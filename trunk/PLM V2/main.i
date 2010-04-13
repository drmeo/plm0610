
#pragma used+
sfrb TWBR=0;
sfrb TWSR=1;
sfrb TWAR=2;
sfrb TWDR=3;
sfrb ADCL=4;
sfrb ADCH=5;
sfrw ADCW=4;      
sfrb ADCSRA=6;
sfrb ADCSR=6;     
sfrb ADMUX=7;
sfrb ACSR=8;
sfrb UBRRL=9;
sfrb UCSRB=0xa;
sfrb UCSRA=0xb;
sfrb UDR=0xc;
sfrb SPCR=0xd;
sfrb SPSR=0xe;
sfrb SPDR=0xf;
sfrb PIND=0x10;
sfrb DDRD=0x11;
sfrb PORTD=0x12;
sfrb PINC=0x13;
sfrb DDRC=0x14;
sfrb PORTC=0x15;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb PINA=0x19;
sfrb DDRA=0x1a;
sfrb PORTA=0x1b;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEARL=0x1e;
sfrb EEARH=0x1f;
sfrw EEAR=0x1e;   
sfrb UBRRH=0x20;
sfrb UCSRC=0X20;
sfrb WDTCR=0x21;
sfrb ASSR=0x22;
sfrb OCR2=0x23;
sfrb TCNT2=0x24;
sfrb TCCR2=0x25;
sfrb ICR1L=0x26;
sfrb ICR1H=0x27;
sfrb OCR1BL=0x28;
sfrb OCR1BH=0x29;
sfrw OCR1B=0x28;  
sfrb OCR1AL=0x2a;
sfrb OCR1AH=0x2b;
sfrw OCR1A=0x2a;  
sfrb TCNT1L=0x2c;
sfrb TCNT1H=0x2d;
sfrw TCNT1=0x2c;  
sfrb TCCR1B=0x2e;
sfrb TCCR1A=0x2f;
sfrb SFIOR=0x30;
sfrb OSCCAL=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0=0x33;
sfrb MCUCSR=0x34;
sfrb MCUCR=0x35;
sfrb TWCR=0x36;
sfrb SPMCR=0x37;
sfrb TIFR=0x38;
sfrb TIMSK=0x39;
sfrb GIFR=0x3a;
sfrb GICR=0x3b;
sfrb OCR0=0X3c;
sfrb SPL=0x3d;
sfrb SPH=0x3e;
sfrb SREG=0x3f;
#pragma used-

#asm
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
#endasm

#pragma used+

#pragma used-

#pragma used+
#pragma used-
#pragma used+

#pragma used-

#pragma used+

char *strcat(char *str1,char *str2);
char *strcatf(char *str1,char flash *str2);
char *strchr(char *str,char c);
signed char strcmp(char *str1,char *str2);
signed char strcmpf(char *str1,char flash *str2);
char *strcpy(char *dest,char *src);
char *strcpyf(char *dest,char flash *src);
unsigned int strlenf(char flash *str);
char *strncat(char *str1,char *str2,unsigned char n);
char *strncatf(char *str1,char flash *str2,unsigned char n);
signed char strncmp(char *str1,char *str2,unsigned char n);
signed char strncmpf(char *str1,char flash *str2,unsigned char n);
char *strncpy(char *dest,char *src,unsigned char n);
char *strncpyf(char *dest,char flash *src,unsigned char n);
char *strpbrk(char *str,char *set);
char *strpbrkf(char *str,char flash *set);
char *strrchr(char *str,char c);
char *strrpbrk(char *str,char *set);
char *strrpbrkf(char *str,char flash *set);
char *strstr(char *str1,char *str2);
char *strstrf(char *str1,char flash *str2);
char *strtok(char *str1,char flash *str2);

unsigned int strlen(char *str);
void *memccpy(void *dest,void *src,char c,unsigned n);
void *memchr(void *buf,unsigned char c,unsigned n);
signed char memcmp(void *buf1,void *buf2,unsigned n);
signed char memcmpf(void *buf1,void flash *buf2,unsigned n);
void *memcpy(void *dest,void *src,unsigned n);
void *memcpyf(void *dest,void flash *src,unsigned n);
void *memmove(void *dest,void *src,unsigned n);
void *memset(void *buf,unsigned char c,unsigned n);
unsigned int strcspn(char *str,char *set);
unsigned int strcspnf(char *str,char flash *set);
int strpos(char *str,char c);
int strrpos(char *str,char c);
unsigned int strspn(char *str,char *set);
unsigned int strspnf(char *str,char flash *set);

