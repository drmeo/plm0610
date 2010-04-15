#include <mega32.h>
#include <plm.h>

void SPI_Init(void){
    // SPI initialization
    // SPI Type: Slave
    // SPI Clock Rate: 2764.800 kHz
    // SPI Clock Phase: Cycle Half
    // SPI Clock Polarity: Low
    // SPI Data Order: MSB First
    SPCR=0xC0;
    SPSR=0x00;

    // Clear the SPI interrupt flag
    #asm
    in   r30,spsr
    in   r30,spdr
    #endasm
     
    
}
//Khoi dong SPI
void Start_SPI(void)
{
    SPCR = SPCR|0x80;
    pin_SS = 0;    
}
void Stop_SPI(void){
    SPCR = 0x40;
    pin_SS = 1;     
}