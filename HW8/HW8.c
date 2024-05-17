/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : HW8
Version : 1.0
Date    : 4/22/2024
Author  : Pooria Rahimi
Company : IUST
Comments: 


Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*******************************************************/
#include <mega32.h>
#include <alcd.h>
#include <delay.h>
#include <stdio.h>



#define KEYPAD_R1 PORTD.0
#define KEYPAD_R2 PORTD.1
#define KEYPAD_R3 PORTD.2
#define KEYPAD_R4 PORTD.3
#define KEYPAD_C1 PIND.4
#define KEYPAD_C2 PIND.5
#define KEYPAD_C3 PIND.6
#define KEYPAD_C4 PIND.7

#define KEYPAD_NUM0 0
#define KEYPAD_NUM1 1
#define KEYPAD_NUM2 2
#define KEYPAD_NUM3 3
#define KEYPAD_NUM4 4
#define KEYPAD_NUM5 5
#define KEYPAD_NUM6 6
#define KEYPAD_NUM7 7
#define KEYPAD_NUM8 8
#define KEYPAD_NUM9 9
#define KEYPAD_DIV  10
#define KEYPAD_MUL  11
#define KEYPAD_PLS  12
#define KEYPAD_MNS  13
#define KEYPAD_EQU  14
#define KEYPAD_ON   15

typedef enum State {StartN1, GetN1, StartN2, GetN2, Error, Result} State;
unsigned char numbers[10] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9'};
unsigned char operators[4] = {'/', '*', '+', '-'};
int number1;
int number2;
unsigned char operator;
char str_result[10];

int is_operator(unsigned char c);
unsigned char keypad_scan();
State state_machine(char current_char, State current_state);
int is_number(char c);
int calculate(int number1, int number2, unsigned char operator);
static char *itoa_simple_helper(char *dest, int i);
char *itoa_simple(char *dest, int i);
int is_zero_division(int number2, unsigned char operator);



void main(void)
{
unsigned char key_res;
unsigned char current_char; 
State current_state = StartN1;
 
DDRC=0xFF;
DDRD=0x0F;
PORTC=0x00;

lcd_init(16);
lcd_clear();
lcd_gotoxy(1,0);
lcd_puts("KEYPAD AND LCD");
lcd_gotoxy(5,1);
lcd_puts("PROJECT");
delay_ms(2000);
lcd_clear();

while (1)
      {
      key_res = keypad_scan();
      if(key_res != 255)
      { 
      while(keypad_scan() != 255);
      delay_ms(20);
      if (key_res == KEYPAD_DIV) 
          current_char = '/';
      else if (key_res == KEYPAD_MUL)
          current_char = '*'; 
      else if (key_res == KEYPAD_MNS)
          current_char = '-';
      else if (key_res == KEYPAD_PLS)
          current_char = '+';
      else if (key_res == KEYPAD_EQU)
          current_char = '=';
      else if (key_res == KEYPAD_ON)
      {      
          current_char = 'c';
      }                               
      else
          current_char = key_res + 48;
          
      //lcd_putchar(current_char);
      current_state = state_machine(current_char, current_state);    
      }
      }
}


State state_machine(unsigned char current_char, State current_state)
{
    int result;

    switch(current_state)
    {
        case StartN1:
            if (is_number(current_char))
            {
                lcd_putchar(current_char);
                current_state = GetN1;
                number1 = (int)(current_char - 48);
            } 
            else if (current_char == 'c')
            {
                current_state = StartN1;
                lcd_clear();
                lcd_gotoxy(0,0);
            }
            else 
            {
                lcd_puts("Error");
                current_state = Error;
            }
            break;

        case GetN1:
            if (is_number(current_char))
            {
                lcd_putchar(current_char);
                current_state = GetN1;
                number1 = number1 * 10;
                number1 = number1 + (int)(current_char - 48);
            } 
            else if (current_char == 'c')
            {
                current_state = StartN1;
                lcd_clear();
                lcd_gotoxy(0,0);
            }
            else if (is_operator(current_char))
            {
                lcd_putchar(current_char);
                current_state = StartN2;
                operator = current_char;
            }
            else 
            {
                lcd_clear();
                lcd_gotoxy(0,0);
                lcd_puts("Error");
                current_state = Error;
            }
            break;
        case StartN2:
            if (is_number(current_char))
            {
                lcd_putchar(current_char);
                current_state = GetN2;
                number2 = (int)(current_char - 48);
            } 
            else if (current_char == 'c')
            {
                current_state = StartN1;
                lcd_clear();
                lcd_gotoxy(0,0);
            }
            else if (current_char == '=')
            {
                lcd_putchar(current_char);
                if (is_zero_division(number2, operator))
                {
                    lcd_clear();
                    lcd_gotoxy(0,0);
                    lcd_puts("Zero Division");
                    current_state = Error;
                }
                else
                {
                    result = calculate(number1, number2, operator);
                    lcd_puts(itoa_simple(str_result, result));
                    current_state = Result;
                }
            }
            else 
            {
                lcd_clear();
                lcd_gotoxy(0,0);
                lcd_puts("Error");
                current_state = Error;
            }
            break;
        case GetN2:
            if (is_number(current_char))
            {
                lcd_putchar(current_char);
                current_state = GetN2;
                number2 = number2 * 10;
                number2 = number2 + (int)(current_char - 48);
            } 
            else if (current_char == 'c')
            {
                current_state = StartN1;
                lcd_clear();
                lcd_gotoxy(0,0);
            }
            else if (current_char == '=')
            {
                lcd_putchar(current_char);
                if (is_zero_division(number2, operator))
                {
                    lcd_clear();
                    lcd_gotoxy(0,0);
                    lcd_puts("Zero Division");
                    current_state = Error;
                }
                else
                {
                    result = calculate(number1, number2, operator);
                    lcd_puts(itoa_simple(str_result, result));
                    current_state = Result;
                }
            }
            else 
            {
                lcd_clear();
                lcd_gotoxy(0,0);
                lcd_puts("Error");
                current_state = Error;
            }
            break;

        case Error:
            if (current_char == 'c')
            {
                current_state = StartN1;
                lcd_clear();
                lcd_gotoxy(0,0);
            }
            break;
            
        case Result:
            if (current_char == 'c')
            {
                current_state = StartN1;
                lcd_clear();
                lcd_gotoxy(0,0);
            }
            else 
            {
                lcd_clear();
                lcd_gotoxy(0,0);
                lcd_puts("Error");
                current_state = Error;
            }
            break;
    }
    return current_state;
}

int is_zero_division(int number2, unsigned char operator)
{
    if (number2 == 0 & operator == '/')
        return 1;
    else
        return 0;
}

int is_number(unsigned char c)
{
    int i;
    for (i = 0;i<10;i++)
    {
        if(c == numbers[i])
            return 1;
    }
    return 0;
}

int is_operator(unsigned char c)
{
    int i;
    for (i = 0;i<10;i++)
    {
        if(c == operators[i])
            return 1;
    }
    return 0;
}

int calculate(int number1, int number2, unsigned char operator)
{
    switch (operator)
           {
           case '+':
                return number1 + number2;
           break;

           case '-':
                return number1 - number2;  
           break;
           
           case '*':
                return number1 * number2;
           break;

           case '/':
                return number1 / number2;
           break;
           }
}

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

unsigned char keypad_scan()
{
unsigned char result=255;
////////////////////////  ROW1 ////////////////////////
KEYPAD_R1 = 1; KEYPAD_R2 = 0;  KEYPAD_R3 = 0;  KEYPAD_R4 = 0; //set Row1 for Keypad
delay_ms(5);
if (KEYPAD_C1)
result = KEYPAD_NUM7;
else if (KEYPAD_C2)
result = KEYPAD_NUM8;
else if (KEYPAD_C3)
result = KEYPAD_NUM9;
else if (KEYPAD_C4)
result = KEYPAD_DIV;

////////////////////////  ROW2 ////////////////////////
KEYPAD_R1 = 0; KEYPAD_R2 = 1;  KEYPAD_R3 = 0;  KEYPAD_R4 = 0; //set Row2 for Keypad
delay_ms(5);
if (KEYPAD_C1)
result = KEYPAD_NUM4;
else if (KEYPAD_C2)
result = KEYPAD_NUM5;
else if (KEYPAD_C3)
result = KEYPAD_NUM6;
else if (KEYPAD_C4)
result = KEYPAD_MUL;

////////////////////////  ROW3 ////////////////////////
KEYPAD_R1 = 0; KEYPAD_R2 = 0;  KEYPAD_R3 = 1;  KEYPAD_R4 = 0; //set Row3 for Keypad
delay_ms(5);
if (KEYPAD_C1)
result = KEYPAD_NUM1;
else if (KEYPAD_C2)
result = KEYPAD_NUM2;
else if (KEYPAD_C3)
result = KEYPAD_NUM3;
else if (KEYPAD_C4)
result = KEYPAD_MNS;

////////////////////////  ROW4 ////////////////////////
KEYPAD_R1 = 0; KEYPAD_R2 = 0;  KEYPAD_R3 = 0;  KEYPAD_R4 = 1; //set Row4 for Keypad
delay_ms(5);
if (KEYPAD_C1)
result = KEYPAD_ON;
else if (KEYPAD_C2)
result = KEYPAD_NUM0;
else if (KEYPAD_C3)
result = KEYPAD_EQU;
else if (KEYPAD_C4)
result = KEYPAD_PLS;

return result;
} 