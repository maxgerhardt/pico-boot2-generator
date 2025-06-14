
generated\Macronix\MX25L3206E\boot2_div_2.elf:     file format elf32-littlearm


Disassembly of section .text:

20041f00 <_stage2_boot>:
20041f00:	2121      	movs	r1, #33	; 0x21
20041f02:	4672      	mov	r2, lr
20041f04:	2002      	movs	r0, #2
20041f06:	b510      	push	{r4, lr}
20041f08:	4b12      	ldr	r3, [pc, #72]	; (20041f54 <_stage2_boot+0x54>)
20041f0a:	4c13      	ldr	r4, [pc, #76]	; (20041f58 <_stage2_boot+0x58>)
20041f0c:	6059      	str	r1, [r3, #4]
20041f0e:	6899      	ldr	r1, [r3, #8]
20041f10:	4381      	bics	r1, r0
20041f12:	60d9      	str	r1, [r3, #12]
20041f14:	23c0      	movs	r3, #192	; 0xc0
20041f16:	2000      	movs	r0, #0
20041f18:	2104      	movs	r1, #4
20041f1a:	055b      	lsls	r3, r3, #21
20041f1c:	6098      	str	r0, [r3, #8]
20041f1e:	6159      	str	r1, [r3, #20]
20041f20:	3903      	subs	r1, #3
20041f22:	6021      	str	r1, [r4, #0]
20041f24:	24e0      	movs	r4, #224	; 0xe0
20041f26:	02e4      	lsls	r4, r4, #11
20041f28:	601c      	str	r4, [r3, #0]
20041f2a:	4c0c      	ldr	r4, [pc, #48]	; (20041f5c <_stage2_boot+0x5c>)
20041f2c:	6099      	str	r1, [r3, #8]
20041f2e:	6098      	str	r0, [r3, #8]
20041f30:	601c      	str	r4, [r3, #0]
20041f32:	6058      	str	r0, [r3, #4]
20041f34:	4c0a      	ldr	r4, [pc, #40]	; (20041f60 <_stage2_boot+0x60>)
20041f36:	480b      	ldr	r0, [pc, #44]	; (20041f64 <_stage2_boot+0x64>)
20041f38:	6004      	str	r4, [r0, #0]
20041f3a:	6099      	str	r1, [r3, #8]
20041f3c:	2a00      	cmp	r2, #0
20041f3e:	d108      	bne.n	20041f52 <_stage2_boot+0x52>
20041f40:	4b09      	ldr	r3, [pc, #36]	; (20041f68 <_stage2_boot+0x68>)
20041f42:	4a0a      	ldr	r2, [pc, #40]	; (20041f6c <_stage2_boot+0x6c>)
20041f44:	6013      	str	r3, [r2, #0]
20041f46:	681b      	ldr	r3, [r3, #0]
20041f48:	f383 8808 	msr	MSP, r3
20041f4c:	4b08      	ldr	r3, [pc, #32]	; (20041f70 <_stage2_boot+0x70>)
20041f4e:	681b      	ldr	r3, [r3, #0]
20041f50:	4718      	bx	r3
20041f52:	bd10      	pop	{r4, pc}
20041f54:	40020000 	.word	0x40020000
20041f58:	180000f0 	.word	0x180000f0
20041f5c:	001f0300 	.word	0x001f0300
20041f60:	03000218 	.word	0x03000218
20041f64:	180000f4 	.word	0x180000f4
20041f68:	10000100 	.word	0x10000100
20041f6c:	e000ed08 	.word	0xe000ed08
20041f70:	10000104 	.word	0x10000104
