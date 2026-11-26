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
	.file	"am_demod.c"
	.section	.text.am_demod_init,"ax",%progbits
	.hidden	am_demod_init                   @ -- Begin function am_demod_init
	.globl	am_demod_init
	.p2align	3
	.type	am_demod_init,%function
	.code	16                              @ @am_demod_init
	.thumb_func
am_demod_init:
	.fnstart
	.cfi_sections .debug_frame
	.cfi_startproc
@ %bb.0:
	.save	{r4, r5, r6, lr}
	push	{r4, r5, r6, lr}
	.cfi_def_cfa_offset 16
	.cfi_offset lr, -4
	.cfi_offset r6, -8
	.cfi_offset r5, -12
	.cfi_offset r4, -16
	movw	r4, :lower16:.L_MergedGlobals.1
	movw	r6, :lower16:.L_MergedGlobals
	movt	r4, :upper16:.L_MergedGlobals.1
	movt	r6, :upper16:.L_MergedGlobals
	movs	r5, #0
	movs	r0, #1
	strb	r0, [r6]
	mov.w	r0, #1065353216
	strd	r0, r0, [r6, #4]
	strd	r5, r0, [r6, #12]
	strd	r0, r5, [r4, #80]
	movw	r0, :lower16:s_audio_buf
	mov.w	r1, #8192
	movt	r0, :upper16:s_audio_buf
	strh	r5, [r4]
	strd	r5, r5, [r4, #16]
	strd	r5, r5, [r4, #24]
	strd	r5, r5, [r4, #32]
	strd	r5, r5, [r4, #40]
	strb	r5, [r4, #2]
	strb	r5, [r4, #3]
	strd	r5, r5, [r4, #48]
	strd	r5, r5, [r4, #56]
	strd	r5, r5, [r4, #64]
	strd	r5, r5, [r4, #72]
	strh	r5, [r4, #8]
	strh	r5, [r4, #10]
	strh	r5, [r4, #12]
	strh	r5, [r4, #14]
	bl	__aeabi_memclr4
	movs	r0, #0
	bl	setup_filters
	movw	r1, :lower16:.L_MergedGlobals.2
	movw	r0, #53612
	movt	r1, :upper16:.L_MergedGlobals.2
	movw	r2, #53612
	movt	r0, #16254
	movt	r2, #49150
	strd	r0, r2, [r1]
	movw	r2, #53452
	str	r0, [r1, #8]
	movw	r0, #41486
	movt	r2, #49150
	movt	r0, #16253
	str	r5, [r1, #20]
	strd	r2, r0, [r1, #12]
	ldrb	r0, [r4, #1]
	str	r5, [r1, #32]
	strd	r5, r5, [r1, #24]
	cmp	r0, #4
	ldr	r1, [r6, #20]
	beq	.LBB0_5
@ %bb.1:
	cmp	r0, #3
	beq	.LBB0_4
@ %bb.2:
	cmp	r0, #2
	bne	.LBB0_6
@ %bb.3:
	addw	r1, r1, #3000
	movs	r6, #255
	mov.w	r5, #4096
	b	.LBB0_7
	.p2align	2
.LBB0_4:
	subw	r1, r1, #3000
	movs	r6, #1
	mov.w	r5, #4096
	b	.LBB0_7
	.p2align	2
.LBB0_5:
	sub.w	r1, r1, #600
	movs	r6, #1
	movw	r5, #1638
	b	.LBB0_7
	.p2align	2
.LBB0_6:
	movs	r6, #0
.LBB0_7:
	movw	r2, #20352
	lsls	r0, r1, #16
	lsrs	r1, r1, #16
	movt	r2, #18
	movs	r3, #0
	bl	__aeabi_uldivmod
	str	r0, [r4, #88]
	str	r5, [r4, #64]
	strb	r6, [r4, #2]
	pop	{r4, r5, r6, pc}
.Lfunc_end0:
	.size	am_demod_init, .Lfunc_end0-am_demod_init
	.cfi_endproc
	.cantunwind
	.fnend
                                        @ -- End function
	.section	.text.setup_filters,"ax",%progbits
	.p2align	3                               @ -- Begin function setup_filters
	.type	setup_filters,%function
	.code	16                              @ @setup_filters
	.thumb_func
setup_filters:
	.fnstart
	.cfi_startproc
@ %bb.0:
	vmov.f32	s0, #1.000000e+00
	movw	r12, :lower16:.L_MergedGlobals.1
	cmp	r0, #4
	movt	r12, :upper16:.L_MergedGlobals.1
	vldr	s2, __arm_cp.1_3
	mov.w	r1, #1
	vseleq.f32	s0, s2, s0
	strh.w	r1, [r12, #4]
	movs	r1, #0
	cmp	r0, #1
	strb.w	r1, [r12, #6]
	movw	r1, :lower16:.L_MergedGlobals
	vldr	s2, __arm_cp.1_4
	movt	r1, :upper16:.L_MergedGlobals
	vseleq.f32	s0, s2, s0
	cmp	r0, #4
	vstr	s0, [r1, #8]
	bhi.w	.LBB1_12
@ %bb.1:
	.save	{r4, r5, r6, r7, r8, r9, r10, lr}
	push.w	{r4, r5, r6, r7, r8, r9, r10, lr}
	.cfi_def_cfa_offset 32
	.cfi_offset lr, -4
	.cfi_offset r10, -8
	.cfi_offset r9, -12
	.cfi_offset r8, -16
	.cfi_offset r7, -20
	.cfi_offset r6, -24
	.cfi_offset r5, -28
	.cfi_offset r4, -32
.LCPI1_2:
	tbh	[pc, r0, lsl #1]
@ %bb.2:
.LJTI1_0:
	.short	(.LBB1_7-(.LCPI1_2+4))/2
	.short	(.LBB1_8-(.LCPI1_2+4))/2
	.short	(.LBB1_3-(.LCPI1_2+4))/2
	.short	(.LBB1_3-(.LCPI1_2+4))/2
	.short	(.LBB1_6-(.LCPI1_2+4))/2
	.p2align	1
	.p2align	2
.LBB1_3:
	movw	r4, :lower16:s_i_lpf
	movw	r1, #53026
	movt	r4, :upper16:s_i_lpf
	movw	lr, #53026
	movw	r8, #44711
	movw	r9, #41919
	movw	r7, #9383
	movw	r5, #62905
	movw	r6, #13019
	movw	r3, #56274
	movt	r1, #14321
	movt	lr, #14449
	strd	r1, lr, [r4]
	movt	r8, #49068
	str	r1, [r4, #8]
	movt	r9, #16107
	movs	r0, #0
	strd	r8, r9, [r4, #12]
	strd	r0, r0, [r4, #20]
	strd	r0, r0, [r4, #28]
	mov.w	r2, #1065353216
	str	r2, [r4, #36]
	mov.w	r10, #1073741824
	str.w	r10, [r4, #40]
	movt	r7, #49082
	str	r2, [r4, #44]
	movt	r5, #16146
	movt	r6, #49111
	strd	r7, r5, [r4, #48]
	strd	r0, r0, [r4, #56]
	strd	r0, r0, [r4, #64]
	strd	r2, r10, [r4, #72]
	str	r2, [r4, #80]
	movt	r3, #16209
	strd	r6, r3, [r4, #84]
	strd	r0, r0, [r4, #92]
	strd	r0, r0, [r4, #100]
	movw	r4, :lower16:s_q_lpf
	strb.w	r0, [r12, #4]
	movt	r4, :upper16:s_q_lpf
	strd	r1, lr, [r4]
	add.w	lr, r4, #8
	str	r0, [r4, #104]
	strd	r2, r7, [r4, #44]
	stm.w	lr, {r1, r8, r9}
	add.w	r1, r4, #68
	movw	r7, #12802
	strd	r3, r0, [r4, #88]
	stm.w	r1, {r0, r2, r10}
	movw	r1, :lower16:s_i_hpf
	movw	r3, #12802
	movt	r1, :upper16:s_i_hpf
	movt	r3, #16243
	movt	r7, #49139
	strd	r3, r7, [r1]
	movw	r7, #55646
	str	r3, [r1, #8]
	movw	r3, #5183
	movt	r7, #49142
	movt	r3, #16238
	str	r2, [r1, #36]
	strd	r7, r3, [r1, #12]
	mov.w	r3, #-1073741824
	str	r3, [r1, #40]
	movw	r3, #1070
	movw	r7, #27625
	strd	r0, r0, [r1, #20]
	strd	r0, r0, [r1, #64]
	strd	r0, r0, [r1, #28]
	movt	r3, #49148
	str	r2, [r1, #44]
	movt	r7, #16248
	strd	r3, r7, [r1, #48]
	strd	r0, r0, [r1, #56]
	movw	r1, :lower16:.L_MergedGlobals.2
	movw	r3, #46600
	movt	r1, :upper16:.L_MergedGlobals.2
	movw	r7, #46600
	movt	r3, #14964
	movt	r7, #15092
	strd	r3, r7, [r1, #36]
	movw	r7, #48169
	str	r3, [r1, #44]
	movw	r3, #34553
	movt	r7, #49070
	strd	r2, r10, [r4, #36]
	strd	r2, r6, [r4, #80]
	movt	r3, #16116
	str	r2, [r1, #80]
	strd	r7, r3, [r1, #48]
	strd	r2, r10, [r1, #72]
	movw	r3, #19731
	movw	r2, #39147
	strd	r0, r0, [r4, #20]
	strd	r0, r0, [r4, #28]
	strd	r5, r0, [r4, #52]
	strd	r0, r0, [r4, #60]
	strd	r0, r0, [r4, #96]
	strd	r0, r0, [r1, #56]
	strd	r0, r0, [r1, #100]
	strd	r0, r0, [r1, #64]
	movt	r3, #49102
	movt	r2, #16190
	strd	r3, r2, [r1, #84]
	strd	r0, r0, [r1, #92]
	b	.LBB1_9
	.p2align	2
@ %bb.4:
__arm_cp.1_3:
	.long	0x3f4ccccd                      @ float 0.800000011
.Lcpi_end0:
	.size	__arm_cp.1_3, .Lcpi_end0-__arm_cp.1_3
	.p2align	2
@ %bb.5:
__arm_cp.1_4:
	.long	0x3eb33333                      @ float 0.349999994
.Lcpi_end1:
	.size	__arm_cp.1_4, .Lcpi_end1-__arm_cp.1_4
	.p2align	2
.LBB1_6:
	movw	r1, :lower16:s_i_lpf
	movw	r3, #13222
	movt	r1, :upper16:s_i_lpf
	movw	lr, #13222
	movw	r8, #15208
	movw	r9, #61029
	movw	r10, #52182
	movw	r4, #5756
	movw	r6, #8617
	movw	r7, #53077
	movt	r3, #12633
	movt	lr, #12761
	strd	r3, lr, [r1]
	movt	r8, #49133
	str	r3, [r1, #8]
	movt	r9, #16219
	movs	r0, #0
	strd	r8, r9, [r1, #12]
	strd	r0, r0, [r1, #20]
	strd	r0, r0, [r1, #28]
	mov.w	r2, #1065353216
	str	r2, [r1, #36]
	mov.w	r5, #1073741824
	str	r5, [r1, #40]
	movt	r10, #49137
	str	r2, [r1, #44]
	movt	r4, #16229
	movt	r6, #49146
	strd	r10, r4, [r1, #48]
	strd	r0, r0, [r1, #56]
	strd	r0, r0, [r1, #64]
	strd	r2, r5, [r1, #72]
	str	r2, [r1, #80]
	movt	r7, #16245
	strd	r6, r7, [r1, #84]
	strd	r0, r0, [r1, #92]
	strd	r0, r0, [r1, #100]
	movw	r1, :lower16:s_q_lpf
	strb.w	r0, [r12, #4]
	movt	r1, :upper16:s_q_lpf
	strd	r3, lr, [r1]
	add.w	lr, r1, #8
	strd	r0, r0, [r1, #20]
	stm.w	lr, {r3, r8, r9}
	add.w	r3, r1, #68
	strd	r0, r0, [r1, #28]
	strd	r2, r5, [r1, #36]
	strd	r2, r10, [r1, #44]
	strd	r4, r0, [r1, #52]
	strd	r0, r0, [r1, #60]
	stm	r3!, {r0, r2, r5}
	add.w	r3, r1, #80
	strd	r0, r0, [r1, #92]
	strd	r0, r0, [r1, #100]
	movw	r1, :lower16:s_i_hpf
	movt	r1, :upper16:s_i_hpf
	stm	r3!, {r2, r6, r7}
	movw	r3, #12802
	movw	r7, #12802
	movt	r3, #16243
	movt	r7, #49139
	strd	r3, r7, [r1]
	movw	r7, #55646
	str	r3, [r1, #8]
	movw	r3, #5183
	movt	r7, #49142
	movt	r3, #16238
	str	r2, [r1, #36]
	strd	r7, r3, [r1, #12]
	mov.w	r3, #-1073741824
	str	r3, [r1, #40]
	movw	r3, #1070
	str	r2, [r1, #44]
	movw	r2, #27625
	movt	r3, #49148
	strd	r0, r0, [r1, #20]
	strd	r0, r0, [r1, #64]
	strd	r0, r0, [r1, #28]
	movt	r2, #16248
	strd	r3, r2, [r1, #48]
	strd	r0, r0, [r1, #56]
	add.w	r0, r12, #6
	b	.LBB1_11
	.p2align	2
.LBB1_7:
	movw	r4, :lower16:s_i_lpf
	movw	r1, #9314
	movt	r4, :upper16:s_i_lpf
	movw	lr, #9314
	movw	r8, #34117
	movw	r9, #25504
	movw	r10, #53799
	movw	r5, #12097
	movw	r6, #6353
	movw	r7, #41535
	movt	r1, #14720
	movt	lr, #14848
	strd	r1, lr, [r4]
	movt	r8, #49034
	str	r1, [r4, #8]
	movt	r9, #16026
	movs	r0, #0
	strd	r8, r9, [r4, #12]
	strd	r0, r0, [r4, #20]
	strd	r0, r0, [r4, #28]
	mov.w	r2, #1065353216
	str	r2, [r4, #36]
	mov.w	r3, #1073741824
	str	r3, [r4, #40]
	movt	r10, #49048
	str	r2, [r4, #44]
	movt	r5, #16095
	movt	r6, #49082
	strd	r10, r5, [r4, #48]
	strd	r0, r0, [r4, #56]
	strd	r0, r0, [r4, #64]
	strd	r2, r3, [r4, #72]
	str	r2, [r4, #80]
	movt	r7, #16191
	strd	r6, r7, [r4, #84]
	strd	r0, r0, [r4, #92]
	strd	r0, r0, [r4, #100]
	movw	r4, :lower16:s_q_lpf
	strb.w	r0, [r12, #4]
	movt	r4, :upper16:s_q_lpf
	strd	r1, lr, [r4]
	add.w	lr, r4, #8
	strd	r2, r3, [r4, #36]
	stm.w	lr, {r1, r8, r9}
	add.w	r1, r4, #68
	strd	r2, r10, [r4, #44]
	stm	r1!, {r0, r2, r3}
	add.w	r1, r4, #80
	strd	r0, r0, [r4, #20]
	stm	r1!, {r2, r6, r7}
	movw	r1, :lower16:.L_MergedGlobals.2
	movw	r7, #38847
	movt	r1, :upper16:.L_MergedGlobals.2
	movw	r6, #38847
	movt	r7, #15229
	movt	r6, #15357
	strd	r7, r6, [r1, #36]
	movw	r6, #43178
	str	r7, [r1, #44]
	movw	r7, #44292
	str	r2, [r1, #80]
	strd	r2, r3, [r1, #72]
	movw	r3, #35124
	movw	r2, #15112
	strd	r0, r0, [r4, #28]
	strd	r5, r0, [r4, #52]
	strd	r0, r0, [r4, #60]
	strd	r0, r0, [r4, #92]
	strd	r0, r0, [r4, #100]
	movt	r6, #49036
	movt	r7, #16036
	strd	r6, r7, [r1, #48]
	strd	r0, r0, [r1, #56]
	strd	r0, r0, [r1, #100]
	strd	r0, r0, [r1, #64]
	movt	r3, #49071
	movt	r2, #16166
	strd	r3, r2, [r1, #84]
	strd	r0, r0, [r1, #92]
	b	.LBB1_10
	.p2align	2
.LBB1_8:
	movw	r2, :lower16:s_i_hpf
	movw	r0, #12802
	movt	r2, :upper16:s_i_hpf
	movw	r1, #12802
	movt	r0, #16243
	movt	r1, #49139
	strd	r0, r1, [r2]
	movw	r1, #55646
	str	r0, [r2, #8]
	movw	r0, #5183
	mov.w	r3, #-1073741824
	str	r3, [r2, #40]
	movw	r3, #1070
	movw	r7, #27625
	movt	r1, #49142
	movt	r0, #16238
	movt	r3, #49148
	strd	r1, r0, [r2, #12]
	movs	r0, #0
	mov.w	r1, #1065353216
	strd	r0, r0, [r2, #20]
	strd	r0, r0, [r2, #28]
	str	r1, [r2, #36]
	movt	r7, #16248
	str	r1, [r2, #44]
	strd	r3, r7, [r2, #48]
	strd	r0, r0, [r2, #56]
	strd	r0, r0, [r2, #64]
	movw	r2, :lower16:.L_MergedGlobals.2
	movw	r3, #46600
	movt	r2, :upper16:.L_MergedGlobals.2
	movw	r7, #46600
	movt	r3, #14964
	movt	r7, #15092
	strd	r3, r7, [r2, #36]
	movw	r7, #48169
	str	r3, [r2, #44]
	movw	r3, #34553
	movt	r7, #49070
	movt	r3, #16116
	str	r1, [r2, #72]
	strd	r7, r3, [r2, #48]
	mov.w	r3, #1073741824
	str	r3, [r2, #76]
	movw	r3, #19731
	str	r1, [r2, #80]
	movw	r1, #39147
	movt	r3, #49102
	strd	r0, r0, [r2, #56]
	strd	r0, r0, [r2, #64]
	movt	r1, #16190
	strd	r3, r1, [r2, #84]
	strd	r0, r0, [r2, #92]
	strd	r0, r0, [r2, #100]
.LBB1_9:
	movs	r0, #1
	strb.w	r0, [r12, #6]
.LBB1_10:
	add.w	r0, r12, #5
.LBB1_11:
	movs	r1, #1
	strb	r1, [r0]
	pop.w	{r4, r5, r6, r7, r8, r9, r10, lr}
.LBB1_12:
	bx	lr
@ %bb.13:
.Lfunc_end1:
	.size	setup_filters, .Lfunc_end1-setup_filters
	.cfi_endproc
	.cantunwind
	.fnend
                                        @ -- End function
	.section	.text.am_demod_set_freq,"ax",%progbits
	.hidden	am_demod_set_freq               @ -- Begin function am_demod_set_freq
	.globl	am_demod_set_freq
	.p2align	3
	.type	am_demod_set_freq,%function
	.code	16                              @ @am_demod_set_freq
	.thumb_func
am_demod_set_freq:
	.fnstart
	.cfi_startproc
@ %bb.0:
	.save	{r4, r5, r6, lr}
	push	{r4, r5, r6, lr}
	.cfi_def_cfa_offset 16
	.cfi_offset lr, -4
	.cfi_offset r6, -8
	.cfi_offset r5, -12
	.cfi_offset r4, -16
	movw	r4, :lower16:.L_MergedGlobals.1
	movw	r2, :lower16:.L_MergedGlobals
	movt	r4, :upper16:.L_MergedGlobals.1
	movt	r2, :upper16:.L_MergedGlobals
	ldrb	r1, [r4, #1]
	str	r0, [r2, #20]
	cmp	r1, #4
	beq	.LBB2_5
@ %bb.1:
	cmp	r1, #3
	beq	.LBB2_4
@ %bb.2:
	cmp	r1, #2
	bne	.LBB2_6
@ %bb.3:
	addw	r0, r0, #3000
	movs	r5, #255
	mov.w	r6, #4096
	b	.LBB2_7
	.p2align	2
.LBB2_4:
	subw	r0, r0, #3000
	movs	r5, #1
	mov.w	r6, #4096
	b	.LBB2_7
	.p2align	2
.LBB2_5:
	sub.w	r0, r0, #600
	movs	r5, #1
	movw	r6, #1638
	b	.LBB2_7
	.p2align	2
.LBB2_6:
	movs	r6, #0
	movs	r5, #0
.LBB2_7:
	lsl.w	r12, r0, #16
	movw	r2, #20352
	lsrs	r1, r0, #16
	movt	r2, #18
	movs	r3, #0
	mov	r0, r12
	bl	__aeabi_uldivmod
	str	r0, [r4, #88]
	str	r6, [r4, #64]
	strb	r5, [r4, #2]
	pop	{r4, r5, r6, pc}
.Lfunc_end2:
	.size	am_demod_set_freq, .Lfunc_end2-am_demod_set_freq
	.cfi_endproc
	.cantunwind
	.fnend
                                        @ -- End function
	.section	.text.am_demod_get_freq,"ax",%progbits
	.hidden	am_demod_get_freq               @ -- Begin function am_demod_get_freq
	.globl	am_demod_get_freq
	.p2align	3
	.type	am_demod_get_freq,%function
	.code	16                              @ @am_demod_get_freq
	.thumb_func
am_demod_get_freq:
	.fnstart
	.cfi_startproc
@ %bb.0:
	movw	r0, :lower16:.L_MergedGlobals
	movt	r0, :upper16:.L_MergedGlobals
	ldr	r0, [r0, #20]
	bx	lr
.Lfunc_end3:
	.size	am_demod_get_freq, .Lfunc_end3-am_demod_get_freq
	.cfi_endproc
	.cantunwind
	.fnend
                                        @ -- End function
	.section	.text.am_demod_set_mode,"ax",%progbits
	.hidden	am_demod_set_mode               @ -- Begin function am_demod_set_mode
	.globl	am_demod_set_mode
	.p2align	3
	.type	am_demod_set_mode,%function
	.code	16                              @ @am_demod_set_mode
	.thumb_func
am_demod_set_mode:
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
	movw	r4, :lower16:.L_MergedGlobals.1
	cmp	r0, #4
	it	hi
	movhi	r0, #0
	movt	r4, :upper16:.L_MergedGlobals.1
	strb	r0, [r4, #1]
	bl	setup_filters
	movw	r8, :lower16:.L_MergedGlobals
	ldrb	r0, [r4, #1]
	movt	r8, :upper16:.L_MergedGlobals
	cmp	r0, #4
	ldr.w	r1, [r8, #20]
	beq	.LBB4_5
@ %bb.1:
	cmp	r0, #3
	beq	.LBB4_4
@ %bb.2:
	cmp	r0, #2
	bne	.LBB4_6
@ %bb.3:
	addw	r1, r1, #3000
	movs	r7, #255
	mov.w	r6, #4096
	b	.LBB4_7
	.p2align	2
.LBB4_4:
	subw	r1, r1, #3000
	movs	r7, #1
	mov.w	r6, #4096
	b	.LBB4_7
	.p2align	2
.LBB4_5:
	sub.w	r1, r1, #600
	movs	r7, #1
	movw	r6, #1638
	b	.LBB4_7
	.p2align	2
.LBB4_6:
	movs	r6, #0
	movs	r7, #0
.LBB4_7:
	movw	r2, #20352
	lsls	r0, r1, #16
	lsrs	r1, r1, #16
	movt	r2, #18
	movs	r3, #0
	movs	r5, #0
	bl	__aeabi_uldivmod
	str	r0, [r4, #88]
	mov.w	r0, #1065353216
	strb	r7, [r4, #2]
	strd	r5, r5, [r4, #20]
	strd	r5, r5, [r4, #28]
	strd	r5, r5, [r4, #36]
	str.w	r0, [r8, #4]
	strd	r5, r5, [r4, #52]
	strd	r5, r6, [r4, #60]
	strd	r5, r5, [r4, #68]
	strd	r5, r0, [r4, #76]
	str	r5, [r4, #84]
	strd	r5, r0, [r8, #12]
	pop.w	{r4, r5, r6, r7, r8, pc}
.Lfunc_end4:
	.size	am_demod_set_mode, .Lfunc_end4-am_demod_set_mode
	.cfi_endproc
	.cantunwind
	.fnend
                                        @ -- End function
	.section	.text.am_demod_get_mode,"ax",%progbits
	.hidden	am_demod_get_mode               @ -- Begin function am_demod_get_mode
	.globl	am_demod_get_mode
	.p2align	3
	.type	am_demod_get_mode,%function
	.code	16                              @ @am_demod_get_mode
	.thumb_func
am_demod_get_mode:
	.fnstart
	.cfi_startproc
@ %bb.0:
	movw	r0, :lower16:.L_MergedGlobals.1
	movt	r0, :upper16:.L_MergedGlobals.1
	ldrb	r0, [r0, #1]
	bx	lr
.Lfunc_end5:
	.size	am_demod_get_mode, .Lfunc_end5-am_demod_get_mode
	.cfi_endproc
	.cantunwind
	.fnend
                                        @ -- End function
	.section	.text.am_demod_enable,"ax",%progbits
	.hidden	am_demod_enable                 @ -- Begin function am_demod_enable
	.globl	am_demod_enable
	.p2align	3
	.type	am_demod_enable,%function
	.code	16                              @ @am_demod_enable
	.thumb_func
am_demod_enable:
	.fnstart
	.cfi_startproc
@ %bb.0:
	movw	r1, :lower16:.L_MergedGlobals.1
	cmp	r0, #0
	movt	r1, :upper16:.L_MergedGlobals.1
	strb	r0, [r1]
	it	eq
	bxeq	lr
.LBB6_1:
	movw	r2, :lower16:.L_MergedGlobals
	movs	r0, #0
	movt	r2, :upper16:.L_MergedGlobals
	str	r0, [r1, #40]
	strd	r0, r0, [r1, #16]
	strd	r0, r0, [r1, #24]
	strd	r0, r0, [r1, #32]
	mov.w	r3, #1065353216
	str	r3, [r2, #4]
	strd	r0, r0, [r1, #48]
	strd	r0, r0, [r1, #56]
	strd	r0, r0, [r1, #68]
	strd	r0, r3, [r1, #76]
	str	r0, [r1, #84]
	strd	r0, r3, [r2, #12]
	strh	r0, [r1, #12]
	strh	r0, [r1, #14]
	ldrb	r0, [r1, #1]
	b	setup_filters
.Lfunc_end6:
	.size	am_demod_enable, .Lfunc_end6-am_demod_enable
	.cfi_endproc
	.cantunwind
	.fnend
                                        @ -- End function
	.section	.text.am_demod_is_enabled,"ax",%progbits
	.hidden	am_demod_is_enabled             @ -- Begin function am_demod_is_enabled
	.globl	am_demod_is_enabled
	.p2align	3
	.type	am_demod_is_enabled,%function
	.code	16                              @ @am_demod_is_enabled
	.thumb_func
am_demod_is_enabled:
	.fnstart
	.cfi_startproc
@ %bb.0:
	movw	r0, :lower16:.L_MergedGlobals.1
	movt	r0, :upper16:.L_MergedGlobals.1
	ldrb	r0, [r0]
	bx	lr
.Lfunc_end7:
	.size	am_demod_is_enabled, .Lfunc_end7-am_demod_is_enabled
	.cfi_endproc
	.cantunwind
	.fnend
                                        @ -- End function
	.section	.text.am_demod_input,"ax",%progbits
	.hidden	am_demod_input                  @ -- Begin function am_demod_input
	.globl	am_demod_input
	.p2align	3
	.type	am_demod_input,%function
	.code	16                              @ @am_demod_input
	.thumb_func
am_demod_input:
	.fnstart
	.cfi_startproc
@ %bb.0:
	movw	r12, :lower16:.L_MergedGlobals.1
	movt	r12, :upper16:.L_MergedGlobals.1
	ldrb.w	r2, [r12]
	cmp	r2, #0
	beq.w	.LBB8_10
@ %bb.1:
	.save	{r7, lr}
	push	{r7, lr}
	.cfi_def_cfa_offset 8
	.cfi_offset lr, -4
	.cfi_offset r7, -8
	ldr.w	r2, [r12, #16]
	movw	lr, :lower16:sin_lut
	add.w	r3, r2, #16384
	movt	lr, :upper16:sin_lut
	ubfx	r1, r2, #8, #8
	ubfx	r3, r3, #8, #8
	ldrsh.w	r1, [lr, r1, lsl #1]
	ldrsh.w	r3, [lr, r3, lsl #1]
	muls	r3, r0, r3
	muls	r0, r1, r0
	asrs	r1, r3, #15
	vmov	s0, r1
	asrs	r3, r0, #15
	ldrb.w	r0, [r12, #1]
	vcvt.f32.s32	s4, s0
	vmov	s0, r3
	subs	r1, r0, #2
	ldr.w	r3, [r12, #88]
	cmp	r1, #3
	add.w	r1, r3, r2
	vcvt.f32.s32	s6, s0
	str.w	r1, [r12, #16]
	bhs	.LBB8_3
@ %bb.2:
	vldr	s8, [r12, #40]
	vsub.f32	s0, s6, s8
	vldr	s6, [r12, #28]
	vsub.f32	s2, s4, s6
	vldr	s4, .LCPI8_0
	vfma.f32	s8, s0, s4
	vldr	s0, [r12, #36]
	vfma.f32	s6, s2, s4
	vldr	s2, [r12, #24]
	vstr	s8, [r12, #40]
	vstr	s6, [r12, #28]
	vsub.f32	s10, s8, s0
	vsub.f32	s12, s6, s2
	vfma.f32	s0, s10, s4
	vfma.f32	s2, s12, s4
	vstr	s0, [r12, #36]
	vstr	s2, [r12, #20]
	vstr	s2, [r12, #24]
	b	.LBB8_6
	.p2align	2
.LBB8_3:
	cmp	r0, #1
	bne	.LBB8_5
@ %bb.4:
	vldr	s2, [r12, #20]
	vldr	s0, [r12, #32]
	vsub.f32	s4, s4, s2
	vldr	s8, .LCPI8_1
	vsub.f32	s6, s6, s0
	vfma.f32	s2, s4, s8
	vfma.f32	s0, s6, s8
	vstr	s2, [r12, #20]
	vstr	s0, [r12, #32]
	b	.LBB8_7
	.p2align	2
.LBB8_5:
	vldr	s8, [r12, #40]
	vldr	s10, [r12, #36]
	vsub.f32	s0, s6, s8
	vldr	s6, [r12, #28]
	vsub.f32	s2, s4, s6
	vldr	s4, .LCPI8_0
	vldr	s12, [r12, #24]
	vfma.f32	s8, s0, s4
	vfma.f32	s6, s2, s4
	vstr	s8, [r12, #40]
	vstr	s6, [r12, #28]
	vsub.f32	s0, s8, s10
	vsub.f32	s2, s6, s12
	vfma.f32	s10, s0, s4
	vldr	s0, [r12, #32]
	vfma.f32	s12, s2, s4
	vldr	s2, [r12, #20]
	vstr	s10, [r12, #36]
	vstr	s12, [r12, #24]
	vsub.f32	s14, s10, s0
	vsub.f32	s1, s12, s2
	vfma.f32	s0, s14, s4
	vfma.f32	s2, s1, s4
	vstr	s2, [r12, #20]
.LBB8_6:
	vcvt.s32.f32	s4, s2
	vstr	s0, [r12, #32]
	vcvt.s32.f32	s6, s0
	vmov	r0, s4
	vmov	r2, s6
	cmp	r0, #0
	it	mi
	rsbmi	r0, r0, #0
	cmp	r2, #0
	it	mi
	rsbmi	r2, r2, #0
	mov	r1, r2
	cmp	r0, r2
	it	hi
	movhi	r1, r0
	it	lo
	movlo	r2, r0
	add.w	r0, r1, r2, lsr #1
	str.w	r0, [r12, #44]
.LBB8_7:
	ldr.w	r0, [r12, #48]
	adds	r0, #1
	str.w	r0, [r12, #48]
	cmp	r0, #25
	pop.w	{r7, lr}
	blo	.LBB8_10
@ %bb.8:
	movs	r0, #0
	str.w	r0, [r12, #48]
	ldrh.w	r0, [r12, #14]
	ldrh.w	r1, [r12, #12]
	adds	r0, #1
	bfc	r0, #10, #22
	cmp	r0, r1
	it	eq
	bxeq	lr
.LBB8_9:
	ldrh.w	r1, [r12, #14]
	vcvt.s32.f32	s2, s2
	movw	r2, :lower16:s_iq_queue
	vcvt.s32.f32	s0, s0
	movt	r2, :upper16:s_iq_queue
	add.w	r1, r1, r1, lsl #1
	vmov	r3, s2
	str.w	r3, [r2, r1, lsl #2]
	ldrh.w	r1, [r12, #14]
	add.w	r1, r1, r1, lsl #1
	add.w	r1, r2, r1, lsl #2
	vstr	s0, [r1, #4]
	ldr.w	r1, [r12, #44]
	ldrh.w	r3, [r12, #14]
	add.w	r3, r3, r3, lsl #1
	add.w	r2, r2, r3, lsl #2
	str	r1, [r2, #8]
	strh.w	r0, [r12, #14]
.LBB8_10:
	bx	lr
	.p2align	2
@ %bb.11:
.LCPI8_0:
	.long	0x3d800000                      @ float 0.0625
.LCPI8_1:
	.long	0x3e051eb8                      @ float 0.129999995
.Lfunc_end8:
	.size	am_demod_input, .Lfunc_end8-am_demod_input
	.cfi_endproc
	.cantunwind
	.fnend
                                        @ -- End function
	.section	.text.am_demod_poll,"ax",%progbits
	.hidden	am_demod_poll                   @ -- Begin function am_demod_poll
	.globl	am_demod_poll
	.p2align	3
	.type	am_demod_poll,%function
	.code	16                              @ @am_demod_poll
	.thumb_func
am_demod_poll:
	.fnstart
	.cfi_startproc
@ %bb.0:
	movw	r12, :lower16:.L_MergedGlobals.1
	movt	r12, :upper16:.L_MergedGlobals.1
	ldrh.w	r1, [r12, #12]
	ldrh.w	r0, [r12, #14]
	cmp	r1, r0
	bne	.LBB9_2
@ %bb.1:
	movs	r0, #0
	bx	lr
	.p2align	2
.LBB9_2:
	.save	{r7, lr}
	push	{r7, lr}
	.cfi_def_cfa_offset 8
	.cfi_offset lr, -4
	.cfi_offset r7, -8
	add.w	r0, r1, r1, lsl #1
	movw	r2, :lower16:s_iq_queue
	movt	r2, :upper16:s_iq_queue
	ldrb.w	r3, [r12, #1]
	add.w	lr, r2, r0, lsl #2
	ldr.w	r2, [r2, r0, lsl #2]
	adds	r0, r1, #1
	bfc	r0, #10, #22
	strh.w	r0, [r12, #12]
	cmp	r3, #4
	ldrd	r1, r0, [lr, #4]
	bhi.w	.LBB9_21
@ %bb.3:
.LCPI9_24:
	tbh	[pc, r3, lsl #1]
@ %bb.4:
.LJTI9_0:
	.short	(.LBB9_14-(.LCPI9_24+4))/2
	.short	(.LBB9_18-(.LCPI9_24+4))/2
	.short	(.LBB9_5-(.LCPI9_24+4))/2
	.short	(.LBB9_5-(.LCPI9_24+4))/2
	.short	(.LBB9_10-(.LCPI9_24+4))/2
	.p2align	1
	.p2align	2
.LBB9_5:
	vmov	s0, r2
	ldrb.w	r0, [r12, #4]
	cmp	r0, #0
	vcvt.f32.s32	s2, s0
	vmov	s0, r1
	vcvt.f32.s32	s0, s0
	bne.w	.LBB9_7
@ %bb.6:
	movw	r1, :lower16:s_i_lpf
	movw	r2, :lower16:s_q_lpf
	movt	r1, :upper16:s_i_lpf
	movt	r2, :upper16:s_q_lpf
	vldr	s4, [r1, #4]
	vldr	s14, [r2, #20]
	vldr	s10, [r1, #20]
	vldr	s12, [r1, #8]
	vmul.f32	s6, s4, s10
	vldr	s4, [r1]
	vldr	s1, [r1, #24]
	vldr	s3, [r2, #24]
	vstr	s2, [r1, #20]
	vfma.f32	s6, s4, s2
	vldr	s4, [r2, #4]
	vmul.f32	s8, s4, s14
	vldr	s4, [r1, #12]
	vldr	s2, [r2, #12]
	vstr	s0, [r2, #20]
	vfma.f32	s6, s12, s1
	vldr	s12, [r2]
	vfma.f32	s8, s12, s0
	vldr	s1, [r1, #28]
	vldr	s12, [r1, #16]
	vldr	s0, [r1, #36]
	vfms.f32	s6, s4, s1
	vldr	s4, [r2, #8]
	vfma.f32	s8, s4, s3
	vldr	s4, [r1, #32]
	vstr	s10, [r1, #24]
	vldr	s10, [r2, #40]
	vfms.f32	s6, s12, s4
	vldr	s12, [r2, #28]
	vfms.f32	s8, s2, s12
	vldr	s2, [r2, #16]
	vldr	s4, [r2, #32]
	vstr	s1, [r1, #32]
	vstr	s14, [r2, #24]
	vldr	s14, [r1, #44]
	vfms.f32	s8, s2, s4
	vldr	s2, [r1, #56]
	vldr	s4, [r1, #40]
	vldr	s1, [r1, #60]
	vmul.f32	s4, s4, s2
	vstr	s12, [r2, #32]
	vldr	s12, [r1, #48]
	vldr	s3, [r2, #60]
	vstr	s6, [r1, #28]
	vfma.f32	s4, s0, s6
	vldr	s0, [r2, #56]
	vmul.f32	s10, s10, s0
	vstr	s6, [r1, #56]
	vldr	s6, [r2, #48]
	vstr	s2, [r1, #60]
	vfma.f32	s4, s14, s1
	vldr	s14, [r2, #36]
	vfma.f32	s10, s14, s8
	vldr	s1, [r1, #64]
	vldr	s14, [r2, #44]
	vstr	s0, [r2, #60]
	vfms.f32	s4, s12, s1
	vldr	s12, [r1, #52]
	vfma.f32	s10, s14, s3
	vldr	s14, [r1, #68]
	vldr	s2, [r2, #52]
	vldr	s0, [r1, #72]
	vfms.f32	s4, s12, s14
	vldr	s12, [r2, #64]
	vfms.f32	s10, s6, s12
	vldr	s6, [r2, #68]
	vldr	s14, [r2, #92]
	vstr	s8, [r2, #28]
	vstr	s1, [r1, #68]
	vldr	s1, [r1, #96]
	vfms.f32	s10, s2, s6
	vldr	s6, [r1, #92]
	vldr	s2, [r1, #76]
	vstr	s8, [r2, #56]
	vmul.f32	s2, s2, s6
	vldr	s8, [r1, #80]
	vstr	s12, [r2, #68]
	vldr	s12, [r2, #72]
	vldr	s3, [r2, #96]
	vstr	s4, [r1, #64]
	vfma.f32	s2, s0, s4
	vldr	s0, [r2, #76]
	vmul.f32	s0, s0, s14
	vstr	s4, [r1, #92]
	vldr	s4, [r2, #84]
	vstr	s6, [r1, #96]
	vfma.f32	s2, s8, s1
	vldr	s8, [r1, #84]
	vfma.f32	s0, s12, s10
	vldr	s1, [r1, #100]
	vldr	s12, [r1, #104]
	vldr	s6, [r2, #88]
	vfms.f32	s2, s8, s1
	vldr	s8, [r2, #80]
	vfma.f32	s0, s8, s3
	vldr	s8, [r1, #88]
	vstr	s10, [r2, #64]
	vfms.f32	s2, s8, s12
	vldr	s8, [r2, #100]
	vfms.f32	s0, s4, s8
	vldr	s4, [r2, #104]
	vstr	s1, [r1, #104]
	vstr	s2, [r1, #100]
	vfms.f32	s0, s6, s4
	vstr	s10, [r2, #92]
	vstr	s14, [r2, #96]
	vstr	s8, [r2, #104]
	vstr	s0, [r2, #100]
.LBB9_7:
	ldr.w	r1, [r12, #60]
	movw	r2, :lower16:sin_lut
	movt	r2, :upper16:sin_lut
	add.w	r3, r1, #16384
	ubfx	r0, r1, #8, #8
	vldr	s6, __arm_cp.9_25
	ldrsh.w	r0, [r2, r0, lsl #1]
	vmov	s4, r0
	ubfx	r0, r3, #8, #8
	ldrsb.w	r3, [r12, #2]
	vcvt.f32.s32	s4, s4
	ldrsh.w	r0, [r2, r0, lsl #1]
	cmp	r3, #0
	ldr.w	r2, [r12, #64]
	vmov	s10, r0
	ldrb.w	r0, [r12, #6]
	vmul.f32	s8, s4, s6
	vnmul.f32	s4, s4, s6
	vcvt.f32.s32	s10, s10
	vselgt.f32	s4, s4, s8
	cmp	r0, #1
	vmul.f32	s6, s10, s6
	add.w	r0, r2, r1
	str.w	r0, [r12, #60]
	vmul.f32	s0, s0, s4
	vfma.f32	s0, s2, s6
	bne	.LBB9_9
@ %bb.8:
	movw	r1, :lower16:s_i_hpf
	movt	r1, :upper16:s_i_hpf
	vldr	s2, [r1, #4]
	vldr	s6, [r1]
	vldr	s4, [r1, #20]
	vldr	s8, [r1, #24]
	vmul.f32	s2, s2, s4
	vldr	s10, [r1, #32]
	vstr	s0, [r1, #20]
	vldr	s12, [r1, #60]
	vstr	s4, [r1, #24]
	vldr	s4, [r1, #68]
	vfma.f32	s2, s6, s0
	vldr	s6, [r1, #8]
	vfma.f32	s2, s6, s8
	vldr	s6, [r1, #12]
	vldr	s8, [r1, #28]
	vstr	s8, [r1, #32]
	vfms.f32	s2, s6, s8
	vldr	s6, [r1, #16]
	vfms.f32	s2, s6, s10
	vldr	s6, [r1, #40]
	vldr	s10, [r1, #56]
	vstr	s10, [r1, #60]
	vmul.f32	s0, s6, s10
	vldr	s6, [r1, #36]
	vstr	s2, [r1, #28]
	vstr	s2, [r1, #56]
	vfma.f32	s0, s6, s2
	vldr	s6, [r1, #44]
	vfma.f32	s0, s6, s12
	vldr	s6, [r1, #48]
	vldr	s12, [r1, #64]
	vstr	s12, [r1, #68]
	vfms.f32	s0, s6, s12
	vldr	s6, [r1, #52]
	vfms.f32	s0, s6, s4
	vstr	s0, [r1, #64]
.LBB9_9:
	ldrb.w	r0, [r12, #5]
	cmp	r0, #1
	beq.w	.LBB9_17
	b	.LBB9_27
	.p2align	2
.LBB9_10:
	vmov	s0, r2
	ldrb.w	r0, [r12, #4]
	cmp	r0, #0
	vcvt.f32.s32	s2, s0
	vmov	s0, r1
	vcvt.f32.s32	s0, s0
	bne.w	.LBB9_12
@ %bb.11:
	movw	r1, :lower16:s_i_lpf
	movw	r2, :lower16:s_q_lpf
	movt	r1, :upper16:s_i_lpf
	movt	r2, :upper16:s_q_lpf
	vldr	s4, [r1, #4]
	vldr	s14, [r2, #20]
	vldr	s10, [r1, #20]
	vldr	s12, [r1, #8]
	vmul.f32	s6, s4, s10
	vldr	s4, [r1]
	vldr	s1, [r1, #24]
	vldr	s3, [r2, #24]
	vstr	s2, [r1, #20]
	vfma.f32	s6, s4, s2
	vldr	s4, [r2, #4]
	vmul.f32	s8, s4, s14
	vldr	s4, [r1, #12]
	vldr	s2, [r2, #12]
	vstr	s0, [r2, #20]
	vfma.f32	s6, s12, s1
	vldr	s12, [r2]
	vfma.f32	s8, s12, s0
	vldr	s1, [r1, #28]
	vldr	s12, [r1, #16]
	vldr	s0, [r1, #36]
	vfms.f32	s6, s4, s1
	vldr	s4, [r2, #8]
	vfma.f32	s8, s4, s3
	vldr	s4, [r1, #32]
	vstr	s10, [r1, #24]
	vldr	s10, [r2, #40]
	vfms.f32	s6, s12, s4
	vldr	s12, [r2, #28]
	vfms.f32	s8, s2, s12
	vldr	s2, [r2, #16]
	vldr	s4, [r2, #32]
	vstr	s1, [r1, #32]
	vstr	s14, [r2, #24]
	vldr	s14, [r1, #44]
	vfms.f32	s8, s2, s4
	vldr	s2, [r1, #56]
	vldr	s4, [r1, #40]
	vldr	s1, [r1, #60]
	vmul.f32	s4, s4, s2
	vstr	s12, [r2, #32]
	vldr	s12, [r1, #48]
	vldr	s3, [r2, #60]
	vstr	s6, [r1, #28]
	vfma.f32	s4, s0, s6
	vldr	s0, [r2, #56]
	vmul.f32	s10, s10, s0
	vstr	s6, [r1, #56]
	vldr	s6, [r2, #48]
	vstr	s2, [r1, #60]
	vfma.f32	s4, s14, s1
	vldr	s14, [r2, #36]
	vfma.f32	s10, s14, s8
	vldr	s1, [r1, #64]
	vldr	s14, [r2, #44]
	vstr	s0, [r2, #60]
	vfms.f32	s4, s12, s1
	vldr	s12, [r1, #52]
	vfma.f32	s10, s14, s3
	vldr	s14, [r1, #68]
	vldr	s2, [r2, #52]
	vldr	s0, [r1, #72]
	vfms.f32	s4, s12, s14
	vldr	s12, [r2, #64]
	vfms.f32	s10, s6, s12
	vldr	s6, [r2, #68]
	vldr	s14, [r2, #92]
	vstr	s8, [r2, #28]
	vstr	s1, [r1, #68]
	vldr	s1, [r1, #96]
	vfms.f32	s10, s2, s6
	vldr	s6, [r1, #92]
	vldr	s2, [r1, #76]
	vstr	s8, [r2, #56]
	vmul.f32	s2, s2, s6
	vldr	s8, [r1, #80]
	vstr	s12, [r2, #68]
	vldr	s12, [r2, #72]
	vldr	s3, [r2, #96]
	vstr	s4, [r1, #64]
	vfma.f32	s2, s0, s4
	vldr	s0, [r2, #76]
	vmul.f32	s0, s0, s14
	vstr	s4, [r1, #92]
	vldr	s4, [r2, #84]
	vstr	s6, [r1, #96]
	vfma.f32	s2, s8, s1
	vldr	s8, [r1, #84]
	vfma.f32	s0, s12, s10
	vldr	s1, [r1, #100]
	vldr	s12, [r1, #104]
	vldr	s6, [r2, #88]
	vfms.f32	s2, s8, s1
	vldr	s8, [r2, #80]
	vfma.f32	s0, s8, s3
	vldr	s8, [r1, #88]
	vstr	s10, [r2, #64]
	vfms.f32	s2, s8, s12
	vldr	s8, [r2, #100]
	vfms.f32	s0, s4, s8
	vldr	s4, [r2, #104]
	vstr	s1, [r1, #104]
	vstr	s2, [r1, #100]
	vfms.f32	s0, s6, s4
	vstr	s10, [r2, #92]
	vstr	s14, [r2, #96]
	vstr	s8, [r2, #104]
	vstr	s0, [r2, #100]
.LBB9_12:
	ldr.w	r1, [r12, #60]
	movw	r3, :lower16:sin_lut
	movt	r3, :upper16:sin_lut
	add.w	r0, r1, #16384
	ubfx	r2, r1, #8, #8
	vldr	s8, __arm_cp.9_26
	ubfx	r0, r0, #8, #8
	ldrsh.w	r2, [r3, r2, lsl #1]
	ldrsh.w	r0, [r3, r0, lsl #1]
	vmov	s4, r2
	ldr.w	r2, [r12, #64]
	vmov	s6, r0
	ldrb.w	r0, [r12, #6]
	vcvt.f32.s32	s4, s4
	cmp	r0, #1
	vcvt.f32.s32	s6, s6
	add.w	r0, r2, r1
	str.w	r0, [r12, #60]
	vmul.f32	s4, s4, s8
	vldr	s8, __arm_cp.9_25
	vmul.f32	s6, s6, s8
	vmul.f32	s0, s0, s4
	vfma.f32	s0, s2, s6
	beq.w	.LBB9_26
	b	.LBB9_27
	.p2align	2
@ %bb.13:
__arm_cp.9_25:
	.long	0x38000000                      @ float 3.05175781E-5
.Lcpi_end2:
	.size	__arm_cp.9_25, .Lcpi_end2-__arm_cp.9_25
	.p2align	2
.LBB9_14:
	vmov	s0, r2
	vmov	s2, r1
	ldrb.w	r0, [r12, #4]
	vcvt.f32.s32	s0, s0
	cmp	r0, #0
	vcvt.f32.s32	s2, s2
	bne.w	.LBB9_16
@ %bb.15:
	movw	r1, :lower16:s_i_lpf
	movw	r2, :lower16:s_q_lpf
	movt	r1, :upper16:s_i_lpf
	movt	r2, :upper16:s_q_lpf
	vldr	s4, [r1, #4]
	vldr	s14, [r2, #20]
	vldr	s10, [r1, #20]
	vldr	s12, [r1, #8]
	vmul.f32	s6, s4, s10
	vldr	s4, [r1]
	vldr	s1, [r1, #24]
	vldr	s3, [r2, #24]
	vstr	s0, [r1, #20]
	vfma.f32	s6, s4, s0
	vldr	s4, [r2, #4]
	vmul.f32	s8, s4, s14
	vldr	s4, [r1, #12]
	vldr	s0, [r2, #12]
	vstr	s2, [r2, #20]
	vfma.f32	s6, s12, s1
	vldr	s12, [r2]
	vfma.f32	s8, s12, s2
	vldr	s1, [r1, #28]
	vldr	s12, [r1, #16]
	vldr	s2, [r1, #36]
	vfms.f32	s6, s4, s1
	vldr	s4, [r2, #8]
	vfma.f32	s8, s4, s3
	vldr	s4, [r1, #32]
	vstr	s10, [r1, #24]
	vldr	s10, [r2, #40]
	vfms.f32	s6, s12, s4
	vldr	s12, [r2, #28]
	vfms.f32	s8, s0, s12
	vldr	s0, [r2, #16]
	vldr	s4, [r2, #32]
	vstr	s1, [r1, #32]
	vstr	s14, [r2, #24]
	vldr	s14, [r1, #44]
	vfms.f32	s8, s0, s4
	vldr	s0, [r1, #56]
	vldr	s4, [r1, #40]
	vldr	s1, [r1, #60]
	vmul.f32	s4, s4, s0
	vstr	s12, [r2, #32]
	vldr	s12, [r1, #48]
	vldr	s3, [r2, #60]
	vstr	s6, [r1, #28]
	vfma.f32	s4, s2, s6
	vldr	s2, [r2, #56]
	vmul.f32	s10, s10, s2
	vstr	s6, [r1, #56]
	vldr	s6, [r2, #48]
	vstr	s0, [r1, #60]
	vfma.f32	s4, s14, s1
	vldr	s14, [r2, #36]
	vfma.f32	s10, s14, s8
	vldr	s1, [r1, #64]
	vldr	s14, [r2, #44]
	vstr	s2, [r2, #60]
	vfms.f32	s4, s12, s1
	vldr	s12, [r1, #52]
	vfma.f32	s10, s14, s3
	vldr	s14, [r1, #68]
	vldr	s0, [r2, #52]
	vldr	s2, [r1, #72]
	vfms.f32	s4, s12, s14
	vldr	s12, [r2, #64]
	vfms.f32	s10, s6, s12
	vldr	s6, [r2, #68]
	vldr	s14, [r2, #92]
	vstr	s8, [r2, #28]
	vstr	s1, [r1, #68]
	vldr	s1, [r1, #96]
	vfms.f32	s10, s0, s6
	vldr	s6, [r1, #92]
	vldr	s0, [r1, #76]
	vstr	s8, [r2, #56]
	vmul.f32	s0, s0, s6
	vldr	s8, [r1, #80]
	vstr	s12, [r2, #68]
	vldr	s12, [r2, #72]
	vldr	s3, [r2, #96]
	vstr	s4, [r1, #64]
	vfma.f32	s0, s2, s4
	vldr	s2, [r2, #76]
	vmul.f32	s2, s2, s14
	vstr	s4, [r1, #92]
	vldr	s4, [r2, #84]
	vstr	s6, [r1, #96]
	vfma.f32	s0, s8, s1
	vldr	s8, [r1, #84]
	vfma.f32	s2, s12, s10
	vldr	s1, [r1, #100]
	vldr	s12, [r1, #104]
	vldr	s6, [r2, #88]
	vfms.f32	s0, s8, s1
	vldr	s8, [r2, #80]
	vfma.f32	s2, s8, s3
	vldr	s8, [r1, #88]
	vstr	s10, [r2, #64]
	vfms.f32	s0, s8, s12
	vldr	s8, [r2, #100]
	vfms.f32	s2, s4, s8
	vldr	s4, [r2, #104]
	vstr	s1, [r1, #104]
	vstr	s0, [r1, #100]
	vfms.f32	s2, s6, s4
	vstr	s10, [r2, #92]
	vstr	s14, [r2, #96]
	vstr	s8, [r2, #104]
	vstr	s2, [r2, #100]
.LBB9_16:
	vmul.f32	s2, s2, s2
	vfma.f32	s2, s0, s0
	vsqrt.f32	s0, s2
	ldrb.w	r0, [r12, #5]
	cmp	r0, #1
	bne.w	.LBB9_27
.LBB9_17:
	movw	r1, :lower16:.L_MergedGlobals.2
	movt	r1, :upper16:.L_MergedGlobals.2
	vldr	s2, [r1, #40]
	vldr	s6, [r1, #36]
	vldr	s4, [r1, #56]
	vldr	s8, [r1, #60]
	vmul.f32	s2, s2, s4
	vldr	s10, [r1, #68]
	vstr	s0, [r1, #56]
	vldr	s12, [r1, #96]
	vstr	s4, [r1, #60]
	vldr	s4, [r1, #104]
	vfma.f32	s2, s6, s0
	vldr	s6, [r1, #44]
	vfma.f32	s2, s6, s8
	vldr	s6, [r1, #48]
	vldr	s8, [r1, #64]
	vstr	s8, [r1, #68]
	vfms.f32	s2, s6, s8
	vldr	s6, [r1, #52]
	vfms.f32	s2, s6, s10
	vldr	s6, [r1, #76]
	vldr	s10, [r1, #92]
	vstr	s10, [r1, #96]
	vmul.f32	s0, s6, s10
	vldr	s6, [r1, #72]
	vstr	s2, [r1, #64]
	vstr	s2, [r1, #92]
	vfma.f32	s0, s6, s2
	vldr	s6, [r1, #80]
	vfma.f32	s0, s6, s12
	vldr	s6, [r1, #84]
	vldr	s12, [r1, #100]
	vstr	s12, [r1, #104]
	vfms.f32	s0, s6, s12
	vldr	s6, [r1, #88]
	vfms.f32	s0, s6, s4
	vstr	s0, [r1, #100]
	b	.LBB9_27
	.p2align	2
.LBB9_18:
	vmov	s0, r1
	vldr	s6, __arm_cp.9_27
	vcvt.f32.s32	s4, s0
	vmov	s0, r2
	vcvt.f32.s32	s2, s0
	vmul.f32	s0, s4, s4
	vfma.f32	s0, s2, s2
	vcmp.f32	s0, s6
	vmrs	APSR_nzcv, fpscr
	ble	.LBB9_22
@ %bb.19:
	vldr	s6, [r12, #52]
	vldr	s8, [r12, #56]
	vnmul.f32	s6, s2, s6
	vfma.f32	s6, s8, s4
	vdiv.f32	s0, s6, s0
	vldr	s6, __arm_cp.9_28
	vmul.f32	s0, s0, s6
	b	.LBB9_23
	.p2align	2
@ %bb.20:
__arm_cp.9_26:
	.long	0xb8000000                      @ float -3.05175781E-5
.Lcpi_end3:
	.size	__arm_cp.9_26, .Lcpi_end3-__arm_cp.9_26
	.p2align	2
.LBB9_21:
	vmov	s0, r0
	vcvt.f32.s32	s0, s0
	b	.LBB9_27
	.p2align	2
.LBB9_22:
	vldr	s2, __arm_cp.9_29
	vmov.f32	s4, s2
	vmov.f32	s0, s2
.LBB9_23:
	ldrb.w	r0, [r12, #5]
	vstr	s4, [r12, #52]
	vstr	s2, [r12, #56]
	cmp	r0, #1
	bne	.LBB9_25
@ %bb.24:
	movw	r1, :lower16:.L_MergedGlobals.2
	movt	r1, :upper16:.L_MergedGlobals.2
	vldr	s2, [r1, #40]
	vldr	s6, [r1, #36]
	vldr	s4, [r1, #56]
	vldr	s8, [r1, #60]
	vmul.f32	s2, s2, s4
	vldr	s10, [r1, #68]
	vstr	s0, [r1, #56]
	vldr	s12, [r1, #96]
	vstr	s4, [r1, #60]
	vldr	s4, [r1, #104]
	vfma.f32	s2, s6, s0
	vldr	s6, [r1, #44]
	vfma.f32	s2, s6, s8
	vldr	s6, [r1, #48]
	vldr	s8, [r1, #64]
	vstr	s8, [r1, #68]
	vfms.f32	s2, s6, s8
	vldr	s6, [r1, #52]
	vfms.f32	s2, s6, s10
	vldr	s6, [r1, #76]
	vldr	s10, [r1, #92]
	vstr	s10, [r1, #96]
	vmul.f32	s0, s6, s10
	vldr	s6, [r1, #72]
	vstr	s2, [r1, #64]
	vstr	s2, [r1, #92]
	vfma.f32	s0, s6, s2
	vldr	s6, [r1, #80]
	vfma.f32	s0, s6, s12
	vldr	s6, [r1, #84]
	vldr	s12, [r1, #100]
	vstr	s12, [r1, #104]
	vfms.f32	s0, s6, s12
	vldr	s6, [r1, #88]
	vfms.f32	s0, s6, s4
	vstr	s0, [r1, #100]
.LBB9_25:
	ldrb.w	r0, [r12, #6]
	cmp	r0, #1
	bne	.LBB9_27
.LBB9_26:
	movw	r1, :lower16:s_i_hpf
	movt	r1, :upper16:s_i_hpf
	vldr	s2, [r1, #4]
	vldr	s6, [r1]
	vldr	s4, [r1, #20]
	vldr	s8, [r1, #24]
	vmul.f32	s2, s2, s4
	vldr	s10, [r1, #32]
	vstr	s0, [r1, #20]
	vldr	s12, [r1, #60]
	vstr	s4, [r1, #24]
	vldr	s4, [r1, #68]
	vfma.f32	s2, s6, s0
	vldr	s6, [r1, #8]
	vfma.f32	s2, s6, s8
	vldr	s6, [r1, #12]
	vldr	s8, [r1, #28]
	vstr	s8, [r1, #32]
	vfms.f32	s2, s6, s8
	vldr	s6, [r1, #16]
	vfms.f32	s2, s6, s10
	vldr	s6, [r1, #40]
	vldr	s10, [r1, #56]
	vstr	s10, [r1, #60]
	vmul.f32	s0, s6, s10
	vldr	s6, [r1, #36]
	vstr	s2, [r1, #28]
	vstr	s2, [r1, #56]
	vfma.f32	s0, s6, s2
	vldr	s6, [r1, #44]
	vfma.f32	s0, s6, s12
	vldr	s6, [r1, #48]
	vldr	s12, [r1, #64]
	vstr	s12, [r1, #68]
	vfms.f32	s0, s6, s12
	vldr	s6, [r1, #52]
	vfms.f32	s0, s6, s4
	vstr	s0, [r1, #64]
.LBB9_27:
	vldr	s8, [r12, #68]
	vldr	s4, .LCPI9_5
	vsub.f32	s2, s0, s8
	vldr	s10, [r12, #72]
	adr	r0, .LCPI9_6
	vldr	s6, .LCPI9_8
	movw	r1, :lower16:.L_MergedGlobals
	vldr	s12, .LCPI9_10
	vfma.f32	s8, s2, s4
	movt	r1, :upper16:.L_MergedGlobals
	vsub.f32	s0, s0, s8
	vabs.f32	s2, s0
	vcmp.f32	s2, s10
	vmrs	APSR_nzcv, fpscr
	it	gt
	addgt	r0, #4
	vsub.f32	s2, s2, s10
	vstr	s8, [r12, #68]
	vldr	s4, [r0]
	vfma.f32	s10, s2, s4
	vmov.f32	s2, #2.000000e+00
	vldr	s4, .LCPI9_7
	vstr	s10, [r12, #72]
	vdiv.f32	s4, s4, s10
	vcmp.f32	s10, s2
	vmrs	APSR_nzcv, fpscr
	vselgt.f32	s4, s4, s6
	vminnm.f32	s4, s4, s6
	vldr	s6, .LCPI9_9
	vmaxnm.f32	s6, s4, s6
	vldr	s4, [r1, #4]
	vmul.f32	s12, s4, s12
	vcmp.f32	s6, s12
	vmrs	APSR_nzcv, fpscr
	bge	.LBB9_32
@ %bb.28:
	vsub.f32	s6, s6, s4
	vldr	s8, .LCPI9_13
	b	.LBB9_34
	.p2align	2
@ %bb.29:
__arm_cp.9_27:
	.long	0x42800000                      @ float 64
.Lcpi_end4:
	.size	__arm_cp.9_27, .Lcpi_end4-__arm_cp.9_27
	.p2align	2
@ %bb.30:
__arm_cp.9_28:
	.long	0x44fa0000                      @ float 2000
.Lcpi_end5:
	.size	__arm_cp.9_28, .Lcpi_end5-__arm_cp.9_28
	.p2align	2
@ %bb.31:
__arm_cp.9_29:
	.long	0x00000000                      @ float 0
.Lcpi_end6:
	.size	__arm_cp.9_29, .Lcpi_end6-__arm_cp.9_29
	.p2align	2
.LBB9_32:
	vldr	s8, .LCPI9_11
	vmul.f32	s8, s4, s8
	vcmp.f32	s6, s8
	vmrs	APSR_nzcv, fpscr
	ble	.LBB9_35
@ %bb.33:
	vsub.f32	s6, s6, s4
	vldr	s8, .LCPI9_12
.LBB9_34:
	vfma.f32	s4, s6, s8
	vstr	s4, [r1, #4]
.LBB9_35:
	vmul.f32	s0, s0, s4
	vldr	s4, [r1, #8]
	ldrb.w	r0, [r12, #3]
	vmul.f32	s0, s0, s4
	vldr	s4, [r1, #24]
	cmp	r0, #0
	vmul.f32	s0, s0, s4
	beq	.LBB9_37
@ %bb.36:
	vmov.f32	s8, #1.500000e+00
	vldr	s10, [r12, #80]
	vabs.f32	s6, s0
	vldr	s4, [r12, #76]
	adr	r0, .LCPI9_14
	adr	r2, .LCPI9_15
	vmul.f32	s8, s10, s8
	vmov.f32	s14, #4.500000e+00
	vcmp.f32	s6, s4
	vmov.f32	s1, #3.000000e+00
	vmrs	APSR_nzcv, fpscr
	it	gt
	addgt	r0, #4
	vcmp.f32	s6, s8
	vmrs	APSR_nzcv, fpscr
	it	lt
	addlt	r2, #4
	vsub.f32	s8, s6, s10
	vldr	s12, [r2]
	ldrb	r2, [r1]
	vsub.f32	s6, s6, s4
	cmp	r2, #2
	vfma.f32	s10, s8, s12
	vldr	s8, [r0]
	adr	r0, .LCPI9_18
	vseleq.f32	s12, s1, s14
	vmov.f32	s14, #1.000000e+00
	cmp	r2, #1
	vfma.f32	s4, s6, s8
	vmov.f32	s6, #5.000000e-01
	vseleq.f32	s2, s2, s12
	cmp	r2, #2
	vmaxnm.f32	s8, s10, s14
	vldr	s10, .LCPI9_16
	vseleq.f32	s6, s6, s10
	cmp	r2, #1
	vldr	s10, .LCPI9_17
	vmul.f32	s2, s2, s8
	vldr	s12, .LCPI9_20
	vseleq.f32	s6, s10, s6
	vdiv.f32	s2, s4, s2
	vsub.f32	s10, s14, s6
	vcmp.f32	s14, s2
	vfma.f32	s6, s10, s2
	vmrs	APSR_nzcv, fpscr
	vselgt.f32	s2, s6, s14
	vldr	s6, [r1, #16]
	vcmp.f32	s2, s6
	vmrs	APSR_nzcv, fpscr
	it	gt
	addgt	r0, #4
	vsub.f32	s2, s2, s6
	cmp	r2, #2
	vldr	s10, [r0]
	adr	r0, .LCPI9_19
	vfma.f32	s6, s2, s10
	vldr	s2, [r12, #84]
	vmov.f32	s10, s2
	it	eq
	addeq	r0, #4
	cmp	r2, #1
	vstr	s4, [r12, #76]
	vstr	s8, [r12, #80]
	vnmls.f32	s10, s0, s6
	vldr	s0, [r0]
	vseleq.f32	s0, s12, s0
	vstr	s6, [r1, #16]
	vfma.f32	s2, s10, s0
	vstr	s2, [r12, #84]
	vmov.f32	s0, s2
.LBB9_37:
	ldrb.w	r0, [r12, #7]
	cbz	r0, .LBB9_39
@ %bb.38:
	movw	r0, :lower16:.L_MergedGlobals.2
	movt	r0, :upper16:.L_MergedGlobals.2
	vldr	s2, [r0, #4]
	vldr	s6, [r0]
	vldr	s4, [r0, #20]
	vldr	s8, [r0, #24]
	vmul.f32	s2, s2, s4
	vldr	s10, [r0, #32]
	vstr	s0, [r0, #20]
	vstr	s4, [r0, #24]
	vfma.f32	s2, s6, s0
	vldr	s6, [r0, #8]
	vfma.f32	s2, s6, s8
	vldr	s6, [r0, #12]
	vldr	s8, [r0, #28]
	vstr	s8, [r0, #32]
	vfms.f32	s2, s6, s8
	vldr	s6, [r0, #16]
	vfms.f32	s2, s6, s10
	vstr	s2, [r0, #28]
	vmov.f32	s0, s2
.LBB9_39:
	vmov.f32	s4, #1.000000e+00
	vldr	s2, [r1, #12]
	vcmp.f32	s2, s4
	vmrs	APSR_nzcv, fpscr
	bge	.LBB9_42
@ %bb.40:
	vldr	s6, .LCPI9_21
	vadd.f32	s2, s2, s6
	vstr	s2, [r1, #12]
	vcmp.f32	s2, s4
	vmrs	APSR_nzcv, fpscr
	ble	.LBB9_42
@ %bb.41:
	vmov.f32	s2, s4
	mov.w	r0, #1065353216
	str	r0, [r1, #12]
.LBB9_42:
	vmul.f32	s0, s0, s2
	vldr	s2, .LCPI9_22
	ldrh.w	r0, [r12, #10]
	movw	r1, :lower16:s_audio_buf
	movt	r1, :upper16:s_audio_buf
	vminnm.f32	s0, s0, s2
	vldr	s2, .LCPI9_23
	vmaxnm.f32	s0, s0, s2
	vcvt.s32.f32	s0, s0
	vmov	r2, s0
	strh.w	r2, [r1, r0, lsl #1]
	ldrh.w	r0, [r12, #10]
	adds	r0, #1
	bfc	r0, #12, #20
	strh.w	r0, [r12, #10]
	movs	r0, #1
	pop	{r7, pc}
	.p2align	2
@ %bb.43:
.LCPI9_5:
	.long	0x3a03126f                      @ float 5.00000024E-4
.LCPI9_6:
	.long	0x38a7c5ac                      @ float 7.9999998E-5
	.long	0x3b83126f                      @ float 0.00400000019
.LCPI9_7:
	.long	0x457a0000                      @ float 4000
.LCPI9_8:
	.long	0x44000000                      @ float 512
.LCPI9_9:
	.long	0x3dcccccd                      @ float 0.100000001
.LCPI9_10:
	.long	0x3f733333                      @ float 0.949999988
.LCPI9_11:
	.long	0x3f8a3d71                      @ float 1.08000004
.LCPI9_12:
	.long	0x38fba882                      @ float 1.19999997E-4
.LCPI9_13:
	.long	0x3bc49ba6                      @ float 0.00600000005
.LCPI9_14:
	.long	0x3a03126f                      @ float 5.00000024E-4
	.long	0x3ca3d70a                      @ float 0.0199999996
.LCPI9_15:
	.long	0x358637bd                      @ float 9.99999997E-7
	.long	0x3827c5ac                      @ float 3.9999999E-5
.LCPI9_16:
	.long	0x3eb33333                      @ float 0.349999994
.LCPI9_17:
	.long	0x3f266666                      @ float 0.649999976
.LCPI9_18:
	.long	0x39b78034                      @ float 3.49999988E-4
	.long	0x3ac49ba6                      @ float 0.00150000001
.LCPI9_19:
	.long	0x3e8f5c29                      @ float 0.280000001
	.long	0x3e6147ae                      @ float 0.219999999
.LCPI9_20:
	.long	0x3e3851ec                      @ float 0.180000007
.LCPI9_21:
	.long	0x3b088889                      @ float 0.00208333344
.LCPI9_22:
	.long	0x46fa0000                      @ float 32000
.LCPI9_23:
	.long	0xc6fa0000                      @ float -32000
.Lfunc_end9:
	.size	am_demod_poll, .Lfunc_end9-am_demod_poll
	.cfi_endproc
	.cantunwind
	.fnend
                                        @ -- End function
	.section	.text.am_demod_read,"ax",%progbits
	.hidden	am_demod_read                   @ -- Begin function am_demod_read
	.globl	am_demod_read
	.p2align	3
	.type	am_demod_read,%function
	.code	16                              @ @am_demod_read
	.thumb_func
am_demod_read:
	.fnstart
	.cfi_startproc
@ %bb.0:
	movw	r1, :lower16:.L_MergedGlobals.1
	movt	r1, :upper16:.L_MergedGlobals.1
	ldrh	r2, [r1, #8]
	ldrh	r3, [r1, #10]
	cmp	r2, r3
	bne	.LBB10_2
@ %bb.1:
	movs	r0, #0
	bx	lr
	.p2align	2
.LBB10_2:
	movw	r3, :lower16:s_audio_buf
	movt	r3, :upper16:s_audio_buf
	ldrh.w	r3, [r3, r2, lsl #1]
	strh	r3, [r0]
	adds	r0, r2, #1
	bfc	r0, #12, #20
	strh	r0, [r1, #8]
	movs	r0, #1
	bx	lr
.Lfunc_end10:
	.size	am_demod_read, .Lfunc_end10-am_demod_read
	.cfi_endproc
	.cantunwind
	.fnend
                                        @ -- End function
	.section	.text.am_demod_get_agc_gain,"ax",%progbits
	.hidden	am_demod_get_agc_gain           @ -- Begin function am_demod_get_agc_gain
	.globl	am_demod_get_agc_gain
	.p2align	3
	.type	am_demod_get_agc_gain,%function
	.code	16                              @ @am_demod_get_agc_gain
	.thumb_func
am_demod_get_agc_gain:
	.fnstart
	.cfi_startproc
@ %bb.0:
	movw	r0, :lower16:.L_MergedGlobals
	vldr	s2, .LCPI11_0
	movt	r0, :upper16:.L_MergedGlobals
	vldr	s0, [r0, #4]
	vmul.f32	s0, s0, s2
	vcvt.s32.f32	s0, s0
	vmov	r0, s0
	bx	lr
	.p2align	2
@ %bb.1:
.LCPI11_0:
	.long	0x43800000                      @ float 256
.Lfunc_end11:
	.size	am_demod_get_agc_gain, .Lfunc_end11-am_demod_get_agc_gain
	.cfi_endproc
	.cantunwind
	.fnend
                                        @ -- End function
	.section	.text.am_demod_set_audio_gain,"ax",%progbits
	.hidden	am_demod_set_audio_gain         @ -- Begin function am_demod_set_audio_gain
	.globl	am_demod_set_audio_gain
	.p2align	3
	.type	am_demod_set_audio_gain,%function
	.code	16                              @ @am_demod_set_audio_gain
	.thumb_func
am_demod_set_audio_gain:
	.fnstart
	.cfi_startproc
@ %bb.0:
	vldr	s2, .LCPI12_0
	movw	r0, :lower16:.L_MergedGlobals
	vmaxnm.f32	s0, s0, s2
	vmov.f32	s2, #2.000000e+01
	movt	r0, :upper16:.L_MergedGlobals
	vminnm.f32	s0, s0, s2
	vstr	s0, [r0, #24]
	bx	lr
	.p2align	2
@ %bb.1:
.LCPI12_0:
	.long	0x3c23d70a                      @ float 0.00999999977
.Lfunc_end12:
	.size	am_demod_set_audio_gain, .Lfunc_end12-am_demod_set_audio_gain
	.cfi_endproc
	.cantunwind
	.fnend
                                        @ -- End function
	.section	.text.am_demod_set_hpf50,"ax",%progbits
	.hidden	am_demod_set_hpf50              @ -- Begin function am_demod_set_hpf50
	.globl	am_demod_set_hpf50
	.p2align	3
	.type	am_demod_set_hpf50,%function
	.code	16                              @ @am_demod_set_hpf50
	.thumb_func
am_demod_set_hpf50:
	.fnstart
	.cfi_startproc
@ %bb.0:
	movw	r1, :lower16:.L_MergedGlobals.1
	cmp	r0, #0
	it	ne
	movne	r0, #1
	movt	r1, :upper16:.L_MergedGlobals.1
	strb	r0, [r1, #7]
	it	eq
	bxeq	lr
.LBB13_1:
	movw	r0, :lower16:.L_MergedGlobals.2
	movs	r1, #0
	movt	r0, :upper16:.L_MergedGlobals.2
	strd	r1, r1, [r0, #20]
	strd	r1, r1, [r0, #28]
	bx	lr
.Lfunc_end13:
	.size	am_demod_set_hpf50, .Lfunc_end13-am_demod_set_hpf50
	.cfi_endproc
	.cantunwind
	.fnend
                                        @ -- End function
	.section	.text.am_demod_set_nr,"ax",%progbits
	.hidden	am_demod_set_nr                 @ -- Begin function am_demod_set_nr
	.globl	am_demod_set_nr
	.p2align	3
	.type	am_demod_set_nr,%function
	.code	16                              @ @am_demod_set_nr
	.thumb_func
am_demod_set_nr:
	.fnstart
	.cfi_startproc
@ %bb.0:
	cmp	r1, #1
	movw	r2, :lower16:.L_MergedGlobals.1
	it	ls
	movls	r1, #1
	movt	r2, :upper16:.L_MergedGlobals.1
	cmp	r1, #3
	it	hs
	movhs	r1, #3
	cmp	r0, #0
	it	ne
	movne	r0, #1
	strb	r0, [r2, #3]
	movw	r0, :lower16:.L_MergedGlobals
	movt	r0, :upper16:.L_MergedGlobals
	strb	r1, [r0]
	mov.w	r1, #1065353216
	str	r1, [r0, #16]
	movs	r0, #0
	strd	r0, r1, [r2, #76]
	str	r0, [r2, #84]
	bx	lr
.Lfunc_end14:
	.size	am_demod_set_nr, .Lfunc_end14-am_demod_set_nr
	.cfi_endproc
	.cantunwind
	.fnend
                                        @ -- End function
	.section	.text.am_demod_get_envelope,"ax",%progbits
	.hidden	am_demod_get_envelope           @ -- Begin function am_demod_get_envelope
	.globl	am_demod_get_envelope
	.p2align	3
	.type	am_demod_get_envelope,%function
	.code	16                              @ @am_demod_get_envelope
	.thumb_func
am_demod_get_envelope:
	.fnstart
	.cfi_startproc
@ %bb.0:
	movw	r0, :lower16:.L_MergedGlobals.1
	movt	r0, :upper16:.L_MergedGlobals.1
	ldr	r0, [r0, #44]
	bx	lr
.Lfunc_end15:
	.size	am_demod_get_envelope, .Lfunc_end15-am_demod_get_envelope
	.cfi_endproc
	.cantunwind
	.fnend
                                        @ -- End function
	.type	s_audio_buf,%object             @ @s_audio_buf
	.section	.bss.s_audio_buf,"aw",%nobits
	.p2align	2, 0x0
s_audio_buf:
	.zero	8192
	.size	s_audio_buf, 8192

	.type	s_iq_queue,%object              @ @s_iq_queue
	.section	.bss.s_iq_queue,"aw",%nobits
	.p2align	2, 0x0
s_iq_queue:
	.zero	12288
	.size	s_iq_queue, 12288

	.type	s_i_lpf,%object                 @ @s_i_lpf
	.section	.bss.s_i_lpf,"aw",%nobits
	.p2align	2, 0x0
s_i_lpf:
	.zero	108
	.size	s_i_lpf, 108

	.type	s_q_lpf,%object                 @ @s_q_lpf
	.section	.bss.s_q_lpf,"aw",%nobits
	.p2align	2, 0x0
s_q_lpf:
	.zero	108
	.size	s_q_lpf, 108

	.type	s_i_hpf,%object                 @ @s_i_hpf
	.section	.bss.s_i_hpf,"aw",%nobits
	.p2align	2, 0x0
s_i_hpf:
	.zero	72
	.size	s_i_hpf, 72

	.type	sin_lut,%object                 @ @sin_lut
	.section	.rodata.sin_lut,"a",%progbits
	.p2align	1, 0x0
sin_lut:
	.short	0                               @ 0x0
	.short	804                             @ 0x324
	.short	1608                            @ 0x648
	.short	2411                            @ 0x96b
	.short	3212                            @ 0xc8c
	.short	4011                            @ 0xfab
	.short	4808                            @ 0x12c8
	.short	5602                            @ 0x15e2
	.short	6393                            @ 0x18f9
	.short	7180                            @ 0x1c0c
	.short	7962                            @ 0x1f1a
	.short	8740                            @ 0x2224
	.short	9512                            @ 0x2528
	.short	10279                           @ 0x2827
	.short	11039                           @ 0x2b1f
	.short	11793                           @ 0x2e11
	.short	12540                           @ 0x30fc
	.short	13279                           @ 0x33df
	.short	14010                           @ 0x36ba
	.short	14732                           @ 0x398c
	.short	15446                           @ 0x3c56
	.short	16151                           @ 0x3f17
	.short	16846                           @ 0x41ce
	.short	17530                           @ 0x447a
	.short	18204                           @ 0x471c
	.short	18868                           @ 0x49b4
	.short	19519                           @ 0x4c3f
	.short	20159                           @ 0x4ebf
	.short	20787                           @ 0x5133
	.short	21403                           @ 0x539b
	.short	22006                           @ 0x55f6
	.short	22595                           @ 0x5843
	.short	23170                           @ 0x5a82
	.short	23731                           @ 0x5cb3
	.short	24279                           @ 0x5ed7
	.short	24811                           @ 0x60eb
	.short	25329                           @ 0x62f1
	.short	25832                           @ 0x64e8
	.short	26319                           @ 0x66cf
	.short	26790                           @ 0x68a6
	.short	27245                           @ 0x6a6d
	.short	27683                           @ 0x6c23
	.short	28106                           @ 0x6dca
	.short	28510                           @ 0x6f5e
	.short	28898                           @ 0x70e2
	.short	29268                           @ 0x7254
	.short	29621                           @ 0x73b5
	.short	29956                           @ 0x7504
	.short	30273                           @ 0x7641
	.short	30572                           @ 0x776c
	.short	30853                           @ 0x7885
	.short	31115                           @ 0x798b
	.short	31359                           @ 0x7a7f
	.short	31585                           @ 0x7b61
	.short	31791                           @ 0x7c2f
	.short	31979                           @ 0x7ceb
	.short	32148                           @ 0x7d94
	.short	32298                           @ 0x7e2a
	.short	32429                           @ 0x7ead
	.short	32541                           @ 0x7f1d
	.short	32635                           @ 0x7f7b
	.short	32709                           @ 0x7fc5
	.short	32765                           @ 0x7ffd
	.short	32767                           @ 0x7fff
	.short	32767                           @ 0x7fff
	.short	32767                           @ 0x7fff
	.short	32765                           @ 0x7ffd
	.short	32709                           @ 0x7fc5
	.short	32635                           @ 0x7f7b
	.short	32541                           @ 0x7f1d
	.short	32429                           @ 0x7ead
	.short	32298                           @ 0x7e2a
	.short	32148                           @ 0x7d94
	.short	31979                           @ 0x7ceb
	.short	31791                           @ 0x7c2f
	.short	31585                           @ 0x7b61
	.short	31359                           @ 0x7a7f
	.short	31115                           @ 0x798b
	.short	30853                           @ 0x7885
	.short	30572                           @ 0x776c
	.short	30273                           @ 0x7641
	.short	29956                           @ 0x7504
	.short	29621                           @ 0x73b5
	.short	29268                           @ 0x7254
	.short	28898                           @ 0x70e2
	.short	28510                           @ 0x6f5e
	.short	28106                           @ 0x6dca
	.short	27683                           @ 0x6c23
	.short	27245                           @ 0x6a6d
	.short	26790                           @ 0x68a6
	.short	26319                           @ 0x66cf
	.short	25832                           @ 0x64e8
	.short	25329                           @ 0x62f1
	.short	24811                           @ 0x60eb
	.short	24279                           @ 0x5ed7
	.short	23731                           @ 0x5cb3
	.short	23170                           @ 0x5a82
	.short	22595                           @ 0x5843
	.short	22006                           @ 0x55f6
	.short	21403                           @ 0x539b
	.short	20787                           @ 0x5133
	.short	20159                           @ 0x4ebf
	.short	19519                           @ 0x4c3f
	.short	18868                           @ 0x49b4
	.short	18204                           @ 0x471c
	.short	17530                           @ 0x447a
	.short	16846                           @ 0x41ce
	.short	16151                           @ 0x3f17
	.short	15446                           @ 0x3c56
	.short	14732                           @ 0x398c
	.short	14010                           @ 0x36ba
	.short	13279                           @ 0x33df
	.short	12540                           @ 0x30fc
	.short	11793                           @ 0x2e11
	.short	11039                           @ 0x2b1f
	.short	10279                           @ 0x2827
	.short	9512                            @ 0x2528
	.short	8740                            @ 0x2224
	.short	7962                            @ 0x1f1a
	.short	7180                            @ 0x1c0c
	.short	6393                            @ 0x18f9
	.short	5602                            @ 0x15e2
	.short	4808                            @ 0x12c8
	.short	4011                            @ 0xfab
	.short	3212                            @ 0xc8c
	.short	2411                            @ 0x96b
	.short	1608                            @ 0x648
	.short	804                             @ 0x324
	.short	0                               @ 0x0
	.short	64732                           @ 0xfcdc
	.short	63928                           @ 0xf9b8
	.short	63125                           @ 0xf695
	.short	62324                           @ 0xf374
	.short	61525                           @ 0xf055
	.short	60728                           @ 0xed38
	.short	59934                           @ 0xea1e
	.short	59143                           @ 0xe707
	.short	58356                           @ 0xe3f4
	.short	57574                           @ 0xe0e6
	.short	56796                           @ 0xdddc
	.short	56024                           @ 0xdad8
	.short	55257                           @ 0xd7d9
	.short	54497                           @ 0xd4e1
	.short	53743                           @ 0xd1ef
	.short	52996                           @ 0xcf04
	.short	52257                           @ 0xcc21
	.short	51526                           @ 0xc946
	.short	50804                           @ 0xc674
	.short	50090                           @ 0xc3aa
	.short	49385                           @ 0xc0e9
	.short	48690                           @ 0xbe32
	.short	48006                           @ 0xbb86
	.short	47332                           @ 0xb8e4
	.short	46668                           @ 0xb64c
	.short	46017                           @ 0xb3c1
	.short	45377                           @ 0xb141
	.short	44749                           @ 0xaecd
	.short	44133                           @ 0xac65
	.short	43530                           @ 0xaa0a
	.short	42941                           @ 0xa7bd
	.short	42366                           @ 0xa57e
	.short	41805                           @ 0xa34d
	.short	41257                           @ 0xa129
	.short	40725                           @ 0x9f15
	.short	40207                           @ 0x9d0f
	.short	39704                           @ 0x9b18
	.short	39217                           @ 0x9931
	.short	38746                           @ 0x975a
	.short	38291                           @ 0x9593
	.short	37853                           @ 0x93dd
	.short	37430                           @ 0x9236
	.short	37026                           @ 0x90a2
	.short	36638                           @ 0x8f1e
	.short	36268                           @ 0x8dac
	.short	35915                           @ 0x8c4b
	.short	35580                           @ 0x8afc
	.short	35263                           @ 0x89bf
	.short	34964                           @ 0x8894
	.short	34683                           @ 0x877b
	.short	34421                           @ 0x8675
	.short	34177                           @ 0x8581
	.short	33951                           @ 0x849f
	.short	33745                           @ 0x83d1
	.short	33557                           @ 0x8315
	.short	33388                           @ 0x826c
	.short	33238                           @ 0x81d6
	.short	33107                           @ 0x8153
	.short	32995                           @ 0x80e3
	.short	32901                           @ 0x8085
	.short	32827                           @ 0x803b
	.short	32771                           @ 0x8003
	.short	32769                           @ 0x8001
	.short	32769                           @ 0x8001
	.short	32769                           @ 0x8001
	.short	32771                           @ 0x8003
	.short	32827                           @ 0x803b
	.short	32901                           @ 0x8085
	.short	32995                           @ 0x80e3
	.short	33107                           @ 0x8153
	.short	33238                           @ 0x81d6
	.short	33388                           @ 0x826c
	.short	33557                           @ 0x8315
	.short	33745                           @ 0x83d1
	.short	33951                           @ 0x849f
	.short	34177                           @ 0x8581
	.short	34421                           @ 0x8675
	.short	34683                           @ 0x877b
	.short	34964                           @ 0x8894
	.short	35263                           @ 0x89bf
	.short	35580                           @ 0x8afc
	.short	35915                           @ 0x8c4b
	.short	36268                           @ 0x8dac
	.short	36638                           @ 0x8f1e
	.short	37026                           @ 0x90a2
	.short	37430                           @ 0x9236
	.short	37853                           @ 0x93dd
	.short	38291                           @ 0x9593
	.short	38746                           @ 0x975a
	.short	39217                           @ 0x9931
	.short	39704                           @ 0x9b18
	.short	40207                           @ 0x9d0f
	.short	40725                           @ 0x9f15
	.short	41257                           @ 0xa129
	.short	41805                           @ 0xa34d
	.short	42366                           @ 0xa57e
	.short	42941                           @ 0xa7bd
	.short	43530                           @ 0xaa0a
	.short	44133                           @ 0xac65
	.short	44749                           @ 0xaecd
	.short	45377                           @ 0xb141
	.short	46017                           @ 0xb3c1
	.short	46668                           @ 0xb64c
	.short	47332                           @ 0xb8e4
	.short	48006                           @ 0xbb86
	.short	48690                           @ 0xbe32
	.short	49385                           @ 0xc0e9
	.short	50090                           @ 0xc3aa
	.short	50804                           @ 0xc674
	.short	51526                           @ 0xc946
	.short	52257                           @ 0xcc21
	.short	52996                           @ 0xcf04
	.short	53743                           @ 0xd1ef
	.short	54497                           @ 0xd4e1
	.short	55257                           @ 0xd7d9
	.short	56024                           @ 0xdad8
	.short	56796                           @ 0xdddc
	.short	57574                           @ 0xe0e6
	.short	58356                           @ 0xe3f4
	.short	59143                           @ 0xe707
	.short	59934                           @ 0xea1e
	.short	60728                           @ 0xed38
	.short	61525                           @ 0xf055
	.short	62324                           @ 0xf374
	.short	63125                           @ 0xf695
	.short	63928                           @ 0xf9b8
	.short	64732                           @ 0xfcdc
	.size	sin_lut, 512

	.type	.L_MergedGlobals,%object        @ @_MergedGlobals
	.section	.data..L_MergedGlobals,"aw",%progbits
	.p2align	2, 0x0
.L_MergedGlobals:
	.byte	1                               @ 0x1
	.zero	3
	.long	0x3f800000                      @ float 1
	.long	0x3f800000                      @ float 1
	.long	0x3f800000                      @ float 1
	.long	0x3f800000                      @ float 1
	.long	465000                          @ 0x71868
	.long	0x3dcccccd                      @ float 0.100000001
	.size	.L_MergedGlobals, 28

	.type	.L_MergedGlobals.1,%object      @ @_MergedGlobals.1
	.section	.bss..L_MergedGlobals.1,"aw",%nobits
	.p2align	2, 0x0
.L_MergedGlobals.1:
	.zero	92
	.size	.L_MergedGlobals.1, 92

	.type	.L_MergedGlobals.2,%object      @ @_MergedGlobals.2
	.section	.bss..L_MergedGlobals.2,"aw",%nobits
	.p2align	2, 0x0
.L_MergedGlobals.2:
	.zero	108
	.size	.L_MergedGlobals.2, 108

.set s_nr_level, .L_MergedGlobals
	.size	s_nr_level, 1
.set s_agc_gain, .L_MergedGlobals+4
	.size	s_agc_gain, 4
.set s_mode_gain, .L_MergedGlobals+8
	.size	s_mode_gain, 4
.set s_mode_ramp, .L_MergedGlobals+12
	.size	s_mode_ramp, 4
.set s_nr_gain, .L_MergedGlobals+16
	.size	s_nr_gain, 4
.set s_carrier_hz, .L_MergedGlobals+20
	.size	s_carrier_hz, 4
.set s_audio_gain, .L_MergedGlobals+24
	.size	s_audio_gain, 4
.set s_enabled, .L_MergedGlobals.1
	.size	s_enabled, 1
.set s_mode, .L_MergedGlobals.1+1
	.size	s_mode, 1
.set s_nco2_dir, .L_MergedGlobals.1+2
	.size	s_nco2_dir, 1
.set s_nr_en, .L_MergedGlobals.1+3
	.size	s_nr_en, 1
.set s_ch_filter_count, .L_MergedGlobals.1+4
	.size	s_ch_filter_count, 1
.set s_af_filter_count, .L_MergedGlobals.1+5
	.size	s_af_filter_count, 1
.set s_hpf_filter_count, .L_MergedGlobals.1+6
	.size	s_hpf_filter_count, 1
.set s_hpf50_en, .L_MergedGlobals.1+7
	.size	s_hpf50_en, 1
.set s_audio_rp, .L_MergedGlobals.1+8
	.size	s_audio_rp, 2
.set s_audio_wp, .L_MergedGlobals.1+10
	.size	s_audio_wp, 2
.set s_iq_rp, .L_MergedGlobals.1+12
	.size	s_iq_rp, 2
.set s_iq_wp, .L_MergedGlobals.1+14
	.size	s_iq_wp, 2
.set s_nco_phase, .L_MergedGlobals.1+16
	.size	s_nco_phase, 4
.set s_i_aa3, .L_MergedGlobals.1+20
	.size	s_i_aa3, 4
.set s_i_aa2, .L_MergedGlobals.1+24
	.size	s_i_aa2, 4
.set s_i_aa1, .L_MergedGlobals.1+28
	.size	s_i_aa1, 4
.set s_q_aa3, .L_MergedGlobals.1+32
	.size	s_q_aa3, 4
.set s_q_aa2, .L_MergedGlobals.1+36
	.size	s_q_aa2, 4
.set s_q_aa1, .L_MergedGlobals.1+40
	.size	s_q_aa1, 4
.set s_envelope, .L_MergedGlobals.1+44
	.size	s_envelope, 4
.set s_decim_cnt, .L_MergedGlobals.1+48
	.size	s_decim_cnt, 4
.set s_fm_q_prev, .L_MergedGlobals.1+52
	.size	s_fm_q_prev, 4
.set s_fm_i_prev, .L_MergedGlobals.1+56
	.size	s_fm_i_prev, 4
.set s_nco2_phase, .L_MergedGlobals.1+60
	.size	s_nco2_phase, 4
.set s_nco2_inc, .L_MergedGlobals.1+64
	.size	s_nco2_inc, 4
.set s_dc, .L_MergedGlobals.1+68
	.size	s_dc, 4
.set s_env_peak, .L_MergedGlobals.1+72
	.size	s_env_peak, 4
.set s_nr_env, .L_MergedGlobals.1+76
	.size	s_nr_env, 4
.set s_nr_floor, .L_MergedGlobals.1+80
	.size	s_nr_floor, 4
.set s_nr_lpf, .L_MergedGlobals.1+84
	.size	s_nr_lpf, 4
.set s_nco_inc, .L_MergedGlobals.1+88
	.size	s_nco_inc, 4
.set s_hpf50, .L_MergedGlobals.2
	.size	s_hpf50, 36
.set s_af_lpf, .L_MergedGlobals.2+36
	.size	s_af_lpf, 72
	.ident	"Component: Arm Compiler for Embedded 6.24 Tool: armclang [5f371800]"
	.section	".note.GNU-stack","",%progbits
	.eabi_attribute	30, 2	@ Tag_ABI_optimization_goals
	.ARM_attribute	16, 1	@ Tag_AV_eba
