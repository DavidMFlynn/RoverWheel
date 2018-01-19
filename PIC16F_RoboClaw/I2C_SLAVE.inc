;=========================================================================================
; PIC12F1822
; I2C SLAVE DRIVER CODE
;
;    Filename:      I2C SLAVE.inc
;    Date:          12/7/2015
;    File Version:  1.0.7
;
;    Author:        David M. Flynn
;    Company:       Oxford V.U.E., Inc.
;    E-Mail:        dflynn@oxfordvue.com
;    Web Site:      http://www.oxfordvue.com/
;
;=========================================================================================
;   I2C Slave Driver Code for PIC16F1822
;
;    History:
;
; 1.0.7  12/7/2015	Changed slave address to ram based I2CAddr.
; 1.0.6  12/5/2015	Fixed some comments.
; 1.0.5  11/9/2015	Added watchdog to recover from wiring glitch.
; 1.0.4  11/5/2015	Optimized some code. Added AHEN=DHEN=1 clock stretching.
; 1.0.3  11/4/2015	Added ACK to R_Data for partial buffer read support.
;	Added PCIE (Stop causes interrupt) to end write 
;	 before all RX_ELEMENTS received.
; 1.0.2  4/25/2015	First woring version
; 1.0.1  9/4/2014	Modified for 12F1822
; 1.0    11/23/2013	Adapted from AN734C
;
; *** Adapted from AN734C ****
; PIC16F1937 
;I2C SLAVE DRIVER CODE 
;Author: Chris Best 
;Microchip Technologies
;DATE: 07/03/2013
;
;=========================================================================================
; Options
;
;   I2C_ADDRESS, TX_ELEMENTS and RX_ELEMENTS must be set and be the same in the master driver.
;
	ifndef useI2CISR
	constant	useI2CISR=1
	endif
;=========================================================================================
;=========================================================================================
; What happens next:
;  Sends or receives TX_ELEMENTS/RX_ELEMENTS bytes of data to/from the master
;
;=========================================================================================
; Routines:
;
; Init_I2C	initial setup, call once before starting main event loop
; I2C_READ
; I2C_WRITE
;
;=========================================================================================
;
;
;Note: only upper 7 bits of address are used
;I2C_ADDRESS	EQU	0x30	; Slave default address
;TX_ELEMENTS	EQU	.8	; number of allowable array elements
;RX_ELEMENTS	EQU	.8	; number of allowable array elements
;I2C_TX_Init_Val	EQU	0xAA	; value to load into transmit array to send to master
;I2C_RX_Init_Val	EQU	0xAA	; value to load into received data array
;
;------------------------------------ variables-------------------------------------------
;	I2CAddr		;Bank 0 Ram
;
;	cblock	0x70									; set up in shared memory for easy access
;	INDEX_I2C		; index used to point to array location
;	TX_DataSize		; # of bytes to TX, 1..TX_ELEMENTS	
;	GFlags
;	endc
;
;#Define	I2C_TXLocked	GFlags,0	; Set/cleared by ISR, data is being sent
;#Define	I2C_RXLocked	GFlags,1	; Set/cleared by ISR, data is being received
;#Define	I2C_NewRXData	GFlags,2	; Set by ISR, The new data is here!
;
;I2C_Buffers	udata	0xA0
;I2C_ARRAY_TX	RES	TX_ELEMENTS	; array to transmit to master
;I2C_ARRAY_RX 	RES	RX_ELEMENTS 	; array to receive from master
;	
;	if useI2CWDT
;TimerI2C	EQU	Timer1Lo
;	endif
;
;=========================================================================================
;----------------------------------- interrupt service routines --------------------------
;
;-----------------------------------------------------------------------------------------
; I2C Com
;	MOVLB	0x00
;	btfsc	PIR1,SSP1IF 	; Is this a SSP interrupt?
;	call	I2C_ISR
;	movlb	0
;
;-----------------------------------------------------------------------------------------
; I2C Bus Collision
;IRQ_5	MOVLB	0x00
;	btfss	PIR2,BCL1IF
;	goto	IRQ_5_End
;
;	banksel	SSP1BUF						
;	movf	SSP1BUF,w	; clear the SSP buffer
;	bsf	SSP1CON1,CKP	; release clock stretch
;	movlb	0x00
;	bcf	PIR2,BCL1IF	; clear the SSP interrupt flag	
;
;IRQ_5_End:
;
;=========================================================================================
;
;LOADFSR1	macro 	ADDRESS,INDEX 	; ADDRESS = I2C_ARRAY, INDEX = INDEX_I2C			
;	movlw 	low ADDRESS 	; load address 						
;	addwf	INDEX,W	; add the index value to determine location in array
;	movwf 	FSR1L	; load FSR1L with pointer info
;	clrf	FSR1H
;	movlw	high ADDRESS
;	addwfc	FSR1H,F
;	endm		
;
;=========================================================================================
;	Main
;-----------------------------------------------------------------------------------------
;
;	call	Init_I2C	; set up uC
;
;=========================================================================================
;=========================================================================================
; I2C Idle routine, only needed if useI2CWDT is used
;=========================================================================================
; Call from main loop
;
I2C_Idle	movlb	0
	movf	TimerI2C,F
	SKPZ
	return
