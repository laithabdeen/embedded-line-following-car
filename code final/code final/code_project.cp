#line 1 "C:/Users/20190543/Desktop/Code/code_project.c"
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for pic/include/stdio.h"
#line 2 "C:/Users/20190543/Desktop/Code/code_project.c"
void my_delay();
void turn_left();
void turn_right();
void move_forward();
void follow_line();
void CCPPWM_init(void);
void stop();
void serial_interface();
void transmitter(unsigned char);
unsigned char result;
unsigned char reciever();

unsigned int pwmValue = 100;

void main() {
 TRISD = 0x00;
 PORTD = 0x00;
 TRISC = 0xF0;
 TRISB = 0x03;
 CCPPWM_init();

 while (1) {
 follow_line();
 }
}

void move_forward() {
 PORTD = 0x05;
}

void turn_right() {
 PORTD = 0x09;
}

void turn_left() {
 PORTD = 0x06;
}

void stop() {
 PORTD = 0x00;
}

void my_delay(unsigned int mscnt) {
 unsigned int ms;
 unsigned int cnt;
 for (ms = 0; ms < mscnt; ms++) {
 for (cnt = 0; cnt < 155; cnt++)
 ;
 }
}

void follow_line() {
 unsigned int tapeCount = 0;


 serial_interface();
 result = reciever();
 transmitter(result);

 if (result == 's') {
 stop();
 }

 if ((PORTB & 0x01) && (PORTB & 0x02)) {
 tapeCount = tapeCount + 1;
 move_forward();
 } else if (PORTB & 0x02) {
 turn_left();
 my_delay(500);
 } else if (PORTB & 0x01) {
 turn_right();
 my_delay(500);
 } else {
 tapeCount = 0;
 move_forward();
 }


 if (tapeCount == 0) {
 pwmValue = 75;
 } else if (tapeCount == 1) {
 pwmValue = 50;
 } else if (tapeCount == 2) {
 stop();
 }

 CCPR1L = pwmValue;
 CCPR2L = pwmValue;
}

 void CCPPWM_init(void){
 T2CON = 0x07;
 CCP1CON = 0x0C;
 CCP2CON = 0x0C;
 PR2 = 250;
 TRISC = 0x00;
 CCPR1L= pwmValue;
 CCPR2L = pwmValue;
}


void serial_interface(){

 TXSTA = 0x20;

 RCSTA = 0x90;

 SPBRG= 12;


 PIR1= PIR1 & 0xEF;
 PIR1= PIR1 & 0xDF;
}



void transmitter(unsigned char tx) {

 TXREG= tx;

 while (!TXIF);

 PIR1= PIR1 & 0xEF;

}



unsigned char reciever(){

 while(!RCIF);

 PIR1= PIR1 & 0xDF;

 return RCREG;

}
