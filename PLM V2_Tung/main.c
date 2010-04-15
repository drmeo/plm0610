/*****************************************************
This program was produced by the
CodeWizardAVR V2.03.4 Standard
Automatic Program Generator
© Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : PLM_Modem
Version : 1.0.0.0
Date    : 3/21/2010
Author  : Nguyen Ngoc Son
Company : 
Comments: 


Chip type           : ATmega32
Program type        : Application
Clock frequency     : 11.059200 MHz
Memory model        : Small
External RAM size   : 0
Data Stack size     : 512
*****************************************************/

#include <mega32.h>
#include <plm.h>
#include <command.h>
#include <rs232.h>
#include <string.h>
#include <delay.h>

extern void IO_Init(void);
extern void TimerCounter_Init(void);
extern void ExtInterupt_Init(void);
extern void SPI_Init(void);
extern void RS232_Init(void);
extern void putchar(char c);
extern char getchar(void);
extern unsigned char RS232_IsRunning(void);
extern void ByteReverse(unsigned long* pul);
extern void SPI_Init(void);
extern void Start_SPI(void);
extern void Stop_SPI(void);
extern unsigned int CalcCRC(unsigned char *pucBuffer, unsigned char ucLength);

volatile unsigned char ucPacket[270];
volatile unsigned char ucIndex;
volatile unsigned char ucLength;
volatile unsigned char ucRS232Started;
volatile unsigned char ucCommand;
volatile unsigned char ucPostableBits;

/*------------PLM----------------*/

volatile bit bAck; 
volatile unsigned char ucState;
volatile unsigned char ucByteCounter;
volatile unsigned char ucBitCounter;
volatile unsigned char ucCorrectionCounter;
volatile unsigned int  uiLastFCS;
//bang tra cuu FEC
flash unsigned char ucCRC[] =    {
                                    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                                    0x00, 0x01, 0x00, 0x02, 0x00, 0x18, 0x00, 0x40,
                                    0x00, 0xc0, 0x03, 0x00, 0x00, 0x70, 0x04, 0x28,
                                    0x00, 0x01, 0x30, 0x1c, 0x00, 0x06, 0x80, 0x80,
                                    0x00, 0x10, 0x80, 0x80, 0x07, 0xa0, 0x00, 0x0a,
                                    0x00, 0x01, 0xe0, 0x02, 0x08, 0xc0, 0x50, 0x05,
                                    0x00, 0x0e, 0x03, 0x40, 0x60, 0x00, 0x38, 0x14,
                                    0x00, 0x01, 0x0c, 0x20, 0x00, 0x00, 0x00, 0x00
                                    };


void PLM_Stop(void){
    ucState = PLM_STOP;  
    
    PLM_pinREG_DATA = 0;
    PLM_pinRXTX = 1; 
}

//cong viec plm thuc hien
void PLM_Task(void){
    static unsigned char ucByte,
                         ucFec;
    switch(ucState){
        case PLM_STOP:
        {
            PLM_Stop();
            break;
        }
        case PLM_RX_REG:
        {
            ucPacket[ucIndex++] = SPDR;
            ucByteCounter--;

            if(!ucByteCounter){
                ucState = PLM_STOP;                        // stop PLM                                
                PLM_pinRXTX = 1;                        // Rx session
                PLM_pinREG_DATA = 0;                    // mains access

                return;
            }                                        

            break;
        }
        case PLM_TX_REG:
        {
           
            if(ucByteCounter){
                SPDR = ucPacket[ucIndex++];
                ucByteCounter--;
            }
            else{
                ucState = PLM_STOP;                        // stop PLM
          
                PLM_pinRXTX = 1;                        // Rx session
                PLM_pinREG_DATA = 0;                    // mains access

                return;
            }

            break;
        }
    }
}

//kiem tra xem co dang chay hay khong
unsigned char PLM_IsRunning(void){
    return ucState;
}

//+++cau hinh cho thanh ghi
void PLM_SetControlRegister(unsigned long ulControlRegister)
{
    *(unsigned long*)&ucPacket[0] = ulControlRegister;
    
    ucIndex = 1;
    ucBitCounter = 0;
    ucByteCounter = 3;
    ucState = PLM_TX_REG;
    SPDR = ucPacket[0];
    PLM_pinREG_DATA = 1;
    PLM_pinRXTX = 0;
   
    Start_SPI();
}

//+++lay cac thong so thiet lap cau hinh
unsigned long PLM_GetControlRegister(void){
    ucIndex = 4;
    ucBitCounter = 8;
    ucByteCounter = 3;
                                        
    PLM_pinREG_DATA = 1;
    PLM_pinRXTX = 1;
    
    ucState = PLM_RX_REG;
    Start_SPI();
    
    while(PLM_IsRunning() != 0);
    
    // return only 24 bits
    return (*(unsigned long*)&ucPacket[3]) & 0xffffff00;
}



//+++
unsigned char PLM_GetCorrectionNumber(void){
    return ucCorrectionCounter;
}

//khoi tao cho plm
void PLM_Init(void){
    PLM_pinREG_DATA = 0;
    PLM_pinRXTX = 1;        
    ucState = PLM_STOP;
}

//co phan hoi hay khong
unsigned char PLM_IsAck(void){
    return bAck;
}

//set cac pin de dua ve che do idle