;
; fall thru to Init_I2C
;
;-----------------------------------------------------------------------------------------
;	Initialize: Sets up register values 
;-----------------------------------------------------------------------------------------
; fill the RX and TX arrays with I2C_TX_Init_Val, I2C_RX_Init_Val
;
Init_I2C:
; for J=0 to TX_ELEMENTS-1
;  I2C_ARRAY_TX(J)=I2C_TX_Init_Val
	movlw	low I2C_ARRAY_TX
	movwf	FSR1L
	movlw	high I2C_ARRAY_TX
	movwf	FSR1H
	movlw	TX_ELEMENTS
	movwf	INDEX_I2C
	movwf	TX_DataSize
	movlw	I2C_TX_Init_Val
Init_I2C_L1	movwi	FSR1++
	decfsz	INDEX_I2C,F
	goto	Init_I2C_L1
;
	movlw	low I2C_ARRAY_RX
	movwf	FSR1L
	movlw	high I2C_ARRAY_RX
	movwf	FSR1H
	movlw	RX_ELEMENTS
	movwf	INDEX_I2C
	movlw	I2C_RX_Init_Val
Init_I2C_L2	movwi	FSR1++
	decfsz	INDEX_I2C,F
	goto	Init_I2C_L2
;
;I2C set up
	clrf	INDEX_I2C	; index used to point to array location
	clrf	GFlags
;
	banksel	SSP1STAT
	bsf	SSP1STAT,SMP	; Slew rate control disabled for standard speed mode
	clrf	SSP1CON1	;Reset SSP
	movlw	b'00110110'	; Enable serial port, I2C slave mode, 7-bit address
	movwf	SSP1CON1
	bsf	SSP1CON2,SEN	; enable clock stretching
	bsf	SSP1CON3,BOEN	; SSPBUF is updated and NACK is generated 	
			; for a received address/data byte, 
			; ignoring the state of SSPOV bit only if BF bit = 0.
	bsf	SSP1CON3,SDAHT	; Minimum of 300 ns hold time
	bsf	SSP1CON3,PCIE	; Stop causes interupt
	bsf	SSP1CON3,AHEN	; Enable address holding, CKP must be set after each byte
	bsf	SSP1CON3,DHEN	; Enable data holding
	movlb	0
	movf	I2CAddr,W	; load the slave address
	BANKSEL	SSP1ADD
	movwf	SSP1ADD
;
	if useI2CISR
	movlb	0x01
	bsf	PIE2,BCL1IE	; enable SSP interrupts
	bsf	PIE1,SSP1IE	; enable SSP interrupts
	endif
	movlb	0x00
	bcf	PIR1,SSP1IF	; clear the SSP interrupt flag	
	bcf	PIR2,BCL1IF	; clear the SSP interrupt flag
	return
;
;=========================================================================================				
; Interrupt Service Routines (ISR)
;=========================================================================================
;
I2C_ISR:
	if useI2CWDT
	BSF	TimerI2C,7	;Kick the dog
	endif
;
	bcf 	PIR1,SSP1IF	; clear the SSP interrupt flag
	banksel	SSP1STAT						
	btfss	SSP1STAT,R_NOT_W	; is it a master read:
	goto	I2C_WRITE
