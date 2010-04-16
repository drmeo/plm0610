#include <mega32.h>
#include <stdio.h>
void IO_Init(void)
{
    // Port A initialization
    // Func7=Out Func6=Out Func5=In Func4=Out Func3=Out Func2=In Func1=In Func0=In 
    // State7=0 State6=0 State5=T State4=0 State3=0 State2=T State1=T State0=T 
    PORTA=0x00;
    DDRA=0xD8;

    // Cau hinh cho su dung ngat
    // Port B initialization
    // Func7=In Func6=Out Func5=In Func4=Out Func3=In Func2=In Func1=In Func0=In 
    // State7=T State6=0 State5=T State4=0 State3=T State2=T State1=T State0=T 
    // PORTB=0x00;
    // DDRB=0x50;

    // Port B initialization
    // Func7=In Func6=Out Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
    // State7=T State6=0 State5=T State4=P State3=T State2=T State1=T State0=T 
    PORTB=0x00;
    DDRB=0x40;
    
    // Port C initialization
    // Func7=In Func6=Out Func5=Out Func4=In Func3=Out Func2=In Func1=In Func0=Out 
    // State7=T State6=0 State5=0 State4=T State3=0 State2=T State1=T State0=0 
    PORTC=0x00;
    DDRC=0x69;

    // Port D initialization
    // Func7=Out Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=In 
    // State7=1 State6=T State5=T State4=T State3=P State2=T State1=0 State0=T 
    PORTD=0x88;
    DDRD=0x82;   
}

void TimerCounter_Init(void){
    // Timer/Counter 0 initialization
    // Clock source: System Clock
    // Clock value: Timer 0 Stopped
    // Mode: Normal top=FFh
    // OC0 output: Disconnected
    TCCR0=0x00;
    TCNT0=0x00;
    OCR0=0x00;

    // Timer/Counter 1 initialization
    // Clock source: System Clock
    // Clock value: Timer 1 Stopped
    // Mode: Normal top=FFFFh
    // OC1A output: Discon.
    // OC1B output: Discon.
    // Noise Canceler: Off
    // Input Capture on Falling Edge
    // Timer 1 Overflow Interrupt: Off
    // Input Capture Interrupt: Off
    // Compare A Match Interrupt: Off
    // Compare B Match Interrupt: Off
    TCCR1A=0x00;
    TCCR1B=0x00;
    TCNT1H=0x00;
    TCNT1L=0x00;
    ICR1H=0x00;
    ICR1L=0x00;
    OCR1AH=0x00;
    OCR1AL=0x00;
    OCR1BH=0x00;
    OCR1BL=0x00;

    // Timer/Counter 2 initialization
    // Clock source: System Clock
    // Clock value: Timer 2 Stopped
    // Mode: Normal top=FFh
    // OC2 output: Disconnected
    ASSR=0x00;
    TCCR2=0x00;
    TCNT2=0x00;
    OCR2=0x00;
    

}

void ExtInterupt_Init(void){
    // External Interrupt(s) initialization
    // INT0: Off
    // INT1: On
    // INT1 Mode: Low level
    // INT2: Off
    GICR|=0x80;
    MCUCR=0x00;
    MCUCSR=0x00;
    GIFR=0x80;

    
    
    
}

void AnalogCompare_Init(void){
    // Analog Comparator initialization
    // Analog Comparator: Off
    // Analog Comparator Input Capture by Timer/Counter 1: Off
    ACSR=0x80;
    SFIOR=0x00;
}

void TimerCounterInter_Init(void){
    // Timer(s)/Counter(s) Interrupt(s) initialization
    TIMSK=0x00;
}

void RS232_Init(void){
    // USART initialization
    // Communication Parameters: 8 Data, 1 Stop, No Parity
    // USART Receiver: On
    // USART Transmitter: On
    // USART Mode: Asynchronous
    // USART Baud Rate: 9600
    UCSRA=0x00;
    UCSRB=0xD8;
    UCSRC=0x86;
    UBRRH=0x00;
    UBRRL=0x47;
}