#pragma used-
#pragma library string.lib

#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

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

volatile bit bAck; 
volatile unsigned char ucState;
volatile unsigned char ucByteCounter;
volatile unsigned char ucBitCounter;
volatile unsigned char ucCorrectionCounter;
volatile unsigned int  uiLastFCS;

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

void PLM_Task(void){
static bit bLastCLRT;
static unsigned char ucByte,
ucFec;

if(PINB.7){                                                
if(!bLastCLRT){                                                
bLastCLRT = 1;                                            

switch(ucState){
case 0x00:
break;

case 0x02:
ucByte = (ucByte << 1) | PINB.5;            
ucBitCounter--;

if(!ucBitCounter){
ucPacket[ucIndex++] = ucByte;
ucBitCounter = 8;
ucByteCounter--;

if(!ucByteCounter){
ucState = 0x00;                        

PORTC.5 = 1;                        
PORTC.6 = 0;                    

return;
}                                        
}

break;

case 0x09:
ucState++;
break;

case 0x0a:
ucByte = (ucByte << 1) | PINB.5;            

if(ucByte == 0xe9){
bAck = 1;

ucBitCounter = 8;
ucState++;
}

if(ucByte == 0x9b){
bAck = 0;

ucBitCounter = 8;
ucState++;
}

break;

case 0x0b:
ucByte = (ucByte << 1) | PINB.5;            
ucBitCounter--;

if(!ucBitCounter){
if(ucByte == 0x58){
if(bAck){
ucByteCounter = 2;                    
}

ucBitCounter = 8;
ucFec = 0;
ucState++;
}
else{
ucState = 0x09;
}
}
break;

case 0x0c:
ucByte = (ucByte << 1) | PINB.5;            
ucBitCounter--;

ucFec = (ucFec << 1) | PINB.5;
if(ucFec & 0x40){
ucFec ^= 0x39;
}

if(!ucBitCounter){
ucBitCounter = 6;
ucState++;
}

break;

case 0x0d:
ucFec = (ucFec << 1) | ~PINB.5;
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
ucState = 0x00;                        

PORTC.5 = 1;                        
PORTC.6 = 0;                    

return;
}

ucBitCounter = 8;
ucFec = 0;
ucState = 0x0c;
}

break;
}
}
}
else{                                                            
if(bLastCLRT){                                                
bLastCLRT = 0;                                            

switch(ucState){
case 0x00:
break;

case 0x01:
if(!ucBitCounter){
if(ucByteCounter){
ucByte = ucPacket[ucIndex++];
ucBitCounter = 8;
ucByteCounter--;
}
else{
ucState = 0x00;                        

PORTC.5 = 1;                        
PORTC.6 = 0;                    

return;
}
}

PORTB.6 = ucByte & 0x80;                        
ucByte <<= 1;
ucBitCounter--;

break;

case 0x03:
PORTB.6 = --ucBitCounter & 0x01;

if(!ucBitCounter){
if(bAck){
ucByte = 0xe9;
}
else{
ucByte = 0x9b;
}
ucBitCounter = 8;
ucState++;
}
break;

case 0x04:
PORTB.6 = ucByte & 0x80;
ucByte <<= 1;
ucBitCounter--;

if(!ucBitCounter){
ucByte = 0x58;
ucBitCounter = 8;
ucState++;
}
break;

case 0x05:
PORTB.6 = ucByte & 0x80;
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

case 0x06:
PORTB.6 = ucByte & 0x80;
ucByte <<= 1;
ucBitCounter--;

ucFec = (ucFec << 1) | PORTB.6;
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

case 0x07:
PORTB.6 = ucFec & 0x20;
ucFec <<= 1;
ucBitCounter--;

if(!ucBitCounter){
if(!ucByteCounter){
ucFec = PORTB.6 ^ 0x01;
ucBitCounter = ucPostableBits;
ucState++;                                
}
else{
ucByte = ucPacket[ucIndex++];
ucBitCounter = 8;
ucByteCounter--;
ucFec = 0;
ucState = 0x06;
}
}
break;

case 0x08:
PORTB.6 = ucFec;
ucBitCounter--;

if(!ucBitCounter){
ucState = 0x00;

PORTC.5 = 1;                            
PORTC.6 = 0;                        
}
break;
}
}    
}
}

