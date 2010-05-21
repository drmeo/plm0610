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
extern void RS232_Init(void);
extern void putchar(char c);
extern char getchar(void);
extern unsigned char RS232_IsRunning(void);
extern void ByteReverse(unsigned long* pul);
//extern unsigned int CalcCRC(unsigned char *pucBuffer, unsigned char ucLength);

volatile unsigned char ucPacket[270];
volatile unsigned char ucIndex;
volatile unsigned char ucLength;
volatile unsigned char ucRS232Started;
volatile unsigned char ucCommand;
volatile unsigned char ucPostableBits;

/*------------PLM----------------*/

volatile bit bAck;
volatile int iMaxLength = 36;
// chuyen tu ham plm_ack ra, ban dau la kieu static

volatile unsigned char ucState;
volatile unsigned char ucByteCounter;
volatile unsigned char ucBitCounter;
volatile unsigned char ucCorrectionCounter;
//volatile unsigned int  uiLastFCS;
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

//cong viec plm thuc hien
void PLM_Task(void){
    static unsigned char ucByte,
                         ucFec;
    static bit bLastCLRT; 
    //PLM_pinWD = ~PLM_pinWD;
    if(PLM_pinCLRT){                                                // PLM clock is 1
        if(!bLastCLRT){                                                // transition 0 -> 1
            bLastCLRT = 1;                                            // update last CLRT value

            switch(ucState){
                case PLM_STOP:
                    break;

                // trang thai doc thanh ghi
                case PLM_RX_REG:{
                    ucByte = (ucByte << 1) | PLM_pinRxD;            // receive 1 bit and store it
                    ucBitCounter--;

                    if(!ucBitCounter){
                        ucPacket[ucIndex++] = ucByte;
                        ucBitCounter = 8;
                        ucByteCounter--;

                        if(!ucByteCounter){
                            ucState = PLM_STOP;                        // stop PLM            
                            
                            PLM_pinRXTX = 1;                        // Rx session
                            PLM_pinREG_DATA = 0;                    // mains access

                            return;
                        }                                        
                    }

                    break;
                }    

                // trang thai doi preamable
                case PLM_RX_PREAMBLE:{
                    ucState++;
                    break;
                }
                
                // trang thai doc header high (kiem tra xem la data hay ack)
                case PLM_RX_HEADER_HIGH:{
                    ucByte = (ucByte << 1) | PLM_pinRxD;            // receive 1 bit and store it

                    if(ucByte == HEADER_HIGH_ACK){
                        bAck = 1;

                        ucBitCounter = 8;
                        ucState++;
                    }

                    if(ucByte == HEADER_HIGH_DATA){
                        bAck = 0;

                        ucBitCounter = 8;
                        ucState++;
                    }

                    break;
                }
                
                // trang thai doc header low
                case PLM_RX_HEADER_LOW:{
                    ucByte = (ucByte << 1) | PLM_pinRxD;            // receive 1 bit and store it
                    ucBitCounter--;

                    if(!ucBitCounter){
                        if(ucByte == HEADER_LOW){
                            if(bAck){
                                ucByteCounter = 3;                    // only FCS
                            }

                            ucBitCounter = 8;
                            //ucFec = 0;
                            ucState = PLM_RX_LENGTH;
                            //ucState++;
                        }
                        else{
                            ucState = PLM_RX_PREAMBLE;
                        }
                    }
                    break;
                }
    
                // trang thai doc do dai cua khung
                case PLM_RX_LENGTH:{
                    ucByte = (ucByte << 1) | PLM_pinRxD;            // receive 1 bit and store it
                    ucBitCounter--;

                    if(!ucBitCounter){
                        ucLength = ucByte;
                        ucByteCounter = ucByte;
                        ucBitCounter = 8;
                        ucState = PLM_RX_DATA;
                        ucFec = 0;
                        //ucState++;
                    }
                    break;
                }
                
                // trang thai doc data
                case PLM_RX_DATA:{
                    ucByte = (ucByte << 1) | PLM_pinRxD;            // receive 1 bit and store it
                    ucBitCounter--;

                    ucFec = (ucFec << 1) | PLM_pinRxD;
                    if(ucFec & 0x40){
                        ucFec ^= 0x39;
                    }

                    if(!ucBitCounter){
                        ucBitCounter = 6;
                        ucState++;
                    }

                    break;
                }

                // trang thai sua loi
                case PLM_RX_FEC:{
                    ucFec = (ucFec << 1) | ~PLM_pinRxD;
                    ucBitCounter--;

                    if(ucFec & 0x40){
                        ucFec ^= 0x39;
                    }

                    if(!ucBitCounter){
                        ucFec &= 0x3f;
                        if(ucFec){
                            ucByte ^= ucCRC[ucFec];
                            ucCorrectionCounter++;
                        }

                        ucPacket[ucIndex++] = ucByte;
                        ucByteCounter--;

                        if(!ucByteCounter){
                            ucState = PLM_STOP;                        // stop PLM            
      
                            PLM_pinRXTX = 1;                        // Rx session
                            PLM_pinREG_DATA = 0;                    // mains access

                            return;
                        }

                        ucBitCounter = 8;
                        ucFec = 0;
                        ucState = PLM_RX_DATA;
                    }

                    break;
                }
            }
        }
    }
    else{                                                            // PLM clock is 0
        if(bLastCLRT){                                                // transition 1 -> 0
            bLastCLRT = 0;                                            // update last CLRT value

            switch(ucState){
                case PLM_STOP:
                    break;

                // trang thai ghi thanh ghi
                case PLM_TX_REG:{
                    if(!ucBitCounter){
                        if(ucByteCounter){
                            ucByte = ucPacket[ucIndex++];
                            ucBitCounter = 8;
                            ucByteCounter--;
                        }
                        else{
                            ucState = PLM_STOP;                        // stop PLM
  
                            PLM_pinRXTX = 1;                        // Rx session
                            PLM_pinREG_DATA = 0;                    // mains access

                            return;
                        }
                    }
                    PLM_pinTxD = ucByte & 0x80;                        // transmit 1 bit
                    ucByte <<= 1;
                    ucBitCounter--;

                    break;
                }
                
                // trang thai truyen preamable
                case PLM_TX_PREAMBLE:{
                    PLM_pinTxD = --ucBitCounter & 0x01 ;

                    if(!ucBitCounter){
                        if(bAck){
                            ucByte = HEADER_HIGH_ACK;
                        }
                        else{
                            ucByte = HEADER_HIGH_DATA;
                        }
                        ucBitCounter = 8;
                        
                        ucState++;
                    }
                    break;
                }
                
                // trang thai truyen header high bao xem co phai la ack khong
                case PLM_TX_HEADER_HIGH:{
                    PLM_pinTxD = ucByte & 0x80;
                    ucByte <<= 1;
                    ucBitCounter--;

                    if(!ucBitCounter){
                        ucByte = HEADER_LOW;
                        ucBitCounter = 8;
                        ucState++;
                    }
                    break;
                }
                
                // trang thai truyen header low
                case PLM_TX_HEADER_LOW:{
                    PLM_pinTxD = ucByte & 0x80;
                    ucByte <<= 1;
                    ucBitCounter--;

                    if(!ucBitCounter){
                        ucByte = ucLength;
                        //ucByte = ucPacket[ucIndex++];
                        ucBitCounter = 8;
                        ucState = PLM_TX_LENGTH;
                        //ucByteCounter--;
                        //ucFec = 0;
                        //ucState++;
                    }

                    break;
                }
                
                // trang thai truyen do dai
                case PLM_TX_LENGTH:{
                    PLM_pinTxD = ucByte & 0x80;
                    ucByte <<= 1;
                    ucBitCounter--;

                    if(!ucBitCounter){
                        //ucByte = ucLength;
                        ucByte = ucPacket[ucIndex++];
                        ucBitCounter = 8;
                        ucByteCounter--;
                        ucFec = 0;
                        ucState = PLM_TX_DATA;
                        //ucState++;
                    }
                    
                    break;
                }
                
                // trang thai truyen data
                case PLM_TX_DATA:{
                    PLM_pinTxD = ucByte & 0x80;
                    ucByte <<= 1;
                    ucBitCounter--;

                    ucFec = (ucFec << 1) | PLM_pinTxD;
                    if(ucFec & 0x40){
                        ucFec ^= 0x39;
                    }

                    if(!ucBitCounter){
                        ucBitCounter = 6;
                        while(ucBitCounter){
                            ucFec <<= 1;
                            if(ucFec & 0x40){
                                ucFec ^= 0x39;
                            }
                            ucBitCounter--;
                        }
                        ucFec ^= 0xff;

                        ucBitCounter = 6;
                        ucState++;
                    }
                    break;
                }

                // trang thai ghep byte sua loi
                case PLM_TX_FEC:{
                    PLM_pinTxD = ucFec & 0x20;
                    ucFec <<= 1;
                    ucBitCounter--;

                    if(!ucBitCounter){
                        if(!ucByteCounter){
                            ucFec = PLM_pinTxD ^ 0x01;
                            ucBitCounter = ucPostableBits;
                            ucState++;                                // postamble
                        }
                        else{
                            ucByte = ucPacket[ucIndex++];
                            ucBitCounter = 8;
                            ucByteCounter--;
                            ucFec = 0;
                            ucState = PLM_TX_DATA;
                        }
                    }
                    break;
                }

                // truyen cac bit bo sung
                case PLM_TX_POSTAMBLE:{
                    PLM_pinTxD = ucFec;
                    ucBitCounter--;

                    if(!ucBitCounter){
                        ucState = PLM_STOP;

                        PLM_pinRXTX = 1;                            // Rx session
                        PLM_pinREG_DATA = 0;                        // mains access
                    }
                    break;
                }
            }
        }   
    }
}

