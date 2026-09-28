RANGE 0x143ebf0-0x143ec03
0143ebf0: sub      rsp, 0x78
0143ebf4: mov      rax, qword ptr [rip + 0x11fd415] ; RVA 0x263c010
0143ebfb: xor      rax, rsp
0143ebfe: mov      qword ptr [rsp + 0x60], rax
RANGE 0x143ec03-0x143ee01
0143ec03: mov      qword ptr [rsp + 0x88], rbx
0143ec0b: mov      qword ptr [rsp + 0x70], rdi
0143ec10: mov      rdi, rcx
0143ec13: call     0x1449f70
0143ec18: cmp      qword ptr [rdi + 0x148], 0
0143ec20: je       0x143edaf
0143ec26: cmp      qword ptr [rdi + 0xf8], 0
0143ec2e: je       0x143edaf
0143ec34: mov      eax, dword ptr [rdi]
0143ec36: shr      eax, 1
0143ec38: test     al, 1
0143ec3a: je       0x143edaf
0143ec40: movss    xmm0, dword ptr [rdi + 0x60]
0143ec45: xorps    xmm1, xmm1
0143ec48: comiss   xmm1, xmm0
0143ec4b: movss    xmm2, dword ptr [rip + 0xf8810d] ; RVA 0x23c6d60
0143ec53: jbe      0x143ec5a
0143ec55: xorps    xmm3, xmm3
0143ec58: jmp      0x143ec61
0143ec5a: movaps   xmm3, xmm2
0143ec5d: minss    xmm3, xmm0
0143ec61: movss    xmm0, dword ptr [rdi + 0x5c]
0143ec66: comiss   xmm1, xmm0
0143ec69: jbe      0x143ec70
0143ec6b: xorps    xmm4, xmm4
0143ec6e: jmp      0x143ec77
0143ec70: movaps   xmm4, xmm2
0143ec73: minss    xmm4, xmm0
0143ec77: movss    xmm0, dword ptr [rdi + 0x58]
0143ec7c: comiss   xmm1, xmm0
0143ec7f: jbe      0x143ec86
0143ec81: xorps    xmm5, xmm5
0143ec84: jmp      0x143ec8d
0143ec86: movaps   xmm5, xmm2
0143ec89: minss    xmm5, xmm0
0143ec8d: movss    xmm0, dword ptr [rdi + 0x54]
0143ec92: comiss   xmm1, xmm0
0143ec95: jbe      0x143ec9c
0143ec97: xorps    xmm2, xmm2
0143ec9a: jmp      0x143eca0
0143ec9c: minss    xmm2, xmm0
0143eca0: movss    xmm0, dword ptr [rip + 0xf88cf4] ; RVA 0x23c799c
0143eca8: mulss    xmm2, xmm0
0143ecac: mulss    xmm5, xmm0
0143ecb0: ucomiss  xmm2, xmm1
0143ecb3: mulss    xmm4, xmm0
0143ecb7: mulss    xmm3, xmm0
0143ecbb: movss    dword ptr [rsp + 0x50], xmm2
0143ecc1: movss    dword ptr [rsp + 0x54], xmm5
0143ecc7: movss    dword ptr [rsp + 0x58], xmm4
0143eccd: movss    dword ptr [rsp + 0x5c], xmm3
0143ecd3: jp       0x143ece4
0143ecd5: jne      0x143ece4
0143ecd7: mov      rcx, rdi
0143ecda: call     0x143eac0
0143ecdf: jmp      0x143edaf
0143ece4: mov      edx, dword ptr [rdi + 0x110]
0143ecea: lea      r8, [rdi + 0x12c]
0143ecf1: mov      rax, qword ptr [rip + 0x1ee7610] ; RVA 0x3326308
0143ecf8: lea      r9, [rdi + 0x124]
0143ecff: lea      r11, [rdi + 0x24]
0143ed03: cmp      edx, -1
0143ed06: jne      0x143ed5e
0143ed08: mov      rcx, qword ptr [rax + 0xd0]
0143ed0f: movzx    edx, word ptr [rdi + 0xbc]
0143ed16: mov      rax, qword ptr [rdi + 0xf8]
0143ed1d: mov      qword ptr [rsp + 0x40], r8
0143ed22: mov      r10, qword ptr [rcx + 0x138]
0143ed29: lea      rcx, [rsp + 0x50]
0143ed2e: mov      r8, qword ptr [rdi + 0x148]
0143ed35: mov      qword ptr [rsp + 0x38], r9
0143ed3a: xor      r9d, r9d
0143ed3d: mov      qword ptr [rsp + 0x30], rcx
0143ed42: mov      rcx, qword ptr [rax + 8]
0143ed46: mov      qword ptr [rsp + 0x28], r11
0143ed4b: mov      dword ptr [rsp + 0x20], edx
0143ed4f: lea      rdx, [rdi + 0x64]
0143ed53: call     r10
0143ed56: mov      dword ptr [rdi + 0x110], eax
0143ed5c: jmp      0x143edaf
0143ed5e: mov      rcx, qword ptr [rdi + 0xf8]
0143ed65: mov      r10, qword ptr [rax + 0xd0]
0143ed6c: movzx    eax, word ptr [rdi + 0xbc]
0143ed73: mov      qword ptr [rsp + 0x48], r8
0143ed78: lea      r8, [rsp + 0x50]
0143ed7d: mov      rcx, qword ptr [rcx + 8]
0143ed81: mov      qword ptr [rsp + 0x40], r9
0143ed86: mov      r9, qword ptr [rdi + 0x148]
0143ed8d: mov      qword ptr [rsp + 0x38], r8
0143ed92: lea      r8, [rdi + 0x64]
0143ed96: mov      qword ptr [rsp + 0x30], r11
0143ed9b: mov      dword ptr [rsp + 0x28], eax
0143ed9f: mov      qword ptr [rsp + 0x20], 0
0143eda8: call     qword ptr [r10 + 0x140]
0143edaf: mov      ecx, dword ptr [rdi]
0143edb1: test     cl, 0x12
0143edb4: je       0x143ede3
0143edb6: mov      rbx, qword ptr [rdi + 0xe0]
0143edbd: test     rbx, rbx
0143edc0: je       0x143ede3
0143edc2: mov      eax, dword ptr [rbx]
0143edc4: test     al, 0x30
0143edc6: je       0x143edd5
0143edc8: and      eax, 0xffffffdf
0143edcb: mov      rcx, rbx
0143edce: mov      dword ptr [rbx], eax
0143edd0: call     0x144de90
0143edd5: mov      rbx, qword ptr [rbx + 0xe8]
0143eddc: test     rbx, rbx
0143eddf: jne      0x143edc2
0143ede1: mov      ecx, dword ptr [rdi]
0143ede3: mov      rbx, qword ptr [rsp + 0x88]
0143edeb: and      ecx, 0xfffffff5
0143edee: mov      dword ptr [rdi], ecx
0143edf0: mov      r8, qword ptr [rdi + 0xf8]
0143edf7: mov      rdi, qword ptr [rsp + 0x70]
0143edfc: test     r8, r8
0143edff: je       0x143ee42
RANGE 0x143ee01-0x143ee54
0143ee01: mov      eax, ecx
0143ee03: shr      eax, 8
0143ee06: test     al, 1
0143ee08: je       0x143ee42
0143ee0a: mov      rax, qword ptr [rip + 0x1ee74f7] ; RVA 0x3326308
0143ee11: shr      ecx, 0xf
0143ee14: test     cl, 1
0143ee17: mov      rcx, qword ptr [r8 + 8]
0143ee1b: mov      rdx, qword ptr [rax + 0xd0]
0143ee22: je       0x143ee3c
0143ee24: call     qword ptr [rdx + 0x298]
0143ee2a: mov      rcx, qword ptr [rsp + 0x60]
0143ee2f: xor      rcx, rsp
0143ee32: call     0x20886a0
0143ee37: add      rsp, 0x78
0143ee3b: ret      
0143ee3c: call     qword ptr [rdx + 0x280]
0143ee42: mov      rcx, qword ptr [rsp + 0x60]
0143ee47: xor      rcx, rsp
0143ee4a: call     0x20886a0
0143ee4f: add      rsp, 0x78
0143ee53: ret      