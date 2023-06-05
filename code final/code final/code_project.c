#include <stdio.h>
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

unsigned int pwmValue = 100;  // Initial PWM value

void main() {
  TRISD = 0x00;  // PORTD as output
  PORTD = 0x00;  // Initialize PORTD to 0
  TRISC = 0xF0;
  TRISB = 0x03;  // PORTB<1:0> as input
  CCPPWM_init();

  while (1) {
    follow_line();  // Start following the line
  }
}

void move_forward() {
  PORTD = 0x05;  // Move forward command
}

void turn_right() {
  PORTD = 0x09;  // Turn right command
}

void turn_left() {
  PORTD = 0x06;  // Turn left command
}

void stop() {
  PORTD = 0x00;  // Stop command
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
    stop();  // If 's' is received, stop the movement
  }

  if ((PORTB & 0x01) && (PORTB & 0x02)) {
    tapeCount = tapeCount + 1;
    move_forward();  // If both sensors detect the line, move forward
  } else if (PORTB & 0x02) {
    turn_left();  // If right sensor detects the line, turn left
    my_delay(500);
  } else if (PORTB & 0x01) {
    turn_right();  // If left sensor detects the line, turn right
    my_delay(500);
  } else {
    tapeCount = 0;
    move_forward();  // If no line is detected, move forward
  }

  // Adjust PWM value based on tape count
  if (tapeCount == 0) {
    pwmValue = 75;  // Set PWM value to 75 if no tape is detected
  } else if (tapeCount == 1) {
    pwmValue = 50;  // Set PWM value to 50 if one tape is detected
  } else if (tapeCount == 2) {
    stop();  // If two tapes are detected, stop the movement
  }

  CCPR1L = pwmValue;
  CCPR2L = pwmValue;
}

 void CCPPWM_init(void){ //Configure CCP1 and CCP2 at 2ms period with 50% duty cycle
  T2CON = 0x07;//enable Timer2 at Fosc/4 with 1:16 prescaler (8 uS percount 2000uS to count 250 counts)
  CCP1CON = 0x0C;//enable PWM for CCP1
  CCP2CON = 0x0C;//enable PWM for CCP2
  PR2 = 250;// 250 counts =8uS *250 =2ms period
  TRISC = 0x00;
  CCPR1L= pwmValue;  // Set initial PWM value for CCP1
  CCPR2L = pwmValue;  // Set initial PWM value for CCP2
}


void serial_interface(){

 TXSTA = 0x20; //Asynchronous mode, Low power BRGH=0, 8-bit selection

 RCSTA = 0x90; // Serial port enable, continous recieve enabled, 8-bit selection

 SPBRG= 12; //Low power,, 9600 baudrate

 //TXIF_bit=RCIF_bit= 0;
 PIR1= PIR1 & 0xEF; //TXIF_bit=0;
 PIR1= PIR1 & 0xDF; //RCIF_bit=0;
}



void transmitter(unsigned char tx) {

 TXREG= tx;

 while (!TXIF);

 PIR1= PIR1 & 0xEF; //TXIF_bit=0;

}



unsigned char reciever(){

 while(!RCIF);

 PIR1= PIR1 & 0xDF; //RCIF_bit=0;

 return RCREG;

}
