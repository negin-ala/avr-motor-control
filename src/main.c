/*
 * microproj2.c
 *
 * Created: 12/29/2019 9:56:02 PM
 * Author: kh alamatsaz
 */

#include <mega32.h>
#include <delay.h>
#include <stdlib.h>
#include <lcd.h>
#include <io.h>
#include <stdio.h>

#asm (".equ __lcd_port=0x15");

unsigned int READ_ADC (unsigned char adc_input) {
  ADMUX = adc_input | 0x00;
  delay_us(10);
  ADCSRA |= 0x40;        //start the conversion

  lcd_clear();
  lcd_puts("C");

  while ((ADCSRA & 0x10)==0);        //wait for the AD conversion to complete

  lcd_clear();
  lcd_puts("D");

  ADCSRA |=0x10;
  return ADCW;
}



interrupt [EXT_INT0] void pushbutton (void) {
  PORTB.0=0;
  PORTB.1=0;         //turn off the motor
  lcd_clear();
  lcd_puts("OFF");
  delay_ms(5000);
  lcd_clear();
}


void main(void) {
  int temp ;
  int cnt=0;
  char buffer[50];

  DDRA.0=0;
  PORTA.0=0;
  lcd_init(16);
  ADMUX=0b01100000;               //ADC0 , Vref=AVCC , left align
  ADCSRA=0b10000111;              //division factor 128
  //ADCSRA = ADCSRA | 1<<ADATE;     //Automatic triger enable
  //SFIOR = SFIOR & 00011111;        //free runing mode (ADIF)
  DDRB.0=1;             //L298 output
  DDRB.1=1;
  MCUCR=0b00000010;              // falling edge

  lcd_clear();
  lcd_puts("A");

  //GICR=1<<INT0;                  //int0 enable
  //    #asm("sei")


  while (1) {
    // Please write your application code here
    lcd_clear();
    lcd_puts("B");

    temp = READ_ADC(0);

    lcd_clear();
    lcd_puts("E");

    cnt += 1;
    sprintf(buffer,"%d",cnt);
    lcd_puts(buffer);
    lcd_puts(" ");

    sprintf(buffer,"%d",temp);
    lcd_puts(buffer);

    delay_ms(500);

    if (temp<550) {                   //v<2.7 (552.42)
      // ADCSRA |= 0b01000000;          //start conversion
      PORTB.0=1;
      PORTB.1=0;
      lcd_clear();
      lcd_puts("CW");
    }
    else if (temp>820) {              //v>4 ((818.4)
      // ADCSRA |= 0b01000000;          //start conversion
      PORTB.0=0;
      PORTB.1=1;
      lcd_clear();
      lcd_puts("CCW");
    }
  }
}
