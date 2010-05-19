#include <mega32.h>
#include <plm.h>
//kiem tra xem co dang chay hay khong
//unsigned char PLM_IsRunning(void){
//    return ucState;
//}

//+++cau hinh cho thanh ghi
//void PLM_SetControlRegister(unsigned long ulControlRegister)
//{
//    *(unsigned long*)&ucPacket[0] = ulControlRegister;
//    
//    ucIndex = 1;
//    ucBitCounter = 0;
//    ucByteCounter = 3;

//    PLM_pinREG_DATA = 1;
//    PLM_pinRXTX = 0;
//    
//    ucState = PLM_TX_REG;
//    pin_TASK = 0;
//}

//+++lay cac thong so thiet lap cau hinh
//unsigned long PLM_GetControlRegister(void){
//    ucIndex = 4;
//    ucBitCounter = 8;
//    ucByteCounter = 3;
//                                        
//    PLM_pinREG_DATA = 1;
//    PLM_pinRXTX = 1;
//    
//    ucState = PLM_RX_REG;
//    pin_TASK = 0;
//    
//    while(PLM_IsRunning() != 0);
//    
    // return only 24 bits
//    return (*(unsigned long*)&ucPacket[3]) & 0xffffff00;
//}

//khoi tao cho plm
//void PLM_Init(void){
//    PLM_pinREG_DATA = 0;
//    PLM_pinRXTX = 1;        
//    ucState = PLM_STOP;
//}

//set cac pin de dua ve che do idle
//void PLM_Stop(void){
//    ucState = PLM_STOP;  
//    
//    PLM_pinREG_DATA = 0;
//    PLM_pinRXTX = 1; 
//}

//chuyen sang che do truyen du lieu
//void PLM_TransmitData(unsigned char length, unsigned char ucAck){
//    bAck = ucAck;

//    ucIndex = 0;
//    ucBitCounter = 16;                    // 16 bits preamble length
//    ucByteCounter = length;             // do dai byte
                                    // mains access
//    PLM_pinREG_DATA = 0;
//    PLM_pinRXTX = 0; 
//    
//    ucState = PLM_TX_PREAMBLE; 
//    pin_TASK = 0;
//}

//+++chuyen sang che do nhan du lieu
//void PLM_ReceiveData(){
//    ucIndex = 3;
//    ucByteCounter = iMaxLength;
//    ucCorrectionCounter = 0;
//    
//    PLM_pinREG_DATA = 0;
//    PLM_pinRXTX = 1;
//       
//    ucState = PLM_RX_PREAMBLE;
//    pin_TASK = 0;
//}