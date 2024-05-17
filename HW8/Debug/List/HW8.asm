
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
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
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
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
	.DEF _number1=R4
	.DEF _number1_msb=R5
	.DEF _number2=R6
	.DEF _number2_msb=R7
	.DEF _operator=R9
	.DEF __lcd_x=R8
	.DEF __lcd_y=R11
	.DEF __lcd_maxx=R10

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
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
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x3:
	.DB  0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37
	.DB  0x38,0x39
_0x4:
	.DB  0x2F,0x2A,0x2B,0x2D
_0x0:
	.DB  0x4B,0x45,0x59,0x50,0x41,0x44,0x20,0x41
	.DB  0x4E,0x44,0x20,0x4C,0x43,0x44,0x0,0x50
	.DB  0x52,0x4F,0x4A,0x45,0x43,0x54,0x0,0x45
	.DB  0x72,0x72,0x6F,0x72,0x0,0x5A,0x65,0x72
	.DB  0x6F,0x20,0x44,0x69,0x76,0x69,0x73,0x69
	.DB  0x6F,0x6E,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  _numbers
	.DW  _0x3*2

	.DW  0x04
	.DW  _operators
	.DW  _0x4*2

	.DW  0x0F
	.DW  _0x5
	.DW  _0x0*2

	.DW  0x08
	.DW  _0x5+15
	.DW  _0x0*2+15

	.DW  0x06
	.DW  _0x22
	.DW  _0x0*2+23

	.DW  0x06
	.DW  _0x22+6
	.DW  _0x0*2+23

	.DW  0x0E
	.DW  _0x22+12
	.DW  _0x0*2+29

	.DW  0x06
	.DW  _0x22+26
	.DW  _0x0*2+23

	.DW  0x0E
	.DW  _0x22+32
	.DW  _0x0*2+29

	.DW  0x06
	.DW  _0x22+46
	.DW  _0x0*2+23

	.DW  0x06
	.DW  _0x22+52
	.DW  _0x0*2+23

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

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
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : HW8
;Version : 1.0
;Date    : 4/22/2024
;Author  : Pooria Rahimi
;Company : IUST
;Comments:
;
;
;Chip type               : ATmega32
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*******************************************************/
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
;#include <alcd.h>
;#include <delay.h>
;#include <stdio.h>
;
;
;
;#define KEYPAD_R1 PORTD.0
;#define KEYPAD_R2 PORTD.1
;#define KEYPAD_R3 PORTD.2
;#define KEYPAD_R4 PORTD.3
;#define KEYPAD_C1 PIND.4
;#define KEYPAD_C2 PIND.5
;#define KEYPAD_C3 PIND.6
;#define KEYPAD_C4 PIND.7
;
;#define KEYPAD_NUM0 0
;#define KEYPAD_NUM1 1
;#define KEYPAD_NUM2 2
;#define KEYPAD_NUM3 3
;#define KEYPAD_NUM4 4
;#define KEYPAD_NUM5 5
;#define KEYPAD_NUM6 6
;#define KEYPAD_NUM7 7
;#define KEYPAD_NUM8 8
;#define KEYPAD_NUM9 9
;#define KEYPAD_DIV  10
;#define KEYPAD_MUL  11
;#define KEYPAD_PLS  12
;#define KEYPAD_MNS  13
;#define KEYPAD_EQU  14
;#define KEYPAD_ON   15
;
;typedef enum State {StartN1, GetN1, StartN2, GetN2, Error, Result} State;
;unsigned char numbers[10] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9'};

	.DSEG