//kiem tra xem co dang chay hay khong
unsigned char PLM_IsRunning(void){
    return ucState;
}

unsigned char PLM_GetCorrectionBytes(void){
    return ucCorrectionCounter;
}

//+++cau hinh cho thanh ghi
void PLM_SetControlRegister(unsigned long ulControlRegister)
{
    *(unsigned long*)&ucPacket[0] = ulControlRegister;
    
    ucIndex = 1;
    ucBitCounter = 0;
    ucByteCounter = 3;

    PLM_pinREG_DATA = 1;
    PLM_pinRXTX = 0;
    
    ucState = PLM_TX_REG;
    pin_TASK = 0;
}

//+++lay cac thong so thiet lap cau hinh
unsigned long PLM_GetControlRegister(void){
    ucIndex = 4;
    ucBitCounter = 8;
    ucByteCounter = 3;
                                        
    PLM_pinREG_DATA = 1;
    PLM_pinRXTX = 1;
    
    ucState = PLM_RX_REG;
    pin_TASK = 0;
    
    while(PLM_IsRunning() != 0);
    
    // return only 24 bits
    return (*(unsigned long*)&ucPacket[3]) & 0xffffff00;
}

//khoi tao cho plm
void PLM_Init(void){
    PLM_pinREG_DATA = 0;
    PLM_pinRXTX = 1;        
    ucState = PLM_STOP;
}

