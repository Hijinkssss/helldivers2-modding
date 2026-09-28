RANGE 0x12ebc50-0x12ebcc5
012ebc50: mov      r11, rsp
012ebc53: push     rbp
012ebc54: push     rbx
012ebc55: push     r14
012ebc57: lea      rbp, [r11 - 0x108]
012ebc5e: sub      rsp, 0x1f0
012ebc65: movaps   xmmword ptr [r11 - 0x58], xmm7
012ebc6a: mov      rax, qword ptr [rip + 0x135039f] ; RVA 0x263c010
012ebc71: xor      rax, rsp
012ebc74: mov      qword ptr [rbp + 0x50], rax
012ebc78: cmp      byte ptr [rcx + 0x58], 0
012ebc7c: mov      ebx, r8d
012ebc7f: movaps   xmm7, xmm1
012ebc82: mov      r14, rcx
012ebc85: je       0x12ec706
012ebc8b: cmp      byte ptr [rcx + 0x21f5b0], 0
012ebc92: je       0x12ec706
012ebc98: mov      rax, qword ptr [rip + 0x2191189] ; RVA 0x347ce28
012ebc9f: cmp      dword ptr [rax + 0x4294], 0
012ebca6: jne      0x12ec706
012ebcac: cmp      dword ptr [rax + 0x4298], 0
012ebcb3: jne      0x12ec706
012ebcb9: cmp      ebx, dword ptr [rip + 0x2198ac9] ; RVA 0x3484788
012ebcbf: je       0x12ec706
RANGE 0x12ebcc5-0x12ebcd8
012ebcc5: mov      qword ptr [r11 + 0x18], rsi
012ebcc9: movaps   xmm0, xmm1
012ebccc: addss    xmm0, dword ptr [rcx + 0x21f5a8]
012ebcd4: mov      qword ptr [r11 - 0x20], rdi
RANGE 0x12ebcd8-0x12ebce7
012ebcd8: mov      qword ptr [r11 - 0x28], r12
012ebcdc: mov      qword ptr [r11 - 0x30], r13
012ebce0: mov      qword ptr [r11 - 0x38], r15
012ebce4: xor      r15d, r15d
RANGE 0x12ebce7-0x12ebd14
012ebce7: movaps   xmmword ptr [r11 - 0x48], xmm6
012ebcec: movaps   xmmword ptr [r11 - 0x68], xmm8
012ebcf1: movaps   xmmword ptr [r11 - 0x78], xmm9
012ebcf6: movaps   xmmword ptr [r11 - 0x88], xmm10
012ebcfe: movss    dword ptr [rcx + 0x21f5a8], xmm0
012ebd06: cmp      ebx, dword ptr [rip + 0x2197f14] ; RVA 0x3483c20
012ebd0c: movaps   xmmword ptr [r11 - 0x98], xmm11
RANGE 0x12ebd14-0x12ec23a
012ebd14: movaps   xmmword ptr [r11 - 0xa8], xmm12
012ebd1c: je       0x12ebd7d
012ebd1e: mov      rax, qword ptr [rip + 0x203a743] ; RVA 0x3326468
012ebd25: mov      edx, r15d
012ebd28: mov      r8d, dword ptr [rax + 0xd8]
012ebd2f: mov      r9d, dword ptr [rax + 0xe0]
012ebd36: imul     r9d, ebx
012ebd3a: lea      edi, [r8 - 1]
012ebd3e: test     r8d, r8d
012ebd41: je       0x12ebd7d
012ebd43: mov      r10, qword ptr [rax + 0xd0]
012ebd4a: mov      r11d, dword ptr [rax + 0xdc]
012ebd51: nop      dword ptr [rax]
012ebd55: nop      word ptr [rax + rax]
012ebd60: mov      eax, edi
012ebd62: lea      ecx, [rdx + r9]
012ebd66: and      rcx, rax
012ebd69: mov      eax, dword ptr [r10 + rcx*8]
012ebd6d: cmp      eax, r11d
012ebd70: je       0x12ebd7d
012ebd72: cmp      eax, ebx
012ebd74: je       0x12ebd7d
012ebd76: inc      edx
012ebd78: cmp      edx, r8d
012ebd7b: jb       0x12ebd60
012ebd7d: mov      r8d, ebx
012ebd80: lea      rdx, [rsp + 0x58]
012ebd85: call     0x606630
012ebd8a: lea      rcx, [r14 + 0x208898]
012ebd91: call     0x1872aa0
012ebd96: mov      esi, dword ptr [rsp + 0x58]
012ebd9a: lea      rcx, [r14 + 0x60]
012ebd9e: mov      r9d, esi
012ebda1: mov      r8d, ebx
012ebda4: movaps   xmm1, xmm7
012ebda7: call     0x18199a0
012ebdac: lea      rcx, [r14 + 0x5778]
012ebdb3: mov      r9d, esi
012ebdb6: mov      r8d, ebx
012ebdb9: movaps   xmm1, xmm7
012ebdbc: call     0x181eac0
012ebdc1: lea      rcx, [r14 + 0x8208]
012ebdc8: mov      r9d, esi
012ebdcb: mov      r8d, ebx
012ebdce: call     0x1820120
012ebdd3: lea      rcx, [r14 + 0x17f540]
012ebdda: mov      r9d, esi
012ebddd: mov      r8d, ebx
012ebde0: movaps   xmm1, xmm7
012ebde3: call     0x183d830
012ebde8: lea      rcx, [r14 + 0x1b010]
012ebdef: call     0x18231d0
012ebdf4: lea      rcx, [r14 + 0x19aaf8]
012ebdfb: mov      r8d, ebx
012ebdfe: movaps   xmm1, xmm7
012ebe01: call     0x17b6490
012ebe06: lea      rcx, [r14 + 0x20b470]
012ebe0d: call     0x17c16a0
012ebe12: mov      rax, qword ptr [rip + 0x203a527] ; RVA 0x3326340
012ebe19: movss    xmm11, dword ptr [rip + 0x10dbf9a] ; RVA 0x23c7dbc
012ebe22: movss    xmm12, dword ptr [rip + 0x10dbf25] ; RVA 0x23c7d50
012ebe2b: movss    xmm6, dword ptr [rip + 0x10daf2d] ; RVA 0x23c6d60
012ebe33: cmp      dword ptr [rax + 0xac21c], 4
012ebe3a: jne      0x12ebebb
012ebe3c: mov      rcx, qword ptr [r14 + 0x20b2f8]
012ebe43: test     rcx, rcx
012ebe46: je       0x12ebe4f
012ebe48: call     0x144c2e0
012ebe4d: jmp      0x12ebe56
012ebe4f: lea      rax, [r14 + 0x20b208]
012ebe56: movss    xmm1, dword ptr [rax + 0x11c]
012ebe5e: lea      rcx, [r14 + 0x20b208]
012ebe65: movss    xmm0, dword ptr [rax + 0x120]
012ebe6d: addss    xmm1, xmm1
012ebe71: addss    xmm0, xmm0
012ebe75: divss    xmm1, xmm11
012ebe7a: divss    xmm0, xmm12
012ebe7f: addss    xmm1, xmm6
012ebe83: addss    xmm0, xmm6
012ebe87: movss    dword ptr [rsp + 0x50], xmm1
012ebe8d: movss    dword ptr [rsp + 0x54], xmm0
012ebe93: mov      rdx, qword ptr [rsp + 0x50]
012ebe98: call     0x1447e40
012ebe9d: lea      rcx, [r14 + 0x216378]
012ebea4: movaps   xmm1, xmm7
012ebea7: call     0x1871000
012ebeac: lea      rcx, [r14 + 0x21b4d8]
012ebeb3: movaps   xmm1, xmm7
012ebeb6: call     0x18708f0
012ebebb: lea      rcx, [r14 + 0x206138]
012ebec2: movaps   xmm1, xmm7
012ebec5: call     0x17ce210
012ebeca: lea      rcx, [r14 + 0x1f8c8]
012ebed1: mov      r9d, esi
012ebed4: mov      r8d, ebx
012ebed7: movaps   xmm1, xmm7
012ebeda: call     0x182d910
012ebedf: mov      rax, qword ptr [rip + 0x2181652] ; RVA 0x346d538
012ebee6: lea      r13, [r14 + 0x3f358]
012ebeed: movss    xmm8, dword ptr [rip + 0x10da94e] ; RVA 0x23c6844
012ebef6: xorps    xmm9, xmm9
012ebefa: comiss   xmm9, dword ptr [r13 + 0x44]
012ebeff: setae    dil
012ebf03: cmp      byte ptr [rax + 0x46d8f2], r15b
012ebf0a: movzx    eax, byte ptr [r13 + 0x6ce8]
012ebf12: sete     dl
012ebf15: cmp      al, dl
012ebf17: je       0x12ebf3e
012ebf19: movaps   xmm3, xmm6
012ebf1c: movss    dword ptr [rsp + 0x20], xmm9
012ebf23: movaps   xmm2, xmm8
012ebf27: mov      byte ptr [r13 + 0x6ce8], dl
012ebf2e: mov      rcx, r13
012ebf31: call     0x1450d40
012ebf36: movzx    eax, byte ptr [r13 + 0x6ce8]
012ebf3e: test     al, al
012ebf40: je       0x12ebf52
012ebf42: movss    xmm0, dword ptr [r13 + 0x44]
012ebf48: comiss   xmm0, xmm9
012ebf4c: jbe      0x12ebfd5
012ebf52: test     dil, dil
012ebf55: je       0x12ebf82
012ebf57: test     al, al
012ebf59: jne      0x12ebf82
012ebf5b: mov      dl, 1
012ebf5d: mov      rcx, r13
012ebf60: call     0x186c990
012ebf65: cmp      qword ptr [r13 + 0x6cf0], r15
012ebf6c: ja       0x12ebf71
012ebf6e: xorps    xmm6, xmm6
012ebf71: lea      rcx, [r13 + 0x110]
012ebf78: movaps   xmm1, xmm6
012ebf7b: call     0x1448a40
012ebf80: jmp      0x12ebfb0
012ebf82: xor      edx, edx
012ebf84: mov      rcx, r13
012ebf87: call     0x186c990
012ebf8c: cmp      qword ptr [r13 + 0x6cf0], r15
012ebf93: lea      rcx, [r13 + 0x110]
012ebf9a: movaps   xmm3, xmm6
012ebf9d: movss    dword ptr [rsp + 0x20], xmm9
012ebfa4: sete     dl
012ebfa7: movaps   xmm2, xmm8
012ebfab: call     0x1450d40
012ebfb0: lea      rdi, [r13 + 0x220]
012ebfb7: mov      r12d, 8
012ebfbd: nop      dword ptr [rax]
012ebfc0: mov      rcx, rdi
012ebfc3: call     0x186b530
012ebfc8: add      rdi, 0xc98
012ebfcf: sub      r12, 1
012ebfd3: jne      0x12ebfc0
012ebfd5: lea      rcx, [r13 + 0x6868]
012ebfdc: call     0x18f5ba0
012ebfe1: movaps   xmm0, xmm7
012ebfe4: addss    xmm0, dword ptr [r14 + 0x54]
012ebfea: comiss   xmm0, dword ptr [rip + 0x10da75b] ; RVA 0x23c674c
012ebff1: movss    dword ptr [r14 + 0x54], xmm0
012ebff7: jbe      0x12ec148
012ebffd: cmp      byte ptr [r14 + 0x15908], r15b
012ec004: jne      0x12ec04a
012ec006: mov      dl, 1
012ec008: lea      rcx, [r14 + 0x15928]
012ec00f: call     0x182cfe0
012ec014: mov      dl, 1
012ec016: lea      rcx, [r14 + 0x19318]
012ec01d: call     0x182cfe0
012ec022: mov      dl, 1
012ec024: lea      rcx, [r14 + 0x17620]
012ec02b: call     0x182cfe0
012ec030: mov      r9d, esi
012ec033: lea      rcx, [r14 + 0x9c38]
012ec03a: mov      r8d, ebx
012ec03d: movaps   xmm1, xmm7
012ec040: call     0x1825e70
012ec045: jmp      0x12ec148
012ec04a: cmp      byte ptr [r14 + 0x175f8], r15b
012ec051: jne      0x12ec087
012ec053: mov      dl, 1
012ec055: lea      rcx, [r14 + 0x19318]
012ec05c: call     0x182cfe0
012ec061: mov      dl, 1
012ec063: lea      rcx, [r14 + 0x17620]
012ec06a: call     0x182cfe0
012ec06f: lea      rcx, [r14 + 0x9c38]
012ec076: call     0x18289a0
012ec07b: lea      rcx, [r14 + 0x15928]
012ec082: jmp      0x12ec13a
012ec087: cmp      byte ptr [r14 + 0x192f0], r15b
012ec08e: jne      0x12ec0c1
012ec090: mov      dl, 1
012ec092: lea      rcx, [r14 + 0x19318]
012ec099: call     0x182cfe0
012ec09e: lea      rcx, [r14 + 0x9c38]
012ec0a5: call     0x18289a0
012ec0aa: mov      dl, 1
012ec0ac: lea      rcx, [r14 + 0x15928]
012ec0b3: call     0x182cfe0
012ec0b8: lea      rcx, [r14 + 0x17620]
012ec0bf: jmp      0x12ec13a
012ec0c1: cmp      byte ptr [r14 + 0x1afe8], r15b
012ec0c8: jne      0x12ec0f4
012ec0ca: mov      dl, 1
012ec0cc: lea      rcx, [r14 + 0x15928]
012ec0d3: call     0x182cfe0
012ec0d8: mov      dl, 1
012ec0da: lea      rcx, [r14 + 0x17620]
012ec0e1: call     0x182cfe0
012ec0e6: lea      rcx, [r14 + 0x9c38]
012ec0ed: call     0x18289a0
012ec0f2: jmp      0x12ec133
012ec0f4: mov      r9d, esi
012ec0f7: lea      rcx, [r14 + 0x9c38]
012ec0fe: mov      r8d, ebx
012ec101: movaps   xmm1, xmm7
012ec104: call     0x1825e70
012ec109: mov      r9d, esi
012ec10c: lea      rcx, [r14 + 0x17620]
012ec113: mov      r8d, ebx
012ec116: movaps   xmm1, xmm7
012ec119: call     0x182a480
012ec11e: mov      r9d, esi
012ec121: lea      rcx, [r14 + 0x15928]
012ec128: mov      r8d, ebx
012ec12b: movaps   xmm1, xmm7
012ec12e: call     0x182a480
012ec133: lea      rcx, [r14 + 0x19318]
012ec13a: mov      r9d, esi
012ec13d: mov      r8d, ebx
012ec140: movaps   xmm1, xmm7
012ec143: call     0x182a480
012ec148: lea      rcx, [r14 + 0x1a0e28]
012ec14f: mov      r8d, ebx
012ec152: movaps   xmm1, xmm7
012ec155: call     0x18a7b90
012ec15a: mov      rcx, qword ptr [rip + 0x203a527] ; RVA 0x3326688
012ec161: mov      edx, esi
012ec163: call     0x927050
012ec168: test     al, al
012ec16a: je       0x12ec183
012ec16c: movaps   xmm0, xmm7
012ec16f: addss    xmm0, dword ptr [r14 + 0x21f5ac]
012ec178: movss    dword ptr [r14 + 0x21f5ac], xmm0
012ec181: jmp      0x12ec18a
012ec183: mov      dword ptr [r14 + 0x21f5ac], r15d
012ec18a: mov      rax, qword ptr [rip + 0x24d9347] ; RVA 0x37c54d8
012ec191: mov      r13, qword ptr [rip + 0x2190cf8] ; RVA 0x347ce90
012ec198: mov      edx, dword ptr [rax + 4]
012ec19b: lea      rax, [rip - 0x12ec1a2] ; RVA 0x0
012ec1a2: lea      rcx, [r13 + 0x3698]
012ec1a9: mov      rdi, qword ptr [rax + rdx*8 + 0x3772260]
012ec1b1: mov      rdx, qword ptr [rax + rdx*8 + 0x37c5470]
012ec1b9: mov      rdx, qword ptr [rdx + 0x18]
012ec1bd: call     0x12ee1e0
012ec1c2: mov      rcx, qword ptr [rip + 0x203a13f] ; RVA 0x3326308
012ec1c9: mov      r12, rax
012ec1cc: mov      rdx, qword ptr [rcx + 0xd0]
012ec1d3: call     qword ptr [rdx + 0x2b8]
012ec1d9: xorps    xmm1, xmm1
012ec1dc: mov      qword ptr [rsp + 0x50], rax
012ec1e1: movss    xmm10, dword ptr [rsp + 0x50]
012ec1e8: movss    xmm2, dword ptr [rsp + 0x54]
012ec1ee: movaps   xmm8, xmm10
012ec1f2: movaps   xmm0, xmm2
012ec1f5: divss    xmm8, xmm11
012ec1fa: divss    xmm0, xmm12
012ec1ff: movups   xmmword ptr [rbp - 0x30], xmm1
012ec203: minss    xmm8, xmm0
012ec208: movups   xmmword ptr [rbp - 0x20], xmm1
012ec20c: movups   xmmword ptr [rbp - 0x10], xmm1
012ec210: movups   xmmword ptr [rbp], xmm1
012ec214: movups   xmmword ptr [rbp + 0x10], xmm1
012ec218: movups   xmmword ptr [rbp + 0x20], xmm1
012ec21c: movups   xmmword ptr [rbp + 0x30], xmm1
012ec220: movups   xmmword ptr [rbp + 0x40], xmm1
012ec224: call     0x12eb3f0
012ec229: movaps   xmm12, xmmword ptr [rsp + 0x160]
012ec232: test     al, al
012ec234: jne      0x12ec4c9
RANGE 0x12ec23a-0x12ec4fc
012ec23a: cmp      dword ptr [r14 + 0x10], 6
012ec23f: je       0x12ec4c9
012ec245: movss    xmm0, dword ptr [r14 + 8]
012ec24b: lea      r9, [rsp + 0x60]
012ec250: mulss    xmm2, dword ptr [rip + 0x10da700] ; RVA 0x23c6958
012ec258: subss    xmm0, xmm7
012ec25c: lea      rdx, [rsp + 0x50]
012ec261: mov      r8d, 0x320
012ec267: movss    xmm11, dword ptr [rip + 0x10da850] ; RVA 0x23c6ac0
012ec270: movaps   xmm1, xmm8
012ec274: mulss    xmm1, dword ptr [rip + 0x10db4b4] ; RVA 0x23c7730
012ec27c: movss    dword ptr [rsp + 0x50], xmm10
012ec283: movss    dword ptr [r14 + 8], xmm0
012ec289: mov      rcx, qword ptr [r13 + 0x36a0]
012ec290: movss    dword ptr [rsp + 0x54], xmm1
012ec296: mov      rax, qword ptr [rsp + 0x50]
012ec29b: mov      qword ptr [rsp + 0x60], rax
012ec2a0: movss    xmm0, dword ptr [rsp + 0x64]
012ec2a6: mov      dword ptr [rsp + 0x50], r15d
012ec2ab: mulss    xmm0, xmm11
012ec2b0: subss    xmm2, xmm0
012ec2b4: movss    dword ptr [rsp + 0x54], xmm2
012ec2ba: mov      rax, qword ptr [rsp + 0x50]
012ec2bf: mov      qword ptr [rsp + 0x50], rax
012ec2c4: mov      rax, qword ptr [rip + 0x203a03d] ; RVA 0x3326308
012ec2cb: mov      r10, qword ptr [rax + 0xd0]
012ec2d2: lea      rax, [rip + 0xee65df] ; RVA 0x21d28b8
012ec2d9: mov      qword ptr [rsp + 0x20], rax
012ec2de: call     qword ptr [r10 + 0xf0]
012ec2e5: movsxd   rax, dword ptr [r14 + 0x10]
012ec2e9: cmp      eax, 5
012ec2ec: ja       0x12ec3cc
012ec2f2: lea      rdx, [rip - 0x12ec2f9] ; RVA 0x0
012ec2f9: mov      ecx, dword ptr [rdx + rax*4 + 0x12ec728]
012ec300: add      rcx, rdx
012ec303: jmp      rcx
012ec305: mov      qword ptr [rsp + 0x38], r15
012ec30a: mov      r8d, 0x2da
012ec310: mov      byte ptr [rsp + 0x30], 1
012ec315: mov      dword ptr [rsp + 0x28], 0xf887a2ea
012ec31d: jmp      0x12ec3ad
012ec322: mov      qword ptr [rsp + 0x38], r15
012ec327: mov      r8d, 0x2dd
012ec32d: mov      byte ptr [rsp + 0x30], 1
012ec332: mov      dword ptr [rsp + 0x28], 0x71146b9d
012ec33a: jmp      0x12ec3ad
012ec33c: mov      r8d, 0x2e0
012ec342: jmp      0x12ec399
012ec344: mov      rax, qword ptr [rip + 0x2190b1d] ; RVA 0x347ce68
012ec34b: lea      r9, [rbp - 0x30]
012ec34f: add      rax, 0xe8
012ec355: mov      qword ptr [rsp + 0x40], rax
012ec35a: mov      dword ptr [rsp + 0x38], 1
012ec362: mov      dword ptr [rsp + 0x28], 0x2278fadc
012ec36a: mov      dword ptr [rsp + 0x20], 0x80
012ec372: call     0x13006a0
012ec377: jmp      0x12ec3cc
012ec379: mov      qword ptr [rsp + 0x38], r15
012ec37e: mov      r8d, 0x2e6
012ec384: mov      byte ptr [rsp + 0x30], 1
012ec389: mov      dword ptr [rsp + 0x28], 0x1c8cb08a
012ec391: jmp      0x12ec3ad
012ec393: mov      r8d, 0x2e9
012ec399: mov      rax, qword ptr [r14 + 0x18]
012ec39d: mov      qword ptr [rsp + 0x38], r15
012ec3a2: mov      byte ptr [rsp + 0x30], 1
012ec3a7: mov      eax, dword ptr [rax]
012ec3a9: mov      dword ptr [rsp + 0x28], eax
012ec3ad: mov      rcx, qword ptr [rip + 0x2190b14] ; RVA 0x347cec8
012ec3b4: lea      r9, [rbp - 0x30]
012ec3b8: lea      rdx, [rip + 0xfd5ef1] ; RVA 0x22c22b0
012ec3bf: mov      dword ptr [rsp + 0x20], 0x80
012ec3c7: call     0x13001c0
012ec3cc: mov      rax, qword ptr [rip + 0x2039f35] ; RVA 0x3326308
012ec3d3: lea      r8, [rbp - 0x30]
012ec3d7: mov      rdx, qword ptr [r13 + 0x36a0]
012ec3de: movaps   xmm6, xmm8
012ec3e2: mulss    xmm6, dword ptr [rip + 0x10db2ea] ; RVA 0x23c76d4
012ec3ea: mov      r9, rdi
012ec3ed: mov      rcx, qword ptr [rax + 0xd0]
012ec3f4: movss    dword ptr [rsp + 0x28], xmm9
012ec3fb: movss    dword ptr [rsp + 0x20], xmm6
012ec401: mov      rax, qword ptr [rcx + 0x1d0]
012ec408: lea      rcx, [rbp - 0x60]
012ec40c: call     rax
012ec40e: mulss    xmm8, dword ptr [rip + 0x10db199] ; RVA 0x23c75b0
012ec417: lea      rdx, [rbp - 0x30]
012ec41b: mov      rcx, qword ptr [r13 + 0x36a0]
012ec422: mov      r8, rdi
012ec425: xorps    xmm0, xmm0
012ec428: mulss    xmm10, xmm11
012ec42d: movups   xmm2, xmmword ptr [rax + 0x10]
012ec431: cvtps2pd xmm1, xmm10
012ec435: cvtss2sd xmm0, xmm2
012ec439: movaps   xmm3, xmm6
012ec43c: mulsd    xmm0, qword ptr [rip + 0x10dab74] ; RVA 0x23c6fb8
012ec444: subsd    xmm1, xmm0
012ec448: movss    xmm0, dword ptr [rsp + 0x50]
012ec44e: cvtpd2ps xmm1, xmm1
012ec452: addss    xmm0, xmm1
012ec456: movss    xmm1, dword ptr [rsp + 0x54]
012ec45c: addss    xmm1, xmm8
012ec461: movss    dword ptr [rsp + 0x58], xmm0
012ec467: movss    dword ptr [rsp + 0x5c], xmm1
012ec46d: mov      rax, qword ptr [rsp + 0x58]
012ec472: mov      qword ptr [rsp + 0x70], rax
012ec477: mov      rax, qword ptr [rip + 0x2039e8a] ; RVA 0x3326308
012ec47e: mov      r9, qword ptr [rax + 0xd0]
012ec485: lea      rax, [rip + 0xee640c] ; RVA 0x21d2898
012ec48c: mov      qword ptr [rsp + 0x40], rax
012ec491: lea      rax, [rsp + 0x70]
012ec496: movss    dword ptr [rsp + 0x38], xmm9
012ec49d: mov      dword ptr [rsp + 0x30], 0x321
012ec4a5: mov      qword ptr [rsp + 0x28], rax
012ec4aa: mov      qword ptr [rsp + 0x20], r12
012ec4af: call     qword ptr [r9 + 0x180]
012ec4b6: comiss   xmm9, dword ptr [r14 + 8]
012ec4bb: jb       0x12ec4c9
012ec4bd: mov      edx, dword ptr [r14 + 0x10]
012ec4c1: mov      rcx, r14
012ec4c4: call     0x12eb2a0
012ec4c9: mov      r13, qword ptr [rip + 0x2039f98] ; RVA 0x3326468
012ec4d0: movaps   xmm11, xmmword ptr [rsp + 0x170]
012ec4d9: movaps   xmm10, xmmword ptr [rsp + 0x180]
012ec4e2: movaps   xmm8, xmmword ptr [rsp + 0x1a0]
012ec4eb: movaps   xmm6, xmmword ptr [rsp + 0x1c0]
012ec4f3: cmp      dword ptr [r13 + 0x88], r15d
012ec4fa: je       0x12ec509
RANGE 0x12ec4fc-0x12ec644
012ec4fc: mov      rax, qword ptr [r13 + 0xe8]
012ec503: add      rax, 8
012ec507: jmp      0x12ec510
012ec509: lea      rax, [rip + 0x2197724] ; RVA 0x3483c34
012ec510: mov      edi, dword ptr [rax]
012ec512: cmp      dword ptr [r13 + 0x88], r15d
012ec519: je       0x12ec52e
012ec51b: mov      edx, dword ptr [r13 + 0x3a8]
012ec522: lea      rcx, [rsp + 0x58]
012ec527: call     0xfd9ba0
012ec52c: jmp      0x12ec53d
012ec52e: mov      eax, dword ptr [rip + 0x2197700] ; RVA 0x3483c34
012ec534: mov      dword ptr [rsp + 0x58], eax
012ec538: lea      rax, [rsp + 0x58]
012ec53d: mov      edx, dword ptr [rip + 0x21976dd] ; RVA 0x3483c20
012ec543: mov      r8d, dword ptr [rax]
012ec546: cmp      edi, edx
012ec548: je       0x12ec5a0
012ec54a: mov      r12d, dword ptr [r13 + 0xe0]
012ec551: mov      ecx, r15d
012ec554: mov      r11d, dword ptr [r13 + 0xd8]
012ec55b: imul     r12d, edi
012ec55f: test     r11d, r11d
012ec562: je       0x12ec5a0
012ec564: mov      r10, qword ptr [r13 + 0xd0]
012ec56b: nop      dword ptr [rax + rax]
012ec570: lea      eax, [r11 - 1]
012ec574: lea      r9d, [r12 + rcx]
012ec578: and      r9, rax
012ec57b: mov      eax, 0xffffffff
012ec580: mov      r10d, dword ptr [r10 + r9*8]
012ec584: cmp      r10d, dword ptr [r13 + 0xdc]
012ec58b: je       0x12ec602
012ec58d: cmp      r10d, edi
012ec590: je       0x12ec607
012ec592: mov      r10, qword ptr [r13 + 0xd0]
012ec599: inc      ecx
012ec59b: cmp      ecx, r11d
012ec59e: jb       0x12ec570
012ec5a0: mov      eax, 0xffffffff
012ec5a5: mov      ecx, eax
012ec5a7: mov      r9d, ecx
012ec5aa: imul     r9, r9, 0x70
012ec5ae: mov      qword ptr [rsp + 0x68], r9
012ec5b3: cmp      edi, edx
012ec5b5: je       0x12ec623
012ec5b7: mov      r10d, dword ptr [r13 + 0xe0]
012ec5be: mov      r9d, dword ptr [r13 + 0xd8]
012ec5c5: imul     r10d, edi
012ec5c9: test     r9d, r9d
012ec5cc: je       0x12ec61e
012ec5ce: mov      r11, qword ptr [r13 + 0xd0]
012ec5d5: mov      r12d, dword ptr [r13 + 0xdc]
012ec5dc: nop      dword ptr [rax]
012ec5e0: lea      ecx, [r9 - 1]
012ec5e4: lea      edx, [r15 + r10]
012ec5e8: and      rdx, rcx
012ec5eb: mov      ecx, dword ptr [r11 + rdx*8]
012ec5ef: cmp      ecx, r12d
012ec5f2: je       0x12ec615
012ec5f4: cmp      ecx, edi
012ec5f6: je       0x12ec619
012ec5f8: inc      r15d
012ec5fb: cmp      r15d, r9d
012ec5fe: jb       0x12ec5e0
012ec600: jmp      0x12ec61e
012ec602: cmp      r10d, edi
012ec605: jne      0x12ec5a5
012ec607: mov      rcx, qword ptr [r13 + 0xd0]
012ec60e: mov      ecx, dword ptr [rcx + r9*8 + 4]
012ec613: jmp      0x12ec5a7
012ec615: cmp      ecx, edi
012ec617: jne      0x12ec61e
012ec619: mov      eax, dword ptr [r11 + rdx*8 + 4]
012ec61e: mov      r9, qword ptr [rsp + 0x68]
012ec623: mov      r15, qword ptr [rsp + 0x1d0]
012ec62b: mov      r12, qword ptr [rsp + 0x1e0]
012ec633: mov      ecx, eax
012ec635: imul     rax, rcx, 0x38
012ec639: cmp      dword ptr [rax + r13 + 0x2e0], 2
012ec642: jne      0x12ec654
RANGE 0x12ec644-0x12ec706
012ec644: movss    xmm0, dword ptr [r9 + r13 + 0x12c]
012ec64e: comiss   xmm0, xmm9
012ec652: ja       0x12ec6ba
012ec654: cmp      r8d, dword ptr [rip + 0x219812d] ; RVA 0x3484788
012ec65b: je       0x12ec670
012ec65d: mov      rcx, qword ptr [rip + 0x203a024] ; RVA 0x3326688
012ec664: mov      edx, r8d
012ec667: call     0x927050
012ec66c: test     al, al
012ec66e: je       0x12ec6ba
012ec670: call     0x127b9f0
012ec675: cmp      ax, 7
012ec679: jne      0x12ec6ba
012ec67b: mov      dl, 1
012ec67d: lea      rcx, [r14 + 0x195ee0]
012ec684: call     0x1450850
012ec689: mov      dl, 1
012ec68b: lea      rcx, [r14 + 0x197e20]
012ec692: call     0x1450850
012ec697: lea      rcx, [r14 + 0x195ee0]
012ec69e: movaps   xmm1, xmm7
012ec6a1: call     0x1861ed0
012ec6a6: mov      r9d, esi
012ec6a9: lea      rcx, [r14 + 0x197e20]
012ec6b0: mov      r8d, ebx
012ec6b3: call     0x1862e60
012ec6b8: jmp      0x12ec6d6
012ec6ba: lea      rcx, [r14 + 0x195ee0]
012ec6c1: xor      edx, edx
012ec6c3: call     0x1450850
012ec6c8: lea      rcx, [r14 + 0x197e20]
012ec6cf: xor      edx, edx
012ec6d1: call     0x1450850
012ec6d6: lea      rcx, [r14 + 0x19a3a0]
012ec6dd: movaps   xmm1, xmm7
012ec6e0: call     0x1863a40
012ec6e5: movaps   xmm9, xmmword ptr [rsp + 0x190]
012ec6ee: mov      r13, qword ptr [rsp + 0x1d8]
012ec6f6: mov      rdi, qword ptr [rsp + 0x1e8]
012ec6fe: mov      rsi, qword ptr [rsp + 0x220]
RANGE 0x12ec706-0x12ec740
012ec706: mov      rcx, qword ptr [rbp + 0x50]
012ec70a: xor      rcx, rsp
012ec70d: call     0x20886a0
012ec712: movaps   xmm7, xmmword ptr [rsp + 0x1b0]
012ec71a: add      rsp, 0x1f0
012ec721: pop      r14
012ec723: pop      rbx
012ec724: pop      rbp
012ec725: ret      
012ec726: nop      
012ec728: add      eax, 0x22012ec3
012ec72d: ret      
012ec72e: add      dword ptr cs:[rbx + rax*8], edi
012ec732: add      dword ptr cs:[rbx + rax*8 + 0x2e], eax
012ec737: add      dword ptr [rcx - 0x3d], edi