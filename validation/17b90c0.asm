RANGE 0x17b90c0-0x17b910e
017b90c0: push     rbx
017b90c2: sub      rsp, 0x20
017b90c6: mov      byte ptr [rcx + 0x209b], dl
017b90cc: mov      rbx, rcx
017b90cf: test     dl, dl
017b90d1: je       0x17b90e9
017b90d3: mov      eax, 0xaf8
017b90d8: xorps    xmm1, xmm1
017b90db: lea      rcx, [rax + rcx]
017b90df: add      rsp, 0x20
017b90e3: pop      rbx
017b90e4: jmp      0x1448a40
017b90e9: add      rcx, 0xc50
017b90f0: xorps    xmm1, xmm1
017b90f3: call     0x1448a40
017b90f8: mov      eax, 0x848
017b90fd: xorps    xmm1, xmm1
017b9100: lea      rcx, [rax + rbx]
017b9104: add      rsp, 0x20
017b9108: pop      rbx
017b9109: jmp      0x1448a40