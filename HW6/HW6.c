/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : HW6
Version : 1.0
Date    : 4/15/2024
Author  : Pooria Rahimi
Company : IUST
Comments: 
Nothing


Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*******************************************************/

#include <mega32.h>
#include <stdio.h>

// Alphanumeric LCD functions
#include <alcd.h>

// Declare your global variables here
int clock[7] = {2, 3, 5, 8, 0, 0, 0};

void increase_clock()
{
    clock[6]++;
    if (clock[6] == 10)
    {           
        clock[6] = 0;
        clock[5]++;
    }
    
    if (clock[5] == 10)
    {           
        clock[5] = 0;
        clock[4]++;
    }   
    
    if (clock[4] == 6)
    {
        clock[4] = 0;
        clock[3]++;
    }    
    
    if (clock[3] == 10)
    {
        clock[3] = 0;
        clock[2]++;
    }     
    
    if (clock[2] == 6)
    {
        clock[2] = 0;
        clock[1]++;
    }
    
    if (clock[0] == 2)
    {
        if (clock[1] == 4)
        {
            clock[1] = 0;
            clock[0] = 0;
        }  
    }
    else
    {
        if (clock[1] == 10)
        {
            clock[1] = 0;
            clock[0]++;
        }
    }
}

void display_clock()
{
    char charValue;
    lcd_gotoxy(4,1);
    charValue = clock[0]+'0';
    lcd_putchar(charValue);
    charValue = clock[1]+'0';
    lcd_putchar(charValue);
    
    lcd_gotoxy(7,1);
    charValue = clock[2]+'0';
    lcd_putchar(charValue);
    charValue = clock[3]+'0';
    lcd_putchar(charValue);
    
    lcd_gotoxy(10,1);
    charValue = clock[4]+'0';
    lcd_putchar(charValue);
    charValue = clock[5]+'0';
    lcd_putchar(charValue);
    
    lcd_gotoxy(13,1);
    charValue = clock[6]+'0';
    lcd_putchar(charValue);
}

// Timer1 output compare A interrupt service routine
interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{
    increase_clock();
    display_clock();
}

void main(void)
{

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 31.250 kHz
// Mode: CTC top=OCR1A
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: On
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x0B;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x20;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0b00010010;

// Global enable interrupts
#asm("sei")
// Declare your local variables here
// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTC Bit 0
// RD - PORTC Bit 1
// EN - PORTC Bit 2

// D4 - PORTC Bit 4
// D5 - PORTC Bit 5
// D6 - PORTC Bit 6
// D7 - PORTC Bit 7
// Characters/line: 16
lcd_init(16);
lcd_gotoxy(4,0);
lcd_puts("LCD Clock");
lcd_gotoxy(6,1);
lcd_putchar(':');
lcd_gotoxy(9,1);
lcd_putchar(':');
lcd_gotoxy(12,1);
lcd_putchar(',');


while (1)
      {
      // Place your code here

      }
}

