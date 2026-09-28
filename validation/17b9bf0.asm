RANGE 0x17b9bf0-0x17b9c6e
017b9bf0: mov      qword ptr [rsp + 8], rbx
017b9bf5: push     rdi
017b9bf6: sub      rsp, 0x20
017b9bfa: mov      eax, dword ptr [rcx + 0x2080]
017b9c00: mov      edi, edx
017b9c02: mov      rbx, rcx
017b9c05: cmp      eax, edx
017b9c07: je       0x17b9c63
017b9c09: sub      eax, 2
017b9c0c: je       0x17b9c44
017b9c0e: cmp      eax, 1
017b9c11: jne      0x17b9c53
017b9c13: xor      eax, eax
017b9c15: xorps    xmm1, xmm1
017b9c18: mov      dword ptr [rcx + 0x20a8], eax
017b9c1e: mov      dword ptr [rcx + 0x20b0], eax
017b9c24: add      rcx, 0x440
017b9c2b: call     0x1448a40
017b9c30: mov      rcx, rbx
017b9c33: call     0x17b9040
017b9c38: xor      edx, edx
017b9c3a: mov      rcx, rbx
017b9c3d: call     0x17b9180
017b9c42: jmp      0x17b9c53
017b9c44: add      rcx, 0x220
017b9c4b: xorps    xmm1, xmm1
017b9c4e: call     0x1448a40
017b9c53: mov      edx, edi
017b9c55: mov      dword ptr [rbx + 0x2080], edi
017b9c5b: mov      rcx, rbx
017b9c5e: call     0x17b9c70
017b9c63: mov      rbx, qword ptr [rsp + 0x30]
017b9c68: add      rsp, 0x20
017b9c6c: pop      rdi
017b9c6d: ret      