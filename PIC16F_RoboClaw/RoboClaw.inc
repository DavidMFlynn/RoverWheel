;******************************************************************
; RoboClaw Driver for PIC16F microcontroller
;  by Dave Flynn
; Created: 1/14/2018
;******************************************************************
; Routines
;ForwardM1	W=Speed 0..127
;
;------------------------------------------------------------------
; RoboClaw data structure
	cblock 0x00
	rc_address
	rc_cmd
	rc_data
	rc_crc:2
	rc_word:2
	rc_trystimeout
	rc_timeout		;milliseconds
	endc
;
true	equ	1
false	equ	0
;------------------------------------------------------------------
; RoboClaw Commands
M1FORWARD	EQU	0
M1BACKWARD	EQU	1
;SETMINMB	EQU	2
;SETMAXMB	EQU	3
M2FORWARD	EQU	4
M2BACKWARD	EQU	5
M17BIT	EQU	6
M27BIT	EQU	7
;MIXEDFORWARD	EQU	8
;MIXEDBACKWARD	EQU	9
;MIXEDRIGHT	EQU	10
;MIXEDLEFT	EQU	11
;MIXEDFB	EQU	12
;MIXEDLR	EQU	13
GETM1ENC	EQU	16
GETM2ENC	EQU	17
GETM1SPEED	EQU	18
GETM2SPEED	EQU	19
RESETENC	EQU	20
GETVERSION	EQU	21
SETM1ENCCOUNT	EQU	22
SETM2ENCCOUNT	EQU	23
GETMBATT	EQU	24
GETLBATT	EQU	25
SETMINLB	EQU	26
SETMAXLB	EQU	27
SETM1PID	EQU	28
SETM2PID	EQU	29
GETM1ISPEED	EQU	30
GETM2ISPEED	EQU	31
M1DUTY	EQU	32
M2DUTY	EQU	33
MIXEDDUTY	EQU	34
M1SPEED	EQU	35
M2SPEED	EQU	36
MIXEDSPEED	EQU	37
M1SPEEDACCEL	EQU	38
M2SPEEDACCEL	EQU	39
MIXEDSPEEDACCEL	EQU	40
M1SPEEDDIST	EQU	41
M2SPEEDDIST	EQU	42
MIXEDSPEEDDIST	EQU	43
M1SPEEDACCELDIST	EQU	44
M2SPEEDACCELDIST	EQU	45
MIXEDSPEEDACCELDIST	EQU	46
GETBUFFERS	EQU	47
GETPWMS	EQU	48
GETCURRENTS	EQU	49
MIXEDSPEED2ACCEL	EQU	50
MIXEDSPEED2ACCELDIST	EQU	51
M1DUTYACCEL	EQU	52
M2DUTYACCEL	EQU	53
MIXEDDUTYACCEL	EQU	54
READM1PID	EQU	55
READM2PID	EQU	56
SETMAINVOLTAGES	EQU	57
SETLOGICVOLTAGES	EQU	58
GETMINMAXMAINVOLTAGES	EQU	59
GETMINMAXLOGICVOLTAGES	EQU	60
SETM1POSPID	EQU	61
SETM2POSPID	EQU	62
READM1POSPID	EQU	63
READM2POSPID	EQU	64
M1SPEEDACCELDECCELPOS	EQU	65
M2SPEEDACCELDECCELPOS	EQU	66
MIXEDSPEEDACCELDECCELPOS	EQU	67
SETM1DEFAULTACCEL	EQU	68
SETM2DEFAULTACCEL	EQU	69
SETPINFUNCTIONS	EQU	74
GETPINFUNCTIONS	EQU	75
SETDEADBAND	EQU	76
GETDEADBAND	EQU	77
RESTOREDEFAULTS	EQU	80
GETTEMP	EQU	82
GETTEMP2	EQU	83
GETERROR	EQU	90
GETENCODERMODE	EQU	91
SETM1ENCODERMODE	EQU	92
SETM2ENCODERMODE	EQU	93
WRITENVM	EQU	94
READNVM	EQU	95
SETCONFIG	EQU	98
GETCONFIG	EQU	99
SETM1MAXCURRENT	EQU	133
SETM2MAXCURRENT	EQU	134
GETM1MAXCURRENT	EQU	135
GETM2MAXCURRENT	EQU	136
SETPWMMODE	EQU	148
GETPWMMODE	EQU	149
FLAGBOOTLOADER	EQU	255
;
;------------------------------------------------------------------------
; ForwardM1
;
; Entry: FSR1->RC_Data, W=Speed 0..127
; Exit: W=true/false
; Ram Used: Param77, Param78, Param79, Param7A
; Calls: write1
;
ForwardM1	movwi	rc_data[FSR1]
	movlw	M1FORWARD
	movwi	rc_cmd[FSR1]
