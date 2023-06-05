
_main:

;code_project.c,16 :: 		void main() {
;code_project.c,17 :: 		TRISD = 0x00;  // PORTD as output
	CLRF       TRISD+0
;code_project.c,18 :: 		PORTD = 0x00;  // Initialize PORTD to 0
	CLRF       PORTD+0
;code_project.c,19 :: 		TRISC = 0xF0;
	MOVLW      240
	MOVWF      TRISC+0
;code_project.c,20 :: 		TRISB = 0x03;  // PORTB<1:0> as input
	MOVLW      3
	MOVWF      TRISB+0
;code_project.c,21 :: 		CCPPWM_init();
	CALL       _CCPPWM_init+0
;code_project.c,23 :: 		while (1) {
L_main0:
;code_project.c,24 :: 		follow_line();  // Start following the line
	CALL       _follow_line+0
;code_project.c,25 :: 		}
	GOTO       L_main0
;code_project.c,26 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_move_forward:

;code_project.c,28 :: 		void move_forward() {
;code_project.c,29 :: 		PORTD = 0x05;  // Move forward command
	MOVLW      5
	MOVWF      PORTD+0
;code_project.c,30 :: 		}
L_end_move_forward:
	RETURN
; end of _move_forward

_turn_right:

;code_project.c,32 :: 		void turn_right() {
;code_project.c,33 :: 		PORTD = 0x09;  // Turn right command
	MOVLW      9
	MOVWF      PORTD+0
;code_project.c,34 :: 		}
L_end_turn_right:
	RETURN
; end of _turn_right

_turn_left:

;code_project.c,36 :: 		void turn_left() {
;code_project.c,37 :: 		PORTD = 0x06;  // Turn left command
	MOVLW      6
	MOVWF      PORTD+0
;code_project.c,38 :: 		}
L_end_turn_left:
	RETURN
; end of _turn_left

_stop:

;code_project.c,40 :: 		void stop() {
;code_project.c,41 :: 		PORTD = 0x00;  // Stop command
	CLRF       PORTD+0
;code_project.c,42 :: 		}
L_end_stop:
	RETURN
; end of _stop

_my_delay:

;code_project.c,44 :: 		void my_delay(unsigned int mscnt) {
;code_project.c,47 :: 		for (ms = 0; ms < mscnt; ms++) {
	CLRF       R1+0
	CLRF       R1+1
L_my_delay2:
	MOVF       FARG_my_delay_mscnt+1, 0
	SUBWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__my_delay33
	MOVF       FARG_my_delay_mscnt+0, 0
	SUBWF      R1+0, 0
L__my_delay33:
	BTFSC      STATUS+0, 0
	GOTO       L_my_delay3
;code_project.c,48 :: 		for (cnt = 0; cnt < 155; cnt++)
	CLRF       R3+0
	CLRF       R3+1
L_my_delay5:
	MOVLW      0
	SUBWF      R3+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__my_delay34
	MOVLW      155
	SUBWF      R3+0, 0
L__my_delay34:
	BTFSC      STATUS+0, 0
	GOTO       L_my_delay6
	INCF       R3+0, 1
	BTFSC      STATUS+0, 2
	INCF       R3+1, 1
;code_project.c,49 :: 		;
	GOTO       L_my_delay5
L_my_delay6:
;code_project.c,47 :: 		for (ms = 0; ms < mscnt; ms++) {
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;code_project.c,50 :: 		}
	GOTO       L_my_delay2
L_my_delay3:
;code_project.c,51 :: 		}
L_end_my_delay:
	RETURN
; end of _my_delay

_follow_line:

;code_project.c,53 :: 		void follow_line() {
;code_project.c,54 :: 		unsigned int tapeCount = 0;
	CLRF       follow_line_tapeCount_L0+0
	CLRF       follow_line_tapeCount_L0+1
;code_project.c,57 :: 		serial_interface();
	CALL       _serial_interface+0
;code_project.c,58 :: 		result = reciever();
	CALL       _reciever+0
	MOVF       R0+0, 0
	MOVWF      _result+0
;code_project.c,59 :: 		transmitter(result);
	MOVF       R0+0, 0
	MOVWF      FARG_transmitter+0
	CALL       _transmitter+0
;code_project.c,61 :: 		if (result == 's') {
	MOVF       _result+0, 0
	XORLW      115
	BTFSS      STATUS+0, 2
	GOTO       L_follow_line8
;code_project.c,62 :: 		stop();  // If 's' is received, stop the movement
	CALL       _stop+0
;code_project.c,63 :: 		}
L_follow_line8:
;code_project.c,65 :: 		if ((PORTB & 0x01) && (PORTB & 0x02)) {
	BTFSS      PORTB+0, 0
	GOTO       L_follow_line11
	BTFSS      PORTB+0, 1
	GOTO       L_follow_line11
L__follow_line26:
;code_project.c,66 :: 		tapeCount = tapeCount + 1;
	INCF       follow_line_tapeCount_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       follow_line_tapeCount_L0+1, 1
;code_project.c,67 :: 		move_forward();  // If both sensors detect the line, move forward
	CALL       _move_forward+0
;code_project.c,68 :: 		} else if (PORTB & 0x02) {
	GOTO       L_follow_line12
L_follow_line11:
	BTFSS      PORTB+0, 1
	GOTO       L_follow_line13
;code_project.c,69 :: 		turn_left();  // If right sensor detects the line, turn left
	CALL       _turn_left+0
;code_project.c,70 :: 		my_delay(500);
	MOVLW      244
	MOVWF      FARG_my_delay_mscnt+0
	MOVLW      1
	MOVWF      FARG_my_delay_mscnt+1
	CALL       _my_delay+0
;code_project.c,71 :: 		} else if (PORTB & 0x01) {
	GOTO       L_follow_line14
L_follow_line13:
	BTFSS      PORTB+0, 0
	GOTO       L_follow_line15
;code_project.c,72 :: 		turn_right();  // If left sensor detects the line, turn right
	CALL       _turn_right+0
;code_project.c,73 :: 		my_delay(500);
	MOVLW      244
	MOVWF      FARG_my_delay_mscnt+0
	MOVLW      1
	MOVWF      FARG_my_delay_mscnt+1
	CALL       _my_delay+0
;code_project.c,74 :: 		} else {
	GOTO       L_follow_line16
L_follow_line15:
;code_project.c,75 :: 		tapeCount = 0;
	CLRF       follow_line_tapeCount_L0+0
	CLRF       follow_line_tapeCount_L0+1
;code_project.c,76 :: 		move_forward();  // If no line is detected, move forward
	CALL       _move_forward+0
;code_project.c,77 :: 		}
L_follow_line16:
L_follow_line14:
L_follow_line12:
;code_project.c,80 :: 		if (tapeCount == 0) {
	MOVLW      0
	XORWF      follow_line_tapeCount_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__follow_line36
	MOVLW      0
	XORWF      follow_line_tapeCount_L0+0, 0
L__follow_line36:
	BTFSS      STATUS+0, 2
	GOTO       L_follow_line17
;code_project.c,81 :: 		pwmValue = 75;  // Set PWM value to 75 if no tape is detected
	MOVLW      75
	MOVWF      _pwmValue+0
	MOVLW      0
	MOVWF      _pwmValue+1
;code_project.c,82 :: 		} else if (tapeCount == 1) {
	GOTO       L_follow_line18
L_follow_line17:
	MOVLW      0
	XORWF      follow_line_tapeCount_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__follow_line37
	MOVLW      1
	XORWF      follow_line_tapeCount_L0+0, 0
L__follow_line37:
	BTFSS      STATUS+0, 2
	GOTO       L_follow_line19
;code_project.c,83 :: 		pwmValue = 50;  // Set PWM value to 50 if one tape is detected
	MOVLW      50
	MOVWF      _pwmValue+0
	MOVLW      0
	MOVWF      _pwmValue+1
;code_project.c,84 :: 		} else if (tapeCount == 2) {
	GOTO       L_follow_line20
L_follow_line19:
	MOVLW      0
	XORWF      follow_line_tapeCount_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__follow_line38
	MOVLW      2
	XORWF      follow_line_tapeCount_L0+0, 0
L__follow_line38:
	BTFSS      STATUS+0, 2
	GOTO       L_follow_line21
;code_project.c,85 :: 		stop();  // If two tapes are detected, stop the movement
	CALL       _stop+0
;code_project.c,86 :: 		}
L_follow_line21:
L_follow_line20:
L_follow_line18:
;code_project.c,88 :: 		CCPR1L = pwmValue;
	MOVF       _pwmValue+0, 0
	MOVWF      CCPR1L+0
;code_project.c,89 :: 		CCPR2L = pwmValue;
	MOVF       _pwmValue+0, 0
	MOVWF      CCPR2L+0
;code_project.c,90 :: 		}
L_end_follow_line:
	RETURN
; end of _follow_line

_CCPPWM_init:

;code_project.c,92 :: 		void CCPPWM_init(void){ //Configure CCP1 and CCP2 at 2ms period with 50% duty cycle
;code_project.c,93 :: 		T2CON = 0x07;//enable Timer2 at Fosc/4 with 1:16 prescaler (8 uS percount 2000uS to count 250 counts)
	MOVLW      7
	MOVWF      T2CON+0
;code_project.c,94 :: 		CCP1CON = 0x0C;//enable PWM for CCP1
	MOVLW      12
	MOVWF      CCP1CON+0
;code_project.c,95 :: 		CCP2CON = 0x0C;//enable PWM for CCP2
	MOVLW      12
	MOVWF      CCP2CON+0
;code_project.c,96 :: 		PR2 = 250;// 250 counts =8uS *250 =2ms period
	MOVLW      250
	MOVWF      PR2+0
;code_project.c,97 :: 		TRISC = 0x00;
	CLRF       TRISC+0
;code_project.c,98 :: 		CCPR1L= pwmValue;  // Set initial PWM value for CCP1
	MOVF       _pwmValue+0, 0
	MOVWF      CCPR1L+0
;code_project.c,99 :: 		CCPR2L = pwmValue;  // Set initial PWM value for CCP2
	MOVF       _pwmValue+0, 0
	MOVWF      CCPR2L+0
;code_project.c,100 :: 		}
L_end_CCPPWM_init:
	RETURN
; end of _CCPPWM_init

_serial_interface:

;code_project.c,103 :: 		void serial_interface(){
;code_project.c,105 :: 		TXSTA = 0x20; //Asynchronous mode, Low power BRGH=0, 8-bit selection
	MOVLW      32
	MOVWF      TXSTA+0
;code_project.c,107 :: 		RCSTA = 0x90; // Serial port enable, continous recieve enabled, 8-bit selection
	MOVLW      144
	MOVWF      RCSTA+0
;code_project.c,109 :: 		SPBRG= 12; //Low power,, 9600 baudrate
	MOVLW      12
	MOVWF      SPBRG+0
;code_project.c,112 :: 		PIR1= PIR1 & 0xEF; //TXIF_bit=0;
	MOVLW      239
	ANDWF      PIR1+0, 1
;code_project.c,113 :: 		PIR1= PIR1 & 0xDF; //RCIF_bit=0;
	MOVLW      223
	ANDWF      PIR1+0, 1
;code_project.c,114 :: 		}
L_end_serial_interface:
	RETURN
; end of _serial_interface

_transmitter:

;code_project.c,118 :: 		void transmitter(unsigned char tx) {
;code_project.c,120 :: 		TXREG= tx;
	MOVF       FARG_transmitter_tx+0, 0
	MOVWF      TXREG+0
;code_project.c,122 :: 		while (!TXIF);
L_transmitter23:
;code_project.c,124 :: 		PIR1= PIR1 & 0xEF; //TXIF_bit=0;
	MOVLW      239
	ANDWF      PIR1+0, 1
;code_project.c,126 :: 		}
L_end_transmitter:
	RETURN
; end of _transmitter

_reciever:

;code_project.c,130 :: 		unsigned char reciever(){
;code_project.c,132 :: 		while(!RCIF);
L_reciever25:
;code_project.c,134 :: 		PIR1= PIR1 & 0xDF; //RCIF_bit=0;
	MOVLW      223
	ANDWF      PIR1+0, 1
;code_project.c,136 :: 		return RCREG;
	MOVF       RCREG+0, 0
	MOVWF      R0+0
;code_project.c,138 :: 		}
L_end_reciever:
	RETURN
; end of _reciever
