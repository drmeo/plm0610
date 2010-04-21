
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

void PLM_Stop(void){
ucState = 0x00;  

PORTC.6 = 0;
PORTC.5 = 1; 
}
void Reset_WD(void)
{   PORTA.3 = 1;
delay_ms(1);
PORTA.3= 0;
delay_ms(1);

}

void PLM_Task(void){
static unsigned char ucByte,
ucFec;
switch(ucState){
case 0x00:

PLM_Stop();
Reset_WD();
break;

case 0x02:

ucPacket[ucIndex++] = SPDR;
ucByteCounter--;

if(!ucByteCounter){
ucState = 0x00;                        
PORTC.5 = 1;                        
PORTC.6 = 0;                    

return;
}                                        

break;

case 0x01:

if(ucByteCounter){
SPDR = ucPacket[ucIndex++];
ucByteCounter--;
}
else{
ucState = 0x00;                        

PORTC.5 = 1;                        
PORTC.6 = 0;                    

return;
}

break;

case 0x09:
ucState++;
break;

case 0x0a:

ucByte = SPDR;

if(ucByte == 0xe9){
bAck = 1;

ucState++;
}

if(ucByte == 0x9b){
bAck = 0;

ucState++;
}

break;

case 0x0b:

ucByte = SPDR;

if(ucByte == 0x58){
if(bAck){
ucByteCounter = 2;                    
}

ucFec = 0;
ucState++;
}
else{
ucState = 0x09;
}

break;

case 0x0c:

ucByte = SPDR;
ucFec = SPDR;
if(ucFec & 0x40){
ucFec ^= 0x39;
}

ucState++;

break;

case 0x0d:

ucFec = ~SPDR;

if(ucFec & 0x40){
ucFec ^= 0x39;
}

ucFec &= 0x3f;
if(ucFec)
{
ucByte ^= ucCRC[ucFec];
ucCorrectionCounter++;
}

ucPacket[ucIndex++] = ucByte;
ucByteCounter--;

if(!ucByteCounter)
{
ucState = 0x00;                        

PORTC.5 = 1;                        
PORTC.6 = 0;                    

return;
}

ucFec = 0;
ucState = 0x0c;

break;

case 0x03:

SPDR = 0x55;

if(bAck){
ucByte = 0xe9;
}
else{
ucByte = 0x9b;
}

ucState++;

break;

case 0x04:
{
if(ucByte & 0x80){
PORTB.6 = 1;
}else{
PORTB.6 = 0;
}
ucByte <<= 1;
ucBitCounter--;

if(!ucBitCounter){
ucByte = 0x58;
ucBitCounter = 8;
ucState++;
}
break;
}
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

unsigned char PLM_IsRunning(void){
return ucState;
}

void PLM_SetControlRegister(unsigned long ulControlRegister)
{
*(unsigned long*)&ucPacket[0] = ulControlRegister;

ucIndex = 1;
ucBitCounter = 0;
ucByteCounter = 3;
ucState = 0x01;
SPDR = ucPacket[0];
PORTC.6 = 1;
PORTC.5 = 0;

Start_SPI();
}

unsigned long PLM_GetControlRegister(void){
ucIndex = 4;
ucBitCounter = 8;
ucByteCounter = 3;

PORTC.6 = 1;
PORTC.5 = 1;

ucState = 0x02;
Start_SPI();

while(PLM_IsRunning() != 0);

return (*(unsigned long*)&ucPacket[3]) & 0xffffff00;
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

interrupt [13] void spi_isr(void)
{
if(PLM_IsRunning()>0){
PLM_Task();
}else{
Stop_SPI();
}
}

void main(void)
{
int i;

IO_Init();
TimerCounter_Init();
RS232_Init();

SPI_Init();
PLM_Init();

PORTD.7 = 1; 

PLM_SetControlRegister(0x1c321800	);
while(PLM_IsRunning() != 0);

ucRS232Started = 0;

#asm("sei")

while (1)
{   Reset_WD();

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

*((unsigned long*)&ucPacket[3]) = PLM_GetControlRegister();
ByteReverse((unsigned long*)&ucPacket[3]);
*ucPacket = 0b10101010;
*(ucPacket + 1) = ucCommand;
*(ucPacket + 2) = 3;

for(i=0;i<7;i++){
delay_ms(10);
putchar(ucPacket[i]);
}
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
PLM_Stop();

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
