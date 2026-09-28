RANGE 0x17b6280-0x17b6489
017b6280: mov      qword ptr [rsp + 8], rbx
017b6285: mov      qword ptr [rsp + 0x10], rbp
017b628a: mov      qword ptr [rsp + 0x18], rsi
017b628f: push     rdi
017b6290: push     r12
017b6292: push     r13
017b6294: push     r14
017b6296: push     r15
017b6298: sub      rsp, 0x20
017b629c: xor      ebx, ebx
017b629e: mov      r12, rcx
017b62a1: test     edx, edx
017b62a3: je       0x17b635a
017b62a9: cmp      edx, dword ptr [rip + 0x1ccd971] ; RVA 0x3483c20
017b62af: je       0x17b635a
017b62b5: mov      r13, qword ptr [rip + 0x1b70a24] ; RVA 0x3326ce0
017b62bc: mov      r9d, ebx
017b62bf: mov      eax, 0xffffffff
017b62c4: mov      r10d, dword ptr [r13 + 0x38]
017b62c8: mov      esi, dword ptr [r13 + 0x40]
017b62cc: mov      edi, esi
017b62ce: imul     edi, edx
017b62d1: lea      r15d, [r10 - 1]
017b62d5: test     r10d, r10d
017b62d8: je       0x17b630c
017b62da: mov      r14, qword ptr [r13 + 0x30]
017b62de: mov      ebp, dword ptr [r13 + 0x3c]
017b62e2: mov      ecx, r15d
017b62e5: lea      r8d, [r9 + rdi]
017b62e9: and      r8, rcx
017b62ec: mov      ecx, dword ptr [r14 + r8*8]
017b62f0: lea      r11, [r14 + r8*8]
017b62f4: cmp      ecx, ebp
017b62f6: je       0x17b637d
017b62fc: cmp      ecx, edx
017b62fe: je       0x17b6381
017b6304: inc      r9d
017b6307: cmp      r9d, r10d
017b630a: jb       0x17b62e2
017b630c: mov      rcx, qword ptr [rip + 0x1b701ad] ; RVA 0x33264c0
017b6313: mov      r9d, ebx
017b6316: mov      r11d, dword ptr [rcx + 0x38]
017b631a: mov      edi, dword ptr [rcx + 0x40]
017b631d: imul     edi, edx
017b6320: lea      r14d, [r11 - 1]
017b6324: test     r11d, r11d
017b6327: je       0x17b635a
017b6329: mov      rsi, qword ptr [rcx + 0x30]
017b632d: mov      ebp, dword ptr [rcx + 0x3c]
017b6330: mov      ecx, r14d
017b6333: lea      r8d, [r9 + rdi]
017b6337: and      r8, rcx
017b633a: mov      ecx, dword ptr [rsi + r8*8]
017b633e: lea      r10, [rsi + r8*8]
017b6342: cmp      ecx, ebp
017b6344: je       0x17b6424
017b634a: cmp      ecx, edx
017b634c: je       0x17b642c
017b6352: inc      r9d
017b6355: cmp      r9d, r11d
017b6358: jb       0x17b6330
017b635a: lea      rdx, [rip + 0x1b35e1f] ; RVA 0x32ec180
017b6361: mov      rax, rdx
017b6364: cmp      dword ptr [rax], 0
017b6367: je       0x17b6452
017b636d: inc      ebx
017b636f: add      rax, 0x78
017b6373: cmp      ebx, 0x11
017b6376: jb       0x17b6364
017b6378: jmp      0x17b645b
017b637d: cmp      ecx, edx
017b637f: jne      0x17b630c
017b6381: cmp      dword ptr [r11 + 4], eax
017b6385: je       0x17b630c
017b6387: imul     esi, edx
017b638a: lea      edi, [r10 - 1]
017b638e: mov      r9d, ebx
017b6391: mov      ecx, edi
017b6393: lea      r8d, [r9 + rsi]
017b6397: and      r8, rcx
017b639a: mov      ecx, dword ptr [r14 + r8*8]
017b639e: lea      r11, [r14 + r8*8]
017b63a2: cmp      ecx, ebp
017b63a4: je       0x17b63b4
017b63a6: cmp      ecx, edx
017b63a8: je       0x17b63b8
017b63aa: inc      r9d
017b63ad: cmp      r9d, r10d
017b63b0: jb       0x17b6391
017b63b2: jmp      0x17b63bc
017b63b4: cmp      ecx, edx
017b63b6: jne      0x17b63bc
017b63b8: mov      eax, dword ptr [r11 + 4]
017b63bc: mov      ecx, eax
017b63be: mov      rax, qword ptr [r13 + 0x48]
017b63c2: mov      rbp, qword ptr [rax + rcx*8]
017b63c6: mov      rcx, rbp
017b63c9: call     0x509a40
017b63ce: mov      r14, rax
017b63d1: mov      esi, ebx
017b63d3: lea      rdi, [rax + 0x194]
017b63da: nop      word ptr [rax + rax]
017b63e0: mov      edx, dword ptr [rdi]
017b63e2: mov      ecx, dword ptr [rbp + 8]
017b63e5: call     0x1787430
017b63ea: cmp      eax, dword ptr [rdi + 4]
017b63ed: je       0x17b6403
017b63ef: inc      esi
017b63f1: add      rdi, 0xc
017b63f5: cmp      esi, 4
017b63f8: jb       0x17b63e0
017b63fa: lea      rdi, [r14 + 0x190]
017b6401: jmp      0x17b6407
017b6403: add      rdi, 8
017b6407: mov      ecx, dword ptr [rdi]
017b6409: lea      rdx, [rip + 0x1b35d70] ; RVA 0x32ec180
017b6410: mov      rax, rdx
017b6413: cmp      ecx, dword ptr [rax]
017b6415: je       0x17b6452
017b6417: inc      ebx
017b6419: add      rax, 0x78
017b641d: cmp      ebx, 0x11
017b6420: jb       0x17b6413
017b6422: jmp      0x17b645b
017b6424: cmp      ecx, edx
017b6426: jne      0x17b635a
017b642c: cmp      dword ptr [r10 + 4], eax
017b6430: je       0x17b635a
017b6436: lea      rdx, [rip + 0x1b35d43] ; RVA 0x32ec180
017b643d: mov      rax, rdx
017b6440: cmp      dword ptr [rax], 0x11
017b6443: je       0x17b6452
017b6445: inc      ebx
017b6447: add      rax, 0x78
017b644b: cmp      ebx, 0x11
017b644e: jb       0x17b6440
017b6450: jmp      0x17b645b
017b6452: mov      eax, ebx
017b6454: imul     rcx, rax, 0x78
017b6458: add      rdx, rcx
017b645b: mov      qword ptr [r12 + 0x2078], rdx
017b6463: mov      rcx, r12
017b6466: xor      edx, edx
017b6468: mov      rbx, qword ptr [rsp + 0x50]
017b646d: mov      rbp, qword ptr [rsp + 0x58]
017b6472: mov      rsi, qword ptr [rsp + 0x60]
017b6477: add      rsp, 0x20
017b647b: pop      r15
017b647d: pop      r14
017b647f: pop      r13
017b6481: pop      r12
017b6483: pop      rdi
017b6484: jmp      0x17b9180