unsigned char PLM_IsRunning(void){
return ucState;
}

void PLM_SetControlRegister(unsigned long ulControlRegister)
{
*(unsigned long*)&ucPacket[0] = ulControlRegister;

ucIndex = 1;
ucBitCounter = 0;
ucByteCounter = 3;

PORTC.6 = 1;
PORTC.5 = 0;

ucState = 0x01;

PIND.3  = 0;
}

unsigned long PLM_GetControlRegister(void){
ucIndex = 1;
ucBitCounter = 8;
ucByteCounter = 3;

PORTC.6 = 1;
PORTC.5 = 1;

ucState = 0x02;
PIND.3  = 1;

while(PLM_IsRunning() != 0);

return (*(unsigned long*)&ucPacket[3]) & 0x00ffffff;
}

unsigned int CalcCRC(unsigned char *pucBuffer, unsigned char ucLength){
unsigned int uiCRC = 0;

while(ucLength--)
uiCRC = tableCRC[((uiCRC >> 8) ^ *pucBuffer++) & 0xff] ^ (uiCRC << 8);

return uiCRC;
}

unsigned char PLM_GetCorrectionNumber(void){
return ucCorrectionCounter;
}

void PLM_Init(void){
PORTC.6 = 0;
PORTC.5 = 1;        
ucState = 0x00;
}

unsigned char PLM_IsAck(void){
return bAck;
}

void PLM_Stop(void){
ucState = 0x00;  

PORTC.6 = 0;
PORTC.5 = 1; 
}

void PLM_TransmitData(unsigned char ucLength, unsigned char ucAck){
bAck = ucAck;

ucIndex = 0;
ucBitCounter = 16;                    
ucByteCounter = ucLength;             

PORTC.6 = 0;
PORTC.5 = 0; 
ucState = 0x03;
}

void PLM_ReceiveData(unsigned char ucLength){
ucIndex = 0;
ucByteCounter = ucLength;
ucCorrectionCounter = 0;

PORTC.6 = 0;
PORTC.5 = 1;

ucState = 0x09;
}

void PLM_GetData(unsigned char *pucBuffer, unsigned char ucLength){
memcpy(pucBuffer, &ucPacket[0], ucLength);
}

void RS232_SetData(unsigned char *pucBuffer, unsigned char ucLength){
int iCounter = 0;
while((ucLength-1)>iCounter){
putchar(*(pucBuffer+iCounter));
iCounter++;
}
}

void RS232_GetData(){
int iCounter = 0;
for(iCounter = 0;iCounter < ucLength; iCounter++){
*(ucPacket+iCounter) = getchar();
}
ucRS232Started = 0;
}

interrupt [3] void ext_int1_isr(void)
{
if(PLM_IsRunning()>0){

PLM_Task();
}else{
PIND.3  = 1;
}
}

interrupt [13] void spi_isr(void)
{

}

void main(void)
{
PIND.3  = 1;

IO_Init();
TimerCounter_Init();
RS232_Init();
ExtInterupt_Init();

PLM_Init();

PLM_SetControlRegister(0x0000321c);
while(PLM_IsRunning() != 0);
PLM_SetControlRegister(0x0000321c);

ucRS232Started = 0;

while (1)
{      
if((RS232_IsRunning()>0)&&(ucRS232Started==0)){
if(getchar()== 0b10101010)
{
delay_ms(200);
ucRS232Started = 1;
ucCommand = getchar();
ucLength = getchar();
delay_ms(10*ucLength);
}
}      
if(ucRS232Started == 1){

RS232_GetData(); 

switch(ucCommand){

case 0x00:
{											 

*((unsigned long*)&ucPacket[0]) = PLM_GetControlRegister();
ByteReverse((unsigned long*)&ucPacket[3]);
*ucPacket = 0b10101010;
*(ucPacket + 1) = ucCommand;
*(ucPacket + 2) = 3;
RS232_SetData(ucPacket, 7);
break;
}

case 0x01:
{											

ByteReverse((unsigned long*)&ucPacket[0]);
PLM_SetControlRegister(*((unsigned long*)&ucPacket[0]));
break;
}
case 0x03:
{

break;
}
case 0x02:
{

break;
} 
}  
}

};
}