;unsigned char operators[4] = {'/', '*', '+', '-'};
;int number1;
;int number2;
;unsigned char operator;
;char str_result[10];
;
;int is_operator(unsigned char c);
;unsigned char keypad_scan();
;State state_machine(char current_char, State current_state);
;int is_number(char c);
;int calculate(int number1, int number2, unsigned char operator);
;static char *itoa_simple_helper(char *dest, int i);
;char *itoa_simple(char *dest, int i);
;int is_zero_division(int number2, unsigned char operator);
;
;
;
;void main(void)
; 0000 004C {

	.CSEG
_main:
; .FSTART _main
; 0000 004D unsigned char key_res;
; 0000 004E unsigned char current_char;
; 0000 004F State current_state = StartN1;
; 0000 0050 
; 0000 0051 DDRC=0xFF;
;	key_res -> R17
;	current_char -> R16
;	current_state -> R19
	LDI  R19,0
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 0052 DDRD=0x0F;
	LDI  R30,LOW(15)
	OUT  0x11,R30
; 0000 0053 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0054 
; 0000 0055 lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 0056 lcd_clear();
	CALL _lcd_clear
; 0000 0057 lcd_gotoxy(1,0);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x0
; 0000 0058 lcd_puts("KEYPAD AND LCD");
	__POINTW2MN _0x5,0
	CALL _lcd_puts
; 0000 0059 lcd_gotoxy(5,1);
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 005A lcd_puts("PROJECT");
	__POINTW2MN _0x5,15
	CALL _lcd_puts
; 0000 005B delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0000 005C lcd_clear();
	CALL _lcd_clear
; 0000 005D 
; 0000 005E while (1)
_0x6:
; 0000 005F       {
; 0000 0060       key_res = keypad_scan();
	RCALL _keypad_scan
	MOV  R17,R30
; 0000 0061       if(key_res != 255)
	CPI  R17,255
	BREQ _0x9
; 0000 0062       {
; 0000 0063       while(keypad_scan() != 255);
_0xA:
	RCALL _keypad_scan
	CPI  R30,LOW(0xFF)
	BRNE _0xA
; 0000 0064       delay_ms(20);
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
; 0000 0065       if (key_res == KEYPAD_DIV)
	CPI  R17,10
	BRNE _0xD
; 0000 0066           current_char = '/';
	LDI  R16,LOW(47)
; 0000 0067       else if (key_res == KEYPAD_MUL)
	RJMP _0xE
_0xD:
	CPI  R17,11
	BRNE _0xF
; 0000 0068           current_char = '*';
	LDI  R16,LOW(42)
; 0000 0069       else if (key_res == KEYPAD_MNS)
	RJMP _0x10
_0xF:
	CPI  R17,13
	BRNE _0x11
; 0000 006A           current_char = '-';
	LDI  R16,LOW(45)
; 0000 006B       else if (key_res == KEYPAD_PLS)
	RJMP _0x12
_0x11:
	CPI  R17,12
	BRNE _0x13
; 0000 006C           current_char = '+';
	LDI  R16,LOW(43)
; 0000 006D       else if (key_res == KEYPAD_EQU)
	RJMP _0x14
_0x13:
	CPI  R17,14
	BRNE _0x15
; 0000 006E           current_char = '=';
	LDI  R16,LOW(61)
; 0000 006F       else if (key_res == KEYPAD_ON)
	RJMP _0x16
_0x15:
	CPI  R17,15
	BRNE _0x17
; 0000 0070       {
; 0000 0071           current_char = 'c';
	LDI  R16,LOW(99)
; 0000 0072       }
; 0000 0073       else
	RJMP _0x18
_0x17:
; 0000 0074           current_char = key_res + 48;
	MOV  R30,R17
	SUBI R30,-LOW(48)
	MOV  R16,R30
; 0000 0075 
; 0000 0076       //lcd_putchar(current_char);
; 0000 0077       current_state = state_machine(current_char, current_state);
_0x18:
_0x16:
_0x14:
_0x12:
_0x10:
_0xE:
	ST   -Y,R16
	MOV  R26,R19
	RCALL _state_machine
	MOV  R19,R30
; 0000 0078       }
; 0000 0079       }
_0x9:
	RJMP _0x6
; 0000 007A }
_0x19:
	RJMP _0x19
; .FEND

	.DSEG
_0x5:
	.BYTE 0x17
