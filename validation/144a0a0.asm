RANGE 0x144a0a0-0x144a34a
0144a0a0: mov      rax, rsp
0144a0a3: push     rbx
0144a0a4: sub      rsp, 0xf0
0144a0ab: movss    xmm1, dword ptr [rcx + 0x6c]
0144a0b0: xorps    xmm0, xmm0
0144a0b3: movss    xmm4, dword ptr [rcx + 0x64]
0144a0b8: mov      rbx, rcx
0144a0bb: movss    xmm3, dword ptr [rcx + 0x7c]
0144a0c0: movaps   xmmword ptr [rax - 0x18], xmm6
0144a0c4: movss    xmm6, dword ptr [rcx + 0x74]
0144a0c9: mulss    xmm6, xmm0
0144a0cd: mulss    xmm3, xmm0
0144a0d1: movaps   xmmword ptr [rax - 0x28], xmm7
0144a0d5: movss    xmm7, dword ptr [rcx + 0x8c]
0144a0dd: movaps   xmmword ptr [rax - 0x38], xmm8
0144a0e2: movaps   xmm2, xmm7
0144a0e5: movaps   xmmword ptr [rax - 0x48], xmm9
0144a0ea: movaps   xmmword ptr [rax - 0x58], xmm10
0144a0ef: movss    xmm10, dword ptr [rcx + 0x84]
0144a0f8: movaps   xmmword ptr [rax - 0x68], xmm11
0144a0fd: movaps   xmm5, xmm10
0144a101: movss    xmm11, dword ptr [rcx + 0x9c]
0144a10a: movaps   xmmword ptr [rax - 0x78], xmm12
0144a10f: movaps   xmm12, xmm4
0144a113: mov      rax, qword ptr [rip + 0x1edc1ee] ; RVA 0x3326308
0144a11a: movaps   xmmword ptr [rsp + 0x70], xmm13
0144a120: movaps   xmmword ptr [rsp + 0x60], xmm14
0144a126: movaps   xmmword ptr [rsp + 0x50], xmm15
0144a12c: movss    xmm15, dword ptr [rcx + 0x94]
0144a135: movss    xmm14, dword ptr [rcx + 0x24]
0144a13b: movss    xmm13, dword ptr [rcx + 0x28]
0144a141: movaps   xmm8, xmm14
0144a145: mulss    xmm8, dword ptr [rdx]
0144a14a: movaps   xmm9, xmm13
0144a14e: mov      rcx, qword ptr [rax + 0xd0]
0144a155: mulss    xmm9, dword ptr [rdx + 4]
0144a15b: mulss    xmm14, dword ptr [r8]
0144a160: mulss    xmm12, xmm8
0144a165: addss    xmm14, xmm8
0144a16a: mulss    xmm5, xmm9
0144a16f: addss    xmm12, xmm6
0144a174: mulss    xmm2, xmm9
0144a179: movss    dword ptr [rsp + 0x20], xmm13
0144a180: movaps   xmm13, xmm1
0144a184: mulss    xmm13, xmm8
0144a189: movaps   xmm0, xmm5
0144a18c: addss    xmm0, xmm12
0144a191: movss    dword ptr [rsp + 0x30], xmm12
0144a198: addss    xmm13, xmm3
0144a19d: addss    xmm0, xmm15
0144a1a2: movss    dword ptr [rsp + 0x44], xmm0
0144a1a8: movaps   xmm0, xmm2
0144a1ab: addss    xmm0, xmm13
0144a1b0: addss    xmm0, xmm11
0144a1b5: movss    dword ptr [rsp + 0x48], xmm0
0144a1bb: movaps   xmm0, xmm14
0144a1bf: mulss    xmm14, xmm1
0144a1c4: movss    xmm1, dword ptr [rsp + 0x20]
0144a1ca: mulss    xmm1, dword ptr [r8 + 4]
0144a1d0: addss    xmm14, xmm3
0144a1d5: mulss    xmm0, xmm4
0144a1d9: addss    xmm1, xmm9
0144a1de: addss    xmm0, xmm6
0144a1e2: movss    dword ptr [rsp + 0x40], xmm14
0144a1e9: addss    xmm14, xmm2
0144a1ee: movaps   xmm9, xmm1
0144a1f2: mulss    xmm1, xmm7
0144a1f6: mulss    xmm9, xmm10
0144a1fb: movaps   xmm12, xmm0
0144a1ff: movaps   xmm8, xmm1
0144a203: addss    xmm12, xmm5
0144a208: addss    xmm8, dword ptr [rsp + 0x40]
0144a20f: movaps   xmm6, xmm9
0144a213: addss    xmm1, xmm13
0144a218: addss    xmm9, dword ptr [rsp + 0x30]
0144a21f: addss    xmm6, xmm0
0144a223: addss    xmm12, xmm15
0144a228: addss    xmm14, xmm11
0144a22d: addss    xmm1, xmm11
0144a232: addss    xmm8, xmm11
0144a237: addss    xmm6, xmm15
0144a23c: addss    xmm9, xmm15
0144a241: movss    dword ptr [rsp + 0x20], xmm1
0144a247: call     qword ptr [rcx + 0x2b8]
0144a24d: movss    xmm11, dword ptr [rsp + 0x44]
0144a254: lea      r11, [rsp + 0xf0]
0144a25c: movss    xmm10, dword ptr [rsp + 0x48]
0144a263: movaps   xmm4, xmm11
0144a267: movss    xmm13, dword ptr [rsp + 0x20]
0144a26e: maxss    xmm11, xmm12
0144a273: movss    xmm3, dword ptr [rip + 0xf7cae5] ; RVA 0x23c6d60
0144a27b: minss    xmm4, xmm12
0144a280: movaps   xmm12, xmmword ptr [r11 - 0x70]
0144a285: movaps   xmm5, xmm10
0144a289: movaps   xmm15, xmmword ptr [rsp + 0x50]
0144a28f: maxss    xmm5, xmm14
0144a294: movaps   xmm0, xmm9
0144a298: mov      qword ptr [rsp + 0x30], rax
0144a29d: minss    xmm0, xmm6
0144a2a1: maxss    xmm9, xmm6
0144a2a6: movaps   xmm6, xmmword ptr [r11 - 0x10]
0144a2ab: minss    xmm10, xmm14
0144a2b0: movaps   xmm14, xmmword ptr [rsp + 0x60]
0144a2b6: minss    xmm4, xmm0
0144a2ba: movaps   xmm0, xmm13
0144a2be: maxss    xmm0, xmm8
0144a2c3: maxss    xmm11, xmm9
0144a2c8: movaps   xmm9, xmmword ptr [r11 - 0x40]
0144a2cd: minss    xmm13, xmm8
0144a2d2: movaps   xmm8, xmmword ptr [r11 - 0x30]
0144a2d7: movaps   xmm7, xmm4
0144a2da: divss    xmm7, dword ptr [rsp + 0x30]
0144a2e0: maxss    xmm5, xmm0
0144a2e4: shufps   xmm7, xmm7, 0xe1
0144a2e8: minss    xmm10, xmm13
0144a2ed: movaps   xmm13, xmmword ptr [r11 - 0x80]
0144a2f2: subss    xmm11, xmm4
0144a2f7: movaps   xmm0, xmm5
0144a2fa: divss    xmm0, dword ptr [rsp + 0x34]
0144a300: divss    xmm11, dword ptr [rsp + 0x30]
0144a307: subss    xmm5, xmm10
0144a30c: movaps   xmm10, xmmword ptr [r11 - 0x50]
0144a311: subss    xmm3, xmm0
0144a315: divss    xmm5, dword ptr [rsp + 0x34]
0144a31b: movss    xmm7, xmm3
0144a31f: shufps   xmm7, xmm7, 0xc6
0144a323: movss    xmm7, xmm11
0144a328: movaps   xmm11, xmmword ptr [r11 - 0x60]
0144a32d: shufps   xmm7, xmm7, 0x27
0144a331: movss    xmm7, xmm5
0144a335: shufps   xmm7, xmm7, 0x39
0144a339: movups   xmmword ptr [rbx + 0xd0], xmm7
0144a340: movaps   xmm7, xmmword ptr [r11 - 0x20]
0144a345: mov      rsp, r11
0144a348: pop      rbx
0144a349: ret      