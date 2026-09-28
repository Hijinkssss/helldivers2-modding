RANGE 0x1377640-0x1377808
01377640: mov      qword ptr [rsp + 0x18], rbx
01377645: mov      qword ptr [rsp + 0x20], rbp
0137764a: push     rsi
0137764b: push     rdi
0137764c: push     r14
0137764e: sub      rsp, 0x150
01377655: mov      rax, qword ptr [rip + 0x12c49b4] ; RVA 0x263c010
0137765c: xor      rax, rsp
0137765f: mov      qword ptr [rsp + 0x140], rax
01377667: xor      eax, eax
01377669: mov      ebx, edx
0137766b: mov      qword ptr [rsp + 0x38], rax
01377670: mov      rdi, rcx
01377673: mov      dword ptr [rsp + 0x30], eax
01377677: mov      eax, edx
01377679: test     edx, edx
0137767b: je       0x13776db
0137767d: sub      eax, 1
01377680: je       0x1377698
01377682: cmp      eax, 1
01377685: jne      0x13776ee
01377687: lea      r8, [rsp + 0x30]
0137768c: lea      rdx, [rsp + 0x38]
01377691: call     0x12f8c10
01377696: jmp      0x13776ee
01377698: mov      rcx, qword ptr [rip + 0x1faeca1] ; RVA 0x3326340
0137769f: add      rcx, 0xac3dc
013776a6: call     0x102d800
013776ab: mov      rax, qword ptr [rip + 0x1faec56] ; RVA 0x3326308
013776b2: mov      rcx, qword ptr [rax + 0x10]
013776b6: call     qword ptr [rcx + 0x4f0]
013776bc: mov      rcx, qword ptr [rip + 0x1faec7d] ; RVA 0x3326340
013776c3: lea      r8, [rsp + 0x30]
013776c8: add      rcx, 0xac3dc
013776cf: lea      rdx, [rsp + 0x38]
013776d4: call     0x102f7a0
013776d9: jmp      0x13776ee
013776db: add      rcx, 0x30
013776df: lea      r8, [rsp + 0x30]
013776e4: lea      rdx, [rsp + 0x38]
013776e9: call     0xabebd0
013776ee: mov      rcx, qword ptr [rip + 0x1faf753] ; RVA 0x3326e48
013776f5: lea      r14, [rip + 0xe52334] ; RVA 0x21c9a30
013776fc: mov      esi, dword ptr [rsp + 0x30]
01377700: add      rbx, rbx
01377703: mov      rbp, qword ptr [rsp + 0x38]
01377708: cmp      byte ptr [rcx + 0x2493], 0
0137770f: je       0x1377747
01377711: cmp      byte ptr [r14 + rbx*8 + 9], 0
01377717: jne      0x1377747
01377719: mov      rax, qword ptr [rip + 0x1faebe8] ; RVA 0x3326308
01377720: mov      r9d, esi
01377723: mov      rcx, qword ptr [r14 + rbx*8]
01377727: mov      r8, rbp
0137772a: mov      rdx, qword ptr [rax + 0x148]
01377731: mov      rax, qword ptr [rdx + 0x48]
01377735: movzx    edx, byte ptr [r14 + rbx*8 + 8]
0137773b: mov      r10, qword ptr [rax + 0x28]
0137773f: call     r10
01377742: jmp      0x13777d7
01377747: mov      rax, qword ptr [rip + 0x21057a2] ; RVA 0x347cef0
0137774e: movzx    edx, byte ptr [rcx + 8]
01377752: mov      rcx, qword ptr [r14 + rbx*8]
01377756: mov      r8, qword ptr [rax + 0xb398]
0137775d: mov      rax, qword ptr [rip + 0x1faebdc] ; RVA 0x3326340
01377764: mov      r9, qword ptr [rax + 8]
01377768: test     r9, r9
0137776b: jne      0x137778f
0137776d: test     dl, dl
0137776f: je       0x137778c
01377771: mov      r9, rcx
01377774: lea      r8, [rip + 0xf522c5] ; RVA 0x22c9a40
0137777b: lea      rcx, [rsp + 0x40]
01377780: mov      edx, 0xff
01377785: call     0x4f0250
0137778a: jmp      0x13777aa
0137778c: mov      r9, r8
0137778f: mov      qword ptr [rsp + 0x20], rcx
01377794: lea      r8, [rip + 0xf522ad] ; RVA 0x22c9a48
0137779b: lea      rcx, [rsp + 0x40]
013777a0: mov      edx, 0xff
013777a5: call     0x4f0250
013777aa: mov      rax, qword ptr [rip + 0x1faeb57] ; RVA 0x3326308
013777b1: mov      r9d, esi
013777b4: movzx    edx, byte ptr [r14 + rbx*8 + 8]
013777ba: mov      r8, rbp
013777bd: mov      byte ptr [rsp + 0x13f], 0
013777c5: mov      rcx, qword ptr [rax + 0xd8]
013777cc: mov      rax, qword ptr [rcx + 0x28]
013777d0: lea      rcx, [rsp + 0x40]
013777d5: call     rax
013777d7: test     eax, eax
013777d9: mov      dword ptr [rdi + rbx*8 + 4], eax
013777dd: setne    al
013777e0: mov      rcx, qword ptr [rsp + 0x140]
013777e8: xor      rcx, rsp
013777eb: call     0x20886a0
013777f0: lea      r11, [rsp + 0x150]
013777f8: mov      rbx, qword ptr [r11 + 0x30]
013777fc: mov      rbp, qword ptr [r11 + 0x38]
01377800: mov      rsp, r11
01377803: pop      r14
01377805: pop      rdi
01377806: pop      rsi
01377807: ret      