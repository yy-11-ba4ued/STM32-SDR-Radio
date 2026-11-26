	.text
	.syntax unified
	.eabi_attribute	67, "2.09"	@ Tag_conformance
	.cpu	cortex-m7
	.eabi_attribute	6, 13	@ Tag_CPU_arch
	.eabi_attribute	7, 77	@ Tag_CPU_arch_profile
	.eabi_attribute	8, 0	@ Tag_ARM_ISA_use
	.eabi_attribute	9, 2	@ Tag_THUMB_ISA_use
	.fpu	fpv5-d16
	.eabi_attribute	36, 1	@ Tag_FP_HP_extension
	.eabi_attribute	34, 1	@ Tag_CPU_unaligned_access
	.eabi_attribute	17, 1	@ Tag_ABI_PCS_GOT_use
	.eabi_attribute	20, 2	@ Tag_ABI_FP_denormal
	.eabi_attribute	21, 0	@ Tag_ABI_FP_exceptions
	.eabi_attribute	23, 1	@ Tag_ABI_FP_number_model
	.eabi_attribute	24, 1	@ Tag_ABI_align_needed
	.eabi_attribute	25, 1	@ Tag_ABI_align_preserved
	.eabi_attribute	28, 1	@ Tag_ABI_VFP_args
	.eabi_attribute	38, 1	@ Tag_ABI_FP_16bit_format
	.eabi_attribute	18, 2	@ Tag_ABI_PCS_wchar_t
	.eabi_attribute	26, 1	@ Tag_ABI_enum_size
	.eabi_attribute	14, 0	@ Tag_ABI_PCS_R9_use
	.file	"main.c"
	.section	.text.DMA1_Stream6_IRQHandler,"ax",%progbits
	.hidden	DMA1_Stream6_IRQHandler         @ -- Begin function DMA1_Stream6_IRQHandler
	.globl	DMA1_Stream6_IRQHandler
	.p2align	3
	.type	DMA1_Stream6_IRQHandler,%function
	.code	16                              @ @DMA1_Stream6_IRQHandler
	.thumb_func
DMA1_Stream6_IRQHandler:
	.fnstart
	.cfi_sections .debug_frame
	.cfi_startproc
@ %bb.0:
	movw	r0, :lower16:hdma_usart2_tx
	movt	r0, :upper16:hdma_usart2_tx
	b	HAL_DMA_IRQHandler
.Lfunc_end0:
	.size	DMA1_Stream6_IRQHandler, .Lfunc_end0-DMA1_Stream6_IRQHandler
	.cfi_endproc
	.cantunwind
	.fnend
                                        @ -- End function
	.section	.text.SPI3_IRQHandler,"ax",%progbits
	.hidden	SPI3_IRQHandler                 @ -- Begin function SPI3_IRQHandler
	.globl	SPI3_IRQHandler
	.p2align	3
	.type	SPI3_IRQHandler,%function
	.code	16                              @ @SPI3_IRQHandler
	.thumb_func
SPI3_IRQHandler:
	.fnstart
	.cfi_startproc
@ %bb.0:
	.save	{r4, r5, r6, r7, r8, lr}
	push.w	{r4, r5, r6, r7, r8, lr}
	.cfi_def_cfa_offset 24
	.cfi_offset lr, -4
	.cfi_offset r8, -8
	.cfi_offset r7, -12
	.cfi_offset r6, -16
	.cfi_offset r5, -20
	.cfi_offset r4, -24
	movw	r5, #15380
	movt	r5, #16384
	ldr	r0, [r5]
	lsls	r0, r0, #31
	bne	.LBB1_3
.LBB1_1:
	ldr	r0, [r5]
	lsls	r0, r0, #25
	it	pl
	poppl.w	{r4, r5, r6, r7, r8, pc}
