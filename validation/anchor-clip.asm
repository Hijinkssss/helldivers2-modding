RANGE 0x144a0a0-0x144a141
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