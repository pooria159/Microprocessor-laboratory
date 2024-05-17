/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : HW7
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
#include <delay.h>
#include <limits.h>

// Alphanumeric LCD functions
#include <alcd.h>

static char *itoa_simple_helper(char *dest, int i) {
  if (i <= -10) {
    dest = itoa_simple_helper(dest, i/10);
  }
  *dest++ = '0' - i%10;
  return dest;
}

char *itoa_simple(char *dest, int i) {
  char *s = dest;
  if (i < 0) {
    *s++ = '-';
  } else {
    i = -i;
  }
  *itoa_simple_helper(s, i) = '\0';
  return dest;
}

void ADC_Init(){                                        
    DDRA = 0x00;            
    ADCSRA = 0x87;          
    ADMUX = 0x40;           
}

int ADC_Read(char channel)                            
{
    ADMUX = 0x40 | (channel & 0x07);   
    ADCSRA |= (1<<ADSC);               
    while (!(ADCSRA & (1<<ADIF)));     
    ADCSRA |= (1<<ADIF);                     
    delay_ms(1);
    delay_ms(1);                      
    return ADCW;                                      
}


void main()
{
    char Temperature[3];
    float celsius;

    lcd_init(16);                   
    ADC_Init();                 
    lcd_gotoxy(3,0); 
    lcd_puts("LM35 Sensor");
    lcd_gotoxy(3,1);
    lcd_puts("Temp:");  
    lcd_gotoxy(12,1);
    lcd_puts("'C");
    
    while(1)
    {
       celsius = (ADC_Read(0)*4.88);
       celsius = (celsius/10.00);
       lcd_gotoxy(9,1);
       lcd_puts(itoa_simple(Temperature, celsius));
       delay_ms(1000);
    }
}