RANGE 0x7cbe60-0x7cbe81
007cbe60: sub      rsp, 8
007cbe64: cmp      edx, dword ptr [rip + 0x2cb7db6] ; RVA 0x3483c20
007cbe6a: mov      r10, qword ptr [rip + 0x2b5a7cf] ; RVA 0x3326640
007cbe71: jne      0x7cbe7a
007cbe73: mov      eax, 0xffffffff
007cbe78: jmp      0x7cbee8
007cbe7a: mov      r9d, dword ptr [r10 + 0x20]
007cbe7e: xor      r8d, r8d
RANGE 0x7cbe81-0x7cbee8
007cbe81: mov      qword ptr [rsp + 0x10], rbx
007cbe86: mov      ebx, dword ptr [r10 + 0x28]
007cbe8a: mov      qword ptr [rsp + 0x18], rbp
007cbe8f: imul     ebx, edx
007cbe92: lea      ebp, [r9 - 1]
007cbe96: mov      qword ptr [rsp + 0x20], rsi
007cbe9b: mov      qword ptr [rsp], rdi
007cbe9f: test     r9d, r9d
007cbea2: je       0x7cbed0
007cbea4: mov      rdi, qword ptr [r10 + 0x18]
007cbea8: mov      esi, dword ptr [r10 + 0x24]
007cbeac: nop      dword ptr [rax]
007cbeb0: mov      eax, ebp
007cbeb2: lea      ecx, [r8 + rbx]
007cbeb6: and      rcx, rax
007cbeb9: mov      eax, dword ptr [rdi + rcx*8]
007cbebc: lea      r11, [rdi + rcx*8]
007cbec0: cmp      eax, esi
007cbec2: je       0x7cbf03
007cbec4: cmp      eax, edx
007cbec6: je       0x7cbf07
007cbec8: inc      r8d
007cbecb: cmp      r8d, r9d
007cbece: jb       0x7cbeb0
007cbed0: mov      eax, 0xffffffff
007cbed5: mov      rsi, qword ptr [rsp + 0x20]
007cbeda: mov      rbp, qword ptr [rsp + 0x18]
007cbedf: mov      rbx, qword ptr [rsp + 0x10]
007cbee4: mov      rdi, qword ptr [rsp]
RANGE 0x7cbee8-0x7cbf03
007cbee8: mov      ecx, eax
007cbeea: mov      rax, qword ptr [r10 + 0x38]
007cbeee: imul     rcx, rcx, 0xe0
007cbef5: cmp      byte ptr [rcx + rax + 0x10], 0
007cbefa: jne      0x7cbf0d
007cbefc: xor      eax, eax
007cbefe: add      rsp, 8
007cbf02: ret      
RANGE 0x7cbf03-0x7cbf0d
007cbf03: cmp      eax, edx
007cbf05: jne      0x7cbed0
007cbf07: mov      eax, dword ptr [r11 + 4]
007cbf0b: jmp      0x7cbed5
RANGE 0x7cbf0d-0x7cbf15
007cbf0d: mov      eax, dword ptr [rcx + rax]
007cbf10: add      rsp, 8
007cbf14: ret      