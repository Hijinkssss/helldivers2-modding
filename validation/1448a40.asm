RANGE 0x1448a40-0x1448a78
01448a40: push     rdi
01448a42: sub      rsp, 0x20
01448a46: movss    xmm0, dword ptr [rcx + 0x44]
01448a4b: mov      rdi, rcx
01448a4e: ucomiss  xmm0, xmm1
01448a51: jp       0x1448a76
01448a53: jne      0x1448a76
01448a55: test     dword ptr [rcx], 0x8000000
01448a5b: je       0x1448bd8
01448a61: mov      eax, dword ptr [rcx + 0xb0]
01448a67: shr      rax, 0xb
01448a6b: test     eax, 0x7ff
01448a70: je       0x1448bd8
01448a76: mov      eax, dword ptr [rcx]
RANGE 0x1448a78-0x1448bd8
01448a78: mov      qword ptr [rsp + 0x30], rbx
01448a7d: and      eax, 0x8000000
01448a82: ucomiss  xmm0, xmm1
01448a85: mov      qword ptr [rsp + 0x38], rbp
01448a8a: mov      qword ptr [rsp + 0x40], rsi
01448a8f: mov      qword ptr [rsp + 0x48], r14
01448a94: jp       0x1448b09
01448a96: jne      0x1448b09
01448a98: test     eax, eax
01448a9a: je       0x1448bc4
01448aa0: mov      eax, dword ptr [rcx + 0xb0]
01448aa6: shr      rax, 0xb
01448aaa: and      eax, 0x7ff
01448aaf: je       0x1448bc4
01448ab5: mov      rsi, qword ptr [rip + 0x20342cc] ; RVA 0x347cd88
01448abc: lea      ebp, [rax - 1]
01448abf: mov      eax, ebp
01448ac1: xor      r14d, r14d
01448ac4: imul     rbx, rax, 0x70
01448ac8: xor      r8d, r8d
01448acb: lea      edx, [r14 + 5]
01448acf: mov      byte ptr [rbx + rsi + 0x12], 0
01448ad4: mov      qword ptr [rbx + rsi + 0x5c], r14
01448ad9: call     0x144d440
01448ade: and      qword ptr [rdi + 0xb0], 0xffffffffffc007ff
01448ae9: mov      qword ptr [rbx + rsi + 0x78], r14
01448aee: mov      eax, dword ptr [rsi + 4]
01448af1: test     eax, eax
01448af3: je       0x1448afa
01448af5: dec      eax
01448af7: mov      dword ptr [rsi + 4], eax
01448afa: cmp      ebp, dword ptr [rsi]
01448afc: jae      0x1448bc4
01448b02: mov      dword ptr [rsi], ebp
01448b04: jmp      0x1448bc4
01448b09: test     eax, eax
01448b0b: je       0x1448b69
01448b0d: mov      eax, dword ptr [rcx + 0xb0]
01448b13: shr      rax, 0xb
01448b17: and      eax, 0x7ff
01448b1c: je       0x1448b69
01448b1e: mov      rsi, qword ptr [rip + 0x2034263] ; RVA 0x347cd88
01448b25: lea      ebp, [rax - 1]
01448b28: mov      eax, ebp
01448b2a: xor      r14d, r14d
01448b2d: imul     rbx, rax, 0x70
01448b31: xor      r8d, r8d
01448b34: lea      edx, [r14 + 5]
01448b38: mov      byte ptr [rbx + rsi + 0x12], 0
01448b3d: mov      qword ptr [rbx + rsi + 0x5c], r14
01448b42: call     0x144d440
01448b47: and      qword ptr [rdi + 0xb0], 0xffffffffffc007ff
01448b52: mov      qword ptr [rbx + rsi + 0x78], r14
01448b57: mov      eax, dword ptr [rsi + 4]
01448b5a: test     eax, eax
01448b5c: je       0x1448b63
01448b5e: dec      eax
01448b60: mov      dword ptr [rsi + 4], eax
01448b63: cmp      ebp, dword ptr [rsi]
01448b65: jae      0x1448b69
01448b67: mov      dword ptr [rsi], ebp
01448b69: mov      edx, dword ptr [rdi + 0xb8]
01448b6f: mov      eax, edx
01448b71: or       eax, 0x20
01448b74: movss    dword ptr [rdi + 0x44], xmm1
01448b79: mov      dword ptr [rdi + 0xb8], eax
01448b7f: cmp      eax, edx
01448b81: je       0x1448bc4
01448b83: not      edx
01448b85: and      edx, eax
01448b87: and      edx, 0xffff2fff
01448b8d: je       0x1448ba3
01448b8f: mov      rcx, qword ptr [rdi + 0xe0]
01448b96: test     rcx, rcx
01448b99: je       0x1448ba3
01448b9b: mov      r8b, 1
01448b9e: call     0x144c370
01448ba3: mov      ecx, dword ptr [rdi]
01448ba5: mov      eax, ecx
01448ba7: shr      eax, 2
01448baa: test     al, 1
01448bac: jne      0x1448bc4
01448bae: or       ecx, 4
01448bb1: mov      dword ptr [rdi], ecx
01448bb3: mov      rcx, qword ptr [rdi + 0xf0]
01448bba: test     rcx, rcx
01448bbd: je       0x1448bc4
01448bbf: call     0x144d170
01448bc4: mov      rsi, qword ptr [rsp + 0x40]
01448bc9: mov      rbp, qword ptr [rsp + 0x38]
01448bce: mov      rbx, qword ptr [rsp + 0x30]
01448bd3: mov      r14, qword ptr [rsp + 0x48]
RANGE 0x1448bd8-0x1448bde
01448bd8: add      rsp, 0x20
01448bdc: pop      rdi
01448bdd: ret      