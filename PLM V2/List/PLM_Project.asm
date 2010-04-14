
;CodeVisionAVR C Compiler V2.03.4 Standard
;(C) Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 11.059200 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote char to int    : Yes
;char is unsigned       : Yes
;global const stored in FLASH  : No
;8 bit enums            : Yes
;Enhanced core instructions    : On
;Smart register allocation : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ANDI R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ORI  R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __CLRD1S
	LDI  R30,0
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+@1)
	LDI  R31,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	LDI  R22,BYTE3(2*@0+@1)
	LDI  R23,BYTE4(2*@0+@1)
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+@2)
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+@3)
	LDI  R@1,HIGH(@2+@3)
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+@3)
	LDI  R@1,HIGH(@2*2+@3)
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+@1
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+@1
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	LDS  R22,@0+@1+2
	LDS  R23,@0+@1+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+@2
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+@3
	LDS  R@1,@2+@3+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+@1
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	LDS  R24,@0+@1+2
	LDS  R25,@0+@1+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+@1,R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	STS  @0+@1+2,R22
	STS  @0+@1+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+@1,R0
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+@1,R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+@1,R@2
	STS  @0+@1+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __CLRD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R@1
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _rx_wr_index=R5
	.DEF _rx_rd_index=R4
	.DEF _rx_counter=R7
	.DEF _tx_wr_index=R6
	.DEF _tx_rd_index=R9
	.DEF _tx_counter=R8

	.CSEG
	.ORG 0x00

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  _ext_int1_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _spi_isr
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  _usart_tx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_ucCRC:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x1,0x0,0x2,0x0,0x18,0x0,0x40
	.DB  0x0,0xC0,0x3,0x0,0x0,0x70,0x4,0x28
	.DB  0x0,0x1,0x30,0x1C,0x0,0x6,0x80,0x80
	.DB  0x0,0x10,0x80,0x80,0x7,0xA0,0x0,0xA
	.DB  0x0,0x1,0xE0,0x2,0x8,0xC0,0x50,0x5
	.DB  0x0,0xE,0x3,0x40,0x60,0x0,0x38,0x14
	.DB  0x0,0x1,0xC,0x20,0x0,0x0,0x0,0x0
_tableCRC:
	.DB  0x0,0x0,0x5,0x80,0xF,0x80,0xA,0x0
	.DB  0x1B,0x80,0x1E,0x0,0x14,0x0,0x11,0x80
	.DB  0x33,0x80,0x36,0x0,0x3C,0x0,0x39,0x80
	.DB  0x28,0x0,0x2D,0x80,0x27,0x80,0x22,0x0
	.DB  0x63,0x80,0x66,0x0,0x6C,0x0,0x69,0x80
	.DB  0x78,0x0,0x7D,0x80,0x77,0x80,0x72,0x0
	.DB  0x50,0x0,0x55,0x80,0x5F,0x80,0x5A,0x0
	.DB  0x4B,0x80,0x4E,0x0,0x44,0x0,0x41,0x80
	.DB  0xC3,0x80,0xC6,0x0,0xCC,0x0,0xC9,0x80
	.DB  0xD8,0x0,0xDD,0x80,0xD7,0x80,0xD2,0x0
	.DB  0xF0,0x0,0xF5,0x80,0xFF,0x80,0xFA,0x0
	.DB  0xEB,0x80,0xEE,0x0,0xE4,0x0,0xE1,0x80
	.DB  0xA0,0x0,0xA5,0x80,0xAF,0x80,0xAA,0x0
	.DB  0xBB,0x80,0xBE,0x0,0xB4,0x0,0xB1,0x80
	.DB  0x93,0x80,0x96,0x0,0x9C,0x0,0x99,0x80
	.DB  0x88,0x0,0x8D,0x80,0x87,0x80,0x82,0x0
	.DB  0x83,0x81,0x86,0x1,0x8C,0x1,0x89,0x81
	.DB  0x98,0x1,0x9D,0x81,0x97,0x81,0x92,0x1
	.DB  0xB0,0x1,0xB5,0x81,0xBF,0x81,0xBA,0x1
	.DB  0xAB,0x81,0xAE,0x1,0xA4,0x1,0xA1,0x81
	.DB  0xE0,0x1,0xE5,0x81,0xEF,0x81,0xEA,0x1
	.DB  0xFB,0x81,0xFE,0x1,0xF4,0x1,0xF1,0x81
	.DB  0xD3,0x81,0xD6,0x1,0xDC,0x1,0xD9,0x81
	.DB  0xC8,0x1,0xCD,0x81,0xC7,0x81,0xC2,0x1
	.DB  0x40,0x1,0x45,0x81,0x4F,0x81,0x4A,0x1
	.DB  0x5B,0x81,0x5E,0x1,0x54,0x1,0x51,0x81
	.DB  0x73,0x81,0x76,0x1,0x7C,0x1,0x79,0x81
	.DB  0x68,0x1,0x6D,0x81,0x67,0x81,0x62,0x1
	.DB  0x23,0x81,0x26,0x1,0x2C,0x1,0x29,0x81
	.DB  0x38,0x1,0x3D,0x81,0x37,0x81,0x32,0x1
	.DB  0x10,0x1,0x15,0x81,0x1F,0x81,0x1A,0x1
	.DB  0xB,0x81,0xE,0x1,0x4,0x1,0x1,0x81
	.DB  0x3,0x83,0x6,0x3,0xC,0x3,0x9,0x83
	.DB  0x18,0x3,0x1D,0x83,0x17,0x83,0x12,0x3
	.DB  0x30,0x3,0x35,0x83,0x3F,0x83,0x3A,0x3
	.DB  0x2B,0x83,0x2E,0x3,0x24,0x3,0x21,0x83
	.DB  0x60,0x3,0x65,0x83,0x6F,0x83,0x6A,0x3
	.DB  0x7B,0x83,0x7E,0x3,0x74,0x3,0x71,0x83
	.DB  0x53,0x83,0x56,0x3,0x5C,0x3,0x59,0x83
	.DB  0x48,0x3,0x4D,0x83,0x47,0x83,0x42,0x3
	.DB  0xC0,0x3,0xC5,0x83,0xCF,0x83,0xCA,0x3
	.DB  0xDB,0x83,0xDE,0x3,0xD4,0x3,0xD1,0x83
	.DB  0xF3,0x83,0xF6,0x3,0xFC,0x3,0xF9,0x83
	.DB  0xE8,0x3,0xED,0x83,0xE7,0x83,0xE2,0x3
	.DB  0xA3,0x83,0xA6,0x3,0xAC,0x3,0xA9,0x83
	.DB  0xB8,0x3,0xBD,0x83,0xB7,0x83,0xB2,0x3
	.DB  0x90,0x3,0x95,0x83,0x9F,0x83,0x9A,0x3
	.DB  0x8B,0x83,0x8E,0x3,0x84,0x3,0x81,0x83
	.DB  0x80,0x2,0x85,0x82,0x8F,0x82,0x8A,0x2
	.DB  0x9B,0x82,0x9E,0x2,0x94,0x2,0x91,0x82
	.DB  0xB3,0x82,0xB6,0x2,0xBC,0x2,0xB9,0x82
	.DB  0xA8,0x2,0xAD,0x82,0xA7,0x82,0xA2,0x2
	.DB  0xE3,0x82,0xE6,0x2,0xEC,0x2,0xE9,0x82
	.DB  0xF8,0x2,0xFD,0x82,0xF7,0x82,0xF2,0x2
	.DB  0xD0,0x2,0xD5,0x82,0xDF,0x82,0xDA,0x2
	.DB  0xCB,0x82,0xCE,0x2,0xC4,0x2,0xC1,0x82
	.DB  0x43,0x82,0x46,0x2,0x4C,0x2,0x49,0x82
	.DB  0x58,0x2,0x5D,0x82,0x57,0x82,0x52,0x2
	.DB  0x70,0x2,0x75,0x82,0x7F,0x82,0x7A,0x2
	.DB  0x6B,0x82,0x6E,0x2,0x64,0x2,0x61,0x82
	.DB  0x20,0x2,0x25,0x82,0x2F,0x82,0x2A,0x2
	.DB  0x3B,0x82,0x3E,0x2,0x34,0x2,0x31,0x82
	.DB  0x13,0x82,0x16,0x2,0x1C,0x2,0x19,0x82
	.DB  0x8,0x2,0xD,0x82,0x7,0x82,0x2,0x2
_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x800)
	LDI  R25,HIGH(0x800)
	LDI  R26,0x60
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0x85F)
	OUT  SPL,R30
	LDI  R30,HIGH(0x85F)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x260)
	LDI  R29,HIGH(0x260)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.03.4 Standard