;
;
;State state_machine(unsigned char current_char, State current_state)
; 0000 007E {

	.CSEG
_state_machine:
; .FSTART _state_machine
; 0000 007F     int result;
; 0000 0080 
; 0000 0081     switch(current_state)
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	current_char -> Y+3
;	current_state -> Y+2
;	result -> R16,R17
	LDD  R30,Y+2
	LDI  R31,0
; 0000 0082     {
; 0000 0083         case StartN1:
	SBIW R30,0
	BRNE _0x1D
; 0000 0084             if (is_number(current_char))
	CALL SUBOPT_0x1
	BREQ _0x1E
; 0000 0085             {
; 0000 0086                 lcd_putchar(current_char);
	LDD  R26,Y+3
	CALL _lcd_putchar
; 0000 0087                 current_state = GetN1;
	LDI  R30,LOW(1)
	STD  Y+2,R30
; 0000 0088                 number1 = (int)(current_char - 48);
	LDD  R30,Y+3
	LDI  R31,0
	SBIW R30,48
	MOVW R4,R30
; 0000 0089             }
; 0000 008A             else if (current_char == 'c')
	RJMP _0x1F
_0x1E:
	LDD  R26,Y+3
	CPI  R26,LOW(0x63)
	BRNE _0x20
; 0000 008B             {
; 0000 008C                 current_state = StartN1;
	CALL SUBOPT_0x2
; 0000 008D                 lcd_clear();
; 0000 008E                 lcd_gotoxy(0,0);
; 0000 008F             }
; 0000 0090             else
	RJMP _0x21
_0x20:
; 0000 0091             {
; 0000 0092                 lcd_puts("Error");
	__POINTW2MN _0x22,0
	CALL SUBOPT_0x3
; 0000 0093                 current_state = Error;
; 0000 0094             }
_0x21:
_0x1F:
; 0000 0095             break;
	RJMP _0x1C
; 0000 0096 
; 0000 0097         case GetN1:
_0x1D:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x23
; 0000 0098             if (is_number(current_char))
	CALL SUBOPT_0x1
	BREQ _0x24
; 0000 0099             {
; 0000 009A                 lcd_putchar(current_char);
	LDD  R26,Y+3
	CALL _lcd_putchar
; 0000 009B                 current_state = GetN1;
	LDI  R30,LOW(1)
	STD  Y+2,R30
; 0000 009C                 number1 = number1 * 10;
	MOVW R30,R4
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	MOVW R4,R30
; 0000 009D                 number1 = number1 + (int)(current_char - 48);
	LDD  R30,Y+3
	LDI  R31,0
	SBIW R30,48
	__ADDWRR 4,5,30,31
; 0000 009E             }
; 0000 009F             else if (current_char == 'c')
	RJMP _0x25
_0x24:
	LDD  R26,Y+3
	CPI  R26,LOW(0x63)
	BRNE _0x26
; 0000 00A0             {
; 0000 00A1                 current_state = StartN1;
	CALL SUBOPT_0x2
; 0000 00A2                 lcd_clear();
; 0000 00A3                 lcd_gotoxy(0,0);
; 0000 00A4             }
; 0000 00A5             else if (is_operator(current_char))
	RJMP _0x27
_0x26:
	LDD  R26,Y+3
	RCALL _is_operator
	SBIW R30,0
	BREQ _0x28
; 0000 00A6             {
; 0000 00A7                 lcd_putchar(current_char);
	LDD  R26,Y+3
	CALL _lcd_putchar
; 0000 00A8                 current_state = StartN2;
	LDI  R30,LOW(2)
	STD  Y+2,R30
; 0000 00A9                 operator = current_char;
	LDD  R9,Y+3
; 0000 00AA             }
; 0000 00AB             else
	RJMP _0x29
_0x28:
; 0000 00AC             {
; 0000 00AD                 lcd_clear();
	CALL SUBOPT_0x4
; 0000 00AE                 lcd_gotoxy(0,0);
; 0000 00AF                 lcd_puts("Error");
	__POINTW2MN _0x22,6
	CALL SUBOPT_0x3
; 0000 00B0                 current_state = Error;
; 0000 00B1             }
_0x29:
_0x27:
_0x25:
; 0000 00B2             break;
	RJMP _0x1C
; 0000 00B3         case StartN2:
_0x23:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2A
; 0000 00B4             if (is_number(current_char))
	CALL SUBOPT_0x1
	BREQ _0x2B
; 0000 00B5             {
; 0000 00B6                 lcd_putchar(current_char);
	LDD  R26,Y+3
	CALL _lcd_putchar
; 0000 00B7                 current_state = GetN2;
	LDI  R30,LOW(3)
	STD  Y+2,R30
; 0000 00B8                 number2 = (int)(current_char - 48);
	LDD  R30,Y+3
	LDI  R31,0
	SBIW R30,48
	MOVW R6,R30
; 0000 00B9             }
; 0000 00BA             else if (current_char == 'c')
	RJMP _0x2C
_0x2B:
	LDD  R26,Y+3
	CPI  R26,LOW(0x63)
	BRNE _0x2D
; 0000 00BB             {
; 0000 00BC                 current_state = StartN1;
	CALL SUBOPT_0x2
; 0000 00BD                 lcd_clear();
; 0000 00BE                 lcd_gotoxy(0,0);
; 0000 00BF             }
; 0000 00C0             else if (current_char == '=')
	RJMP _0x2E
_0x2D:
	LDD  R26,Y+3
	CPI  R26,LOW(0x3D)
	BRNE _0x2F
; 0000 00C1             {
; 0000 00C2                 lcd_putchar(current_char);
	CALL SUBOPT_0x5
; 0000 00C3                 if (is_zero_division(number2, operator))
	BREQ _0x30
; 0000 00C4                 {
; 0000 00C5                     lcd_clear();
	CALL SUBOPT_0x4
; 0000 00C6                     lcd_gotoxy(0,0);
; 0000 00C7                     lcd_puts("Zero Division");
	__POINTW2MN _0x22,12
	CALL _lcd_puts
; 0000 00C8                     current_state = Error;
	LDI  R30,LOW(4)
	RJMP _0x91
; 0000 00C9                 }
; 0000 00CA                 else
_0x30:
; 0000 00CB                 {
; 0000 00CC                     result = calculate(number1, number2, operator);
	CALL SUBOPT_0x6
; 0000 00CD                     lcd_puts(itoa_simple(str_result, result));
; 0000 00CE                     current_state = Result;
_0x91:
	STD  Y+2,R30
; 0000 00CF                 }
; 0000 00D0             }
; 0000 00D1             else
	RJMP _0x32
_0x2F:
; 0000 00D2             {
; 0000 00D3                 lcd_clear();
	CALL SUBOPT_0x4
; 0000 00D4                 lcd_gotoxy(0,0);
; 0000 00D5                 lcd_puts("Error");
	__POINTW2MN _0x22,26
	CALL SUBOPT_0x3
; 0000 00D6                 current_state = Error;
; 0000 00D7             }
_0x32:
_0x2E:
_0x2C:
; 0000 00D8             break;
	RJMP _0x1C
; 0000 00D9         case GetN2:
_0x2A:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x33
; 0000 00DA             if (is_number(current_char))
	CALL SUBOPT_0x1
	BREQ _0x34
; 0000 00DB             {
; 0000 00DC                 lcd_putchar(current_char);
	LDD  R26,Y+3
	RCALL _lcd_putchar
; 0000 00DD                 current_state = GetN2;
	LDI  R30,LOW(3)
	STD  Y+2,R30
; 0000 00DE                 number2 = number2 * 10;
	MOVW R30,R6
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	MOVW R6,R30
; 0000 00DF                 number2 = number2 + (int)(current_char - 48);
	LDD  R30,Y+3
	LDI  R31,0
	SBIW R30,48
	__ADDWRR 6,7,30,31
; 0000 00E0             }
; 0000 00E1             else if (current_char == 'c')
	RJMP _0x35
_0x34:
	LDD  R26,Y+3
	CPI  R26,LOW(0x63)
	BRNE _0x36
; 0000 00E2             {
; 0000 00E3                 current_state = StartN1;
	CALL SUBOPT_0x2
; 0000 00E4                 lcd_clear();
; 0000 00E5                 lcd_gotoxy(0,0);
; 0000 00E6             }
; 0000 00E7             else if (current_char == '=')
	RJMP _0x37
_0x36:
	LDD  R26,Y+3
	CPI  R26,LOW(0x3D)
	BRNE _0x38
; 0000 00E8             {
; 0000 00E9                 lcd_putchar(current_char);
	CALL SUBOPT_0x5
; 0000 00EA                 if (is_zero_division(number2, operator))
	BREQ _0x39
; 0000 00EB                 {
; 0000 00EC                     lcd_clear();
	CALL SUBOPT_0x4
; 0000 00ED                     lcd_gotoxy(0,0);
; 0000 00EE                     lcd_puts("Zero Division");
	__POINTW2MN _0x22,32
	RCALL _lcd_puts
; 0000 00EF                     current_state = Error;
	LDI  R30,LOW(4)
	RJMP _0x92
; 0000 00F0                 }
; 0000 00F1                 else
_0x39:
; 0000 00F2                 {
; 0000 00F3                     result = calculate(number1, number2, operator);
	CALL SUBOPT_0x6
; 0000 00F4                     lcd_puts(itoa_simple(str_result, result));
; 0000 00F5                     current_state = Result;
_0x92:
	STD  Y+2,R30
; 0000 00F6                 }
; 0000 00F7             }
; 0000 00F8             else
	RJMP _0x3B
_0x38:
; 0000 00F9             {
; 0000 00FA                 lcd_clear();
	CALL SUBOPT_0x4
; 0000 00FB                 lcd_gotoxy(0,0);
; 0000 00FC                 lcd_puts("Error");
	__POINTW2MN _0x22,46
	CALL SUBOPT_0x3
; 0000 00FD                 current_state = Error;
; 0000 00FE             }
_0x3B:
_0x37:
_0x35:
; 0000 00FF             break;
	RJMP _0x1C
; 0000 0100 
; 0000 0101         case Error:
_0x33:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x3C
; 0000 0102             if (current_char == 'c')
	LDD  R26,Y+3
	CPI  R26,LOW(0x63)
	BRNE _0x3D
; 0000 0103             {
; 0000 0104                 current_state = StartN1;
	CALL SUBOPT_0x2
; 0000 0105                 lcd_clear();
; 0000 0106                 lcd_gotoxy(0,0);
; 0000 0107             }
; 0000 0108             break;
_0x3D:
	RJMP _0x1C
; 0000 0109 
; 0000 010A         case Result:
_0x3C:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x1C
; 0000 010B             if (current_char == 'c')
	LDD  R26,Y+3
	CPI  R26,LOW(0x63)
	BRNE _0x3F
; 0000 010C             {
; 0000 010D                 current_state = StartN1;
	CALL SUBOPT_0x2
; 0000 010E                 lcd_clear();
; 0000 010F                 lcd_gotoxy(0,0);
; 0000 0110             }
; 0000 0111             else
	RJMP _0x40
_0x3F:
; 0000 0112             {
; 0000 0113                 lcd_clear();
	CALL SUBOPT_0x4
; 0000 0114                 lcd_gotoxy(0,0);
; 0000 0115                 lcd_puts("Error");
	__POINTW2MN _0x22,52
	CALL SUBOPT_0x3
; 0000 0116                 current_state = Error;
; 0000 0117             }
_0x40:
; 0000 0118             break;
; 0000 0119     }
_0x1C:
; 0000 011A     return current_state;
	LDD  R30,Y+2
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x2080003
; 0000 011B }
; .FEND

	.DSEG
