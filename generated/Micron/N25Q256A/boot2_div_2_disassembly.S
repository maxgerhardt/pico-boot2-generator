
generated\Micron\N25Q256A\boot2_div_2.elf:     file format elf32-littlearm


Disassembly of section .text:

20041f00 <_stage2_boot>:
20041f00:	b5f7      	push	{r0, r1, r2, r4, r5, r6, r7, lr}
20041f02:	4673      	mov	r3, lr
20041f04:	2221      	movs	r2, #33	; 0x21
20041f06:	2702      	movs	r7, #2
20041f08:	9301      	str	r3, [sp, #4]
20041f0a:	4b28      	ldr	r3, [pc, #160]	; (20041fac <_stage2_boot+0xac>)
20041f0c:	24c0      	movs	r4, #192	; 0xc0
20041f0e:	605a      	str	r2, [r3, #4]
20041f10:	689a      	ldr	r2, [r3, #8]
20041f12:	2501      	movs	r5, #1
20041f14:	43ba      	bics	r2, r7
20041f16:	60da      	str	r2, [r3, #12]
20041f18:	609a      	str	r2, [r3, #8]
20041f1a:	611a      	str	r2, [r3, #16]
20041f1c:	615a      	str	r2, [r3, #20]
20041f1e:	2300      	movs	r3, #0
20041f20:	0564      	lsls	r4, r4, #21
20041f22:	60a3      	str	r3, [r4, #8]
20041f24:	3304      	adds	r3, #4
20041f26:	6163      	str	r3, [r4, #20]
20041f28:	4b21      	ldr	r3, [pc, #132]	; (20041fb0 <_stage2_boot+0xb0>)
20041f2a:	2605      	movs	r6, #5
20041f2c:	601d      	str	r5, [r3, #0]
20041f2e:	23e0      	movs	r3, #224	; 0xe0
20041f30:	02db      	lsls	r3, r3, #11
20041f32:	6023      	str	r3, [r4, #0]
20041f34:	0038      	movs	r0, r7
20041f36:	60a5      	str	r5, [r4, #8]
20041f38:	6626      	str	r6, [r4, #96]	; 0x60
20041f3a:	6626      	str	r6, [r4, #96]	; 0x60
20041f3c:	f000 f848 	bl	20041fd0 <wait_and_read>
20041f40:	b2c0      	uxtb	r0, r0
20041f42:	42b8      	cmp	r0, r7
20041f44:	d010      	beq.n	20041f68 <_stage2_boot+0x68>
20041f46:	2306      	movs	r3, #6
20041f48:	0028      	movs	r0, r5
20041f4a:	6623      	str	r3, [r4, #96]	; 0x60
20041f4c:	f000 f840 	bl	20041fd0 <wait_and_read>
20041f50:	6625      	str	r5, [r4, #96]	; 0x60
20041f52:	0038      	movs	r0, r7
20041f54:	6627      	str	r7, [r4, #96]	; 0x60
20041f56:	f000 f83b 	bl	20041fd0 <wait_and_read>
20041f5a:	6626      	str	r6, [r4, #96]	; 0x60
20041f5c:	2002      	movs	r0, #2
20041f5e:	6626      	str	r6, [r4, #96]	; 0x60
20041f60:	f000 f836 	bl	20041fd0 <wait_and_read>
20041f64:	4228      	tst	r0, r5
20041f66:	d1f8      	bne.n	20041f5a <_stage2_boot+0x5a>
20041f68:	2500      	movs	r5, #0
20041f6a:	4b12      	ldr	r3, [pc, #72]	; (20041fb4 <_stage2_boot+0xb4>)
20041f6c:	60a5      	str	r5, [r4, #8]
20041f6e:	4f12      	ldr	r7, [pc, #72]	; (20041fb8 <_stage2_boot+0xb8>)
20041f70:	6023      	str	r3, [r4, #0]
20041f72:	4b12      	ldr	r3, [pc, #72]	; (20041fbc <_stage2_boot+0xbc>)
20041f74:	6065      	str	r5, [r4, #4]
20041f76:	2601      	movs	r6, #1
20041f78:	603b      	str	r3, [r7, #0]
20041f7a:	23eb      	movs	r3, #235	; 0xeb
20041f7c:	60a6      	str	r6, [r4, #8]
20041f7e:	6623      	str	r3, [r4, #96]	; 0x60
20041f80:	3b4b      	subs	r3, #75	; 0x4b
20041f82:	6623      	str	r3, [r4, #96]	; 0x60
20041f84:	2002      	movs	r0, #2
20041f86:	f000 f823 	bl	20041fd0 <wait_and_read>
20041f8a:	4b0d      	ldr	r3, [pc, #52]	; (20041fc0 <_stage2_boot+0xc0>)
20041f8c:	60a5      	str	r5, [r4, #8]
20041f8e:	603b      	str	r3, [r7, #0]
20041f90:	60a6      	str	r6, [r4, #8]
20041f92:	9b01      	ldr	r3, [sp, #4]
20041f94:	42ab      	cmp	r3, r5
20041f96:	d108      	bne.n	20041faa <_stage2_boot+0xaa>
20041f98:	4b0a      	ldr	r3, [pc, #40]	; (20041fc4 <_stage2_boot+0xc4>)
20041f9a:	4a0b      	ldr	r2, [pc, #44]	; (20041fc8 <_stage2_boot+0xc8>)
20041f9c:	6013      	str	r3, [r2, #0]
20041f9e:	681b      	ldr	r3, [r3, #0]
20041fa0:	f383 8808 	msr	MSP, r3
20041fa4:	4b09      	ldr	r3, [pc, #36]	; (20041fcc <_stage2_boot+0xcc>)
20041fa6:	681b      	ldr	r3, [r3, #0]
20041fa8:	4718      	bx	r3
20041faa:	bdf7      	pop	{r0, r1, r2, r4, r5, r6, r7, pc}
20041fac:	40020000 	.word	0x40020000
20041fb0:	180000f0 	.word	0x180000f0
20041fb4:	005f0300 	.word	0x005f0300
20041fb8:	180000f4 	.word	0x180000f4
20041fbc:	00002221 	.word	0x00002221
20041fc0:	a0002022 	.word	0xa0002022
20041fc4:	10000100 	.word	0x10000100
20041fc8:	e000ed08 	.word	0xe000ed08
20041fcc:	10000104 	.word	0x10000104

20041fd0 <wait_and_read>:
20041fd0:	23c0      	movs	r3, #192	; 0xc0
20041fd2:	0002      	movs	r2, r0
20041fd4:	2104      	movs	r1, #4
20041fd6:	055b      	lsls	r3, r3, #21
20041fd8:	6a98      	ldr	r0, [r3, #40]	; 0x28
20041fda:	4208      	tst	r0, r1
20041fdc:	d0fc      	beq.n	20041fd8 <wait_and_read+0x8>
20041fde:	2101      	movs	r1, #1
20041fe0:	6a98      	ldr	r0, [r3, #40]	; 0x28
20041fe2:	4208      	tst	r0, r1
20041fe4:	d1fc      	bne.n	20041fe0 <wait_and_read+0x10>
20041fe6:	6e18      	ldr	r0, [r3, #96]	; 0x60
20041fe8:	2a01      	cmp	r2, #1
20041fea:	d000      	beq.n	20041fee <wait_and_read+0x1e>
20041fec:	6e18      	ldr	r0, [r3, #96]	; 0x60
20041fee:	4770      	bx	lr