;Automatic Program Generator
;© Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : PLM_Modem
;Version : 1.0.0.0
;Date    : 3/21/2010
;Author  : Nguyen Ngoc Son
;Company :
;Comments:
;
;
;Chip type           : ATmega32
;Program type        : Application
;Clock frequency     : 11.059200 MHz
;Memory model        : Small
;External RAM size   : 0
;Data Stack size     : 512
;*****************************************************/
;
;#include <mega32.h>
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
;#include <plm.h>
;#include <command.h>
;#include <rs232.h>
;#include <string.h>
;#include <delay.h>
;
;extern void IO_Init(void);
;extern void TimerCounter_Init(void);
;extern void ExtInterupt_Init(void);
;extern void SPI_Init(void);
;extern void RS232_Init(void);
;extern void putchar(char c);
;extern char getchar(void);
;extern unsigned char RS232_IsRunning(void);
;extern void ByteReverse(unsigned long* pul);
;
;volatile unsigned char ucPacket[270];
;volatile unsigned char ucIndex;
;volatile unsigned char ucLength;
;volatile unsigned char ucRS232Started;
;volatile unsigned char ucCommand;
;volatile unsigned char ucPostableBits;
;
;/*------------PLM----------------*/
;
;volatile bit bAck;
;volatile unsigned char ucState;
;volatile unsigned char ucByteCounter;
;volatile unsigned char ucBitCounter;
;volatile unsigned char ucCorrectionCounter;
;volatile unsigned int  uiLastFCS;
;//bang tra cuu FEC
;flash unsigned char ucCRC[] =    {
;                                    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;                                    0x00, 0x01, 0x00, 0x02, 0x00, 0x18, 0x00, 0x40,
;                                    0x00, 0xc0, 0x03, 0x00, 0x00, 0x70, 0x04, 0x28,
;                                    0x00, 0x01, 0x30, 0x1c, 0x00, 0x06, 0x80, 0x80,
;                                    0x00, 0x10, 0x80, 0x80, 0x07, 0xa0, 0x00, 0x0a,
;                                    0x00, 0x01, 0xe0, 0x02, 0x08, 0xc0, 0x50, 0x05,
;                                    0x00, 0x0e, 0x03, 0x40, 0x60, 0x00, 0x38, 0x14,
;                                    0x00, 0x01, 0x0c, 0x20, 0x00, 0x00, 0x00, 0x00
;                                    };
;//bang tra cuu CRC
;flash unsigned int tableCRC[] =    {
;                                        0x0000, 0x8005, 0x800f, 0x000a, 0x801b, 0x001e, 0x0014, 0x8011,
;                                        0x8033, 0x0036, 0x003c, 0x8039, 0x0028, 0x802d, 0x8027, 0x0022,
;                                        0x8063, 0x0066, 0x006c, 0x8069, 0x0078, 0x807d, 0x8077, 0x0072,
;                                        0x0050, 0x8055, 0x805f, 0x005a, 0x804b, 0x004e, 0x0044, 0x8041,
;                                        0x80c3, 0x00c6, 0x00cc, 0x80c9, 0x00d8, 0x80dd, 0x80d7, 0x00d2,
;                                        0x00f0, 0x80f5, 0x80ff, 0x00fa, 0x80eb, 0x00ee, 0x00e4, 0x80e1,
;                                        0x00a0, 0x80a5, 0x80af, 0x00aa, 0x80bb, 0x00be, 0x00b4, 0x80b1,
;                                        0x8093, 0x0096, 0x009c, 0x8099, 0x0088, 0x808d, 0x8087, 0x0082,
;                                        0x8183, 0x0186, 0x018c, 0x8189, 0x0198, 0x819d, 0x8197, 0x0192,
;                                        0x01b0, 0x81b5, 0x81bf, 0x01ba, 0x81ab, 0x01ae, 0x01a4, 0x81a1,
;                                        0x01e0, 0x81e5, 0x81ef, 0x01ea, 0x81fb, 0x01fe, 0x01f4, 0x81f1,
;                                        0x81d3, 0x01d6, 0x01dc, 0x81d9, 0x01c8, 0x81cd, 0x81c7, 0x01c2,
;                                        0x0140, 0x8145, 0x814f, 0x014a, 0x815b, 0x015e, 0x0154, 0x8151,
;                                        0x8173, 0x0176, 0x017c, 0x8179, 0x0168, 0x816d, 0x8167, 0x0162,
;                                        0x8123, 0x0126, 0x012c, 0x8129, 0x0138, 0x813d, 0x8137, 0x0132,
;                                        0x0110, 0x8115, 0x811f, 0x011a, 0x810b, 0x010e, 0x0104, 0x8101,
;                                        0x8303, 0x0306, 0x030c, 0x8309, 0x0318, 0x831d, 0x8317, 0x0312,
;                                        0x0330, 0x8335, 0x833f, 0x033a, 0x832b, 0x032e, 0x0324, 0x8321,
;                                        0x0360, 0x8365, 0x836f, 0x036a, 0x837b, 0x037e, 0x0374, 0x8371,
;                                        0x8353, 0x0356, 0x035c, 0x8359, 0x0348, 0x834d, 0x8347, 0x0342,
;                                        0x03c0, 0x83c5, 0x83cf, 0x03ca, 0x83db, 0x03de, 0x03d4, 0x83d1,
;                                        0x83f3, 0x03f6, 0x03fc, 0x83f9, 0x03e8, 0x83ed, 0x83e7, 0x03e2,
;                                        0x83a3, 0x03a6, 0x03ac, 0x83a9, 0x03b8, 0x83bd, 0x83b7, 0x03b2,
;                                        0x0390, 0x8395, 0x839f, 0x039a, 0x838b, 0x038e, 0x0384, 0x8381,
;                                        0x0280, 0x8285, 0x828f, 0x028a, 0x829b, 0x029e, 0x0294, 0x8291,
;                                        0x82b3, 0x02b6, 0x02bc, 0x82b9, 0x02a8, 0x82ad, 0x82a7, 0x02a2,
;                                        0x82e3, 0x02e6, 0x02ec, 0x82e9, 0x02f8, 0x82fd, 0x82f7, 0x02f2,
;                                        0x02d0, 0x82d5, 0x82df, 0x02da, 0x82cb, 0x02ce, 0x02c4, 0x82c1,
;                                        0x8243, 0x0246, 0x024c, 0x8249, 0x0258, 0x825d, 0x8257, 0x0252,
;                                        0x0270, 0x8275, 0x827f, 0x027a, 0x826b, 0x026e, 0x0264, 0x8261,
;                                        0x0220, 0x8225, 0x822f, 0x022a, 0x823b, 0x023e, 0x0234, 0x8231,
;                                        0x8213, 0x0216, 0x021c, 0x8219, 0x0208, 0x820d, 0x8207, 0x0202
;                                        };
;
;//cong viec plm thuc hien
;void PLM_Task(void){
; 0000 0068 void PLM_Task(void){

	.CSEG
_PLM_Task:
; 0000 0069     static bit bLastCLRT;
; 0000 006A     static unsigned char ucByte,
; 0000 006B                          ucFec;
; 0000 006C 
; 0000 006D     if(PLM_pinCLRT){                                                // PLM clock is 1
	SBIS 0x16,7
	RJMP _0x3
; 0000 006E         if(!bLastCLRT){                                                // transition 0 -> 1
	SBRC R2,1
	RJMP _0x4
; 0000 006F             bLastCLRT = 1;                                            // update last CLRT value
	SET
	CALL SUBOPT_0x0
; 0000 0070 
; 0000 0071             switch(ucState){
; 0000 0072                 case PLM_STOP:
	BRNE _0x8
; 0000 0073                     break;
	RJMP _0x7
; 0000 0074 
; 0000 0075                 case PLM_RX_REG:
_0x8:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x9
; 0000 0076                     ucByte = (ucByte << 1) | PLM_pinRxD;            // receive 1 bit and store it
	CALL SUBOPT_0x1
; 0000 0077                     ucBitCounter--;
	CALL SUBOPT_0x2
; 0000 0078 
; 0000 0079                     if(!ucBitCounter){
	BRNE _0xA
; 0000 007A                         ucPacket[ucIndex++] = ucByte;
	CALL SUBOPT_0x3
; 0000 007B                         ucBitCounter = 8;
	CALL SUBOPT_0x4
; 0000 007C                         ucByteCounter--;
; 0000 007D 
; 0000 007E                         if(!ucByteCounter){
	LDS  R30,_ucByteCounter
	CPI  R30,0
	BRNE _0xB
; 0000 007F                             ucState = PLM_STOP;                        // stop PLM
	RJMP _0x2060001
; 0000 0080 
; 0000 0081                             PLM_pinRXTX = 1;                        // Rx session
; 0000 0082                             PLM_pinREG_DATA = 0;                    // mains access
; 0000 0083 
; 0000 0084                             return;
; 0000 0085                         }
; 0000 0086                     }
_0xB:
; 0000 0087 
; 0000 0088                     break;
_0xA:
	RJMP _0x7
; 0000 0089 
; 0000 008A                 case PLM_RX_PREAMBLE:
_0x9:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x10
; 0000 008B                     ucState++;
	LDS  R30,_ucState
	SUBI R30,-LOW(1)
	RJMP _0xA8
; 0000 008C                     break;
; 0000 008D 
; 0000 008E                 case PLM_RX_HEADER_HIGH:
_0x10:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x11
; 0000 008F                     ucByte = (ucByte << 1) | PLM_pinRxD;            // receive 1 bit and store it
	CALL SUBOPT_0x1
; 0000 0090 
; 0000 0091                     if(ucByte == HEADER_HIGH_ACK){
	LDS  R26,_ucByte_S0000000
	CPI  R26,LOW(0xE9)
	BRNE _0x12
; 0000 0092                         bAck = 1;
	SET
	CALL SUBOPT_0x5
; 0000 0093 
; 0000 0094                         ucBitCounter = 8;
; 0000 0095                         ucState++;
; 0000 0096                     }
; 0000 0097 
; 0000 0098                     if(ucByte == HEADER_HIGH_DATA){
_0x12:
	LDS  R26,_ucByte_S0000000
	CPI  R26,LOW(0x9B)
	BRNE _0x13
; 0000 0099                         bAck = 0;
	CLT
	CALL SUBOPT_0x5
; 0000 009A 
; 0000 009B                         ucBitCounter = 8;
; 0000 009C                         ucState++;
; 0000 009D                     }
; 0000 009E 
; 0000 009F                     break;
_0x13:
	RJMP _0x7
; 0000 00A0 
; 0000 00A1                 case PLM_RX_HEADER_LOW:
_0x11:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x14
; 0000 00A2                     ucByte = (ucByte << 1) | PLM_pinRxD;            // receive 1 bit and store it
	CALL SUBOPT_0x1
; 0000 00A3                     ucBitCounter--;
	CALL SUBOPT_0x2
; 0000 00A4 
; 0000 00A5                     if(!ucBitCounter){
	BRNE _0x15
; 0000 00A6                         if(ucByte == HEADER_LOW){
	LDS  R26,_ucByte_S0000000
	CPI  R26,LOW(0x58)
	BRNE _0x16
; 0000 00A7                             if(bAck){
	SBRS R2,0
	RJMP _0x17
; 0000 00A8                                 ucByteCounter = 2;                    // only FCS
	LDI  R30,LOW(2)
	STS  _ucByteCounter,R30
; 0000 00A9                             }
; 0000 00AA 
; 0000 00AB                             ucBitCounter = 8;
_0x17:
	CALL SUBOPT_0x6
; 0000 00AC                             ucFec = 0;
; 0000 00AD                             ucState++;
	LDS  R30,_ucState
	SUBI R30,-LOW(1)
	RJMP _0xA9
; 0000 00AE                         }
; 0000 00AF                         else{
_0x16:
; 0000 00B0                             ucState = PLM_RX_PREAMBLE;
	LDI  R30,LOW(9)
_0xA9:
	STS  _ucState,R30
; 0000 00B1                         }
; 0000 00B2                     }
; 0000 00B3                     break;
_0x15:
	RJMP _0x7
; 0000 00B4 
; 0000 00B5                 case PLM_RX_DATA:
_0x14:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x19
; 0000 00B6                     ucByte = (ucByte << 1) | PLM_pinRxD;            // receive 1 bit and store it
	CALL SUBOPT_0x1
; 0000 00B7                     ucBitCounter--;
	CALL SUBOPT_0x7
; 0000 00B8 
; 0000 00B9                     ucFec = (ucFec << 1) | PLM_pinRxD;
	LSL  R30
	ROL  R31
	MOVW R26,R30
	LDI  R30,0
	SBIC 0x16,5
	LDI  R30,1
	CALL SUBOPT_0x8
; 0000 00BA                     if(ucFec & 0x40){
	CALL SUBOPT_0x9
	ANDI R30,LOW(0x40)
	BREQ _0x1A
; 0000 00BB                         ucFec ^= 0x39;
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
; 0000 00BC                     }
; 0000 00BD 
; 0000 00BE                     if(!ucBitCounter){
_0x1A:
	LDS  R30,_ucBitCounter
	CPI  R30,0
	BRNE _0x1B
; 0000 00BF                         ucBitCounter = 6;
	CALL SUBOPT_0xB
; 0000 00C0                         ucState++;
; 0000 00C1                     }
; 0000 00C2 
; 0000 00C3                     break;
_0x1B:
	RJMP _0x7
; 0000 00C4 
; 0000 00C5                 case PLM_RX_FEC:
_0x19:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x7
; 0000 00C6                     ucFec = (ucFec << 1) | ~PLM_pinRxD;
	CALL SUBOPT_0x9
	LSL  R30
	ROL  R31
	MOVW R26,R30
	LDI  R30,0
	SBIS 0x16,5
	LDI  R30,1
	CALL SUBOPT_0x8
; 0000 00C7                     ucBitCounter--;
	CALL SUBOPT_0x7
; 0000 00C8 
; 0000 00C9                     if(ucFec & 0x40){
	ANDI R30,LOW(0x40)
	BREQ _0x1D
; 0000 00CA                         ucFec ^= 0x39;
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
; 0000 00CB                     }
; 0000 00CC 
; 0000 00CD                     if(!ucBitCounter){
_0x1D:
	LDS  R30,_ucBitCounter
	CPI  R30,0
	BRNE _0x1E
; 0000 00CE                         ucFec &= 0x3f;
	CALL SUBOPT_0x9
	ANDI R30,LOW(0x3F)
	ANDI R31,HIGH(0x3F)
	STS  _ucFec_S0000000,R30
; 0000 00CF                         if(ucFec){
	CPI  R30,0
	BREQ _0x1F
; 0000 00D0                             ucByte ^= ucCRC[ucFec];
	LDS  R26,_ucByte_S0000000
	CLR  R27
	CALL SUBOPT_0x9
	SUBI R30,LOW(-_ucCRC*2)
	SBCI R31,HIGH(-_ucCRC*2)
	LPM  R30,Z
	LDI  R31,0
	EOR  R30,R26
	STS  _ucByte_S0000000,R30
; 0000 00D1                             ucCorrectionCounter++;
	LDS  R30,_ucCorrectionCounter
	SUBI R30,-LOW(1)
	STS  _ucCorrectionCounter,R30
; 0000 00D2                         }
; 0000 00D3 
; 0000 00D4                         ucPacket[ucIndex++] = ucByte;
_0x1F:
	CALL SUBOPT_0x3
; 0000 00D5                         ucByteCounter--;
	LDS  R30,_ucByteCounter
	SUBI R30,LOW(1)
	STS  _ucByteCounter,R30
; 0000 00D6 
; 0000 00D7                         if(!ucByteCounter){
	LDS  R30,_ucByteCounter
	CPI  R30,0
	BREQ _0x2060001
; 0000 00D8                             ucState = PLM_STOP;                        // stop PLM
; 0000 00D9 
; 0000 00DA                             PLM_pinRXTX = 1;                        // Rx session
; 0000 00DB                             PLM_pinREG_DATA = 0;                    // mains access
; 0000 00DC 
; 0000 00DD                             return;
; 0000 00DE                         }
; 0000 00DF 
; 0000 00E0                         ucBitCounter = 8;
	CALL SUBOPT_0x6
; 0000 00E1                         ucFec = 0;
; 0000 00E2                         ucState = PLM_RX_DATA;
	LDI  R30,LOW(12)
_0xA8:
	STS  _ucState,R30
; 0000 00E3                     }
; 0000 00E4 
; 0000 00E5                     break;
_0x1E:
; 0000 00E6             }
_0x7:
; 0000 00E7         }
; 0000 00E8     }
_0x4:
; 0000 00E9     else{                                                            // PLM clock is 0
	RJMP _0x25
_0x3:
; 0000 00EA         if(bLastCLRT){                                                // transition 1 -> 0
	SBRS R2,1
	RJMP _0x26
; 0000 00EB             bLastCLRT = 0;                                            // update last CLRT value
	CLT
	CALL SUBOPT_0x0
; 0000 00EC 
; 0000 00ED             switch(ucState){
; 0000 00EE                 case PLM_STOP:
	BRNE _0x2A
; 0000 00EF                     break;
	RJMP _0x29
; 0000 00F0 
; 0000 00F1                 case PLM_TX_REG:
_0x2A:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2B
; 0000 00F2                     if(!ucBitCounter){
	LDS  R30,_ucBitCounter
	CPI  R30,0
	BRNE _0x2C
; 0000 00F3                         if(ucByteCounter){
	LDS  R30,_ucByteCounter
	CPI  R30,0
	BREQ _0x2D
; 0000 00F4                             ucByte = ucPacket[ucIndex++];
	CALL SUBOPT_0xC
; 0000 00F5                             ucBitCounter = 8;
; 0000 00F6                             ucByteCounter--;
; 0000 00F7                         }
; 0000 00F8                         else{
	RJMP _0x2E
_0x2D:
; 0000 00F9                             ucState = PLM_STOP;                        // stop PLM
_0x2060001:
	LDI  R30,LOW(0)
	STS  _ucState,R30
; 0000 00FA 
; 0000 00FB                             PLM_pinRXTX = 1;                        // Rx session
	SBI  0x15,5
; 0000 00FC                             PLM_pinREG_DATA = 0;                    // mains access
	CBI  0x15,6
; 0000 00FD 
; 0000 00FE                             return;
	RET
; 0000 00FF                         }
_0x2E:
; 0000 0100                     }
; 0000 0101                     if((ucByte&0x80)==0x80){
_0x2C:
	CALL SUBOPT_0xD
	ANDI R30,LOW(0x80)
	CPI  R30,LOW(0x80)
	BRNE _0x33
; 0000 0102                         PLM_pinTxD = 1;
	SBI  0x18,6
; 0000 0103                     }else{
	RJMP _0x36
_0x33:
; 0000 0104                         PLM_pinTxD = 0;
	CBI  0x18,6
; 0000 0105                     }
_0x36:
; 0000 0106                     PLM_pinTxD = ucByte & 0x80;                        // transmit 1 bit
	CALL SUBOPT_0xD
	ANDI R30,LOW(0x80)
	ANDI R31,HIGH(0x80)
	CPI  R30,0
	BRNE _0x39
	CBI  0x18,6
	RJMP _0x3A
_0x39:
	SBI  0x18,6
_0x3A:
; 0000 0107                     ucByte <<= 1;
	CALL SUBOPT_0xD
	CALL SUBOPT_0xE
; 0000 0108                     ucBitCounter--;
	CALL SUBOPT_0xF
; 0000 0109 
; 0000 010A                     break;
	RJMP _0x29
; 0000 010B 
; 0000 010C                 case PLM_TX_PREAMBLE:
_0x2B:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x3B
; 0000 010D                     PLM_pinTxD = --ucBitCounter & 0x01;
	CALL SUBOPT_0xF
	LDI  R31,0
	ANDI R30,LOW(0x1)
	BRNE _0x3C
	CBI  0x18,6
	RJMP _0x3D
_0x3C:
	SBI  0x18,6
_0x3D:
; 0000 010E 
; 0000 010F                     if(!ucBitCounter){
	LDS  R30,_ucBitCounter
	CPI  R30,0
	BRNE _0x3E
; 0000 0110                         if(bAck){
	SBRS R2,0
	RJMP _0x3F
; 0000 0111                             ucByte = HEADER_HIGH_ACK;
	LDI  R30,LOW(233)
	RJMP _0xAA
; 0000 0112                         }
; 0000 0113                         else{
_0x3F:
; 0000 0114                             ucByte = HEADER_HIGH_DATA;
	LDI  R30,LOW(155)
_0xAA:
	STS  _ucByte_S0000000,R30
; 0000 0115                         }
; 0000 0116                         ucBitCounter = 8;
	CALL SUBOPT_0x10
; 0000 0117                         ucState++;
; 0000 0118                     }
; 0000 0119                     break;
_0x3E:
	RJMP _0x29
; 0000 011A 
; 0000 011B                 case PLM_TX_HEADER_HIGH:
_0x3B:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x41
; 0000 011C                 {
; 0000 011D                     if(ucByte & 0x80){
	CALL SUBOPT_0xD
	ANDI R30,LOW(0x80)
	BREQ _0x42
; 0000 011E                         PLM_pinTxD = 1;
	SBI  0x18,6
; 0000 011F                     }else{
	RJMP _0x45
_0x42:
; 0000 0120                         PLM_pinTxD = 0;
	CBI  0x18,6
; 0000 0121                     }
_0x45:
; 0000 0122                     ucByte <<= 1;
	CALL SUBOPT_0xD
	CALL SUBOPT_0xE
; 0000 0123                     ucBitCounter--;
	CALL SUBOPT_0x2
; 0000 0124 
; 0000 0125                     if(!ucBitCounter){
	BRNE _0x48
; 0000 0126                         ucByte = HEADER_LOW;
	LDI  R30,LOW(88)
	STS  _ucByte_S0000000,R30
; 0000 0127                         ucBitCounter = 8;
	CALL SUBOPT_0x10
; 0000 0128                         ucState++;
; 0000 0129                     }
; 0000 012A                     break;
_0x48:
	RJMP _0x29
; 0000 012B                 }
; 0000 012C                 case PLM_TX_HEADER_LOW:
_0x41:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x49
; 0000 012D                     PLM_pinTxD = ucByte & 0x80;
	CALL SUBOPT_0xD
	ANDI R30,LOW(0x80)
	ANDI R31,HIGH(0x80)
	CPI  R30,0
	BRNE _0x4A
	CBI  0x18,6
	RJMP _0x4B
_0x4A:
	SBI  0x18,6
_0x4B:
; 0000 012E                     ucByte <<= 1;
	CALL SUBOPT_0xD
	CALL SUBOPT_0xE
; 0000 012F                     ucBitCounter--;
	CALL SUBOPT_0x2
; 0000 0130 
; 0000 0131                     if(!ucBitCounter){
	BRNE _0x4C
; 0000 0132                         ucByte = ucPacket[ucIndex++];
	CALL SUBOPT_0xC
; 0000 0133                         ucBitCounter = 8;
; 0000 0134                         ucByteCounter--;
; 0000 0135                         ucFec = 0;
	LDI  R30,LOW(0)
	STS  _ucFec_S0000000,R30
; 0000 0136                         ucState++;
	LDS  R30,_ucState
	SUBI R30,-LOW(1)
	STS  _ucState,R30
; 0000 0137                     }
; 0000 0138 
; 0000 0139                     break;
_0x4C:
	RJMP _0x29
; 0000 013A 
; 0000 013B                 case PLM_TX_DATA:
_0x49:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x4D
; 0000 013C                     PLM_pinTxD = ucByte & 0x80;
	CALL SUBOPT_0xD
	ANDI R30,LOW(0x80)
	ANDI R31,HIGH(0x80)
	CPI  R30,0
	BRNE _0x4E
	CBI  0x18,6
	RJMP _0x4F
_0x4E:
	SBI  0x18,6
_0x4F:
; 0000 013D                     ucByte <<= 1;
	CALL SUBOPT_0xD
	CALL SUBOPT_0xE
; 0000 013E                     ucBitCounter--;
	CALL SUBOPT_0x7
; 0000 013F 
; 0000 0140                     ucFec = (ucFec << 1) | PLM_pinTxD;
	LSL  R30
	ROL  R31
	MOVW R26,R30
	LDI  R30,0
	SBIC 0x18,6
	LDI  R30,1
	CALL SUBOPT_0x8
; 0000 0141                     if(ucFec & 0x40){
	CALL SUBOPT_0x9
	ANDI R30,LOW(0x40)
	BREQ _0x50
; 0000 0142                         ucFec ^= 0x39;
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
; 0000 0143                     }
; 0000 0144 
; 0000 0145                     if(!ucBitCounter){
_0x50:
	LDS  R30,_ucBitCounter
	CPI  R30,0
	BRNE _0x51
; 0000 0146                         ucBitCounter = 6;
	LDI  R30,LOW(6)
	STS  _ucBitCounter,R30
; 0000 0147                         while(ucBitCounter){
_0x52:
	LDS  R30,_ucBitCounter
	CPI  R30,0
	BREQ _0x54
; 0000 0148                             ucFec <<= 1;
	CALL SUBOPT_0x9
	LSL  R30
	ROL  R31
	STS  _ucFec_S0000000,R30
; 0000 0149                             if(ucFec & 0x40){
	CALL SUBOPT_0x9
	ANDI R30,LOW(0x40)
	BREQ _0x55
; 0000 014A                                 ucFec ^= 0x39;
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
; 0000 014B                             }
; 0000 014C                             ucBitCounter--;
_0x55:
	CALL SUBOPT_0xF
; 0000 014D                         }
	RJMP _0x52
_0x54:
; 0000 014E                         ucFec ^= 0xff;
	CALL SUBOPT_0x9
	LDI  R26,LOW(255)
	LDI  R27,HIGH(255)
	EOR  R30,R26
	STS  _ucFec_S0000000,R30
; 0000 014F 
; 0000 0150                         ucBitCounter = 6;
	CALL SUBOPT_0xB
; 0000 0151                         ucState++;
; 0000 0152                     }
; 0000 0153                     break;
_0x51:
	RJMP _0x29
; 0000 0154 
; 0000 0155                 case PLM_TX_FEC:
_0x4D:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x56
; 0000 0156                     PLM_pinTxD = ucFec & 0x20;
	CALL SUBOPT_0x9
	ANDI R30,LOW(0x20)
	ANDI R31,HIGH(0x20)
	CPI  R30,0
	BRNE _0x57
	CBI  0x18,6
	RJMP _0x58
_0x57:
	SBI  0x18,6
_0x58:
; 0000 0157                     ucFec <<= 1;
	CALL SUBOPT_0x9
	LSL  R30
	ROL  R31
	STS  _ucFec_S0000000,R30
; 0000 0158                     ucBitCounter--;
	CALL SUBOPT_0x2
; 0000 0159 
; 0000 015A                     if(!ucBitCounter){
	BRNE _0x59
; 0000 015B                         if(!ucByteCounter){
	LDS  R30,_ucByteCounter
	CPI  R30,0
	BRNE _0x5A
; 0000 015C                             ucFec = PLM_pinTxD ^ 0x01;
	LDI  R26,0
	SBIC 0x18,6
	LDI  R26,1
	LDI  R30,LOW(1)
	EOR  R30,R26
	STS  _ucFec_S0000000,R30
; 0000 015D                             ucBitCounter = ucPostableBits;
	LDS  R30,_ucPostableBits
	STS  _ucBitCounter,R30
; 0000 015E                             ucState++;                                // postamble
	LDS  R30,_ucState
	SUBI R30,-LOW(1)
	RJMP _0xAB
; 0000 015F                         }
; 0000 0160                         else{
_0x5A:
; 0000 0161                             ucByte = ucPacket[ucIndex++];
	CALL SUBOPT_0xC
; 0000 0162                             ucBitCounter = 8;
; 0000 0163                             ucByteCounter--;
; 0000 0164                             ucFec = 0;
	LDI  R30,LOW(0)
	STS  _ucFec_S0000000,R30
; 0000 0165                             ucState = PLM_TX_DATA;
	LDI  R30,LOW(6)
_0xAB:
	STS  _ucState,R30
; 0000 0166                         }
; 0000 0167                     }
; 0000 0168                     break;
_0x59:
	RJMP _0x29
; 0000 0169 
; 0000 016A                 case PLM_TX_POSTAMBLE:
_0x56:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x29
; 0000 016B                     PLM_pinTxD = ucFec;
	LDS  R30,_ucFec_S0000000
	CPI  R30,0
	BRNE _0x5D
	CBI  0x18,6
	RJMP _0x5E
_0x5D:
	SBI  0x18,6
_0x5E:
; 0000 016C                     ucBitCounter--;
	CALL SUBOPT_0x2
; 0000 016D 
; 0000 016E                     if(!ucBitCounter){
	BRNE _0x5F
; 0000 016F                         ucState = PLM_STOP;
	LDI  R30,LOW(0)
	STS  _ucState,R30
; 0000 0170 
; 0000 0171                         PLM_pinRXTX = 1;                            // Rx session
	SBI  0x15,5
; 0000 0172                         PLM_pinREG_DATA = 0;                        // mains access
	CBI  0x15,6
; 0000 0173                     }
; 0000 0174                     break;
_0x5F:
; 0000 0175             }
_0x29:
; 0000 0176         }
; 0000 0177     }
_0x26:
_0x25:
; 0000 0178 }
	RET
;
;//kiem tra xem co dang chay hay khong
;unsigned char PLM_IsRunning(void){
; 0000 017B unsigned char PLM_IsRunning(void){
_PLM_IsRunning:
; 0000 017C     return ucState;
	LDS  R30,_ucState
	RET
; 0000 017D }
;
;//+++cau hinh cho thanh ghi
;void PLM_SetControlRegister(unsigned long ulControlRegister)
; 0000 0181 {
_PLM_SetControlRegister:
; 0000 0182     *(unsigned long*)&ucPacket[0] = ulControlRegister;
;	ulControlRegister -> Y+0
	__GETD1S 0
	STS  _ucPacket,R30
	STS  _ucPacket+1,R31
	STS  _ucPacket+2,R22
	STS  _ucPacket+3,R23
; 0000 0183 
; 0000 0184     ucIndex = 1;
	LDI  R30,LOW(1)
	STS  _ucIndex,R30
; 0000 0185     ucBitCounter = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x11
; 0000 0186     ucByteCounter = 3;
; 0000 0187 
; 0000 0188     PLM_pinREG_DATA = 1;
; 0000 0189     PLM_pinRXTX = 0;
	CBI  0x15,5
; 0000 018A     ucState = PLM_TX_REG;
	LDI  R30,LOW(1)
	STS  _ucState,R30
; 0000 018B     pin_TASK = 0;
	CBI  0x12,7
; 0000 018C }
	ADIW R28,4
	RET
;
;//+++lay cac thong so thiet lap cau hinh
;unsigned long PLM_GetControlRegister(void){
; 0000 018F unsigned long PLM_GetControlRegister(void){
_PLM_GetControlRegister:
; 0000 0190     ucIndex = 4;
	LDI  R30,LOW(4)
	STS  _ucIndex,R30
; 0000 0191     ucBitCounter = 8;
	LDI  R30,LOW(8)
	CALL SUBOPT_0x11
; 0000 0192     ucByteCounter = 3;
; 0000 0193 
; 0000 0194     PLM_pinREG_DATA = 1;
; 0000 0195     PLM_pinRXTX = 1;
	SBI  0x15,5
; 0000 0196 
; 0000 0197     ucState = PLM_RX_REG;
	LDI  R30,LOW(2)
	STS  _ucState,R30
; 0000 0198     pin_TASK = 0;
	CBI  0x12,7
; 0000 0199 
; 0000 019A     while(PLM_IsRunning() != 0);
_0x70:
	RCALL _PLM_IsRunning
	CPI  R30,0
	BRNE _0x70
; 0000 019B 
; 0000 019C     // return only 24 bits
; 0000 019D     return (*(unsigned long*)&ucPacket[3]) & 0xffffff00;
	__GETD1MN _ucPacket,3
	ANDI R30,LOW(0xFFFFFF00)
	RET
; 0000 019E }
;
;//+++tinh toan va sua loi
;unsigned int CalcCRC(unsigned char *pucBuffer, unsigned char ucLength){
; 0000 01A1 unsigned int CalcCRC(unsigned char *pucBuffer, unsigned char ucLength){
; 0000 01A2     unsigned int uiCRC = 0;
; 0000 01A3 
; 0000 01A4     while(ucLength--)
;	*pucBuffer -> Y+3
;	ucLength -> Y+2
;	uiCRC -> R16,R17
; 0000 01A5         uiCRC = tableCRC[((uiCRC >> 8) ^ *pucBuffer++) & 0xff] ^ (uiCRC << 8);
; 0000 01A7 return uiCRC;
; 0000 01A8 }
;
;//+++
;unsigned char PLM_GetCorrectionNumber(void){
; 0000 01AB unsigned char PLM_GetCorrectionNumber(void){
; 0000 01AC     return ucCorrectionCounter;
; 0000 01AD }
;
;//khoi tao cho plm
;void PLM_Init(void){
; 0000 01B0 void PLM_Init(void){
_PLM_Init:
; 0000 01B1     PLM_pinREG_DATA = 0;
	CBI  0x15,6
; 0000 01B2     PLM_pinRXTX = 1;
	SBI  0x15,5
; 0000 01B3     ucState = PLM_STOP;
	LDI  R30,LOW(0)
	STS  _ucState,R30
; 0000 01B4 }
	RET
;
;//co phan hoi hay khong
;unsigned char PLM_IsAck(void){
; 0000 01B7 unsigned char PLM_IsAck(void){
; 0000 01B8     return bAck;
; 0000 01B9 }
;
;//set cac pin de dua ve che do idle
;void PLM_Stop(void){
; 0000 01BC void PLM_Stop(void){
; 0000 01BD     ucState = PLM_STOP;
; 0000 01BE 
; 0000 01BF     PLM_pinREG_DATA = 0;
; 0000 01C0     PLM_pinRXTX = 1;
; 0000 01C1 }
;
;//chuyen sang che do truyen du lieu
;void PLM_TransmitData(unsigned char ucLength, unsigned char ucAck){
; 0000 01C4 void PLM_TransmitData(unsigned char ucLength, unsigned char ucAck){
; 0000 01C5     bAck = ucAck;
;	ucLength -> Y+1
;	ucAck -> Y+0
; 0000 01C6 
; 0000 01C7     ucIndex = 0;
; 0000 01C8     ucBitCounter = 16;                    // 16 bits preamble length
; 0000 01C9     ucByteCounter = ucLength;             // do dai byte
; 0000 01CA 
; 0000 01CB                                    // mains access
; 0000 01CC     PLM_pinREG_DATA = 0;
; 0000 01CD     PLM_pinRXTX = 0;
; 0000 01CE     ucState = PLM_TX_PREAMBLE;
; 0000 01CF }
;
;//+++chuyen sang che do nhan du lieu
;void PLM_ReceiveData(unsigned char ucLength){
; 0000 01D2 void PLM_ReceiveData(unsigned char ucLength){
; 0000 01D3     ucIndex = 0;
;	ucLength -> Y+0
; 0000 01D4     ucByteCounter = ucLength;
; 0000 01D5     ucCorrectionCounter = 0;
; 0000 01D6 
; 0000 01D7     PLM_pinREG_DATA = 0;
; 0000 01D8     PLM_pinRXTX = 1;
; 0000 01D9 
; 0000 01DA     ucState = PLM_RX_PREAMBLE;
; 0000 01DB }
;//---lay du lieu phuc vu nhan
;void PLM_GetData(unsigned char *pucBuffer, unsigned char ucLength){
; 0000 01DD void PLM_GetData(unsigned char *pucBuffer, unsigned char ucLength){
; 0000 01DE     memcpy(pucBuffer, &ucPacket[0], ucLength);
;	*pucBuffer -> Y+1
;	ucLength -> Y+0
; 0000 01DF }
;
;//+++gan du lieu de chuan bi gui qua rs232
;void RS232_SetData(unsigned char *pucBuffer, unsigned char ucLength){
; 0000 01E2 void RS232_SetData(unsigned char *pucBuffer, unsigned char ucLength){
; 0000 01E3     int iCounter = 0;
; 0000 01E4     while((ucLength-1)>iCounter){
;	*pucBuffer -> Y+3
;	ucLength -> Y+2
;	iCounter -> R16,R17
; 0000 01E5         putchar(*(pucBuffer+iCounter));
; 0000 01E6         iCounter++;
; 0000 01E7     }
; 0000 01E8 }
;
;//+++lay du lieu tu pc gui xuong qua rs232
;void RS232_GetData(){
; 0000 01EB void RS232_GetData(){
_RS232_GetData:
; 0000 01EC     int iCounter = 0;
; 0000 01ED     for(iCounter = 0;iCounter < ucLength; iCounter++){
	ST   -Y,R17
	ST   -Y,R16
;	iCounter -> R16,R17
	__GETWRN 16,17,0
	__GETWRN 16,17,0
_0x8A:
	LDS  R30,_ucLength
	MOVW R26,R16
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x8B
; 0000 01EE         *(ucPacket+iCounter) = getchar();
	MOVW R30,R16
	SUBI R30,LOW(-_ucPacket)
	SBCI R31,HIGH(-_ucPacket)
	PUSH R31
	PUSH R30
	CALL _getchar
	POP  R26
	POP  R27
	ST   X,R30
; 0000 01EF     }
	__ADDWRN 16,17,1
	RJMP _0x8A
_0x8B:
; 0000 01F0     ucRS232Started = 0;
	LDI  R30,LOW(0)
	STS  _ucRS232Started,R30
; 0000 01F1 }
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;/*-----------RS233---------------*/
;
;// External Interrupt 0 service routine
;
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 01F8 {
_ext_int1_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 01F9     if(PLM_IsRunning()>0){
	RCALL _PLM_IsRunning
	CPI  R30,LOW(0x1)
	BRLO _0x8C
; 0000 01FA         //ucState = 0;
; 0000 01FB         PLM_Task();
	RCALL _PLM_Task
; 0000 01FC     }else{
	RJMP _0x8D
_0x8C:
; 0000 01FD         pin_TASK = 1;
	SBI  0x12,7
; 0000 01FE     }
_0x8D:
; 0000 01FF }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;// Trien khai spi
;interrupt [SPI_STC] void spi_isr(void)
; 0000 0203 {
_spi_isr:
; 0000 0204 
; 0000 0205 }
	RETI
;
;// Declare your global variables here
;
;
;
;// dao vi tri byte
;
;
;void main(void)
; 0000 020F {
_main:
; 0000 0210     int i;
; 0000 0211 
; 0000 0212     // Khai bao bien
; 0000 0213 
; 0000 0214     // Khoi tao cac gia tri
; 0000 0215     IO_Init();
;	i -> R16,R17
	RCALL _IO_Init
; 0000 0216     TimerCounter_Init();
	RCALL _TimerCounter_Init
; 0000 0217     RS232_Init();
	RCALL _RS232_Init
; 0000 0218     pin_TASK = 1;
	SBI  0x12,7
; 0000 0219     ExtInterupt_Init();
	RCALL _ExtInterupt_Init
; 0000 021A 
; 0000 021B     PLM_Init();
	RCALL _PLM_Init
; 0000 021C     // ket thuc khoi tao
; 0000 021D 
; 0000 021E     // khoi tao cho thanh ghi ST
; 0000 021F     PLM_SetControlRegister(DEFAULT_CONTROL_REG);// dummy write
	CALL SUBOPT_0x12
; 0000 0220     while(PLM_IsRunning() != 0);
_0x92:
	RCALL _PLM_IsRunning
	CPI  R30,0
	BRNE _0x92
; 0000 0221     PLM_SetControlRegister(DEFAULT_CONTROL_REG);// dummy write
	CALL SUBOPT_0x12
; 0000 0222     // ket thuc khoi tao cho thanh ghi
; 0000 0223     putchar('c');
	LDI  R30,LOW(99)
	ST   -Y,R30
	CALL _putchar
; 0000 0224     ucRS232Started = 0;
	LDI  R30,LOW(0)
	STS  _ucRS232Started,R30
; 0000 0225     // Chuong trinh chinh
; 0000 0226     while (1)
_0x95:
; 0000 0227     {
; 0000 0228         if((RS232_IsRunning()>0)&&(ucRS232Started==0)){
	CALL _RS232_IsRunning
	CPI  R30,LOW(0x1)
	BRLO _0x99
	LDS  R26,_ucRS232Started
	CPI  R26,LOW(0x0)
	BREQ _0x9A
_0x99:
	RJMP _0x98
_0x9A:
; 0000 0229             if(getchar()== RX_START)
	CALL _getchar
	CPI  R30,LOW(0xAA)
	BRNE _0x9B
; 0000 022A             {
; 0000 022B                 delay_ms(200);
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CALL SUBOPT_0x13
; 0000 022C                 ucRS232Started = 1;
	LDI  R30,LOW(1)
	STS  _ucRS232Started,R30
; 0000 022D                 ucCommand = getchar();
	CALL _getchar
	STS  _ucCommand,R30
; 0000 022E                 ucLength = getchar();
	CALL _getchar
	STS  _ucLength,R30
; 0000 022F                 delay_ms(10*ucLength);
	LDS  R30,_ucLength
	LDI  R31,0
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	CALL SUBOPT_0x13
; 0000 0230             }
; 0000 0231         }
_0x9B:
; 0000 0232         if(ucRS232Started == 1){
_0x98:
	LDS  R26,_ucRS232Started
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x9C
; 0000 0233             // doc gia tri tu rs232
; 0000 0234             RS232_GetData();
	RCALL _RS232_GetData
; 0000 0235             /*
; 0000 0236             for(i=0;i<ucLength;i++){
; 0000 0237                 delay_ms(10);
; 0000 0238                 putchar(ucPacket[i]);
; 0000 0239             }
; 0000 023A             */
; 0000 023B             // kiem tra gia tri dau tien cua ucPacket
; 0000 023C             switch(ucCommand){
	LDS  R30,_ucCommand
	LDI  R31,0
; 0000 023D                 // doc thanh ghi st7538/7540
; 0000 023E                 case COM_GET_CTR:
	SBIW R30,0
	BRNE _0xA0
; 0000 023F                 {
; 0000 0240                     // get control register (comm)
; 0000 0241 			        *((unsigned long*)&ucPacket[3]) = PLM_GetControlRegister();
	RCALL _PLM_GetControlRegister
	__PUTD1MN _ucPacket,3
; 0000 0242 					ByteReverse((unsigned long*)&ucPacket[3]);
	__POINTW1MN _ucPacket,3
	ST   -Y,R31
	ST   -Y,R30
	CALL _ByteReverse
; 0000 0243                     *ucPacket = TX_START;// them header
	LDI  R30,LOW(170)
	STS  _ucPacket,R30
; 0000 0244                     *(ucPacket + 1) = ucCommand;// them code
	LDS  R30,_ucCommand
	__PUTB1MN _ucPacket,1
; 0000 0245                     *(ucPacket + 2) = 3;// them do dai
	LDI  R30,LOW(3)
	__PUTB1MN _ucPacket,2
; 0000 0246 					//RS232_SetData(ucPacket, 7);
; 0000 0247                     for(i=0;i<7;i++){
	__GETWRN 16,17,0
_0xA2:
	__CPWRN 16,17,7
	BRGE _0xA3
; 0000 0248                         delay_ms(10);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x13
; 0000 0249                         putchar(ucPacket[i]);
	LDI  R26,LOW(_ucPacket)
	LDI  R27,HIGH(_ucPacket)
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	ST   -Y,R30
	CALL _putchar
; 0000 024A                     }
	__ADDWRN 16,17,1
	RJMP _0xA2
_0xA3:
; 0000 024B 					break;
	RJMP _0x9F
; 0000 024C 			    }
; 0000 024D 
; 0000 024E                 // ghi thanh ghi st7538/7540
; 0000 024F 		        case COM_SET_CTR:
_0xA0:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xA4
; 0000 0250                 {
; 0000 0251                     // set control register (comm, byte0, byte1, byte2, byte3)
; 0000 0252 					ByteReverse((unsigned long*)&ucPacket[0]);
	LDI  R30,LOW(_ucPacket)
	LDI  R31,HIGH(_ucPacket)
	ST   -Y,R31
	ST   -Y,R30
	CALL _ByteReverse
; 0000 0253 					PLM_SetControlRegister(*((unsigned long*)&ucPacket[0]));
	LDS  R30,_ucPacket
	LDS  R31,_ucPacket+1
	LDS  R22,_ucPacket+2
	LDS  R23,_ucPacket+3
	CALL __PUTPARD1
	RCALL _PLM_SetControlRegister
; 0000 0254                     putchar('c');
	LDI  R30,LOW(99)
	ST   -Y,R30
	CALL _putchar
; 0000 0255 					break;
; 0000 0256 			    }
; 0000 0257                 case COM_SET_PLM:
_0xA4:
; 0000 0258                 {
; 0000 0259 //					PLM_Stop();
; 0000 025A 
; 0000 025B //					uiLastFCS = CalcCRC(&ucPacket[0], 72);
; 0000 025C //					*(unsigned int*)&ucPacket[72] = uiLastFCS;
; 0000 025D //
; 0000 025E //                    ucPostableBits = 8-((78 * 14) % 8);
; 0000 025F //
; 0000 0260                     // truyen khong co ack
; 0000 0261 //					PLM_TransmitData(74, 0);
; 0000 0262 //                    while(PLM_pinCD_PD == 1);
; 0000 0263 //                    pin_TASK = 1;
; 0000 0264 //					while(PLM_IsRunning() != 0);
; 0000 0265 //                    PLM_ReceiveData(74);
; 0000 0266 					break;
; 0000 0267 			    }
; 0000 0268                 case COM_GET_PLM:
; 0000 0269                 {
; 0000 026A //                    PLM_ReceiveData(74);
; 0000 026B 					break;
; 0000 026C 			    }
; 0000 026D             }
_0x9F:
; 0000 026E         }
; 0000 026F //        while(RS232_IsRunning()!=0);
; 0000 0270 //
; 0000 0271 //        delay_ms(100);
; 0000 0272 
; 0000 0273 //		if(PLM_IsRunning() != 0){
; 0000 0274 //            if(PLM_pinCD_PD == 0){
; 0000 0275 //                pin_TASK = 1;
; 0000 0276 //            }
; 0000 0277 //        }
; 0000 0278 
; 0000 0279 //        if(PLM_IsRunning()==0){
; 0000 027A //            if(!PLM_IsAck()){
; 0000 027B //                if(*(unsigned int*)&ucPacket[72] == CalcCRC(ucPacket, 72)){
; 0000 027C //                    RS232_SetData(ucPacket, 72);
; 0000 027D //                }
; 0000 027E //            }
; 0000 027F //        }
; 0000 0280     };
_0x9C:
	RJMP _0x95
; 0000 0281 }
_0xA7:
	RJMP _0xA7
;#include <mega32.h>
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
;#include <stdio.h>
;void IO_Init(void)
; 0001 0004 {

	.CSEG
_IO_Init:
; 0001 0005     // Port A initialization
; 0001 0006     // Func7=Out Func6=Out Func5=In Func4=Out Func3=Out Func2=In Func1=In Func0=In
; 0001 0007     // State7=0 State6=0 State5=T State4=0 State3=0 State2=T State1=T State0=T
; 0001 0008     PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0001 0009     DDRA=0xD8;
	LDI  R30,LOW(216)
	OUT  0x1A,R30
; 0001 000A 
; 0001 000B     // Port B initialization
; 0001 000C     // Func7=In Func6=Out Func5=In Func4=Out Func3=In Func2=In Func1=In Func0=In
; 0001 000D     // State7=T State6=0 State5=T State4=0 State3=T State2=T State1=T State0=T
; 0001 000E     PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0001 000F     DDRB=0x50;
	LDI  R30,LOW(80)
	OUT  0x17,R30
; 0001 0010 
; 0001 0011     // Port C initialization
; 0001 0012     // Func7=In Func6=Out Func5=Out Func4=In Func3=Out Func2=In Func1=In Func0=Out
; 0001 0013     // State7=T State6=0 State5=0 State4=T State3=0 State2=T State1=T State0=0
; 0001 0014     PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0001 0015     DDRC=0x69;
	LDI  R30,LOW(105)
	OUT  0x14,R30
; 0001 0016 
; 0001 0017     // Port D initialization
; 0001 0018     // Func7=Out Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=In
; 0001 0019     // State7=1 State6=T State5=T State4=T State3=P State2=T State1=0 State0=T
; 0001 001A     PORTD=0x88;
	LDI  R30,LOW(136)
	OUT  0x12,R30
; 0001 001B     DDRD=0x82;
	LDI  R30,LOW(130)
	OUT  0x11,R30
; 0001 001C }
	RET
;
;void TimerCounter_Init(void){
; 0001 001E void TimerCounter_Init(void){
_TimerCounter_Init:
; 0001 001F     // Timer/Counter 0 initialization
; 0001 0020     // Clock source: System Clock
; 0001 0021     // Clock value: Timer 0 Stopped
; 0001 0022     // Mode: Normal top=FFh
; 0001 0023     // OC0 output: Disconnected
; 0001 0024     TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0001 0025     TCNT0=0x00;
	OUT  0x32,R30
; 0001 0026     OCR0=0x00;
	OUT  0x3C,R30
; 0001 0027 
; 0001 0028     // Timer/Counter 1 initialization
; 0001 0029     // Clock source: System Clock
; 0001 002A     // Clock value: Timer 1 Stopped
; 0001 002B     // Mode: Normal top=FFFFh
; 0001 002C     // OC1A output: Discon.
; 0001 002D     // OC1B output: Discon.
; 0001 002E     // Noise Canceler: Off
; 0001 002F     // Input Capture on Falling Edge
; 0001 0030     // Timer 1 Overflow Interrupt: Off
; 0001 0031     // Input Capture Interrupt: Off
; 0001 0032     // Compare A Match Interrupt: Off
; 0001 0033     // Compare B Match Interrupt: Off
; 0001 0034     TCCR1A=0x00;
	OUT  0x2F,R30
; 0001 0035     TCCR1B=0x00;
	OUT  0x2E,R30
; 0001 0036     TCNT1H=0x00;
	OUT  0x2D,R30
; 0001 0037     TCNT1L=0x00;
	OUT  0x2C,R30
; 0001 0038     ICR1H=0x00;
	OUT  0x27,R30
; 0001 0039     ICR1L=0x00;
	OUT  0x26,R30
; 0001 003A     OCR1AH=0x00;
	OUT  0x2B,R30
; 0001 003B     OCR1AL=0x00;
	OUT  0x2A,R30
; 0001 003C     OCR1BH=0x00;
	OUT  0x29,R30
; 0001 003D     OCR1BL=0x00;
	OUT  0x28,R30
; 0001 003E 
; 0001 003F     // Timer/Counter 2 initialization
; 0001 0040     // Clock source: System Clock
; 0001 0041     // Clock value: Timer 2 Stopped
; 0001 0042     // Mode: Normal top=FFh
; 0001 0043     // OC2 output: Disconnected
; 0001 0044     ASSR=0x00;
	OUT  0x22,R30
; 0001 0045     TCCR2=0x00;
	OUT  0x25,R30
; 0001 0046     TCNT2=0x00;
	OUT  0x24,R30
; 0001 0047     OCR2=0x00;
	OUT  0x23,R30
; 0001 0048 
; 0001 0049 
; 0001 004A }
	RET
;
;void ExtInterupt_Init(void){
; 0001 004C void ExtInterupt_Init(void){
_ExtInterupt_Init:
; 0001 004D     // External Interrupt(s) initialization
; 0001 004E     // INT0: Off
; 0001 004F     // INT1: On
; 0001 0050     // INT1 Mode: Low level
; 0001 0051     // INT2: Off
; 0001 0052     GICR|=0x80;
	IN   R30,0x3B
	LDI  R31,0
	ORI  R30,0x80
	OUT  0x3B,R30
; 0001 0053     MCUCR=0x00;
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0001 0054     MCUCSR=0x00;
	OUT  0x34,R30
; 0001 0055     GIFR=0x80;
	LDI  R30,LOW(128)
	OUT  0x3A,R30
; 0001 0056 
; 0001 0057     // Timer(s)/Counter(s) Interrupt(s) initialization
; 0001 0058     TIMSK=0x00;
	LDI  R30,LOW(0)
	OUT  0x39,R30
; 0001 0059 
; 0001 005A     // Analog Comparator initialization
; 0001 005B     // Analog Comparator: Off
; 0001 005C     // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0001 005D     ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0001 005E     SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0001 005F     // Global enable interrupts
; 0001 0060     #asm("sei")
	sei
; 0001 0061 
; 0001 0062 
; 0001 0063 }
	RET
;
;void SPI_Init(void){
; 0001 0065 void SPI_Init(void){
; 0001 0066     // SPI initialization
; 0001 0067     // SPI Type: Slave
; 0001 0068     // SPI Clock Rate: 2764.800 kHz
; 0001 0069     // SPI Clock Phase: Cycle Half
; 0001 006A     // SPI Clock Polarity: Low
; 0001 006B     // SPI Data Order: MSB First
; 0001 006C     SPCR=0xC0;
; 0001 006D     SPSR=0x00;
; 0001 006E 
; 0001 006F     // Clear the SPI interrupt flag
; 0001 0070     #asm
; 0001 0071     in   r30,spsr
; 0001 0072     in   r30,spdr
; 0001 0073     #endasm
; 0001 0074 
; 0001 0075 
; 0001 0076 }
;
;
;void RS232_Init(void){
; 0001 0079 void RS232_Init(void){
_RS232_Init:
; 0001 007A     // USART initialization
; 0001 007B     // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0001 007C     // USART Receiver: On
; 0001 007D     // USART Transmitter: On
; 0001 007E     // USART Mode: Asynchronous
; 0001 007F     // USART Baud Rate: 9600
; 0001 0080     UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0001 0081     UCSRB=0xD8;
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0001 0082     UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0001 0083     UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0001 0084     UBRRL=0x47;
	LDI  R30,LOW(71)
	OUT  0x9,R30
; 0001 0085 }
	RET
;#include <mega32.h>
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
;#include <stdio.h>
;
;#define UPE     2
;#define FE      4
;#define UDRE    5
;#define RXB8    1
;#define TXB8    0
;#define OVR     3
;#define RXC     7
;#define TXC     6
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<OVR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;#define TX_COMPLETE (1<<TXC)
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 255
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE<256
;unsigned char rx_wr_index,rx_rd_index,rx_counter;
;#else
;unsigned int rx_wr_index,rx_rd_index,rx_counter;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0002 0022 {

	.CSEG
_usart_rx_isr:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0002 0023 
; 0002 0024     char status,data;
; 0002 0025     status=UCSRA;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0002 0026     data=UDR;
	IN   R16,12
; 0002 0027     if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R26,R17
	LDI  R27,0
	LDI  R30,LOW(28)
	LDI  R31,HIGH(28)
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BRNE _0x40003
; 0002 0028     {
; 0002 0029         rx_buffer[rx_wr_index]=data;
	MOV  R30,R5
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0002 002A 
; 0002 002B         if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	INC  R5
	LDI  R30,LOW(255)
	CP   R30,R5
	BRNE _0x40004
	CLR  R5
; 0002 002C         if (++rx_counter == RX_BUFFER_SIZE)
_0x40004:
	INC  R7
	LDI  R30,LOW(255)
	CP   R30,R7
	BRNE _0x40005
; 0002 002D         {
; 0002 002E             rx_counter=0;
	CLR  R7
; 0002 002F             rx_buffer_overflow=1;
	SET
	BLD  R2,2
; 0002 0030         };
_0x40005:
; 0002 0031     };
_0x40003:
; 0002 0032 }
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0002 0039 {
_getchar:
; 0002 003A     char data;
; 0002 003B     while (rx_counter==0);
	ST   -Y,R17
;	data -> R17
_0x40006:
	TST  R7
	BREQ _0x40006
; 0002 003C     data=rx_buffer[rx_rd_index];
	MOV  R30,R4
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	LD   R17,Z
; 0002 003D     if (++rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
	INC  R4
	LDI  R30,LOW(255)
	CP   R30,R4
	BRNE _0x40009
	CLR  R4
; 0002 003E     #asm("cli")
_0x40009:
	cli
; 0002 003F     --rx_counter;
	DEC  R7
; 0002 0040     #asm("sei")
	sei
; 0002 0041     return data;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0002 0042 }
;#pragma used-
;#endif
;
;// USART Transmitter buffer
;#define TX_BUFFER_SIZE 255
;char tx_buffer[TX_BUFFER_SIZE];
;
;#if TX_BUFFER_SIZE<256
;unsigned char tx_wr_index,tx_rd_index,tx_counter;
;#else
;static unsigned int tx_wr_index,tx_rd_index,tx_counter;
;#endif
;
;// USART Transmitter interrupt service routine
;interrupt [USART_TXC] void usart_tx_isr(void)
; 0002 0052 {
_usart_tx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0002 0053     if (tx_counter)
	TST  R8
	BREQ _0x4000A
; 0002 0054     {
; 0002 0055         --tx_counter;
	DEC  R8
; 0002 0056         UDR=tx_buffer[tx_rd_index];
	MOV  R30,R9
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R30,Z
	OUT  0xC,R30
; 0002 0057         if (++tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	INC  R9
	LDI  R30,LOW(255)
	CP   R30,R9
	BRNE _0x4000B
	CLR  R9
; 0002 0058     };
_0x4000B:
_0x4000A:
; 0002 0059 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0002 0060 {
_putchar:
; 0002 0061     while (tx_counter == TX_BUFFER_SIZE);
;	c -> Y+0
_0x4000C:
	LDI  R30,LOW(255)
	CP   R30,R8
	BREQ _0x4000C
; 0002 0062     #asm("cli")
	cli
; 0002 0063     if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
	TST  R8
	BRNE _0x40010
	IN   R30,0xB
	LDI  R31,0
	ANDI R30,LOW(0x20)
	BRNE _0x4000F
_0x40010:
; 0002 0064     {
; 0002 0065         tx_buffer[tx_wr_index]=c;
	MOV  R30,R6
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R26,Y
	STD  Z+0,R26
; 0002 0066         if (++tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
	INC  R6
	LDI  R30,LOW(255)
	CP   R30,R6
	BRNE _0x40012
	CLR  R6
; 0002 0067         ++tx_counter;
_0x40012:
	INC  R8
; 0002 0068     }
; 0002 0069     else
	RJMP _0x40013
_0x4000F:
; 0002 006A         UDR=c;
	LD   R30,Y
	OUT  0xC,R30
; 0002 006B     #asm("sei")
_0x40013:
	sei
; 0002 006C }
	ADIW R28,1
	RET
;#pragma used-
;#endif
;
;
;unsigned char RS232_IsRunning(void){
; 0002 0071 unsigned char RS232_IsRunning(void){
_RS232_IsRunning:
; 0002 0072     return (unsigned char) rx_counter;
	MOV  R30,R7
	RET
; 0002 0073 }
;#include <mega32.h>
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
;void ByteReverse(unsigned long* pul){
; 0003 0002 void ByteReverse(unsigned long* pul){

	.CSEG
_ByteReverse:
; 0003 0003     unsigned char uc;
; 0003 0004 
; 0003 0005     uc = *((unsigned char*)pul + 0);                                // msb
	ST   -Y,R17
;	*pul -> Y+1
;	uc -> R17
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,0
	LD   R17,X
; 0003 0006     *((unsigned char*)pul + 0) = *((unsigned char*)pul + 3);        // lsb
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,3
	LD   R30,X
	__PUTB1SNS 1,0
; 0003 0007     *((unsigned char*)pul + 3) = uc;
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	__PUTBZR 17,3
; 0003 0008 
; 0003 0009     uc = *((unsigned char*)(pul) + 1);                                // msb
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,1
	LD   R17,X
; 0003 000A     *((unsigned char*)pul + 1) = *((unsigned char*)pul + 2);        // lsb
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,2
	LD   R30,X
	__PUTB1SNS 1,1
; 0003 000B     *((unsigned char*)pul + 2) = uc;
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	__PUTBZR 17,2
; 0003 000C }
	LDD  R17,Y+0
	ADIW R28,3
	RET
;
;unsigned char Sum(unsigned char* pucBuffer, unsigned char ucLength){
; 0003 000E unsigned char Sum(unsigned char* pucBuffer, unsigned char ucLength){
; 0003 000F     unsigned char    uc,
; 0003 0010                     ucSum = 0x00;
; 0003 0011 
; 0003 0012     for(uc = 0; uc < ucLength; uc++){
;	*pucBuffer -> Y+3
;	ucLength -> Y+2
;	uc -> R17
;	ucSum -> R16
; 0003 0013         ucSum += pucBuffer[uc];
; 0003 0014     }
; 0003 0015 
; 0003 0016     return ucSum;
; 0003 0017 }

	.CSEG
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

	.CSEG

	.CSEG

	.DSEG
_ucPacket:
	.BYTE 0x10E
_ucIndex:
	.BYTE 0x1
_ucLength:
	.BYTE 0x1
_ucRS232Started:
	.BYTE 0x1
_ucCommand:
	.BYTE 0x1
_ucPostableBits:
	.BYTE 0x1
_ucState:
	.BYTE 0x1
_ucByteCounter:
	.BYTE 0x1
_ucBitCounter:
	.BYTE 0x1
_ucCorrectionCounter:
	.BYTE 0x1
_ucByte_S0000000:
	.BYTE 0x1
_ucFec_S0000000:
	.BYTE 0x1
_rx_buffer:
	.BYTE 0xFF
_tx_buffer:
	.BYTE 0xFF
_p_S1000024:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	BLD  R2,1
	LDS  R30,_ucState
	LDI  R31,0
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0x1:
	LDS  R30,_ucByte_S0000000
	LDI  R31,0
	LSL  R30
	ROL  R31
	MOVW R26,R30
	LDI  R30,0
	SBIC 0x16,5
	LDI  R30,1
	LDI  R31,0
	OR   R30,R26
	STS  _ucByte_S0000000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x2:
	LDS  R30,_ucBitCounter
	SUBI R30,LOW(1)
	STS  _ucBitCounter,R30
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3:
	LDS  R30,_ucIndex
	SUBI R30,-LOW(1)
	STS  _ucIndex,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_ucPacket)
	SBCI R31,HIGH(-_ucPacket)
	LDS  R26,_ucByte_S0000000
	STD  Z+0,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(8)
	STS  _ucBitCounter,R30
	LDS  R30,_ucByteCounter
	SUBI R30,LOW(1)
	STS  _ucByteCounter,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5:
	BLD  R2,0
	LDI  R30,LOW(8)
	STS  _ucBitCounter,R30
	LDS  R30,_ucState
	SUBI R30,-LOW(1)
	STS  _ucState,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(8)
	STS  _ucBitCounter,R30
	LDI  R30,LOW(0)
	STS  _ucFec_S0000000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x7:
	LDS  R30,_ucBitCounter
	SUBI R30,LOW(1)
	STS  _ucBitCounter,R30
	LDS  R30,_ucFec_S0000000
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	LDI  R31,0
	OR   R30,R26
	STS  _ucFec_S0000000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:36 WORDS
SUBOPT_0x9:
	LDS  R30,_ucFec_S0000000
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xA:
	LDI  R26,LOW(57)
	LDI  R27,HIGH(57)
	EOR  R30,R26
	STS  _ucFec_S0000000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(6)
	STS  _ucBitCounter,R30
	LDS  R30,_ucState
	SUBI R30,-LOW(1)
	STS  _ucState,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0xC:
	LDS  R30,_ucIndex
	SUBI R30,-LOW(1)
	STS  _ucIndex,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_ucPacket)
	SBCI R31,HIGH(-_ucPacket)
	LD   R30,Z
	STS  _ucByte_S0000000,R30
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xD:
	LDS  R30,_ucByte_S0000000
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	LSL  R30
	ROL  R31
	STS  _ucByte_S0000000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	LDS  R30,_ucBitCounter
	SUBI R30,LOW(1)
	STS  _ucBitCounter,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(8)
	STS  _ucBitCounter,R30
	LDS  R30,_ucState
	SUBI R30,-LOW(1)
	STS  _ucState,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	STS  _ucBitCounter,R30
	LDI  R30,LOW(3)
	STS  _ucByteCounter,R30
	SBI  0x15,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	__GETD1N 0x1C321800
	CALL __PUTPARD1
	JMP  _PLM_SetControlRegister

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xACD
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

;END OF CODE MARKER
__END_OF_CODE:
