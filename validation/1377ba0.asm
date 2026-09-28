RANGE 0x1377ba0-0x1377fa4
01377ba0: mov      rax, rsp
01377ba3: movss    dword ptr [rax + 0x10], xmm1
01377ba8: push     rbx
01377ba9: push     rdi
01377baa: push     r12
01377bac: push     r13
01377bae: push     r14
01377bb0: push     r15
01377bb2: sub      rsp, 0x88
01377bb9: movaps   xmmword ptr [rax - 0x48], xmm6
01377bbd: lea      rbx, [rcx + 8]
01377bc1: movaps   xmmword ptr [rax - 0x58], xmm7
01377bc5: lea      r12, [rip + 0xe51e64] ; RVA 0x21c9a30
01377bcc: movss    xmm7, dword ptr [rip + 0x104f18c] ; RVA 0x23c6d60
01377bd4: xor      r13d, r13d
01377bd7: movaps   xmmword ptr [rax - 0x68], xmm8
01377bdc: mov      r14, rcx
01377bdf: movss    xmm8, dword ptr [rip + 0x104fbf8] ; RVA 0x23c77e0
01377be8: mov      edi, r13d
01377beb: mov      qword ptr [rax + 8], rbp
01377bef: xorps    xmm6, xmm6
01377bf2: mov      qword ptr [rax - 0x38], rsi
01377bf6: nop      word ptr [rax + rax]
01377c00: mov      r8d, dword ptr [rbx]
01377c03: xor      r15b, r15b
01377c06: test     r8d, r8d
01377c09: je       0x1377e5e
01377c0f: mov      edx, edi
01377c11: call     0x13f24a0
01377c16: test     al, al
01377c18: je       0x1377e6e
01377c1e: mov      rax, qword ptr [rip + 0x1faf223] ; RVA 0x3326e48
01377c25: mov      r10d, dword ptr [rbx]
01377c28: mov      dword ptr [rsp + 0xc8], r13d
01377c30: cmp      byte ptr [rax + 0x2493], r13b
01377c37: je       0x1377c73
01377c39: mov      eax, edi
01377c3b: add      rax, rax
01377c3e: cmp      byte ptr [r12 + rax*8 + 9], r13b
01377c43: jne      0x1377c73
01377c45: mov      rax, qword ptr [rip + 0x1fae6bc] ; RVA 0x3326308
01377c4c: lea      r8, [rsp + 0xc8]
01377c54: mov      ecx, r10d
01377c57: mov      rdx, qword ptr [rax + 0x148]
01377c5e: mov      rax, qword ptr [rdx + 0x48]
01377c62: lea      rdx, [rsp + 0xd0]
01377c6a: mov      r9, qword ptr [rax + 0x18]
01377c6e: call     r9
01377c71: jmp      0x1377c9a
01377c73: mov      rax, qword ptr [rip + 0x1fae68e] ; RVA 0x3326308
01377c7a: lea      r8, [rsp + 0xc8]
01377c82: lea      rdx, [rsp + 0xd0]
01377c8a: mov      rcx, qword ptr [rax + 0xd8]
01377c91: mov      rax, qword ptr [rcx + 0x18]
01377c95: mov      ecx, r10d
01377c98: call     rax
01377c9a: cmp      eax, 8
01377c9d: jne      0x1377dfd
01377ca3: mov      edx, dword ptr [rsp + 0xc8]
01377caa: test     edx, edx
01377cac: je       0x1377dfd
01377cb2: mov      r9, qword ptr [rsp + 0xd0]
01377cba: test     r9, r9
01377cbd: je       0x1377dfd
01377cc3: mov      eax, edi
01377cc5: test     edi, edi
01377cc7: je       0x1377ded
01377ccd: sub      eax, 1
01377cd0: je       0x1377db3
01377cd6: cmp      eax, 1
01377cd9: jne      0x1377dfd
01377cdf: mov      rax, qword ptr [rip + 0x1fae622] ; RVA 0x3326308
01377ce6: mov      rcx, r9
01377ce9: mov      rbp, qword ptr [rip + 0x2105228] ; RVA 0x347cf18
01377cf0: mov      r8, qword ptr [rax + 0x128]
01377cf7: mov      rax, qword ptr [r8 + 0x10]
01377cfb: call     rax
01377cfd: mov      rsi, rax
01377d00: test     rax, rax
01377d03: je       0x1377d55
01377d05: mov      rcx, qword ptr [rip + 0x210520c] ; RVA 0x347cf18
01377d0c: mov      r8b, 1
01377d0f: add      rcx, 0xa7ac8
01377d16: mov      rdx, rax
01377d19: call     0xaf26d0
01377d1e: mov      rcx, qword ptr [rip + 0x21051f3] ; RVA 0x347cf18
01377d25: call     0x12f8440
01377d2a: movzx    ecx, byte ptr [rbp + 0xa7b02]
01377d31: mov      rdx, qword ptr [rip + 0x21051e0] ; RVA 0x347cf18
01377d38: mov      byte ptr [rdx + 0xe1ad6], cl
01377d3e: mov      rcx, qword ptr [rip + 0x1fae5c3] ; RVA 0x3326308
01377d45: mov      rax, qword ptr [rcx + 0x128]
01377d4c: mov      rcx, rsi
01377d4f: call     qword ptr [rax + 0x160]
01377d55: mov      rax, qword ptr [rip + 0x1fae5bc] ; RVA 0x3326318
01377d5c: call     qword ptr [rax + 0x10]
01377d5f: test     al, al
01377d61: je       0x1377dfd
01377d67: mov      rax, qword ptr [rip + 0x1fae5aa] ; RVA 0x3326318
01377d6e: mov      rdx, qword ptr [rax + 0xa0]
01377d75: mov      rax, qword ptr [rip + 0x210519c] ; RVA 0x347cf18
01377d7c: movss    xmm0, dword ptr [rax + 0xa7b68]
01377d84: comiss   xmm6, xmm0
01377d87: jbe      0x1377d9c
01377d89: movaps   xmm1, xmm6
01377d8c: lea      rcx, [rip + 0xeede05] ; RVA 0x2265b98
01377d93: mulss    xmm1, xmm8
01377d98: call     rdx
01377d9a: jmp      0x1377dfd
01377d9c: movaps   xmm1, xmm7
01377d9f: lea      rcx, [rip + 0xeeddf2] ; RVA 0x2265b98
01377da6: minss    xmm1, xmm0
01377daa: mulss    xmm1, xmm8
01377daf: call     rdx
01377db1: jmp      0x1377dfd
01377db3: mov      rcx, qword ptr [rip + 0x1fae586] ; RVA 0x3326340
01377dba: mov      r8d, edx
01377dbd: add      rcx, 0xac3dc
01377dc4: mov      rdx, r9
01377dc7: call     0x1030260
01377dcc: mov      r8, qword ptr [rip + 0x1fae56d] ; RVA 0x3326340
01377dd3: lea      rcx, [r8 + 0xac3dc]
01377dda: call     0x1030ee0
01377ddf: lea      rcx, [r8 + 0xac3dc]
01377de6: call     0x102f390
01377deb: jmp      0x1377dfd
01377ded: mov      dword ptr [r14 + 0x38], edx
01377df1: lea      rcx, [r14 + 0x30]
01377df5: mov      rdx, r9
01377df8: call     0xabf250
01377dfd: mov      rax, qword ptr [rip + 0x1faf044] ; RVA 0x3326e48
01377e04: mov      ecx, dword ptr [rbx]
01377e06: cmp      byte ptr [rax + 0x2493], r13b
01377e0d: je       0x1377e32
01377e0f: mov      eax, edi
01377e11: add      rax, rax
01377e14: cmp      byte ptr [r12 + rax*8 + 9], r13b
01377e19: jne      0x1377e32
01377e1b: mov      rax, qword ptr [rip + 0x1fae4e6] ; RVA 0x3326308
01377e22: mov      rdx, qword ptr [rax + 0x148]
01377e29: mov      rax, qword ptr [rdx + 0x48]
01377e2d: call     qword ptr [rax + 8]
01377e30: jmp      0x1377e43
01377e32: mov      rax, qword ptr [rip + 0x1fae4cf] ; RVA 0x3326308
01377e39: mov      rdx, qword ptr [rax + 0xd8]
01377e40: call     qword ptr [rdx + 8]
01377e43: mov      dword ptr [rbx], r13d
01377e46: mov      byte ptr [rbx + 4], 1
01377e4a: test     edi, edi
01377e4c: jne      0x1377e53
01377e4e: call     0xb69520
01377e53: cmp      dword ptr [rbx - 8], r13d
01377e57: jbe      0x1377e6e
01377e59: mov      r15b, 1
01377e5c: jmp      0x1377e6e
01377e5e: cmp      byte ptr [rbx + 5], r13b
01377e62: je       0x1377e6e
01377e64: mov      edx, edi
01377e66: mov      rcx, r14
01377e69: call     0x1377970
01377e6e: mov      r8d, dword ptr [rbx - 4]
01377e72: test     r8d, r8d
01377e75: je       0x1377f43
01377e7b: mov      edx, edi
01377e7d: call     0x13f24a0
01377e82: test     al, al
01377e84: je       0x1377f49
01377e8a: mov      rax, qword ptr [rip + 0x1faefb7] ; RVA 0x3326e48
01377e91: mov      edx, dword ptr [rbx - 4]
01377e94: mov      esi, edi
01377e96: cmp      byte ptr [rax + 0x2493], r13b
01377e9d: je       0x1377ecb
01377e9f: mov      eax, esi
01377ea1: add      rax, rax
01377ea4: cmp      byte ptr [r12 + rax*8 + 9], r13b
01377ea9: jne      0x1377ecb
01377eab: mov      rax, qword ptr [rip + 0x1fae456] ; RVA 0x3326308
01377eb2: mov      rcx, qword ptr [rax + 0x148]
01377eb9: mov      rax, qword ptr [rcx + 0x48]
01377ebd: lea      rcx, [rsp + 0x20]
01377ec2: mov      r8, qword ptr [rax + 0x10]
01377ec6: call     r8
01377ec9: jmp      0x1377ee4
01377ecb: mov      rax, qword ptr [rip + 0x1fae436] ; RVA 0x3326308
01377ed2: mov      rcx, qword ptr [rax + 0xd8]
01377ed9: mov      rax, qword ptr [rcx + 0x10]
01377edd: lea      rcx, [rsp + 0x40]
01377ee2: call     rax
01377ee4: cmp      dword ptr [rax + 8], 8
01377ee8: sete     al
01377eeb: test     al, al
01377eed: je       0x1377ef2
01377eef: dec      dword ptr [rbx - 8]
01377ef2: mov      rax, qword ptr [rip + 0x1faef4f] ; RVA 0x3326e48
01377ef9: mov      ecx, dword ptr [rbx - 4]
01377efc: cmp      byte ptr [rax + 0x2493], r13b
01377f03: je       0x1377f26
01377f05: add      rsi, rsi
01377f08: cmp      byte ptr [r12 + rsi*8 + 9], r13b
01377f0d: jne      0x1377f26
01377f0f: mov      rax, qword ptr [rip + 0x1fae3f2] ; RVA 0x3326308
01377f16: mov      rdx, qword ptr [rax + 0x148]
01377f1d: mov      rax, qword ptr [rdx + 0x48]
01377f21: call     qword ptr [rax + 8]
01377f24: jmp      0x1377f37
01377f26: mov      rax, qword ptr [rip + 0x1fae3db] ; RVA 0x3326308
01377f2d: mov      rdx, qword ptr [rax + 0xd8]
01377f34: call     qword ptr [rdx + 8]
01377f37: mov      dword ptr [rbx - 4], r13d
01377f3b: cmp      dword ptr [rbx - 8], r13d
01377f3f: jbe      0x1377f49
01377f41: jmp      0x1377f4e
01377f43: cmp      dword ptr [rbx - 8], r13d
01377f47: ja       0x1377f4e
01377f49: test     r15b, r15b
01377f4c: je       0x1377f63
01377f4e: mov      edx, edi
01377f50: mov      rcx, r14
01377f53: call     0x1377640
01377f58: test     al, al
01377f5a: je       0x1377f63
01377f5c: mov      dword ptr [rbx - 8], 1
01377f63: inc      edi
01377f65: add      rbx, 0x10
01377f69: cmp      edi, 3
01377f6c: jb       0x1377c00
01377f72: mov      rsi, qword ptr [rsp + 0x80]
01377f7a: mov      rbp, qword ptr [rsp + 0xc0]
01377f82: movaps   xmm6, xmmword ptr [rsp + 0x70]
01377f87: movaps   xmm7, xmmword ptr [rsp + 0x60]
01377f8c: movaps   xmm8, xmmword ptr [rsp + 0x50]
01377f92: add      rsp, 0x88
01377f99: pop      r15
01377f9b: pop      r14
01377f9d: pop      r13
01377f9f: pop      r12
01377fa1: pop      rdi
01377fa2: pop      rbx
01377fa3: ret      