//set cac pin de dua ve che do idle
void PLM_Stop(void){
    ucState = PLM_STOP;  
    
    PLM_pinREG_DATA = 0;
    PLM_pinRXTX = 1; 
}

//chuyen sang che do truyen du lieu
void PLM_TransmitData(unsigned char length, unsigned char ucAck){
    bAck = ucAck;

    ucIndex = 0;
    ucBitCounter = 16;                    // 16 bits preamble length
    ucByteCounter = length;             // do dai byte
                                    // mains access
    PLM_pinREG_DATA = 0;
    PLM_pinRXTX = 0; 
    
    ucState = PLM_TX_PREAMBLE; 
    pin_TASK = 0;
}

//+++chuyen sang che do nhan du lieu
void PLM_ReceiveData(){
    ucIndex = 3;
    ucByteCounter = iMaxLength;
    ucCorrectionCounter = 0;
    
    PLM_pinREG_DATA = 0;
    PLM_pinRXTX = 1;
       
    ucState = PLM_RX_PREAMBLE;
    pin_TASK = 0;
}

//+++gan du lieu de chuan bi gui qua rs232
void RS232_SetData(unsigned char *pucBuffer, unsigned char ucLength){
    int i;
    for(i=0;i<ucLength;i++){
        delay_ms(2);
        putchar(*(pucBuffer+i));
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

interrupt [EXT_INT1] void ext_int1_isr(void)
{
    if(PLM_IsRunning()>0){
        PLM_Task();
    }else{
        pin_TASK = 1;
    }
}


void main(void)
{    
    // Khai bao bien
    
    // Khoi tao cac gia tri
    IO_Init();
    TimerCounter_Init();
    RS232_Init();
    pin_TASK = 1;
    ExtInterupt_Init();
    
    PLM_Init();
    // ket thuc khoi tao
    
    // khoi tao cho thanh ghi ST
    PLM_SetControlRegister(DEFAULT_CONTROL_REG);// dummy write
    while(PLM_IsRunning() != 0);
    PLM_SetControlRegister(DEFAULT_CONTROL_REG);// dummy write
    // ket thuc khoi tao cho thanh ghi
    ucRS232Started = 0;
    // Chuong trinh chinh  
    while (1)
    {      
        if((RS232_IsRunning()>0)&&(ucRS232Started==0)){
            if(getchar()== RX_START)
            {
                delay_ms(50);
                ucRS232Started = 1;
                ucCommand = getchar();
                ucLength = getchar();
                delay_ms(2*ucLength);
                PLM_pinWD = ~PLM_pinWD;
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
                    *(ucPacket + 2) = 4;// them do dai
					RS232_SetData(ucPacket, 7);
                    PLM_pinWD = ~PLM_pinWD;
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
                
                // ghi gia tri do dai mot frame
                case COM_SET_MAXLENGTH:
                {   
                    iMaxLength = ucPacket[0];
                    break;
                }
                
                // doc gia tri do dai mot frame                
                case COM_GET_MAXLENGTH:
                {
                    *ucPacket = TX_START;// them header
                    *(ucPacket + 1) = ucCommand;// them code
                    *(ucPacket + 2) = 1;// them do dai
                    *(ucPacket + 3) = iMaxLength;
					RS232_SetData(ucPacket, 4);
                    break;
                }
                
                // truyen 
                case COM_SET_PLM:
                {
					PLM_Stop();                                      
                    ucPostableBits = 8 -((ucLength * 14) % 8);
                    PLM_TransmitData(ucLength, 0); 
					break;
			    }
                
                // nhan
                case COM_GET_PLM:
                {
                    PLM_ReceiveData();
					break;
			    } 
            }  
        }
        
        
        if(PLM_pinCD_PD == 0)
        {
            if(PLM_pinBU == 1){
                PLM_ReceiveData();
                delay_ms(16);
                *ucPacket = TX_START;// them header
                *(ucPacket + 1) = COM_GET_PLM;// them code
                *(ucPacket + 2) = ucLength;// them do dai
//                *(ucPacket + ( 3 + ucLength )) = PLM_GetCorrectionBytes(); 
//                RS232_SetData(ucPacket, ucLength + 4);
                RS232_SetData(ucPacket, ucLength + 3);
    	    } 
        }
		     
    	PLM_pinWD = ~PLM_pinWD;
    };
}
