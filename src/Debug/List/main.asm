
;CodeVisionAVR C Compiler V3.34 Evaluation
;(C) Copyright 1998-2018 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Mode 2
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

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

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

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
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
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
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
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

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
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

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
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

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
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
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
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

	.MACRO __PUTBSR
	STD  Y+@1,R@0
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
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
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

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
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
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
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
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
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
	.DEF __lcd_x=R5
	.DEF __lcd_y=R4
	.DEF __lcd_maxx=R7

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _pushbutton
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
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G102:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G102:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x0:
	.DB  0x43,0x0,0x44,0x0,0x4F,0x46,0x46,0x0
	.DB  0x41,0x0,0x42,0x0,0x45,0x0,0x25,0x64
	.DB  0x0,0x20,0x0,0x43,0x57,0x0,0x43,0x43
	.DB  0x57,0x0
_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0
_0x2020003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  _0x3
	.DW  _0x0*2

	.DW  0x02
	.DW  _0x3+2
	.DW  _0x0*2+2

	.DW  0x04
	.DW  _0xB
	.DW  _0x0*2+4

	.DW  0x02
	.DW  _0x14
	.DW  _0x0*2+8

	.DW  0x02
	.DW  _0x14+2
	.DW  _0x0*2+10

	.DW  0x02
	.DW  _0x14+4
	.DW  _0x0*2+12

	.DW  0x02
	.DW  _0x14+6
	.DW  _0x0*2+17

	.DW  0x03
	.DW  _0x14+8
	.DW  _0x0*2+19

	.DW  0x04
	.DW  _0x14+11
	.DW  _0x0*2+22

	.DW  0x01
	.DW  __seed_G100
	.DW  _0x2000060*2

	.DW  0x02
	.DW  __base_y_G101
	.DW  _0x2020003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

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

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
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

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0x00

	.DSEG
	.ORG 0x260

	.CSEG
;/*
; * microproj2.c
; *
; * Created: 12/29/2019 9:56:02 PM
; * Author: kh alamatsaz
; */
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
;#include <delay.h>
;#include <stdlib.h>
;#include <lcd.h>
;#include <io.h>
;#include <stdio.h>
;
;#asm (".equ __lcd_port=0x15");
	.equ __lcd_port=0x15
;
;unsigned int READ_ADC (unsigned char adc_input) {
; 0000 0011 unsigned int READ_ADC (unsigned char adc_input) {

	.CSEG
_READ_ADC:
; .FSTART _READ_ADC
; 0000 0012   ADMUX = adc_input | 0x00;
	ST   -Y,R17
	MOV  R17,R26
;	adc_input -> R17
	MOV  R30,R17
	OUT  0x7,R30
; 0000 0013   delay_us(10);
	__DELAY_USB 27
; 0000 0014   ADCSRA |= 0x40;        //start the conversion
	SBI  0x6,6
; 0000 0015 
; 0000 0016   lcd_clear();
	RCALL _lcd_clear
; 0000 0017   lcd_puts("C");
	__POINTW2MN _0x3,0
	RCALL _lcd_puts
; 0000 0018 
; 0000 0019   while ((ADCSRA & 0x10)==0);        //wait for the AD conversion to complete
_0x4:
	SBIS 0x6,4
	RJMP _0x4
; 0000 001A 
; 0000 001B   lcd_clear();
	RCALL _lcd_clear
; 0000 001C   lcd_puts("D");
	__POINTW2MN _0x3,2
	RCALL _lcd_puts
; 0000 001D 
; 0000 001E   ADCSRA |=0x10;
	SBI  0x6,4
; 0000 001F   return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	LD   R17,Y+
	RET
; 0000 0020 }
; .FEND

	.DSEG
_0x3:
	.BYTE 0x4
;
;
;
;interrupt [EXT_INT0] void pushbutton (void) {
; 0000 0024 interrupt [2] void pushbutton (void) {

	.CSEG
_pushbutton:
; .FSTART _pushbutton
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
; 0000 0025   PORTB.0=0;
	CBI  0x18,0
; 0000 0026   PORTB.1=0;         //turn off the motor
	CBI  0x18,1
; 0000 0027   lcd_clear();
	RCALL _lcd_clear
; 0000 0028   lcd_puts("OFF");
	__POINTW2MN _0xB,0
	RCALL _lcd_puts
; 0000 0029   delay_ms(5000);
	LDI  R26,LOW(5000)
	LDI  R27,HIGH(5000)
	RCALL _delay_ms
; 0000 002A   lcd_clear();
	RCALL _lcd_clear
; 0000 002B }
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
; .FEND

	.DSEG
_0xB:
	.BYTE 0x4
;
;
;void main(void) {
; 0000 002E void main(void) {

	.CSEG
_main:
; .FSTART _main
; 0000 002F   int temp ;
; 0000 0030   int cnt=0;
; 0000 0031   char buffer[50];
; 0000 0032 
; 0000 0033   DDRA.0=0;
	SBIW R28,50
;	temp -> R16,R17
;	cnt -> R18,R19
;	buffer -> Y+0
	__GETWRN 18,19,0
	CBI  0x1A,0
; 0000 0034   PORTA.0=0;
	CBI  0x1B,0
; 0000 0035   lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 0036   ADMUX=0b01100000;               //ADC0 , Vref=AVCC , left align
	LDI  R30,LOW(96)
	OUT  0x7,R30
; 0000 0037   ADCSRA=0b10000111;              //division factor 128
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0000 0038   //ADCSRA = ADCSRA | 1<<ADATE;     //Automatic triger enable
; 0000 0039   //SFIOR = SFIOR & 00011111;        //free runing mode (ADIF)
; 0000 003A   DDRB.0=1;             //L298 output
	SBI  0x17,0
; 0000 003B   DDRB.1=1;
	SBI  0x17,1
; 0000 003C   MCUCR=0b00000010;              // falling edge
	LDI  R30,LOW(2)
	OUT  0x35,R30
; 0000 003D 
; 0000 003E   lcd_clear();
	RCALL _lcd_clear
; 0000 003F   lcd_puts("A");
	__POINTW2MN _0x14,0
	RCALL _lcd_puts
; 0000 0040 
; 0000 0041   //GICR=1<<INT0;                  //int0 enable
; 0000 0042   //    #asm("sei")
; 0000 0043 
; 0000 0044 
; 0000 0045   while (1) {
_0x15:
; 0000 0046     // Please write your application code here
; 0000 0047     lcd_clear();
	RCALL _lcd_clear
; 0000 0048     lcd_puts("B");
	__POINTW2MN _0x14,2
	RCALL _lcd_puts
; 0000 0049 
; 0000 004A     temp = READ_ADC(0);
	LDI  R26,LOW(0)
	RCALL _READ_ADC
	MOVW R16,R30
; 0000 004B 
; 0000 004C     lcd_clear();
	RCALL _lcd_clear
; 0000 004D     lcd_puts("E");
	__POINTW2MN _0x14,4
	RCALL _lcd_puts
; 0000 004E 
; 0000 004F     cnt += 1;
	__ADDWRN 18,19,1
; 0000 0050     sprintf(buffer,"%d",cnt);
	RCALL SUBOPT_0x0
	MOVW R30,R18
	RCALL SUBOPT_0x1
; 0000 0051     lcd_puts(buffer);
; 0000 0052     lcd_puts(" ");
	__POINTW2MN _0x14,6
	RCALL _lcd_puts
; 0000 0053 
; 0000 0054     sprintf(buffer,"%d",temp);
	RCALL SUBOPT_0x0
	MOVW R30,R16
	RCALL SUBOPT_0x1
; 0000 0055     lcd_puts(buffer);
; 0000 0056 
; 0000 0057     delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
; 0000 0058 
; 0000 0059     if (temp<550) {                   //v<2.7 (552.42)
	__CPWRN 16,17,550
	BRGE _0x18
; 0000 005A       // ADCSRA |= 0b01000000;          //start conversion
; 0000 005B       PORTB.0=1;
	SBI  0x18,0
; 0000 005C       PORTB.1=0;
	CBI  0x18,1
; 0000 005D       lcd_clear();
	RCALL _lcd_clear
; 0000 005E       lcd_puts("CW");
	__POINTW2MN _0x14,8
	RJMP _0x24
; 0000 005F     }
; 0000 0060     else if (temp>820) {              //v>4 ((818.4)
_0x18:
	__CPWRN 16,17,821
	BRLT _0x1E
; 0000 0061       // ADCSRA |= 0b01000000;          //start conversion
; 0000 0062       PORTB.0=0;
	CBI  0x18,0
; 0000 0063       PORTB.1=1;
	SBI  0x18,1
; 0000 0064       lcd_clear();
	RCALL _lcd_clear
; 0000 0065       lcd_puts("CCW");
	__POINTW2MN _0x14,11
_0x24:
	RCALL _lcd_puts
; 0000 0066     }
; 0000 0067   }
_0x1E:
	RJMP _0x15
; 0000 0068 }
_0x23:
	RJMP _0x23
; .FEND

	.DSEG
_0x14:
	.BYTE 0xF

	.CSEG

	.DSEG

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
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG

	.CSEG
__lcd_delay_G101:
; .FSTART __lcd_delay_G101
    ldi   r31,15
__lcd_delay0:
    dec   r31
    brne  __lcd_delay0
	RET
; .FEND
__lcd_ready:
; .FSTART __lcd_ready
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
    cbi   __lcd_port,__lcd_rs     ;RS=0
__lcd_busy:
	RCALL __lcd_delay_G101
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G101
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G101
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G101
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
; .FEND
__lcd_write_nibble_G101:
; .FSTART __lcd_write_nibble_G101
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G101
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G101
	RET
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G101
    ld    r26,y
    swap  r26
	RCALL __lcd_write_nibble_G101
    sbi   __lcd_port,__lcd_rd     ;RD=1
	JMP  _0x20C0002
; .FEND
__lcd_read_nibble_G101:
; .FSTART __lcd_read_nibble_G101
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G101
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G101
    andi  r30,0xf0
	RET
; .FEND
_lcd_read_byte0_G101:
; .FSTART _lcd_read_byte0_G101
	RCALL __lcd_delay_G101
	RCALL __lcd_read_nibble_G101
    mov   r26,r30
	RCALL __lcd_read_nibble_G101
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	RCALL __lcd_ready
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R5,Y+1
	LDD  R4,Y+0
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	RCALL __lcd_ready
	LDI  R26,LOW(2)
	RCALL __lcd_write_data
	RCALL __lcd_ready
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	RCALL __lcd_ready
	LDI  R26,LOW(1)
	RCALL __lcd_write_data
	LDI  R30,LOW(0)
	MOV  R4,R30
	MOV  R5,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	CP   R5,R7
	BRLO _0x2020004
	__lcd_putchar1:
	INC  R4
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOV  R26,R4
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0x2020004:
	INC  R5
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
	LD   R26,Y
	RCALL __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	JMP  _0x20C0002
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2020005:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020007
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2020005
_0x2020007:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
__long_delay_G101:
; .FSTART __long_delay_G101
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
; .FEND
__lcd_init_write_G101:
; .FSTART __lcd_init_write_G101
	ST   -Y,R26
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G101
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x20C0002
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LDD  R7,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	RCALL __long_delay_G101
	LDI  R26,LOW(48)
	RCALL __lcd_init_write_G101
	RCALL __long_delay_G101
	LDI  R26,LOW(48)
	RCALL __lcd_init_write_G101
	RCALL __long_delay_G101
	LDI  R26,LOW(48)
	RCALL __lcd_init_write_G101
	RCALL __long_delay_G101
	LDI  R26,LOW(32)
	RCALL __lcd_init_write_G101
	RCALL __long_delay_G101
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	RCALL __long_delay_G101
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	RCALL __long_delay_G101
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	RCALL __long_delay_G101
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RCALL _lcd_read_byte0_G101
	CPI  R30,LOW(0x5)
	BREQ _0x202000B
	LDI  R30,LOW(0)
	RJMP _0x20C0002
_0x202000B:
	RCALL __lcd_ready
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
	LDI  R30,LOW(1)
_0x20C0002:
	ADIW R28,1
	RET
; .FEND
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
_put_buff_G102:
; .FSTART _put_buff_G102
	RCALL __SAVELOCR6
	MOVW R18,R26
	LDD  R21,Y+6
	ADIW R26,2
	RCALL __GETW1P
	SBIW R30,0
	BREQ _0x2040010
	MOVW R26,R18
	ADIW R26,4
	RCALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2040012
	__CPWRN 16,17,2
	BRLO _0x2040013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1RNS 18,4
_0x2040012:
	MOVW R26,R18
	ADIW R26,2
	RCALL SUBOPT_0x2
	SBIW R30,1
	ST   Z,R21
_0x2040013:
	MOVW R26,R18
	RCALL __GETW1P
	TST  R31
	BRMI _0x2040014
	RCALL SUBOPT_0x2
_0x2040014:
	RJMP _0x2040015
_0x2040010:
	MOVW R26,R18
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2040015:
	RCALL __LOADLOCR6
	ADIW R28,7
	RET
; .FEND
__print_G102:
; .FSTART __print_G102
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2040016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2040018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x204001C
	CPI  R18,37
	BRNE _0x204001D
	LDI  R17,LOW(1)
	RJMP _0x204001E
_0x204001D:
	RCALL SUBOPT_0x3
_0x204001E:
	RJMP _0x204001B
_0x204001C:
	CPI  R30,LOW(0x1)
	BRNE _0x204001F
	CPI  R18,37
	BRNE _0x2040020
	RCALL SUBOPT_0x3
	RJMP _0x20400CC
_0x2040020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2040021
	LDI  R16,LOW(1)
	RJMP _0x204001B
_0x2040021:
	CPI  R18,43
	BRNE _0x2040022
	LDI  R20,LOW(43)
	RJMP _0x204001B
_0x2040022:
	CPI  R18,32
	BRNE _0x2040023
	LDI  R20,LOW(32)
	RJMP _0x204001B
_0x2040023:
	RJMP _0x2040024
_0x204001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2040025
_0x2040024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2040026
	ORI  R16,LOW(128)
	RJMP _0x204001B
_0x2040026:
	RJMP _0x2040027
_0x2040025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x204001B
_0x2040027:
	CPI  R18,48
	BRLO _0x204002A
	CPI  R18,58
	BRLO _0x204002B
_0x204002A:
	RJMP _0x2040029
_0x204002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x204001B
_0x2040029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x204002F
	RCALL SUBOPT_0x4
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x5
	RJMP _0x2040030
_0x204002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2040032
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x6
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2040033
_0x2040032:
	CPI  R30,LOW(0x70)
	BRNE _0x2040035
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x6
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2040033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2040036
_0x2040035:
	CPI  R30,LOW(0x64)
	BREQ _0x2040039
	CPI  R30,LOW(0x69)
	BRNE _0x204003A
_0x2040039:
	ORI  R16,LOW(4)
	RJMP _0x204003B
_0x204003A:
	CPI  R30,LOW(0x75)
	BRNE _0x204003C
_0x204003B:
	LDI  R30,LOW(_tbl10_G102*2)
	LDI  R31,HIGH(_tbl10_G102*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x204003D
_0x204003C:
	CPI  R30,LOW(0x58)
	BRNE _0x204003F
	ORI  R16,LOW(8)
	RJMP _0x2040040
_0x204003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2040071
_0x2040040:
	LDI  R30,LOW(_tbl16_G102*2)
	LDI  R31,HIGH(_tbl16_G102*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x204003D:
	SBRS R16,2
	RJMP _0x2040042
	RCALL SUBOPT_0x4
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	LD   R30,X+
	LD   R31,X+
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2040043
	RCALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2040043:
	CPI  R20,0
	BREQ _0x2040044
	SUBI R17,-LOW(1)
	RJMP _0x2040045
_0x2040044:
	ANDI R16,LOW(251)
_0x2040045:
	RJMP _0x2040046
_0x2040042:
	RCALL SUBOPT_0x4
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	RCALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
_0x2040046:
_0x2040036:
	SBRC R16,0
	RJMP _0x2040047
_0x2040048:
	CP   R17,R21
	BRSH _0x204004A
	SBRS R16,7
	RJMP _0x204004B
	SBRS R16,2
	RJMP _0x204004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x204004D
_0x204004C:
	LDI  R18,LOW(48)
_0x204004D:
	RJMP _0x204004E
_0x204004B:
	LDI  R18,LOW(32)
_0x204004E:
	RCALL SUBOPT_0x3
	SUBI R21,LOW(1)
	RJMP _0x2040048
_0x204004A:
_0x2040047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x204004F
_0x2040050:
	CPI  R19,0
	BREQ _0x2040052
	SBRS R16,3
	RJMP _0x2040053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2040054
_0x2040053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2040054:
	RCALL SUBOPT_0x3
	CPI  R21,0
	BREQ _0x2040055
	SUBI R21,LOW(1)
_0x2040055:
	SUBI R19,LOW(1)
	RJMP _0x2040050
_0x2040052:
	RJMP _0x2040056
_0x204004F:
_0x2040058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x204005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x204005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x204005A
_0x204005C:
	CPI  R18,58
	BRLO _0x204005D
	SBRS R16,3
	RJMP _0x204005E
	SUBI R18,-LOW(7)
	RJMP _0x204005F
_0x204005E:
	SUBI R18,-LOW(39)
_0x204005F:
_0x204005D:
	SBRC R16,4
	RJMP _0x2040061
	CPI  R18,49
	BRSH _0x2040063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2040062
_0x2040063:
	RJMP _0x20400CD
_0x2040062:
	CP   R21,R19
	BRLO _0x2040067
	SBRS R16,0
	RJMP _0x2040068
_0x2040067:
	RJMP _0x2040066
_0x2040068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2040069
	LDI  R18,LOW(48)
_0x20400CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x204006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0x5
	CPI  R21,0
	BREQ _0x204006B
	SUBI R21,LOW(1)
_0x204006B:
_0x204006A:
_0x2040069:
_0x2040061:
	RCALL SUBOPT_0x3
	CPI  R21,0
	BREQ _0x204006C
	SUBI R21,LOW(1)
_0x204006C:
_0x2040066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2040059
	RJMP _0x2040058
_0x2040059:
_0x2040056:
	SBRS R16,0
	RJMP _0x204006D
_0x204006E:
	CPI  R21,0
	BREQ _0x2040070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x5
	RJMP _0x204006E
_0x2040070:
_0x204006D:
_0x2040071:
_0x2040030:
_0x20400CC:
	LDI  R17,LOW(0)
_0x204001B:
	RJMP _0x2040016
_0x2040018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LD   R30,X+
	LD   R31,X+
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR6
	MOVW R30,R28
	RCALL __ADDW1R15
	__GETWRZ 20,21,14
	MOV  R0,R20
	OR   R0,R21
	BRNE _0x2040072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0001
_0x2040072:
	MOVW R26,R28
	ADIW R26,8
	RCALL __ADDW2R15
	MOVW R16,R26
	__PUTWSR 20,21,8
	LDI  R30,LOW(0)
	STD  Y+10,R30
	STD  Y+10+1,R30
	MOVW R26,R28
	ADIW R26,12
	RCALL __ADDW2R15
	LD   R30,X+
	LD   R31,X+
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G102)
	LDI  R31,HIGH(_put_buff_G102)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,12
	RCALL __print_G102
	MOVW R18,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20C0001:
	RCALL __LOADLOCR6
	ADIW R28,12
	POP  R15
	RET
; .FEND

	.CSEG

	.CSEG

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.DSEG
__seed_G100:
	.BYTE 0x4
__base_y_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x0:
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,14
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1:
	RCALL __CWD1
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _sprintf
	ADIW R28,8
	MOVW R26,R28
	RJMP _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x3:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x4:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x5:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x6:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	LD   R30,X+
	LD   R31,X+
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;RUNTIME LIBRARY

	.CSEG
__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__ADDW1R15:
	CLR  R0
	ADD  R30,R15
	ADC  R31,R0
	RET

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0x7D0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