;
; fall thru to write1
;------------------------------------------------------------------------
; write1
;
; Entry: FSR1->RC_Data.rc_address, RC_Data.rc_cmd, RC_Data.rc_data
; Exit: W=true/false
; Ram Used: Param77, Param78, Param79, Param7A
; Calls: sendcommand, writebyte, writechecksum
;
write1	moviw	rc_trystimeout[FSR1]
	movwf	Param77	;trys
write1_L1	call	sendcommand	;send rc_address,rc_cmd
	call	writebyte	;send rc_data
	call	writechecksum
	andlw	true
	SKPZ
	retlw	true
	decfsz	Param77,F
	goto	write1_L1
	retlw	false
;
;------------------------------------------------------------------------
; BackwardM1
;
; Entry: FSR1->RC_Data, W=Speed 0..127
; Exit: W=true/false
; Ram Used: Param77, Param78, Param79, Param7A
; Calls: write1
;
BackwardM1	movwi	rc_data[FSR1]
	movlw	M1BACKWARD
	movwi	rc_cmd[FSR1]
	goto	write1
;
;------------------------------------------------------------------------
;ForwardM2
;
; Entry: FSR1->RC_Data, W=Speed 0..127
; Exit: W=true/false
; Ram Used: Param77, Param78, Param79, Param7A
; Calls: write1
;
ForwardM2	movwi	rc_data[FSR1]
	movlw	M2FORWARD
	movwi	rc_cmd[FSR1]
	goto	write1
;
;------------------------------------------------------------------------
; BackwardM2
;
; Entry: FSR1->RC_Data, W=Speed 0..127
; Exit: W=true/false
; Ram Used: Param77, Param78, Param79, Param7A
; Calls: write1
;
BackwardM2	movwi	rc_data[FSR1]
	movlw	M2BACKWARD
	movwi	rc_cmd[FSR1]
	goto	write1
;
;------------------------------------------------------------------------
; ForwardBackwardM1
;
; Entry: FSR1->RC_Data, W=Speed (0..64..127) (full reverse .. stop .. full forward)
; Exit: W=true/false
; Ram Used: Param77, Param78, Param79, Param7A
; Calls: write1
;
ForwardBackwardM1	movwi	rc_data[FSR1]
	movlw	M17BIT
	movwi	rc_cmd[FSR1]
	goto	write1
;
;------------------------------------------------------------------------
; ForwardBackwardM2
;
; Entry: FSR1->RC_Data, W=Speed (0..64..127) (full reverse .. stop .. full forward)
; Exit: W=true/false
; Ram Used: Param77, Param78, Param79, Param7A
; Calls: write1
;
ForwardBackwardM2	movwi	rc_data[FSR1]
	movlw	M27BIT
	movwi	rc_cmd[FSR1]
	goto	write1
;
;------------------------------------------------------------------------
; write0
;
; Entry: FSR1->RC_Data.rc_address, RC_Data.rc_cmd
; Exit: W=true/false
; Ram Used: Param77, Param78, Param79, Param7A
; Calls: sendcommand, writebyte, writechecksum
;
write0	moviw	rc_trystimeout[FSR1]
	movwf	Param77	;trys
write0_L1	call	sendcommand	;send rc_address,rc_cmd
	call	writechecksum
	andlw	true
	SKPZ
	retlw	true
	decfsz	Param77,F
	goto	write0_L1
	retlw	false
;
;------------------------------------------------------------------------
; writechecksum
;
; Entry: FSR1->RC_Data
; Exit: W=true/false
;
writechecksum	moviw	rc_crc[FSR1]
	movwi	rc_word[FSR1]
	moviw	rc_crc+1[FSR1]
	movwi	rc_word+1[FSR1]
	call	writeword
	call	readbyte
	andlw	true
	SKPNZ
	retlw	false
	moviw	rc_data[FSR1]
	andlw	true
	SKPZ
	retlw	true
	retlw	false
;
;------------------------------------------------------------------------
; readbyte
;
; Entry: FSR1->RC_Data
; Exit: W=true/false,rc_data
; Ram Used:
; Calls: port_read, crc_update
;
readbyte	call	port_read
	andlw	true
	SKPNZ
	retlw	false
	movf	Param78,W
	movwi	rc_data[FSR1]
	call	crc_update
	retlw	true
;
;------------------------------------------------------------------------
; sendcommand
;
; Entry: FSR1->RC_Data.rc_address, RC_Data.rc_cmd
; Exit: none
; Ram Used: Param78, Param79, Param7A
; Calls: crc_clear, crc_update, port_write
;
sendcommand	call	crc_clear
	moviw	rc_address[FSR1]
	movwf	Param78
	call	crc_update	;Adds Param78 to checksum
	call	port_write	;sends Param78
	moviw	rc_cmd[FSR1]
	movwf	Param78
	call	crc_update
	goto	port_write	;sends Param78
;
;------------------------------------------------------------------------
; writeword send MSB,LSB
;
; Entry: FSR1->RC_Data
; Exit: none
;
writeword	moviw	rc_word+1[FSR1]
	movwi	rc_data[FSR1]
	call	writebyte
	moviw	rc_word[FSR1]
	movwi	rc_data[FSR1]
;
; fall thru to writebyte
;------------------------------------------------------------------------
; writebyte
;
; Entry: FSR1->RC_Data.rc_address, RC_Data.rc_data
; Exit: none
; Ram Used: Param78, Param79, Param7A
; Calls: crc_update, port_write
;
writebyte	moviw	rc_data[FSR1]
	movwf	Param78
	call	crc_update
;
; fall thru to port_write
;------------------------------------------------------------------------
; port_write	write a byte to the serial buffer
;
; Entry: Param78=Data
; Exit: none
; Ram Used:
; Calls:
;
port_write	movf	Param78,W
	call	StoreSerOut
	call	SerialIdle
	return
;
;------------------------------------------------------------------------
; port_read	read the next byte of data from the serial buffer
;
; Entry: W=bytes to read
; Exit: Param78=Data, W=true/false
;
port_read	moviw	rc_timeout[FSR1]
	movwf	MilliSeconds
port_read_L1	call	GetSerIn
	btfsc	Param78,0
	bra	port_read_1	;data in W
	call	SerialIdle
	movf	MilliSeconds,W
	SKPZ
	bra	port_read_L1
	retlw	false
;
port_read_1	movwf	Param78
	retlw	true
;
;------------------------------------------------------------------------
; crc_clear
; Entry: FSR1->RC_Data
; Exit: W=0, FSR1=unchanged
;
crc_clear	movlw	0x00
	movwi	rc_crc[FSR1]
	movwi	rc_crc+1[FSR1]
	return
;
;--------------------------------------------------------------------------
; crc_update
; Entry: FSR1->RC_Data, Param78=Data
; Exit: none
; Ram Used: W=changed, FSR1=unchanged, Param78=unchanged, Param79, Param7A
;
crc_update	moviw	rc_crc+1[FSR1]
	xorwf	Param78,W
	movwf	Param7A
	moviw	rc_crc[FSR1]
	movwf	Param79
	btfss	Param7A,7
	bra	crc_update_1
;
	lslf	Param79,W
	xorlw	0x21
	movwi	rc_crc[FSR1]
	rlf	Param7A,W
	xorlw	0x10
	movwi	rc_crc+1[FSR1]
	return	
;	
crc_update_1	lslf	Param79,W
	movwi	rc_crc[FSR1]
	rlf	Param7A,W
	movwi	rc_crc+1[FSR1]
	return
;
;--------------------------------------------------------------------------