; I2C_READ
	btfsc	SSP1STAT,D_NOT_A	; was last byte an address or data?
	goto	R_DATA	; if set, it was data
;	
R_ADDRESS	bcf	SSP1CON2,ACKDT
	btfss	SSP1CON3,ACKTIM
	goto	R_Add_ACK
	movf	SSP1BUF,W	; dummy read to clear BF bit
	bsf	SSP1CON1,CKP	; release clock stretch
	return	
;
R_Add_ACK	clrf	INDEX_I2C	; clear index pointer
	LOADFSR1	I2C_ARRAY_TX,INDEX_I2C
	movf	INDF1,W	; move value into W to load to SSP buffer
	movwf	SSP1BUF	; load SSP buffer
	bsf	SSP1CON1,CKP
;
	incf	INDEX_I2C,F	; increment INDEX_I2C 'pointer'
	bsf	I2C_TXLocked	; lock data
	return
;
;----------------
;
R_DATA	btfsc	SSP1CON2,ACKSTAT	; ACK* = Master wants another byte
	goto	R_Data_NACK	;  don't send another
;
	movf	TX_DataSize,W	; load array elements to TX
	subwf	INDEX_I2C,W	; if Z = 1, subtract index from number of elements
	CLRW		;default to sending 0, filler byte
	btfsc	_C	; did a carry occur after subtraction?
	goto	R_PastEnd	; if so, Master is trying to read to many bytes
	LOADFSR1	I2C_ARRAY_TX,INDEX_I2C
	incf	INDEX_I2C,F	; increment INDEX_I2C 'pointer'
	movf	INDF1,W	; move value into W to load to SSP buffer
R_PastEnd	movwf	SSP1BUF	; load SSP buffer
;
	movf	TX_DataSize,W
	subwf	INDEX_I2C,W
	btfsc	_Z
	BCF	I2C_TXLocked
	bsf	SSP1CON1,CKP
	return
;
R_Data_NACK	BCF	I2C_TXLocked	;unlock data
	Return 
;
;-----------------------------------------------------------------------------------------
;
I2C_WRITE	btfsc	SSP1STAT,D_NOT_A	; was last byte an address or data?
	goto	W_DATA	; if set, it was data
;
W_ADDRESS	bcf	SSP1CON2,ACKDT	;We will ACK*
	movf	SSP1BUF,W	; dummy read to clear the BF bit
	clrf	INDEX_I2C	; clear index pointer
	BSF	I2C_RXLocked	; lock data
W_ACK	bsf	SSP1CON1,CKP	; release clock stretch
	return
;
W_DATA	btfsc	SSP1STAT,P	;Stop bit?
	goto	W_Data_Stop	;  Yes
;
	btfss	SSP1CON3,ACKTIM	;Data arrived?
	goto	W_ACK	; no, just an outgoing ACK*	
;	
	btfss	SSP1STAT,BF	;Buffer full?
	return		; no
;
	bsf	SSP1CON1,CKP	; release clock stretch
	movlw	RX_ELEMENTS	; load array elements value
	subwf	INDEX_I2C,W	; if Z = 1, subtract index from number of elements
	btfsc	_C	; did a carry occur after subtraction?
	goto	NO_MEM_OVERWRITE	; if so, Master is trying to write to many bytes
;
	LOADFSR1	I2C_ARRAY_RX,INDEX_I2C
	incf	INDEX_I2C,F	; increment INDEX_I2C 'pointer'
	movf	SSP1BUF,W	; move the contents of the buffer into W
	movwf 	INDF1	; load INDF1 with data to write
	BSF	I2C_NewRXData	;new data is available
;
	movlw	RX_ELEMENTS
	subwf	INDEX_I2C,W
	SKPZ		;Last byte?
	return		; no
	bsf	SSP1CON2,ACKDT	;Yes, We will not ACK*
;	
W_Data_Stop	BCF	I2C_RXLocked	;unlock data
	return	
;
;-----------------------------------------------------------------------------------------
;
NO_MEM_OVERWRITE	movf	SSP1BUF,W	; clear buffer so no overwrite occurs
	return
;
;-----------------------------------------------------------------------------------------
;
;
;	
		
		
		
		
		
		
		
		
		
		
		
		
		
											; END OF PROGRAM
