RANGE 0x1449f70-0x144a05b
01449f70: sub      rsp, 0x38
01449f74: mov      r10, qword ptr [rcx + 0xf8]
01449f7b: test     r10, r10
01449f7e: je       0x144a056
01449f84: mov      eax, dword ptr [rcx]
01449f86: mov      r9d, eax
01449f89: shr      r9d, 8
01449f8d: and      r9b, 1
01449f91: shr      eax, 0xf
01449f94: test     al, 1
01449f96: je       0x144a013
01449f98: call     0x144f650
01449f9d: mov      r11, rax
01449fa0: test     r9b, r9b
01449fa3: je       0x1449fee
01449fa5: movss    xmm0, dword ptr [rcx + 0xdc]
01449fad: mov      rdx, qword ptr [rip + 0x1edc354] ; RVA 0x3326308
01449fb4: movss    xmm3, dword ptr [rcx + 0xd8]
01449fbc: movss    xmm2, dword ptr [rcx + 0xd4]
01449fc4: movss    xmm1, dword ptr [rcx + 0xd0]
01449fcc: mov      r8, qword ptr [rdx + 0xd0]
01449fd3: mov      rcx, qword ptr [r10 + 8]
01449fd7: mov      qword ptr [rsp + 0x28], rax
01449fdc: movss    dword ptr [rsp + 0x20], xmm0
01449fe2: call     qword ptr [r8 + 0x290]
01449fe9: add      rsp, 0x38
01449fed: ret      
01449fee: test     r11, r11
01449ff1: je       0x144a056
01449ff3: mov      rax, qword ptr [rip + 0x1edc30e] ; RVA 0x3326308
01449ffa: mov      rdx, r11
01449ffd: mov      rcx, qword ptr [r10 + 8]
0144a001: mov      r8, qword ptr [rax + 0xd0]
0144a008: add      rsp, 0x38
0144a00c: jmp      qword ptr [r8 + 0x288]
0144a013: test     r9b, r9b
0144a016: je       0x144a056
0144a018: movss    xmm0, dword ptr [rcx + 0xdc]
0144a020: mov      rax, qword ptr [rip + 0x1edc2e1] ; RVA 0x3326308
0144a027: movss    xmm3, dword ptr [rcx + 0xd8]
0144a02f: movss    xmm2, dword ptr [rcx + 0xd4]
0144a037: movss    xmm1, dword ptr [rcx + 0xd0]
0144a03f: mov      rdx, qword ptr [rax + 0xd0]
0144a046: mov      rcx, qword ptr [r10 + 8]
0144a04a: movss    dword ptr [rsp + 0x20], xmm0
0144a050: call     qword ptr [rdx + 0x278]
0144a056: add      rsp, 0x38
0144a05a: ret      