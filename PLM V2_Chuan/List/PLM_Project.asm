
;CodeVisionAVR C Compiler V2.03.4 Standard
;(C) Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 16.000000 MHz
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
	JMP  0x00
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
_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x3:
	.DB  0x24

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  _iMaxLength
	.DW  _0x3*2

_0xFFFFFFFF:
	.DW  0

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

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

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
;� Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
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
;extern void RS232_Init(void);
;extern void putchar(char c);
;extern char getchar(void);
;extern unsigned char RS232_IsRunning(void);
;extern void ByteReverse(unsigned long* pul);
;//extern unsigned int CalcCRC(unsigned char *pucBuffer, unsigned char ucLength);
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
;volatile int iMaxLength = 36;

	.DSEG
;// chuyen tu ham plm_ack ra, ban dau la kieu static
;
;volatile unsigned char ucState;
;volatile unsigned char ucByteCounter;
;volatile unsigned char ucBitCounter;
;volatile unsigned char ucCorrectionCounter;
;//volatile unsigned int  uiLastFCS;
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
;
;
;
;//cong viec plm thuc hien
;void PLM_Task(void){
; 0000 004A void PLM_Task(void){

	.CSEG
_PLM_Task:
; 0000 004B     static unsigned char ucByte,
; 0000 004C                          ucFec;
; 0000 004D     static bit bLastCLRT;
; 0000 004E //    PLM_pinWD = ~PLM_pinWD;
; 0000 004F     if(PLM_pinCLRT){                                                // PLM clock is 1
	SBIS 0x16,7
	RJMP _0x4
; 0000 0050         if(!bLastCLRT){                                                // transition 0 -> 1
	SBRC R2,1
	RJMP _0x5
; 0000 0051             bLastCLRT = 1;                                            // update last CLRT value
	SET
	CALL SUBOPT_0x0
; 0000 0052 
; 0000 0053             switch(ucState){
; 0000 0054                 case PLM_STOP:
	BRNE _0x9
; 0000 0055                     break;
	RJMP _0x8
; 0000 0056 
; 0000 0057                 // trang thai doc thanh ghi
; 0000 0058                 case PLM_RX_REG:{
_0x9:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xA
; 0000 0059                     ucByte = (ucByte << 1) | PLM_pinRxD;            // receive 1 bit and store it
	CALL SUBOPT_0x1
; 0000 005A                     ucBitCounter--;
	CALL SUBOPT_0x2
; 0000 005B 
; 0000 005C                     if(!ucBitCounter){
	BRNE _0xB
; 0000 005D                         ucPacket[ucIndex++] = ucByte;
	CALL SUBOPT_0x3
; 0000 005E                         ucBitCounter = 8;
	CALL SUBOPT_0x4
; 0000 005F                         ucByteCounter--;
; 0000 0060 
; 0000 0061                         if(!ucByteCounter){
	LDS  R30,_ucByteCounter
	CPI  R30,0
	BRNE _0xC
; 0000 0062                             ucState = PLM_STOP;                        // stop PLM
	RJMP _0x2060001
; 0000 0063 
; 0000 0064                             PLM_pinRXTX = 1;                        // Rx session
; 0000 0065                             PLM_pinREG_DATA = 0;                    // mains access
; 0000 0066 
; 0000 0067                             return;
; 0000 0068                         }
; 0000 0069                     }
_0xC:
; 0000 006A 
; 0000 006B                     break;
_0xB:
	RJMP _0x8
; 0000 006C                 }
; 0000 006D 
; 0000 006E                 // trang thai doi preamable
; 0000 006F                 case PLM_RX_PREAMBLE:{
_0xA:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x11
; 0000 0070                     ucState++;
	LDS  R30,_ucState
	SUBI R30,-LOW(1)
	RJMP _0xAA
; 0000 0071                     break;
; 0000 0072                 }
; 0000 0073 
; 0000 0074                 // trang thai doc header high (kiem tra xem la data hay ack)
; 0000 0075                 case PLM_RX_HEADER_HIGH:{
_0x11:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x12
; 0000 0076                     ucByte = (ucByte << 1) | PLM_pinRxD;            // receive 1 bit and store it
	CALL SUBOPT_0x1
; 0000 0077 
; 0000 0078                     if(ucByte == HEADER_HIGH_ACK){
	LDS  R26,_ucByte_S0000000
	CPI  R26,LOW(0xE9)
	BRNE _0x13
; 0000 0079                         bAck = 1;
	SET
	CALL SUBOPT_0x5
; 0000 007A 
; 0000 007B                         ucBitCounter = 8;
; 0000 007C                         ucState++;
; 0000 007D                     }
; 0000 007E 
; 0000 007F                     if(ucByte == HEADER_HIGH_DATA){
_0x13:
	LDS  R26,_ucByte_S0000000
	CPI  R26,LOW(0x9B)
	BRNE _0x14
; 0000 0080                         bAck = 0;
	CLT
	CALL SUBOPT_0x5
; 0000 0081 
; 0000 0082                         ucBitCounter = 8;
; 0000 0083                         ucState++;
; 0000 0084                     }
; 0000 0085 
; 0000 0086                     break;
_0x14:
	RJMP _0x8
; 0000 0087                 }
; 0000 0088 
; 0000 0089                 // trang thai doc header low
; 0000 008A                 case PLM_RX_HEADER_LOW:{
_0x12:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x15
; 0000 008B                     ucByte = (ucByte << 1) | PLM_pinRxD;            // receive 1 bit and store it
	CALL SUBOPT_0x1
; 0000 008C                     ucBitCounter--;
	CALL SUBOPT_0x2
; 0000 008D 
; 0000 008E                     if(!ucBitCounter){
	BRNE _0x16
; 0000 008F                         if(ucByte == HEADER_LOW){
	LDS  R26,_ucByte_S0000000
	CPI  R26,LOW(0x58)
	BRNE _0x17
; 0000 0090                             if(bAck){
	SBRS R2,0
	RJMP _0x18
; 0000 0091                                 ucByteCounter = 3;                    // only FCS
	LDI  R30,LOW(3)
	STS  _ucByteCounter,R30
; 0000 0092                             }
; 0000 0093 
; 0000 0094                             ucBitCounter = 8;
_0x18:
	LDI  R30,LOW(8)
	STS  _ucBitCounter,R30
; 0000 0095                             //ucFec = 0;
; 0000 0096                             ucState = PLM_RX_LENGTH;
	LDI  R30,LOW(17)
	RJMP _0xAB
; 0000 0097                             //ucState++;
; 0000 0098                         }
; 0000 0099                         else{
_0x17:
; 0000 009A                             ucState = PLM_RX_PREAMBLE;
	LDI  R30,LOW(9)
_0xAB:
	STS  _ucState,R30
; 0000 009B                         }
; 0000 009C                     }
; 0000 009D                     break;
_0x16:
	RJMP _0x8
; 0000 009E                 }
; 0000 009F 
; 0000 00A0                 // trang thai doc do dai cua khung
; 0000 00A1                 case PLM_RX_LENGTH:{
_0x15:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BRNE _0x1A
; 0000 00A2                     ucByte = (ucByte << 1) | PLM_pinRxD;            // receive 1 bit and store it
	CALL SUBOPT_0x1
; 0000 00A3                     ucBitCounter--;
	CALL SUBOPT_0x2
; 0000 00A4 
; 0000 00A5                     if(!ucBitCounter){
	BRNE _0x1B
; 0000 00A6                         ucLength = ucByte;
	LDS  R30,_ucByte_S0000000
	STS  _ucLength,R30
; 0000 00A7                         ucByteCounter = ucByte;
	LDS  R30,_ucByte_S0000000
	STS  _ucByteCounter,R30
; 0000 00A8                         ucBitCounter = 8;
	LDI  R30,LOW(8)
	STS  _ucBitCounter,R30
; 0000 00A9                         ucState = PLM_RX_DATA;
	LDI  R30,LOW(12)
	STS  _ucState,R30
; 0000 00AA                         ucFec = 0;
	LDI  R30,LOW(0)
	STS  _ucFec_S0000000,R30
; 0000 00AB                         //ucState++;
; 0000 00AC                     }
; 0000 00AD                     break;
_0x1B:
	RJMP _0x8
; 0000 00AE                 }
; 0000 00AF 
; 0000 00B0                 // trang thai doc data
; 0000 00B1                 case PLM_RX_DATA:{
_0x1A:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x1C
; 0000 00B2                     ucByte = (ucByte << 1) | PLM_pinRxD;            // receive 1 bit and store it
	CALL SUBOPT_0x1
; 0000 00B3                     ucBitCounter--;
	CALL SUBOPT_0x6
; 0000 00B4 
; 0000 00B5                     ucFec = (ucFec << 1) | PLM_pinRxD;
	LSL  R30
	ROL  R31
	MOVW R26,R30
	LDI  R30,0
	SBIC 0x16,5
	LDI  R30,1
	CALL SUBOPT_0x7
; 0000 00B6                     if(ucFec & 0x40){
	CALL SUBOPT_0x8
	ANDI R30,LOW(0x40)
	BREQ _0x1D
; 0000 00B7                         ucFec ^= 0x39;
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0000 00B8                     }
; 0000 00B9 
; 0000 00BA                     if(!ucBitCounter){
_0x1D:
	LDS  R30,_ucBitCounter
	CPI  R30,0
	BRNE _0x1E
; 0000 00BB                         ucBitCounter = 6;
	CALL SUBOPT_0xA
; 0000 00BC                         ucState++;
; 0000 00BD                     }
; 0000 00BE 
; 0000 00BF                     break;
_0x1E:
	RJMP _0x8
; 0000 00C0                 }
; 0000 00C1 
; 0000 00C2                 // trang thai sua loi
; 0000 00C3                 case PLM_RX_FEC:{
_0x1C:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x8
; 0000 00C4                     ucFec = (ucFec << 1) | ~PLM_pinRxD;
	CALL SUBOPT_0x8
	LSL  R30
	ROL  R31
	MOVW R26,R30
	LDI  R30,0
	SBIS 0x16,5
	LDI  R30,1
	CALL SUBOPT_0x7
; 0000 00C5                     ucBitCounter--;
	CALL SUBOPT_0x6
; 0000 00C6 
; 0000 00C7                     if(ucFec & 0x40){
	ANDI R30,LOW(0x40)
	BREQ _0x20
; 0000 00C8                         ucFec ^= 0x39;
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0000 00C9                     }
; 0000 00CA 
; 0000 00CB                     if(!ucBitCounter){
_0x20:
	LDS  R30,_ucBitCounter
	CPI  R30,0
	BRNE _0x21
; 0000 00CC                         ucFec &= 0x3f;
	CALL SUBOPT_0x8
	ANDI R30,LOW(0x3F)
	ANDI R31,HIGH(0x3F)
	STS  _ucFec_S0000000,R30
; 0000 00CD                         if(ucFec){
	CPI  R30,0
	BREQ _0x22
; 0000 00CE                             ucByte ^= ucCRC[ucFec];
	LDS  R26,_ucByte_S0000000
	CLR  R27
	CALL SUBOPT_0x8
	SUBI R30,LOW(-_ucCRC*2)
	SBCI R31,HIGH(-_ucCRC*2)
	LPM  R30,Z
	LDI  R31,0
	EOR  R30,R26
	STS  _ucByte_S0000000,R30
; 0000 00CF                             ucCorrectionCounter++;
	LDS  R30,_ucCorrectionCounter
	SUBI R30,-LOW(1)
	STS  _ucCorrectionCounter,R30
; 0000 00D0                         }
; 0000 00D1 
; 0000 00D2                         ucPacket[ucIndex++] = ucByte;
_0x22:
	CALL SUBOPT_0x3
; 0000 00D3                         ucByteCounter--;
	LDS  R30,_ucByteCounter
	SUBI R30,LOW(1)
	STS  _ucByteCounter,R30
; 0000 00D4 
; 0000 00D5                         if(!ucByteCounter){
	LDS  R30,_ucByteCounter
	CPI  R30,0
	BREQ _0x2060001
; 0000 00D6                             ucState = PLM_STOP;                        // stop PLM
; 0000 00D7 
; 0000 00D8                             PLM_pinRXTX = 1;                        // Rx session
; 0000 00D9                             PLM_pinREG_DATA = 0;                    // mains access
; 0000 00DA 
; 0000 00DB                             return;
; 0000 00DC                         }
; 0000 00DD 
; 0000 00DE                         ucBitCounter = 8;
	LDI  R30,LOW(8)
	STS  _ucBitCounter,R30
; 0000 00DF                         ucFec = 0;
	LDI  R30,LOW(0)
	STS  _ucFec_S0000000,R30
; 0000 00E0                         ucState = PLM_RX_DATA;
	LDI  R30,LOW(12)
_0xAA:
	STS  _ucState,R30
; 0000 00E1                     }
; 0000 00E2 
; 0000 00E3                     break;
_0x21:
; 0000 00E4                 }
; 0000 00E5             }
_0x8:
; 0000 00E6         }
; 0000 00E7     }
_0x5:
; 0000 00E8     else{                                                            // PLM clock is 0
	RJMP _0x28
_0x4:
; 0000 00E9         if(bLastCLRT){                                                // transition 1 -> 0
	SBRS R2,1
	RJMP _0x29
; 0000 00EA             bLastCLRT = 0;                                            // update last CLRT value
	CLT
	CALL SUBOPT_0x0
; 0000 00EB 
; 0000 00EC             switch(ucState){
; 0000 00ED                 case PLM_STOP:
	BRNE _0x2D
; 0000 00EE                     break;
	RJMP _0x2C
; 0000 00EF 
; 0000 00F0                 // trang thai ghi thanh ghi
; 0000 00F1                 case PLM_TX_REG:{
_0x2D:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2E
; 0000 00F2                     if(!ucBitCounter){
	LDS  R30,_ucBitCounter
	CPI  R30,0
	BRNE _0x2F
; 0000 00F3                         if(ucByteCounter){
	LDS  R30,_ucByteCounter
	CPI  R30,0
	BREQ _0x30
; 0000 00F4                             ucByte = ucPacket[ucIndex++];
	CALL SUBOPT_0xB
; 0000 00F5                             ucBitCounter = 8;
; 0000 00F6                             ucByteCounter--;
; 0000 00F7                         }
; 0000 00F8                         else{
	RJMP _0x31
_0x30:
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
_0x31:
; 0000 0100                     }
; 0000 0101                     PLM_pinTxD = ucByte & 0x80;                        // transmit 1 bit
_0x2F:
	CALL SUBOPT_0xC
	ANDI R30,LOW(0x80)
	ANDI R31,HIGH(0x80)
	CPI  R30,0
	BRNE _0x36
	CBI  0x18,6
	RJMP _0x37
_0x36:
	SBI  0x18,6
_0x37:
; 0000 0102                     ucByte <<= 1;
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
; 0000 0103                     ucBitCounter--;
	CALL SUBOPT_0xE
; 0000 0104 
; 0000 0105                     break;
	RJMP _0x2C
; 0000 0106                 }
; 0000 0107 
; 0000 0108                 // trang thai truyen preamable
; 0000 0109                 case PLM_TX_PREAMBLE:{
_0x2E:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x38
; 0000 010A                     PLM_pinTxD = --ucBitCounter & 0x01 ;
	CALL SUBOPT_0xE
	LDI  R31,0
	ANDI R30,LOW(0x1)
	BRNE _0x39
	CBI  0x18,6
	RJMP _0x3A
_0x39:
	SBI  0x18,6
_0x3A:
; 0000 010B 
; 0000 010C                     if(!ucBitCounter){
	LDS  R30,_ucBitCounter
	CPI  R30,0
	BRNE _0x3B
; 0000 010D                         if(bAck){
	SBRS R2,0
	RJMP _0x3C
; 0000 010E                             ucByte = HEADER_HIGH_ACK;
	LDI  R30,LOW(233)
	RJMP _0xAC
; 0000 010F                         }
; 0000 0110                         else{
_0x3C:
; 0000 0111                             ucByte = HEADER_HIGH_DATA;
	LDI  R30,LOW(155)
_0xAC:
	STS  _ucByte_S0000000,R30
; 0000 0112                         }
; 0000 0113                         ucBitCounter = 8;
	CALL SUBOPT_0xF
; 0000 0114 
; 0000 0115                         ucState++;
; 0000 0116                     }
; 0000 0117                     break;
_0x3B:
	RJMP _0x2C
; 0000 0118                 }
; 0000 0119 
; 0000 011A                 // trang thai truyen header high bao xem co phai la ack khong
; 0000 011B                 case PLM_TX_HEADER_HIGH:{
_0x38:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x3E
; 0000 011C                     PLM_pinTxD = ucByte & 0x80;
	CALL SUBOPT_0xC
	ANDI R30,LOW(0x80)
	ANDI R31,HIGH(0x80)
	CPI  R30,0
	BRNE _0x3F
	CBI  0x18,6
	RJMP _0x40
_0x3F:
	SBI  0x18,6
_0x40:
; 0000 011D                     ucByte <<= 1;
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
; 0000 011E                     ucBitCounter--;
	CALL SUBOPT_0x2
; 0000 011F 
; 0000 0120                     if(!ucBitCounter){
	BRNE _0x41
; 0000 0121                         ucByte = HEADER_LOW;
	LDI  R30,LOW(88)
	STS  _ucByte_S0000000,R30
; 0000 0122                         ucBitCounter = 8;
	CALL SUBOPT_0xF
; 0000 0123                         ucState++;
; 0000 0124                     }
; 0000 0125                     break;
_0x41:
	RJMP _0x2C
; 0000 0126                 }
; 0000 0127 
; 0000 0128                 // trang thai truyen header low
; 0000 0129                 case PLM_TX_HEADER_LOW:{
_0x3E:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x42
; 0000 012A                     PLM_pinTxD = ucByte & 0x80;
	CALL SUBOPT_0xC
	ANDI R30,LOW(0x80)
	ANDI R31,HIGH(0x80)
	CPI  R30,0
	BRNE _0x43
	CBI  0x18,6
	RJMP _0x44
_0x43:
	SBI  0x18,6
_0x44:
; 0000 012B                     ucByte <<= 1;
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
; 0000 012C                     ucBitCounter--;
	CALL SUBOPT_0x2
; 0000 012D 
; 0000 012E                     if(!ucBitCounter){
	BRNE _0x45
; 0000 012F                         ucByte = ucLength;
	LDS  R30,_ucLength
	STS  _ucByte_S0000000,R30
; 0000 0130                         //ucByte = ucPacket[ucIndex++];
; 0000 0131                         ucBitCounter = 8;
	LDI  R30,LOW(8)
	STS  _ucBitCounter,R30
; 0000 0132                         ucState = PLM_TX_LENGTH;
	LDI  R30,LOW(16)
	STS  _ucState,R30
; 0000 0133                         //ucByteCounter--;
; 0000 0134                         //ucFec = 0;
; 0000 0135                         //ucState++;
; 0000 0136                     }
; 0000 0137 
; 0000 0138                     break;
_0x45:
	RJMP _0x2C
; 0000 0139                 }
; 0000 013A 
; 0000 013B                 // trang thai truyen do dai
; 0000 013C                 case PLM_TX_LENGTH:{
_0x42:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0x46
; 0000 013D                     PLM_pinTxD = ucByte & 0x80;
	CALL SUBOPT_0xC
	ANDI R30,LOW(0x80)
	ANDI R31,HIGH(0x80)
	CPI  R30,0
	BRNE _0x47
	CBI  0x18,6
	RJMP _0x48
_0x47:
	SBI  0x18,6
_0x48:
; 0000 013E                     ucByte <<= 1;
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
; 0000 013F                     ucBitCounter--;
	CALL SUBOPT_0x2
; 0000 0140 
; 0000 0141                     if(!ucBitCounter){
	BRNE _0x49
; 0000 0142                         //ucByte = ucLength;
; 0000 0143                         ucByte = ucPacket[ucIndex++];
	CALL SUBOPT_0xB
; 0000 0144                         ucBitCounter = 8;
; 0000 0145                         ucByteCounter--;
; 0000 0146                         ucFec = 0;
	LDI  R30,LOW(0)
	STS  _ucFec_S0000000,R30
; 0000 0147                         ucState = PLM_TX_DATA;
	LDI  R30,LOW(6)
	STS  _ucState,R30
; 0000 0148                         //ucState++;
; 0000 0149                     }
; 0000 014A 
; 0000 014B                     break;
_0x49:
	RJMP _0x2C
; 0000 014C                 }
; 0000 014D 
; 0000 014E                 // trang thai truyen data
; 0000 014F                 case PLM_TX_DATA:{
_0x46:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x4A
; 0000 0150                     PLM_pinTxD = ucByte & 0x80;
	CALL SUBOPT_0xC
	ANDI R30,LOW(0x80)
	ANDI R31,HIGH(0x80)
	CPI  R30,0
	BRNE _0x4B
	CBI  0x18,6
	RJMP _0x4C
_0x4B:
	SBI  0x18,6
_0x4C:
; 0000 0151                     ucByte <<= 1;
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
; 0000 0152                     ucBitCounter--;
	CALL SUBOPT_0x6
; 0000 0153 
; 0000 0154                     ucFec = (ucFec << 1) | PLM_pinTxD;
	LSL  R30
	ROL  R31
	MOVW R26,R30
	LDI  R30,0
	SBIC 0x18,6
	LDI  R30,1
	CALL SUBOPT_0x7
; 0000 0155                     if(ucFec & 0x40){
	CALL SUBOPT_0x8
	ANDI R30,LOW(0x40)
	BREQ _0x4D
; 0000 0156                         ucFec ^= 0x39;
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0000 0157                     }
; 0000 0158 
; 0000 0159                     if(!ucBitCounter){
_0x4D:
	LDS  R30,_ucBitCounter
	CPI  R30,0
	BRNE _0x4E
; 0000 015A                         ucBitCounter = 6;
	LDI  R30,LOW(6)
	STS  _ucBitCounter,R30
; 0000 015B                         while(ucBitCounter){
_0x4F:
	LDS  R30,_ucBitCounter
	CPI  R30,0
	BREQ _0x51
; 0000 015C                             ucFec <<= 1;
	CALL SUBOPT_0x8
	LSL  R30
	ROL  R31
	STS  _ucFec_S0000000,R30
; 0000 015D                             if(ucFec & 0x40){
	CALL SUBOPT_0x8
	ANDI R30,LOW(0x40)
	BREQ _0x52
; 0000 015E                                 ucFec ^= 0x39;
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0000 015F                             }
; 0000 0160                             ucBitCounter--;
_0x52:
	CALL SUBOPT_0xE
; 0000 0161                         }
	RJMP _0x4F
_0x51:
; 0000 0162                         ucFec ^= 0xff;
	CALL SUBOPT_0x8
	LDI  R26,LOW(255)
	LDI  R27,HIGH(255)
	EOR  R30,R26
	STS  _ucFec_S0000000,R30
; 0000 0163 
; 0000 0164                         ucBitCounter = 6;
	CALL SUBOPT_0xA
; 0000 0165                         ucState++;
; 0000 0166                     }
; 0000 0167                     break;
_0x4E:
	RJMP _0x2C
; 0000 0168                 }
; 0000 0169 
; 0000 016A                 // trang thai ghep byte sua loi
; 0000 016B                 case PLM_TX_FEC:{
_0x4A:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x53
; 0000 016C                     PLM_pinTxD = ucFec & 0x20;
	CALL SUBOPT_0x8
	ANDI R30,LOW(0x20)
	ANDI R31,HIGH(0x20)
	CPI  R30,0
	BRNE _0x54
	CBI  0x18,6
	RJMP _0x55
_0x54:
	SBI  0x18,6
_0x55:
; 0000 016D                     ucFec <<= 1;
	CALL SUBOPT_0x8
	LSL  R30
	ROL  R31
	STS  _ucFec_S0000000,R30
; 0000 016E                     ucBitCounter--;
	CALL SUBOPT_0x2
; 0000 016F 
; 0000 0170                     if(!ucBitCounter){
	BRNE _0x56
; 0000 0171                         if(!ucByteCounter){
	LDS  R30,_ucByteCounter
	CPI  R30,0
	BRNE _0x57
; 0000 0172                             ucFec = PLM_pinTxD ^ 0x01;
	LDI  R26,0
	SBIC 0x18,6
	LDI  R26,1
	LDI  R30,LOW(1)
	EOR  R30,R26
	STS  _ucFec_S0000000,R30
; 0000 0173                             ucBitCounter = ucPostableBits;
	LDS  R30,_ucPostableBits
	STS  _ucBitCounter,R30
; 0000 0174                             ucState++;                                // postamble
	LDS  R30,_ucState
	SUBI R30,-LOW(1)
	RJMP _0xAD
; 0000 0175                         }
; 0000 0176                         else{
_0x57:
; 0000 0177                             ucByte = ucPacket[ucIndex++];
	CALL SUBOPT_0xB
; 0000 0178                             ucBitCounter = 8;
; 0000 0179                             ucByteCounter--;
; 0000 017A                             ucFec = 0;
	LDI  R30,LOW(0)
	STS  _ucFec_S0000000,R30
; 0000 017B                             ucState = PLM_TX_DATA;
	LDI  R30,LOW(6)
_0xAD:
	STS  _ucState,R30
; 0000 017C                         }
; 0000 017D                     }
; 0000 017E                     break;
_0x56:
	RJMP _0x2C
; 0000 017F                 }
; 0000 0180 
; 0000 0181                 // truyen cac bit bo sung
; 0000 0182                 case PLM_TX_POSTAMBLE:{
_0x53:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x2C
; 0000 0183                     PLM_pinTxD = ucFec;
	LDS  R30,_ucFec_S0000000
	CPI  R30,0
	BRNE _0x5A
	CBI  0x18,6
	RJMP _0x5B
_0x5A:
	SBI  0x18,6
_0x5B:
; 0000 0184                     ucBitCounter--;
	CALL SUBOPT_0x2
; 0000 0185 
; 0000 0186                     if(!ucBitCounter){
	BRNE _0x5C
; 0000 0187                         ucState = PLM_STOP;
	LDI  R30,LOW(0)
	STS  _ucState,R30
; 0000 0188 
; 0000 0189                         PLM_pinRXTX = 1;                            // Rx session
	SBI  0x15,5
; 0000 018A                         PLM_pinREG_DATA = 0;                        // mains access
	CBI  0x15,6
; 0000 018B                     }
; 0000 018C                     break;
_0x5C:
; 0000 018D                 }
; 0000 018E             }
_0x2C:
; 0000 018F         }
; 0000 0190     }
_0x29:
_0x28:
; 0000 0191 }
	RET
;
;//kiem tra xem co dang chay hay khong
;unsigned char PLM_IsRunning(void){
; 0000 0194 unsigned char PLM_IsRunning(void){
_PLM_IsRunning:
; 0000 0195     return ucState;
	LDS  R30,_ucState
	RET
; 0000 0196 }
;
;unsigned char PLM_GetCorrectionBytes(void){
; 0000 0198 unsigned char PLM_GetCorrectionBytes(void){
; 0000 0199     return ucCorrectionCounter;
; 0000 019A }
;
;//+++cau hinh cho thanh ghi
;void PLM_SetControlRegister(unsigned long ulControlRegister)
; 0000 019E {
_PLM_SetControlRegister:
; 0000 019F     *(unsigned long*)&ucPacket[0] = ulControlRegister;
;	ulControlRegister -> Y+0
	__GETD1S 0
	STS  _ucPacket,R30
	STS  _ucPacket+1,R31
	STS  _ucPacket+2,R22
	STS  _ucPacket+3,R23
; 0000 01A0 
; 0000 01A1     ucIndex = 1;
	LDI  R30,LOW(1)
	STS  _ucIndex,R30
; 0000 01A2     ucBitCounter = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x10
; 0000 01A3     ucByteCounter = 3;
; 0000 01A4 
; 0000 01A5     PLM_pinREG_DATA = 1;
; 0000 01A6     PLM_pinRXTX = 0;
	CBI  0x15,5
; 0000 01A7 
; 0000 01A8     ucState = PLM_TX_REG;
	LDI  R30,LOW(1)
	STS  _ucState,R30
; 0000 01A9     pin_TASK = 0;
	CBI  0x12,7
; 0000 01AA }
	ADIW R28,4
	RET
;
;//+++lay cac thong so thiet lap cau hinh
;unsigned long PLM_GetControlRegister(void){
; 0000 01AD unsigned long PLM_GetControlRegister(void){
_PLM_GetControlRegister:
; 0000 01AE     ucIndex = 4;
	LDI  R30,LOW(4)
	STS  _ucIndex,R30
; 0000 01AF     ucBitCounter = 8;
	LDI  R30,LOW(8)
	CALL SUBOPT_0x10
; 0000 01B0     ucByteCounter = 3;
; 0000 01B1 
; 0000 01B2     PLM_pinREG_DATA = 1;
; 0000 01B3     PLM_pinRXTX = 1;
	SBI  0x15,5
; 0000 01B4 
; 0000 01B5     ucState = PLM_RX_REG;
	LDI  R30,LOW(2)
	STS  _ucState,R30
; 0000 01B6     pin_TASK = 0;
	CBI  0x12,7
; 0000 01B7 
; 0000 01B8     while(PLM_IsRunning() != 0);
_0x6D:
	RCALL _PLM_IsRunning
	CPI  R30,0
	BRNE _0x6D
; 0000 01B9 
; 0000 01BA     // return only 24 bits
; 0000 01BB     return (*(unsigned long*)&ucPacket[3]) & 0xffffff00;
	__GETD1MN _ucPacket,3
	ANDI R30,LOW(0xFFFFFF00)
	RET
; 0000 01BC }
;
;//khoi tao cho plm
;void PLM_Init(void){
; 0000 01BF void PLM_Init(void){
_PLM_Init:
; 0000 01C0     PLM_pinREG_DATA = 0;
	CBI  0x15,6
; 0000 01C1     PLM_pinRXTX = 1;
	SBI  0x15,5
; 0000 01C2     ucState = PLM_STOP;
	LDI  R30,LOW(0)
	STS  _ucState,R30
; 0000 01C3 }
	RET
;
;//set cac pin de dua ve che do idle
;void PLM_Stop(void){
; 0000 01C6 void PLM_Stop(void){
_PLM_Stop:
; 0000 01C7     ucState = PLM_STOP;
	LDI  R30,LOW(0)
	STS  _ucState,R30
; 0000 01C8 
; 0000 01C9     PLM_pinREG_DATA = 0;
	CBI  0x15,6
; 0000 01CA     PLM_pinRXTX = 1;
	SBI  0x15,5
; 0000 01CB }
	RET
;
;//chuyen sang che do truyen du lieu
;void PLM_TransmitData(unsigned char length, unsigned char ucAck){
; 0000 01CE void PLM_TransmitData(unsigned char length, unsigned char ucAck){
_PLM_TransmitData:
; 0000 01CF     bAck = ucAck;
;	length -> Y+1
;	ucAck -> Y+0
	LD   R30,Y
	CALL __BSTB1
	BLD  R2,0
; 0000 01D0 
; 0000 01D1     ucIndex = 0;
	LDI  R30,LOW(0)
	STS  _ucIndex,R30
; 0000 01D2     ucBitCounter = 16;                    // 16 bits preamble length
	LDI  R30,LOW(16)
	STS  _ucBitCounter,R30
; 0000 01D3     ucByteCounter = length;             // do dai byte
	LDD  R30,Y+1
	STS  _ucByteCounter,R30
; 0000 01D4                                     // mains access
; 0000 01D5     PLM_pinREG_DATA = 0;
	CBI  0x15,6
; 0000 01D6     PLM_pinRXTX = 0;
	CBI  0x15,5
; 0000 01D7 
; 0000 01D8     ucState = PLM_TX_PREAMBLE;
	LDI  R30,LOW(3)
	STS  _ucState,R30
; 0000 01D9     pin_TASK = 0;
	CBI  0x12,7
; 0000 01DA }
	ADIW R28,2
	RET
;
;//+++chuyen sang che do nhan du lieu
;void PLM_ReceiveData(){
; 0000 01DD void PLM_ReceiveData(){
_PLM_ReceiveData:
; 0000 01DE     ucIndex = 3;
	LDI  R30,LOW(3)
	STS  _ucIndex,R30
; 0000 01DF     ucByteCounter = iMaxLength;
	LDS  R30,_iMaxLength
	STS  _ucByteCounter,R30
; 0000 01E0     ucCorrectionCounter = 0;
	LDI  R30,LOW(0)
	STS  _ucCorrectionCounter,R30
; 0000 01E1 
; 0000 01E2     PLM_pinREG_DATA = 0;
	CBI  0x15,6
; 0000 01E3     PLM_pinRXTX = 1;
	SBI  0x15,5
; 0000 01E4 
; 0000 01E5     ucState = PLM_RX_PREAMBLE;
	LDI  R30,LOW(9)
	STS  _ucState,R30
; 0000 01E6     pin_TASK = 0;
	CBI  0x12,7
; 0000 01E7 }
	RET
;
;//+++gan du lieu de chuan bi gui qua rs232
;void RS232_SetData(unsigned char *pucBuffer, unsigned char ucLength){
; 0000 01EA void RS232_SetData(unsigned char *pucBuffer, unsigned char ucLength){
_RS232_SetData:
; 0000 01EB     int i;
; 0000 01EC     for(i=0;i<ucLength;i++){
	ST   -Y,R17
	ST   -Y,R16
;	*pucBuffer -> Y+3
;	ucLength -> Y+2
;	i -> R16,R17
	__GETWRN 16,17,0
_0x85:
	LDD  R30,Y+2
	CALL SUBOPT_0x11
	BRGE _0x86
; 0000 01ED         delay_ms(2);
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x12
; 0000 01EE         putchar(*(pucBuffer+i));
	MOVW R30,R16
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	ST   -Y,R30
	CALL _putchar
; 0000 01EF     }
	__ADDWRN 16,17,1
	RJMP _0x85
_0x86:
; 0000 01F0 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
;
;//+++lay du lieu tu pc gui xuong qua rs232
;void RS232_GetData(){
; 0000 01F3 void RS232_GetData(){
_RS232_GetData:
; 0000 01F4     int iCounter = 0;
; 0000 01F5     for(iCounter = 0;iCounter < ucLength; iCounter++){
	ST   -Y,R17
	ST   -Y,R16
;	iCounter -> R16,R17
	__GETWRN 16,17,0
	__GETWRN 16,17,0
_0x88:
	LDS  R30,_ucLength
	CALL SUBOPT_0x11
	BRGE _0x89
; 0000 01F6         *(ucPacket+iCounter) = getchar();
	MOVW R30,R16
	SUBI R30,LOW(-_ucPacket)
	SBCI R31,HIGH(-_ucPacket)
	PUSH R31
	PUSH R30
	CALL _getchar
	POP  R26
	POP  R27
	ST   X,R30
; 0000 01F7     }
	__ADDWRN 16,17,1
	RJMP _0x88
_0x89:
; 0000 01F8     ucRS232Started = 0;
	LDI  R30,LOW(0)
	STS  _ucRS232Started,R30
; 0000 01F9 }
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;/*-----------RS233---------------*/
;
;// External Interrupt 0 service routine
;
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 0200 {
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
; 0000 0201     if(PLM_IsRunning()>0){
	RCALL _PLM_IsRunning
	CPI  R30,LOW(0x1)
	BRLO _0x8A
; 0000 0202         PLM_Task();
	RCALL _PLM_Task
; 0000 0203     }else{
	RJMP _0x8B
_0x8A:
; 0000 0204         pin_TASK = 1;
	SBI  0x12,7
; 0000 0205     }
_0x8B:
; 0000 0206 }
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
;
;void main(void)
; 0000 020A {
_main:
; 0000 020B     // Khai bao bien
; 0000 020C 
; 0000 020D     // Khoi tao cac gia tri
; 0000 020E     IO_Init();
	RCALL _IO_Init
; 0000 020F     TimerCounter_Init();
	RCALL _TimerCounter_Init
; 0000 0210     RS232_Init();
	RCALL _RS232_Init
; 0000 0211     pin_TASK = 1;
	SBI  0x12,7
; 0000 0212     ExtInterupt_Init();
	RCALL _ExtInterupt_Init
; 0000 0213 
; 0000 0214     PLM_Init();
	RCALL _PLM_Init
; 0000 0215     // ket thuc khoi tao
; 0000 0216 
; 0000 0217     // khoi tao cho thanh ghi ST
; 0000 0218     PLM_SetControlRegister(DEFAULT_CONTROL_REG);// dummy write
	CALL SUBOPT_0x13
; 0000 0219     while(PLM_IsRunning() != 0);
_0x90:
	RCALL _PLM_IsRunning
	CPI  R30,0
	BRNE _0x90
; 0000 021A     PLM_SetControlRegister(DEFAULT_CONTROL_REG);// dummy write
	CALL SUBOPT_0x13
; 0000 021B     // ket thuc khoi tao cho thanh ghi
; 0000 021C     ucRS232Started = 0;
	LDI  R30,LOW(0)
	STS  _ucRS232Started,R30
; 0000 021D     // Chuong trinh chinh
; 0000 021E     while (1)
_0x93:
; 0000 021F     {
; 0000 0220         if((RS232_IsRunning()>0)&&(ucRS232Started==0)){
	CALL _RS232_IsRunning
	CPI  R30,LOW(0x1)
	BRLO _0x97
	LDS  R26,_ucRS232Started
	CPI  R26,LOW(0x0)
	BREQ _0x98
_0x97:
	RJMP _0x96
_0x98:
; 0000 0221             if(getchar()== RX_START)
	CALL _getchar
	CPI  R30,LOW(0xAA)
	BRNE _0x99
; 0000 0222             {
; 0000 0223                 delay_ms(50);
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CALL SUBOPT_0x12
; 0000 0224                 ucRS232Started = 1;
	LDI  R30,LOW(1)
	STS  _ucRS232Started,R30
; 0000 0225                 ucCommand = getchar();
	CALL _getchar
	STS  _ucCommand,R30
; 0000 0226                 ucLength = getchar();
	CALL _getchar
	STS  _ucLength,R30
; 0000 0227                 delay_ms(2*ucLength);
	CALL SUBOPT_0x14
	LSL  R30
	ROL  R31
	CALL SUBOPT_0x12
; 0000 0228 //                PLM_pinWD = ~PLM_pinWD;
; 0000 0229             }
; 0000 022A         }
_0x99:
; 0000 022B         if(ucRS232Started == 1){
_0x96:
	LDS  R26,_ucRS232Started
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x9A
; 0000 022C             // doc gia tri tu rs232
; 0000 022D             RS232_GetData();
	RCALL _RS232_GetData
; 0000 022E             // kiem tra gia tri dau tien cua ucPacket
; 0000 022F             switch(ucCommand){
	LDS  R30,_ucCommand
	LDI  R31,0
; 0000 0230                 // doc thanh ghi st7538/7540
; 0000 0231                 case COM_GET_CTR:
	SBIW R30,0
	BRNE _0x9E
; 0000 0232                 {
; 0000 0233                     // get control register (comm)
; 0000 0234 			        *((unsigned long*)&ucPacket[3]) = PLM_GetControlRegister();
	RCALL _PLM_GetControlRegister
	__PUTD1MN _ucPacket,3
; 0000 0235 					ByteReverse((unsigned long*)&ucPacket[3]);
	__POINTW1MN _ucPacket,3
	ST   -Y,R31
	ST   -Y,R30
	CALL _ByteReverse
; 0000 0236                     *ucPacket = TX_START;// them header
	CALL SUBOPT_0x15
; 0000 0237                     *(ucPacket + 1) = ucCommand;// them code
; 0000 0238                     *(ucPacket + 2) = 3;// them do dai
	LDI  R30,LOW(3)
	__PUTB1MN _ucPacket,2
; 0000 0239 					RS232_SetData(ucPacket, 7);
	CALL SUBOPT_0x16
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _RS232_SetData
; 0000 023A //                    PLM_pinWD = ~PLM_pinWD;
; 0000 023B 					break;
	RJMP _0x9D
; 0000 023C 			    }
; 0000 023D 
; 0000 023E                 // ghi thanh ghi st7538/7540
; 0000 023F 		        case COM_SET_CTR:
_0x9E:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x9F
; 0000 0240                 {
; 0000 0241                     // set control register (comm, byte0, byte1, byte2, byte3)
; 0000 0242 					ByteReverse((unsigned long*)&ucPacket[0]);
	CALL SUBOPT_0x16
	CALL _ByteReverse
; 0000 0243 					PLM_SetControlRegister(*((unsigned long*)&ucPacket[0]));
	LDS  R30,_ucPacket
	LDS  R31,_ucPacket+1
	LDS  R22,_ucPacket+2
	LDS  R23,_ucPacket+3
	CALL __PUTPARD1
	RCALL _PLM_SetControlRegister
; 0000 0244 					break;
	RJMP _0x9D
; 0000 0245 			    }
; 0000 0246 
; 0000 0247                 // ghi gia tri do dai mot frame
; 0000 0248                 case COM_SET_MAXLENGTH:
_0x9F:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xA0
; 0000 0249                 {
; 0000 024A                     iMaxLength = ucPacket[0];
	LDS  R30,_ucPacket
	LDI  R31,0
	STS  _iMaxLength,R30
	STS  _iMaxLength+1,R31
; 0000 024B                     break;
	RJMP _0x9D
; 0000 024C                 }
; 0000 024D 
; 0000 024E                 // doc gia tri do dai mot frame
; 0000 024F                 case COM_GET_MAXLENGTH:
_0xA0:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xA1
; 0000 0250                 {
; 0000 0251                     *ucPacket = TX_START;// them header
	CALL SUBOPT_0x15
; 0000 0252                     *(ucPacket + 1) = ucCommand;// them code
; 0000 0253                     *(ucPacket + 2) = 1;// them do dai
	LDI  R30,LOW(1)
	__PUTB1MN _ucPacket,2
; 0000 0254                     *(ucPacket + 3) = iMaxLength;
	LDS  R30,_iMaxLength
	__PUTB1MN _ucPacket,3
; 0000 0255 					RS232_SetData(ucPacket, 4);
	CALL SUBOPT_0x16
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL _RS232_SetData
; 0000 0256                     break;
	RJMP _0x9D
; 0000 0257                 }
; 0000 0258 
; 0000 0259                 // truyen
; 0000 025A                 case COM_SET_PLM:
_0xA1:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xA2
; 0000 025B                 {
; 0000 025C 					PLM_Stop();
	RCALL _PLM_Stop
; 0000 025D                     ucPostableBits = 8 -((ucLength * 14) % 8);
	CALL SUBOPT_0x14
	LDI  R26,LOW(14)
	LDI  R27,HIGH(14)
	CALL __MULW12
	MOVW R26,R30
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __MODW21
	LDI  R26,LOW(8)
	LDI  R27,HIGH(8)
	CALL __SWAPW12
	SUB  R30,R26
	STS  _ucPostableBits,R30
; 0000 025E                     PLM_TransmitData(ucLength, 0);
	LDS  R30,_ucLength
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _PLM_TransmitData
; 0000 025F 					break;
	RJMP _0x9D
; 0000 0260 			    }
; 0000 0261 
; 0000 0262                 // nhan
; 0000 0263                 case COM_GET_PLM:
_0xA2:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x9D
; 0000 0264                 {
; 0000 0265                     PLM_ReceiveData();
	RCALL _PLM_ReceiveData
; 0000 0266 					break;
; 0000 0267 			    }
; 0000 0268             }
_0x9D:
; 0000 0269         }
; 0000 026A 
; 0000 026B 
; 0000 026C         if(PLM_pinCD_PD == 0)
_0x9A:
	SBIC 0x13,4
	RJMP _0xA4
; 0000 026D         {
; 0000 026E             if(PLM_pinBU == 1){
	LDI  R26,0
	SBIC 0x19,2
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0xA5
; 0000 026F                 PLM_ReceiveData();
	RCALL _PLM_ReceiveData
; 0000 0270                 delay_ms(6);
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CALL SUBOPT_0x12
; 0000 0271                 *ucPacket = TX_START;// them header
	LDI  R30,LOW(170)
	STS  _ucPacket,R30
; 0000 0272                 *(ucPacket + 1) = COM_GET_PLM;// them code
	LDI  R30,LOW(2)
	__PUTB1MN _ucPacket,1
; 0000 0273                 *(ucPacket + 2) = ucLength;// them do dai
	LDS  R30,_ucLength
	__PUTB1MN _ucPacket,2
; 0000 0274 //                *(ucPacket + ( 3 + ucLength )) = PLM_GetCorrectionBytes();
; 0000 0275 //                RS232_SetData(ucPacket, ucLength + 4);
; 0000 0276                if(ucLength>0)
	LDS  R26,_ucLength
	CPI  R26,LOW(0x1)
	BRLO _0xA6
; 0000 0277                 RS232_SetData(ucPacket, ucLength + 3);
	CALL SUBOPT_0x16
	CALL SUBOPT_0x14
	ADIW R30,3
	ST   -Y,R30
	RCALL _RS232_SetData
; 0000 0278     	    }
_0xA6:
; 0000 0279         }
_0xA5:
; 0000 027A 
; 0000 027B     	PLM_pinWD = ~PLM_pinWD;
_0xA4:
	SBIS 0x1B,3
	RJMP _0xA7
	CBI  0x1B,3
	RJMP _0xA8
_0xA7:
	SBI  0x1B,3
_0xA8:
; 0000 027C 
; 0000 027D     };
	RJMP _0x93
; 0000 027E }
_0xA9:
	RJMP _0xA9
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
;
;void RS232_Init(void){
; 0001 0066 void RS232_Init(void){
_RS232_Init:
; 0001 0067     // USART initialization
; 0001 0068     // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0001 0069     // USART Receiver: On
; 0001 006A     // USART Transmitter: On
; 0001 006B     // USART Mode: Asynchronous
; 0001 006C     // USART Baud Rate: 9600
; 0001 006D     UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0001 006E     UCSRB=0xD8;
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0001 006F     UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0001 0070     UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0001 0071     UBRRL=0x47;
	LDI  R30,LOW(71)
	OUT  0x9,R30
; 0001 0072 }
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
;//bang tra cuu CRC
;//flash unsigned int tableCRC[] =    {
;//                                        0x0000, 0x8005, 0x800f, 0x000a, 0x801b, 0x001e, 0x0014, 0x8011,
;//                                        0x8033, 0x0036, 0x003c, 0x8039, 0x0028, 0x802d, 0x8027, 0x0022,
;//                                        0x8063, 0x0066, 0x006c, 0x8069, 0x0078, 0x807d, 0x8077, 0x0072,
;//                                        0x0050, 0x8055, 0x805f, 0x005a, 0x804b, 0x004e, 0x0044, 0x8041,
;//                                        0x80c3, 0x00c6, 0x00cc, 0x80c9, 0x00d8, 0x80dd, 0x80d7, 0x00d2,
;//                                        0x00f0, 0x80f5, 0x80ff, 0x00fa, 0x80eb, 0x00ee, 0x00e4, 0x80e1,
;//                                        0x00a0, 0x80a5, 0x80af, 0x00aa, 0x80bb, 0x00be, 0x00b4, 0x80b1,
;//                                        0x8093, 0x0096, 0x009c, 0x8099, 0x0088, 0x808d, 0x8087, 0x0082,
;//                                        0x8183, 0x0186, 0x018c, 0x8189, 0x0198, 0x819d, 0x8197, 0x0192,
;//                                        0x01b0, 0x81b5, 0x81bf, 0x01ba, 0x81ab, 0x01ae, 0x01a4, 0x81a1,
;//                                        0x01e0, 0x81e5, 0x81ef, 0x01ea, 0x81fb, 0x01fe, 0x01f4, 0x81f1,
;//                                        0x81d3, 0x01d6, 0x01dc, 0x81d9, 0x01c8, 0x81cd, 0x81c7, 0x01c2,
;//                                        0x0140, 0x8145, 0x814f, 0x014a, 0x815b, 0x015e, 0x0154, 0x8151,
;//                                        0x8173, 0x0176, 0x017c, 0x8179, 0x0168, 0x816d, 0x8167, 0x0162,
;//                                        0x8123, 0x0126, 0x012c, 0x8129, 0x0138, 0x813d, 0x8137, 0x0132,
;//                                        0x0110, 0x8115, 0x811f, 0x011a, 0x810b, 0x010e, 0x0104, 0x8101,
;//                                        0x8303, 0x0306, 0x030c, 0x8309, 0x0318, 0x831d, 0x8317, 0x0312,
;//                                        0x0330, 0x8335, 0x833f, 0x033a, 0x832b, 0x032e, 0x0324, 0x8321,
;//                                        0x0360, 0x8365, 0x836f, 0x036a, 0x837b, 0x037e, 0x0374, 0x8371,
;//                                        0x8353, 0x0356, 0x035c, 0x8359, 0x0348, 0x834d, 0x8347, 0x0342,
;//                                        0x03c0, 0x83c5, 0x83cf, 0x03ca, 0x83db, 0x03de, 0x03d4, 0x83d1,
;//                                        0x83f3, 0x03f6, 0x03fc, 0x83f9, 0x03e8, 0x83ed, 0x83e7, 0x03e2,
;//                                        0x83a3, 0x03a6, 0x03ac, 0x83a9, 0x03b8, 0x83bd, 0x83b7, 0x03b2,
;//                                        0x0390, 0x8395, 0x839f, 0x039a, 0x838b, 0x038e, 0x0384, 0x8381,
;//                                        0x0280, 0x8285, 0x828f, 0x028a, 0x829b, 0x029e, 0x0294, 0x8291,
;//                                        0x82b3, 0x02b6, 0x02bc, 0x82b9, 0x02a8, 0x82ad, 0x82a7, 0x02a2,
;//                                        0x82e3, 0x02e6, 0x02ec, 0x82e9, 0x02f8, 0x82fd, 0x82f7, 0x02f2,
;//                                        0x02d0, 0x82d5, 0x82df, 0x02da, 0x82cb, 0x02ce, 0x02c4, 0x82c1,
;//                                        0x8243, 0x0246, 0x024c, 0x8249, 0x0258, 0x825d, 0x8257, 0x0252,
;//                                        0x0270, 0x8275, 0x827f, 0x027a, 0x826b, 0x026e, 0x0264, 0x8261,
;//                                        0x0220, 0x8225, 0x822f, 0x022a, 0x823b, 0x023e, 0x0234, 0x8231,
;//                                        0x8213, 0x0216, 0x021c, 0x8219, 0x0208, 0x820d, 0x8207, 0x0202
;//                                        };
;void ByteReverse(unsigned long* pul){
; 0003 0025 void ByteReverse(unsigned long* pul){

	.CSEG
_ByteReverse:
; 0003 0026     unsigned char uc;
; 0003 0027 
; 0003 0028     uc = *((unsigned char*)pul + 0);                                // msb
	ST   -Y,R17
;	*pul -> Y+1
;	uc -> R17
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,0
	LD   R17,X
; 0003 0029     *((unsigned char*)pul + 0) = *((unsigned char*)pul + 3);        // lsb
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,3
	LD   R30,X
	__PUTB1SNS 1,0
; 0003 002A     *((unsigned char*)pul + 3) = uc;
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	__PUTBZR 17,3
; 0003 002B 
; 0003 002C     uc = *((unsigned char*)(pul) + 1);                                // msb
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,1
	LD   R17,X
; 0003 002D     *((unsigned char*)pul + 1) = *((unsigned char*)pul + 2);        // lsb
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,2
	LD   R30,X
	__PUTB1SNS 1,1
; 0003 002E     *((unsigned char*)pul + 2) = uc;
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	__PUTBZR 17,2
; 0003 002F }
	LDD  R17,Y+0
	ADIW R28,3
	RET
;
;//unsigned int CalcCRC(unsigned char *pucBuffer, unsigned char ucLength){
;//    unsigned int uiCRC = 0;
;
;//    while(ucLength--)
;//        uiCRC = tableCRC[((uiCRC >> 8) ^ *pucBuffer++) & 0xff] ^ (uiCRC << 8);
;
;//    return uiCRC;
;//}
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
;//kiem tra xem co dang chay hay khong
;//unsigned char PLM_IsRunning(void){
;//    return ucState;
;//}
;
;//+++cau hinh cho thanh ghi
;//void PLM_SetControlRegister(unsigned long ulControlRegister)
;//{
;//    *(unsigned long*)&ucPacket[0] = ulControlRegister;
;//
;//    ucIndex = 1;
;//    ucBitCounter = 0;
;//    ucByteCounter = 3;
;
;//    PLM_pinREG_DATA = 1;
;//    PLM_pinRXTX = 0;
;//
;//    ucState = PLM_TX_REG;
;//    pin_TASK = 0;
;//}
;
;//+++lay cac thong so thiet lap cau hinh
;//unsigned long PLM_GetControlRegister(void){
;//    ucIndex = 4;
;//    ucBitCounter = 8;
;//    ucByteCounter = 3;
;//
;//    PLM_pinREG_DATA = 1;
;//    PLM_pinRXTX = 1;
;//
;//    ucState = PLM_RX_REG;
;//    pin_TASK = 0;
;//
;//    while(PLM_IsRunning() != 0);
;//
;    // return only 24 bits
;//    return (*(unsigned long*)&ucPacket[3]) & 0xffffff00;
;//}
;
;//khoi tao cho plm
;//void PLM_Init(void){
;//    PLM_pinREG_DATA = 0;
;//    PLM_pinRXTX = 1;
;//    ucState = PLM_STOP;
;//}
;
;//set cac pin de dua ve che do idle
;//void PLM_Stop(void){
;//    ucState = PLM_STOP;
;//
;//    PLM_pinREG_DATA = 0;
;//    PLM_pinRXTX = 1;
;//}
;
;//chuyen sang che do truyen du lieu
;//void PLM_TransmitData(unsigned char length, unsigned char ucAck){
;//    bAck = ucAck;
;
;//    ucIndex = 0;
;//    ucBitCounter = 16;                    // 16 bits preamble length
;//    ucByteCounter = length;             // do dai byte
;                                    // mains access
;//    PLM_pinREG_DATA = 0;
;//    PLM_pinRXTX = 0;
;//
;//    ucState = PLM_TX_PREAMBLE;
;//    pin_TASK = 0;
;//}
;
;//+++chuyen sang che do nhan du lieu
;//void PLM_ReceiveData(){
;//    ucIndex = 3;
;//    ucByteCounter = iMaxLength;
;//    ucCorrectionCounter = 0;
;//
;//    PLM_pinREG_DATA = 0;
;//    PLM_pinRXTX = 1;
;//
;//    ucState = PLM_RX_PREAMBLE;
;//    pin_TASK = 0;
;//}

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
_iMaxLength:
	.BYTE 0x2
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:57 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:39 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x6:
	LDS  R30,_ucBitCounter
	SUBI R30,LOW(1)
	STS  _ucBitCounter,R30
	LDS  R30,_ucFec_S0000000
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7:
	LDI  R31,0
	OR   R30,R26
	STS  _ucFec_S0000000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:36 WORDS
SUBOPT_0x8:
	LDS  R30,_ucFec_S0000000
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x9:
	LDI  R26,LOW(57)
	LDI  R27,HIGH(57)
	EOR  R30,R26
	STS  _ucFec_S0000000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(6)
	STS  _ucBitCounter,R30
	LDS  R30,_ucState
	SUBI R30,-LOW(1)
	STS  _ucState,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0xB:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0xC:
	LDS  R30,_ucByte_S0000000
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD:
	LSL  R30
	ROL  R31
	STS  _ucByte_S0000000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	LDS  R30,_ucBitCounter
	SUBI R30,LOW(1)
	STS  _ucBitCounter,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(8)
	STS  _ucBitCounter,R30
	LDS  R30,_ucState
	SUBI R30,-LOW(1)
	STS  _ucState,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	STS  _ucBitCounter,R30
	LDI  R30,LOW(3)
	STS  _ucByteCounter,R30
	SBI  0x15,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	MOVW R26,R16
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	__GETD1N 0xD7361300
	CALL __PUTPARD1
	JMP  _PLM_SetControlRegister

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	LDS  R30,_ucLength
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(170)
	STS  _ucPacket,R30
	LDS  R30,_ucCommand
	__PUTB1MN _ucPacket,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(_ucPacket)
	LDI  R31,HIGH(_ucPacket)
	ST   -Y,R31
	ST   -Y,R30
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
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

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
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

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__BSTB1:
	CLT
	TST  R30
	BREQ PC+2
	SET
	RET

;END OF CODE MARKER
__END_OF_CODE:
