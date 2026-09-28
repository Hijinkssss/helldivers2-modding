RANGE 0x17b9f40-0x17b9fa1
017b9f40: push     rbx
017b9f42: sub      rsp, 0x20
017b9f46: mov      rbx, rcx
017b9f49: sub      edx, 2
017b9f4c: je       0x17b9f87
017b9f4e: cmp      edx, 1
017b9f51: jne      0x17b9f9b
017b9f53: xor      eax, eax
017b9f55: xorps    xmm1, xmm1
017b9f58: mov      dword ptr [rcx + 0x20a8], eax
017b9f5e: mov      dword ptr [rcx + 0x20b0], eax
017b9f64: add      rcx, 0x440
017b9f6b: call     0x1448a40
017b9f70: mov      rcx, rbx
017b9f73: call     0x17b9040
017b9f78: xor      edx, edx
017b9f7a: mov      rcx, rbx
017b9f7d: add      rsp, 0x20
017b9f81: pop      rbx
017b9f82: jmp      0x17b9180
017b9f87: add      rcx, 0x220
017b9f8e: xorps    xmm1, xmm1
017b9f91: add      rsp, 0x20
017b9f95: pop      rbx
017b9f96: jmp      0x1448a40
017b9f9b: add      rsp, 0x20
017b9f9f: pop      rbx
017b9fa0: ret      