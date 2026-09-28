RANGE 0x17b9040-0x17b90be
017b9040: mov      qword ptr [rsp + 8], rbx
017b9045: mov      qword ptr [rsp + 0x10], rsi
017b904a: push     rdi
017b904b: sub      rsp, 0x20
017b904f: mov      rdi, rcx
017b9052: lea      rbx, [rcx + 0x1460]
017b9059: mov      esi, 4
017b905e: nop      
017b9060: lea      rcx, [rbx - 0x560]
017b9067: xorps    xmm1, xmm1
017b906a: call     0x1448a40
017b906f: mov      rcx, rbx
017b9072: call     0x1448a40
017b9077: add      rbx, 0x158
017b907e: sub      rsi, 1
017b9082: jne      0x17b9060
017b9084: cmp      byte ptr [rdi + 0x209b], sil
017b908b: jne      0x17b90ae
017b908d: lea      rcx, [rdi + 0x848]
017b9094: call     0x1448a40
017b9099: cmp      byte ptr [rdi + 0x209c], sil
017b90a0: je       0x17b90ae
017b90a2: lea      rcx, [rdi + 0x9a0]
017b90a9: call     0x1448a40
017b90ae: mov      rbx, qword ptr [rsp + 0x30]
017b90b3: mov      rsi, qword ptr [rsp + 0x38]
017b90b8: add      rsp, 0x20
017b90bc: pop      rdi
017b90bd: ret      