_0x22:
	.BYTE 0x3A
;
;int is_zero_division(int number2, unsigned char operator)
; 0000 011E {

	.CSEG
_is_zero_division:
; .FSTART _is_zero_division
; 0000 011F     if (number2 == 0 & operator == '/')
	ST   -Y,R26
;	number2 -> Y+1
;	operator -> Y+0
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	MOV  R0,R30
	LD   R26,Y
	LDI  R30,LOW(47)
	CALL __EQB12
	AND  R30,R0
	BREQ _0x41
; 0000 0120         return 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x2080002
; 0000 0121     else
_0x41:
; 0000 0122         return 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2080002
; 0000 0123 }
; .FEND
;
;int is_number(unsigned char c)
; 0000 0126 {
_is_number:
; .FSTART _is_number
; 0000 0127     int i;
; 0000 0128     for (i = 0;i<10;i++)
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	c -> Y+2
;	i -> R16,R17
	__GETWRN 16,17,0
_0x44:
	__CPWRN 16,17,10
	BRGE _0x45
; 0000 0129     {
; 0000 012A         if(c == numbers[i])
	LDI  R26,LOW(_numbers)
	LDI  R27,HIGH(_numbers)
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	LDD  R26,Y+2
	CP   R30,R26
	BRNE _0x46
; 0000 012B             return 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x2080002
; 0000 012C     }
_0x46:
	__ADDWRN 16,17,1
	RJMP _0x44
_0x45:
; 0000 012D     return 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x2080002
; 0000 012E }
; .FEND
;
;int is_operator(unsigned char c)
; 0000 0131 {
_is_operator:
; .FSTART _is_operator
; 0000 0132     int i;
; 0000 0133     for (i = 0;i<10;i++)
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	c -> Y+2
;	i -> R16,R17
	__GETWRN 16,17,0
_0x48:
	__CPWRN 16,17,10
	BRGE _0x49
; 0000 0134     {
; 0000 0135         if(c == operators[i])
	LDI  R26,LOW(_operators)
	LDI  R27,HIGH(_operators)
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	LDD  R26,Y+2
	CP   R30,R26
	BRNE _0x4A
; 0000 0136             return 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x2080002
; 0000 0137     }
_0x4A:
	__ADDWRN 16,17,1
	RJMP _0x48
_0x49:
; 0000 0138     return 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x2080002
; 0000 0139 }
; .FEND
;
;int calculate(int number1, int number2, unsigned char operator)
; 0000 013C {
_calculate:
; .FSTART _calculate
; 0000 013D     switch (operator)
	ST   -Y,R26
;	number1 -> Y+3
;	number2 -> Y+1
;	operator -> Y+0
	LD   R30,Y
	LDI  R31,0
; 0000 013E            {
; 0000 013F            case '+':
	CPI  R30,LOW(0x2B)
	LDI  R26,HIGH(0x2B)
	CPC  R31,R26
	BRNE _0x4E
; 0000 0140                 return number1 + number2;
	CALL SUBOPT_0x7
	ADD  R30,R26
	ADC  R31,R27
	RJMP _0x2080004
; 0000 0141            break;
; 0000 0142 
; 0000 0143            case '-':
_0x4E:
	CPI  R30,LOW(0x2D)
	LDI  R26,HIGH(0x2D)
	CPC  R31,R26
	BRNE _0x4F
; 0000 0144                 return number1 - number2;
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	SUB  R30,R26
	SBC  R31,R27
	RJMP _0x2080004
; 0000 0145            break;
; 0000 0146 
; 0000 0147            case '*':
_0x4F:
	CPI  R30,LOW(0x2A)
	LDI  R26,HIGH(0x2A)
	CPC  R31,R26
	BRNE _0x50
; 0000 0148                 return number1 * number2;
	CALL SUBOPT_0x7
	CALL __MULW12
	RJMP _0x2080004
; 0000 0149            break;
; 0000 014A 
; 0000 014B            case '/':
_0x50:
	CPI  R30,LOW(0x2F)
	LDI  R26,HIGH(0x2F)
	CPC  R31,R26
	BRNE _0x4D
; 0000 014C                 return number1 / number2;
	CALL SUBOPT_0x7
	CALL __DIVW21
; 0000 014D            break;
; 0000 014E            }
_0x4D:
; 0000 014F }
_0x2080004:
	ADIW R28,5
	RET