//chuyen sang che do truyen du lieu
void PLM_TransmitData(unsigned char ucLength, unsigned char ucAck){
    bAck = ucAck;

    ucIndex = 0;
    ucBitCounter = 16;                    // 16 bits preamble length
    ucByteCounter = ucLength;             // do dai byte
    
                                   // mains access
    PLM_pinREG_DATA = 0;
    PLM_pinRXTX = 0; 
    ucState = PLM_TX_PREAMBLE;
}

//+++chuyen sang che do nhan du lieu
void PLM_ReceiveData(unsigned char ucLength){
    ucIndex = 0;
    ucByteCounter = ucLength;
    ucCorrectionCounter = 0;
    
    PLM_pinREG_DATA = 0;
    PLM_pinRXTX = 1;
     
    ucState = PLM_RX_PREAMBLE;
}
//---lay du lieu phuc vu nhan
void PLM_GetData(unsigned char *pucBuffer, unsigned char ucLength){
    memcpy(pucBuffer, &ucPacket[0], ucLength);
}

//+++gan du lieu de chuan bi gui qua rs232
void RS232_SetData(unsigned char *pucBuffer, unsigned char ucLength){
    int iCounter = 0;
    while((ucLength-1)>iCounter){
        putchar(*(pucBuffer+iCounter));
        iCounter++;
    }
}

//+++lay du lieu tu pc gui xuong qua rs232
void RS232_GetData(){
    int iCounter = 0;
    for(iCounter = 0;iCounter < ucLength; iCounter++){
        *(ucPacket+iCounter) = getchar();
    }
    ucRS232Started = 0;
}
    
/*-----------RS233---------------*/

// External Interrupt 0 service routine

//interrupt [EXT_INT1] void ext_int1_isr(void)
//{
//    if(PLM_IsRunning()>0){
        //ucState = 0;
//        PLM_Task();
//    }else{
        //pin_TASK = 1;
//    }
//}

// Trien khai spi
interrupt [SPI_STC] void spi_isr(void)
{
    if(PLM_IsRunning()>0){
        PLM_Task();
    }else{
        Stop_SPI();
    }
}

// Declare your global variables here



// dao vi tri byte


void main(void)
{
    int i;
    
    // Khai bao bien

    // Khoi tao cac gia tri
    IO_Init();
    TimerCounter_Init();
    RS232_Init();
    //pin_TASK = 1;
    //ExtInterupt_Init();
    SPI_Init();
    PLM_Init();
    // ket thuc khoi tao
       pin_SS = 1; 
    // khoi tao cho thanh ghi ST
    
    
    PLM_SetControlRegister(DEFAULT_CONTROL_REG);// dummy write}
    //while(PLM_IsRunning() != 0);
    //PLM_SetControlRegister(DEFAULT_CONTROL_REG);// dummy write
    // ket thuc khoi tao cho thanh ghi
    
    ucRS232Started = 0;
     
    // Global enable interrupts
    #asm("sei")
    
    // Dua ve hoat dong la slave
    
    // Chuong trinh chinh 
    while (1)
    {   
        // doc va kiem tra khung du lieu tu    
        if((RS232_IsRunning()>0)&&(ucRS232Started==0)){
            if(getchar()== RX_START)
            {
                delay_ms(200);
                ucRS232Started = 1;
                ucCommand = getchar();
                ucLength = getchar();
                delay_ms(10*ucLength);
            }
        }      
        if(ucRS232Started == 1){
            // doc gia tri tu rs232
            RS232_GetData(); 
            // kiem tra gia tri dau tien cua ucPacket
            switch(ucCommand){
                // doc thanh ghi st7538/7540
                case COM_GET_CTR:
                {											 
                    // get control register (comm)
			        *((unsigned long*)&ucPacket[3]) = PLM_GetControlRegister();
					ByteReverse((unsigned long*)&ucPacket[3]);
                    *ucPacket = TX_START;// them header
                    *(ucPacket + 1) = ucCommand;// them code
                    *(ucPacket + 2) = 3;// them do dai
					//RS232_SetData(ucPacket, 7);
                    for(i=0;i<7;i++){
                        delay_ms(10);
                        putchar(ucPacket[i]);
                    }
					break;
			    }
		
                // ghi thanh ghi st7538/7540
		        case COM_SET_CTR:
                {											
                    // set control register (comm, byte0, byte1, byte2, byte3)
					ByteReverse((unsigned long*)&ucPacket[0]);
					PLM_SetControlRegister(*((unsigned long*)&ucPacket[0]));
					break;
			    }
                case COM_SET_PLM:
                {
					PLM_Stop();

//					uiLastFCS = CalcCRC(&ucPacket[0], 72);
//					*(unsigned int*)&ucPacket[72] = uiLastFCS;
//                    
//                    ucPostableBits = 8-((78 * 14) % 8);
//                    
                    // truyen khong co ack
//					PLM_TransmitData(74, 0);
//                    while(PLM_pinCD_PD == 1);
//                    pin_TASK = 1;
//					while(PLM_IsRunning() != 0);
//                    PLM_ReceiveData(74);
					break;
			    }
                case COM_GET_PLM:
                {
//                    PLM_ReceiveData(74);
					break;
			    } 
            }  
        }
//        while(RS232_IsRunning()!=0);
//        
//        delay_ms(100);

//		if(PLM_IsRunning() != 0){
//            if(PLM_pinCD_PD == 0){
//                pin_TASK = 1;
//            }
//        }

//        if(PLM_IsRunning()==0){
//            if(!PLM_IsAck()){
//                if(*(unsigned int*)&ucPacket[72] == CalcCRC(ucPacket, 72)){
//                    RS232_SetData(ucPacket, 72);    
//                }
//            }
//        }
    };
}
