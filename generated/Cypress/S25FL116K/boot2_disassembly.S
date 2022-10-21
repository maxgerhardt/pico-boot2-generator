
generated\Cypress\S25FL116K\boot2.elf:     file format elf32-littlearm


Disassembly of section .text:

20041f00 <_stage2_boot>:
20041f00:	b5f7      	push	{r0, r1, r2, r4, r5, r6, r7, lr}
20041f02:	4673      	mov	r3, lr
20041f04:	2221      	movs	r2, #33	; 0x21
20041f06:	2602      	movs	r6, #2
20041f08:	9301      	str	r3, [sp, #4]
20041f0a:	4b29      	ldr	r3, [pc, #164]	; (20041fb0 <_stage2_boot+0xb0>)
20041f0c:	24c0      	movs	r4, #192	; 0xc0
20041f0e:	605a      	str	r2, [r3, #4]
20041f10:	689a      	ldr	r2, [r3, #8]
20041f12:	2700      	movs	r7, #0
20041f14:	43b2      	bics	r2, r6
20041f16:	60da      	str	r2, [r3, #12]
20041f18:	609a      	str	r2, [r3, #8]
20041f1a:	611a      	str	r2, [r3, #16]
20041f1c:	615a      	str	r2, [r3, #20]
20041f1e:	2304      	movs	r3, #4
20041f20:	2501      	movs	r5, #1
20041f22:	0564      	lsls	r4, r4, #21
20041f24:	60a7      	str	r7, [r4, #8]
20041f26:	6163      	str	r3, [r4, #20]
20041f28:	4b22      	ldr	r3, [pc, #136]	; (20041fb4 <_stage2_boot+0xb4>)
20041f2a:	0030      	movs	r0, r6
20041f2c:	601d      	str	r5, [r3, #0]
20041f2e:	23e0      	movs	r3, #224	; 0xe0
20041f30:	02db      	lsls	r3, r3, #11
20041f32:	6023      	str	r3, [r4, #0]
20041f34:	2335      	movs	r3, #53	; 0x35
20041f36:	60a5      	str	r5, [r4, #8]
20041f38:	6623      	str	r3, [r4, #96]	; 0x60
20041f3a:	6623      	str	r3, [r4, #96]	; 0x60
20041f3c:	f000 f84a 	bl	20041fd4 <wait_and_read>
20041f40:	b2c0      	uxtb	r0, r0
20041f42:	42b0      	cmp	r0, r6
20041f44:	d012      	beq.n	20041f6c <_stage2_boot+0x6c>
20041f46:	2306      	movs	r3, #6
20041f48:	0028      	movs	r0, r5
20041f4a:	6623      	str	r3, [r4, #96]	; 0x60
20041f4c:	f000 f842 	bl	20041fd4 <wait_and_read>
20041f50:	6625      	str	r5, [r4, #96]	; 0x60
20041f52:	2003      	movs	r0, #3
20041f54:	6627      	str	r7, [r4, #96]	; 0x60
20041f56:	6626      	str	r6, [r4, #96]	; 0x60
20041f58:	f000 f83c 	bl	20041fd4 <wait_and_read>
20041f5c:	3603      	adds	r6, #3
20041f5e:	6626      	str	r6, [r4, #96]	; 0x60
20041f60:	2002      	movs	r0, #2
20041f62:	6626      	str	r6, [r4, #96]	; 0x60
20041f64:	f000 f836 	bl	20041fd4 <wait_and_read>
20041f68:	4228      	tst	r0, r5
20041f6a:	d1f8      	bne.n	20041f5e <_stage2_boot+0x5e>
20041f6c:	2500      	movs	r5, #0
20041f6e:	4b12      	ldr	r3, [pc, #72]	; (20041fb8 <_stage2_boot+0xb8>)
20041f70:	60a5      	str	r5, [r4, #8]
20041f72:	4f12      	ldr	r7, [pc, #72]	; (20041fbc <_stage2_boot+0xbc>)
20041f74:	6023      	str	r3, [r4, #0]
20041f76:	4b12      	ldr	r3, [pc, #72]	; (20041fc0 <_stage2_boot+0xc0>)
20041f78:	6065      	str	r5, [r4, #4]
20041f7a:	2601      	movs	r6, #1
20041f7c:	603b      	str	r3, [r7, #0]
20041f7e:	23eb      	movs	r3, #235	; 0xeb
20041f80:	60a6      	str	r6, [r4, #8]
20041f82:	6623      	str	r3, [r4, #96]	; 0x60
20041f84:	3b4b      	subs	r3, #75	; 0x4b
20041f86:	6623      	str	r3, [r4, #96]	; 0x60
20041f88:	2002      	movs	r0, #2
20041f8a:	f000 f823 	bl	20041fd4 <wait_and_read>
20041f8e:	4b0d      	ldr	r3, [pc, #52]	; (20041fc4 <_stage2_boot+0xc4>)
20041f90:	60a5      	str	r5, [r4, #8]
20041f92:	603b      	str	r3, [r7, #0]
20041f94:	60a6      	str	r6, [r4, #8]
20041f96:	9b01      	ldr	r3, [sp, #4]
20041f98:	42ab      	cmp	r3, r5
20041f9a:	d108      	bne.n	20041fae <_stage2_boot+0xae>
20041f9c:	4b0a      	ldr	r3, [pc, #40]	; (20041fc8 <_stage2_boot+0xc8>)
20041f9e:	4a0b      	ldr	r2, [pc, #44]	; (20041fcc <_stage2_boot+0xcc>)
20041fa0:	6013      	str	r3, [r2, #0]
20041fa2:	681b      	ldr	r3, [r3, #0]
20041fa4:	f383 8808 	msr	MSP, r3
20041fa8:	4b09      	ldr	r3, [pc, #36]	; (20041fd0 <_stage2_boot+0xd0>)
20041faa:	681b      	ldr	r3, [r3, #0]
20041fac:	4718      	bx	r3
20041fae:	bdf7      	pop	{r0, r1, r2, r4, r5, r6, r7, pc}
20041fb0:	40020000 	.word	0x40020000
20041fb4:	180000f0 	.word	0x180000f0
20041fb8:	005f0300 	.word	0x005f0300
20041fbc:	180000f4 	.word	0x180000f4
20041fc0:	00002221 	.word	0x00002221
20041fc4:	a0002022 	.word	0xa0002022
20041fc8:	10000100 	.word	0x10000100
20041fcc:	e000ed08 	.word	0xe000ed08
20041fd0:	10000104 	.word	0x10000104

20041fd4 <wait_and_read>:
20041fd4:	22c0      	movs	r2, #192	; 0xc0
20041fd6:	0003      	movs	r3, r0
20041fd8:	2104      	movs	r1, #4
20041fda:	0552      	lsls	r2, r2, #21
20041fdc:	6a90      	ldr	r0, [r2, #40]	; 0x28
20041fde:	4208      	tst	r0, r1
20041fe0:	d0fc      	beq.n	20041fdc <wait_and_read+0x8>
20041fe2:	2101      	movs	r1, #1
20041fe4:	6a90      	ldr	r0, [r2, #40]	; 0x28
20041fe6:	4208      	tst	r0, r1
20041fe8:	d1fc      	bne.n	20041fe4 <wait_and_read+0x10>
20041fea:	3b01      	subs	r3, #1
20041fec:	b2db      	uxtb	r3, r3
20041fee:	6e10      	ldr	r0, [r2, #96]	; 0x60
20041ff0:	2b00      	cmp	r3, #0
20041ff2:	d1fa      	bne.n	20041fea <wait_and_read+0x16>
20041ff4:	4770      	bx	lr