; .FEND
;
;static char *itoa_simple_helper(char *dest, int i) {
; 0000 0151 static char *itoa_simple_helper(char *dest, int i) {
_itoa_simple_helper_G000:
; .FSTART _itoa_simple_helper_G000
; 0000 0152   if (i <= -10) {
	ST   -Y,R27
	ST   -Y,R26
;	*dest -> Y+2
;	i -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(65526)
	LDI  R31,HIGH(65526)
	CP   R30,R26
	CPC  R31,R27
	BRLT _0x52
; 0000 0153     dest = itoa_simple_helper(dest, i/10);
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOVW R26,R30
	RCALL _itoa_simple_helper_G000
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 0154   }
; 0000 0155   *dest++ = '0' - i%10;
_0x52:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ADIW R30,1
	STD  Y+2,R30
	STD  Y+2+1,R31
	SBIW R30,1
	MOVW R22,R30
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	LDI  R26,LOW(48)
	CALL __SWAPB12
	SUB  R30,R26
	MOVW R26,R22
	ST   X,R30
; 0000 0156   return dest;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
_0x2080003:
	ADIW R28,4
	RET
; 0000 0157 }
; .FEND
;
;char *itoa_simple(char *dest, int i) {
; 0000 0159 char *itoa_simple(char *dest, int i) {
_itoa_simple:
; .FSTART _itoa_simple
; 0000 015A   char *s = dest;
; 0000 015B   if (i < 0) {
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	*dest -> Y+4
;	i -> Y+2
;	*s -> R16,R17
	__GETWRS 16,17,4
	LDD  R26,Y+3
	TST  R26
	BRPL _0x53
; 0000 015C     *s++ = '-';
	MOVW R26,R16
	__ADDWRN 16,17,1
	LDI  R30,LOW(45)
	ST   X,R30
; 0000 015D   } else {
	RJMP _0x54
_0x53:
; 0000 015E     i = -i;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CALL __ANEGW1
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 015F   }
_0x54:
; 0000 0160   *itoa_simple_helper(s, i) = '\0';
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL _itoa_simple_helper_G000
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 0161   return dest;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,6
	RET
; 0000 0162 }
; .FEND
;
;unsigned char keypad_scan()
; 0000 0165 {
_keypad_scan:
; .FSTART _keypad_scan
; 0000 0166 unsigned char result=255;
; 0000 0167 ////////////////////////  ROW1 ////////////////////////
; 0000 0168 KEYPAD_R1 = 1; KEYPAD_R2 = 0;  KEYPAD_R3 = 0;  KEYPAD_R4 = 0; //set Row1 for Keypad
	ST   -Y,R17
;	result -> R17
	LDI  R17,255
	SBI  0x12,0
	CBI  0x12,1
	CALL SUBOPT_0x8
; 0000 0169 delay_ms(5);
; 0000 016A if (KEYPAD_C1)
	SBIS 0x10,4
	RJMP _0x5D
; 0000 016B result = KEYPAD_NUM7;
	LDI  R17,LOW(7)
; 0000 016C else if (KEYPAD_C2)
	RJMP _0x5E
_0x5D:
	SBIS 0x10,5
	RJMP _0x5F
; 0000 016D result = KEYPAD_NUM8;
	LDI  R17,LOW(8)
; 0000 016E else if (KEYPAD_C3)
	RJMP _0x60
_0x5F:
	SBIS 0x10,6
	RJMP _0x61
; 0000 016F result = KEYPAD_NUM9;
	LDI  R17,LOW(9)
; 0000 0170 else if (KEYPAD_C4)
	RJMP _0x62
_0x61:
	SBIC 0x10,7
; 0000 0171 result = KEYPAD_DIV;
	LDI  R17,LOW(10)
; 0000 0172 
; 0000 0173 ////////////////////////  ROW2 ////////////////////////
; 0000 0174 KEYPAD_R1 = 0; KEYPAD_R2 = 1;  KEYPAD_R3 = 0;  KEYPAD_R4 = 0; //set Row2 for Keypad
_0x62:
_0x60:
_0x5E:
	CBI  0x12,0
	SBI  0x12,1
	CALL SUBOPT_0x8
; 0000 0175 delay_ms(5);
; 0000 0176 if (KEYPAD_C1)
	SBIS 0x10,4
	RJMP _0x6C
; 0000 0177 result = KEYPAD_NUM4;
	LDI  R17,LOW(4)
; 0000 0178 else if (KEYPAD_C2)
	RJMP _0x6D
_0x6C:
	SBIS 0x10,5
	RJMP _0x6E
; 0000 0179 result = KEYPAD_NUM5;
	LDI  R17,LOW(5)
; 0000 017A else if (KEYPAD_C3)
	RJMP _0x6F
_0x6E:
	SBIS 0x10,6
	RJMP _0x70
; 0000 017B result = KEYPAD_NUM6;
	LDI  R17,LOW(6)
; 0000 017C else if (KEYPAD_C4)
	RJMP _0x71
_0x70:
	SBIC 0x10,7
; 0000 017D result = KEYPAD_MUL;
	LDI  R17,LOW(11)
; 0000 017E 
; 0000 017F ////////////////////////  ROW3 ////////////////////////
; 0000 0180 KEYPAD_R1 = 0; KEYPAD_R2 = 0;  KEYPAD_R3 = 1;  KEYPAD_R4 = 0; //set Row3 for Keypad
_0x71:
_0x6F:
_0x6D:
	CBI  0x12,0
	CBI  0x12,1
	SBI  0x12,2
	CBI  0x12,3
; 0000 0181 delay_ms(5);
	LDI  R26,LOW(5)
	LDI  R27,0
	CALL _delay_ms
; 0000 0182 if (KEYPAD_C1)
	SBIS 0x10,4
	RJMP _0x7B
; 0000 0183 result = KEYPAD_NUM1;
	LDI  R17,LOW(1)
; 0000 0184 else if (KEYPAD_C2)
	RJMP _0x7C
_0x7B:
	SBIS 0x10,5
	RJMP _0x7D
; 0000 0185 result = KEYPAD_NUM2;
	LDI  R17,LOW(2)
; 0000 0186 else if (KEYPAD_C3)
	RJMP _0x7E
_0x7D:
	SBIS 0x10,6
	RJMP _0x7F
; 0000 0187 result = KEYPAD_NUM3;
	LDI  R17,LOW(3)
; 0000 0188 else if (KEYPAD_C4)
	RJMP _0x80
_0x7F:
	SBIC 0x10,7
; 0000 0189 result = KEYPAD_MNS;
	LDI  R17,LOW(13)
; 0000 018A 
; 0000 018B ////////////////////////  ROW4 ////////////////////////
; 0000 018C KEYPAD_R1 = 0; KEYPAD_R2 = 0;  KEYPAD_R3 = 0;  KEYPAD_R4 = 1; //set Row4 for Keypad
_0x80:
_0x7E:
_0x7C:
	CBI  0x12,0
	CBI  0x12,1
	CBI  0x12,2
	SBI  0x12,3
; 0000 018D delay_ms(5);
	LDI  R26,LOW(5)
	LDI  R27,0
	CALL _delay_ms
; 0000 018E if (KEYPAD_C1)
	SBIS 0x10,4
	RJMP _0x8A
; 0000 018F result = KEYPAD_ON;
	LDI  R17,LOW(15)
; 0000 0190 else if (KEYPAD_C2)
	RJMP _0x8B
_0x8A:
	SBIS 0x10,5
	RJMP _0x8C
; 0000 0191 result = KEYPAD_NUM0;
	LDI  R17,LOW(0)
; 0000 0192 else if (KEYPAD_C3)
	RJMP _0x8D
_0x8C:
	SBIS 0x10,6
	RJMP _0x8E
; 0000 0193 result = KEYPAD_EQU;
	LDI  R17,LOW(14)
; 0000 0194 else if (KEYPAD_C4)
	RJMP _0x8F
_0x8E:
	SBIC 0x10,7
; 0000 0195 result = KEYPAD_PLS;
	LDI  R17,LOW(12)
; 0000 0196 
; 0000 0197 return result;
_0x8F:
_0x8D:
_0x8B:
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 0198 }
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

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0x15
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x15,R30
	__DELAY_USB 13
	SBI  0x15,2
	__DELAY_USB 13
	CBI  0x15,2
	__DELAY_USB 13
	RJMP _0x2080001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	RJMP _0x2080001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R8,Y+1
	LDD  R11,Y+0
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x9
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x9
	LDI  R30,LOW(0)
	MOV  R11,R30
	MOV  R8,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	CP   R8,R10
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R11
	MOV  R26,R11
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000007
	RJMP _0x2080001
_0x2000007:
_0x2000004:
	INC  R8
	SBI  0x15,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x15,0
	RJMP _0x2080001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
	LDD  R17,Y+0
_0x2080002:
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x14
	ORI  R30,LOW(0xF0)
	OUT  0x14,R30
	SBI  0x14,2
	SBI  0x14,0
	SBI  0x14,1
	CBI  0x15,2
	CBI  0x15,0
	CBI  0x15,1
	LDD  R10,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2080001:
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

	.CSEG

	.CSEG

	.DSEG
_numbers:
	.BYTE 0xA
_operators:
	.BYTE 0x4
_str_result:
	.BYTE 0xA
__base_y_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x0:
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	LDD  R26,Y+3
	CALL _is_number
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(0)
	STD  Y+2,R30
	CALL _lcd_clear
	LDI  R30,LOW(0)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3:
	CALL _lcd_puts
	LDI  R30,LOW(4)
	STD  Y+2,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x4:
	CALL _lcd_clear
	LDI  R30,LOW(0)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5:
	LDD  R26,Y+3
	CALL _lcd_putchar
	ST   -Y,R7
	ST   -Y,R6
	MOV  R26,R9
	CALL _is_zero_division
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x6:
	ST   -Y,R5
	ST   -Y,R4
	ST   -Y,R7
	ST   -Y,R6
	MOV  R26,R9
	CALL _calculate
	MOVW R16,R30
	LDI  R30,LOW(_str_result)
	LDI  R31,HIGH(_str_result)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R16
	CALL _itoa_simple
	MOVW R26,R30
	CALL _lcd_puts
	LDI  R30,LOW(5)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	CBI  0x12,2
	CBI  0x12,3
	LDI  R26,LOW(5)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xA:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
	RET

__EQW12:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BREQ __EQW12T
	CLR  R30
__EQW12T:
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

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
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

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

;END OF CODE MARKER
__END_OF_CODE:
