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
//bang tra cuu CRC
flash unsigned int tableCRC[] =    {
                                        0x0000, 0x8005, 0x800f, 0x000a, 0x801b, 0x001e, 0x0014, 0x8011,
                                        0x8033, 0x0036, 0x003c, 0x8039, 0x0028, 0x802d, 0x8027, 0x0022,
                                        0x8063, 0x0066, 0x006c, 0x8069, 0x0078, 0x807d, 0x8077, 0x0072,
                                        0x0050, 0x8055, 0x805f, 0x005a, 0x804b, 0x004e, 0x0044, 0x8041,
                                        0x80c3, 0x00c6, 0x00cc, 0x80c9, 0x00d8, 0x80dd, 0x80d7, 0x00d2,
                                        0x00f0, 0x80f5, 0x80ff, 0x00fa, 0x80eb, 0x00ee, 0x00e4, 0x80e1,
                                        0x00a0, 0x80a5, 0x80af, 0x00aa, 0x80bb, 0x00be, 0x00b4, 0x80b1,
                                        0x8093, 0x0096, 0x009c, 0x8099, 0x0088, 0x808d, 0x8087, 0x0082,
                                        0x8183, 0x0186, 0x018c, 0x8189, 0x0198, 0x819d, 0x8197, 0x0192,
                                        0x01b0, 0x81b5, 0x81bf, 0x01ba, 0x81ab, 0x01ae, 0x01a4, 0x81a1,
                                        0x01e0, 0x81e5, 0x81ef, 0x01ea, 0x81fb, 0x01fe, 0x01f4, 0x81f1,
                                        0x81d3, 0x01d6, 0x01dc, 0x81d9, 0x01c8, 0x81cd, 0x81c7, 0x01c2,
                                        0x0140, 0x8145, 0x814f, 0x014a, 0x815b, 0x015e, 0x0154, 0x8151,
                                        0x8173, 0x0176, 0x017c, 0x8179, 0x0168, 0x816d, 0x8167, 0x0162,
                                        0x8123, 0x0126, 0x012c, 0x8129, 0x0138, 0x813d, 0x8137, 0x0132,
                                        0x0110, 0x8115, 0x811f, 0x011a, 0x810b, 0x010e, 0x0104, 0x8101,
                                        0x8303, 0x0306, 0x030c, 0x8309, 0x0318, 0x831d, 0x8317, 0x0312,
                                        0x0330, 0x8335, 0x833f, 0x033a, 0x832b, 0x032e, 0x0324, 0x8321,
                                        0x0360, 0x8365, 0x836f, 0x036a, 0x837b, 0x037e, 0x0374, 0x8371,
                                        0x8353, 0x0356, 0x035c, 0x8359, 0x0348, 0x834d, 0x8347, 0x0342,
                                        0x03c0, 0x83c5, 0x83cf, 0x03ca, 0x83db, 0x03de, 0x03d4, 0x83d1,
                                        0x83f3, 0x03f6, 0x03fc, 0x83f9, 0x03e8, 0x83ed, 0x83e7, 0x03e2,
                                        0x83a3, 0x03a6, 0x03ac, 0x83a9, 0x03b8, 0x83bd, 0x83b7, 0x03b2,
                                        0x0390, 0x8395, 0x839f, 0x039a, 0x838b, 0x038e, 0x0384, 0x8381,
                                        0x0280, 0x8285, 0x828f, 0x028a, 0x829b, 0x029e, 0x0294, 0x8291,
                                        0x82b3, 0x02b6, 0x02bc, 0x82b9, 0x02a8, 0x82ad, 0x82a7, 0x02a2,
                                        0x82e3, 0x02e6, 0x02ec, 0x82e9, 0x02f8, 0x82fd, 0x82f7, 0x02f2,
                                        0x02d0, 0x82d5, 0x82df, 0x02da, 0x82cb, 0x02ce, 0x02c4, 0x82c1,
                                        0x8243, 0x0246, 0x024c, 0x8249, 0x0258, 0x825d, 0x8257, 0x0252,
                                        0x0270, 0x8275, 0x827f, 0x027a, 0x826b, 0x026e, 0x0264, 0x8261,
                                        0x0220, 0x8225, 0x822f, 0x022a, 0x823b, 0x023e, 0x0234, 0x8231,
                                        0x8213, 0x0216, 0x021c, 0x8219, 0x0208, 0x820d, 0x8207, 0x0202
                                        };

//cong viec plm thuc hien
void PLM_Task(void){
    static bit bLastCLRT;
    static unsigned char ucByte,
                         ucFec;

    if(PLM_pinCLRT){                                                // PLM clock is 1
        if(!bLastCLRT){                                                // transition 0 -> 1
            bLastCLRT = 1;                                            // update last CLRT value

            switch(ucState){
                case PLM_STOP:
                    break;

                case PLM_RX_REG:
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

                case PLM_RX_PREAMBLE:
                    ucState++;
                    break;

                case PLM_RX_HEADER_HIGH:
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

                case PLM_RX_HEADER_LOW:
                    ucByte = (ucByte << 1) | PLM_pinRxD;            // receive 1 bit and store it
                    ucBitCounter--;

                    if(!ucBitCounter){
                        if(ucByte == HEADER_LOW){
                            if(bAck){
                                ucByteCounter = 2;                    // only FCS
                            }

                            ucBitCounter = 8;
                            ucFec = 0;
                            ucState++;
                        }
                        else{
                            ucState = PLM_RX_PREAMBLE;
                        }
                    }
                    break;
    
                case PLM_RX_DATA:
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

                case PLM_RX_FEC:
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
    else{                                                            // PLM clock is 0
        if(bLastCLRT){                                                // transition 1 -> 0
            bLastCLRT = 0;                                            // update last CLRT value

            switch(ucState){
                case PLM_STOP:
                    break;

                case PLM_TX_REG:
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

                case PLM_TX_PREAMBLE:
                    PLM_pinTxD = --ucBitCounter & 0x01;

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

                case PLM_TX_HEADER_HIGH:
                    PLM_pinTxD = ucByte & 0x80;
                    ucByte <<= 1;
                    ucBitCounter--;

                    if(!ucBitCounter){
                        ucByte = HEADER_LOW;
                        ucBitCounter = 8;
                        ucState++;
                    }
                    break;

                case PLM_TX_HEADER_LOW:
                    PLM_pinTxD = ucByte & 0x80;
                    ucByte <<= 1;
                    ucBitCounter--;

                    if(!ucBitCounter){
                        ucByte = ucPacket[ucIndex++];
                        ucBitCounter = 8;
                        ucByteCounter--;
                        ucFec = 0;
                        ucState++;
                    }

                    break;

                case PLM_TX_DATA:
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

                case PLM_TX_FEC:
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

                case PLM_TX_POSTAMBLE:
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

    PLM_pinREG_DATA = 1;
    PLM_pinRXTX = 0;
    
    ucState = PLM_TX_REG;

    pin_TASK = 0;
}

//+++lay cac thong so thiet lap cau hinh
unsigned long PLM_GetControlRegister(void){
    ucIndex = 1;
    ucBitCounter = 8;
    ucByteCounter = 3;
                                        
    PLM_pinREG_DATA = 1;
    PLM_pinRXTX = 1;
    
    ucState = PLM_RX_REG;
    pin_TASK = 1;
    
    while(PLM_IsRunning() != 0);
    
    // return only 24 bits
    return (*(unsigned long*)&ucPacket[3]) & 0x00ffffff;
}

//+++tinh toan va sua loi
unsigned int CalcCRC(unsigned char *pucBuffer, unsigned char ucLength){
    unsigned int uiCRC = 0;

    while(ucLength--)
        uiCRC = tableCRC[((uiCRC >> 8) ^ *pucBuffer++) & 0xff] ^ (uiCRC << 8);

    return uiCRC;
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
void PLM_Stop(void){
    ucState = PLM_STOP;  
    
    PLM_pinREG_DATA = 0;
    PLM_pinRXTX = 1; 
}

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

interrupt [EXT_INT1] void ext_int1_isr(void)
{
    if(PLM_IsRunning()>0){
        //ucState = 0;
        PLM_Task();
    }else{
        pin_TASK = 1;
    }
}

// Trien khai spi
interrupt [SPI_STC] void spi_isr(void)
{

}

// Declare your global variables here



// dao vi tri byte


void main(void)
{
    pin_TASK = 1;
    // Khai bao bien

    // Khoi tao cac gia tri
    IO_Init();
    TimerCounter_Init();
    RS232_Init();
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
            /*
            for(i=0;i<ucLength;i++){
                delay_ms(10);
                putchar(ucPacket[i]);
            }
            */
            // kiem tra gia tri dau tien cua ucPacket
            switch(ucCommand){
                // doc thanh ghi st7538/7540
                case COM_GET_CTR:
                {											 
                    // get control register (comm)
			        *((unsigned long*)&ucPacket[0]) = PLM_GetControlRegister();
					ByteReverse((unsigned long*)&ucPacket[3]);
                    *ucPacket = TX_START;// them header
                    *(ucPacket + 1) = ucCommand;// them code
                    *(ucPacket + 2) = 3;// them do dai
					RS232_SetData(ucPacket, 7);
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
//					PLM_Stop();

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
