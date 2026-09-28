RANGE 0x102f7a0-0x1030258
0102f7a0: mov      qword ptr [rsp + 8], rbx
0102f7a5: mov      qword ptr [rsp + 0x10], rbp
0102f7aa: mov      qword ptr [rsp + 0x18], rsi
0102f7af: push     rdi
0102f7b0: push     r14
0102f7b2: push     r15
0102f7b4: sub      rsp, 0x20
0102f7b8: mov      rax, qword ptr [rip + 0x22f6b49] ; RVA 0x3326308
0102f7bf: mov      r15, rdx
0102f7c2: mov      rbx, rcx
0102f7c5: lea      rdx, [rip + 0x120f2fb] ; RVA 0x223eac7
0102f7cc: xor      ecx, ecx
0102f7ce: mov      r14, r8
0102f7d1: mov      r9, qword ptr [rax + 0x128]
0102f7d8: mov      rax, qword ptr [r9 + 0x140]
0102f7df: call     rax
0102f7e1: mov      r9, qword ptr [rip + 0x22f6b20] ; RVA 0x3326308
0102f7e8: lea      rdx, [rip + 0x122fb21] ; RVA 0x225f310
0102f7ef: mov      r8d, 0x35
0102f7f5: mov      rcx, rax
0102f7f8: mov      rsi, rax
0102f7fb: mov      r10, qword ptr [r9 + 0x128]
0102f802: call     qword ptr [r10 + 0xf0]
0102f809: mov      rcx, qword ptr [rip + 0x22f6af8] ; RVA 0x3326308
0102f810: lea      rdx, [rip + 0x122fa09] ; RVA 0x225f220
0102f817: movss    xmm2, dword ptr [rbx + 0xbc]
0102f81f: mov      r8, qword ptr [rcx + 0x128]
0102f826: mov      rcx, rsi
0102f829: call     qword ptr [r8 + 0x100]
0102f830: mov      rcx, qword ptr [rip + 0x22f6ad1] ; RVA 0x3326308
0102f837: lea      rdx, [rip + 0x122fa72] ; RVA 0x225f2b0
0102f83e: movss    xmm2, dword ptr [rbx + 0xc0]
0102f846: mov      r8, qword ptr [rcx + 0x128]
0102f84d: mov      rcx, rsi
0102f850: call     qword ptr [r8 + 0x100]
0102f857: mov      rax, qword ptr [rip + 0x22f6aaa] ; RVA 0x3326308
0102f85e: lea      rdx, [rip + 0x122fa2b] ; RVA 0x225f290
0102f865: movzx    r8d, byte ptr [rbx + 0xc4]
0102f86d: mov      rcx, rsi
0102f870: mov      r9, qword ptr [rax + 0x128]
0102f877: call     qword ptr [r9 + 0x108]
0102f87e: mov      rax, qword ptr [rip + 0x22f6a83] ; RVA 0x3326308
0102f885: lea      rdx, [rip + 0x122fa14] ; RVA 0x225f2a0
0102f88c: movzx    r8d, byte ptr [rbx + 0xc5]
0102f894: mov      rcx, rsi
0102f897: mov      r9, qword ptr [rax + 0x128]
0102f89e: call     qword ptr [r9 + 0x108]
0102f8a5: mov      rax, qword ptr [rip + 0x22f6a5c] ; RVA 0x3326308
0102f8ac: lea      rdx, [rip + 0x122fa65] ; RVA 0x225f318
0102f8b3: movss    xmm2, dword ptr [rbx + 0xc8]
0102f8bb: mov      rcx, rsi
0102f8be: mov      r8, qword ptr [rax + 0x128]
0102f8c5: call     qword ptr [r8 + 0x100]
0102f8cc: mov      rax, qword ptr [rip + 0x22f6a35] ; RVA 0x3326308
0102f8d3: lea      rdx, [rip + 0x122fa9e] ; RVA 0x225f378
0102f8da: movss    xmm2, dword ptr [rbx + 0xcc]
0102f8e2: mov      rcx, rsi
0102f8e5: mov      r8, qword ptr [rax + 0x128]
0102f8ec: call     qword ptr [r8 + 0x100]
0102f8f3: mov      r8d, dword ptr [rbx + 0xd4]
0102f8fa: lea      rdi, [rip - 0x102f901] ; RVA 0x0
0102f901: mov      rax, qword ptr [rip + 0x22f6a00] ; RVA 0x3326308
0102f908: lea      rdx, [rip + 0x122fa81] ; RVA 0x225f390
0102f90f: mov      rcx, rsi
0102f912: mov      r8, qword ptr [rdi + r8*8 + 0x37c5650]
0102f91a: mov      r9, qword ptr [rax + 0x128]
0102f921: mov      r8, qword ptr [r8 + 8]
0102f925: call     qword ptr [r9 + 0xe8]
0102f92c: mov      rax, qword ptr [rip + 0x22f69d5] ; RVA 0x3326308
0102f933: lea      rdx, [rip + 0x122fa16] ; RVA 0x225f350
0102f93a: mov      rcx, rsi
0102f93d: mov      r9, qword ptr [rax + 0x128]
0102f944: mov      eax, dword ptr [rbx + 0xd8]
0102f94a: mov      r8d, dword ptr [rdi + rax*4 + 0x37c55d0]
0102f952: mov      r8, qword ptr [rdi + r8*8 + 0x37c5650]
0102f95a: mov      r8, qword ptr [r8 + 8]
0102f95e: call     qword ptr [r9 + 0xe8]
0102f965: call     0x13edfd0
0102f96a: cmp      eax, -1
0102f96d: je       0x102f99d
0102f96f: mov      rcx, qword ptr [rip + 0x22f6992] ; RVA 0x3326308
0102f976: lea      rdx, [rip + 0x122f9e3] ; RVA 0x225f360
0102f97d: mov      r8d, eax
0102f980: mov      r9, qword ptr [rcx + 0x128]
0102f987: mov      rcx, rsi
0102f98a: mov      r8, qword ptr [rdi + r8*8 + 0x37c5650]
0102f992: mov      r8, qword ptr [r8 + 8]
0102f996: call     qword ptr [r9 + 0xe8]
0102f99d: mov      rax, qword ptr [rip + 0x22f6964] ; RVA 0x3326308
0102f9a4: lea      rdx, [rip + 0x122fa15] ; RVA 0x225f3c0
0102f9ab: mov      r8d, dword ptr [rbx + 0xe0]
0102f9b2: mov      rcx, rsi
0102f9b5: mov      r9, qword ptr [rax + 0x128]
0102f9bc: call     qword ptr [r9 + 0xf0]
0102f9c3: mov      rax, qword ptr [rip + 0x22f693e] ; RVA 0x3326308
0102f9ca: lea      rdx, [rip + 0x122f9ff] ; RVA 0x225f3d0
0102f9d1: mov      r8d, dword ptr [rbx + 0xe8]
0102f9d8: mov      rcx, rsi
0102f9db: mov      r9, qword ptr [rax + 0x128]
0102f9e2: call     qword ptr [r9 + 0xf0]
0102f9e9: mov      rax, qword ptr [rip + 0x22f6918] ; RVA 0x3326308
0102f9f0: lea      rdx, [rip + 0x122f9a9] ; RVA 0x225f3a0
0102f9f7: mov      r8d, dword ptr [rbx + 0xec]
0102f9fe: mov      rcx, rsi
0102fa01: mov      r9, qword ptr [rax + 0x128]
0102fa08: call     qword ptr [r9 + 0xf0]
0102fa0f: mov      rax, qword ptr [rip + 0x22f68f2] ; RVA 0x3326308
0102fa16: lea      rdx, [rip + 0x122f993] ; RVA 0x225f3b0
0102fa1d: mov      r8d, dword ptr [rbx + 0xe4]
0102fa24: mov      rcx, rsi
0102fa27: mov      r9, qword ptr [rax + 0x128]
0102fa2e: call     qword ptr [r9 + 0xf0]
0102fa35: mov      rax, qword ptr [rip + 0x22f68cc] ; RVA 0x3326308
0102fa3c: lea      rdx, [rip + 0x122f9d5] ; RVA 0x225f418
0102fa43: movzx    r8d, byte ptr [rbx + 0xf8]
0102fa4b: mov      rcx, rsi
0102fa4e: mov      r9, qword ptr [rax + 0x128]
0102fa55: call     qword ptr [r9 + 0x108]
0102fa5c: mov      rax, qword ptr [rip + 0x22f68a5] ; RVA 0x3326308
0102fa63: lea      rdx, [rip + 0x122f9be] ; RVA 0x225f428
0102fa6a: movzx    r8d, byte ptr [rbx + 0xf9]
0102fa72: mov      rcx, rsi
0102fa75: mov      r9, qword ptr [rax + 0x128]
0102fa7c: call     qword ptr [r9 + 0x108]
0102fa83: mov      rax, qword ptr [rip + 0x22f687e] ; RVA 0x3326308
0102fa8a: lea      rdx, [rip + 0x122f957] ; RVA 0x225f3e8
0102fa91: movzx    r8d, byte ptr [rbx + 0xfa]
0102fa99: mov      rcx, rsi
0102fa9c: mov      r9, qword ptr [rax + 0x128]
0102faa3: call     qword ptr [r9 + 0x108]
0102faaa: mov      rax, qword ptr [rip + 0x22f6857] ; RVA 0x3326308
0102fab1: lea      rdx, [rip + 0x122f948] ; RVA 0x225f400
0102fab8: movzx    r8d, byte ptr [rbx + 0xfe]
0102fac0: mov      rcx, rsi
0102fac3: mov      r9, qword ptr [rax + 0x128]
0102faca: call     qword ptr [r9 + 0x108]
0102fad1: mov      rax, qword ptr [rip + 0x22f6830] ; RVA 0x3326308
0102fad8: lea      rdx, [rip + 0x122f9a1] ; RVA 0x225f480
0102fadf: mov      r8d, dword ptr [rbx + 0xf0]
0102fae6: mov      rcx, rsi
0102fae9: mov      r9, qword ptr [rax + 0x128]
0102faf0: call     qword ptr [r9 + 0xf0]
0102faf7: mov      rax, qword ptr [rip + 0x22f680a] ; RVA 0x3326308
0102fafe: lea      rdx, [rip + 0x122f993] ; RVA 0x225f498
0102fb05: movzx    r8d, byte ptr [rbx + 0xf4]
0102fb0d: mov      rcx, rsi
0102fb10: mov      r9, qword ptr [rax + 0x128]
0102fb17: call     qword ptr [r9 + 0x108]
0102fb1e: mov      rax, qword ptr [rip + 0x22f67e3] ; RVA 0x3326308
0102fb25: lea      rdx, [rip + 0x122f914] ; RVA 0x225f440
0102fb2c: movzx    r8d, byte ptr [rbx + 0xf5]
0102fb34: mov      rcx, rsi
0102fb37: mov      r9, qword ptr [rax + 0x128]
0102fb3e: call     qword ptr [r9 + 0x108]
0102fb45: mov      rax, qword ptr [rip + 0x22f67bc] ; RVA 0x3326308
0102fb4c: lea      rdx, [rip + 0x122f90d] ; RVA 0x225f460
0102fb53: movzx    r8d, byte ptr [rbx + 0xf6]
0102fb5b: mov      rcx, rsi
0102fb5e: mov      r9, qword ptr [rax + 0x128]
0102fb65: call     qword ptr [r9 + 0x108]
0102fb6c: mov      rax, qword ptr [rip + 0x22f6795] ; RVA 0x3326308
0102fb73: lea      rdx, [rip + 0x122f956] ; RVA 0x225f4d0
0102fb7a: movzx    r8d, byte ptr [rbx + 0xf7]
0102fb82: mov      rcx, rsi
0102fb85: mov      r9, qword ptr [rax + 0x128]
0102fb8c: call     qword ptr [r9 + 0x108]
0102fb93: mov      rax, qword ptr [rip + 0x22f676e] ; RVA 0x3326308
0102fb9a: movzx    r8d, byte ptr [rbx + 0xfb]
0102fba2: mov      r9, qword ptr [rax + 0x128]
0102fba9: lea      rdx, [rip + 0x122f938] ; RVA 0x225f4e8
0102fbb0: mov      rcx, rsi
0102fbb3: call     qword ptr [r9 + 0x108]
0102fbba: mov      rax, qword ptr [rip + 0x22f6747] ; RVA 0x3326308
0102fbc1: lea      rdx, [rip + 0x122f8e8] ; RVA 0x225f4b0
0102fbc8: movzx    r8d, byte ptr [rbx + 0xfc]
0102fbd0: mov      rcx, rsi
0102fbd3: mov      r9, qword ptr [rax + 0x128]
0102fbda: call     qword ptr [r9 + 0x108]
0102fbe1: mov      rax, qword ptr [rip + 0x22f6720] ; RVA 0x3326308
0102fbe8: lea      rdx, [rip + 0x122f8d1] ; RVA 0x225f4c0
0102fbef: movss    xmm2, dword ptr [rbx + 0x100]
0102fbf7: mov      rcx, rsi
0102fbfa: mov      r8, qword ptr [rax + 0x128]
0102fc01: call     qword ptr [r8 + 0x100]
0102fc08: mov      rax, qword ptr [rip + 0x22f66f9] ; RVA 0x3326308
0102fc0f: lea      rdx, [rip + 0x122f91a] ; RVA 0x225f530
0102fc16: movss    xmm2, dword ptr [rbx + 0x104]
0102fc1e: mov      rcx, rsi
0102fc21: mov      r8, qword ptr [rax + 0x128]
0102fc28: call     qword ptr [r8 + 0x100]
0102fc2f: mov      rax, qword ptr [rip + 0x22f66d2] ; RVA 0x3326308
0102fc36: lea      rdx, [rip + 0x122f903] ; RVA 0x225f540
0102fc3d: movss    xmm2, dword ptr [rbx + 0x108]
0102fc45: mov      rcx, rsi
0102fc48: mov      r8, qword ptr [rax + 0x128]
0102fc4f: call     qword ptr [r8 + 0x100]
0102fc56: mov      rax, qword ptr [rip + 0x22f66ab] ; RVA 0x3326308
0102fc5d: lea      rdx, [rip + 0x122f89c] ; RVA 0x225f500
0102fc64: mov      r8d, dword ptr [rbx + 0x10c]
0102fc6b: mov      rcx, rsi
0102fc6e: mov      r9, qword ptr [rax + 0x128]
0102fc75: call     qword ptr [r9 + 0xf0]
0102fc7c: mov      rax, qword ptr [rip + 0x22f6685] ; RVA 0x3326308
0102fc83: lea      rdx, [rip + 0x122f88e] ; RVA 0x225f518
0102fc8a: mov      r8d, dword ptr [rbx + 0x110]
0102fc91: mov      rcx, rsi
0102fc94: mov      r9, qword ptr [rax + 0x128]
0102fc9b: call     qword ptr [r9 + 0xf0]
0102fca2: mov      rax, qword ptr [rip + 0x22f665f] ; RVA 0x3326308
0102fca9: lea      rdx, [rip + 0x122f8e0] ; RVA 0x225f590
0102fcb0: mov      r8d, dword ptr [rbx + 0x114]
0102fcb7: mov      rcx, rsi
0102fcba: mov      r9, qword ptr [rax + 0x128]
0102fcc1: call     qword ptr [r9 + 0xf0]
0102fcc8: mov      rax, qword ptr [rip + 0x22f6639] ; RVA 0x3326308
0102fccf: lea      rdx, [rip + 0x122f8ca] ; RVA 0x225f5a0
0102fcd6: mov      r8d, dword ptr [rbx + 0x118]
0102fcdd: mov      rcx, rsi
0102fce0: mov      r9, qword ptr [rax + 0x128]
0102fce7: call     qword ptr [r9 + 0xf0]
0102fcee: mov      rax, qword ptr [rip + 0x22f6613] ; RVA 0x3326308
0102fcf5: lea      rdx, [rip + 0x122f854] ; RVA 0x225f550
0102fcfc: mov      r8d, dword ptr [rbx + 0x11c]
0102fd03: mov      rcx, rsi
0102fd06: mov      r9, qword ptr [rax + 0x128]
0102fd0d: call     qword ptr [r9 + 0xf0]
0102fd14: mov      rax, qword ptr [rip + 0x22f65ed] ; RVA 0x3326308
0102fd1b: lea      rdx, [rip + 0x122f84e] ; RVA 0x225f570
0102fd22: mov      r8d, dword ptr [rbx + 0x120]
0102fd29: mov      rcx, rsi
0102fd2c: mov      r9, qword ptr [rax + 0x128]
0102fd33: call     qword ptr [r9 + 0xf0]
0102fd3a: mov      rax, qword ptr [rip + 0x22f65c7] ; RVA 0x3326308
0102fd41: lea      rdx, [rip + 0x122f8a0] ; RVA 0x225f5e8
0102fd48: mov      r8d, dword ptr [rbx + 0x124]
0102fd4f: mov      rcx, rsi
0102fd52: mov      r9, qword ptr [rax + 0x128]
0102fd59: call     qword ptr [r9 + 0xf0]
0102fd60: mov      rax, qword ptr [rip + 0x22f65a1] ; RVA 0x3326308
0102fd67: lea      rdx, [rip + 0x122f892] ; RVA 0x225f600
0102fd6e: mov      r8d, dword ptr [rbx + 0x128]
0102fd75: mov      rcx, rsi
0102fd78: mov      r9, qword ptr [rax + 0x128]
0102fd7f: call     qword ptr [r9 + 0xf0]
0102fd86: mov      rax, qword ptr [rip + 0x22f657b] ; RVA 0x3326308
0102fd8d: lea      rdx, [rip + 0x122f824] ; RVA 0x225f5b8
0102fd94: mov      r8d, dword ptr [rbx + 0x12c]
0102fd9b: mov      rcx, rsi
0102fd9e: mov      r9, qword ptr [rax + 0x128]
0102fda5: call     qword ptr [r9 + 0xf0]
0102fdac: mov      rax, qword ptr [rip + 0x22f6555] ; RVA 0x3326308
0102fdb3: lea      rdx, [rip + 0x122f816] ; RVA 0x225f5d0
0102fdba: mov      r8d, dword ptr [rbx + 0x130]
0102fdc1: mov      rcx, rsi
0102fdc4: mov      r9, qword ptr [rax + 0x128]
0102fdcb: call     qword ptr [r9 + 0xf0]
0102fdd2: mov      rax, qword ptr [rip + 0x22f652f] ; RVA 0x3326308
0102fdd9: lea      rdx, [rip + 0x122f868] ; RVA 0x225f648
0102fde0: mov      r8d, dword ptr [rbx + 0x134]
0102fde7: mov      rcx, rsi
0102fdea: mov      r9, qword ptr [rax + 0x128]
0102fdf1: call     qword ptr [r9 + 0xf0]
0102fdf8: mov      rax, qword ptr [rip + 0x22f6509] ; RVA 0x3326308
0102fdff: lea      rdx, [rip + 0x122f852] ; RVA 0x225f658
0102fe06: mov      r8d, dword ptr [rbx + 0x138]
0102fe0d: mov      rcx, rsi
0102fe10: mov      r9, qword ptr [rax + 0x128]
0102fe17: call     qword ptr [r9 + 0xf0]
0102fe1e: mov      rax, qword ptr [rip + 0x22f64e3] ; RVA 0x3326308
0102fe25: lea      rdx, [rip + 0x122f7ec] ; RVA 0x225f618
0102fe2c: mov      r8d, dword ptr [rbx + 0x13c]
0102fe33: mov      rcx, rsi
0102fe36: mov      r9, qword ptr [rax + 0x128]
0102fe3d: call     qword ptr [r9 + 0xf0]
0102fe44: mov      rax, qword ptr [rip + 0x22f64bd] ; RVA 0x3326308
0102fe4b: lea      rdx, [rip + 0x122f7de] ; RVA 0x225f630
0102fe52: mov      r8d, dword ptr [rbx + 0x140]
0102fe59: mov      rcx, rsi
0102fe5c: mov      r9, qword ptr [rax + 0x128]
0102fe63: call     qword ptr [r9 + 0xf0]
0102fe6a: mov      rax, qword ptr [rip + 0x22f6497] ; RVA 0x3326308
0102fe71: lea      rdx, [rip + 0x122f818] ; RVA 0x225f690
0102fe78: mov      r8d, dword ptr [rbx + 0x144]
0102fe7f: mov      rcx, rsi
0102fe82: mov      r9, qword ptr [rax + 0x128]
0102fe89: call     qword ptr [r9 + 0xf0]
0102fe90: mov      rax, qword ptr [rip + 0x22f6471] ; RVA 0x3326308
0102fe97: lea      rdx, [rip + 0x122f802] ; RVA 0x225f6a0
0102fe9e: mov      r8d, dword ptr [rbx + 0x148]
0102fea5: mov      rcx, rsi
0102fea8: mov      r9, qword ptr [rax + 0x128]
0102feaf: call     qword ptr [r9 + 0xf0]
0102feb6: mov      rax, qword ptr [rip + 0x22f644b] ; RVA 0x3326308
0102febd: lea      rdx, [rip + 0x122f7a4] ; RVA 0x225f668
0102fec4: mov      r8d, dword ptr [rbx + 0x14c]
0102fecb: mov      rcx, rsi
0102fece: mov      r9, qword ptr [rax + 0x128]
0102fed5: call     qword ptr [r9 + 0xf0]
0102fedc: mov      rax, qword ptr [rip + 0x22f6425] ; RVA 0x3326308
0102fee3: lea      rdx, [rip + 0x122f78e] ; RVA 0x225f678
0102feea: mov      r8d, dword ptr [rbx + 0x150]
0102fef1: mov      rcx, rsi
0102fef4: mov      r9, qword ptr [rax + 0x128]
0102fefb: call     qword ptr [r9 + 0xf0]
0102ff02: mov      rax, qword ptr [rip + 0x22f63ff] ; RVA 0x3326308
0102ff09: lea      rdx, [rip + 0x122f7c0] ; RVA 0x225f6d0
0102ff10: mov      r8d, dword ptr [rbx + 0x154]
0102ff17: mov      rcx, rsi
0102ff1a: mov      r9, qword ptr [rax + 0x128]
0102ff21: call     qword ptr [r9 + 0xf0]
0102ff28: mov      rax, qword ptr [rip + 0x22f63d9] ; RVA 0x3326308
0102ff2f: lea      rdx, [rip + 0x122f7aa] ; RVA 0x225f6e0
0102ff36: mov      r8d, dword ptr [rbx + 0x158]
0102ff3d: mov      rcx, rsi
0102ff40: mov      r9, qword ptr [rax + 0x128]
0102ff47: call     qword ptr [r9 + 0xf0]
0102ff4e: mov      rax, qword ptr [rip + 0x22f63b3] ; RVA 0x3326308
0102ff55: lea      rdx, [rip + 0x122f754] ; RVA 0x225f6b0
0102ff5c: mov      r8d, dword ptr [rbx + 0x15c]
0102ff63: mov      rcx, rsi
0102ff66: mov      r9, qword ptr [rax + 0x128]
0102ff6d: call     qword ptr [r9 + 0xf0]
0102ff74: mov      rax, qword ptr [rip + 0x22f638d] ; RVA 0x3326308
0102ff7b: lea      rdx, [rip + 0x122f73e] ; RVA 0x225f6c0
0102ff82: mov      r8d, dword ptr [rbx + 0x160]
0102ff89: mov      rcx, rsi
0102ff8c: mov      r9, qword ptr [rax + 0x128]
0102ff93: call     qword ptr [r9 + 0xf0]
0102ff9a: mov      rax, qword ptr [rip + 0x22f6367] ; RVA 0x3326308
0102ffa1: mov      r8d, dword ptr [rbx + 0x164]
0102ffa8: mov      r9, qword ptr [rax + 0x128]
0102ffaf: lea      rdx, [rip + 0x122f762] ; RVA 0x225f718
0102ffb6: mov      rcx, rsi
0102ffb9: call     qword ptr [r9 + 0xf0]
0102ffc0: mov      rax, qword ptr [rip + 0x22f6341] ; RVA 0x3326308
0102ffc7: lea      rdx, [rip + 0x122f75a] ; RVA 0x225f728
0102ffce: mov      r8d, dword ptr [rbx + 0x168]
0102ffd5: mov      rcx, rsi
0102ffd8: mov      r9, qword ptr [rax + 0x128]
0102ffdf: call     qword ptr [r9 + 0xf0]
0102ffe6: mov      rax, qword ptr [rip + 0x22f631b] ; RVA 0x3326308
0102ffed: lea      rdx, [rip + 0x122f6fc] ; RVA 0x225f6f0
0102fff4: mov      r8d, dword ptr [rbx + 0x16c]
0102fffb: mov      rcx, rsi
0102fffe: mov      r9, qword ptr [rax + 0x128]
01030005: call     qword ptr [r9 + 0xf0]
0103000c: mov      rax, qword ptr [rip + 0x22f62f5] ; RVA 0x3326308
01030013: lea      rdx, [rip + 0x122f6e6] ; RVA 0x225f700
0103001a: mov      r8d, dword ptr [rbx + 0x170]
01030021: mov      rcx, rsi
01030024: mov      r9, qword ptr [rax + 0x128]
0103002b: call     qword ptr [r9 + 0xf0]
01030032: mov      rax, qword ptr [rip + 0x22f62cf] ; RVA 0x3326308
01030039: lea      rdx, [rip + 0x122f738] ; RVA 0x225f778
01030040: mov      r8d, dword ptr [rbx + 0x180]
01030047: mov      rcx, rsi
0103004a: mov      r9, qword ptr [rax + 0x128]
01030051: call     qword ptr [r9 + 0xf0]
01030058: mov      rax, qword ptr [rip + 0x22f62a9] ; RVA 0x3326308
0103005f: lea      rdx, [rip + 0x122f72a] ; RVA 0x225f790
01030066: mov      r8d, dword ptr [rbx + 0x174]
0103006d: mov      rcx, rsi
01030070: mov      r9, qword ptr [rax + 0x128]
01030077: call     qword ptr [r9 + 0xf0]
0103007e: mov      rax, qword ptr [rip + 0x22f6283] ; RVA 0x3326308
01030085: lea      rdx, [rip + 0x122f6b4] ; RVA 0x225f740
0103008c: mov      r8d, dword ptr [rbx + 0x178]
01030093: mov      rcx, rsi
01030096: mov      r9, qword ptr [rax + 0x128]
0103009d: call     qword ptr [r9 + 0xf0]
010300a4: mov      rax, qword ptr [rip + 0x22f625d] ; RVA 0x3326308
010300ab: lea      rdx, [rip + 0x122f6a6] ; RVA 0x225f758
010300b2: mov      r8d, dword ptr [rbx + 0x17c]
010300b9: mov      rcx, rsi
010300bc: mov      r9, qword ptr [rax + 0x128]
010300c3: call     qword ptr [r9 + 0xf0]
010300ca: mov      rax, qword ptr [rip + 0x22f6237] ; RVA 0x3326308
010300d1: lea      rdx, [rip + 0x122f700] ; RVA 0x225f7d8
010300d8: movzx    r8d, byte ptr [rbx + 0xfd]
010300e0: mov      rcx, rsi
010300e3: mov      r9, qword ptr [rax + 0x128]
010300ea: call     qword ptr [r9 + 0x108]
010300f1: mov      rax, qword ptr [rip + 0x22f6210] ; RVA 0x3326308
010300f8: lea      rdx, [rip + 0x122f6f1] ; RVA 0x225f7f0
010300ff: movzx    r8d, byte ptr [rbx + 0x185]
01030107: mov      rcx, rsi
0103010a: mov      r9, qword ptr [rax + 0x128]
01030111: call     qword ptr [r9 + 0x108]
01030118: mov      rax, qword ptr [rip + 0x22f61e9] ; RVA 0x3326308
0103011f: lea      rdx, [rip + 0x122f67a] ; RVA 0x225f7a0
01030126: movzx    r8d, byte ptr [rbx + 0x184]
0103012e: mov      rcx, rsi
01030131: mov      r9, qword ptr [rax + 0x128]
01030138: call     qword ptr [r9 + 0x108]
0103013f: mov      rax, qword ptr [rip + 0x22f61c2] ; RVA 0x3326308
01030146: lea      rdx, [rip + 0x122f673] ; RVA 0x225f7c0
0103014d: mov      r8d, dword ptr [rbx + 0x188]
01030154: mov      rcx, rsi
01030157: mov      r9, qword ptr [rax + 0x128]
0103015e: call     qword ptr [r9 + 0xf0]
01030165: mov      rax, qword ptr [rip + 0x22f619c] ; RVA 0x3326308
0103016c: lea      rdx, [rip + 0x122f6b5] ; RVA 0x225f828
01030173: mov      r8d, dword ptr [rbx + 0x18c]
0103017a: mov      rcx, rsi
0103017d: mov      r9, qword ptr [rax + 0x128]
01030184: call     qword ptr [r9 + 0xf0]
0103018b: mov      rax, qword ptr [rip + 0x22f6176] ; RVA 0x3326308
01030192: lea      rdx, [rip + 0x122f69f] ; RVA 0x225f838
01030199: movzx    r8d, byte ptr [rbx + 0x190]
010301a1: mov      rcx, rsi
010301a4: mov      r9, qword ptr [rax + 0x128]
010301ab: call     qword ptr [r9 + 0x108]
010301b2: mov      rax, qword ptr [rip + 0x22f614f] ; RVA 0x3326308
010301b9: mov      dl, 1
010301bb: mov      rcx, qword ptr [rax + 0x128]
010301c2: mov      rax, qword ptr [rcx + 0x18]
010301c6: mov      rcx, rsi
010301c9: call     rax
010301cb: mov      rbp, rax
010301ce: mov      rcx, 0xffffffffffffffff
010301d5: inc      rcx
010301d8: cmp      byte ptr [rcx + rax], 0
010301dc: jne      0x10301d5
010301de: mov      dword ptr [r14], ecx
010301e1: lea      edx, [rcx + 1]
010301e4: lea      rcx, [rip + 0x22f6105] ; RVA 0x33262f0
010301eb: mov      r8d, 8
010301f1: call     0x173b800
010301f6: mov      ebx, dword ptr [r14]
010301f9: mov      rdx, rbp
010301fc: mov      r8d, ebx
010301ff: mov      qword ptr [r15], rax
01030202: mov      rcx, rax
01030205: mov      rdi, rax
01030208: call     0x2098820
0103020d: mov      rax, qword ptr [rip + 0x22f60f4] ; RVA 0x3326308
01030214: mov      rcx, rbp
01030217: mov      byte ptr [rbx + rdi], 0
0103021b: mov      rdx, qword ptr [rax + 0x128]
01030222: call     qword ptr [rdx + 0x168]
01030228: mov      rax, qword ptr [rip + 0x22f60d9] ; RVA 0x3326308
0103022f: mov      rcx, rsi
01030232: mov      rdx, qword ptr [rax + 0x128]
01030239: mov      rbx, qword ptr [rsp + 0x40]
0103023e: mov      rbp, qword ptr [rsp + 0x48]
01030243: mov      rsi, qword ptr [rsp + 0x50]
01030248: add      rsp, 0x20
0103024c: pop      r15
0103024e: pop      r14
01030250: pop      rdi
01030251: jmp      qword ptr [rdx + 0x160]