.LBB1_2:
	movs	r0, #64
	str	r0, [r5, #4]
	pop.w	{r4, r5, r6, r7, r8, pc}
	.p2align	2
.LBB1_3:
	ldrb	r0, [r5, #28]
	sub.w	r1, r0, #32
	cmp	r1, #94
	bhi	.LBB1_6
@ %bb.4:
	movw	r1, :lower16:.L_MergedGlobals.41
	movt	r1, :upper16:.L_MergedGlobals.41
	ldrb	r2, [r1, #5]
	cmp	r2, #46
	bhi	.LBB1_1
@ %bb.5:
	movw	r3, :lower16:.L_MergedGlobals.43
	movt	r3, :upper16:.L_MergedGlobals.43
	add	r3, r2
	adds	r2, #1
	strb	r2, [r1, #5]
	strb.w	r0, [r3, #48]
	b	.LBB1_1
	.p2align	2
.LBB1_6:
	subs.w	r1, r0, #10
	it	ne
	movne	r1, #1
	subs	r0, #13
	it	ne
	movne	r0, #1
	tst	r1, r0
	bne	.LBB1_1
@ %bb.7:
	movw	r6, :lower16:.L_MergedGlobals.41
	movt	r6, :upper16:.L_MergedGlobals.41
	ldrb	r7, [r6, #5]
	cmp	r7, #0
	beq	.LBB1_1
@ %bb.8:
	movw	r1, :lower16:.L_MergedGlobals.43
	ldrb	r0, [r6, #6]
	movt	r1, :upper16:.L_MergedGlobals.43
	movs	r2, #5
	add.w	r4, r1, #48
	adds	r0, #1
	and	r8, r0, #7
	movs	r0, #0
	strb	r0, [r4, r7]
	adr	r1, .LCPI1_0
	mov	r0, r4
	bl	memcmp
	cbz	r0, .LBB1_11
@ %bb.9:
	adr	r1, .LCPI1_1
	movs	r2, #5
	mov	r0, r4
	bl	memcmp
	cbnz	r0, .LBB1_13
@ %bb.10:
	movs	r0, #0
	b	.LBB1_12
	.p2align	2
.LBB1_11:
	movs	r0, #1
.LBB1_12:
	strb	r0, [r6, #2]
.LBB1_13:
	ldrb	r0, [r6, #7]
	cmp	r8, r0
	beq	.LBB1_15
@ %bb.14:
	ldrb	r0, [r6, #6]
	movw	r1, :lower16:cmd_line_queue
	movt	r1, :upper16:cmd_line_queue
	adds	r2, r7, #1
	add.w	r0, r0, r0, lsl #1
	add.w	r0, r1, r0, lsl #4
	mov	r1, r4
	bl	__aeabi_memcpy
	strb.w	r8, [r6, #6]
.LBB1_15:
	movs	r0, #0
	strb	r0, [r6, #5]
	b	.LBB1_1
	.p2align	2
@ %bb.16:
.LCPI1_0:
.L.str:
	.asciz	"TX 1\000\000\000"
.LCPI1_1:
.L.str.1:
	.asciz	"TX 0\000\000\000"
.Lfunc_end1:
	.size	SPI3_IRQHandler, .Lfunc_end1-SPI3_IRQHandler
	.cfi_endproc
	.cantunwind
	.fnend
                                        @ -- End function
	.section	.text.hot.TIM2_IRQHandler,"ax",%progbits
	.hidden	TIM2_IRQHandler                 @ -- Begin function TIM2_IRQHandler
	.globl	TIM2_IRQHandler
	.p2align	3
	.type	TIM2_IRQHandler,%function
	.code	16                              @ @TIM2_IRQHandler
	.thumb_func
TIM2_IRQHandler:
	.fnstart
	.cfi_startproc
@ %bb.0:
	.save	{r4, lr}
	push	{r4, lr}
	.cfi_def_cfa_offset 8
	.cfi_offset lr, -4
	.cfi_offset r4, -8
	movs	r0, #16
	movw	r4, :lower16:.L_MergedGlobals.41
	movt	r0, #16384
	movt	r4, :upper16:.L_MergedGlobals.41
	mvn	r1, #1
	str	r1, [r0]
	ldr	r0, [r4, #48]
	adds	r0, #1
	str	r0, [r4, #48]
	ldr	r0, [r4, #44]
	adds	r0, #1
	str	r0, [r4, #44]
	ldr	r0, [r4, #60]
	adds	r0, #1
	str	r0, [r4, #60]
	ldr	r0, [r4, #48]
	lsls	r0, r0, #25
	bne	.LBB2_2
@ %bb.1:
	movw	r0, #2048
	mov.w	r1, #8192
	movt	r0, #22530
	bl	HAL_GPIO_ReadPin
	clz	r0, r0
	lsrs	r0, r0, #5
	strb	r0, [r4, #3]
.LBB2_2:
	ldrb	r0, [r4]
	cmp	r0, #0
	movw	r0, #29704
	movt	r0, #16384
	bne	.LBB2_4
@ %bb.3:
	ldrb	r1, [r4, #2]
	cmp	r1, #0
	beq	.LBB2_17
.LBB2_4:
	movs	r1, #1
	strb	r1, [r4, #4]
.LBB2_5:
	movw	r2, #40703
	ldr	r1, [r4, #44]
	movt	r2, #36
	movs	r3, #0
	cmp	r1, r2
	movw	r1, :lower16:.L_MergedGlobals
	it	hi
	movhi	r3, #1
	movt	r1, :upper16:.L_MergedGlobals
	strb	r3, [r4, #8]
	ldrb	r2, [r1]
	cmp	r2, #7
	bne	.LBB2_7
@ %bb.6:
	ldr	r2, [r1, #24]
	b	.LBB2_8
	.p2align	2
.LBB2_7:
	movw	r2, #39322
	movt	r2, #12697
.LBB2_8:
	ldr	r3, [r4, #64]
	add	r2, r3
	str	r2, [r4, #64]
	ldr	r2, [r4, #64]
	movw	r3, :lower16:cos_table_q15
	lsrs	r2, r2, #20
	movt	r3, :upper16:cos_table_q15
	ldrsh.w	r2, [r3, r2, lsl #1]
	ldrb	r3, [r1]
	cmp	r3, #6
	bne	.LBB2_10
.LBB2_9:
	mov.w	r1, #2000
	muls	r1, r2, r1
	b	.LBB2_12
	.p2align	2
.LBB2_10:
	ldrb	r3, [r1]
	cmp	r3, #8
	bne	.LBB2_13
@ %bb.11:
	ldr	r1, [r1, #28]
	muls	r1, r2, r1
.LBB2_12:
	mov.w	r2, #2048
	add.w	r1, r2, r1, asr #15
	usat	r1, #12, r1
	uxth	r1, r1
	str	r1, [r0]
	str	r1, [r0, #12]
	pop	{r4, pc}
	.p2align	2
.LBB2_13:
	ldrb	r3, [r4, #8]
	cmp	r3, #0
	beq	.LBB2_9
@ %bb.14:
	ldrb	r3, [r1]
	cmp	r3, #1
	beq	.LBB2_9
@ %bb.15:
	ldrb	r1, [r1]
	cmp	r1, #7
	beq	.LBB2_9
@ %bb.16:
	ldr	r1, [r4, #64]
	ldr	r3, [r4, #56]
	add	r1, r3
	movw	r3, :lower16:sin_table_q15
	lsrs	r1, r1, #20
	movt	r3, :upper16:sin_table_q15
	ldrsh.w	r1, [r3, r1, lsl #1]
	ldr	r3, [r4, #68]
	ldr	r4, [r4, #72]
	muls	r2, r3, r2
	mov.w	r3, #2048
	muls	r1, r4, r1
	add.w	r2, r3, r2, asr #15
	add.w	r1, r3, r1, asr #15
	usat	r2, #12, r2
	usat	r1, #12, r1
	uxth	r2, r2
	str	r2, [r0]
	uxth	r1, r1
	str	r1, [r0, #12]
	pop	{r4, pc}
	.p2align	2
.LBB2_17:
	ldrb	r1, [r4, #3]
	cmp	r1, #0
	it	ne
	movne	r1, #1
	strb	r1, [r4, #4]
	bne	.LBB2_5
@ %bb.18:
	mov.w	r1, #2048
	str	r1, [r0]
	str	r1, [r0, #12]
	pop	{r4, pc}
.Lfunc_end2:
	.size	TIM2_IRQHandler, .Lfunc_end2-TIM2_IRQHandler
	.cfi_endproc
	.cantunwind
	.fnend
                                        @ -- End function
	.section	.text.hot.TIM3_IRQHandler,"ax",%progbits
	.hidden	TIM3_IRQHandler                 @ -- Begin function TIM3_IRQHandler
	.globl	TIM3_IRQHandler
	.p2align	3
	.type	TIM3_IRQHandler,%function
	.code	16                              @ @TIM3_IRQHandler
	.thumb_func
TIM3_IRQHandler:
	.fnstart
	.cfi_startproc
@ %bb.0:
	movw	r0, #1040
	movt	r0, #16384
	ldr	r1, [r0]
	lsls	r1, r1, #31
	it	eq
	bxeq	lr
.LBB3_1:
	mvn	r1, #1
	str	r1, [r0]
	movw	r0, :lower16:.L_MergedGlobals.41
	movt	r0, :upper16:.L_MergedGlobals.41
	ldr	r1, [r0, #76]
	adds	r1, #1
	str	r1, [r0, #76]
	movw	r0, :lower16:.L_MergedGlobals
	movt	r0, :upper16:.L_MergedGlobals
	ldrb	r0, [r0, #1]
	cbz	r0, .LBB3_3
@ %bb.2:
	movs	r0, #16
	mov.w	r2, #4096
	movt	r0, #16386
	ldr	r1, [r0, #4]
	ldr	r0, [r0]
	bic.w	r0, r2, r0, lsr #7
	movw	r2, :lower16:adc_dma_buf
	subs	r0, r0, r1
	movw	r1, :lower16:adc_dma_buf2
	add.w	r0, r0, #8128
	movt	r1, :upper16:adc_dma_buf2
	bfc	r0, #13, #19
	movt	r2, :upper16:adc_dma_buf
	cmp.w	r0, #4096
	add.w	r1, r1, r0, lsl #1
	sub.w	r1, r1, #8192
	it	lo
	addlo.w	r1, r2, r0, lsl #1
	ldrh	r0, [r1]
	mov.w	r1, #32768
	eor.w	r0, r1, r0, lsl #4
	sxth	r0, r0
	b	am_demod_input
	.p2align	2
.LBB3_3:
	bx	lr
.Lfunc_end3:
	.size	TIM3_IRQHandler, .Lfunc_end3-TIM3_IRQHandler
	.cfi_endproc
	.cantunwind
	.fnend
                                        @ -- End function
	.section	.text.hot.TIM4_IRQHandler,"ax",%progbits
	.hidden	TIM4_IRQHandler                 @ -- Begin function TIM4_IRQHandler
	.globl	TIM4_IRQHandler
	.p2align	3
	.type	TIM4_IRQHandler,%function
	.code	16                              @ @TIM4_IRQHandler
	.thumb_func
TIM4_IRQHandler:
	.fnstart
	.cfi_startproc
@ %bb.0:
	.save	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	push.w	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	.cfi_def_cfa_offset 36
	.cfi_offset lr, -4
	.cfi_offset r11, -8
	.cfi_offset r10, -12
	.cfi_offset r9, -16
	.cfi_offset r8, -20
	.cfi_offset r7, -24
	.cfi_offset r6, -28
	.cfi_offset r5, -32
	.cfi_offset r4, -36
	.pad	#68
	sub	sp, #68
	.cfi_def_cfa_offset 104
	movw	r0, #2064
	movt	r0, #16384
	ldr	r1, [r0]
	lsls	r1, r1, #31
	beq.w	.LBB4_42
@ %bb.1:
	movw	r4, :lower16:.L_MergedGlobals.41
	mvn	r1, #1
	movt	r4, :upper16:.L_MergedGlobals.41
	str	r1, [r0]
	ldr	r0, [r4, #80]
	adds	r0, #1
	str	r0, [r4, #80]
	ldrb	r0, [r4]
	cbnz	r0, .LBB4_4
@ %bb.2:
	ldrb	r0, [r4, #2]
	cbnz	r0, .LBB4_4
@ %bb.3:
	ldrb	r0, [r4, #3]
	cmp	r0, #0
	beq.w	.LBB4_42
.LBB4_4:
	movw	r9, :lower16:.L_MergedGlobals
	movt	r9, :upper16:.L_MergedGlobals
	ldrb.w	r0, [r9]
	cmp	r0, #1
	beq.w	.LBB4_42
@ %bb.5:
	ldrb.w	r0, [r9]
	cmp	r0, #5
	beq.w	.LBB4_42
@ %bb.6:
	ldrb.w	r0, [r9]
	cmp	r0, #6
	beq.w	.LBB4_42
@ %bb.7:
	ldrb.w	r0, [r9]
	cmp	r0, #4
	bne	.LBB4_9
@ %bb.8:
	ldr	r0, [r4, #84]
	ldr	r1, [r4, #88]
	add	r0, r1
	str	r0, [r4, #88]
	ldr	r0, [r4, #88]
	movw	r1, :lower16:sin_table_q15
	lsrs	r0, r0, #20
	movt	r1, :upper16:sin_table_q15
	ldrh.w	r2, [r1, r0, lsl #1]
	b	.LBB4_10
	.p2align	2
.LBB4_9:
	movw	r0, #24640
	movt	r0, #22530
	ldr	r0, [r0]
	ldr.w	r1, [r9, #16]
	uxth	r0, r0
	ldr.w	r2, [r9, #32]
	sub.w	r2, r2, r2, lsr #10
	add.w	r2, r2, r0, lsl #6
	str.w	r2, [r9, #32]
	sub.w	r0, r0, r2, lsr #16
	str	r0, [r4, #52]
	muls	r1, r0, r1
	ssat	r2, #16, r1
.LBB4_10:
	strh	r2, [r4, #20]
	movw	r12, :lower16:dec_buf
	ldrh	r1, [r4, #32]
	movt	r12, :upper16:dec_buf
	add.w	r3, r12, r1, lsl #1
	strh.w	r2, [r12, r1, lsl #1]
	adds	r1, #1
	strh.w	r2, [r3, #256]
	and	lr, r1, #127
	strh.w	r2, [r3, #512]
	strh.w	lr, [r4, #32]
	ldrb.w	r3, [r9]
	cmp	r3, #7
	beq	.LBB4_12
@ %bb.11:
	ldrb.w	r3, [r9]
	cmp	r3, #8
	bne	.LBB4_13
.LBB4_12:
	ldrd	r3, r7, [r4, #92]
	ldr	r6, [r4, #100]
	movs	r5, #73
	muls	r5, r3, r5
	movw	r0, #19871
	sxtah	r7, r7, r2
	mla	r0, r6, r0, r5
	movs	r5, #37
	ldr	r1, [r4, #104]
	sxth	r2, r2
	mla	r0, r7, r5, r0
	movw	r7, #59244
	str	r6, [r4, #104]
	movt	r7, #65535
	movw	r6, #24245
	mla	r0, r1, r7, r0
	ldr	r7, [r4, #116]
	strd	r2, r3, [r4, #92]
	ldrd	r3, r2, [r4, #108]
	ssat	r0, #16, r0, asr #14
	ldr	r5, [r4, #120]
	str	r0, [r4, #100]
	add	r2, r0
	lsls	r2, r2, #14
	add.w	r2, r2, r3, lsl #15
	mla	r2, r7, r6, r2
	movw	r6, #54253
	movt	r6, #65535
	mla	r2, r5, r6, r2
	movw	r6, #1365
	strd	r0, r3, [r4, #108]
	movw	r3, #39322
	ssat	r0, #16, r2, asr #14
	movw	r2, :lower16:.L_MergedGlobals.42
	strd	r0, r7, [r4, #116]
	mov.w	r7, #1000
	movt	r2, :upper16:.L_MergedGlobals.42
	mul	r5, r0, r7
	movt	r3, #12697
	str	r0, [r2]
	mla	r0, r0, r6, r3
	str.w	r0, [r9, #24]
	add.w	r0, r7, r5, asr #15
	str.w	r0, [r9, #28]
.LBB4_13:
	ldrb.w	r0, [r9]
	cbz	r0, .LBB4_17
@ %bb.14:
	ldrb.w	r0, [r9]
	cmp	r0, #2
	beq	.LBB4_17
@ %bb.15:
	ldrb.w	r0, [r9]
	cmp	r0, #3
	beq	.LBB4_17
@ %bb.16:
	ldrb.w	r0, [r9]
	cmp	r0, #4
	bne.w	.LBB4_30
.LBB4_17:
	ldrh.w	r11, [r4, #34]
	movw	r0, :lower16:.L_MergedGlobals.42
	movt	r0, :upper16:.L_MergedGlobals.42
	cmp.w	r11, #0
	beq	.LBB4_19
@ %bb.18:
	ldrd	r12, r1, [r0, #64]
	str	r1, [sp, #64]                   @ 4-byte Spill
	ldrd	r6, r7, [r0, #72]
	b	.LBB4_22
	.p2align	2
.LBB4_19:
	movs	r5, #0
	add.w	r8, r12, lr, lsl #1
	strd	r5, r5, [r0, #64]
	strd	r5, r5, [r0, #72]
	movw	r0, :lower16:ssb_win_lo
	movs	r2, #128
	movt	r0, :upper16:ssb_win_lo
	mov	r1, r8
	bl	__aeabi_memcpy
	movw	r0, :lower16:ssb_win_hi
	movt	r0, :upper16:ssb_win_hi
	adds	r0, #30
	.p2align	2
.LBB4_20:                               @ =>This Inner Loop Header: Depth=1
	add.w	r1, r8, r5
	subs	r5, #32
	ldrh.w	r2, [r1, #254]
	ldr.w	r3, [r1, #250]
	strh	r2, [r0, #-30]
	ror.w	r2, r3, #16
	str	r2, [r0, #-28]
	ldr.w	r2, [r1, #246]
	ldr.w	r3, [r1, #242]
	ror.w	r2, r2, #16
	str	r2, [r0, #-24]
	ror.w	r2, r3, #16
	str	r2, [r0, #-20]
	ldr.w	r2, [r1, #226]
	ldr.w	r3, [r1, #230]
	ldr.w	r7, [r1, #238]
	ldr.w	r6, [r1, #234]
	ldrh.w	r1, [r1, #224]
	ror.w	r7, r7, #16
	str	r7, [r0, #-16]
	ror.w	r7, r6, #16
	str	r7, [r0, #-12]
	ror.w	r3, r3, #16
	str	r3, [r0, #-8]
	ror.w	r2, r2, #16
	str	r2, [r0, #-4]
	adds.w	r2, r5, #128
	strh	r1, [r0]
	add.w	r0, r0, #32
	bne	.LBB4_20
@ %bb.21:
	movs	r6, #0
	movs	r7, #0
	mov.w	r12, #0
	movs	r0, #0
	str	r0, [sp, #64]                   @ 4-byte Spill
.LBB4_22:
	add.w	r0, r11, #16
	uxth	r2, r0
	mov	r3, r2
	cmp	r2, #64
	it	hs
	movhs	r3, #64
	cmp	r11, r3
	bhs	.LBB4_26
@ %bb.23:
	sub.w	r0, r3, r11
	mvn.w	r1, r11
	ands	r8, r0, #3
	movw	lr, :lower16:h_q15
	movw	r9, :lower16:g_q15
	movw	r10, :lower16:ssb_win_lo
	movw	r0, :lower16:ssb_win_hi
	add	r1, r3
	movt	lr, :upper16:h_q15
	movt	r9, :upper16:g_q15
	movt	r10, :upper16:ssb_win_lo
	movt	r0, :upper16:ssb_win_hi
	str	r2, [sp]                        @ 4-byte Spill
	str	r3, [sp, #4]                    @ 4-byte Spill
	beq	.LBB4_27
@ %bb.24:
	ldrsh.w	r2, [r0, r11, lsl #1]
	ldrsh.w	r3, [r10, r11, lsl #1]
	ldrsh.w	r4, [r9, r11, lsl #1]
	ldrsh.w	r0, [lr, r11, lsl #1]
	adds	r5, r3, r2
	subs	r2, r2, r3
	muls	r4, r5, r4
	str	r1, [sp, #60]                   @ 4-byte Spill
	ldr	r1, [sp, #64]                   @ 4-byte Reload
	muls	r2, r0, r2
	adds.w	r12, r12, r4
	adc.w	r1, r1, r4, asr #31
	adds	r6, r6, r2
	adc.w	r7, r7, r2, asr #31
	cmp.w	r8, #1
	add.w	r2, r11, #1
	str	r1, [sp, #64]                   @ 4-byte Spill
	bne	.LBB4_28
@ %bb.25:
	mov	r8, r9
	mov	r3, lr
	mov	r11, r2
	mov	lr, r7
	mov	r7, r6
	b	.LBB4_32
	.p2align	2
.LBB4_26:
	lsrs	r0, r6, #15
	orr.w	r1, r0, r7, lsl #17
	ldr	r7, [sp, #64]                   @ 4-byte Reload
	lsr.w	r0, r12, #15
	orr.w	r0, r0, r7, lsl #17
	cmp	r2, #63
	strh	r3, [r4, #34]
	bhi.w	.LBB4_37
	b	.LBB4_42
	.p2align	2
.LBB4_27:
	mov	r8, r9
	mov	r3, lr
	mov	lr, r7
	mov	r7, r6
	b	.LBB4_33
	.p2align	2
.LBB4_28:
	movw	r0, :lower16:ssb_win_hi
	ldrsh.w	r4, [r10, r2, lsl #1]
	movt	r0, :upper16:ssb_win_hi
	ldrsh.w	r5, [r9, r2, lsl #1]
	ldr	r1, [sp, #64]                   @ 4-byte Reload
	ldrsh.w	r3, [r0, r2, lsl #1]
	ldrsh.w	r2, [lr, r2, lsl #1]
	adds	r0, r4, r3
	subs	r3, r3, r4
	muls	r5, r0, r5
	add.w	r0, r11, #2
	muls	r2, r3, r2
	mov	r4, lr
	adds.w	r12, r12, r5
	adc.w	r1, r1, r5, asr #31
	adds	r6, r6, r2
	adc.w	r7, r7, r2, asr #31
	cmp.w	r8, #2
	mov	lr, r7
	str	r1, [sp, #64]                   @ 4-byte Spill
	bne	.LBB4_31
@ %bb.29:
	mov	r8, r9
	mov	r3, r4
	mov	r11, r0
	mov	r7, r6
	b	.LBB4_32
	.p2align	2
.LBB4_30:
	movw	r1, :lower16:.L_MergedGlobals.42
	movs	r0, #0
	movt	r1, :upper16:.L_MergedGlobals.42
	strh	r0, [r4, #34]
	strd	r0, r0, [r1, #64]
	strd	r0, r0, [r1, #72]
	b	.LBB4_42
	.p2align	2
.LBB4_31:
	movw	r2, :lower16:ssb_win_hi
	ldrsh.w	r7, [r10, r0, lsl #1]
	movt	r2, :upper16:ssb_win_hi
	mov	r8, r9
	ldrsh.w	r9, [r9, r0, lsl #1]
	mov	r3, r4
	ldrsh.w	r2, [r2, r0, lsl #1]
	ldrsh.w	r0, [r4, r0, lsl #1]
	add.w	r11, r11, #3
	adds	r5, r7, r2
	subs	r2, r2, r7
	mul	r4, r5, r9
	muls	r0, r2, r0
	adds.w	r12, r12, r4
	adc.w	r1, r1, r4, asr #31
	adds	r7, r6, r0
	adc.w	lr, lr, r0, asr #31
	str	r1, [sp, #64]                   @ 4-byte Spill
.LBB4_32:
	ldr	r1, [sp, #60]                   @ 4-byte Reload
.LBB4_33:
	cmp	r1, #3
	blo.w	.LBB4_36
@ %bb.34:
	movw	r2, :lower16:ssb_win_lo
	movw	r9, :lower16:ssb_win_hi
	ldr	r0, [sp, #4]                    @ 4-byte Reload
	movt	r2, :upper16:ssb_win_lo
	movt	r9, :upper16:ssb_win_hi
	sub.w	r0, r0, r11
	subs	r5, r3, #2
	sub.w	r1, r8, #2
	subs	r4, r2, #2
	sub.w	r6, r9, #2
	sub.w	r8, r8, #4
	sub.w	r10, r2, #4
	sub.w	r2, r9, #4
	subs	r3, #4
	str	r3, [sp, #60]                   @ 4-byte Spill
	lsl.w	r3, r11, #1
	str	r3, [sp, #8]                    @ 4-byte Spill
	.p2align	2
.LBB4_35:                               @ =>This Inner Loop Header: Depth=1
	mov	r9, lr
	ldr.w	lr, [sp, #8]                    @ 4-byte Reload
	strd	r4, r1, [sp, #48]               @ 8-byte Folded Spill
	add.w	r3, r6, lr
	add	r4, lr
	str	r0, [sp, #56]                   @ 4-byte Spill
	add.w	r0, r1, lr
	strd	r5, r6, [sp, #40]               @ 8-byte Folded Spill
	ldrsh.w	r1, [r3, #2]
	ldrsh.w	r6, [r4, #2]
	ldrsh.w	r11, [r0, #2]
	str	r3, [sp, #28]                   @ 4-byte Spill
	str	r0, [sp, #20]                   @ 4-byte Spill
	adds	r3, r6, r1
	add.w	r0, r5, lr
	mul	r3, r3, r11
	str	r4, [sp, #24]                   @ 4-byte Spill
	subs	r1, r1, r6
	ldrsh.w	r4, [r0, #2]
	ldr	r6, [sp, #64]                   @ 4-byte Reload
	adds.w	r5, r12, r3
	str	r5, [sp, #16]                   @ 4-byte Spill
	adc.w	r3, r6, r3, asr #31
	str	r3, [sp, #64]                   @ 4-byte Spill
	mul	r3, r1, r4
	add.w	r4, r2, lr
	add.w	r6, r10, lr
	add.w	r1, r8, lr
	adds.w	r11, r7, r3
	ldrsh.w	r7, [r4, #6]
	ldrsh.w	r5, [r6, #6]
	adc.w	r3, r9, r3, asr #31
	ldr.w	r9, [sp, #60]                   @ 4-byte Reload
	ldrsh.w	r4, [r4, #8]
	strd	r2, r10, [sp, #32]              @ 8-byte Folded Spill
	ldrsh.w	r2, [r1, #6]
	add	lr, r9
	add.w	r12, r5, r7
	ldrsh.w	r6, [r6, #8]
	mul	r2, r12, r2
	ldrsh.w	r12, [lr, #6]
	subs	r5, r7, r5
	ldrsh.w	r1, [r1, #8]
	mul	r7, r5, r12
	adds	r5, r6, r4
	str	r0, [sp, #12]                   @ 4-byte Spill
	muls	r1, r5, r1
	ldr	r5, [sp, #16]                   @ 4-byte Reload
	add.w	r8, r8, #8
	ldr	r0, [sp, #64]                   @ 4-byte Reload
	adds	r5, r5, r2
	add.w	r9, r9, #8
	str.w	r9, [sp, #60]                   @ 4-byte Spill
	adc.w	r2, r0, r2, asr #31
	adds.w	r12, r11, r7
	adc.w	r3, r3, r7, asr #31
	adds.w	r10, r5, r1
	adc.w	r11, r2, r1, asr #31
	ldr	r1, [sp, #28]                   @ 4-byte Reload
	subs	r2, r4, r6
	ldrsh.w	r7, [lr, #8]
	ldrsh.w	r4, [r1, #8]
	ldr	r1, [sp, #24]                   @ 4-byte Reload
	ldr	r0, [sp, #12]                   @ 4-byte Reload
	muls	r2, r7, r2
	ldrsh.w	r6, [r1, #8]
	ldr	r1, [sp, #20]                   @ 4-byte Reload
	ldrsh.w	r0, [r0, #8]
	ldr	r5, [sp, #40]                   @ 4-byte Reload
	ldrsh.w	r1, [r1, #8]
	adds	r7, r6, r4
	adds	r5, #8
	muls	r1, r7, r1
	subs	r7, r4, r6
	muls	r0, r7, r0
	adds.w	r7, r12, r2
	adc.w	r2, r3, r2, asr #31
	adds.w	r12, r10, r1
	adc.w	r1, r11, r1, asr #31
	adds	r7, r7, r0
	ldrd	r6, r4, [sp, #44]               @ 8-byte Folded Reload
	ldr.w	r10, [sp, #36]                  @ 4-byte Reload
	str	r1, [sp, #64]                   @ 4-byte Spill
	ldr	r1, [sp, #52]                   @ 4-byte Reload
	adc.w	lr, r2, r0, asr #31
	ldr	r0, [sp, #56]                   @ 4-byte Reload
	adds	r1, #8
	ldr	r2, [sp, #32]                   @ 4-byte Reload
	subs	r0, #4
	add.w	r4, r4, #8
	add.w	r6, r6, #8
	add.w	r10, r10, #8
	add.w	r2, r2, #8
	bne.w	.LBB4_35
.LBB4_36:
	movw	r0, :lower16:.L_MergedGlobals.42
	ldr	r4, [sp, #64]                   @ 4-byte Reload
	movt	r0, :upper16:.L_MergedGlobals.42
	lsr.w	r2, r12, #15
	lsrs	r1, r7, #15
	movw	r9, :lower16:.L_MergedGlobals
	str	r7, [r0, #72]
	orr.w	r1, r1, lr, lsl #17
	str.w	r12, [r0, #64]
	movt	r9, :upper16:.L_MergedGlobals
	str	r4, [r0, #68]
	str.w	lr, [r0, #76]
	orr.w	r0, r2, r4, lsl #17
	movw	r4, :lower16:.L_MergedGlobals.41
	movt	r4, :upper16:.L_MergedGlobals.41
	ldrd	r2, r3, [sp]                    @ 8-byte Folded Reload
	cmp	r2, #63
	strh	r3, [r4, #34]
	bls	.LBB4_42
.LBB4_37:
	movs	r2, #0
	strh	r2, [r4, #34]
	strh	r0, [r4, #36]
	strh	r1, [r4, #38]
	ldrb.w	r7, [r9]
	cmp	r7, #4
	bhi	.LBB4_44
@ %bb.38:
	movs	r3, #0
.LCPI4_0:
	tbb	[pc, r7]
@ %bb.39:
.LJTI4_0:
	.byte	(.LBB4_40-(.LCPI4_0+4))/2
	.byte	(.LBB4_45-(.LCPI4_0+4))/2
	.byte	(.LBB4_43-(.LCPI4_0+4))/2
	.byte	(.LBB4_41-(.LCPI4_0+4))/2
	.byte	(.LBB4_40-(.LCPI4_0+4))/2
	.p2align	1
	.p2align	2
.LBB4_40:
	sxth	r2, r0
.LBB4_41:
	sxth	r3, r1
	b	.LBB4_45
	.p2align	2
.LBB4_42:
	add	sp, #68
	pop.w	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
	.p2align	2
.LBB4_43:
	sxth	r2, r0
	b	.LBB4_45
	.p2align	2
.LBB4_44:
	movs	r3, #0
.LBB4_45:
	ldrsh.w	r7, [r4, #28]
	ldr.w	r6, [r9, #8]
	add	r7, r2
	ssat	r7, #16, r7
	muls	r7, r6, r7
	movw	r6, :lower16:.L_MergedGlobals.42
	movt	r6, :upper16:.L_MergedGlobals.42
	asrs	r7, r7, #15
	str	r7, [r6, #28]
	ldrsh.w	r7, [r4, #30]
	ldrsh.w	r5, [r4, #26]
	muls	r2, r5, r2
	add	r3, r7
	add.w	r2, r3, r2, asr #15
	ldr.w	r3, [r9, #12]
	ssat	r2, #16, r2
	muls	r2, r3, r2
	mov.w	r3, #2000
	asrs	r2, r2, #15
	str	r2, [r6, #32]
	ldr	r2, [r6, #28]
	muls	r2, r3, r2
	asrs	r2, r2, #15
	str	r2, [r4, #68]
	ldr	r2, [r6, #32]
	muls	r2, r3, r2
	asrs	r2, r2, #15
	str	r2, [r4, #72]
	ldrb	r2, [r4, #10]
	cbz	r2, .LBB4_47
@ %bb.46:
	ldr	r2, [r4, #72]
	rsbs	r2, r2, #0
	str	r2, [r4, #72]
.LBB4_47:
	strh	r0, [r4, #22]
	strh	r1, [r4, #24]
	add	sp, #68
	pop.w	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
.Lfunc_end4:
	.size	TIM4_IRQHandler, .Lfunc_end4-TIM4_IRQHandler
	.cfi_endproc
	.cantunwind
	.fnend
                                        @ -- End function
	.section	.text.main,"ax",%progbits
	.hidden	main                            @ -- Begin function main
	.globl	main
	.p2align	3
	.type	main,%function
	.code	16                              @ @main
	.thumb_func
main:
	.fnstart
	.cfi_startproc
@ %bb.0:
	.pad	#256
	sub	sp, #256
	.cfi_def_cfa_offset 256
	movw	r7, #61288
	movt	r7, #57344
	bl	HAL_Init
	movs	r4, #1
	str	r4, [sp, #64]
	bl	HAL_MPU_Disable
	mov.w	r0, #603979776
	str	r0, [sp, #68]
	movs	r0, #13
	movt	r0, #769
	strd	r0, r4, [sp, #72]
	add	r0, sp, #64
	bl	HAL_MPU_ConfigRegion
	movs	r0, #4
	bl	HAL_MPU_Enable
	movw	r1, #64940
	movt	r1, #65535
	ldr	r0, [r7, r1]
	lsls	r0, r0, #14
	bmi	.LBB5_2
@ %bb.1:
	dsb	sy
	isb	sy
	movs	r0, #0
	str	r0, [r7, #-24]
	dsb	sy
	isb	sy
	ldr	r0, [r7, r1]
	orr	r0, r0, #131072
	str	r0, [r7, r1]
	dsb	sy
	isb	sy
.LBB5_2:
	ldr	r0, [r7, r1]
	lsls	r0, r0, #15
	bmi	.LBB5_13
@ %bb.3:
	movw	r0, #65052
	movs	r1, #0
	movt	r0, #65535
	movs	r3, #1
	movw	r11, #16352
	str	r1, [r7, r0]
	movw	r0, #65048
	movt	r0, #65535
	dsb	sy
	ldr	r0, [r7, r0]
	lsrs	r2, r0, #3
	ubfx	r5, r0, #3, #10
	ubfx	r1, r0, #13, #15
	subs	r6, r5, #1
	add.w	r0, r3, r0, lsr #3
	sub.w	r10, r5, #2
	lsls	r3, r2, #30
	and	r0, r0, #3
	lsl.w	r9, r6, #30
	lsl.w	r2, r10, #30
	str	r2, [sp, #40]                   @ 4-byte Spill
	subs	r2, r5, #3
	str	r2, [sp, #36]                   @ 4-byte Spill
	b	.LBB5_5
	.p2align	2
.LBB5_4:                                @   in Loop: Header=BB5_5 Depth=1
	cmp	r1, #0
	sub.w	r1, r1, #1
	beq	.LBB5_12
.LBB5_5:                                @ =>This Loop Header: Depth=1
                                        @     Child Loop BB5_11 Depth 2
	and.w	r4, r11, r1, lsl #5
	mov	r2, r5
	cbz	r0, .LBB5_9
@ %bb.6:                                @   in Loop: Header=BB5_5 Depth=1
	cmp	r0, #1
	orr.w	r2, r3, r4
	str	r2, [r7, #-8]
	mov	r2, r6
	beq	.LBB5_9
@ %bb.7:                                @   in Loop: Header=BB5_5 Depth=1
	cmp	r0, #2
	orr.w	r2, r9, r4
	str	r2, [r7, #-8]
	mov	r2, r10
	beq	.LBB5_9
@ %bb.8:                                @   in Loop: Header=BB5_5 Depth=1
	ldr	r2, [sp, #40]                   @ 4-byte Reload
	orrs	r2, r4
	str	r2, [r7, #-8]
	ldr	r2, [sp, #36]                   @ 4-byte Reload
	.p2align	2
.LBB5_9:                                @   in Loop: Header=BB5_5 Depth=1
	cmp	r5, #3
	blo	.LBB5_4
@ %bb.10:                               @   in Loop: Header=BB5_5 Depth=1
	orr.w	r4, r4, r2, lsl #30
	adds	r2, #1
	add.w	r12, r4, #-1073741824
	eor	lr, r4, #-2147483648
	add.w	r8, r4, #1073741824
	.p2align	2
.LBB5_11:                               @   Parent Loop BB5_5 Depth=1
                                        @ =>  This Inner Loop Header: Depth=2
	subs	r2, #4
	str	r4, [r7, #-8]
	str	r12, [r7, #-8]
	str	lr, [r7, #-8]
	str	r8, [r7, #-8]
	bne	.LBB5_11
	b	.LBB5_4
	.p2align	2
.LBB5_12:
	movw	r1, #64940
	movt	r1, #65535
	dsb	sy
	ldr	r0, [r7, r1]
	orr	r0, r0, #65536
	str	r0, [r7, r1]
	dsb	sy
	isb	sy
.LBB5_13:
	movw	r9, #17632
	movw	r4, #2048
	movw	r10, #29696
	movt	r9, #22530
	movt	r4, #22530
	movt	r10, #16384
	bl	SystemClock_Config
	ldr.w	r0, [r9]
	add	r5, sp, #64
	orr	r0, r0, #4
	str.w	r0, [r9]
	ldr.w	r0, [r9]
	mov	r1, r5
	and	r0, r0, #4
	str	r0, [sp, #64]
	ldr	r0, [sp, #64]
	mov	r0, r4
	movs	r6, #0
	str	r6, [sp, #80]
	mov.w	r8, #2
	str.w	r8, [sp, #64]
	mov.w	r11, #1
	str.w	r8, [sp, #76]
	strd	r11, r11, [sp, #68]
	bl	HAL_GPIO_Init
	add	r1, sp, #64
	mov.w	r0, #8192
	str	r6, [sp, #76]
	stm.w	r1, {r0, r6, r11}
	mov	r0, r4
	mov	r1, r5
	bl	HAL_GPIO_Init
	ldr.w	r0, [r9, #8]
	sub.w	r5, r4, #2048
	orr	r0, r0, #536870912
	str.w	r0, [r9, #8]
	ldr.w	r0, [r9, #8]
	add	r1, sp, #44
	and	r0, r0, #536870912
	str	r0, [sp, #64]
	ldr	r0, [sp, #64]
	ldr.w	r0, [r9]
	orr	r0, r0, #1
	str.w	r0, [r9]
	ldr.w	r0, [r9]
	and	r0, r0, #1
	str	r0, [sp, #64]
	ldr	r0, [sp, #64]
	movs	r0, #48
	str	r0, [sp, #44]
	movs	r0, #3
	strd	r0, r6, [sp, #48]
	mov	r0, r5
	strd	r6, r6, [sp, #56]
	bl	HAL_GPIO_Init
	strd	r8, r11, [sp, #72]
	movw	r8, :lower16:.L_MergedGlobals.42
	movs	r0, #10
	movt	r8, :upper16:.L_MergedGlobals.42
	str	r6, [sp, #80]
	strd	r6, r0, [sp, #64]
	mov	r0, r8
	strd	r6, r6, [sp, #92]
	strd	r6, r6, [sp, #84]
	str	r10, [r0, #92]!
	bl	HAL_DAC_Init
	cbz	r0, .LBB5_15
	.p2align	2
.LBB5_14:                               @ =>This Inner Loop Header: Depth=1
	movs	r1, #2
	mov	r0, r4
	bl	HAL_GPIO_TogglePin
	movs	r0, #50
	bl	HAL_Delay
	b	.LBB5_14
	.p2align	2
.LBB5_15:
	add.w	r6, r8, #92
	add	r1, sp, #64
	movs	r2, #0
	mov	r0, r6
	bl	HAL_DAC_ConfigChannel
	cbz	r0, .LBB5_17
	.p2align	2
.LBB5_16:                               @ =>This Inner Loop Header: Depth=1
	movs	r1, #2
	mov	r0, r4
	bl	HAL_GPIO_TogglePin
	movs	r0, #50
	bl	HAL_Delay
	b	.LBB5_16
	.p2align	2
.LBB5_17:
	add	r1, sp, #64
	movs	r2, #16
	mov	r0, r6
	bl	HAL_DAC_ConfigChannel
	cbz	r0, .LBB5_19
	.p2align	2
.LBB5_18:                               @ =>This Inner Loop Header: Depth=1
	movs	r1, #2
	mov	r0, r4
	bl	HAL_GPIO_TogglePin
	movs	r0, #50
	bl	HAL_Delay
	b	.LBB5_18
	.p2align	2
.LBB5_19:
	movs	r1, #0
	mov	r0, r6
	bl	HAL_DAC_Start
	cbz	r0, .LBB5_21
	.p2align	2
.LBB5_20:                               @ =>This Inner Loop Header: Depth=1
	movs	r1, #2
	mov	r0, r4
	bl	HAL_GPIO_TogglePin
	movs	r0, #50
	bl	HAL_Delay
	b	.LBB5_20
	.p2align	2
.LBB5_21:
	movs	r1, #16
	mov	r0, r6
	bl	HAL_DAC_Start
	cbz	r0, .LBB5_23
	.p2align	2
.LBB5_22:                               @ =>This Inner Loop Header: Depth=1
	movs	r1, #2
	mov	r0, r4
	bl	HAL_GPIO_TogglePin
	movs	r0, #50
	bl	HAL_Delay
	b	.LBB5_22
	.p2align	2
.LBB5_23:
	ldr.w	r0, [r9]
	movs	r6, #0
	orr	r0, r0, #16777216
	str.w	r0, [r9]
	ldr.w	r0, [r9]
	add	r1, sp, #44
	and	r0, r0, #16777216
	str	r0, [sp, #64]
	ldr	r0, [sp, #64]
	ldr.w	r0, [r9]
	orr	r0, r0, #4
	str.w	r0, [r9]
	ldr.w	r0, [r9]
	and	r0, r0, #4
	str	r0, [sp, #64]
	ldr	r0, [sp, #64]
	movs	r0, #8
	str	r0, [sp, #44]
	movs	r0, #3
	strd	r0, r6, [sp, #48]
	mov	r0, r4
	strd	r6, r6, [sp, #56]
	bl	HAL_GPIO_Init
	movw	r0, :lower16:hadc3
	movw	r1, #24576
	movt	r0, :upper16:hadc3
	movt	r1, #22530
	movs	r2, #1
	mov.w	r11, #4
	strb	r6, [r0, #28]
	str	r6, [r0, #36]
	str	r6, [r0, #40]
	str	r2, [r0, #24]
	str	r1, [r0]
	mov.w	r1, #196608
	str	r1, [r0, #4]
	movs	r1, #12
	strd	r1, r6, [r0, #8]
	str.w	r11, [r0, #16]
	mov.w	r1, #256
	strh	r1, [r0, #20]
	mov.w	r1, #4096
	str	r1, [r0, #48]
	strb.w	r6, [r0, #56]
	bl	HAL_ADC_Init
	cbz	r0, .LBB5_25
	.p2align	2
.LBB5_24:                               @ =>This Inner Loop Header: Depth=1
	movs	r1, #2
	mov	r0, r4
	bl	HAL_GPIO_TogglePin
	movs	r0, #50
	bl	HAL_Delay
	b	.LBB5_24
	.p2align	2
.LBB5_25:
	movs	r0, #2
	add	r1, sp, #64
	movt	r0, #1072
	str	r0, [sp, #64]
	movs	r0, #6
	str	r6, [sp, #88]
	strd	r0, r6, [sp, #68]
	movw	r0, #2047
	str	r6, [sp, #84]
	strd	r0, r11, [sp, #76]
	movw	r0, :lower16:hadc3
	movt	r0, :upper16:hadc3
	bl	HAL_ADC_ConfigChannel
	cbz	r0, .LBB5_27
	.p2align	2
.LBB5_26:                               @ =>This Inner Loop Header: Depth=1
	movs	r1, #2
	mov	r0, r4
	bl	HAL_GPIO_TogglePin
	movs	r0, #50
	bl	HAL_Delay
	b	.LBB5_26
	.p2align	2
.LBB5_27:
	movw	r0, :lower16:hadc3
	movs	r1, #0
	movt	r0, :upper16:hadc3
	movw	r2, #2047
	bl	HAL_ADCEx_Calibration_Start
	cbz	r0, .LBB5_29
	.p2align	2
.LBB5_28:                               @ =>This Inner Loop Header: Depth=1
	movs	r1, #2
	mov	r0, r4
	bl	HAL_GPIO_TogglePin
	movs	r0, #50
	bl	HAL_Delay
	b	.LBB5_28
	.p2align	2
.LBB5_29:
	movw	r0, :lower16:hadc3
	movt	r0, :upper16:hadc3
	bl	HAL_ADC_Start
	cbz	r0, .LBB5_31
	.p2align	2
.LBB5_30:                               @ =>This Inner Loop Header: Depth=1
	movs	r1, #2
	mov	r0, r4
	bl	HAL_GPIO_TogglePin
	movs	r0, #50
	bl	HAL_Delay
	b	.LBB5_30
	.p2align	2
.LBB5_31:
	ldr	r0, [r9, #-8]
	movw	r11, #8204
	orr	r0, r0, #32
	str	r0, [r9, #-8]
	ldr	r0, [r9, #-8]
	add	r1, sp, #44
	and	r0, r0, #32
	str	r0, [sp, #64]
	ldr	r0, [sp, #64]
	ldr.w	r0, [r9]
	orr	r0, r0, #1
	str.w	r0, [r9]
	ldr.w	r0, [r9]
	movs	r6, #0
	and	r0, r0, #1
	str	r0, [sp, #64]
	ldr	r0, [sp, #64]
	movs	r0, #192
	str	r0, [sp, #44]
	movs	r0, #3
	str	r0, [sp, #48]
	mov	r0, r5
	strd	r6, r6, [sp, #56]
	movt	r11, #16386
	str	r6, [sp, #52]
	bl	HAL_GPIO_Init
	movw	r0, :lower16:hadc1
	movs	r1, #1
	movt	r0, :upper16:hadc1
	strb	r6, [r0, #28]
	str	r1, [r0, #24]
	sub.w	r1, r11, #12
	str	r1, [r0]
	mov.w	r1, #196608
	str	r1, [r0, #4]
	movs	r1, #8
	strd	r1, r6, [r0, #8]
	movs	r1, #4
	mov.w	r11, #4
	str	r1, [r0, #16]
	mov.w	r1, #1376
	strh	r6, [r0, #20]
	strb.w	r6, [r0, #56]
	str	r1, [r0, #36]
	mov.w	r1, #1024
	str	r1, [r0, #40]
	movs	r1, #3
	str	r1, [r0, #44]
	mov.w	r1, #4096
	str	r1, [r0, #48]
	bl	HAL_ADC_Init
	cbz	r0, .LBB5_33
	.p2align	2
.LBB5_32:                               @ =>This Inner Loop Header: Depth=1
	movs	r1, #2
	mov	r0, r4
	bl	HAL_GPIO_TogglePin
	movs	r0, #50
	bl	HAL_Delay
	b	.LBB5_32
	.p2align	2
.LBB5_33:
	movs	r0, #8
	add	r1, sp, #64
	movt	r0, #3216
	str	r0, [sp, #64]
	movs	r0, #6
	str	r0, [sp, #68]
	movs	r0, #0
	str	r6, [sp, #88]
	movt	r0, #18431
	strd	r6, r0, [sp, #72]
	movw	r0, :lower16:hadc1
	movt	r0, :upper16:hadc1
	strd	r11, r6, [sp, #80]
	bl	HAL_ADC_ConfigChannel
	cbz	r0, .LBB5_35
.LBB5_34:                               @ =>This Inner Loop Header: Depth=1
	movs	r1, #2
	mov	r0, r4
	bl	HAL_GPIO_TogglePin
	movs	r0, #50
	bl	HAL_Delay
	b	.LBB5_34
	.p2align	2
.LBB5_35:
	movw	r0, :lower16:hadc1
	movs	r2, #0
	movt	r0, :upper16:hadc1
	movs	r1, #0
	movt	r2, #18431
	movs	r6, #0
	bl	HAL_ADCEx_Calibration_Start
	cbz	r0, .LBB5_37
.LBB5_36:                               @ =>This Inner Loop Header: Depth=1
	movs	r1, #2
	mov	r0, r4
	bl	HAL_GPIO_TogglePin
	movs	r0, #50
	bl	HAL_Delay
	b	.LBB5_36
	.p2align	2
.LBB5_37:
	ldr.w	r0, [r9, #8]
	add	r1, sp, #64
	orr	r0, r0, #131072
	str.w	r0, [r9, #8]
	ldr.w	r0, [r9, #8]
	and	r0, r0, #131072
	str	r0, [sp, #64]
	ldr	r0, [sp, #64]
	ldr.w	r0, [r9]
	orr	r0, r0, #1
	str.w	r0, [r9]
	ldr.w	r0, [r9]
	and	r0, r0, #1
	str	r0, [sp, #64]
	ldr	r0, [sp, #64]
	movs	r0, #12
	str	r0, [sp, #64]
	movs	r0, #2
	strd	r0, r6, [sp, #68]
	str	r0, [sp, #76]
	movs	r0, #7
	str	r0, [sp, #80]
	mov	r0, r5
	bl	HAL_GPIO_Init
	movw	r11, :lower16:huart2
	movw	r0, #15368
	movt	r11, :upper16:huart2
	movt	r0, #16384
	add.w	r0, r0, #2040
	str.w	r0, [r11]
	mov.w	r0, #921600
	strd	r0, r6, [r11, #4]
	movs	r0, #12
	strd	r0, r6, [r11, #20]
	mov	r0, r11
	strd	r6, r6, [r11, #12]
	strd	r6, r6, [r11, #28]
	bl	HAL_UART_Init
	cbz	r0, .LBB5_39
.LBB5_38:                               @ =>This Inner Loop Header: Depth=1
	movs	r1, #2
	mov	r0, r4
	bl	HAL_GPIO_TogglePin
	movs	r0, #50
	bl	HAL_Delay
	b	.LBB5_38
	.p2align	2
.LBB5_39:
	movs	r6, #16
	movs	r0, #38
	movt	r6, #16386
	bl	HAL_NVIC_DisableIRQ
	ldr	r0, [r9, #-8]
	add.w	r1, r6, #144
	orr	r0, r0, #1
	str	r0, [r9, #-8]
	ldr	r0, [r9, #-8]
	movs	r2, #0
	and	r0, r0, #1
	str	r0, [sp, #44]
	ldr	r0, [sp, #44]
	movw	r0, :lower16:hdma_usart2_tx
	movt	r0, :upper16:hdma_usart2_tx
	str	r1, [r0]
	movs	r1, #44
	str	r1, [r0, #4]
	movs	r1, #64
	str	r1, [r0, #8]
	mov.w	r1, #1024
	str	r2, [r0, #12]
	strd	r1, r2, [r0, #16]
	strd	r2, r2, [r0, #24]
	mov.w	r1, #131072
	strd	r1, r2, [r0, #32]
	bl	HAL_DMA_Init
	cbz	r0, .LBB5_41
.LBB5_40:                               @ =>This Inner Loop Header: Depth=1
	movs	r1, #2
	mov	r0, r4
	bl	HAL_GPIO_TogglePin
	movs	r0, #50
	bl	HAL_Delay
	b	.LBB5_40
	.p2align	2
.LBB5_41:
	movw	r6, :lower16:hdma_usart2_tx
	movs	r0, #17
	movt	r6, :upper16:hdma_usart2_tx
	movs	r1, #3
	movs	r2, #0
	str.w	r6, [r11, #124]
	str.w	r11, [r6, #56]
	movs	r3, #3
	str	r3, [sp, #40]                   @ 4-byte Spill
	bl	HAL_NVIC_SetPriority
	movs	r0, #17
	bl	HAL_NVIC_EnableIRQ
	movw	r0, :lower16:uart2_dma_tc_cb
	add.w	r11, sp, #64
	movt	r0, :upper16:uart2_dma_tc_cb
	str	r0, [r6, #60]
	ldr.w	r0, [r9, #8]
	movs	r6, #0
	orr	r0, r0, #32768
	str.w	r0, [r9, #8]
	ldr.w	r0, [r9, #8]
	mov	r1, r11
	and	r0, r0, #32768
	str	r0, [sp, #64]
	ldr	r0, [sp, #64]
	ldr.w	r0, [r9]
	orr	r0, r0, #2
	str.w	r0, [r9]
	ldr.w	r0, [r9]
	and	r0, r0, #2
	str	r0, [sp, #64]
	ldr	r0, [sp, #64]
	ldr.w	r0, [r9]
	orr	r0, r0, #4
	str.w	r0, [r9]
	ldr.w	r0, [r9]
	and	r0, r0, #4
	str	r0, [sp, #64]
	ldr	r0, [sp, #64]
	ldr.w	r0, [r9]
	orr	r0, r0, #1
	str.w	r0, [r9]
	ldr.w	r0, [r9]
	and	r0, r0, #1
	str	r0, [sp, #64]
	ldr	r0, [sp, #64]
	mov.w	r0, #32768
	strd	r0, r6, [sp, #64]
	mov	r0, r5
	str	r6, [sp, #72]
	strd	r6, r6, [sp, #76]
	bl	HAL_GPIO_Init
	mov.w	r0, #3072
	str	r0, [sp, #64]
	movs	r0, #2
	str	r0, [sp, #76]
	strd	r0, r6, [sp, #68]
	movs	r0, #6
	str	r0, [sp, #80]
	mov	r0, r4
	mov	r1, r11
	bl	HAL_GPIO_Init
	movs	r0, #4
	str	r0, [sp, #64]
	movs	r0, #7
	str	r0, [sp, #80]
	sub.w	r0, r4, #1024
	mov	r1, r11
	bl	HAL_GPIO_Init
	movw	r6, :lower16:hspi3
	movw	r0, #15368
	movt	r6, :upper16:hspi3
	movt	r0, #16384
	subs	r0, #8
	movs	r1, #0
	str	r0, [r6]
	movs	r0, #7
	strd	r0, r1, [r6, #12]
	mov.w	r0, #67108864
	str	r0, [r6, #24]
	mov	r0, r6
	str	r1, [r6, #20]
	strd	r1, r1, [r6, #4]
	strd	r1, r1, [r6, #32]
	str	r1, [r6, #40]
	mov.w	r11, #0
	strd	r1, r1, [r6, #56]
	bl	HAL_SPI_Init
	ldr	r0, [r6]
	movs	r2, #0
	ldr	r1, [r0, #16]
	orr	r1, r1, #1
	str	r1, [r0, #16]
	movs	r0, #51
	movs	r1, #6
	bl	HAL_NVIC_SetPriority
	movs	r0, #51
	bl	HAL_NVIC_EnableIRQ
	movw	r0, :lower16:.L_MergedGlobals.41
	movs	r1, #0
	movt	r0, :upper16:.L_MergedGlobals.41
	str	r1, [sp, #36]                   @ 4-byte Spill
	strb.w	r11, [r0, #9]
	bl	am_demod_init
	vldr	d11, .LCPI5_22
	vldr	d10, .LCPI5_23
	vldr	d15, .LCPI5_24
	vldr	d9, .LCPI5_25
	vldr	d12, .LCPI5_26
	b	.LBB5_43
	.p2align	2
.LBB5_42:                               @   in Loop: Header=BB5_43 Depth=1
	vmov.f64	d1, d15
	vldr	d2, .LCPI5_27
	vfma.f64	d1, d8, d2
	vmul.f64	d8, d13, d12
	vmul.f64	d0, d1, d0
	vadd.f64	d13, d0, d0
	vmov.f64	d0, d8
	bl	__hardfp_cos
	vmul.f64	d0, d0, d13
	vstr	d0, [r11, #24]
	vmov.f64	d0, d8
	bl	__hardfp_sin
	vmul.f64	d0, d13, d0
	ldr	r0, [sp, #36]                   @ 4-byte Reload
	adds	r0, #32
	str	r0, [sp, #36]                   @ 4-byte Spill
	vstr	d0, [r6, #24]
	cmp.w	r0, #1024
	ldr	r0, [sp, #40]                   @ 4-byte Reload
	vmov.f64	d0, #4.000000e+00
	add.w	r0, r0, #4
	str	r0, [sp, #40]                   @ 4-byte Spill
	vadd.f64	d11, d11, d0
	beq.w	.LBB5_66
.LBB5_43:                               @ =>This Inner Loop Header: Depth=1
	vldr	d0, .LCPI5_28
	vmul.f64	d0, d11, d0
	vldr	d1, .LCPI5_29
	vdiv.f64	d0, d0, d1
	vadd.f64	d13, d11, d10
	bl	__hardfp_cos
	vabs.f64	d1, d13
	vldr	d2, .LCPI5_30
	vmov.f64	d8, d0
	vcmp.f64	d1, d2
	vmov.f64	d0, d9
	vmrs	APSR_nzcv, fpscr
	blt	.LBB5_45
@ %bb.44:                               @   in Loop: Header=BB5_43 Depth=1
	vldr	d0, .LCPI5_31
	vmul.f64	d0, d13, d0
	bl	__hardfp_sin
	vldr	d1, .LCPI5_32
	vmul.f64	d1, d13, d1
	vdiv.f64	d0, d0, d1
.LBB5_45:                               @   in Loop: Header=BB5_43 Depth=1
	vmov.f64	d1, d15
	vldr	d2, .LCPI5_27
	vfma.f64	d1, d8, d2
	vmul.f64	d8, d13, d12
	vmul.f64	d0, d1, d0
	vadd.f64	d14, d0, d0
	vmov.f64	d0, d8
	bl	__hardfp_cos
	movw	r0, :lower16:init_iq_splitter.gd
	ldr	r6, [sp, #36]                   @ 4-byte Reload
	vmul.f64	d0, d0, d14
	movt	r0, :upper16:init_iq_splitter.gd
	add	r0, r6
	mov	r11, r0
	vstr	d0, [r0]
	vmov.f64	d0, d8
	bl	__hardfp_sin
	ldr	r0, [sp, #40]                   @ 4-byte Reload
	subs	r0, #2
	vmov	s2, r0
	movw	r0, :lower16:init_iq_splitter.hd
	vldr	d3, .LCPI5_29
	movt	r0, :upper16:init_iq_splitter.hd
	vcvt.f64.u32	d2, s2
	add	r6, r0
	vldr	d1, .LCPI5_28
	vmul.f64	d1, d2, d1
	vmul.f64	d0, d14, d0
	vdiv.f64	d1, d1, d3
	vstr	d0, [r6]
	vmov.f64	d0, d1
	vadd.f64	d13, d2, d10
	bl	__hardfp_cos
	vabs.f64	d1, d13
	vldr	d2, .LCPI5_30
	vmov.f64	d8, d0
	vcmp.f64	d1, d2
	vmov.f64	d0, d9
	vmrs	APSR_nzcv, fpscr
	blt	.LBB5_47
@ %bb.46:                               @   in Loop: Header=BB5_43 Depth=1
	vldr	d0, .LCPI5_31
	vmul.f64	d0, d13, d0
	bl	__hardfp_sin
	vldr	d1, .LCPI5_32
	vmul.f64	d1, d13, d1
	vdiv.f64	d0, d0, d1
.LBB5_47:                               @   in Loop: Header=BB5_43 Depth=1
	vmov.f64	d1, d15
	vldr	d2, .LCPI5_27
	vfma.f64	d1, d8, d2
	vmul.f64	d8, d13, d12
	vmul.f64	d0, d1, d0
	vadd.f64	d14, d0, d0
	vmov.f64	d0, d8
	bl	__hardfp_cos
	vmul.f64	d0, d0, d14
	vstr	d0, [r11, #8]
	vmov.f64	d0, d8
	bl	__hardfp_sin
	ldr	r0, [sp, #40]                   @ 4-byte Reload
	subs	r0, #1
	vmov	s2, r0
	vldr	d3, .LCPI5_29
	vcvt.f64.u32	d2, s2
	vldr	d1, .LCPI5_28
	vmul.f64	d1, d2, d1
	vmul.f64	d0, d14, d0
	vdiv.f64	d1, d1, d3
	vstr	d0, [r6, #8]
	vmov.f64	d0, d1
	vadd.f64	d13, d2, d10
	bl	__hardfp_cos
	vabs.f64	d1, d13
	vldr	d2, .LCPI5_30
	vmov.f64	d8, d0
	vcmp.f64	d1, d2
	vmov.f64	d0, d9
	vmrs	APSR_nzcv, fpscr
	blt	.LBB5_49
@ %bb.48:                               @   in Loop: Header=BB5_43 Depth=1
	vldr	d0, .LCPI5_31
	vmul.f64	d0, d13, d0
	bl	__hardfp_sin
	vldr	d1, .LCPI5_32
	vmul.f64	d1, d13, d1
	vdiv.f64	d0, d0, d1
.LBB5_49:                               @   in Loop: Header=BB5_43 Depth=1
	vmov.f64	d1, d15
	vldr	d2, .LCPI5_27
	vfma.f64	d1, d8, d2
	vmul.f64	d8, d13, d12
	vmul.f64	d0, d1, d0
	vadd.f64	d14, d0, d0
	vmov.f64	d0, d8
	bl	__hardfp_cos
	vmul.f64	d0, d0, d14
	vstr	d0, [r11, #16]
	vmov.f64	d0, d8
	bl	__hardfp_sin
	ldr	r0, [sp, #40]                   @ 4-byte Reload
	vmov	s2, r0
	vldr	d3, .LCPI5_29
	vcvt.f64.u32	d2, s2
	vldr	d1, .LCPI5_28
	vmul.f64	d1, d2, d1
	vmul.f64	d0, d14, d0
	vdiv.f64	d1, d1, d3
	vstr	d0, [r6, #16]
	vmov.f64	d0, d1
	vadd.f64	d13, d2, d10
	bl	__hardfp_cos
	vabs.f64	d1, d13
	vldr	d2, .LCPI5_30
	vmov.f64	d8, d0
	vcmp.f64	d1, d2
	vmov.f64	d0, d9
	vmrs	APSR_nzcv, fpscr
	blt.w	.LBB5_42
@ %bb.50:                               @   in Loop: Header=BB5_43 Depth=1
	vldr	d0, .LCPI5_31
	vmul.f64	d0, d13, d0
	bl	__hardfp_sin
	vldr	d1, .LCPI5_32
	vmul.f64	d1, d13, d1
	vdiv.f64	d0, d0, d1
	b	.LBB5_42
	.p2align	3
@ %bb.51:
.LCPI5_22:
	.long	0                               @ double 0
	.long	0
	.p2align	3
@ %bb.52:
.LCPI5_23:
	.long	0                               @ double -63.5
	.long	3226451968
	.p2align	3
@ %bb.53:
.LCPI5_24:
	.long	343597384                       @ double 0.54000000000000004
	.long	1071728558
	.p2align	3
@ %bb.54:
.LCPI5_25:
	.long	2370821947                      @ double 0.035999999999999997
	.long	1067609751
	.p2align	3
@ %bb.55:
.LCPI5_26:
	.long	4123168604                      @ double 0.13823008060455322
	.long	1069658501
	.p2align	3
@ %bb.56:
.LCPI5_27:
	.long	3607772529                      @ double -0.46000000000000002
	.long	3218960547
	.p2align	3
@ %bb.57:
.LCPI5_28:
	.long	1610612736                      @ double 6.2831854820251465
	.long	1075388923
	.p2align	3
@ %bb.58:
.LCPI5_29:
	.long	0                               @ double 127
	.long	1080016896
	.p2align	3
@ %bb.59:
.LCPI5_30:
	.long	2167269905                      @ double 9.9999999999999998E-13
	.long	1030854553
	.p2align	3
@ %bb.60:
.LCPI5_31:
	.long	2061584302                      @ double 0.11309733867645264
	.long	1069347826
	.p2align	3
@ %bb.61:
.LCPI5_32:
	.long	1610612736                      @ double 3.1415927410125732
	.long	1074340347
	.p2align	3
@ %bb.62:
.LCPI5_33:
	.long	3323461632                      @ double -10367.256045341492
	.long	3234086816
	.p2align	3
@ %bb.63:
.LCPI5_34:
	.long	0                               @ double 75000
	.long	1089621888
	.p2align	3
@ %bb.64:
.LCPI5_35:
	.long	0                               @ double 32767
	.long	1088421824
	.p2align	3
@ %bb.65:
.LCPI5_38:
	.long	0                               @ double 4294967296
	.long	1106247680
	.p2align	2
.LBB5_66:
	vldr	d9, .LCPI5_22
	movw	r0, :lower16:init_iq_splitter.gd
	movs	r6, #7
	vmov.f64	d14, d9
	movt	r0, :upper16:init_iq_splitter.gd
	add.w	r11, r0, #56
	vmov.f64	d15, d9
	vldr	d12, .LCPI5_33
	vldr	d11, .LCPI5_34
.LBB5_67:                               @ =>This Inner Loop Header: Depth=1
	vadd.f64	d0, d15, d10
	vldr	d13, [r11, #-56]
	vmul.f64	d0, d0, d12
	vdiv.f64	d8, d0, d11
	vmov.f64	d0, d8
	bl	__hardfp_cos
	vfma.f64	d9, d13, d0
	vmov.f64	d0, d8
	bl	__hardfp_sin
	vfma.f64	d14, d13, d0
	subs	r0, r6, #6
	vmov	s2, r0
	vldr	d13, [r11, #-48]
	vcvt.f64.u32	d1, s2
	vadd.f64	d1, d1, d10
	vmul.f64	d1, d1, d12
	vdiv.f64	d8, d1, d11
	vmov.f64	d0, d8
	bl	__hardfp_cos
	vfma.f64	d9, d13, d0
	vmov.f64	d0, d8
	bl	__hardfp_sin
	vfma.f64	d14, d13, d0
	subs	r0, r6, #5
	vmov	s2, r0
	vldr	d13, [r11, #-40]
	vcvt.f64.u32	d1, s2
	vadd.f64	d1, d1, d10
	vmul.f64	d1, d1, d12
	vdiv.f64	d8, d1, d11
	vmov.f64	d0, d8
	bl	__hardfp_cos
	vfma.f64	d9, d13, d0
	vmov.f64	d0, d8
	bl	__hardfp_sin
	vfma.f64	d14, d13, d0
	subs	r0, r6, #4
	vmov	s2, r0
	vldr	d13, [r11, #-32]
	vcvt.f64.u32	d1, s2
	vadd.f64	d1, d1, d10
	vmul.f64	d1, d1, d12
	vdiv.f64	d8, d1, d11
	vmov.f64	d0, d8
	bl	__hardfp_cos
	vfma.f64	d9, d13, d0
	vmov.f64	d0, d8
	bl	__hardfp_sin
	vfma.f64	d14, d13, d0
	subs	r0, r6, #3
	vmov	s2, r0
	vldr	d13, [r11, #-24]
	vcvt.f64.u32	d1, s2
	vadd.f64	d1, d1, d10
	vmul.f64	d1, d1, d12
	vdiv.f64	d8, d1, d11
	vmov.f64	d0, d8
	bl	__hardfp_cos
	vfma.f64	d9, d13, d0
	vmov.f64	d0, d8
	bl	__hardfp_sin
	vfma.f64	d14, d13, d0
	subs	r0, r6, #2
	vmov	s2, r0
	vldr	d13, [r11, #-16]
	vcvt.f64.u32	d1, s2
	vadd.f64	d1, d1, d10
	vmul.f64	d1, d1, d12
	vdiv.f64	d8, d1, d11
	vmov.f64	d0, d8
	bl	__hardfp_cos
	vfma.f64	d9, d13, d0
	vmov.f64	d0, d8
	bl	__hardfp_sin
	vfma.f64	d14, d13, d0
	subs	r0, r6, #1
	vmov	s2, r0
	vldr	d13, [r11, #-8]
	vcvt.f64.u32	d1, s2
	vadd.f64	d1, d1, d10
	vmul.f64	d1, d1, d12
	vdiv.f64	d8, d1, d11
	vmov.f64	d0, d8
	bl	__hardfp_cos
	vfma.f64	d9, d13, d0
	vmov.f64	d0, d8
	bl	__hardfp_sin
	vfma.f64	d14, d13, d0
	vmov	s2, r6
	vldr	d13, [r11]
	vcvt.f64.u32	d1, s2
	vadd.f64	d1, d1, d10
	vmul.f64	d1, d1, d12
	vdiv.f64	d8, d1, d11
	vmov.f64	d0, d8
	bl	__hardfp_cos
	vfma.f64	d9, d13, d0
	vmov.f64	d0, d8
	bl	__hardfp_sin
	vfma.f64	d14, d13, d0
	adds	r6, #8
	cmp	r6, #135
	add.w	r11, r11, #64
	vmov.f64	d0, #8.000000e+00
	vadd.f64	d15, d15, d0
	bne.w	.LBB5_67
@ %bb.68:
	vmul.f64	d0, d14, d14
	movw	r0, :lower16:g_q15
	movw	r1, :lower16:h_q15
	movt	r0, :upper16:g_q15
	vldr	d3, .LCPI5_30
	movt	r1, :upper16:h_q15
	subs	r0, #8
	vfma.f64	d0, d9, d9
	subs	r1, #8
	movs	r2, #0
	vsqrt.f64	d1, d0
	vmov.f64	d0, #1.000000e+00
	vcmp.f64	d1, d3
	vmrs	APSR_nzcv, fpscr
	vdiv.f64	d2, d0, d1
	vldr	d3, .LCPI5_35
	vselgt.f64	d1, d2, d0
	vmov.f64	d2, #-1.000000e+00
.LBB5_69:                               @ =>This Inner Loop Header: Depth=1
	movw	r3, :lower16:init_iq_splitter.gd
	movt	r3, :upper16:init_iq_splitter.gd
	add	r3, r2
	vldr	d5, [r3]
	vldr	d10, [r3, #8]
	vldr	d7, [r3, #16]
	vldr	d4, [r3, #24]
	movw	r3, :lower16:init_iq_splitter.hd
	vmul.f64	d6, d1, d5
	movt	r3, :upper16:init_iq_splitter.hd
	add	r3, r2
	adds	r2, #32
	vmul.f64	d10, d1, d10
	cmp.w	r2, #512
	vldr	d8, [r3]
	vmul.f64	d8, d1, d8
	vminnm.f64	d6, d6, d0
	vldr	d12, [r3, #8]
	vminnm.f64	d8, d8, d0
	vmaxnm.f64	d6, d6, d2
	vmul.f64	d12, d1, d12
	vminnm.f64	d10, d10, d0
	vldr	d9, [r3, #16]
	vmaxnm.f64	d8, d8, d2
	vmul.f64	d7, d1, d7
	vmul.f64	d6, d6, d3
	vminnm.f64	d12, d12, d0
	vcvt.s32.f64	s12, d6
	vmaxnm.f64	d10, d10, d2
	vmul.f64	d9, d1, d9
	vmul.f64	d8, d8, d3
	vminnm.f64	d7, d7, d0
	vcvt.s32.f64	s13, d8
	vldr	d5, [r3, #24]
	vmov	r3, s12
	vmaxnm.f64	d12, d12, d2
	strh	r3, [r0, #8]!
	vmov	r3, s13
	vmul.f64	d4, d1, d4
	strh	r3, [r1, #8]!
	vmul.f64	d10, d10, d3
	vminnm.f64	d9, d9, d0
	vcvt.s32.f64	s16, d10
	vmaxnm.f64	d7, d7, d2
	vmul.f64	d5, d1, d5
	vmov	r3, s16
	vmul.f64	d12, d12, d3
	strh	r3, [r0, #2]
	vminnm.f64	d4, d4, d0
	vcvt.s32.f64	s12, d12
	vmaxnm.f64	d9, d9, d2
	vmul.f64	d7, d7, d3
	vmov	r3, s12
	vminnm.f64	d5, d5, d0
	vcvt.s32.f64	s14, d7
	strh	r3, [r1, #2]
	vmaxnm.f64	d4, d4, d2
	vmul.f64	d9, d9, d3
	vmov	r3, s14
	vmaxnm.f64	d5, d5, d2
	vcvt.s32.f64	s13, d9
	strh	r3, [r0, #4]
	vmul.f64	d4, d4, d3
	vmul.f64	d5, d5, d3
	vcvt.s32.f64	s8, d4
	vmov	r3, s13
	vcvt.s32.f64	s10, d5
	strh	r3, [r1, #4]
	vmov	r3, s8
	strh	r3, [r0, #6]
	vmov	r3, s10
	strh	r3, [r1, #6]
	bne.w	.LBB5_69
@ %bb.70:
	movw	r0, :lower16:dec_buf
	mov.w	r1, #768
	movt	r0, :upper16:dec_buf
	bl	__aeabi_memclr4
	movw	r12, :lower16:.L_MergedGlobals.41
	movw	r0, :lower16:.L_MergedGlobals
	movt	r12, :upper16:.L_MergedGlobals.41
	movt	r0, :upper16:.L_MergedGlobals
	movs	r6, #0
	adr.w	r1, .LCPI5_36
	strh.w	r6, [r12, #32]
	adr.w	r2, .LCPI5_37
	strd	r6, r6, [r8, #64]
	strd	r6, r6, [r8, #72]
	str.w	r6, [r12, #36]
	ldr	r3, [r1, #8]
	str.w	r6, [r8, #28]
	str.w	r6, [r8, #32]
	str.w	r6, [r12, #68]
	str.w	r6, [r12, #72]
	strh.w	r6, [r12, #40]
	str.w	r6, [r12, #88]
	ldrh	r0, [r0, #4]
	strb.w	r6, [r12, #10]
	vmov	s0, r0
	movw	r0, :lower16:.L_MergedGlobals.43
	movt	r0, :upper16:.L_MergedGlobals.43
	vcvt.f64.u32	d1, s0
	str	r3, [r0, #32]
	vldr	d0, .LCPI5_38
	ldr	r3, [r1, #12]
	str	r3, [r0, #36]
	vdiv.f64	d1, d1, d11
	ldr	r3, [r1, #16]
	str	r3, [r0, #40]
	ldr	r3, [r1, #20]
	str	r3, [r0, #44]
	ldr.w	r3, .LCPI5_37
	vmul.f64	d0, d1, d0
	str	r3, [r0]
	ldr	r3, [r2, #4]
	str	r3, [r0, #4]
	ldr	r3, [r2, #8]
	str	r3, [r0, #8]
	vcvt.u32.f64	s0, d0
	ldr	r3, [r2, #12]
	str	r3, [r0, #12]
	ldr	r3, [r2, #16]
	str	r3, [r0, #16]
	ldr	r2, [r2, #20]
	str	r2, [r0, #20]
	ldr.w	r2, .LCPI5_36
	str	r2, [r0, #24]
	ldr	r1, [r1, #4]
	str	r1, [r0, #28]
	vstr	s0, [r12, #84]
	bl	apply_cfg
	ldr.w	r0, [r9, #8]
	mov.w	r1, #1073741824
	orr	r0, r0, #1
	str.w	r0, [r9, #8]
	ldr.w	r0, [r9, #8]
	and	r0, r0, #1
	str	r0, [sp, #64]
	ldr	r0, [sp, #64]
	movw	r0, :lower16:htim2
	movt	r0, :upper16:htim2
	strd	r1, r6, [r0]
	str	r6, [r0, #8]
	movs	r1, #99
	strd	r1, r6, [r0, #12]
	str	r6, [r0, #24]
	bl	HAL_TIM_Base_Init
	cbz	r0, .LBB5_72
.LBB5_71:                               @ =>This Inner Loop Header: Depth=1
	movs	r1, #2
	mov	r0, r4
	bl	HAL_GPIO_TogglePin
	movs	r0, #50
	bl	HAL_Delay
	b	.LBB5_71
	.p2align	2
.LBB5_72:
	mov.w	r0, #4096
	str	r0, [sp, #64]
	movw	r0, :lower16:htim2
	add	r1, sp, #64
	movt	r0, :upper16:htim2
	str	r6, [sp, #76]
	strd	r6, r6, [sp, #68]
	bl	HAL_TIM_ConfigClockSource
	cbz	r0, .LBB5_74
.LBB5_73:                               @ =>This Inner Loop Header: Depth=1
	movs	r1, #2
	mov	r0, r4
	bl	HAL_GPIO_TogglePin
	movs	r0, #50
	bl	HAL_Delay
	b	.LBB5_73
	.p2align	2
.LBB5_74:
	movs	r0, #32
	str	r0, [sp, #44]
	movw	r0, :lower16:htim2
	add	r1, sp, #44
	movt	r0, :upper16:htim2
	movs	r6, #0
	str	r6, [sp, #48]
	str	r6, [sp, #52]
	bl	HAL_TIMEx_MasterConfigSynchronization
	cbz	r0, .LBB5_76
.LBB5_75:                               @ =>This Inner Loop Header: Depth=1
	movs	r1, #2
	mov	r0, r4
	bl	HAL_GPIO_TogglePin
	movs	r0, #50
	bl	HAL_Delay
	b	.LBB5_75
	.p2align	2
.LBB5_76:
	movw	r11, #1024
	movs	r0, #28
	movs	r1, #0
	movs	r2, #0
	movt	r11, #16384
	bl	HAL_NVIC_SetPriority
	movs	r0, #28
	bl	HAL_NVIC_EnableIRQ
	ldr.w	r0, [r9, #8]
	orr	r0, r0, #2
	str.w	r0, [r9, #8]
	ldr.w	r0, [r9, #8]
	and	r0, r0, #2
	str	r0, [sp, #64]
	movw	r0, :lower16:htim3
	ldr	r1, [sp, #64]
	movt	r0, :upper16:htim3
	movs	r1, #199
	strd	r11, r6, [r0]
	str	r6, [r0, #8]
	strd	r1, r6, [r0, #12]
	str	r6, [r0, #24]
	bl	HAL_TIM_Base_Init
	cbz	r0, .LBB5_78
.LBB5_77:                               @ =>This Inner Loop Header: Depth=1
	movs	r1, #2
	mov	r0, r4
	bl	HAL_GPIO_TogglePin
	movs	r0, #50
	bl	HAL_Delay
	b	.LBB5_77
	.p2align	2
.LBB5_78:
	mov.w	r0, #4096
	str	r0, [sp, #64]
	movw	r0, :lower16:htim3
	add	r1, sp, #64
	movt	r0, :upper16:htim3
	movs	r6, #0
	str	r6, [sp, #76]
	strd	r6, r6, [sp, #68]
	bl	HAL_TIM_ConfigClockSource
	cbz	r0, .LBB5_80
.LBB5_79:                               @ =>This Inner Loop Header: Depth=1
	movs	r1, #2
	mov	r0, r4
	bl	HAL_GPIO_TogglePin
	movs	r0, #50
	bl	HAL_Delay
	b	.LBB5_79
	.p2align	2
.LBB5_80:
	movs	r0, #29
	movs	r1, #1
	movs	r2, #0
	bl	HAL_NVIC_SetPriority
	movs	r0, #29
	bl	HAL_NVIC_EnableIRQ
	ldr.w	r0, [r9, #8]
	movw	r1, #1024
	orr	r0, r0, #4
	str.w	r0, [r9, #8]
	ldr.w	r0, [r9, #8]
	movt	r1, #16384
	and	r0, r0, #4
	str	r0, [sp, #64]
	ldr	r0, [sp, #64]
	movw	r0, :lower16:htim4
	movt	r0, :upper16:htim4
	add.w	r1, r1, #1024
	strd	r1, r6, [r0]
	str	r6, [r0, #8]
	movw	r1, #3199
	strd	r1, r6, [r0, #12]
	str	r6, [r0, #24]
	bl	HAL_TIM_Base_Init
	cbz	r0, .LBB5_82
.LBB5_81:                               @ =>This Inner Loop Header: Depth=1
	movs	r1, #2
	mov	r0, r4
	bl	HAL_GPIO_TogglePin
	movs	r0, #50
	bl	HAL_Delay
	b	.LBB5_81
	.p2align	2
.LBB5_82:
	mov.w	r0, #4096
	str	r0, [sp, #64]
	movw	r0, :lower16:htim4
	add	r1, sp, #64
	movt	r0, :upper16:htim4
	movs	r6, #0
	str	r6, [sp, #76]
	strd	r6, r6, [sp, #68]
	bl	HAL_TIM_ConfigClockSource
	cbz	r0, .LBB5_84
.LBB5_83:                               @ =>This Inner Loop Header: Depth=1
	movs	r1, #2
	mov	r0, r4
	bl	HAL_GPIO_TogglePin
	movs	r0, #50
	bl	HAL_Delay
	b	.LBB5_83
	.p2align	2
.LBB5_84:
	movs	r0, #30
	movs	r1, #2
	movs	r2, #0
	bl	HAL_NVIC_SetPriority
	movs	r0, #30
	bl	HAL_NVIC_EnableIRQ
	bl	HAL_RCC_GetPCLK1Freq
	movw	r11, :lower16:htim2
	movs	r1, #99
	movt	r11, :upper16:htim2
	ldr.w	r0, [r11]
	str	r6, [r0, #40]
	str	r1, [r0, #44]
	str.w	r1, [r11, #12]
	str	r6, [r0, #36]
	movw	r0, #48580
	movt	r0, #65520
	str	r0, [sp, #24]                   @ 4-byte Spill
.LBB5_85:                               @ =>This Inner Loop Header: Depth=1
	movw	r1, :lower16:.L_MergedGlobals.41
	movt	r1, :upper16:.L_MergedGlobals.41
	ldrb	r1, [r1, #15]
	cmp	r1, #0
	itttt	ne
	movwne	r1, :lower16:.L_MergedGlobals.41
	movtne	r1, :upper16:.L_MergedGlobals.41
	ldrbne	r1, [r1, #15]
	cmpne	r1, #0
	beq	.LBB5_88
@ %bb.86:                               @   in Loop: Header=BB5_85 Depth=1
	movw	r1, :lower16:.L_MergedGlobals.41
	movt	r1, :upper16:.L_MergedGlobals.41
	ldrb	r1, [r1, #15]
	cmp	r1, #0
	itttt	ne
	movwne	r1, :lower16:.L_MergedGlobals.41
	movtne	r1, :upper16:.L_MergedGlobals.41
	ldrbne	r1, [r1, #15]
	cmpne	r1, #0
	beq	.LBB5_88
@ %bb.87:                               @   in Loop: Header=BB5_85 Depth=1
	cmp	r0, #0
	add.w	r0, r0, #4
	bne	.LBB5_85
.LBB5_88:
	movw	r0, #62148
	movs	r1, #0
	movt	r0, #65532
	adr.w	r2, .LCPI5_17
	b	.LBB5_90
	.p2align	2
.LBB5_89:                               @   in Loop: Header=BB5_90 Depth=1
	movw	r6, #17436
	ldrb	r3, [r2, r1]
	adds	r1, #1
	movt	r6, #16384
	cmp	r1, #22
	str	r3, [r6, #12]
	beq	.LBB5_94
.LBB5_90:                               @ =>This Loop Header: Depth=1
                                        @     Child Loop BB5_91 Depth 2
	mov	r3, r0
.LBB5_91:                               @   Parent Loop BB5_90 Depth=1
                                        @ =>  This Inner Loop Header: Depth=2
	movw	r6, #17436
	movt	r6, #16384
	ldr	r6, [r6]
	lsls	r6, r6, #24
	itttt	pl
	movwpl	r6, #17436
	movtpl	r6, #16384
	ldrpl	r6, [r6]
	lslspl.w	r6, r6, #24
	bmi	.LBB5_89
@ %bb.92:                               @   in Loop: Header=BB5_91 Depth=2
	movw	r6, #17436
	movt	r6, #16384
	ldr	r6, [r6]
	lsls	r6, r6, #24
	itttt	pl
	movwpl	r6, #17436
	movtpl	r6, #16384
	ldrpl	r6, [r6]
	lslspl.w	r6, r6, #24
	bmi	.LBB5_89
@ %bb.93:                               @   in Loop: Header=BB5_91 Depth=2
	cmp	r3, #0
	add.w	r3, r3, #4
	bne	.LBB5_91
	b	.LBB5_89
	.p2align	2
.LBB5_94:
	movw	r1, #48580
	movt	r1, #65520
.LBB5_95:                               @ =>This Inner Loop Header: Depth=1
	movw	r2, :lower16:.L_MergedGlobals.41
	movt	r2, :upper16:.L_MergedGlobals.41
	ldrb	r2, [r2, #15]
	cmp	r2, #0
	itttt	ne
	movwne	r2, :lower16:.L_MergedGlobals.41
	movtne	r2, :upper16:.L_MergedGlobals.41
	ldrbne	r2, [r2, #15]
	cmpne	r2, #0
	beq	.LBB5_98
@ %bb.96:                               @   in Loop: Header=BB5_95 Depth=1
	movw	r2, :lower16:.L_MergedGlobals.41
	movt	r2, :upper16:.L_MergedGlobals.41
	ldrb	r2, [r2, #15]
	cmp	r2, #0
	itttt	ne
	movwne	r2, :lower16:.L_MergedGlobals.41
	movtne	r2, :upper16:.L_MergedGlobals.41
	ldrbne	r2, [r2, #15]
	cmpne	r2, #0
	beq	.LBB5_98
@ %bb.97:                               @   in Loop: Header=BB5_95 Depth=1
	cmp	r1, #0
	add.w	r1, r1, #4
	bne	.LBB5_95
.LBB5_98:
	movs	r1, #0
	adr.w	r2, .LCPI5_18
	b	.LBB5_100
	.p2align	2
.LBB5_99:                               @   in Loop: Header=BB5_100 Depth=1
	movw	r6, #17436
	ldrb	r3, [r2, r1]
	adds	r1, #1
	movt	r6, #16384
	cmp	r1, #50
	str	r3, [r6, #12]
	beq	.LBB5_104
.LBB5_100:                              @ =>This Loop Header: Depth=1
                                        @     Child Loop BB5_101 Depth 2
	mov	r3, r0
.LBB5_101:                              @   Parent Loop BB5_100 Depth=1
                                        @ =>  This Inner Loop Header: Depth=2
	movw	r6, #17436
	movt	r6, #16384
	ldr	r6, [r6]
	lsls	r6, r6, #24
	itttt	pl
	movwpl	r6, #17436
	movtpl	r6, #16384
	ldrpl	r6, [r6]
	lslspl.w	r6, r6, #24
	bmi	.LBB5_99
@ %bb.102:                              @   in Loop: Header=BB5_101 Depth=2
	movw	r6, #17436
	movt	r6, #16384
	ldr	r6, [r6]
	lsls	r6, r6, #24
	itttt	pl
	movwpl	r6, #17436
	movtpl	r6, #16384
	ldrpl	r6, [r6]
	lslspl.w	r6, r6, #24
	bmi	.LBB5_99
@ %bb.103:                              @   in Loop: Header=BB5_101 Depth=2
	cmp	r3, #0
	add.w	r3, r3, #4
	bne	.LBB5_101
	b	.LBB5_99
	.p2align	2
.LBB5_104:
	mov.w	r11, #0
	vldr	s18, __arm_cp.5_39
	vldr	s20, __arm_cp.5_40
	movs	r1, #0
	vldr	s22, __arm_cp.5_41
.LBB5_105:                              @ =>This Inner Loop Header: Depth=1
	vmov	s0, r1
	mov	r6, r1
	vcvt.f32.u32	s0, s0
	vmul.f32	s0, s0, s18
	vmul.f32	s16, s0, s20
	vmov.f32	s0, s16
	bl	__hardfp_sinf
	vmul.f32	s0, s0, s22
	movw	r1, :lower16:sin_table_q15
	movt	r1, :upper16:sin_table_q15
	add.w	r2, r1, r11
	str	r2, [sp, #40]                   @ 4-byte Spill
	vcvt.s32.f32	s0, s0
	vmov	r0, s0
	vmov.f32	s0, s16
	strh.w	r0, [r1, r11]
	bl	__hardfp_cosf
	adds	r0, r6, #1
	vmul.f32	s0, s0, s22
	vmov	s2, r0
	movw	r1, :lower16:cos_table_q15
	movt	r1, :upper16:cos_table_q15
	str.w	r11, [sp, #28]                  @ 4-byte Spill
	vcvt.s32.f32	s0, s0
	add.w	r2, r1, r11
	vcvt.f32.u32	s2, s2
	str	r2, [sp, #36]                   @ 4-byte Spill
	vmov	r0, s0
	vmul.f32	s2, s2, s18
	strh.w	r0, [r1, r11]
	vmul.f32	s16, s2, s20
	vmov.f32	s0, s16
	bl	__hardfp_sinf
	vmul.f32	s0, s0, s22
	ldr	r1, [sp, #40]                   @ 4-byte Reload
	vcvt.s32.f32	s0, s0
	vmov	r0, s0
	vmov.f32	s0, s16
	strh	r0, [r1, #2]
	bl	__hardfp_cosf
	adds	r0, r6, #2
	vmul.f32	s0, s0, s22
	vmov	s2, r0
	ldr.w	r11, [sp, #36]                  @ 4-byte Reload
	str	r6, [sp, #32]                   @ 4-byte Spill
	vcvt.s32.f32	s0, s0
	vcvt.f32.u32	s2, s2
	vmov	r0, s0
	vmul.f32	s2, s2, s18
	strh.w	r0, [r11, #2]
	vmul.f32	s16, s2, s20
	vmov.f32	s0, s16
	bl	__hardfp_sinf
	vmul.f32	s0, s0, s22
	ldr	r1, [sp, #40]                   @ 4-byte Reload
	vcvt.s32.f32	s0, s0
	vmov	r0, s0
	vmov.f32	s0, s16
	strh	r0, [r1, #4]
	bl	__hardfp_cosf
	adds	r0, r6, #3
	vmul.f32	s0, s0, s22
	vmov	s2, r0
	vcvt.s32.f32	s0, s0
	vcvt.f32.u32	s2, s2
	vmov	r0, s0
	vmul.f32	s2, s2, s18
	strh.w	r0, [r11, #4]
	vmul.f32	s16, s2, s20
	vmov.f32	s0, s16
	bl	__hardfp_sinf
	vmul.f32	s0, s0, s22
	ldr	r6, [sp, #40]                   @ 4-byte Reload
	vcvt.s32.f32	s0, s0
	vmov	r0, s0
	vmov.f32	s0, s16
	strh	r0, [r6, #6]
	bl	__hardfp_cosf
	ldr	r0, [sp, #32]                   @ 4-byte Reload
	vmul.f32	s0, s0, s22
	adds	r0, #4
	vmov	s2, r0
	vcvt.s32.f32	s0, s0
	vcvt.f32.u32	s2, s2
	vmov	r0, s0
	vmul.f32	s2, s2, s18
	strh.w	r0, [r11, #6]
	vmul.f32	s16, s2, s20
	vmov.f32	s0, s16
	bl	__hardfp_sinf
	vmul.f32	s0, s0, s22
	mov	r11, r6
	vcvt.s32.f32	s0, s0
	vmov	r0, s0
	vmov.f32	s0, s16
	strh	r0, [r6, #8]
	bl	__hardfp_cosf
	ldr	r6, [sp, #32]                   @ 4-byte Reload
	vmul.f32	s0, s0, s22
	adds	r0, r6, #5
	ldr	r1, [sp, #36]                   @ 4-byte Reload
	vmov	s2, r0
	vcvt.s32.f32	s0, s0
	vcvt.f32.u32	s2, s2
	vmov	r0, s0
	vmul.f32	s2, s2, s18
	strh	r0, [r1, #8]
	vmul.f32	s16, s2, s20
	vmov.f32	s0, s16
	bl	__hardfp_sinf
	vmul.f32	s0, s0, s22
	vcvt.s32.f32	s0, s0
	vmov	r0, s0
	vmov.f32	s0, s16
	strh.w	r0, [r11, #10]
	bl	__hardfp_cosf
	adds	r0, r6, #6
	vmul.f32	s0, s0, s22
	vmov	s2, r0
	mov	r11, r6
	ldr	r6, [sp, #36]                   @ 4-byte Reload
	vcvt.s32.f32	s0, s0
	vcvt.f32.u32	s2, s2
	vmov	r0, s0
	vmul.f32	s2, s2, s18
	strh	r0, [r6, #10]
	vmul.f32	s16, s2, s20
	vmov.f32	s0, s16
	bl	__hardfp_sinf
	vmul.f32	s0, s0, s22
	ldr	r1, [sp, #40]                   @ 4-byte Reload
	vcvt.s32.f32	s0, s0
	vmov	r0, s0
	vmov.f32	s0, s16
	strh	r0, [r1, #12]
	bl	__hardfp_cosf
	add.w	r0, r11, #7
	vmul.f32	s0, s0, s22
	vmov	s2, r0
	vcvt.s32.f32	s0, s0
	vcvt.f32.u32	s2, s2
	vmov	r0, s0
	vmul.f32	s2, s2, s18
	strh	r0, [r6, #12]
	vmul.f32	s16, s2, s20
	vmov.f32	s0, s16
	bl	__hardfp_sinf
	vmul.f32	s0, s0, s22
	ldr	r1, [sp, #40]                   @ 4-byte Reload
	vcvt.s32.f32	s0, s0
	vmov	r0, s0
	vmov.f32	s0, s16
	strh	r0, [r1, #14]
	bl	__hardfp_cosf
	vmul.f32	s0, s0, s22
	add.w	r11, r11, #8
	mov	r1, r11
	cmp.w	r11, #4096
	ldr.w	r11, [sp, #28]                  @ 4-byte Reload
	vcvt.s32.f32	s0, s0
	add.w	r11, r11, #16
	vmov	r0, s0
	strh	r0, [r6, #14]
	bne.w	.LBB5_105
@ %bb.106:
	movw	r6, :lower16:.L_MergedGlobals.41
	movw	r0, :lower16:htim2
	movt	r6, :upper16:.L_MergedGlobals.41
	movt	r0, :upper16:htim2
	mov.w	r11, #0
	str.w	r11, [r6, #64]
	bl	HAL_TIM_Base_Start_IT
	ldrb	r0, [r6, #9]
	cbnz	r0, .LBB5_113
@ %bb.107:
	add	r6, sp, #64
	movs	r1, #184
	add.w	r0, r6, #8
	bl	__aeabi_memclr8
	mov.w	r0, #256
	str	r0, [sp, #64]
	movs	r0, #3
	str	r0, [sp, #152]
	mov	r0, r6
	str.w	r11, [sp, #68]
	bl	HAL_RCCEx_PeriphCLKConfig
	cbz	r0, .LBB5_112
.LBB5_108:                              @ =>This Inner Loop Header: Depth=1
	movs	r1, #2
	mov	r0, r4
	bl	HAL_GPIO_TogglePin
	movs	r0, #50
	bl	HAL_Delay
	b	.LBB5_108
	.p2align	2
@ %bb.109:
__arm_cp.5_39:
	.long	0x40c90fdb                      @ float 6.28318548
.Lcpi_end0:
	.size	__arm_cp.5_39, .Lcpi_end0-__arm_cp.5_39
	.p2align	2
@ %bb.110:
__arm_cp.5_40:
	.long	0x39800000                      @ float 2.44140625E-4
.Lcpi_end1:
	.size	__arm_cp.5_40, .Lcpi_end1-__arm_cp.5_40
	.p2align	2
@ %bb.111:
__arm_cp.5_41:
	.long	0x46fffe00                      @ float 32767
.Lcpi_end2:
	.size	__arm_cp.5_41, .Lcpi_end2-__arm_cp.5_41
	.p2align	2
.LBB5_112:
	bl	MX_SAI1_Init
	bl	PCM5102_Init
	movw	r1, :lower16:.L_MergedGlobals.41
	movs	r0, #1
	movt	r1, :upper16:.L_MergedGlobals.41
	strb	r0, [r1, #9]
.LBB5_113:
	movw	r1, #15368
	movw	r2, :lower16:.L_MergedGlobals
	movt	r1, #16384
	movt	r2, :upper16:.L_MergedGlobals
	ldr	r0, [r1, #-8]
	ldr	r0, [r1, #-4]
	ldr	r0, [r1]
	ldr	r0, [r1, #4]
	ldr	r0, [r1, #12]
	movw	r1, :lower16:.L_MergedGlobals.41
	movt	r1, :upper16:.L_MergedGlobals.41
	movs	r0, #1
	strb.w	r11, [r1, #1]
	str.w	r11, [r8, #4]
	strb.w	r11, [r1, #11]
	strb	r0, [r2, #2]
	mov.w	r0, #2048
	strb.w	r11, [r1, #12]
	movw	r1, #2048
	str.w	r0, [r10, #8]
	movt	r1, #16386
	str.w	r0, [r10, #20]
	movw	r2, #8204
	ldr	r0, [r9, #-8]
	movt	r2, #16386
	orr	r0, r0, #1
	str	r0, [r9, #-8]
	ldr	r0, [r9, #-8]
	and	r0, r0, #1
	str	r0, [sp, #64]
	ldr	r0, [sp, #64]
	movs	r0, #9
	str	r0, [r1]
	movs	r1, #16
	movt	r1, #16386
	movw	r0, #11264
	movt	r0, #7
	str	r0, [r1]
	add.w	r0, r2, #52
	str	r0, [r1, #8]
	movw	r0, :lower16:adc_dma_buf
	movt	r0, :upper16:adc_dma_buf
	str	r0, [r1, #12]
	movw	r0, :lower16:adc_dma_buf2
	movt	r0, :upper16:adc_dma_buf2
	str	r0, [r1, #16]
	mov.w	r0, #4096
	str	r0, [r1, #4]
	dmb	sy
	ldr	r0, [r1]
	orr	r0, r0, #1
	str	r0, [r1]
	ldr	r0, [r2]
	orr	r0, r0, #3
	str	r0, [r2]
	ldr	r0, [r2, #-4]
	orr	r0, r0, #1
	str	r0, [r2, #-4]
.LBB5_114:                              @ =>This Inner Loop Header: Depth=1
	movw	r0, #8204
	movt	r0, #16386
	ldr	r0, [r0, #-12]
	lsls	r0, r0, #31
	itttt	eq
	movweq	r0, #8204
	movteq	r0, #16386
	ldreq	r0, [r0, #-12]
	lslseq.w	r0, r0, #31
	bne	.LBB5_117
@ %bb.115:                              @   in Loop: Header=BB5_114 Depth=1
	movw	r0, #8204
	movt	r0, #16386
	ldr	r0, [r0, #-12]
	lsls	r0, r0, #31
	itttt	eq
	movweq	r0, #8204
	movteq	r0, #16386
	ldreq	r0, [r0, #-12]
	lslseq.w	r0, r0, #31
	bne	.LBB5_117
@ %bb.116:                              @   in Loop: Header=BB5_114 Depth=1
	ldr	r0, [sp, #24]                   @ 4-byte Reload
	cmp	r0, #0
	add.w	r0, r0, #4
	str	r0, [sp, #24]                   @ 4-byte Spill
	bne	.LBB5_114
.LBB5_117:
	movw	r1, #8204
	mov.w	r9, #0
	movt	r1, #16386
	movw	r2, :lower16:.L.str.8
	add	r6, sp, #64
	movt	r2, :upper16:.L.str.8
	ldr	r0, [r1]
	bic	r0, r0, #3072
	str	r0, [r1]
	ldr	r0, [r1]
	orr	r0, r0, #8192
	str	r0, [r1]
	ldr	r0, [r1, #-4]
	orr	r0, r0, #4
	str	r0, [r1, #-4]
	movw	r0, :lower16:.L_MergedGlobals.41
	movs	r1, #16
	movt	r0, :upper16:.L_MergedGlobals.41
	movt	r1, #16386
	strb.w	r9, [r0, #13]
	ldr	r3, [r1]
	ldr	r0, [r1, #4]
	uxth.w	r12, r0
	ldr	r0, [r1, #12]
	movs	r1, #96
	strd	r12, r0, [sp]
	mov	r0, r6
	bl	__2snprintf
	cmp	r0, #1
	blt	.LBB5_128
@ %bb.118:
	movw	r1, :lower16:hdma_usart2_tx
	movt	r1, :upper16:hdma_usart2_tx
	ldrb.w	r1, [r1, #53]
	cmp	r1, #1
	bne	.LBB5_128
@ %bb.119:
	uxth	r3, r0
	cbz	r3, .LBB5_126
@ %bb.120:
	dsb	sy
	and	r0, r6, #31
	add	r0, r3
.LBB5_121:                              @ =>This Inner Loop Header: Depth=1
	cmp	r0, #33
	str	r6, [r7]
	blo	.LBB5_125
@ %bb.122:                              @   in Loop: Header=BB5_121 Depth=1
	subs	r0, #65
	add.w	r1, r6, #32
	cmn.w	r0, #34
	str	r1, [r7]
	bhi	.LBB5_125
@ %bb.123:                              @   in Loop: Header=BB5_121 Depth=1
	subs	r0, #32
	adds	r1, #32
	cmn.w	r0, #34
	str	r1, [r7]
	bhi	.LBB5_125
@ %bb.124:                              @   in Loop: Header=BB5_121 Depth=1
	sub.w	r6, r0, #32
	subs	r0, #31
	cmn.w	r6, #33
	add.w	r6, r1, #64
	add.w	r2, r1, #32
	str	r2, [r7]
	blo	.LBB5_121
.LBB5_125:
	dsb	sy
	isb	sy
.LBB5_126:
	movw	r1, #17436
	movt	r1, #16384
	add.w	r2, r1, #12
	ldr	r0, [r1, #-20]
	orr	r0, r0, #128
	str	r0, [r1, #-20]
	movw	r0, :lower16:hdma_usart2_tx
	add	r1, sp, #64
	movt	r0, :upper16:hdma_usart2_tx
	bl	HAL_DMA_Start_IT
	cbnz	r0, .LBB5_128
@ %bb.127:
	movw	r1, :lower16:.L_MergedGlobals.41
	movs	r0, #1
	movt	r1, :upper16:.L_MergedGlobals.41
	strb	r0, [r1, #15]
.LBB5_128:
	movw	r1, #65172
	movw	lr, #4100
	movt	r1, #65535
	movt	lr, #57344
	movs	r0, #16
	mov.w	r6, #2048
	ldr	r2, [r7, r1]
	movt	r0, #16386
	orr	r2, r2, #16777216
	str	r2, [r7, r1]
	str.w	r9, [lr]
	ldr	r1, [lr, #-4]
	orr	r1, r1, #1
	str	r1, [lr, #-4]
	ldr	r3, [r0, #4]
	ldr.w	r12, [lr]
	uxth	r0, r3
	uxtah	r3, r6, r3
.LBB5_129:                              @ =>This Inner Loop Header: Depth=1
	movs	r1, #16
	mov	r2, r0
	movt	r1, #16386
	ldr	r6, [r1, #4]
	uxth	r6, r6
	cmp	r0, r6
	it	lo
	movlo	r2, r3
	subs	r2, r2, r6
	cmp.w	r9, r2, lsr #10
	bne	.LBB5_133
@ %bb.130:                              @   in Loop: Header=BB5_129 Depth=1
	ldr	r2, [r1, #4]
	mov	r1, r0
	uxth	r2, r2
	cmp	r0, r2
	it	lo
	movlo	r1, r3
	subs	r1, r1, r2
	cmp.w	r9, r1, lsr #10
	bne	.LBB5_133
@ %bb.131:                              @   in Loop: Header=BB5_129 Depth=1
	movs	r1, #16
	mov	r2, r0
	movt	r1, #16386
	ldr	r1, [r1, #4]
	uxth	r1, r1
	cmp	r0, r1
	it	lo
	movlo	r2, r3
	subs	r1, r2, r1
	cmp.w	r9, r1, lsr #10
	bne	.LBB5_133
@ %bb.132:                              @   in Loop: Header=BB5_129 Depth=1
	movs	r1, #16
	mov	r2, r0
	movt	r1, #16386
	ldr	r1, [r1, #4]
	uxth	r1, r1
	cmp	r0, r1
	it	lo
	movlo	r2, r3
	subs	r1, r2, r1
	cmp.w	r1, #1024
	blo	.LBB5_129
.LBB5_133:
	ldr.w	r0, [lr]
	movs	r1, #114
	sub.w	r9, r0, r12
	movs	r0, #0
	movt	r0, #28896
	movs	r3, #0
	mov	r2, r9
	bl	__aeabi_uldivmod
.LBB5_134:                              @ =>This Inner Loop Header: Depth=1
	movw	r1, :lower16:hdma_usart2_tx
	movt	r1, :upper16:hdma_usart2_tx
	ldrb.w	r1, [r1, #53]
	cmp	r1, #1
	beq	.LBB5_137
@ %bb.135:                              @   in Loop: Header=BB5_134 Depth=1
	movw	r1, :lower16:hdma_usart2_tx
	movt	r1, :upper16:hdma_usart2_tx
	ldrb.w	r1, [r1, #53]
	cmp	r1, #1
	itttt	ne
	movwne	r1, :lower16:hdma_usart2_tx
	movtne	r1, :upper16:hdma_usart2_tx
	ldrbne.w	r1, [r1, #53]
	cmpne	r1, #1
	beq	.LBB5_137
@ %bb.136:                              @   in Loop: Header=BB5_134 Depth=1
	movw	r1, :lower16:hdma_usart2_tx
	movt	r1, :upper16:hdma_usart2_tx
	ldrb.w	r1, [r1, #53]
	cmp	r1, #1
	bne	.LBB5_134
.LBB5_137:
	movw	r2, :lower16:.L.str.9
	add	r6, sp, #64
	movt	r2, :upper16:.L.str.9
	movs	r1, #96
	str	r0, [sp]
	mov	r0, r6
	mov	r3, r9
	bl	__2snprintf
	cmp	r0, #1
	blt	.LBB5_148
@ %bb.138:
	movw	r1, :lower16:hdma_usart2_tx
	movt	r1, :upper16:hdma_usart2_tx
	ldrb.w	r1, [r1, #53]
	cmp	r1, #1
	bne	.LBB5_148
@ %bb.139:
	uxth	r3, r0
	cbz	r3, .LBB5_146
@ %bb.140:
	dsb	sy
	and	r0, r6, #31
	add	r0, r3
.LBB5_141:                              @ =>This Inner Loop Header: Depth=1
	cmp	r0, #33
	str	r6, [r7]
	blo	.LBB5_145
@ %bb.142:                              @   in Loop: Header=BB5_141 Depth=1
	subs	r0, #65
	add.w	r1, r6, #32
	cmn.w	r0, #34
	str	r1, [r7]
	bhi	.LBB5_145
@ %bb.143:                              @   in Loop: Header=BB5_141 Depth=1
	subs	r0, #32
	adds	r1, #32
	cmn.w	r0, #34
	str	r1, [r7]
	bhi	.LBB5_145
@ %bb.144:                              @   in Loop: Header=BB5_141 Depth=1
	sub.w	r6, r0, #32
	subs	r0, #31
	cmn.w	r6, #33
	add.w	r6, r1, #64
	add.w	r2, r1, #32
	str	r2, [r7]
	blo	.LBB5_141
.LBB5_145:
	dsb	sy
	isb	sy
.LBB5_146:
	movw	r1, #17436
	movt	r1, #16384
	add.w	r2, r1, #12
	ldr	r0, [r1, #-20]
	orr	r0, r0, #128
	str	r0, [r1, #-20]
	movw	r0, :lower16:hdma_usart2_tx
	add	r1, sp, #64
	movt	r0, :upper16:hdma_usart2_tx
	bl	HAL_DMA_Start_IT
	cbnz	r0, .LBB5_148
@ %bb.147:
	movw	r1, :lower16:.L_MergedGlobals.41
	movs	r0, #1
	movt	r1, :upper16:.L_MergedGlobals.41
	strb	r0, [r1, #15]
.LBB5_148:
	movs	r0, #1
	bl	am_demod_enable
	movs	r0, #1
	bl	PCM5102_SetDemodMode
	bl	PCM5102_Play
	movw	r0, :lower16:htim3
	movt	r0, :upper16:htim3
	bl	HAL_TIM_Base_Start_IT
	movw	r0, :lower16:htim4
	movt	r0, :upper16:htim4
	bl	HAL_TIM_Base_Start_IT
	movw	r6, #8204
	movw	r9, :lower16:main.adc1_diag
	movt	r6, #16386
	movt	r9, :upper16:main.adc1_diag
	ldr	r3, [r6, #-4]
	ldr	r0, [r6]
	ldr	r1, [r6, #8]
	ldr	r2, [r6, #-12]
	ldr	r6, [r6, #52]
	stm.w	sp, {r0, r1, r2}
	movw	r2, :lower16:.L.str.10
	movs	r1, #160
	movt	r2, :upper16:.L.str.10
	mov	r0, r9
	uxth	r6, r6
	str	r6, [sp, #12]
	bl	__2snprintf
	cmp	r0, #1
	blt	.LBB5_159
@ %bb.149:
	movw	r1, :lower16:hdma_usart2_tx
	movt	r1, :upper16:hdma_usart2_tx
	ldrb.w	r1, [r1, #53]
	cmp	r1, #1
	bne	.LBB5_159
@ %bb.150:
	uxth	r3, r0
	cbz	r3, .LBB5_157
@ %bb.151:
	dsb	sy
	and	r0, r9, #31
	add	r0, r3
.LBB5_152:                              @ =>This Inner Loop Header: Depth=1
	cmp	r0, #33
	str.w	r9, [r7]
	blo	.LBB5_156
@ %bb.153:                              @   in Loop: Header=BB5_152 Depth=1
	subs	r0, #65
	add.w	r1, r9, #32
	cmn.w	r0, #34
	str	r1, [r7]
	bhi	.LBB5_156
@ %bb.154:                              @   in Loop: Header=BB5_152 Depth=1
	subs	r0, #32
	adds	r1, #32
	cmn.w	r0, #34
	str	r1, [r7]
	bhi	.LBB5_156
@ %bb.155:                              @   in Loop: Header=BB5_152 Depth=1
	sub.w	r6, r0, #32
	add.w	r9, r1, #64
	cmn.w	r6, #33
	sub.w	r0, r0, #31
	add.w	r2, r1, #32
	str	r2, [r7]
	blo	.LBB5_152
.LBB5_156:
	dsb	sy
	isb	sy
.LBB5_157:
	movw	r11, #17436
	movw	r1, :lower16:main.adc1_diag
	movt	r11, #16384
	movt	r1, :upper16:main.adc1_diag
	add.w	r2, r11, #12
	ldr	r0, [r11, #-20]
	orr	r0, r0, #128
	str	r0, [r11, #-20]
	movw	r0, :lower16:hdma_usart2_tx
	movt	r0, :upper16:hdma_usart2_tx
	bl	HAL_DMA_Start_IT
	cbnz	r0, .LBB5_159
@ %bb.158:
	movw	r1, :lower16:.L_MergedGlobals.41
	movs	r0, #1
	movt	r1, :upper16:.L_MergedGlobals.41
	strb	r0, [r1, #15]
.LBB5_159:
	movw	r10, #16384
	movw	r0, #52428
	movt	r10, #65534
	movs	r1, #3
	str.w	r0, [r4, r10]
	movw	r0, #21845
	str.w	r0, [r4, r10]
	movw	r0, #16388
	movt	r0, #65534
	str	r1, [r4, r0]
	movw	r0, #16392
	movt	r0, #65534
	mov.w	r1, #8000
	str	r1, [r4, r0]
	bl	HAL_GetTick
	movw	r9, #16396
	mov	r6, r0
	movt	r9, #65534
.LBB5_160:                              @ =>This Inner Loop Header: Depth=1
	ldr.w	r0, [r4, r9]
	lsls	r0, r0, #30
	beq	.LBB5_162
@ %bb.161:                              @   in Loop: Header=BB5_160 Depth=1
	bl	HAL_GetTick
	subs	r0, r0, r6
	cmp	r0, #21
	blo	.LBB5_160
.LBB5_162:
	movw	r0, :lower16:tx_frame
	movw	r1, #8196
	movt	r0, :upper16:tx_frame
	movw	r2, #8197
	and	r0, r0, #31
	movw	r9, #43690
	add	r1, r0
	str.w	r9, [r4, r10]
	add	r2, r0
	str	r2, [sp, #24]                   @ 4-byte Spill
	movs	r2, #1
	add.w	r1, r2, r1, lsr #5
	movw	r2, #8165
	uxtb	r1, r1
	str	r1, [sp, #32]                   @ 4-byte Spill
	adds	r1, r0, r2
	str	r1, [sp, #28]                   @ 4-byte Spill
	movw	r1, #8133
	movw	r2, #8101
	add	r1, r0
	str	r1, [sp, #20]                   @ 4-byte Spill
	add	r0, r2
	str	r0, [sp, #16]                   @ 4-byte Spill
	movs	r0, #0
	str	r0, [sp, #36]                   @ 4-byte Spill
	b	.LBB5_165
	.p2align	2
.LBB5_163:                              @   in Loop: Header=BB5_165 Depth=1
	ldr.w	r0, [r8, #48]
	adds	r0, #1
	str.w	r0, [r8, #48]
.LBB5_164:                              @   in Loop: Header=BB5_165 Depth=1
	movw	r0, :lower16:.L_MergedGlobals.41
	movt	r0, :upper16:.L_MergedGlobals.41
	ldr	r0, [r0, #44]
	ldr	r1, [sp, #36]                   @ 4-byte Reload
	subs	r0, r0, r1
	movw	r1, #40704
	movt	r1, #36
	cmp	r0, r1
	bhs.w	.LBB5_217
.LBB5_165:                              @ =>This Loop Header: Depth=1
                                        @     Child Loop BB5_166 Depth 2
                                        @       Child Loop BB5_168 Depth 3
                                        @       Child Loop BB5_178 Depth 3
                                        @     Child Loop BB5_191 Depth 2
                                        @       Child Loop BB5_194 Depth 3
                                        @     Child Loop BB5_207 Depth 2
                                        @     Child Loop BB5_209 Depth 2
	movw	r11, #16
	movt	r11, #16386
.LBB5_166:                              @   Parent Loop BB5_165 Depth=1
                                        @ =>  This Loop Header: Depth=2
                                        @       Child Loop BB5_168 Depth 3
                                        @       Child Loop BB5_178 Depth 3
	bl	process_spi_commands
	movs	r6, #0
	b	.LBB5_168
	.p2align	2
.LBB5_167:                              @   in Loop: Header=BB5_168 Depth=3
	adds	r6, #1
	cmp	r6, #64
	beq	.LBB5_171
.LBB5_168:                              @   Parent Loop BB5_165 Depth=1
                                        @     Parent Loop BB5_166 Depth=2
                                        @ =>    This Inner Loop Header: Depth=3
	bl	am_demod_poll
	cbz	r0, .LBB5_171
@ %bb.169:                              @   in Loop: Header=BB5_168 Depth=3
	lsls	r0, r6, #28
	bne	.LBB5_167
@ %bb.170:                              @   in Loop: Header=BB5_168 Depth=3
	movw	r0, :lower16:.L_MergedGlobals.41
	movt	r0, :upper16:.L_MergedGlobals.41
	ldrb	r0, [r0, #14]
	cmp	r0, #0
	it	ne
	strne.w	r9, [r4, r10]
	b	.LBB5_167
	.p2align	2
.LBB5_171:                              @   in Loop: Header=BB5_166 Depth=2
	ldr.w	r0, [r8, #8]
	adds	r0, #1
	str.w	r0, [r8, #8]
	movw	r0, :lower16:.L_MergedGlobals.41
	movt	r0, :upper16:.L_MergedGlobals.41
	ldrb	r0, [r0, #14]
	cmp	r0, #0
	movw	r0, :lower16:.L_MergedGlobals.41
	movt	r0, :upper16:.L_MergedGlobals.41
	it	ne
	strne.w	r9, [r4, r10]
	ldrb	r0, [r0, #13]
	cbnz	r0, .LBB5_174
@ %bb.172:                              @   in Loop: Header=BB5_166 Depth=2
	ldr.w	r0, [r11]
	lsls	r0, r0, #12
	bpl	.LBB5_166
@ %bb.173:                              @   in Loop: Header=BB5_166 Depth=2
	movw	r0, :lower16:.L_MergedGlobals.41
	movs	r1, #1
	movt	r0, :upper16:.L_MergedGlobals.41
	strb	r1, [r0, #13]
.LBB5_174:                              @   in Loop: Header=BB5_166 Depth=2
	ldr.w	r0, [r11]
	movw	r2, :lower16:adc_dma_buf2
	lsls	r1, r0, #12
	movw	r1, :lower16:adc_dma_buf
	movt	r1, :upper16:adc_dma_buf
	movt	r2, :upper16:adc_dma_buf2
	it	pl
	movpl	r1, r2
	movs	r6, #1
	and	r3, r1, #30
	subs	r2, r3, #1
	dsb	sy
	add.w	r2, r6, r2, lsr #5
	lsls	r2, r2, #30
	beq	.LBB5_176
@ %bb.175:                              @   in Loop: Header=BB5_166 Depth=2
	add.w	r2, r1, #32
	add.w	r3, r3, #8160
	str	r1, [r7, #-12]
	b	.LBB5_177
	.p2align	2
.LBB5_176:                              @   in Loop: Header=BB5_166 Depth=2
	add.w	r3, r3, #8192
	mov	r2, r1
.LBB5_177:                              @   in Loop: Header=BB5_166 Depth=2
	subs	r3, #1
.LBB5_178:                              @   Parent Loop BB5_165 Depth=1
                                        @     Parent Loop BB5_166 Depth=2
                                        @ =>    This Inner Loop Header: Depth=3
	subs	r3, #128
	str	r2, [r7, #-12]
	add.w	r6, r2, #32
	str	r6, [r7, #-12]
	add.w	r6, r2, #64
	str	r6, [r7, #-12]
	add.w	r6, r2, #96
	cmn.w	r3, #33
	add.w	r2, r2, #128
	str	r6, [r7, #-12]
	blo	.LBB5_178
@ %bb.179:                              @   in Loop: Header=BB5_166 Depth=2
	and	r0, r0, #524288
	movs	r2, #1
	dsb	sy
	eor.w	r6, r2, r0, lsr #19
	movw	r0, :lower16:tx_frame
	isb	sy
	movt	r0, :upper16:tx_frame
	mov.w	r2, #8192
	adds	r0, #5
	bl	__aeabi_memcpy
	ldr.w	r0, [r11]
	and	r0, r0, #524288
	cmp.w	r6, r0, lsr #19
	beq.w	.LBB5_166
@ %bb.180:                              @   in Loop: Header=BB5_165 Depth=1
	movw	r0, :lower16:.L_MergedGlobals.41
	movt	r0, :upper16:.L_MergedGlobals.41
	ldr	r3, [r0, #60]
	ldr	r2, [r0, #76]
	ldr	r1, [r0, #80]
	ldr.w	r0, [r8, #8]
	ldr.w	r6, [r8, #12]
	cmp	r3, r6
	bne	.LBB5_182
@ %bb.181:                              @   in Loop: Header=BB5_165 Depth=1
	movs	r6, #0
	b	.LBB5_183
	.p2align	2
.LBB5_182:                              @   in Loop: Header=BB5_165 Depth=1
	movs	r6, #1
	str.w	r3, [r8, #12]
.LBB5_183:                              @   in Loop: Header=BB5_165 Depth=1
	ldr.w	r3, [r8, #16]
	cmp	r2, r3
	bne.w	.LBB5_201
@ %bb.184:                              @   in Loop: Header=BB5_165 Depth=1
	ldr.w	r2, [r8, #20]
	cmp	r1, r2
	bne.w	.LBB5_202
.LBB5_185:                              @   in Loop: Header=BB5_165 Depth=1
	ldr.w	r1, [r8, #24]
	cmp	r0, r1
	beq	.LBB5_187
.LBB5_186:                              @   in Loop: Header=BB5_165 Depth=1
	adds	r6, #8
	str.w	r0, [r8, #24]
.LBB5_187:                              @   in Loop: Header=BB5_165 Depth=1
	movw	r0, :lower16:.L_MergedGlobals
	movt	r0, :upper16:.L_MergedGlobals
	ldrb	r0, [r0, #1]
	cbz	r0, .LBB5_189
@ %bb.188:                              @   in Loop: Header=BB5_165 Depth=1
	movw	r0, :lower16:.L_MergedGlobals.41
	movt	r0, :upper16:.L_MergedGlobals.41
	ldrb	r0, [r0, #13]
	cmp	r0, #0
	it	ne
	addne	r6, #16
.LBB5_189:                              @   in Loop: Header=BB5_165 Depth=1
	bl	PCM5102_IsPlaying
	cmp	r0, #0
	movw	r1, :lower16:.L_MergedGlobals.41
	it	ne
	addne	r6, #32
	movt	r1, :upper16:.L_MergedGlobals.41
	movw	r2, :lower16:tx_frame
	and	r0, r6, #15
	movt	r2, :upper16:tx_frame
	subs	r0, #15
	clz	r0, r0
	lsrs	r0, r0, #5
	strb	r0, [r1, #14]
	ldrb	r0, [r1, #14]
	cmp	r0, #0
	movw	r0, #23210
	it	ne
	strne.w	r9, [r4, r10]
	strh.w	r0, [r8, #52]
	mov.w	r0, #4096
	strh.w	r0, [r8, #55]
	movs	r0, #16
	strb	r0, [r2, #4]
	movw	r0, :lower16:hspi3
	movt	r0, :upper16:hspi3
	strb.w	r6, [r8, #54]
	ldr.w	r1, [r8, #52]
	str	r1, [r2]
	ldr	r0, [r0]
	movw	r2, #8197
	ldr	r1, [r0]
	bic	r1, r1, #1
	str	r1, [r0]
	movw	r1, #15368
	movw	r0, #2168
	movt	r1, #16384
	str	r0, [r1, #16]
	ldr	r0, [r1, #-4]
	bfi	r0, r2, #0, #16
	str	r0, [r1, #-4]
	bl	HAL_GetTick
	mov	r6, r0
	ldr.w	r0, [r8, #44]
	adds	r0, #1
	str.w	r0, [r8, #44]
	b	.LBB5_191
	.p2align	2
.LBB5_190:                              @   in Loop: Header=BB5_191 Depth=2
	bl	process_spi_commands
	movw	r0, :lower16:.L_MergedGlobals.41
	movt	r0, :upper16:.L_MergedGlobals.41
	ldrb	r0, [r0, #14]
	cmp	r0, #0
	it	ne
	strne.w	r9, [r4, r10]
	bl	HAL_GetTick
	subs	r0, r0, r6
	cmp.w	r0, #500
	bhi.w	.LBB5_163
.LBB5_191:                              @   Parent Loop BB5_165 Depth=1
                                        @ =>  This Loop Header: Depth=2
                                        @       Child Loop BB5_194 Depth 3
	mov.w	r1, #32768
	mov	r0, r5
	bl	HAL_GPIO_ReadPin
	cmp	r0, #1
	bne	.LBB5_197
@ %bb.192:                              @   in Loop: Header=BB5_191 Depth=2
	mov.w	r11, #0
	b	.LBB5_194
	.p2align	2
.LBB5_193:                              @   in Loop: Header=BB5_194 Depth=3
	add.w	r11, r11, #1
	cmp.w	r11, #64
	beq	.LBB5_190
.LBB5_194:                              @   Parent Loop BB5_165 Depth=1
                                        @     Parent Loop BB5_191 Depth=2
                                        @ =>    This Inner Loop Header: Depth=3
	bl	am_demod_poll
	cmp	r0, #0
	beq	.LBB5_190
@ %bb.195:                              @   in Loop: Header=BB5_194 Depth=3
	lsls.w	r0, r11, #28
	bne	.LBB5_193
@ %bb.196:                              @   in Loop: Header=BB5_194 Depth=3
	movw	r0, :lower16:.L_MergedGlobals.41
	movt	r0, :upper16:.L_MergedGlobals.41
	ldrb	r0, [r0, #14]
	cmp	r0, #0
	it	ne
	strne.w	r9, [r4, r10]
	b	.LBB5_193
	.p2align	2
.LBB5_197:                              @   in Loop: Header=BB5_165 Depth=1
	dsb	sy
	ldr	r0, [sp, #32]                   @ 4-byte Reload
	cmp	r0, #0
	beq	.LBB5_205
@ %bb.198:                              @   in Loop: Header=BB5_165 Depth=1
	ldr	r0, [sp, #32]                   @ 4-byte Reload
	cmp	r0, #1
	movw	r0, :lower16:tx_frame
	movt	r0, :upper16:tx_frame
	str	r0, [r7]
	add.w	r0, r0, #32
	ldr	r1, [sp, #28]                   @ 4-byte Reload
	beq	.LBB5_206
@ %bb.199:                              @   in Loop: Header=BB5_165 Depth=1
	ldr	r1, [sp, #32]                   @ 4-byte Reload
	str	r0, [r7]
	movw	r0, :lower16:tx_frame
	cmp	r1, #2
	movt	r0, :upper16:tx_frame
	ldr	r1, [sp, #20]                   @ 4-byte Reload
	add.w	r0, r0, #64
	beq	.LBB5_206
@ %bb.200:                              @   in Loop: Header=BB5_165 Depth=1
	str	r0, [r7]
	movw	r0, :lower16:tx_frame
	movt	r0, :upper16:tx_frame
	ldr	r1, [sp, #16]                   @ 4-byte Reload
	adds	r0, #96
	b	.LBB5_206
	.p2align	2
.LBB5_201:                              @   in Loop: Header=BB5_165 Depth=1
	adds	r6, #2
	str.w	r2, [r8, #16]
	ldr.w	r2, [r8, #20]
	cmp	r1, r2
	beq.w	.LBB5_185
.LBB5_202:                              @   in Loop: Header=BB5_165 Depth=1
	adds	r6, #4
	str.w	r1, [r8, #20]
	ldr.w	r1, [r8, #24]
	cmp	r0, r1
	bne.w	.LBB5_186
	b	.LBB5_187
	.p2align	2
@ %bb.203:
.LCPI5_36:
CFG_USB_DEFAULT:
	.long	33357                           @ 0x824d
	.long	32767                           @ 0x7fff
	.long	124554051                       @ 0x76c8b43
	.short	6094                            @ 0x17ce
	.short	0                               @ 0x0
	.short	0                               @ 0x0
	.zero	2
	.long	64                              @ 0x40
	.p2align	2
@ %bb.204:
.LCPI5_37:
CFG_LSB_DEFAULT:
	.long	33554                           @ 0x8312
	.long	32833                           @ 0x8041
	.long	155096041                       @ 0x93e93e9
	.short	57868                           @ 0xe20c
	.short	0                               @ 0x0
	.short	0                               @ 0x0
	.zero	2
	.long	100                             @ 0x64
	.p2align	2
.LBB5_205:                              @   in Loop: Header=BB5_165 Depth=1
	movw	r0, :lower16:tx_frame
	ldr	r1, [sp, #24]                   @ 4-byte Reload
	movt	r0, :upper16:tx_frame
.LBB5_206:                              @   in Loop: Header=BB5_165 Depth=1
	subs	r1, #1
.LBB5_207:                              @   Parent Loop BB5_165 Depth=1
                                        @ =>  This Inner Loop Header: Depth=2
	subs	r1, #128
	str	r0, [r7]
	add.w	r2, r0, #32
	str	r2, [r7]
	add.w	r2, r0, #64
	str	r2, [r7]
	add.w	r2, r0, #96
	cmn.w	r1, #33
	add.w	r0, r0, #128
	str	r2, [r7]
	blo	.LBB5_207
@ %bb.208:                              @   in Loop: Header=BB5_165 Depth=1
	movs	r1, #16
	movw	r11, #15368
	movt	r1, #16386
	movt	r11, #16384
	dsb	sy
	isb	sy
	movs	r6, #0
	str	r6, [r1, #120]
	add.w	r0, r11, #24
	str.w	r0, [r1, #128]
	movw	r0, :lower16:tx_frame
	movs	r2, #62
	movt	r0, :upper16:tx_frame
	str.w	r0, [r1, #132]
	movw	r0, #8197
	str	r0, [r1, #124]
	mov.w	r0, #3904
	str	r0, [r1, #-4]
	movw	r0, #1088
	movt	r0, #3
	str	r0, [r1, #120]
	movw	r0, #2048
	movt	r0, #16386
	str	r2, [r0, #20]
	ldr.w	r0, [r11]
	orr	r0, r0, #32768
	str.w	r0, [r11]
	ldr	r0, [r1, #120]
	orr	r0, r0, #1
	str	r0, [r1, #120]
	movw	r0, :lower16:hspi3
	movt	r0, :upper16:hspi3
	ldr	r0, [r0]
	ldr	r1, [r0]
	orr	r1, r1, #1
	str	r1, [r0]
	bl	HAL_GetTick
	str	r0, [sp, #40]                   @ 4-byte Spill
.LBB5_209:                              @   Parent Loop BB5_165 Depth=1
                                        @ =>  This Inner Loop Header: Depth=2
	bl	am_demod_poll
	cbz	r0, .LBB5_213
@ %bb.210:                              @   in Loop: Header=BB5_209 Depth=2
	lsls	r0, r6, #28
	bne	.LBB5_212
@ %bb.211:                              @   in Loop: Header=BB5_209 Depth=2
	movw	r0, :lower16:.L_MergedGlobals.41
	movt	r0, :upper16:.L_MergedGlobals.41
	ldrb	r0, [r0, #14]
	cmp	r0, #0
	it	ne
	strne.w	r9, [r4, r10]
.LBB5_212:                              @   in Loop: Header=BB5_209 Depth=2
	adds	r6, #1
	cmp	r6, #64
	bne	.LBB5_209
.LBB5_213:                              @   in Loop: Header=BB5_209 Depth=2
	bl	process_spi_commands
	movw	r0, :lower16:.L_MergedGlobals.41
	movt	r0, :upper16:.L_MergedGlobals.41
	ldrb	r0, [r0, #14]
	cmp	r0, #0
	it	ne
	strne.w	r9, [r4, r10]
	ldr.w	r0, [r11, #12]
	lsls	r0, r0, #28
	bmi	.LBB5_216
@ %bb.214:                              @   in Loop: Header=BB5_209 Depth=2
	mov.w	r1, #32768
	mov	r0, r5
	bl	HAL_GPIO_ReadPin
	cmp	r0, #1
	beq	.LBB5_216
@ %bb.215:                              @   in Loop: Header=BB5_209 Depth=2
	bl	HAL_GetTick
	ldr	r1, [sp, #40]                   @ 4-byte Reload
	movs	r6, #0
	subs	r0, r0, r1
	movw	r1, #3001
	cmp	r0, r1
	blo	.LBB5_209
.LBB5_216:                              @   in Loop: Header=BB5_165 Depth=1
	movw	r0, :lower16:hspi3
	movt	r0, :upper16:hspi3
	ldr	r0, [r0]
	ldr	r1, [r0]
	bic	r1, r1, #1
	str	r1, [r0]
	movs	r1, #16
	ldr.w	r0, [r11]
	movt	r1, #16386
	bic	r0, r0, #32768
	str.w	r0, [r11]
	ldr	r0, [r1, #120]
	bic	r0, r0, #1
	str	r0, [r1, #120]
	mov.w	r0, #3904
	str	r0, [r1, #-4]
	movw	r0, #2168
	str.w	r0, [r11, #16]
	b	.LBB5_164
	.p2align	2
.LBB5_217:                              @   in Loop: Header=BB5_165 Depth=1
	movw	r0, :lower16:.L_MergedGlobals.41
	movs	r1, #2
	movt	r0, :upper16:.L_MergedGlobals.41
	ldr	r0, [r0, #44]
	str	r0, [sp, #36]                   @ 4-byte Spill
	mov	r0, r4
	bl	HAL_GPIO_TogglePin
	b	.LBB5_165
	.p2align	2
@ %bb.218:
.LCPI5_17:
.L.str.3:
	.asciz	"HELLO SSB-IQ-TUNER v8\n\000"
.LCPI5_18:
.L.str.4:
	.asciz	"USART2 cmd: STAT/HELP SIDE TX (send HELP to list)\n\000"
.Lfunc_end5:
	.size	main, .Lfunc_end5-main
	.cfi_endproc
	.cantunwind
	.fnend
                                        @ -- End function
	.section	.text.SystemClock_Config,"ax",%progbits
	.hidden	SystemClock_Config              @ -- Begin function SystemClock_Config
	.globl	SystemClock_Config
	.p2align	3
	.type	SystemClock_Config,%function
	.code	16                              @ @SystemClock_Config
	.thumb_func
SystemClock_Config:
	.fnstart
	.cfi_startproc
@ %bb.0:
	.save	{r4, r5, r7, lr}
	push	{r4, r5, r7, lr}
	.cfi_def_cfa_offset 16
	.cfi_offset lr, -4
	.cfi_offset r7, -8
	.cfi_offset r5, -12
	.cfi_offset r4, -16
	.pad	#112
	sub	sp, #112
	.cfi_def_cfa_offset 128
	movw	r4, #18456
	add	r0, sp, #36
	movs	r1, #76
	movt	r4, #22530
	bl	__aeabi_memclr4
	movs	r0, #2
	movs	r5, #0
	strd	r5, r5, [sp, #28]
	strd	r5, r5, [sp, #20]
	strd	r5, r5, [sp, #12]
	strd	r5, r5, [sp, #4]
	bl	HAL_PWREx_ConfigSupply
	str	r5, [sp]
	ldr	r0, [r4]
	orr	r0, r0, #49152
	str	r0, [r4]
	ldr	r0, [r4]
	and	r0, r0, #49152
	str	r0, [sp]
	movw	r0, #1068
	movt	r0, #22528
	ldr	r1, [r0]
	orr	r1, r1, #1
	str	r1, [r0]
	ldr	r0, [r0]
	and	r0, r0, #1
	str	r0, [sp]
	ldr	r0, [sp]
.LBB6_1:                                @ =>This Inner Loop Header: Depth=1
	ldr	r0, [r4]
	lsls	r0, r0, #18
	bmi	.LBB6_4
@ %bb.2:                                @   in Loop: Header=BB6_1 Depth=1
	ldr	r0, [r4]
	lsls	r0, r0, #18
	itt	pl
	ldrpl	r0, [r4]
	lslspl.w	r0, r0, #18
	bmi	.LBB6_4
@ %bb.3:                                @   in Loop: Header=BB6_1 Depth=1
	ldr	r0, [r4]
	lsls	r0, r0, #18
	bpl	.LBB6_1
.LBB6_4:
	movs	r0, #1
	str	r0, [sp, #36]
	mov.w	r0, #65536
	str	r0, [sp, #40]
	movs	r0, #2
	movs	r1, #5
	strd	r0, r0, [sp, #72]
	str	r1, [sp, #80]
	movs	r1, #192
	strd	r1, r0, [sp, #84]
	strd	r0, r0, [sp, #92]
	add	r0, sp, #36
	bl	HAL_RCC_OscConfig
	cbz	r0, .LBB6_7
@ %bb.5:
	movw	r4, #2048
	movt	r4, #22530
	.p2align	2
.LBB6_6:                                @ =>This Inner Loop Header: Depth=1
	movs	r1, #2
	mov	r0, r4
	bl	HAL_GPIO_TogglePin
	movs	r0, #50
	bl	HAL_Delay
	b	.LBB6_6
	.p2align	2
.LBB6_7:
	movs	r0, #63
	str	r0, [sp, #4]
	movs	r0, #3
	str	r0, [sp, #8]
	movs	r0, #0
	str	r0, [sp, #12]
	movs	r1, #8
	str	r1, [sp, #16]
	movs	r1, #64
	strd	r1, r0, [sp, #20]
	mov.w	r0, #1024
	strd	r0, r1, [sp, #28]
	add	r0, sp, #4
	movs	r1, #4
	bl	HAL_RCC_ClockConfig
	cbz	r0, .LBB6_10
@ %bb.8:
	movw	r4, #2048
	movt	r4, #22530
	.p2align	2
.LBB6_9:                                @ =>This Inner Loop Header: Depth=1
	movs	r1, #2
	mov	r0, r4
	bl	HAL_GPIO_TogglePin
	movs	r0, #50
	bl	HAL_Delay
	b	.LBB6_9
	.p2align	2
.LBB6_10:
	add	sp, #112
	pop	{r4, r5, r7, pc}
.Lfunc_end6:
	.size	SystemClock_Config, .Lfunc_end6-SystemClock_Config
	.cfi_endproc
	.cantunwind
	.fnend
                                        @ -- End function
	.section	.text.apply_cfg,"ax",%progbits
	.p2align	3                               @ -- Begin function apply_cfg
	.type	apply_cfg,%function
	.code	16                              @ @apply_cfg
	.thumb_func
apply_cfg:
	.fnstart
	.cfi_startproc
@ %bb.0:
	.save	{r4, lr}
	push	{r4, lr}
	.cfi_def_cfa_offset 8
	.cfi_offset lr, -4
	.cfi_offset r4, -8
	movw	r12, :lower16:.L_MergedGlobals
	ldr	r1, [r0]
	movt	r12, :upper16:.L_MergedGlobals
	str.w	r1, [r12, #8]
	ldr	r1, [r0, #4]
	str.w	r1, [r12, #12]
	movw	r1, :lower16:.L_MergedGlobals.41
	ldr	r2, [r0, #8]
	movt	r1, :upper16:.L_MergedGlobals.41
	str	r2, [r1, #56]
	ldrh	r2, [r0, #12]
	strh	r2, [r1, #26]
	ldrh	r2, [r0, #14]
	strh	r2, [r1, #28]
	ldrh	r2, [r0, #16]
	strh	r2, [r1, #30]
	ldr	r0, [r0, #20]
	str.w	r0, [r12, #16]
	ldrb.w	r2, [r12]
	movs	r0, #0
	cmp	r2, #4
	bhi	.LBB7_6
@ %bb.1:
	mov.w	lr, #0
.LCPI7_0:
	tbb	[pc, r2]
@ %bb.2:
.LJTI7_0:
	.byte	(.LBB7_3-(.LCPI7_0+4))/2
	.byte	(.LBB7_7-(.LCPI7_0+4))/2
	.byte	(.LBB7_5-(.LCPI7_0+4))/2
	.byte	(.LBB7_4-(.LCPI7_0+4))/2
	.byte	(.LBB7_3-(.LCPI7_0+4))/2
	.p2align	1
	.p2align	2
.LBB7_3:
	ldrsh.w	r0, [r1, #36]
.LBB7_4:
	ldrsh.w	lr, [r1, #38]
	b	.LBB7_7
	.p2align	2
.LBB7_5:
	ldrsh.w	r0, [r1, #36]
	b	.LBB7_7
	.p2align	2
.LBB7_6:
	mov.w	lr, #0
.LBB7_7:
	ldrsh.w	r2, [r1, #28]
	ldr.w	r3, [r12, #8]
	add	r2, r0
	ssat	r2, #16, r2
	muls	r2, r3, r2
	movw	r3, :lower16:.L_MergedGlobals.42
	movt	r3, :upper16:.L_MergedGlobals.42
	asrs	r2, r2, #15
	str	r2, [r3, #28]
	ldrsh.w	r2, [r1, #30]
	ldrsh.w	r4, [r1, #26]
	muls	r0, r4, r0
	add	r2, lr
	add.w	r0, r2, r0, asr #15
	ldr.w	r2, [r12, #12]
	ssat	r0, #16, r0
	muls	r0, r2, r0
	mov.w	r2, #2000
	asrs	r0, r0, #15
	str	r0, [r3, #32]
	ldr	r0, [r3, #28]
	muls	r0, r2, r0
	asrs	r0, r0, #15
	str	r0, [r1, #68]
	ldr	r0, [r3, #32]
	muls	r0, r2, r0
	asrs	r0, r0, #15
	str	r0, [r1, #72]
	ldrb	r0, [r1, #10]
	cmp	r0, #0
	it	eq
	popeq	{r4, pc}
.LBB7_8:
	ldr	r0, [r1, #72]
	rsbs	r0, r0, #0
	str	r0, [r1, #72]
	pop	{r4, pc}
.Lfunc_end7:
	.size	apply_cfg, .Lfunc_end7-apply_cfg
	.cfi_endproc
	.cantunwind
	.fnend
                                        @ -- End function
	.section	.text.process_spi_commands,"ax",%progbits
	.p2align	3                               @ -- Begin function process_spi_commands
	.type	process_spi_commands,%function
	.code	16                              @ @process_spi_commands
	.thumb_func
process_spi_commands:
	.fnstart
	.cfi_startproc
@ %bb.0:
	.save	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	push.w	{r4, r5, r6, r7, r8, r9, r10, r11, lr}
	.cfi_def_cfa_offset 36
	.cfi_offset lr, -4
	.cfi_offset r11, -8
	.cfi_offset r10, -12
	.cfi_offset r9, -16
	.cfi_offset r8, -20
	.cfi_offset r7, -24
	.cfi_offset r6, -28
	.cfi_offset r5, -32
	.cfi_offset r4, -36
	.pad	#4
	sub	sp, #4
	.cfi_def_cfa_offset 40
	.vsave	{d8, d9, d10}
	vpush	{d8, d9, d10}
	.cfi_def_cfa_offset 64
	.cfi_offset d10, -48
	.cfi_offset d9, -56
	.cfi_offset d8, -64
	.pad	#64
	sub	sp, #64
	.cfi_def_cfa_offset 128
	movw	r9, :lower16:.L_MergedGlobals.41
	@APP
	cpsid i
	@NO_APP
	movt	r9, :upper16:.L_MergedGlobals.41
	ldrb.w	r0, [r9, #7]
	ldrb.w	r1, [r9, #6]
	cmp	r0, r1
	bne	.LBB8_2
.LBB8_1:
	@APP
	cpsie i
	@NO_APP
	add	sp, #64
	vpop	{d8, d9, d10}
	add	sp, #4
	pop.w	{r4, r5, r6, r7, r8, r9, r10, r11, pc}
	.p2align	2
.LBB8_2:
	add	r4, sp, #4
	vldr	s18, __arm_cp.8_26
	vldr	s16, __arm_cp.8_27
	movs	r5, #0
	vldr	s20, __arm_cp.8_28
	adds	r0, r4, #2
	str	r0, [sp]                        @ 4-byte Spill
	b	.LBB8_5
	.p2align	2
.LBB8_3:                                @   in Loop: Header=BB8_5 Depth=1
	movw	r2, #32320
	bic.w	r7, r10, r10, asr #31
	movt	r2, #5
	movs	r0, #0
	cmp	r7, r2
	mov.w	r3, #0
	it	ge
	movge	r7, r2
	mov	r1, r7
	bl	__aeabi_uldivmod
	str.w	r0, [r9, #56]
	movw	r2, :lower16:.L_MergedGlobals.43
	ldr.w	r0, [r9, #56]
	movt	r2, :upper16:.L_MergedGlobals.43
	ldrb.w	r1, [r9, #10]
	cmp	r1, #0
	mov.w	r1, #32
	it	eq
	moveq	r1, #8
	str	r0, [r2, r1]
	movs	r0, #1
	strb.w	r0, [r9, #16]
	movs	r0, #3
	strb.w	r0, [r9, #17]
	movw	r0, :lower16:.L_MergedGlobals.42
	movt	r0, :upper16:.L_MergedGlobals.42
	str	r7, [r0, #36]
	.p2align	2
.LBB8_4:                                @   in Loop: Header=BB8_5 Depth=1
	@APP
	cpsid i
	@NO_APP
	movs	r5, #0
	ldrb.w	r0, [r9, #7]
	ldrb.w	r1, [r9, #6]
	cmp	r0, r1
	beq	.LBB8_1
.LBB8_5:                                @ =>This Loop Header: Depth=1
                                        @     Child Loop BB8_7 Depth 2
                                        @     Child Loop BB8_53 Depth 2
                                        @     Child Loop BB8_65 Depth 2
                                        @     Child Loop BB8_77 Depth 2
                                        @     Child Loop BB8_90 Depth 2
	ldrb.w	r0, [r9, #7]
	movw	r1, :lower16:cmd_line_queue
	movt	r1, :upper16:cmd_line_queue
	movs	r2, #48
	add.w	r0, r0, r0, lsl #1
	add.w	r1, r1, r0, lsl #4
	mov	r0, r4
	bl	__aeabi_memcpy
	ldrb.w	r0, [r9, #7]
	movs	r3, #0
	adds	r0, #1
	and	r0, r0, #7
	strb.w	r0, [r9, #7]
	@APP
	cpsie i
	@NO_APP
	str	r5, [sp, #60]
	strd	r5, r5, [sp, #52]
	b	.LBB8_7
	.p2align	2
.LBB8_6:                                @   in Loop: Header=BB8_7 Depth=2
	adds	r3, #4
.LBB8_7:                                @   Parent Loop BB8_5 Depth=1
                                        @ =>  This Inner Loop Header: Depth=2
	ldrb	r2, [r4, r3]
	cmp	r2, #32
	beq	.LBB8_9
@ %bb.8:                                @   in Loop: Header=BB8_7 Depth=2
	cmp	r2, #9
	bne	.LBB8_17
.LBB8_9:                                @   in Loop: Header=BB8_7 Depth=2
	adds	r0, r4, r3
	ldrb	r2, [r0, #1]
	cmp	r2, #32
	beq	.LBB8_11
@ %bb.10:                               @   in Loop: Header=BB8_7 Depth=2
	cmp	r2, #9
	bne	.LBB8_16
.LBB8_11:                               @   in Loop: Header=BB8_7 Depth=2
	ldrb	r2, [r0, #2]
	cmp	r2, #32
	beq	.LBB8_13
@ %bb.12:                               @   in Loop: Header=BB8_7 Depth=2
	cmp	r2, #9
	bne	.LBB8_19
.LBB8_13:                               @   in Loop: Header=BB8_7 Depth=2
	ldrb	r2, [r0, #3]
	cmp	r2, #32
	beq	.LBB8_6
@ %bb.14:                               @   in Loop: Header=BB8_7 Depth=2
	cmp	r2, #9
	beq	.LBB8_6
@ %bb.15:                               @   in Loop: Header=BB8_5 Depth=1
	adds	r3, #3
	orr	r0, r2, #32
	cmp	r0, #32
	beq	.LBB8_18
	b	.LBB8_20
	.p2align	2
.LBB8_16:                               @   in Loop: Header=BB8_5 Depth=1
	adds	r3, #1
.LBB8_17:                               @   in Loop: Header=BB8_5 Depth=1
	orr	r0, r2, #32
	cmp	r0, #32
	bne	.LBB8_20
.LBB8_18:                               @   in Loop: Header=BB8_5 Depth=1
	mov.w	r12, #1
	mov	r0, r3
	b	.LBB8_53
	.p2align	2
.LBB8_19:                               @   in Loop: Header=BB8_5 Depth=1
	adds	r3, #2
	orr	r0, r2, #32
	cmp	r0, #32
	beq	.LBB8_18
.LBB8_20:                               @   in Loop: Header=BB8_5 Depth=1
	sub.w	r0, r2, #97
	mov.w	r12, #0
	uxtb	r0, r0
	cmp	r0, #26
	add.w	r0, r3, #1
	it	lo
	sublo	r2, #32
	strb.w	r2, [sp, #52]
	ldrb	r2, [r4, r0]
	cmp	r2, #0
	beq.w	.LBB8_53
@ %bb.21:                               @   in Loop: Header=BB8_5 Depth=1
	cmp	r2, #9
	beq.w	.LBB8_51
@ %bb.22:                               @   in Loop: Header=BB8_5 Depth=1
	cmp	r2, #32
	beq.w	.LBB8_53
@ %bb.23:                               @   in Loop: Header=BB8_5 Depth=1
	sub.w	r0, r2, #97
	uxtb	r0, r0
	cmp	r0, #26
	add.w	r0, r3, #2
	it	lo
	sublo	r2, #32
	strb.w	r2, [sp, #53]
	ldrb	r2, [r4, r0]
	cmp	r2, #0
	beq.w	.LBB8_53
@ %bb.24:                               @   in Loop: Header=BB8_5 Depth=1
	cmp	r2, #9
	beq.w	.LBB8_51
@ %bb.25:                               @   in Loop: Header=BB8_5 Depth=1
	cmp	r2, #32
	beq.w	.LBB8_53
@ %bb.26:                               @   in Loop: Header=BB8_5 Depth=1
	sub.w	r0, r2, #97
	uxtb	r0, r0
	cmp	r0, #26
	add.w	r0, r3, #3
	it	lo
	sublo	r2, #32
	strb.w	r2, [sp, #54]
	ldrb	r2, [r4, r0]
	cmp	r2, #0
	beq.w	.LBB8_53
@ %bb.27:                               @   in Loop: Header=BB8_5 Depth=1
	cmp	r2, #9
	beq.w	.LBB8_51
@ %bb.28:                               @   in Loop: Header=BB8_5 Depth=1
	cmp	r2, #32
	beq.w	.LBB8_53
@ %bb.29:                               @   in Loop: Header=BB8_5 Depth=1
	sub.w	r0, r2, #97
	uxtb	r0, r0
	cmp	r0, #26
	add.w	r0, r3, #4
	it	lo
	sublo	r2, #32
	strb.w	r2, [sp, #55]
	ldrb	r2, [r4, r0]
	cmp	r2, #0
	beq	.LBB8_53
@ %bb.30:                               @   in Loop: Header=BB8_5 Depth=1
	cmp	r2, #9
	beq	.LBB8_51
@ %bb.31:                               @   in Loop: Header=BB8_5 Depth=1
	cmp	r2, #32
	beq	.LBB8_53
@ %bb.32:                               @   in Loop: Header=BB8_5 Depth=1
	sub.w	r0, r2, #97
	uxtb	r0, r0
	cmp	r0, #26
	add.w	r0, r3, #5
	it	lo
	sublo	r2, #32
	strb.w	r2, [sp, #56]
	ldrb	r2, [r4, r0]
	cmp	r2, #0
	beq	.LBB8_53
@ %bb.33:                               @   in Loop: Header=BB8_5 Depth=1
	cmp	r2, #9
	beq	.LBB8_51
@ %bb.34:                               @   in Loop: Header=BB8_5 Depth=1
	cmp	r2, #32
	beq	.LBB8_53
@ %bb.35:                               @   in Loop: Header=BB8_5 Depth=1
	sub.w	r0, r2, #97
	uxtb	r0, r0
	cmp	r0, #26
	add.w	r0, r3, #6
	it	lo
	sublo	r2, #32
	strb.w	r2, [sp, #57]
	ldrb	r2, [r4, r0]
	cmp	r2, #0
	beq	.LBB8_53
@ %bb.36:                               @   in Loop: Header=BB8_5 Depth=1
	cmp	r2, #9
	beq	.LBB8_51
@ %bb.37:                               @   in Loop: Header=BB8_5 Depth=1
	cmp	r2, #32
	beq	.LBB8_53
@ %bb.38:                               @   in Loop: Header=BB8_5 Depth=1
	sub.w	r0, r2, #97
	uxtb	r0, r0
	cmp	r0, #26
	add.w	r0, r3, #7
	it	lo
	sublo	r2, #32
	strb.w	r2, [sp, #58]
	ldrb	r2, [r4, r0]
	cmp	r2, #0
	beq	.LBB8_53
@ %bb.39:                               @   in Loop: Header=BB8_5 Depth=1
	cmp	r2, #9
	beq	.LBB8_51
@ %bb.40:                               @   in Loop: Header=BB8_5 Depth=1
	cmp	r2, #32
	beq	.LBB8_53
@ %bb.41:                               @   in Loop: Header=BB8_5 Depth=1
	sub.w	r0, r2, #97
	uxtb	r0, r0
	cmp	r0, #26
	add.w	r0, r3, #8
	it	lo
	sublo	r2, #32
	strb.w	r2, [sp, #59]
	ldrb	r2, [r4, r0]
	cbz	r2, .LBB8_53
@ %bb.42:                               @   in Loop: Header=BB8_5 Depth=1
	cmp	r2, #9
	beq	.LBB8_51
@ %bb.43:                               @   in Loop: Header=BB8_5 Depth=1
	cmp	r2, #32
	beq	.LBB8_53
@ %bb.44:                               @   in Loop: Header=BB8_5 Depth=1
	sub.w	r0, r2, #97
	uxtb	r0, r0
	cmp	r0, #26
	add.w	r0, r3, #9
	it	lo
	sublo	r2, #32
	strb.w	r2, [sp, #60]
	ldrb	r2, [r4, r0]
	cbz	r2, .LBB8_53
@ %bb.45:                               @   in Loop: Header=BB8_5 Depth=1
	cmp	r2, #9
	beq	.LBB8_51
@ %bb.46:                               @   in Loop: Header=BB8_5 Depth=1
	cmp	r2, #32
	beq	.LBB8_53
@ %bb.47:                               @   in Loop: Header=BB8_5 Depth=1
	sub.w	r0, r2, #97
	uxtb	r0, r0
	cmp	r0, #26
	add.w	r0, r3, #10
	it	lo
	sublo	r2, #32
	strb.w	r2, [sp, #61]
	ldrb	r2, [r4, r0]
	cbz	r2, .LBB8_53
@ %bb.48:                               @   in Loop: Header=BB8_5 Depth=1
	cmp	r2, #9
	beq	.LBB8_51
@ %bb.49:                               @   in Loop: Header=BB8_5 Depth=1
	cmp	r2, #32
	beq	.LBB8_53
@ %bb.50:                               @   in Loop: Header=BB8_5 Depth=1
	sub.w	r0, r2, #97
	uxtb	r0, r0
	cmp	r0, #26
	add.w	r0, r3, #11
	it	lo
	sublo	r2, #32
	strb.w	r2, [sp, #62]
	ldrb	r2, [r4, r0]
	b	.LBB8_53
	.p2align	2
.LBB8_51:                               @   in Loop: Header=BB8_5 Depth=1
	movs	r2, #9
	b	.LBB8_53
	.p2align	2
.LBB8_52:                               @   in Loop: Header=BB8_53 Depth=2
	ldrb	r2, [r3, #4]
	adds	r0, #4
.LBB8_53:                               @   Parent Loop BB8_5 Depth=1
                                        @ =>  This Inner Loop Header: Depth=2
	uxtb	r3, r2
	cmp	r3, #32
	beq	.LBB8_55
@ %bb.54:                               @   in Loop: Header=BB8_53 Depth=2
	cmp	r3, #9
	bne	.LBB8_64
.LBB8_55:                               @   in Loop: Header=BB8_53 Depth=2
	adds	r3, r4, r0
	ldrb	r2, [r3, #1]
	cmp	r2, #32
	beq	.LBB8_57
@ %bb.56:                               @   in Loop: Header=BB8_53 Depth=2
	cmp	r2, #9
	bne	.LBB8_62
.LBB8_57:                               @   in Loop: Header=BB8_53 Depth=2
	ldrb	r2, [r3, #2]
	cmp	r2, #32
	beq	.LBB8_59
@ %bb.58:                               @   in Loop: Header=BB8_53 Depth=2
	cmp	r2, #9
	bne	.LBB8_63
.LBB8_59:                               @   in Loop: Header=BB8_53 Depth=2
	ldrb	r2, [r3, #3]
	cmp	r2, #32
	beq	.LBB8_52
@ %bb.60:                               @   in Loop: Header=BB8_53 Depth=2
	cmp	r2, #9
	beq	.LBB8_52
@ %bb.61:                               @   in Loop: Header=BB8_5 Depth=1
	adds	r0, #3
	b	.LBB8_64
	.p2align	2
.LBB8_62:                               @   in Loop: Header=BB8_5 Depth=1
	adds	r0, #1
	b	.LBB8_64
	.p2align	2
.LBB8_63:                               @   in Loop: Header=BB8_5 Depth=1
	adds	r0, #2
.LBB8_64:                               @   in Loop: Header=BB8_5 Depth=1
	uxtb	r2, r2
	mov.w	r11, #0
	cmp	r2, #45
	it	eq
	addeq	r0, #1
	ldrb	r7, [r4, r0]
	sub.w	r3, r7, #48
	cmp	r3, #9
	bhi	.LBB8_72
	.p2align	2
.LBB8_65:                               @   Parent Loop BB8_5 Depth=1
                                        @ =>  This Inner Loop Header: Depth=2
	adds	r3, r4, r0
	add.w	r6, r11, r11, lsl #2
	ldrb	r5, [r3, #1]
	add.w	r7, r7, r6, lsl #1
	sub.w	r11, r7, #48
	sub.w	r1, r5, #48
	cmp	r1, #9
	bhi	.LBB8_69
@ %bb.66:                               @   in Loop: Header=BB8_65 Depth=2
	ldrb	r7, [r3, #2]
	add.w	r1, r11, r11, lsl #2
	sub.w	r6, r7, #48
	add.w	r1, r5, r1, lsl #1
	cmp	r6, #9
	sub.w	r11, r1, #48
	bhi	.LBB8_70
@ %bb.67:                               @   in Loop: Header=BB8_65 Depth=2
	ldrb	r5, [r3, #3]
	add.w	r1, r11, r11, lsl #2
	sub.w	r6, r5, #48
	add.w	r1, r7, r1, lsl #1
	cmp	r6, #9
	sub.w	r11, r1, #48
	bhi	.LBB8_71
@ %bb.68:                               @   in Loop: Header=BB8_65 Depth=2
	ldrb	r7, [r3, #4]
	add.w	r1, r11, r11, lsl #2
	adds	r0, #4
	sub.w	r3, r7, #48
	add.w	r1, r5, r1, lsl #1
	cmp	r3, #10
	sub.w	r11, r1, #48
	blo	.LBB8_65
	b	.LBB8_72
	.p2align	2
.LBB8_69:                               @   in Loop: Header=BB8_5 Depth=1
	adds	r0, #1
	b	.LBB8_72
	.p2align	2
.LBB8_70:                               @   in Loop: Header=BB8_5 Depth=1
	adds	r0, #2
	b	.LBB8_72
	.p2align	2
.LBB8_71:                               @   in Loop: Header=BB8_5 Depth=1
	adds	r0, #3
	.p2align	2
.LBB8_72:                               @   in Loop: Header=BB8_5 Depth=1
	add	r5, sp, #52
	b	.LBB8_77
	.p2align	2
@ %bb.73:
__arm_cp.8_26:
	.long	0x42c80000                      @ float 100
.Lcpi_end3:
	.size	__arm_cp.8_26, .Lcpi_end3-__arm_cp.8_26
	.p2align	2
@ %bb.74:
__arm_cp.8_27:
	.long	0x44fa0000                      @ float 2000
.Lcpi_end4:
	.size	__arm_cp.8_27, .Lcpi_end4-__arm_cp.8_27
	.p2align	2
@ %bb.75:
__arm_cp.8_28:
	.long	0x3c23d70a                      @ float 0.00999999977
.Lcpi_end5:
	.size	__arm_cp.8_28, .Lcpi_end5-__arm_cp.8_28
	.p2align	2
.LBB8_76:                               @   in Loop: Header=BB8_77 Depth=2
	adds	r0, #4
.LBB8_77:                               @   Parent Loop BB8_5 Depth=1
                                        @ =>  This Inner Loop Header: Depth=2
	ldrb	r3, [r4, r0]
	cmp	r3, #32
	beq	.LBB8_79
@ %bb.78:                               @   in Loop: Header=BB8_77 Depth=2
	cmp	r3, #9
	bne	.LBB8_88
.LBB8_79:                               @   in Loop: Header=BB8_77 Depth=2
	adds	r7, r4, r0
	ldrb	r3, [r7, #1]
	cmp	r3, #32
	beq	.LBB8_81
@ %bb.80:                               @   in Loop: Header=BB8_77 Depth=2
	cmp	r3, #9
	bne	.LBB8_86
.LBB8_81:                               @   in Loop: Header=BB8_77 Depth=2
	ldrb	r3, [r7, #2]
	cmp	r3, #32
	beq	.LBB8_83
@ %bb.82:                               @   in Loop: Header=BB8_77 Depth=2
	cmp	r3, #9
	bne	.LBB8_87
.LBB8_83:                               @   in Loop: Header=BB8_77 Depth=2
	ldrb	r3, [r7, #3]
	cmp	r3, #32
	beq	.LBB8_76
@ %bb.84:                               @   in Loop: Header=BB8_77 Depth=2
	cmp	r3, #9
	beq	.LBB8_76
@ %bb.85:                               @   in Loop: Header=BB8_5 Depth=1
	adds	r0, #3
	b	.LBB8_88
	.p2align	2
.LBB8_86:                               @   in Loop: Header=BB8_5 Depth=1
	adds	r0, #1
	b	.LBB8_88
	.p2align	2
.LBB8_87:                               @   in Loop: Header=BB8_5 Depth=1
	adds	r0, #2
.LBB8_88:                               @   in Loop: Header=BB8_5 Depth=1
	mov	r10, r11
	sub.w	r7, r3, #48
	cmp	r2, #45
	it	eq
	rsbeq.w	r10, r10, #0
	cmp	r7, #9
	bhi	.LBB8_94
@ %bb.89:                               @   in Loop: Header=BB8_5 Depth=1
	ldr	r1, [sp]                        @ 4-byte Reload
	mov.w	r8, #0
	add	r0, r1
	.p2align	2
.LBB8_90:                               @   Parent Loop BB8_5 Depth=1
                                        @ =>  This Inner Loop Header: Depth=2
	ldrb	r2, [r0, #-1]
	add.w	r1, r8, r8, lsl #2
	sub.w	r6, r2, #48
	add.w	r1, r3, r1, lsl #1
	cmp	r6, #9
	sub.w	r8, r1, #48
	bhi	.LBB8_95
@ %bb.91:                               @   in Loop: Header=BB8_90 Depth=2
	ldrb	r3, [r0]
	add.w	r1, r8, r8, lsl #2
	sub.w	r6, r3, #48
	add.w	r1, r2, r1, lsl #1
	cmp	r6, #9
	sub.w	r8, r1, #48
	bhi	.LBB8_95
@ %bb.92:                               @   in Loop: Header=BB8_90 Depth=2
	ldrb	r2, [r0, #1]
	add.w	r1, r8, r8, lsl #2
	sub.w	r6, r2, #48
	add.w	r1, r3, r1, lsl #1
	cmp	r6, #9
	sub.w	r8, r1, #48
	bhi	.LBB8_95
@ %bb.93:                               @   in Loop: Header=BB8_90 Depth=2
	ldrb	r3, [r0, #2]
	add.w	r1, r8, r8, lsl #2
	adds	r0, #4
	sub.w	r6, r3, #48
	add.w	r1, r2, r1, lsl #1
	cmp	r6, #10
	sub.w	r8, r1, #48
	blo	.LBB8_90
	b	.LBB8_95
	.p2align	2
.LBB8_94:                               @   in Loop: Header=BB8_5 Depth=1
	mov.w	r8, #0
.LBB8_95:                               @   in Loop: Header=BB8_5 Depth=1
	cmp.w	r12, #0
	bne.w	.LBB8_4
@ %bb.96:                               @   in Loop: Header=BB8_5 Depth=1
	movs	r2, #6
	mov	r0, r5
	adr.w	r1, .LCPI8_0
	bl	memcmp
	cmp	r0, #0
	beq.w	.LBB8_126
@ %bb.97:                               @   in Loop: Header=BB8_5 Depth=1
	movs	r2, #6
	mov	r0, r5
	adr.w	r1, .LCPI8_1
	bl	memcmp
	cmp	r0, #0
	beq.w	.LBB8_131
@ %bb.98:                               @   in Loop: Header=BB8_5 Depth=1
	movs	r2, #6
	mov	r0, r5
	adr.w	r1, .LCPI8_2
	bl	memcmp
	cmp	r0, #0
	beq.w	.LBB8_3
@ %bb.99:                               @   in Loop: Header=BB8_5 Depth=1
	movs	r2, #5
	mov	r0, r5
	adr.w	r1, .LCPI8_3
	bl	memcmp
	cmp	r0, #0
	beq.w	.LBB8_136
@ %bb.100:                              @   in Loop: Header=BB8_5 Depth=1
	movw	r1, #17481
	ldr	r0, [sp, #52]
	movt	r1, #67
	movw	r12, :lower16:.L_MergedGlobals
	movw	r6, :lower16:.L_MergedGlobals.42
	cmp	r0, r1
	movt	r12, :upper16:.L_MergedGlobals
	movt	r6, :upper16:.L_MergedGlobals.42
	beq.w	.LBB8_142
@ %bb.101:                              @   in Loop: Header=BB8_5 Depth=1
	movw	r1, #17489
	ldr	r0, [sp, #52]
	movt	r1, #67
	cmp	r0, r1
	beq.w	.LBB8_152
@ %bb.102:                              @   in Loop: Header=BB8_5 Depth=1
	movs	r2, #6
	mov	r0, r5
	adr.w	r1, .LCPI8_4
	bl	memcmp
	cmp	r0, #0
	beq.w	.LBB8_161
@ %bb.103:                              @   in Loop: Header=BB8_5 Depth=1
	movs	r2, #5
	mov	r0, r5
	adr.w	r1, .LCPI8_5
	bl	memcmp
	cmp	r0, #0
	beq.w	.LBB8_163
@ %bb.104:                              @   in Loop: Header=BB8_5 Depth=1
	movs	r2, #5
	mov	r0, r5
	adr.w	r1, .LCPI8_6
	bl	memcmp
	cmp	r0, #0
	beq.w	.LBB8_173
@ %bb.105:                              @   in Loop: Header=BB8_5 Depth=1
	movs	r2, #5
	mov	r0, r5
	adr.w	r1, .LCPI8_7
	bl	memcmp
	cmp	r0, #0
	beq.w	.LBB8_179
@ %bb.106:                              @   in Loop: Header=BB8_5 Depth=1
	movs	r2, #7
	mov	r0, r5
	adr.w	r1, .LCPI8_8
	bl	memcmp
	cmp	r0, #0
	beq.w	.LBB8_185
@ %bb.107:                              @   in Loop: Header=BB8_5 Depth=1
	movs	r2, #5
	mov	r0, r5
	adr.w	r1, .LCPI8_9
	bl	memcmp
	cmp	r0, #0
	beq.w	.LBB8_189
@ %bb.108:                              @   in Loop: Header=BB8_5 Depth=1
	movs	r2, #3
	mov	r0, r5
	adr.w	r1, .LCPI8_10
	bl	memcmp
	cmp	r0, #0
	beq.w	.LBB8_198
@ %bb.109:                              @   in Loop: Header=BB8_5 Depth=1
	movw	r1, #21584
	ldr	r0, [sp, #52]
	movt	r1, #84
	movs	r2, #1
	cmp	r0, r1
	beq.w	.LBB8_201
@ %bb.110:                              @   in Loop: Header=BB8_5 Depth=1
	movw	r1, #17478
	ldr	r0, [sp, #52]
	movt	r1, #88
	cmp	r0, r1
	beq.w	.LBB8_206
@ %bb.111:                              @   in Loop: Header=BB8_5 Depth=1
	movs	r2, #3
	mov	r0, r5
	adr.w	r1, .LCPI8_11
	bl	memcmp
	cmp	r0, #0
	beq.w	.LBB8_213
@ %bb.112:                              @   in Loop: Header=BB8_5 Depth=1
	movs	r2, #5
	mov	r0, r5
	adr.w	r1, .LCPI8_12
	bl	memcmp
	cmp	r0, #0
	beq.w	.LBB8_212
@ %bb.113:                              @   in Loop: Header=BB8_5 Depth=1
	movw	r1, #17735
	ldr	r0, [sp, #52]
	movt	r1, #84
	cmp	r0, r1
	beq.w	.LBB8_212
@ %bb.114:                              @   in Loop: Header=BB8_5 Depth=1
	movs	r2, #6
	mov	r0, r5
	adr.w	r1, .LCPI8_13
	bl	memcmp
	cmp	r0, #0
	beq.w	.LBB8_217
@ %bb.115:                              @   in Loop: Header=BB8_5 Depth=1
	movs	r2, #6
	mov	r0, r5
	adr.w	r1, .LCPI8_14
	bl	memcmp
	cmp	r0, #0
	beq.w	.LBB8_220
@ %bb.116:                              @   in Loop: Header=BB8_5 Depth=1
	movw	r1, #20552
	ldr	r0, [sp, #52]
	movt	r1, #70
	cmp	r0, r1
	beq.w	.LBB8_221
@ %bb.117:                              @   in Loop: Header=BB8_5 Depth=1
	movs	r2, #3
	mov	r0, r5
	adr.w	r1, .LCPI8_15
	bl	memcmp
	cmp	r0, #0
	beq.w	.LBB8_222
@ %bb.118:                              @   in Loop: Header=BB8_5 Depth=1
	movs	r2, #5
	mov	r0, r5
	adr.w	r1, .LCPI8_16
	bl	memcmp
	cmp	r0, #0
	beq.w	.LBB8_225
@ %bb.119:                              @   in Loop: Header=BB8_5 Depth=1
	ldrh.w	r0, [sp, #52]
	cmp	r0, #70
	beq.w	.LBB8_226
@ %bb.120:                              @   in Loop: Header=BB8_5 Depth=1
	ldrh.w	r0, [sp, #52]
	cmp	r0, #86
	beq.w	.LBB8_227
@ %bb.121:                              @   in Loop: Header=BB8_5 Depth=1
	ldrh.w	r0, [sp, #52]
	cmp	r0, #87
	beq.w	.LBB8_228
@ %bb.122:                              @   in Loop: Header=BB8_5 Depth=1
	ldrh.w	r0, [sp, #52]
	cmp	r0, #80
	beq.w	.LBB8_229
@ %bb.123:                              @   in Loop: Header=BB8_5 Depth=1
	ldrh.w	r0, [sp, #52]
	cmp	r0, #83
	beq.w	.LBB8_230
@ %bb.124:                              @   in Loop: Header=BB8_5 Depth=1
	ldrh.w	r0, [sp, #52]
	cmp	r0, #73
	beq.w	.LBB8_231
@ %bb.125:                              @   in Loop: Header=BB8_5 Depth=1
	movw	r5, :lower16:.L_MergedGlobals.42
	movs	r0, #4
	movt	r5, :upper16:.L_MergedGlobals.42
	strb.w	r0, [r9, #16]
	add.w	r0, r5, #80
	movs	r2, #11
	add	r1, sp, #52
	movs	r6, #0
	strb.w	r6, [r9, #17]
	bl	strncpy
	strb.w	r6, [r5, #91]
	b	.LBB8_4
	.p2align	2
.LBB8_126:                              @   in Loop: Header=BB8_5 Depth=1
	usat	r0, #16, r10
	movw	r6, :lower16:.L_MergedGlobals
	movt	r6, :upper16:.L_MergedGlobals
	movw	r2, :lower16:.L_MergedGlobals.43
	movt	r2, :upper16:.L_MergedGlobals.43
	str	r0, [r6, #8]
	ldr	r1, [r6, #8]
	ldrb.w	r0, [r9, #10]
	cmp	r0, #0
	it	ne
	addne	r2, #24
	str	r1, [r2]
	movs	r1, #0
	ldrb	r3, [r6]
	cmp	r3, #4
	bhi.w	.LBB8_148
@ %bb.127:                              @   in Loop: Header=BB8_5 Depth=1
	movw	r5, :lower16:.L_MergedGlobals.42
	movs	r2, #0
	movt	r5, :upper16:.L_MergedGlobals.42
.LCPI8_20:
	tbb	[pc, r3]
@ %bb.128:
.LJTI8_5:
	.byte	(.LBB8_129-(.LCPI8_20+4))/2
	.byte	(.LBB8_149-(.LCPI8_20+4))/2
	.byte	(.LBB8_141-(.LCPI8_20+4))/2
	.byte	(.LBB8_130-(.LCPI8_20+4))/2
	.byte	(.LBB8_129-(.LCPI8_20+4))/2
	.p2align	1
	.p2align	2
.LBB8_129:                              @   in Loop: Header=BB8_5 Depth=1
	ldrsh.w	r1, [r9, #36]
.LBB8_130:                              @   in Loop: Header=BB8_5 Depth=1
	ldrsh.w	r2, [r9, #38]
	b	.LBB8_149
	.p2align	2
.LBB8_131:                              @   in Loop: Header=BB8_5 Depth=1
	usat	r0, #16, r10
	movw	r6, :lower16:.L_MergedGlobals
	movt	r6, :upper16:.L_MergedGlobals
	movs	r2, #28
	movw	r3, :lower16:.L_MergedGlobals.43
	str	r0, [r6, #12]
	movt	r3, :upper16:.L_MergedGlobals.43
	ldr	r1, [r6, #12]
	ldrb.w	r0, [r9, #10]
	cmp	r0, #0
	it	eq
	moveq	r2, #4
	str	r1, [r3, r2]
	movs	r1, #0
	ldrb	r3, [r6]
	cmp	r3, #4
	bhi.w	.LBB8_157
@ %bb.132:                              @   in Loop: Header=BB8_5 Depth=1
	movw	r5, :lower16:.L_MergedGlobals.42
	movs	r2, #0
	movt	r5, :upper16:.L_MergedGlobals.42
.LCPI8_21:
	tbh	[pc, r3, lsl #1]
@ %bb.133:
.LJTI8_4:
	.short	(.LBB8_134-(.LCPI8_21+4))/2
	.short	(.LBB8_158-(.LCPI8_21+4))/2
	.short	(.LBB8_147-(.LCPI8_21+4))/2
	.short	(.LBB8_135-(.LCPI8_21+4))/2
	.short	(.LBB8_134-(.LCPI8_21+4))/2
	.p2align	1
	.p2align	2
.LBB8_134:                              @   in Loop: Header=BB8_5 Depth=1
	ldrsh.w	r1, [r9, #36]
.LBB8_135:                              @   in Loop: Header=BB8_5 Depth=1
	ldrsh.w	r2, [r9, #38]
	b	.LBB8_158
	.p2align	2
.LBB8_136:                              @   in Loop: Header=BB8_5 Depth=1
	ssat	r0, #16, r10
	movs	r2, #36
	strh.w	r0, [r9, #26]
	movw	r3, :lower16:.L_MergedGlobals.43
	ldrh.w	r1, [r9, #26]
	movt	r3, :upper16:.L_MergedGlobals.43
	ldrb.w	r0, [r9, #10]
	movw	r6, :lower16:.L_MergedGlobals
	movt	r6, :upper16:.L_MergedGlobals
	movw	r5, :lower16:.L_MergedGlobals.42
	cmp	r0, #0
	movt	r5, :upper16:.L_MergedGlobals.42
	it	eq
	moveq	r2, #12
	strh	r1, [r3, r2]
	movs	r1, #0
	ldrb	r3, [r6]
	cmp	r3, #4
	bhi.w	.LBB8_169
@ %bb.137:                              @   in Loop: Header=BB8_5 Depth=1
	movs	r2, #0
.LCPI8_22:
	tbh	[pc, r3, lsl #1]
@ %bb.138:
.LJTI8_3:
	.short	(.LBB8_139-(.LCPI8_22+4))/2
	.short	(.LBB8_170-(.LCPI8_22+4))/2
	.short	(.LBB8_162-(.LCPI8_22+4))/2
	.short	(.LBB8_140-(.LCPI8_22+4))/2
	.short	(.LBB8_139-(.LCPI8_22+4))/2
	.p2align	1
	.p2align	2
.LBB8_139:                              @   in Loop: Header=BB8_5 Depth=1
	ldrsh.w	r1, [r9, #36]
.LBB8_140:                              @   in Loop: Header=BB8_5 Depth=1
	ldrsh.w	r2, [r9, #38]
	b	.LBB8_170
	.p2align	2
.LBB8_141:                              @   in Loop: Header=BB8_5 Depth=1
	ldrsh.w	r1, [r9, #36]
	b	.LBB8_149
	.p2align	2
.LBB8_142:                              @   in Loop: Header=BB8_5 Depth=1
	mov.w	r0, #1024
	cmp.w	r10, #1024
	it	ge
	movge	r10, r0
	movw	r0, #64512
	movs	r2, #38
	movt	r0, #65535
	cmn.w	r10, #1024
	it	le
	movle	r10, r0
	movw	r3, :lower16:.L_MergedGlobals.43
	strh.w	r10, [r9, #28]
	movt	r3, :upper16:.L_MergedGlobals.43
	ldrh.w	r1, [r9, #28]
	ldrb.w	r0, [r9, #10]
	cmp	r0, #0
	it	eq
	moveq	r2, #14
	strh	r1, [r3, r2]
	movs	r1, #0
	ldrb.w	r3, [r12]
	cmp	r3, #4
	bhi.w	.LBB8_175
@ %bb.143:                              @   in Loop: Header=BB8_5 Depth=1
	movs	r2, #0
.LCPI8_23:
	tbh	[pc, r3, lsl #1]
@ %bb.144:
.LJTI8_2:
	.short	(.LBB8_145-(.LCPI8_23+4))/2
	.short	(.LBB8_176-(.LCPI8_23+4))/2
	.short	(.LBB8_168-(.LCPI8_23+4))/2
	.short	(.LBB8_146-(.LCPI8_23+4))/2
	.short	(.LBB8_145-(.LCPI8_23+4))/2
	.p2align	1
	.p2align	2
.LBB8_145:                              @   in Loop: Header=BB8_5 Depth=1
	ldrsh.w	r1, [r9, #36]
.LBB8_146:                              @   in Loop: Header=BB8_5 Depth=1
	ldrsh.w	r2, [r9, #38]
	b	.LBB8_176
	.p2align	2
.LBB8_147:                              @   in Loop: Header=BB8_5 Depth=1
	ldrsh.w	r1, [r9, #36]
	b	.LBB8_158
	.p2align	2
.LBB8_148:                              @   in Loop: Header=BB8_5 Depth=1
	movw	r5, :lower16:.L_MergedGlobals.42
	movs	r2, #0
	movt	r5, :upper16:.L_MergedGlobals.42
.LBB8_149:                              @   in Loop: Header=BB8_5 Depth=1
	ldrsh.w	r3, [r9, #28]
	ldr	r7, [r6, #8]
	cmp	r0, #0
	add	r3, r1
	ssat	r3, #16, r3
	mul	r3, r7, r3
	asr.w	r3, r3, #15
	str	r3, [r5, #28]
	ldrsh.w	r3, [r9, #30]
	ldrsh.w	r7, [r9, #26]
	mul	r1, r7, r1
	add	r2, r3
	add.w	r1, r2, r1, asr #15
	ldr	r2, [r6, #12]
	ssat	r1, #16, r1
	mul	r1, r2, r1
	mov.w	r2, #2000
	asr.w	r1, r1, #15
	str	r1, [r5, #32]
	ldr	r1, [r5, #28]
	mul	r1, r2, r1
	asr.w	r1, r1, #15
	str.w	r1, [r9, #68]
	ldr	r1, [r5, #32]
	mul	r1, r2, r1
	asr.w	r0, r1, #15
	str.w	r0, [r9, #72]
	beq	.LBB8_151
@ %bb.150:                              @   in Loop: Header=BB8_5 Depth=1
	ldr.w	r0, [r9, #72]
	rsbs	r0, r0, #0
	str.w	r0, [r9, #72]
.LBB8_151:                              @   in Loop: Header=BB8_5 Depth=1
	movs	r0, #1
	strb.w	r0, [r9, #16]
	strb.w	r0, [r9, #17]
	ldr	r0, [r6, #8]
	str	r0, [r5, #36]
	b.w	.LBB8_4
	.p2align	2
.LBB8_152:                              @   in Loop: Header=BB8_5 Depth=1
	mov.w	r0, #1024
	cmp.w	r10, #1024
	it	ge
	movge	r10, r0
	movw	r0, #64512
	movs	r2, #40
	movt	r0, #65535
	cmn.w	r10, #1024
	it	le
	movle	r10, r0
	movw	r3, :lower16:.L_MergedGlobals.43
	strh.w	r10, [r9, #30]
	movt	r3, :upper16:.L_MergedGlobals.43
	ldrh.w	r1, [r9, #30]
	ldrb.w	r0, [r9, #10]
	cmp	r0, #0
	it	eq
	moveq	r2, #16
	strh	r1, [r3, r2]
	movs	r1, #0
	ldrb.w	r3, [r12]
	cmp	r3, #4
	bhi.w	.LBB8_181
@ %bb.153:                              @   in Loop: Header=BB8_5 Depth=1
	movs	r2, #0
.LCPI8_24:
	tbh	[pc, r3, lsl #1]
@ %bb.154:
.LJTI8_1:
	.short	(.LBB8_155-(.LCPI8_24+4))/2
	.short	(.LBB8_182-(.LCPI8_24+4))/2
	.short	(.LBB8_174-(.LCPI8_24+4))/2
	.short	(.LBB8_156-(.LCPI8_24+4))/2
	.short	(.LBB8_155-(.LCPI8_24+4))/2
	.p2align	1
	.p2align	2
.LBB8_155:                              @   in Loop: Header=BB8_5 Depth=1
	ldrsh.w	r1, [r9, #36]
.LBB8_156:                              @   in Loop: Header=BB8_5 Depth=1
	ldrsh.w	r2, [r9, #38]
	b	.LBB8_182
	.p2align	2
.LBB8_157:                              @   in Loop: Header=BB8_5 Depth=1
	movw	r5, :lower16:.L_MergedGlobals.42
	movs	r2, #0
	movt	r5, :upper16:.L_MergedGlobals.42
.LBB8_158:                              @   in Loop: Header=BB8_5 Depth=1
	ldrsh.w	r3, [r9, #28]
	ldr	r7, [r6, #8]
	cmp	r0, #0
	add	r3, r1
	ssat	r3, #16, r3
	mul	r3, r7, r3
	asr.w	r3, r3, #15
	str	r3, [r5, #28]
	ldrsh.w	r3, [r9, #30]
	ldrsh.w	r7, [r9, #26]
	mul	r1, r7, r1
	add	r2, r3
	add.w	r1, r2, r1, asr #15
	ldr	r2, [r6, #12]
	ssat	r1, #16, r1
	mul	r1, r2, r1
	mov.w	r2, #2000
	asr.w	r1, r1, #15
	str	r1, [r5, #32]
	ldr	r1, [r5, #28]
	mul	r1, r2, r1
	asr.w	r1, r1, #15
	str.w	r1, [r9, #68]
	ldr	r1, [r5, #32]
	mul	r1, r2, r1
	asr.w	r0, r1, #15
	str.w	r0, [r9, #72]
	beq	.LBB8_160
@ %bb.159:                              @   in Loop: Header=BB8_5 Depth=1
	ldr.w	r0, [r9, #72]
	rsbs	r0, r0, #0
	str.w	r0, [r9, #72]
.LBB8_160:                              @   in Loop: Header=BB8_5 Depth=1
	movs	r0, #1
	strb.w	r0, [r9, #16]
	movs	r0, #2
	strb.w	r0, [r9, #17]
	ldr	r0, [r6, #12]
	str	r0, [r5, #36]
	b.w	.LBB8_4
	.p2align	2
.LBB8_161:                              @   in Loop: Header=BB8_5 Depth=1
	mov.w	r0, #1024
	cmp.w	r10, #1024
	it	ge
	movge	r10, r0
	movw	r2, :lower16:.L_MergedGlobals
	movw	r3, :lower16:.L_MergedGlobals.43
	movt	r2, :upper16:.L_MergedGlobals
	movt	r3, :upper16:.L_MergedGlobals.43
	bic.w	r0, r10, r10, asr #31
	str	r0, [r2, #16]
	ldr	r0, [r2, #16]
	ldrb.w	r1, [r9, #10]
	cmp	r1, #0
	mov.w	r1, #44
	it	eq
	moveq	r1, #20
	str	r0, [r3, r1]
	movs	r0, #1
	strb.w	r0, [r9, #16]
	movs	r0, #7
	strb.w	r0, [r9, #17]
	ldr	r0, [r2, #16]
	b	.LBB8_180
	.p2align	2
.LBB8_162:                              @   in Loop: Header=BB8_5 Depth=1
	ldrsh.w	r1, [r9, #36]
	b	.LBB8_170
	.p2align	2
.LBB8_163:                              @   in Loop: Header=BB8_5 Depth=1
	movs	r0, #8
	cmp.w	r10, #8
	it	ge
	movge	r10, r0
	movw	r7, :lower16:.L_MergedGlobals
	movt	r7, :upper16:.L_MergedGlobals
	bic.w	r0, r10, r10, asr #31
	strb	r0, [r7]
	movs	r0, #0
	ldrb	r2, [r7]
	cmp	r2, #4
	bhi.w	.LBB8_192
@ %bb.164:                              @   in Loop: Header=BB8_5 Depth=1
	movw	r6, :lower16:.L_MergedGlobals.42
	movs	r1, #0
	movt	r6, :upper16:.L_MergedGlobals.42
.LCPI8_25:
	tbh	[pc, r2, lsl #1]
@ %bb.165:
.LJTI8_0:
	.short	(.LBB8_166-(.LCPI8_25+4))/2
	.short	(.LBB8_193-(.LCPI8_25+4))/2
	.short	(.LBB8_188-(.LCPI8_25+4))/2
	.short	(.LBB8_167-(.LCPI8_25+4))/2
	.short	(.LBB8_166-(.LCPI8_25+4))/2
	.p2align	1
	.p2align	2
.LBB8_166:                              @   in Loop: Header=BB8_5 Depth=1
	ldrsh.w	r0, [r9, #36]
.LBB8_167:                              @   in Loop: Header=BB8_5 Depth=1
	ldrsh.w	r1, [r9, #38]
	b	.LBB8_193
	.p2align	2
.LBB8_168:                              @   in Loop: Header=BB8_5 Depth=1
	ldrsh.w	r1, [r9, #36]
	b	.LBB8_176
	.p2align	2
.LBB8_169:                              @   in Loop: Header=BB8_5 Depth=1
	movs	r2, #0
.LBB8_170:                              @   in Loop: Header=BB8_5 Depth=1
	ldrsh.w	r3, [r9, #28]
	ldr	r7, [r6, #8]
	cmp	r0, #0
	add	r3, r1
	ssat	r3, #16, r3
	mul	r3, r7, r3
	asr.w	r3, r3, #15
	str	r3, [r5, #28]
	ldrsh.w	r3, [r9, #30]
	ldrsh.w	r7, [r9, #26]
	mul	r1, r7, r1
	add	r2, r3
	add.w	r1, r2, r1, asr #15
	ldr	r2, [r6, #12]
	ssat	r1, #16, r1
	mul	r1, r2, r1
	mov.w	r2, #2000
	asr.w	r1, r1, #15
	str	r1, [r5, #32]
	ldr	r1, [r5, #28]
	mul	r1, r2, r1
	asr.w	r1, r1, #15
	str.w	r1, [r9, #68]
	ldr	r1, [r5, #32]
	mul	r1, r2, r1
	asr.w	r0, r1, #15
	str.w	r0, [r9, #72]
	beq	.LBB8_172
@ %bb.171:                              @   in Loop: Header=BB8_5 Depth=1
	ldr.w	r0, [r9, #72]
	rsbs	r0, r0, #0
	str.w	r0, [r9, #72]
.LBB8_172:                              @   in Loop: Header=BB8_5 Depth=1
	movs	r0, #1
	strb.w	r0, [r9, #16]
	movs	r0, #4
	strb.w	r0, [r9, #17]
	ldrsh.w	r0, [r9, #26]
	str	r0, [r5, #36]
	b.w	.LBB8_4
	.p2align	2
.LBB8_173:                              @   in Loop: Header=BB8_5 Depth=1
	movw	r0, #61568
	movw	r1, :lower16:.L_MergedGlobals
	movt	r0, #762
	movt	r1, :upper16:.L_MergedGlobals
	cmp	r10, r0
	it	ge
	movge	r10, r0
	bic.w	r0, r10, r10, asr #31
	str	r0, [r1, #20]
	movs	r0, #1
	strb.w	r0, [r9, #16]
	movs	r0, #22
	strb.w	r0, [r9, #17]
	ldr	r0, [r1, #20]
	b	.LBB8_180
	.p2align	2
.LBB8_174:                              @   in Loop: Header=BB8_5 Depth=1
	ldrsh.w	r1, [r9, #36]
	b	.LBB8_182
	.p2align	2
.LBB8_175:                              @   in Loop: Header=BB8_5 Depth=1
	movs	r2, #0
.LBB8_176:                              @   in Loop: Header=BB8_5 Depth=1
	ldrsh.w	r3, [r9, #28]
	ldr.w	r7, [r12, #8]
	cmp	r0, #0
	add	r3, r1
	ssat	r3, #16, r3
	mul	r3, r7, r3
	asr.w	r3, r3, #15
	str	r3, [r6, #28]
	ldrsh.w	r3, [r9, #30]
	ldrsh.w	r7, [r9, #26]
	mul	r1, r7, r1
	add	r2, r3
	add.w	r1, r2, r1, asr #15
	ldr.w	r2, [r12, #12]
	ssat	r1, #16, r1
	mul	r1, r2, r1
	mov.w	r2, #2000
	asr.w	r1, r1, #15
	str	r1, [r6, #32]
	ldr	r1, [r6, #28]
	mul	r1, r2, r1
	asr.w	r1, r1, #15
	str.w	r1, [r9, #68]
	ldr	r1, [r6, #32]
	mul	r1, r2, r1
	asr.w	r0, r1, #15
	str.w	r0, [r9, #72]
	beq	.LBB8_178
@ %bb.177:                              @   in Loop: Header=BB8_5 Depth=1
	ldr.w	r0, [r9, #72]
	rsbs	r0, r0, #0
	str.w	r0, [r9, #72]
.LBB8_178:                              @   in Loop: Header=BB8_5 Depth=1
	movs	r0, #1
	strb.w	r0, [r9, #16]
	movs	r0, #5
	strb.w	r0, [r9, #17]
	ldrsh.w	r0, [r9, #28]
	str	r0, [r6, #36]
	b.w	.LBB8_4
	.p2align	2
.LBB8_179:                              @   in Loop: Header=BB8_5 Depth=1
	movw	r0, #3000
	movw	r5, :lower16:.L_MergedGlobals
	cmp	r10, r0
	movt	r5, :upper16:.L_MergedGlobals
	it	ge
	movge	r10, r0
	movs	r0, #100
	movw	r2, #9464
	cmp.w	r10, #100
	mov.w	r3, #0
	it	le
	movle	r10, r0
	movs	r0, #0
	movt	r2, #1
	strh.w	r10, [r5, #4]
	ldrh	r1, [r5, #4]
	bl	__aeabi_uldivmod
	str.w	r0, [r9, #84]
	movs	r0, #0
	str.w	r0, [r9, #88]
	movs	r0, #1
	strb.w	r0, [r9, #16]
	movs	r0, #9
	strb.w	r0, [r9, #17]
	ldrh	r0, [r5, #4]
.LBB8_180:                              @   in Loop: Header=BB8_5 Depth=1
	movw	r1, :lower16:.L_MergedGlobals.42
	movt	r1, :upper16:.L_MergedGlobals.42
	str	r0, [r1, #36]
	b.w	.LBB8_4
	.p2align	2
.LBB8_181:                              @   in Loop: Header=BB8_5 Depth=1
	movs	r2, #0
.LBB8_182:                              @   in Loop: Header=BB8_5 Depth=1
	ldrsh.w	r3, [r9, #28]
	ldr.w	r7, [r12, #8]
	cmp	r0, #0
	add	r3, r1
	ssat	r3, #16, r3
	mul	r3, r7, r3
	asr.w	r3, r3, #15
	str	r3, [r6, #28]
	ldrsh.w	r3, [r9, #30]
	ldrsh.w	r7, [r9, #26]
	mul	r1, r7, r1
	add	r2, r3
	add.w	r1, r2, r1, asr #15
	ldr.w	r2, [r12, #12]
	ssat	r1, #16, r1
	mul	r1, r2, r1
	mov.w	r2, #2000
	asr.w	r1, r1, #15
	str	r1, [r6, #32]
	ldr	r1, [r6, #28]
	mul	r1, r2, r1
	asr.w	r1, r1, #15
	str.w	r1, [r9, #68]
	ldr	r1, [r6, #32]
	mul	r1, r2, r1
	asr.w	r0, r1, #15
	str.w	r0, [r9, #72]
	beq	.LBB8_184
@ %bb.183:                              @   in Loop: Header=BB8_5 Depth=1
	ldr.w	r0, [r9, #72]
	rsbs	r0, r0, #0
	str.w	r0, [r9, #72]
.LBB8_184:                              @   in Loop: Header=BB8_5 Depth=1
	movs	r0, #1
	strb.w	r0, [r9, #16]
	movs	r0, #6
	strb.w	r0, [r9, #17]
	ldrsh.w	r0, [r9, #30]
	str	r0, [r6, #36]
	b.w	.LBB8_4
	.p2align	2
.LBB8_185:                              @   in Loop: Header=BB8_5 Depth=1
	movw	r1, :lower16:.L_MergedGlobals
	cmp.w	r11, #0
	movt	r1, :upper16:.L_MergedGlobals
	ldrb	r0, [r1, #3]
	it	ne
	movne.w	r11, #1
	clz	r0, r0
	cmp	r7, #9
	lsr.w	r0, r0, #5
	and.w	r0, r0, r11
	strb.w	r0, [r9, #1]
	bhi	.LBB8_187
@ %bb.186:                              @   in Loop: Header=BB8_5 Depth=1
	sub.w	r0, r8, #1
	cmp	r0, #63
	it	ls
	strhls.w	r8, [r1, #6]
.LBB8_187:                              @   in Loop: Header=BB8_5 Depth=1
	movw	r2, :lower16:.L_MergedGlobals.42
	movs	r0, #0
	strh.w	r0, [r9, #40]
	movs	r0, #1
	strb.w	r0, [r9, #16]
	movs	r0, #10
	strb.w	r0, [r9, #17]
	movt	r2, :upper16:.L_MergedGlobals.42
	ldrb.w	r0, [r9, #1]
	str	r0, [r2, #36]
	ldrh	r0, [r1, #6]
	str	r0, [r2, #40]
	b.w	.LBB8_4
	.p2align	2
.LBB8_188:                              @   in Loop: Header=BB8_5 Depth=1
	ldrsh.w	r0, [r9, #36]
	b	.LBB8_193
	.p2align	2
.LBB8_189:                              @   in Loop: Header=BB8_5 Depth=1
	cmp.w	r11, #0
	movw	r0, :lower16:.L_MergedGlobals.43
	it	ne
	movne.w	r11, #1
	movt	r0, :upper16:.L_MergedGlobals.43
	strb.w	r11, [r9, #10]
	it	ne
	addne	r0, #24
	bl	apply_cfg
	ldrb.w	r0, [r9]
	cbz	r0, .LBB8_191
@ %bb.190:                              @   in Loop: Header=BB8_5 Depth=1
	@APP
	cpsid i
	@NO_APP
	bl	tx_dsp_reset
	@APP
	cpsie i
	@NO_APP
	ldrb.w	r11, [r9, #10]
.LBB8_191:                              @   in Loop: Header=BB8_5 Depth=1
	movs	r0, #1
	strb.w	r0, [r9, #16]
	movs	r0, #11
	strb.w	r0, [r9, #17]
	movw	r0, :lower16:.L_MergedGlobals.42
	movt	r0, :upper16:.L_MergedGlobals.42
	str.w	r11, [r0, #36]
	b.w	.LBB8_4
	.p2align	2
.LBB8_192:                              @   in Loop: Header=BB8_5 Depth=1
	movw	r6, :lower16:.L_MergedGlobals.42
	movs	r1, #0
	movt	r6, :upper16:.L_MergedGlobals.42
.LBB8_193:                              @   in Loop: Header=BB8_5 Depth=1
	ldrsh.w	r2, [r9, #28]
	ldr	r3, [r7, #8]
	add	r2, r0
	ssat	r2, #16, r2
	muls	r2, r3, r2
	asrs	r2, r2, #15
	str	r2, [r6, #28]
	ldrsh.w	r2, [r9, #30]
	ldrsh.w	r3, [r9, #26]
	muls	r0, r3, r0
	add	r1, r2
	add.w	r0, r1, r0, asr #15
	ldr	r1, [r7, #12]
	ssat	r0, #16, r0
	muls	r0, r1, r0
	mov.w	r1, #2000
	asrs	r0, r0, #15
	str	r0, [r6, #32]
	ldr	r0, [r6, #28]
	muls	r0, r1, r0
	asrs	r0, r0, #15
	str.w	r0, [r9, #68]
	ldr	r0, [r6, #32]
	muls	r0, r1, r0
	asrs	r0, r0, #15
	str.w	r0, [r9, #72]
	ldrb.w	r0, [r9, #10]
	cbz	r0, .LBB8_195
@ %bb.194:                              @   in Loop: Header=BB8_5 Depth=1
	ldr.w	r0, [r9, #72]
	rsbs	r0, r0, #0
	str.w	r0, [r9, #72]
.LBB8_195:                              @   in Loop: Header=BB8_5 Depth=1
	ldrb.w	r0, [r9]
	cmp	r0, #0
	beq	.LBB8_197
@ %bb.196:                              @   in Loop: Header=BB8_5 Depth=1
	movw	r0, :lower16:dec_buf
	@APP
	cpsid i
	@NO_APP
	mov.w	r1, #768
	movt	r0, :upper16:dec_buf
	bl	__aeabi_memclr4
	movw	r0, :lower16:.L_MergedGlobals.42
	movs	r1, #0
	movt	r0, :upper16:.L_MergedGlobals.42
	movw	r2, #39322
	strd	r1, r1, [r9, #32]
	strd	r1, r1, [r0, #64]
	strd	r1, r1, [r0, #72]
	str	r1, [r0, #28]
	movt	r2, #12697
	str	r1, [r0, #32]
	str.w	r1, [r9, #68]
	str.w	r1, [r9, #72]
	str.w	r1, [r9, #88]
	strd	r1, r1, [r9, #92]
	strd	r1, r1, [r9, #100]
	strd	r1, r1, [r9, #108]
	strd	r1, r1, [r9, #116]
	str	r1, [r0]
	movw	r0, :lower16:.L_MergedGlobals
	movt	r0, :upper16:.L_MergedGlobals
	str	r2, [r0, #24]
	mov.w	r2, #1000
	str	r2, [r0, #28]
	movw	r2, #40703
	str.w	r1, [r9, #64]
	movt	r2, #36
	ldr.w	r0, [r9, #44]
	cmp	r0, r2
	mov.w	r0, #0
	it	hi
	movhi	r0, #1
	mov.w	r2, #134217728
	strb.w	r0, [r9, #8]
	movw	r0, :lower16:.L_MergedGlobals
	movt	r0, :upper16:.L_MergedGlobals
	str	r2, [r0, #32]
	strh.w	r1, [r9, #40]
	ldrb.w	r0, [r9, #10]
	cmp	r0, #0
	movw	r0, :lower16:.L_MergedGlobals.43
	movt	r0, :upper16:.L_MergedGlobals.43
	it	ne
	addne	r0, #24
	bl	apply_cfg
	movw	r6, :lower16:.L_MergedGlobals.42
	movw	r7, :lower16:.L_MergedGlobals
	movt	r6, :upper16:.L_MergedGlobals.42
	movt	r7, :upper16:.L_MergedGlobals
	@APP
	cpsie i
	@NO_APP
.LBB8_197:                              @   in Loop: Header=BB8_5 Depth=1
	movs	r0, #1
	strb.w	r0, [r9, #16]
	movs	r0, #8
	strb.w	r0, [r9, #17]
	ldrb	r0, [r7]
	str	r0, [r6, #36]
	b.w	.LBB8_4
	.p2align	2
.LBB8_198:                              @   in Loop: Header=BB8_5 Depth=1
	ldrb.w	r0, [r9]
	cmp.w	r10, #0
	beq	.LBB8_204
@ %bb.199:                              @   in Loop: Header=BB8_5 Depth=1
	cbnz	r0, .LBB8_204
@ %bb.200:                              @   in Loop: Header=BB8_5 Depth=1
	@APP
	cpsid i
	@NO_APP
	bl	tx_dsp_reset
	movs	r2, #1
	strb.w	r2, [r9]
	@APP
	cpsie i
	@NO_APP
	movw	r1, :lower16:.L_MergedGlobals.42
	movt	r1, :upper16:.L_MergedGlobals.42
	b	.LBB8_205
	.p2align	2
.LBB8_201:                              @   in Loop: Header=BB8_5 Depth=1
	ldrb.w	r0, [r9]
	cmp.w	r10, #0
	mov.w	r5, #0
	beq	.LBB8_209
@ %bb.202:                              @   in Loop: Header=BB8_5 Depth=1
	cbnz	r0, .LBB8_209
@ %bb.203:                              @   in Loop: Header=BB8_5 Depth=1
	@APP
	cpsid i
	@NO_APP
	bl	tx_dsp_reset
	movs	r2, #1
	strb.w	r2, [r9]
	@APP
	cpsie i
	@NO_APP
	b	.LBB8_210
	.p2align	2
.LBB8_204:                              @   in Loop: Header=BB8_5 Depth=1
	cmp.w	r11, #0
	movw	r1, :lower16:.L_MergedGlobals.42
	it	ne
	movne.w	r11, #1
	movt	r1, :upper16:.L_MergedGlobals.42
	movs	r2, #1
	strb.w	r11, [r9]
.LBB8_205:                              @   in Loop: Header=BB8_5 Depth=1
	ldrb.w	r0, [r9]
	strb.w	r0, [r9, #2]
	movs	r0, #12
	strb.w	r2, [r9, #16]
	strb.w	r0, [r9, #17]
	b	.LBB8_211
	.p2align	2
.LBB8_206:                              @   in Loop: Header=BB8_5 Depth=1
	cmp.w	r11, #0
	movw	r0, :lower16:.L_MergedGlobals
	it	ne
	movne.w	r11, #1
	movt	r0, :upper16:.L_MergedGlobals
	strb.w	r11, [r9, #18]
	ldrb	r0, [r0, #1]
	cbnz	r0, .LBB8_208
@ %bb.207:                              @   in Loop: Header=BB8_5 Depth=1
	bl	rx_chain_start
	movs	r2, #1
.LBB8_208:                              @   in Loop: Header=BB8_5 Depth=1
	strb.w	r2, [r9, #16]
	movs	r0, #0
	strb.w	r0, [r9, #17]
	ldrb.w	r0, [r9, #18]
	b	.LBB8_180
	.p2align	2
.LBB8_209:                              @   in Loop: Header=BB8_5 Depth=1
	cmp.w	r11, #0
	it	ne
	movne.w	r11, #1
	strb.w	r11, [r9]
.LBB8_210:                              @   in Loop: Header=BB8_5 Depth=1
	movw	r1, :lower16:.L_MergedGlobals.42
	ldrb.w	r0, [r9]
	movt	r1, :upper16:.L_MergedGlobals.42
	strb.w	r0, [r9, #2]
	strb.w	r2, [r9, #16]
	strb.w	r5, [r9, #17]
.LBB8_211:                              @   in Loop: Header=BB8_5 Depth=1
	ldrb.w	r0, [r9]
	str	r0, [r1, #36]
	b.w	.LBB8_4
	.p2align	2
.LBB8_212:                              @   in Loop: Header=BB8_5 Depth=1
	movs	r0, #2
	strb.w	r0, [r9, #16]
	movs	r0, #14
	strb.w	r0, [r9, #17]
	b.w	.LBB8_4
	.p2align	2
.LBB8_213:                              @   in Loop: Header=BB8_5 Depth=1
	cmp.w	r10, #0
	beq	.LBB8_215
@ %bb.214:                              @   in Loop: Header=BB8_5 Depth=1
	movw	r5, :lower16:.L_MergedGlobals
	movw	r6, :lower16:.L_MergedGlobals.42
	movw	r0, #29704
	movt	r5, :upper16:.L_MergedGlobals
	movt	r6, :upper16:.L_MergedGlobals.42
	movt	r0, #16384
	movs	r2, #0
	strb.w	r2, [r9]
	strb.w	r2, [r9, #18]
	movs	r1, #1
	strb.w	r2, [r9, #2]
	strb.w	r2, [r9, #3]
	strb.w	r2, [r9, #4]
	strb	r1, [r5, #3]
	strb.w	r2, [r9, #1]
	str	r2, [r6, #4]
	strb.w	r2, [r9, #11]
	strb	r1, [r5, #2]
	mov.w	r1, #2048
	strb.w	r2, [r9, #12]
	str	r1, [r0]
	str	r1, [r0, #12]
	bl	rx_chain_start
	movs	r2, #1
	mov	r1, r6
	mov	r0, r5
	b	.LBB8_216
	.p2align	2
.LBB8_215:                              @   in Loop: Header=BB8_5 Depth=1
	movw	r0, :lower16:.L_MergedGlobals
	movs	r1, #0
	movt	r0, :upper16:.L_MergedGlobals
	movs	r2, #1
	strb	r1, [r0, #3]
	movw	r1, :lower16:.L_MergedGlobals.42
	movt	r1, :upper16:.L_MergedGlobals.42
.LBB8_216:                              @   in Loop: Header=BB8_5 Depth=1
	strb.w	r2, [r9, #16]
	movs	r2, #13
	strb.w	r2, [r9, #17]
	ldrb	r0, [r0, #3]
	str	r0, [r1, #36]
	b.w	.LBB8_4
	.p2align	2
.LBB8_217:                              @   in Loop: Header=BB8_5 Depth=1
	cmp.w	r10, #1
	mov.w	r5, #0
	blt	.LBB8_219
@ %bb.218:                              @   in Loop: Header=BB8_5 Depth=1
	movw	r0, :lower16:.L_MergedGlobals
	cmp	r7, #10
	it	hs
	movhs	r8, r5
	movt	r0, :upper16:.L_MergedGlobals
	str.w	r10, [r0, #20]
	uxtb.w	r0, r8
	bl	am_demod_set_mode
	mov	r0, r10
	bl	am_demod_set_freq
.LBB8_219:                              @   in Loop: Header=BB8_5 Depth=1
	movs	r0, #1
	strb.w	r0, [r9, #16]
	strb.w	r5, [r9, #17]
	b	.LBB8_224
	.p2align	2
.LBB8_220:                              @   in Loop: Header=BB8_5 Depth=1
	bic.w	r5, r10, r10, asr #31
	movs	r0, #100
	cmp	r5, #100
	it	ge
	movge	r5, r0
	vmov	s0, r5
	vcvt.f32.u32	s0, s0
	vdiv.f32	s1, s0, s18
	vmov.f32	s0, s16
	bl	__hardfp_powf
	vmul.f32	s0, s0, s20
	bl	am_demod_set_audio_gain
	movs	r0, #1
	strb.w	r0, [r9, #16]
	movs	r0, #0
	strb.w	r0, [r9, #17]
	movw	r0, :lower16:.L_MergedGlobals.42
	movt	r0, :upper16:.L_MergedGlobals.42
	str	r5, [r0, #36]
	b.w	.LBB8_4
	.p2align	2
.LBB8_221:                              @   in Loop: Header=BB8_5 Depth=1
	cmp.w	r11, #0
	it	ne
	movne.w	r11, #1
	mov	r0, r11
	bl	am_demod_set_hpf50
	movs	r0, #1
	strb.w	r0, [r9, #16]
	b	.LBB8_223
	.p2align	2
.LBB8_222:                              @   in Loop: Header=BB8_5 Depth=1
	movs	r5, #1
	cmp	r7, #10
	it	hs
	movhs	r8, r5
	cmp.w	r11, #0
	it	ne
	movne.w	r11, #1
	uxtb.w	r1, r8
	mov	r0, r11
	bl	am_demod_set_nr
	strb.w	r5, [r9, #16]
.LBB8_223:                              @   in Loop: Header=BB8_5 Depth=1
	movs	r0, #0
	strb.w	r0, [r9, #17]
.LBB8_224:                              @   in Loop: Header=BB8_5 Depth=1
	movw	r0, :lower16:.L_MergedGlobals.42
	movt	r0, :upper16:.L_MergedGlobals.42
	str.w	r10, [r0, #36]
	b.w	.LBB8_4
	.p2align	2
.LBB8_225:                              @   in Loop: Header=BB8_5 Depth=1
	movs	r0, #3
	strb.w	r0, [r9, #16]
	movs	r0, #15
	strb.w	r0, [r9, #17]
	b.w	.LBB8_4
	.p2align	2
.LBB8_226:                              @   in Loop: Header=BB8_5 Depth=1
	movw	r0, #20000
	cmp	r10, r0
	it	ge
	movge	r10, r0
	movs	r0, #20
	cmp.w	r10, #20
	it	le
	movle	r10, r0
	mov	r0, r10
	bl	PCM5102_SetFrequency
	movs	r0, #5
	strb.w	r0, [r9, #16]
	movs	r0, #16
	strb.w	r0, [r9, #17]
	b.w	.LBB8_4
	.p2align	2
.LBB8_227:                              @   in Loop: Header=BB8_5 Depth=1
	movs	r0, #100
	cmp.w	r10, #100
	it	ge
	movge	r10, r0
	bic.w	r0, r10, r10, asr #31
	bl	PCM5102_SetVolume
	movs	r0, #5
	strb.w	r0, [r9, #16]
	movs	r0, #17
	strb.w	r0, [r9, #17]
	b.w	.LBB8_4
	.p2align	2
.LBB8_228:                              @   in Loop: Header=BB8_5 Depth=1
	movs	r0, #4
	cmp.w	r10, #4
	it	ge
	movge	r10, r0
	bic.w	r0, r10, r10, asr #31
	bl	PCM5102_SetWave
	movs	r0, #5
	strb.w	r0, [r9, #16]
	movs	r0, #18
	strb.w	r0, [r9, #17]
	b.w	.LBB8_4
	.p2align	2
.LBB8_229:                              @   in Loop: Header=BB8_5 Depth=1
	bl	PCM5102_Play
	movs	r0, #5
	strb.w	r0, [r9, #16]
	movs	r0, #19
	strb.w	r0, [r9, #17]
	b.w	.LBB8_4
	.p2align	2
.LBB8_230:                              @   in Loop: Header=BB8_5 Depth=1
	bl	PCM5102_Stop
	movs	r0, #5
	strb.w	r0, [r9, #16]
	movs	r0, #20
	strb.w	r0, [r9, #17]
	b.w	.LBB8_4
	.p2align	2
.LBB8_231:                              @   in Loop: Header=BB8_5 Depth=1
	movs	r0, #5
	strb.w	r0, [r9, #16]
	movs	r0, #21
	strb.w	r0, [r9, #17]
	b.w	.LBB8_4
	.p2align	2
@ %bb.232:
.LCPI8_0:
.L.str.11:
	.asciz	"IGAIN\000\000"
.LCPI8_1:
.L.str.12:
	.asciz	"QGAIN\000\000"
.LCPI8_2:
.L.str.13:
	.asciz	"PHASE\000\000"
.LCPI8_3:
.L.str.14:
	.asciz	"QUAD\000\000\000"
.LCPI8_4:
.L.str.17:
	.asciz	"AGAIN\000\000"
.LCPI8_5:
.L.str.18:
	.asciz	"MODE\000\000\000"
.LCPI8_6:
.L.str.19:
	.asciz	"FREQ\000\000\000"
.LCPI8_7:
.L.str.20:
	.asciz	"TONE\000\000\000"
.LCPI8_8:
.L.str.21:
	.asciz	"STREAM\000"
.LCPI8_9:
.L.str.22:
	.asciz	"SIDE\000\000\000"
.LCPI8_10:
.L.str.23:
	.asciz	"TX\000"
.LCPI8_11:
.L.str.26:
	.asciz	"RX\000"
.LCPI8_12:
.L.str.27:
	.asciz	"STAT\000\000\000"
.LCPI8_13:
.L.str.29:
	.asciz	"DEMOD\000\000"
.LCPI8_14:
.L.str.30:
	.asciz	"DGAIN\000\000"
.LCPI8_15:
.L.str.32:
	.asciz	"NR\000"
.LCPI8_16:
.L.str.33:
	.asciz	"HELP\000\000\000"
.Lfunc_end8:
	.size	process_spi_commands, .Lfunc_end8-process_spi_commands
	.cfi_endproc
	.cantunwind
	.fnend
                                        @ -- End function
	.section	.text.Error_Handler,"ax",%progbits
	.hidden	Error_Handler                   @ -- Begin function Error_Handler
	.globl	Error_Handler
	.p2align	3
	.type	Error_Handler,%function
	.code	16                              @ @Error_Handler
	.thumb_func
Error_Handler:
	.fnstart
	.cfi_startproc
@ %bb.0:
	movw	r4, #2048
	movt	r4, #22530
	.p2align	2
.LBB9_1:                                @ =>This Inner Loop Header: Depth=1
	movs	r1, #2
	mov	r0, r4
	bl	HAL_GPIO_TogglePin
	movs	r0, #50
	bl	HAL_Delay
	b	.LBB9_1
.Lfunc_end9:
	.size	Error_Handler, .Lfunc_end9-Error_Handler
	.cfi_endproc
	.cantunwind
	.fnend
                                        @ -- End function
	.section	.text.PeriphCommonClock_Config,"ax",%progbits
	.hidden	PeriphCommonClock_Config        @ -- Begin function PeriphCommonClock_Config
	.globl	PeriphCommonClock_Config
	.p2align	3
	.type	PeriphCommonClock_Config,%function
	.code	16                              @ @PeriphCommonClock_Config
	.thumb_func
PeriphCommonClock_Config:
	.fnstart
	.cfi_startproc
@ %bb.0:
	.save	{r4, lr}
	push	{r4, lr}
	.cfi_def_cfa_offset 8
	.cfi_offset lr, -4
	.cfi_offset r4, -8
	.pad	#192
	sub	sp, #192
	.cfi_def_cfa_offset 200
	mov	r4, sp
	movs	r1, #184
	add.w	r0, r4, #8
	bl	__aeabi_memclr8
	movs	r0, #0
	str	r0, [sp, #4]
	mov.w	r0, #256
	str	r0, [sp]
	movs	r0, #3
	str	r0, [sp, #88]
	mov	r0, r4
	bl	HAL_RCCEx_PeriphCLKConfig
	cbz	r0, .LBB10_3
@ %bb.1:
	movw	r4, #2048
	movt	r4, #22530
	.p2align	2
.LBB10_2:                               @ =>This Inner Loop Header: Depth=1
	movs	r1, #2
	mov	r0, r4
	bl	HAL_GPIO_TogglePin
	movs	r0, #50
	bl	HAL_Delay
	b	.LBB10_2
	.p2align	2
.LBB10_3:
	add	sp, #192
	pop	{r4, pc}
.Lfunc_end10:
	.size	PeriphCommonClock_Config, .Lfunc_end10-PeriphCommonClock_Config
	.cfi_endproc
	.cantunwind
	.fnend
                                        @ -- End function
	.section	.text.uart2_dma_tc_cb,"ax",%progbits
	.p2align	3                               @ -- Begin function uart2_dma_tc_cb
	.type	uart2_dma_tc_cb,%function
	.code	16                              @ @uart2_dma_tc_cb
	.thumb_func
uart2_dma_tc_cb:
	.fnstart
	.cfi_startproc
@ %bb.0:
	movs	r1, #160
	ldr	r0, [r0]
	movt	r1, #16386
	cmp	r0, r1
	it	ne
	bxne	lr
.LBB11_1:
	movw	r0, :lower16:.L_MergedGlobals.41
	movs	r1, #0
	movt	r0, :upper16:.L_MergedGlobals.41
	strb	r1, [r0, #15]
	bx	lr
.Lfunc_end11:
	.size	uart2_dma_tc_cb, .Lfunc_end11-uart2_dma_tc_cb
	.cfi_endproc
	.cantunwind
	.fnend
                                        @ -- End function
	.section	.text.tx_dsp_reset,"ax",%progbits
	.p2align	3                               @ -- Begin function tx_dsp_reset
	.type	tx_dsp_reset,%function
	.code	16                              @ @tx_dsp_reset
	.thumb_func
tx_dsp_reset:
	.fnstart
	.cfi_startproc
@ %bb.0:
	.save	{r7, lr}
	push	{r7, lr}
	.cfi_def_cfa_offset 8
	.cfi_offset lr, -4
	.cfi_offset r7, -8
	movw	r0, :lower16:dec_buf
	mov.w	r1, #768
	movt	r0, :upper16:dec_buf
	bl	__aeabi_memclr4
	movw	r2, :lower16:.L_MergedGlobals.42
	movw	r1, :lower16:.L_MergedGlobals.41
	movw	r12, :lower16:.L_MergedGlobals
	movt	r2, :upper16:.L_MergedGlobals.42
	movt	r1, :upper16:.L_MergedGlobals.41
	movt	r12, :upper16:.L_MergedGlobals
	movw	r3, #39322
	movs	r0, #0
	strd	r0, r0, [r2, #64]
	str	r0, [r2, #72]
	movt	r3, #12697
	str	r0, [r2, #76]
	strd	r0, r0, [r1, #32]
	str	r0, [r2, #28]
	str	r0, [r2, #32]
	str	r0, [r1, #68]
	str	r0, [r1, #72]
	str	r0, [r1, #88]
	strd	r0, r0, [r1, #92]
	strd	r0, r0, [r1, #100]
	strd	r0, r0, [r1, #108]
	strd	r0, r0, [r1, #116]
	str	r0, [r2]
	movw	r2, #40703
	str.w	r3, [r12, #24]
	mov.w	r3, #1000
	str.w	r3, [r12, #28]
	movt	r2, #36
	str	r0, [r1, #64]
	ldr	r3, [r1, #44]
	cmp	r3, r2
	mov.w	r2, #0
	it	hi
	movhi	r2, #1
	strb	r2, [r1, #8]
	mov.w	r2, #134217728
	str.w	r2, [r12, #32]
	strh	r0, [r1, #40]
	movw	r0, :lower16:.L_MergedGlobals.43
	ldrb	r1, [r1, #10]
	movt	r0, :upper16:.L_MergedGlobals.43
	cmp	r1, #0
	it	ne
	addne	r0, #24
	pop.w	{r7, lr}
	b	apply_cfg
.Lfunc_end12:
	.size	tx_dsp_reset, .Lfunc_end12-tx_dsp_reset
	.cfi_endproc
	.cantunwind
	.fnend
                                        @ -- End function
	.section	.text.rx_chain_start,"ax",%progbits
	.p2align	3                               @ -- Begin function rx_chain_start
	.type	rx_chain_start,%function
	.code	16                              @ @rx_chain_start
	.thumb_func
rx_chain_start:
	.fnstart
	.cfi_startproc
@ %bb.0:
	.save	{r4, r5, r7, lr}
	push	{r4, r5, r7, lr}
	.cfi_def_cfa_offset 16
	.cfi_offset lr, -4
	.cfi_offset r7, -8
	.cfi_offset r5, -12
	.cfi_offset r4, -16
	.pad	#192
	sub	sp, #192
	.cfi_def_cfa_offset 208
	movw	r5, :lower16:.L_MergedGlobals.41
	movt	r5, :upper16:.L_MergedGlobals.41
	ldrb	r0, [r5, #9]
	cbnz	r0, .LBB13_5
@ %bb.1:
	mov	r4, sp
	movs	r1, #184
	add.w	r0, r4, #8
	bl	__aeabi_memclr8
	movs	r0, #0
	str	r0, [sp, #4]
	mov.w	r0, #256
	str	r0, [sp]
	movs	r0, #3
	str	r0, [sp, #88]
	mov	r0, r4
	bl	HAL_RCCEx_PeriphCLKConfig
	cbz	r0, .LBB13_4
@ %bb.2:
	movw	r4, #2048
	movt	r4, #22530
	.p2align	2
.LBB13_3:                               @ =>This Inner Loop Header: Depth=1
	movs	r1, #2
	mov	r0, r4
	bl	HAL_GPIO_TogglePin
	movs	r0, #50
	bl	HAL_Delay
	b	.LBB13_3
	.p2align	2
.LBB13_4:
	bl	MX_SAI1_Init
	bl	PCM5102_Init
	movs	r0, #1
	strb	r0, [r5, #9]
.LBB13_5:
	movw	r4, :lower16:.L_MergedGlobals
	movt	r4, :upper16:.L_MergedGlobals
	ldrb	r0, [r4, #1]
	cbz	r0, .LBB13_7
.LBB13_6:
	movs	r0, #1
	bl	PCM5102_SetDemodMode
	bl	PCM5102_Play
	add	sp, #192
	pop	{r4, r5, r7, pc}
	.p2align	2
.LBB13_7:
	movw	r0, :lower16:hadc1
	movt	r0, :upper16:hadc1
	bl	HAL_ADC_Start
	cbz	r0, .LBB13_10
@ %bb.8:
	movw	r4, #2048
	movt	r4, #22530
	.p2align	2
.LBB13_9:                               @ =>This Inner Loop Header: Depth=1
	movs	r1, #2
	mov	r0, r4
	bl	HAL_GPIO_TogglePin
	movs	r0, #50
	bl	HAL_Delay
	b	.LBB13_9
	.p2align	2
.LBB13_10:
	movs	r0, #1
	strb	r0, [r4, #1]
	bl	am_demod_enable
	b	.LBB13_6
.Lfunc_end13:
	.size	rx_chain_start, .Lfunc_end13-rx_chain_start
	.cfi_endproc
	.cantunwind
	.fnend
                                        @ -- End function
	.type	hdma_usart2_tx,%object          @ @hdma_usart2_tx
	.section	.bss.hdma_usart2_tx,"aw",%nobits
	.p2align	2, 0x0
hdma_usart2_tx:
	.zero	120
	.size	hdma_usart2_tx, 120

	.type	cmd_line_queue,%object          @ @cmd_line_queue
	.section	.bss.cmd_line_queue,"aw",%nobits
cmd_line_queue:
	.zero	384
	.size	cmd_line_queue, 384

	.type	cos_table_q15,%object           @ @cos_table_q15
	.section	.bss.cos_table_q15,"aw",%nobits
	.p2align	1, 0x0
cos_table_q15:
	.zero	8192
	.size	cos_table_q15, 8192

	.type	sin_table_q15,%object           @ @sin_table_q15
	.section	.bss.sin_table_q15,"aw",%nobits
	.p2align	1, 0x0
sin_table_q15:
	.zero	8192
	.size	sin_table_q15, 8192

	.type	adc_dma_buf,%object             @ @adc_dma_buf
	.section	.ARM.__at_0x24000000,"aw",%progbits
	.p2align	1, 0x0
adc_dma_buf:
	.zero	8192
	.size	adc_dma_buf, 8192

	.type	adc_dma_buf2,%object            @ @adc_dma_buf2
	.section	.ARM.__at_0x24002000,"aw",%progbits
	.p2align	1, 0x0
adc_dma_buf2:
	.zero	8192
	.size	adc_dma_buf2, 8192

	.type	dec_buf,%object                 @ @dec_buf
	.section	.bss.dec_buf,"aw",%nobits
	.p2align	2, 0x0
dec_buf:
	.zero	768
	.size	dec_buf, 768

	.type	ssb_win_hi,%object              @ @ssb_win_hi
	.section	.bss.ssb_win_hi,"aw",%nobits
	.p2align	1, 0x0
ssb_win_hi:
	.zero	128
	.size	ssb_win_hi, 128

	.type	ssb_win_lo,%object              @ @ssb_win_lo
	.section	.bss.ssb_win_lo,"aw",%nobits
	.p2align	2, 0x0
ssb_win_lo:
	.zero	128
	.size	ssb_win_lo, 128

	.type	g_q15,%object                   @ @g_q15
	.section	.bss.g_q15,"aw",%nobits
	.p2align	1, 0x0
g_q15:
	.zero	128
	.size	g_q15, 128

	.type	h_q15,%object                   @ @h_q15
	.section	.bss.h_q15,"aw",%nobits
	.p2align	1, 0x0
h_q15:
	.zero	128
	.size	h_q15, 128

	.type	hspi3,%object                   @ @hspi3
	.section	.bss.hspi3,"aw",%nobits
	.p2align	2, 0x0
hspi3:
	.zero	136
	.size	hspi3, 136

	.type	htim2,%object                   @ @htim2
	.section	.bss.htim2,"aw",%nobits
	.p2align	2, 0x0
htim2:
	.zero	76
	.size	htim2, 76

	.type	.L.str.8,%object                @ @.str.8
	.section	.rodata.str1.1,"aMS",%progbits,1
.L.str.8:
	.asciz	"RAW-DMA CR=%08lx NDTR=%04lx M0AR=%08lx\n"
	.size	.L.str.8, 40

	.type	.L.str.9,%object                @ @.str.9
.L.str.9:
	.asciz	"FSAMP dt=%lu fs=%lu\n"
	.size	.L.str.9, 21

	.type	htim3,%object                   @ @htim3
	.section	.bss.htim3,"aw",%nobits
	.p2align	2, 0x0
htim3:
	.zero	76
	.size	htim3, 76

	.type	htim4,%object                   @ @htim4
	.section	.bss.htim4,"aw",%nobits
	.p2align	2, 0x0
htim4:
	.zero	76
	.size	htim4, 76

	.type	main.adc1_diag,%object          @ @main.adc1_diag
	.section	.bss.main.adc1_diag,"aw",%nobits
main.adc1_diag:
	.zero	160
	.size	main.adc1_diag, 160

	.type	.L.str.10,%object               @ @.str.10
	.section	.rodata.str1.1,"aMS",%progbits,1
.L.str.10:
	.asciz	"ADC1 CR=%08lx CFGR=%08lx SMPR1=%08lx ISR=%08lx DR=%04x\n"
	.size	.L.str.10, 56

	.type	tx_frame,%object                @ @tx_frame
	.section	.bss.tx_frame,"aw",%nobits
	.p2align	2, 0x0
tx_frame:
	.zero	16394
	.size	tx_frame, 16394

	.type	huart2,%object                  @ @huart2
	.section	.bss.huart2,"aw",%nobits
	.p2align	2, 0x0
huart2:
	.zero	148
	.size	huart2, 148

	.type	init_iq_splitter.gd,%object     @ @init_iq_splitter.gd
	.section	.bss.init_iq_splitter.gd,"aw",%nobits
	.p2align	3, 0x0
init_iq_splitter.gd:
	.zero	1024
	.size	init_iq_splitter.gd, 1024

	.type	init_iq_splitter.hd,%object     @ @init_iq_splitter.hd
	.section	.bss.init_iq_splitter.hd,"aw",%nobits
	.p2align	3, 0x0
init_iq_splitter.hd:
	.zero	1024
	.size	init_iq_splitter.hd, 1024

	.type	.L.str.15,%object               @ @.str.15
	.section	.rodata.str1.1,"aMS",%progbits,1
.L.str.15:
	.asciz	"IDC"
	.size	.L.str.15, 4

	.type	.L.str.16,%object               @ @.str.16
.L.str.16:
	.asciz	"QDC"
	.size	.L.str.16, 4

	.type	.L.str.24,%object               @ @.str.24
.L.str.24:
	.asciz	"PTT"
	.size	.L.str.24, 4

	.type	.L.str.25,%object               @ @.str.25
.L.str.25:
	.asciz	"FDX"
	.size	.L.str.25, 4

	.type	.L.str.28,%object               @ @.str.28
.L.str.28:
	.asciz	"GET"
	.size	.L.str.28, 4

	.type	.L.str.31,%object               @ @.str.31
.L.str.31:
	.asciz	"HPF"
	.size	.L.str.31, 4

	.type	.L.str.34,%object               @ @.str.34
.L.str.34:
	.asciz	"F"
	.size	.L.str.34, 2

	.type	.L.str.35,%object               @ @.str.35
.L.str.35:
	.asciz	"V"
	.size	.L.str.35, 2

	.type	.L.str.36,%object               @ @.str.36
.L.str.36:
	.asciz	"W"
	.size	.L.str.36, 2

	.type	.L.str.37,%object               @ @.str.37
.L.str.37:
	.asciz	"P"
	.size	.L.str.37, 2

	.type	.L.str.38,%object               @ @.str.38
.L.str.38:
	.asciz	"S"
	.size	.L.str.38, 2

	.type	.L.str.39,%object               @ @.str.39
.L.str.39:
	.asciz	"I"
	.size	.L.str.39, 2

	.type	hadc1,%object                   @ @hadc1
	.section	.bss.hadc1,"aw",%nobits
	.p2align	2, 0x0
hadc1:
	.zero	100
	.size	hadc1, 100

	.type	hadc3,%object                   @ @hadc3
	.section	.bss.hadc3,"aw",%nobits
	.p2align	2, 0x0
hadc3:
	.zero	100
	.size	hadc3, 100

	.type	__ARM_use_no_argv,%object       @ @__ARM_use_no_argv
	.section	.ARM.use_no_argv,"awR",%progbits,unique,1
	.globl	__ARM_use_no_argv
	.p2align	2, 0x0
__ARM_use_no_argv:
	.long	1                               @ 0x1
	.size	__ARM_use_no_argv, 4

	.type	.L_MergedGlobals,%object        @ @_MergedGlobals
	.section	.data..L_MergedGlobals,"aw",%progbits
	.p2align	2, 0x0
.L_MergedGlobals:
	.byte	8                               @ 0x8
	.byte	1                               @ 0x1
	.byte	1                               @ 0x1
	.byte	1                               @ 0x1
	.short	1000                            @ 0x3e8
	.short	1                               @ 0x1
	.long	32767                           @ 0x7fff
	.long	32767                           @ 0x7fff
	.long	64                              @ 0x40
	.long	465000                          @ 0x71868
	.long	832149914                       @ 0x3199999a
	.long	1000                            @ 0x3e8
	.long	134217728                       @ 0x8000000
	.size	.L_MergedGlobals, 36

	.type	.L_MergedGlobals.41,%object     @ @_MergedGlobals.41
	.section	.bss..L_MergedGlobals.41,"aw",%nobits
	.p2align	2, 0x0
.L_MergedGlobals.41:
	.zero	124
	.size	.L_MergedGlobals.41, 124

	.type	.L_MergedGlobals.42,%object     @ @_MergedGlobals.42
	.section	.bss..L_MergedGlobals.42,"aw",%nobits
	.p2align	3, 0x0
.L_MergedGlobals.42:
	.zero	112
	.size	.L_MergedGlobals.42, 112

	.type	.L_MergedGlobals.43,%object     @ @_MergedGlobals.43
	.section	.bss..L_MergedGlobals.43,"aw",%nobits
	.p2align	2, 0x0
.L_MergedGlobals.43:
	.zero	96
	.size	.L_MergedGlobals.43, 96

	.hidden	_printf_percent
	.hidden	_printf_flags
	.hidden	_printf_widthprec
	.hidden	_printf_pre_padding
	.hidden	_printf_sizespec
	.hidden	_printf_return_value
	.hidden	_printf_x
	.hidden	_printf_u
	.hidden	_printf_int_dec
	.hidden	_printf_longlong_hex
	.globl	mode_run
	.hidden	mode_run
.set mode_run, .L_MergedGlobals
	.size	mode_run, 1
.set rx_chain_en, .L_MergedGlobals+1
	.size	rx_chain_en, 1
.set rx_acquire, .L_MergedGlobals+2
	.size	rx_acquire, 1
.set rx_mode, .L_MergedGlobals+3
	.size	rx_mode, 1
	.globl	tone_freq
	.hidden	tone_freq
.set tone_freq, .L_MergedGlobals+4
	.size	tone_freq, 2
	.globl	stream_decim
	.hidden	stream_decim
.set stream_decim, .L_MergedGlobals+6
	.size	stream_decim, 2
	.globl	i_gain_run
	.hidden	i_gain_run
.set i_gain_run, .L_MergedGlobals+8
	.size	i_gain_run, 4
	.globl	q_gain_run
	.hidden	q_gain_run
.set q_gain_run, .L_MergedGlobals+12
	.size	q_gain_run, 4
	.globl	audio_gain_run
	.hidden	audio_gain_run
.set audio_gain_run, .L_MergedGlobals+16
	.size	audio_gain_run, 4
	.globl	tuned_freq_hz
	.hidden	tuned_freq_hz
.set tuned_freq_hz, .L_MergedGlobals+20
	.size	tuned_freq_hz, 4
.set nfm_inc_run, .L_MergedGlobals+24
	.size	nfm_inc_run, 4
.set am_env_run, .L_MergedGlobals+28
	.size	am_env_run, 4
.set dc_q16, .L_MergedGlobals+32
	.size	dc_q16, 4
	.globl	ptt_cmd
	.hidden	ptt_cmd
.set ptt_cmd, .L_MergedGlobals.41
	.size	ptt_cmd, 1
	.globl	stream_en
	.hidden	stream_en
.set stream_en, .L_MergedGlobals.41+1
	.size	stream_en, 1
	.globl	tx_cmd
	.hidden	tx_cmd
.set tx_cmd, .L_MergedGlobals.41+2
	.size	tx_cmd, 1
	.globl	tx_pc13
	.hidden	tx_pc13
.set tx_pc13, .L_MergedGlobals.41+3
	.size	tx_pc13, 1
	.globl	tx_sw
	.hidden	tx_sw
.set tx_sw, .L_MergedGlobals.41+4
	.size	tx_sw, 1
.set rx_len, .L_MergedGlobals.41+5
	.size	rx_len, 1
.set cmd_q_tail, .L_MergedGlobals.41+6
	.size	cmd_q_tail, 1
.set cmd_q_head, .L_MergedGlobals.41+7
	.size	cmd_q_head, 1
.set modulation_enabled, .L_MergedGlobals.41+8
	.size	modulation_enabled, 1
.set s_audio_dac_inited, .L_MergedGlobals.41+9
	.size	s_audio_dac_inited, 1
.set side_run, .L_MergedGlobals.41+10
	.size	side_run, 1
.set rx_ready, .L_MergedGlobals.41+11
	.size	rx_ready, 1
.set rx_div, .L_MergedGlobals.41+12
	.size	rx_div, 1
.set adc_db_ready, .L_MergedGlobals.41+13
	.size	adc_db_ready, 1
.set wd_healthy, .L_MergedGlobals.41+14
	.size	wd_healthy, 1
.set uart_dma_busy, .L_MergedGlobals.41+15
	.size	uart_dma_busy, 1
.set rpl_kind, .L_MergedGlobals.41+16
	.size	rpl_kind, 1
.set rpl_cmd, .L_MergedGlobals.41+17
	.size	rpl_cmd, 1
.set full_duplex_en, .L_MergedGlobals.41+18
	.size	full_duplex_en, 1
	.globl	debug_audio_q15
	.hidden	debug_audio_q15
.set debug_audio_q15, .L_MergedGlobals.41+20
	.size	debug_audio_q15, 2
	.globl	debug_i_audio
	.hidden	debug_i_audio
.set debug_i_audio, .L_MergedGlobals.41+22
	.size	debug_i_audio, 2
	.globl	debug_q_audio
	.hidden	debug_q_audio
.set debug_q_audio, .L_MergedGlobals.41+24
	.size	debug_q_audio, 2
	.globl	quad_q15
	.hidden	quad_q15
.set quad_q15, .L_MergedGlobals.41+26
	.size	quad_q15, 2
	.globl	idc_trim
	.hidden	idc_trim
.set idc_trim, .L_MergedGlobals.41+28
	.size	idc_trim, 2
	.globl	qdc_trim
	.hidden	qdc_trim
.set qdc_trim, .L_MergedGlobals.41+30
	.size	qdc_trim, 2
.set dec_wp, .L_MergedGlobals.41+32
	.size	dec_wp, 2
.set split_tap, .L_MergedGlobals.41+34
	.size	split_tap, 2
.set i_audio_cur, .L_MergedGlobals.41+36
	.size	i_audio_cur, 2
.set q_audio_cur, .L_MergedGlobals.41+38
	.size	q_audio_cur, 2
.set stream_wp, .L_MergedGlobals.41+40
	.size	stream_wp, 2
	.globl	sys_tick
	.hidden	sys_tick
.set sys_tick, .L_MergedGlobals.41+44
	.size	sys_tick, 4
	.globl	int_count
	.hidden	int_count
.set int_count, .L_MergedGlobals.41+48
	.size	int_count, 4
	.globl	debug_ac_i
	.hidden	debug_ac_i
.set debug_ac_i, .L_MergedGlobals.41+52
	.size	debug_ac_i, 4
	.globl	phase_off32
	.hidden	phase_off32
.set phase_off32, .L_MergedGlobals.41+56
	.size	phase_off32, 4
.set hb_tim2, .L_MergedGlobals.41+60
	.size	hb_tim2, 4
.set carrier_phase, .L_MergedGlobals.41+64
	.size	carrier_phase, 4
.set i_audio_dac_run, .L_MergedGlobals.41+68
	.size	i_audio_dac_run, 4
.set q_audio_dac_run, .L_MergedGlobals.41+72
	.size	q_audio_dac_run, 4
.set hb_tim3, .L_MergedGlobals.41+76
	.size	hb_tim3, 4
.set hb_tim4, .L_MergedGlobals.41+80
	.size	hb_tim4, 4
.set tone_inc, .L_MergedGlobals.41+84
	.size	tone_inc, 4
.set tone_phase, .L_MergedGlobals.41+88
	.size	tone_phase, 4
.set l1_x1, .L_MergedGlobals.41+92
	.size	l1_x1, 4
.set l1_x2, .L_MergedGlobals.41+96
	.size	l1_x2, 4
.set l1_y1, .L_MergedGlobals.41+100
	.size	l1_y1, 4
.set l1_y2, .L_MergedGlobals.41+104
	.size	l1_y2, 4
.set l2_x1, .L_MergedGlobals.41+108
	.size	l2_x1, 4
.set l2_x2, .L_MergedGlobals.41+112
	.size	l2_x2, 4
.set l2_y1, .L_MergedGlobals.41+116
	.size	l2_y1, 4
.set l2_y2, .L_MergedGlobals.41+120
	.size	l2_y2, 4
.set lpf_audio_run, .L_MergedGlobals.42
	.size	lpf_audio_run, 4
.set rx_wp, .L_MergedGlobals.42+4
	.size	rx_wp, 4
.set hb_main, .L_MergedGlobals.42+8
	.size	hb_main, 4
.set main.last_t2, .L_MergedGlobals.42+12
	.size	main.last_t2, 4
.set main.last_t3, .L_MergedGlobals.42+16
	.size	main.last_t3, 4
.set main.last_t4, .L_MergedGlobals.42+20
	.size	main.last_t4, 4
.set main.last_main, .L_MergedGlobals.42+24
	.size	main.last_main, 4
.set i_audio_g_run, .L_MergedGlobals.42+28
	.size	i_audio_g_run, 4
.set q_audio_g_run, .L_MergedGlobals.42+32
	.size	q_audio_g_run, 4
.set rpl_val, .L_MergedGlobals.42+36
	.size	rpl_val, 4
.set rpl_val2, .L_MergedGlobals.42+40
	.size	rpl_val2, 4
.set dbg_calls, .L_MergedGlobals.42+44
	.size	dbg_calls, 4
.set dbg_nss_high_wait, .L_MergedGlobals.42+48
	.size	dbg_nss_high_wait, 4
.set rx_hdr, .L_MergedGlobals.42+52
	.size	rx_hdr, 5
.set i_acc, .L_MergedGlobals.42+64
	.size	i_acc, 8
.set q_acc, .L_MergedGlobals.42+72
	.size	q_acc, 8
.set rpl_badcmd, .L_MergedGlobals.42+80
	.size	rpl_badcmd, 12
.set hdac1, .L_MergedGlobals.42+92
	.size	hdac1, 20
.set cfg_lsb, .L_MergedGlobals.43
	.size	cfg_lsb, 24
.set cfg_usb, .L_MergedGlobals.43+24
	.size	cfg_usb, 24
.set rx_line, .L_MergedGlobals.43+48
	.size	rx_line, 48
	.ident	"Component: Arm Compiler for Embedded 6.24 Tool: armclang [5f371800]"
	.section	".note.GNU-stack","",%progbits
	.eabi_attribute	30, 2	@ Tag_ABI_optimization_goals
	.ARM_attribute	16, 1	@ Tag_AV_eba
