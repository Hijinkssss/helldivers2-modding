RANGE 0x17b9c70-0x17b9f3c
017b9c70: mov      qword ptr [rsp + 8], rbx
017b9c75: push     rdi
017b9c76: sub      rsp, 0x30
017b9c7a: mov      rdi, rcx
017b9c7d: sub      edx, 1
017b9c80: je       0x17b9e7a
017b9c86: sub      edx, 1
017b9c89: je       0x17b9e02
017b9c8f: sub      edx, 1
017b9c92: je       0x17b9d4c
017b9c98: cmp      edx, 1
017b9c9b: jne      0x17b9f31
017b9ca1: add      rcx, 0x848
017b9ca8: xorps    xmm1, xmm1
017b9cab: call     0x1448a40
017b9cb0: lea      rcx, [rdi + 0x9a0]
017b9cb7: call     0x1448a40
017b9cbc: lea      rcx, [rdi + 0xaf8]
017b9cc3: call     0x1448a40
017b9cc8: lea      rcx, [rdi + 0xc50]
017b9ccf: call     0x1448a40
017b9cd4: lea      rcx, [rdi + 0xda8]
017b9cdb: call     0x1448a40
017b9ce0: lea      rcx, [rdi + 0x220]
017b9ce7: call     0x1448a40
017b9cec: lea      rcx, [rdi + 0x19c0]
017b9cf3: call     0x1448a40
017b9cf8: lea      rcx, [rdi + 0x1b18]
017b9cff: call     0x1448a40
017b9d04: lea      rcx, [rdi + 0x440]
017b9d0b: call     0x1448a40
017b9d10: add      rdi, 0x1460
017b9d17: mov      ebx, 4
017b9d1c: nop      dword ptr [rax]
017b9d20: lea      rcx, [rdi - 0x560]
017b9d27: call     0x1448a40
017b9d2c: mov      rcx, rdi
017b9d2f: call     0x1448a40
017b9d34: add      rdi, 0x158
017b9d3b: sub      rbx, 1
017b9d3f: jne      0x17b9d20
017b9d41: mov      rbx, qword ptr [rsp + 0x40]
017b9d46: add      rsp, 0x30
017b9d4a: pop      rdi
017b9d4b: ret      
017b9d4c: cmp      byte ptr [rcx + 0x209b], 0
017b9d53: je       0x17b9f31
017b9d59: movss    xmm4, dword ptr [rip + 0xc0cfff] ; RVA 0x23c6d60
017b9d61: add      rcx, 0xaf8
017b9d68: movaps   xmm3, xmmword ptr [rip + 0xa28e61] ; RVA 0x21e2bd0
017b9d6f: movaps   xmm1, xmm4
017b9d72: call     0x1448a40
017b9d77: movaps   xmm0, xmm3
017b9d7a: lea      rdx, [rsp + 0x20]
017b9d7f: movaps   xmm2, xmm3
017b9d82: shufps   xmm0, xmm3, 0xaa
017b9d86: shufps   xmm2, xmm3, 0x55
017b9d8a: lea      rcx, [rdi + 0xaf8]
017b9d91: shufps   xmm3, xmm3, 0xff
017b9d95: movss    dword ptr [rsp + 0x28], xmm3
017b9d9b: movss    dword ptr [rsp + 0x20], xmm2
017b9da1: movss    dword ptr [rsp + 0x24], xmm0
017b9da7: call     0x1448600
017b9dac: movaps   xmm3, xmmword ptr [rip + 0xa28e7d] ; RVA 0x21e2c30
017b9db3: lea      rcx, [rdi + 0xda8]
017b9dba: movaps   xmm1, xmm4
017b9dbd: call     0x1448a40
017b9dc2: movaps   xmm0, xmm3
017b9dc5: lea      rdx, [rsp + 0x20]
017b9dca: movaps   xmm2, xmm3
017b9dcd: shufps   xmm0, xmm3, 0xaa
017b9dd1: shufps   xmm2, xmm3, 0x55
017b9dd5: lea      rcx, [rdi + 0xda8]
017b9ddc: shufps   xmm3, xmm3, 0xff
017b9de0: movss    dword ptr [rsp + 0x28], xmm3
017b9de6: movss    dword ptr [rsp + 0x20], xmm2
017b9dec: movss    dword ptr [rsp + 0x24], xmm0
017b9df2: call     0x1448600
017b9df7: mov      rbx, qword ptr [rsp + 0x40]
017b9dfc: add      rsp, 0x30
017b9e00: pop      rdi
017b9e01: ret      
017b9e02: add      rcx, 0x848
017b9e09: xorps    xmm1, xmm1
017b9e0c: call     0x1448a40
017b9e11: lea      rcx, [rdi + 0x9a0]
017b9e18: call     0x1448a40
017b9e1d: lea      rcx, [rdi + 0xaf8]
017b9e24: call     0x1448a40
017b9e29: lea      rcx, [rdi + 0xc50]
017b9e30: call     0x1448a40
017b9e35: lea      rcx, [rdi + 0xda8]
017b9e3c: call     0x1448a40
017b9e41: movss    xmm1, dword ptr [rip + 0xc0cf17] ; RVA 0x23c6d60
017b9e49: lea      rcx, [rdi + 0x220]
017b9e50: call     0x1448a40
017b9e55: lea      rcx, [rdi + 0x19c0]
017b9e5c: xorps    xmm1, xmm1
017b9e5f: call     0x1448a40
017b9e64: lea      rcx, [rdi + 0x1b18]
017b9e6b: mov      rbx, qword ptr [rsp + 0x40]
017b9e70: add      rsp, 0x30
017b9e74: pop      rdi
017b9e75: jmp      0x1448a40
017b9e7a: add      rcx, 0x848
017b9e81: xorps    xmm1, xmm1
017b9e84: call     0x1448a40
017b9e89: lea      rcx, [rdi + 0x9a0]
017b9e90: call     0x1448a40
017b9e95: lea      rcx, [rdi + 0xaf8]
017b9e9c: call     0x1448a40
017b9ea1: lea      rcx, [rdi + 0xc50]
017b9ea8: call     0x1448a40
017b9ead: lea      rcx, [rdi + 0xda8]
017b9eb4: call     0x1448a40
017b9eb9: lea      rcx, [rdi + 0x220]
017b9ec0: call     0x1448a40
017b9ec5: lea      rcx, [rdi + 0x19c0]
017b9ecc: call     0x1448a40
017b9ed1: lea      rcx, [rdi + 0x1b18]
017b9ed8: call     0x1448a40
017b9edd: lea      rcx, [rdi + 0x440]
017b9ee4: call     0x1448a40
017b9ee9: lea      rcx, [rdi + 0x1dc8]
017b9ef0: call     0x1448a40
017b9ef5: lea      rcx, [rdi + 0x1f20]
017b9efc: call     0x1448a40
017b9f01: add      rdi, 0x1460
017b9f08: mov      ebx, 4
017b9f0d: nop      dword ptr [rax]
017b9f10: lea      rcx, [rdi - 0x560]
017b9f17: call     0x1448a40
017b9f1c: mov      rcx, rdi
017b9f1f: call     0x1448a40
017b9f24: add      rdi, 0x158
017b9f2b: sub      rbx, 1
017b9f2f: jne      0x17b9f10
017b9f31: mov      rbx, qword ptr [rsp + 0x40]
017b9f36: add      rsp, 0x30
017b9f3a: pop      rdi
017b9f3b: ret      