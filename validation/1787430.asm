RANGE 0x1787430-0x1787465
01787430: push     rbx
01787432: sub      rsp, 0x20
01787436: mov      ebx, edx
01787438: call     0x1787390
0178743d: test     al, al
0178743f: je       0x17874f1
01787445: mov      r11, qword ptr [rip + 0x1b9f894] ; RVA 0x3326ce0
0178744c: xor      r8d, r8d
0178744f: cmp      ecx, dword ptr [rip + 0x1cfc7cb] ; RVA 0x3483c20
01787455: jne      0x178745e
01787457: mov      eax, 0xffffffff
0178745c: jmp      0x17874cb
0178745e: mov      r10d, dword ptr [r11 + 0x38]
01787462: mov      r9d, r8d
RANGE 0x1787465-0x17874cb
01787465: mov      qword ptr [rsp + 0x30], rbp
0178746a: mov      qword ptr [rsp + 0x38], rsi
0178746f: mov      qword ptr [rsp + 0x40], rdi
01787474: mov      edi, dword ptr [r11 + 0x40]
01787478: imul     edi, ecx
0178747b: mov      qword ptr [rsp + 0x48], r14
01787480: lea      r14d, [r10 - 1]
01787484: test     r10d, r10d
01787487: je       0x17874b2
01787489: mov      rsi, qword ptr [r11 + 0x30]
0178748d: mov      ebp, dword ptr [r11 + 0x3c]
01787491: mov      eax, r14d
01787494: lea      edx, [r9 + rdi]
01787498: and      rdx, rax
0178749b: mov      eax, dword ptr [rsi + rdx*8]
0178749e: lea      rdx, [rsi + rdx*8]
017874a2: cmp      eax, ebp
017874a4: je       0x17874fc
017874a6: cmp      eax, ecx
017874a8: je       0x1787500
017874aa: inc      r9d
017874ad: cmp      r9d, r10d
017874b0: jb       0x1787491
017874b2: mov      eax, 0xffffffff
017874b7: mov      rdi, qword ptr [rsp + 0x40]
017874bc: mov      rsi, qword ptr [rsp + 0x38]
017874c1: mov      rbp, qword ptr [rsp + 0x30]
017874c6: mov      r14, qword ptr [rsp + 0x48]
RANGE 0x17874cb-0x17874fc
017874cb: mov      edx, eax
017874cd: imul     rax, rdx, 0x3f0
017874d4: add      rax, 0x350
017874da: add      rax, qword ptr [r11 + 0x58]
017874de: nop      
017874e0: cmp      dword ptr [rax], ebx
017874e2: je       0x1787505
017874e4: inc      r8d
017874e7: add      rax, 4
017874eb: cmp      r8d, 4
017874ef: jb       0x17874e0
017874f1: mov      eax, 0xffffffff
017874f6: add      rsp, 0x20
017874fa: pop      rbx
017874fb: ret      
RANGE 0x17874fc-0x1787505
017874fc: cmp      eax, ecx
017874fe: jne      0x17874b2
01787500: mov      eax, dword ptr [rdx + 4]
01787503: jmp      0x17874b7
RANGE 0x1787505-0x1787514
01787505: mov      edx, ecx
01787507: mov      rcx, r11
0178750a: add      rsp, 0x20
0178750e: pop      rbx
0178750f: jmp      0x755ba0