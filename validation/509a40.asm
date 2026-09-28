RANGE 0x509a40-0x509a6c
00509a40: sub      rsp, 0x28
00509a44: mov      r10, rcx
00509a47: test     rcx, rcx
00509a4a: jne      0x509a53
00509a4c: xor      eax, eax
00509a4e: add      rsp, 0x28
00509a52: ret      
00509a53: mov      eax, dword ptr [rcx + 8]
00509a56: cmp      eax, dword ptr [rip + 0x2f7a1c8] ; RVA 0x3483c24
00509a5c: je       0x509af5
00509a62: mov      r11, qword ptr [rip + 0x2e1d277] ; RVA 0x3326ce0
00509a69: xor      r8d, r8d
RANGE 0x509a6c-0x509ada
00509a6c: mov      qword ptr [rsp + 0x30], rbx
00509a71: mov      qword ptr [rsp + 0x38], rbp
00509a76: mov      qword ptr [rsp + 0x40], rsi
00509a7b: mov      r9d, dword ptr [r11 + 0x78]
00509a7f: mov      ebx, dword ptr [r11 + 0x80]
00509a86: imul     ebx, eax
00509a89: mov      qword ptr [rsp + 0x20], rdi
00509a8e: lea      ebp, [r9 - 1]
00509a92: test     r9d, r9d
00509a95: je       0x509ac0
00509a97: mov      rdi, qword ptr [r11 + 0x70]
00509a9b: mov      esi, dword ptr [r11 + 0x7c]
00509a9f: nop      
00509aa0: mov      ecx, ebp
00509aa2: lea      edx, [r8 + rbx]
00509aa6: and      rdx, rcx
00509aa9: lea      rcx, [rdi + rdx*8]
00509aad: mov      edx, dword ptr [rdi + rdx*8]
00509ab0: cmp      edx, esi
00509ab2: je       0x509ac2
00509ab4: cmp      edx, eax
00509ab6: je       0x509ac2
00509ab8: inc      r8d
00509abb: cmp      r8d, r9d
00509abe: jb       0x509aa0
00509ac0: xor      ecx, ecx
00509ac2: mov      rdi, qword ptr [rsp + 0x20]
00509ac7: mov      rsi, qword ptr [rsp + 0x40]
00509acc: mov      rbp, qword ptr [rsp + 0x38]
00509ad1: mov      rbx, qword ptr [rsp + 0x30]
00509ad6: cmp      dword ptr [rcx], eax
00509ad8: jne      0x509af5
RANGE 0x509ada-0x509b01
00509ada: mov      eax, dword ptr [rcx + 4]
00509add: cmp      eax, -1
00509ae0: je       0x509af5
00509ae2: imul     rax, rax, 0x4d0
00509ae9: add      rax, qword ptr [r11 + 0xb0]
00509af0: add      rsp, 0x28
00509af4: ret      
00509af5: mov      rcx, qword ptr [r10]
00509af8: add      rsp, 0x28
00509afc: jmp      0x509570