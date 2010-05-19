#include <mega32.h>
void InitSPI_ST(void){
    UART_SPI = 0;
    SS_SPI = 0;    
}

//Khoi dong SPI
void Start_SPI(void)
{
    SPCR = SPCR|0x80;    
}
void Stop_SPI(void){
    SPCR = 0x40;    
}