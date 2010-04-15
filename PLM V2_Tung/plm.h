#pragma used+
    #define DEFAULT_CONTROL_REG	0x1c321800	
    //0x0000321c
    // Frame header
    #define HEADER_HIGH_DATA        0x9b
    #define HEADER_HIGH_ACK         0xe9
    #define HEADER_LOW              0x58

    // States
    #define PLM_STOP                0x00
    #define PLM_TX_REG              0x01
    #define PLM_RX_REG              0x02

    #define PLM_TX_PREAMBLE         0x03
    #define PLM_TX_HEADER_HIGH      0x04
    #define PLM_TX_HEADER_LOW       0x05
    #define PLM_TX_DATA             0x06
    #define PLM_TX_FEC              0x07
    #define PLM_TX_POSTAMBLE        0x08

    #define PLM_RX_PREAMBLE         0x09
    #define PLM_RX_HEADER_HIGH      0x0a
    #define PLM_RX_HEADER_LOW       0x0b
    #define PLM_RX_DATA             0x0c
    #define PLM_RX_FEC              0x0d
    #define PLM_RX_POSTAMBLE        0x0e
    
    
    #define PLM_pinRxD PINB.5
    #define PLM_pinTxD PORTB.6
    #define PLM_pinCLRT PINB.7

    #define PLM_pinREGOK PINA.0
    #define PLM_pinPG PINA.1
    #define PLM_pinBU PINA.2
    #define PLM_pinWD PORTA.3
    
    #define PLM_pinRXTX PORTC.5
    #define PLM_pinREG_DATA PORTC.6
    #define PLM_pinCD_PD PINC.4
        
    //#define pin_TASK PORTD.7 //bao ngat
    #define pin_SS PORTD.7
#pragma used-

