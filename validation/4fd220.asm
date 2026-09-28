RANGE 0x4fd220-0x4fd24c
004fd220: sub      rsp, 0x28
004fd224: mov      r10, rcx
004fd227: test     rcx, rcx
004fd22a: jne      0x4fd233
004fd22c: xor      eax, eax
004fd22e: add      rsp, 0x28
004fd232: ret      
004fd233: mov      eax, dword ptr [rcx + 8]
004fd236: cmp      eax, dword ptr [rip + 0x2f869e8] ; RVA 0x3483c24
004fd23c: je       0x4fd2d6
004fd242: mov      r11, qword ptr [rip + 0x2e29827] ; RVA 0x3326a70
004fd249: xor      r8d, r8d
RANGE 0x4fd24c-0x4fd2ba
004fd24c: mov      qword ptr [rsp + 0x30], rbx
004fd251: mov      qword ptr [rsp + 0x38], rbp
004fd256: mov      qword ptr [rsp + 0x40], rsi
004fd25b: mov      r9d, dword ptr [r11 + 0x68]
004fd25f: mov      ebx, dword ptr [r11 + 0x70]
004fd263: imul     ebx, eax
004fd266: mov      qword ptr [rsp + 0x20], rdi
004fd26b: lea      ebp, [r9 - 1]
004fd26f: test     r9d, r9d
004fd272: je       0x4fd2a0
004fd274: mov      rdi, qword ptr [r11 + 0x60]
004fd278: mov      esi, dword ptr [r11 + 0x6c]
004fd27c: nop      dword ptr [rax]
004fd280: mov      ecx, ebp
004fd282: lea      edx, [r8 + rbx]
004fd286: and      rdx, rcx
004fd289: lea      rcx, [rdi + rdx*8]
004fd28d: mov      edx, dword ptr [rdi + rdx*8]
004fd290: cmp      edx, esi
004fd292: je       0x4fd2a2
004fd294: cmp      edx, eax
004fd296: je       0x4fd2a2
004fd298: inc      r8d
004fd29b: cmp      r8d, r9d
004fd29e: jb       0x4fd280
004fd2a0: xor      ecx, ecx
004fd2a2: mov      rdi, qword ptr [rsp + 0x20]
004fd2a7: mov      rsi, qword ptr [rsp + 0x40]
004fd2ac: mov      rbp, qword ptr [rsp + 0x38]
004fd2b1: mov      rbx, qword ptr [rsp + 0x30]
004fd2b6: cmp      dword ptr [rcx], eax
004fd2b8: jne      0x4fd2d6
RANGE 0x4fd2ba-0x4fd2e2
004fd2ba: mov      eax, dword ptr [rcx + 4]
004fd2bd: cmp      eax, -1
004fd2c0: je       0x4fd2d6
004fd2c2: lea      rax, [rax + rax*4]
004fd2c6: shl      rax, 4
004fd2ca: add      rax, qword ptr [r11 + 0xa0]
004fd2d1: add      rsp, 0x28
004fd2d5: ret      
004fd2d6: mov      rcx, qword ptr [r10]
004fd2d9: add      rsp, 0x28
004fd2dd: jmp      0x4fce20