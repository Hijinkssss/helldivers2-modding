RANGE 0x1486790-0x14882bd
01486790: mov      rax, rsp
01486793: mov      qword ptr [rax + 0x10], rbx
01486797: mov      qword ptr [rax + 0x18], rsi
0148679b: mov      qword ptr [rax + 0x20], rdi
0148679f: push     rbp
014867a0: push     r12
014867a2: push     r13
014867a4: push     r14
014867a6: push     r15
014867a8: lea      rbp, [rax - 0x38]
014867ac: sub      rsp, 0x110
014867b3: movaps   xmmword ptr [rax - 0x38], xmm6
014867b7: movaps   xmmword ptr [rax - 0x48], xmm7
014867bb: movaps   xmmword ptr [rax - 0x58], xmm8
014867c0: movaps   xmmword ptr [rax - 0x68], xmm9
014867c5: mov      rax, qword ptr [rip + 0x11b5844] ; RVA 0x263c010
014867cc: xor      rax, rsp
014867cf: mov      qword ptr [rbp - 0x40], rax
014867d3: xor      ebx, ebx
014867d5: mov      byte ptr [rcx + 0x13], 0
014867d9: mov      r8b, 1
014867dc: mov      dword ptr [rcx + 0x239c20], ebx
014867e2: mov      qword ptr [rcx + 0x239c28], rbx
014867e9: mov      r15, rcx
014867ec: mov      dword ptr [rcx + 0x239c24], 0xbf800000
014867f6: mov      eax, ebx
014867f8: mov      rcx, qword ptr [rcx]
014867fb: movzx    edx, r8b
014867ff: xorps    xmm9, xmm9
01486803: mov      qword ptr [rsp + 0x68], rbx
01486808: call     0x1438a90
0148680d: mov      r8b, 1
01486810: movzx    edx, r8b
01486814: call     0x12f6130
01486819: movss    xmm0, dword ptr [rip + 0xf40eef] ; RVA 0x23c7710
01486821: movss    xmm1, dword ptr [rip + 0xf41527] ; RVA 0x23c7d50
01486829: mov      rcx, qword ptr [rip + 0x1fe6d00] ; RVA 0x346d530
01486830: movss    dword ptr [rsp + 0x6c], xmm0
01486836: movss    xmm0, dword ptr [rip + 0xf4157e] ; RVA 0x23c7dbc
0148683e: mov      dword ptr [rsp + 0x68], ebx
01486842: mov      rax, qword ptr [rsp + 0x68]
01486847: mov      qword ptr [rsp + 0x68], rax
0148684c: subss    xmm0, dword ptr [rsp + 0x68]
01486852: subss    xmm1, dword ptr [rsp + 0x6c]
01486858: movss    dword ptr [rsp + 0x60], xmm0
0148685e: movss    dword ptr [rsp + 0x64], xmm1
01486864: cmp      qword ptr [rcx + 0x1b58], rbx
0148686b: je       0x14868b0
0148686d: movss    xmm2, dword ptr [rip + 0xf3ffcf] ; RVA 0x23c6844
01486875: lea      rax, [rsp + 0x70]
0148687a: mov      rdx, qword ptr [rsp + 0x60]
0148687f: xorps    xmm0, xmm0
01486882: movss    dword ptr [rsp + 0x40], xmm9
01486889: add      rcx, 0x1a68
01486890: mov      qword ptr [rsp + 0x38], rax
01486895: movss    dword ptr [rsp + 0x30], xmm9
0148689c: mov      byte ptr [rsp + 0x28], 1
014868a1: mov      dword ptr [rsp + 0x20], ebx
014868a5: movdqa   xmmword ptr [rsp + 0x70], xmm0
014868ab: call     0x1446d40
014868b0: mov      edx, 1
014868b5: mov      dword ptr [rsp + 0x60], 0x44f00000
014868bd: lea      rcx, [r15 + 0x38]
014868c1: mov      dword ptr [rsp + 0x64], 0x44870000
014868c9: call     0x14467b0
014868ce: mov      rdx, qword ptr [rsp + 0x60]
014868d3: lea      rcx, [r15 + 0x38]
014868d7: call     0x14470d0
014868dc: mov      rdx, rbx
014868df: mov      qword ptr [rsp + 0x60], rbx
014868e4: lea      rcx, [r15 + 0x38]
014868e8: call     0x1447610
014868ed: movss    xmm8, dword ptr [rip + 0xf4046a] ; RVA 0x23c6d60
014868f6: lea      rcx, [r15 + 0x38]
014868fa: mov      dword ptr [rsp + 0x60], 0x3f000000
01486902: mov      dword ptr [rsp + 0x64], 0x3f800000
0148690a: mov      rdx, qword ptr [rsp + 0x60]
0148690f: call     0x144f0d0
01486914: mov      dword ptr [rsp + 0x60], 0x3f000000
0148691c: lea      rcx, [r15 + 0x38]
01486920: mov      dword ptr [rsp + 0x64], 0x3f800000
01486928: mov      rdx, qword ptr [rsp + 0x60]
0148692d: call     0x144f040
01486932: xor      edx, edx
01486934: lea      rcx, [r15 + 0x38]
01486938: call     0x1449160
0148693d: movaps   xmm1, xmm8
01486941: lea      rcx, [r15 + 0x38]
01486945: call     0x1448a40
0148694a: lea      rdx, [rsp + 0x70]
0148694f: mov      dword ptr [rsp + 0x70], 0x3f800000
01486957: lea      rcx, [r15 + 0x38]
0148695b: mov      dword ptr [rsp + 0x74], 0x3f800000
01486963: mov      dword ptr [rsp + 0x78], 0x3f800000
0148696b: call     0x1448600
01486970: mov      rbx, qword ptr [r15]
01486973: lea      rdx, [r15 + 0x38]
01486977: lea      rcx, [rbx + 0x288]
0148697e: call     0x144c530
01486983: lea      rcx, [rbx + 0x288]
0148698a: call     0x144c230
0148698f: lea      rsi, [r15 + 0x148]
01486996: mov      edx, 1
0148699b: mov      rcx, rsi
0148699e: call     0x14467b0
014869a3: mov      dword ptr [rsp + 0x60], 0x44f00000
014869ab: mov      rcx, rsi
014869ae: mov      dword ptr [rsp + 0x64], 0x44870000
014869b6: mov      rdx, qword ptr [rsp + 0x60]
014869bb: call     0x14470d0
014869c0: mov      dword ptr [rsp + 0x60], 0x3f000000
014869c8: mov      rcx, rsi
014869cb: mov      dword ptr [rsp + 0x64], 0x3f000000
014869d3: mov      rdx, qword ptr [rsp + 0x60]
014869d8: call     0x144f0d0
014869dd: mov      dword ptr [rsp + 0x60], 0x3f000000
014869e5: mov      rcx, rsi
014869e8: mov      dword ptr [rsp + 0x64], 0x3f000000
014869f0: mov      rdx, qword ptr [rsp + 0x60]
014869f5: call     0x144f040
014869fa: xor      edx, edx
014869fc: mov      rcx, rsi
014869ff: call     0x1449160
01486a04: movaps   xmm1, xmm8
01486a08: mov      rcx, rsi
01486a0b: call     0x1448a40
01486a10: lea      rdx, [rsp + 0x70]
01486a15: mov      dword ptr [rsp + 0x70], 0x3f800000
01486a1d: mov      rcx, rsi
01486a20: mov      dword ptr [rsp + 0x74], 0x3f800000
01486a28: mov      dword ptr [rsp + 0x78], 0x3f800000
01486a30: call     0x1448600
01486a35: mov      rbx, qword ptr [r15]
01486a38: mov      rdx, rsi
01486a3b: lea      rcx, [rbx + 0x288]
01486a42: call     0x144c530
01486a47: lea      rcx, [rbx + 0x288]
01486a4e: call     0x144c230
01486a53: lea      rdi, [r15 + 0x258]
01486a5a: mov      edx, 1
01486a5f: mov      rcx, rdi
01486a62: call     0x14467b0
01486a67: mov      dword ptr [rsp + 0x60], 0x44f00000
01486a6f: mov      rcx, rdi
01486a72: mov      dword ptr [rsp + 0x64], 0x44870000
01486a7a: mov      rdx, qword ptr [rsp + 0x60]
01486a7f: call     0x14470d0
01486a84: mov      dword ptr [rsp + 0x60], 0x3f000000
01486a8c: mov      rcx, rdi
01486a8f: mov      dword ptr [rsp + 0x64], 0x3f000000
01486a97: mov      rdx, qword ptr [rsp + 0x60]
01486a9c: call     0x144f0d0
01486aa1: mov      dword ptr [rsp + 0x60], 0x3f000000
01486aa9: mov      rcx, rdi
01486aac: mov      dword ptr [rsp + 0x64], 0x3f000000
01486ab4: mov      rdx, qword ptr [rsp + 0x60]
01486ab9: call     0x144f040
01486abe: xor      edx, edx
01486ac0: mov      rcx, rdi
01486ac3: call     0x1449160
01486ac8: movaps   xmm1, xmm8
01486acc: mov      rcx, rdi
01486acf: call     0x1448a40
01486ad4: lea      rdx, [rsp + 0x70]
01486ad9: mov      dword ptr [rsp + 0x70], 0x3f800000
01486ae1: mov      rcx, rdi
01486ae4: mov      dword ptr [rsp + 0x74], 0x3f800000
01486aec: mov      dword ptr [rsp + 0x78], 0x3f800000
01486af4: call     0x1448600
01486af9: mov      rbx, qword ptr [r15]
01486afc: mov      rdx, rdi
01486aff: lea      rcx, [rbx + 0x288]
01486b06: call     0x144c530
01486b0b: lea      rcx, [rbx + 0x288]
01486b12: call     0x144c230
01486b17: lea      rbx, [r15 + 0x36520]
01486b1e: mov      edx, 0x5a
01486b23: mov      rcx, rbx
01486b26: mov      byte ptr [rbx + 0xe08d], 0
01486b2d: call     0x17a9750
01486b32: xor      r8d, r8d
01486b35: xor      edx, edx
01486b37: mov      rcx, rbx
01486b3a: call     0x17aab80
01486b3f: mov      rdx, rbx
01486b42: mov      dword ptr [rbx + 0x2afc], 3
01486b4c: lea      rcx, [r15 + 0x38]
01486b50: mov      byte ptr [rbx + 0x2b0d], 0
01486b57: call     0x144c530
01486b5c: lea      rcx, [r15 + 0x38]
01486b60: call     0x144c230
01486b65: mov      edx, 0x8dc2c88d
01486b6a: mov      rcx, rbx
01486b6d: call     0x17ab2a0
01486b72: cmp      byte ptr [rbx + 0xe071], 1
01486b79: je       0x1486b8a
01486b7b: mov      rcx, rbx
01486b7e: mov      byte ptr [rbx + 0xe071], 1
01486b85: call     0x17abe40
01486b8a: movss    xmm0, dword ptr [rip + 0xf415e2] ; RVA 0x23c8174
01486b92: mov      rcx, rbx
01486b95: movss    dword ptr [rsp + 0x64], xmm0
01486b9b: mov      dword ptr [rsp + 0x60], 0
01486ba3: mov      rdx, qword ptr [rsp + 0x60]
01486ba8: call     0x1447610
01486bad: mov      qword ptr [rsp + 0x60], 0x3f000000
01486bb6: lea      rbx, [r15 + 0x368]
01486bbd: mov      r8, qword ptr [rsp + 0x60]
01486bc2: mov      rcx, rbx
01486bc5: mov      qword ptr [rsp + 0x68], 0x3f000000
01486bce: mov      rdx, qword ptr [rsp + 0x68]
01486bd3: call     0x1873a70
01486bd8: mov      rdx, rbx
01486bdb: lea      rcx, [r15 + 0x38]
01486bdf: call     0x144c530
01486be4: lea      rcx, [r15 + 0x38]
01486be8: call     0x144c230
01486bed: cmp      byte ptr [rbx + 0x361a8], 0
01486bf4: je       0x1486c15
01486bf6: movaps   xmm1, xmm8
01486bfa: mov      byte ptr [rbx + 0x361a8], 0
01486c01: mov      rcx, rbx
01486c04: call     0x1448a40
01486c09: lea      rcx, [rbx + 0x110]
01486c10: call     0x1448a40
01486c15: mov      dword ptr [rsp + 0x60], 0
01486c1d: lea      rcx, [r15 + 0x445b0]
01486c24: mov      dword ptr [rsp + 0x64], 0x3f800000
01486c2c: mov      r9, qword ptr [rsp + 0x60]
01486c31: mov      dword ptr [rsp + 0x68], 0
01486c39: mov      dword ptr [rsp + 0x6c], 0x3f800000
01486c41: mov      r8, qword ptr [rsp + 0x68]
01486c46: mov      dword ptr [rsp + 0x50], 0x42640000
01486c4e: mov      dword ptr [rsp + 0x54], 0xc3070000
01486c56: mov      rdx, qword ptr [rsp + 0x50]
01486c5b: call     0x187efa0
01486c60: lea      rdx, [r15 + 0x445b0]
01486c67: mov      rcx, rsi
01486c6a: call     0x144c530
01486c6f: mov      rcx, rsi
01486c72: call     0x144c230
01486c77: mov      dword ptr [rsp + 0x60], 0
01486c7f: lea      rcx, [r15 + 0x55170]
01486c86: mov      dword ptr [rsp + 0x64], 0x3f800000
01486c8e: mov      r8, qword ptr [rsp + 0x60]
01486c93: mov      dword ptr [rsp + 0x68], 0x42640000
01486c9b: mov      dword ptr [rsp + 0x6c], 0xc3070000
01486ca3: mov      rdx, qword ptr [rsp + 0x68]
01486ca8: mov      dword ptr [rsp + 0x50], 0
01486cb0: mov      dword ptr [rsp + 0x54], 0x3f800000
01486cb8: mov      r9, qword ptr [rsp + 0x50]
01486cbd: call     0x1a1d540
01486cc2: lea      rdx, [r15 + 0x55170]
01486cc9: mov      rcx, rsi
01486ccc: call     0x144c530
01486cd1: mov      rcx, rsi
01486cd4: call     0x144c230
01486cd9: mov      rdx, qword ptr [rip + 0x20089a8] ; RVA 0x348f688
01486ce0: lea      rcx, [r15 + 0x60de8]
01486ce7: mov      qword ptr [rsp + 0x60], 0
01486cf0: mov      r8, qword ptr [rsp + 0x60]
01486cf5: mov      dword ptr [rsp + 0x50], 0
01486cfd: mov      dword ptr [rsp + 0x54], 0x3f000000
01486d05: mov      r9, qword ptr [rsp + 0x50]
01486d0a: call     0x18804b0
01486d0f: lea      rdx, [r15 + 0x60de8]
01486d16: mov      rcx, rsi
01486d19: call     0x144c530
01486d1e: mov      rcx, rsi
01486d21: call     0x144c230
01486d26: mov      rdx, qword ptr [rip + 0x200895b] ; RVA 0x348f688
01486d2d: lea      rcx, [r15 + 0x656e0]
01486d34: mov      qword ptr [rsp + 0x60], 0
01486d3d: mov      r8, qword ptr [rsp + 0x60]
01486d42: mov      qword ptr [rsp + 0x50], 0
01486d4b: mov      r9, qword ptr [rsp + 0x50]
01486d50: call     0x19a0fa0
01486d55: lea      rdx, [r15 + 0x656e0]
01486d5c: mov      rcx, rsi
01486d5f: call     0x144c530
01486d64: mov      rcx, rsi
01486d67: call     0x144c230
01486d6c: mov      rdx, qword ptr [rip + 0x2008915] ; RVA 0x348f688
01486d73: lea      rcx, [r15 + 0x74d58]
01486d7a: mov      qword ptr [rsp + 0x60], 0
01486d83: mov      r8, qword ptr [rsp + 0x60]
01486d88: mov      dword ptr [rsp + 0x50], 0
01486d90: mov      dword ptr [rsp + 0x54], 0x3f000000
01486d98: mov      r9, qword ptr [rsp + 0x50]
01486d9d: mov      dword ptr [rsp + 0x20], 0x32
01486da5: call     0x187bc40
01486daa: lea      rdx, [r15 + 0x74d58]
01486db1: mov      rcx, rsi
01486db4: call     0x144c530
01486db9: mov      rcx, rsi
01486dbc: call     0x144c230
01486dc1: mov      rdx, qword ptr [rip + 0x20088c0] ; RVA 0x348f688
01486dc8: lea      rcx, [r15 + 0x804c0]
01486dcf: mov      qword ptr [rsp + 0x60], 0
01486dd8: mov      r8, qword ptr [rsp + 0x60]
01486ddd: mov      dword ptr [rsp + 0x50], 0
01486de5: mov      dword ptr [rsp + 0x54], 0x3f000000
01486ded: mov      r9, qword ptr [rsp + 0x50]
01486df2: call     0x187d2c0
01486df7: lea      rdx, [r15 + 0x804c0]
01486dfe: mov      rcx, rsi
01486e01: call     0x144c530
01486e06: mov      rcx, rsi
01486e09: call     0x144c230
01486e0e: lea      rdi, [r15 + 0x21d990]
01486e15: mov      edx, 1
01486e1a: mov      rcx, rdi
01486e1d: call     0x14467b0
01486e22: movss    xmm1, dword ptr [rip + 0xf41316] ; RVA 0x23c8140
01486e2a: mov      rcx, rdi
01486e2d: movss    dword ptr [rsp + 0x54], xmm1
01486e33: mov      dword ptr [rsp + 0x50], 0xc2200000
01486e3b: mov      rdx, qword ptr [rsp + 0x50]
01486e40: call     0x1447610
01486e45: mov      dword ptr [rsp + 0x50], 0x3f800000
01486e4d: mov      rcx, rdi
01486e50: mov      dword ptr [rsp + 0x54], 0x3f800000
01486e58: mov      rdx, qword ptr [rsp + 0x50]
01486e5d: call     0x144f0d0
01486e62: mov      dword ptr [rsp + 0x50], 0x3f800000
01486e6a: mov      rcx, rdi
01486e6d: mov      dword ptr [rsp + 0x54], 0x3f800000
01486e75: mov      rdx, qword ptr [rsp + 0x50]
01486e7a: call     0x144f040
01486e7f: mov      rdx, rdi
01486e82: mov      rcx, rsi
01486e85: call     0x144c530
01486e8a: mov      rcx, rsi
01486e8d: call     0x144c230
01486e92: movabs   rax, 0xb00000000
01486e9c: mov      dword ptr [rsp + 0x60], 0x3f800000
01486ea4: mov      qword ptr [rsp + 0x28], rax
01486ea9: lea      r14, [r15 + 0x21daa0]
01486eb0: mov      dword ptr [rsp + 0x64], 0x3f800000
01486eb8: mov      rcx, r14
01486ebb: mov      r8, qword ptr [rsp + 0x60]
01486ec0: mov      qword ptr [rsp + 0x68], 0
01486ec9: mov      rdx, qword ptr [rsp + 0x68]
01486ece: mov      dword ptr [rsp + 0x50], 0x3f800000
01486ed6: mov      dword ptr [rsp + 0x54], 0x3f800000
01486ede: mov      r9, qword ptr [rsp + 0x50]
01486ee3: mov      dword ptr [rsp + 0x20], 0xa0
01486eeb: call     0x19ab9a0
01486ef0: mov      rdx, r14
01486ef3: mov      rcx, rdi
01486ef6: call     0x144c530
01486efb: mov      rcx, rdi
01486efe: call     0x144c230
01486f03: mov      rcx, r14
01486f06: call     0x144e110
01486f0b: movabs   rax, 0xe00000000
01486f15: mov      dword ptr [rsp + 0x30], 0x1be64b49
01486f1d: mov      qword ptr [rsp + 0x28], rax
01486f22: lea      rsi, [r15 + 0x220638]
01486f29: mov      dword ptr [rsp + 0x60], 0x3f800000
01486f31: mov      rcx, rsi
01486f34: mov      dword ptr [rsp + 0x64], 0x3f800000
01486f3c: mov      r8, qword ptr [rsp + 0x60]
01486f41: mov      qword ptr [rsp + 0x68], 0
01486f4a: mov      rdx, qword ptr [rsp + 0x68]
01486f4f: mov      dword ptr [rsp + 0x50], 0x3f800000
01486f57: mov      dword ptr [rsp + 0x54], 0x3f800000
01486f5f: mov      r9, qword ptr [rsp + 0x50]
01486f64: mov      dword ptr [rsp + 0x20], 0x32
01486f6c: call     0x19d3760
01486f71: mov      rdx, rsi
01486f74: mov      rcx, rdi
01486f77: call     0x144c530
01486f7c: mov      rcx, rdi
01486f7f: call     0x144c230
01486f84: mov      rcx, rsi
01486f87: call     0x144e110
01486f8c: mov      dword ptr [rsp + 0x30], 0xc2fc1815
01486f94: lea      rbx, [r15 + 0x222f18]
01486f9b: movabs   rax, 0x3500000000
01486fa5: mov      dword ptr [rsp + 0x50], 0x3f800000
01486fad: mov      qword ptr [rsp + 0x28], rax
01486fb2: mov      dword ptr [rsp + 0x20], 0x32
01486fba: mov      dword ptr [rsp + 0x54], 0x3f800000
01486fc2: mov      dword ptr [rsp + 0x60], 0x3f800000
01486fca: mov      dword ptr [rsp + 0x64], 0x3f800000
01486fd2: mov      qword ptr [rsp + 0x68], 0
01486fdb: mov      r9, qword ptr [rsp + 0x50]
01486fe0: mov      rcx, rbx
01486fe3: mov      r8, qword ptr [rsp + 0x60]
01486fe8: mov      rdx, qword ptr [rsp + 0x68]
01486fed: call     0x19d3760
01486ff2: mov      rdx, rbx
01486ff5: mov      rcx, rdi
01486ff8: call     0x144c530
01486ffd: mov      rcx, rdi
01487000: call     0x144c230
01487005: mov      rcx, rbx
01487008: call     0x144e110
0148700d: xor      ecx, ecx
0148700f: lea      r13, [r15 + 0x227330]
01487016: mov      qword ptr [r13], rdi
0148701a: lea      rdx, [r15 + 0x2274b0]
01487021: mov      dword ptr [r13 + 0x20], ecx
01487025: lea      r10, [r15 + 0x227430]
0148702c: mov      dword ptr [r13 + 0x24], 1
01487034: mov      eax, ecx
01487036: mov      word ptr [r13 + 0x29], 0x100
0148703d: mov      byte ptr [r13 + 0x28], 1
01487042: mov      qword ptr [r13 + 8], rcx
01487046: mov      qword ptr [r13 + 0x10], rcx
0148704a: mov      qword ptr [r13 + 0x18], rcx
0148704e: mov      qword ptr [r13 + 0x2c], rcx
01487052: mov      qword ptr [r13 + 0x34], rcx
01487056: mov      qword ptr [r13 + 0x3c], rcx
0148705a: mov      qword ptr [r13 + 0x44], rcx
0148705e: mov      qword ptr [r13 + 0x54], rcx
01487062: mov      rax, qword ptr [rdi + 0xc]
01487066: mov      qword ptr [r13 + 0x4c], rax
0148706a: mov      eax, ecx
0148706c: mov      dword ptr [r13 + 0x64], ecx
01487070: mov      qword ptr [r13 + 0x70], rcx
01487074: mov      qword ptr [r13 + 0x78], rcx
01487078: mov      qword ptr [rdx], rbx
0148707b: mov      dword ptr [rdx + 0x20], ecx
0148707e: mov      dword ptr [rdx + 0x24], 1
01487085: mov      word ptr [rdx + 0x29], 0x100
0148708b: mov      byte ptr [rdx + 0x28], 1
0148708f: mov      qword ptr [rdx + 8], rcx
01487093: mov      qword ptr [rdx + 0x10], rcx
01487097: mov      qword ptr [rdx + 0x18], rcx
0148709b: mov      qword ptr [rdx + 0x2c], rcx
0148709f: mov      qword ptr [rdx + 0x34], rcx
014870a3: mov      qword ptr [rdx + 0x3c], rcx
014870a7: mov      qword ptr [rdx + 0x44], rcx
014870ab: mov      qword ptr [rdx + 0x54], rcx
014870af: mov      rax, qword ptr [rbx + 0xc]
014870b3: lea      rbx, [r15 + 0x2273b0]
014870ba: mov      qword ptr [rdx + 0x4c], rax
014870be: mov      eax, ecx
014870c0: mov      dword ptr [rdx + 0x64], ecx
014870c3: mov      qword ptr [rdx + 0x70], rcx
014870c7: mov      qword ptr [rdx + 0x78], rcx
014870cb: mov      qword ptr [r10], rsi
014870ce: mov      dword ptr [r10 + 0x20], ecx
014870d2: mov      dword ptr [r10 + 0x24], 1
014870da: mov      word ptr [r10 + 0x29], 0x100
014870e1: mov      byte ptr [r10 + 0x28], 1
014870e6: mov      qword ptr [r10 + 8], rcx
014870ea: mov      qword ptr [r10 + 0x10], rcx
014870ee: mov      qword ptr [r10 + 0x18], rcx
014870f2: mov      qword ptr [r10 + 0x2c], rcx
014870f6: mov      qword ptr [r10 + 0x34], rcx
014870fa: mov      qword ptr [r10 + 0x3c], rcx
014870fe: mov      qword ptr [r10 + 0x44], rcx
01487102: mov      qword ptr [r10 + 0x54], rcx
01487106: mov      rax, qword ptr [rsi + 0xc]
0148710a: mov      qword ptr [r10 + 0x4c], rax
0148710e: mov      dword ptr [r10 + 0x64], ecx
01487112: mov      qword ptr [r10 + 0x70], rcx
01487116: mov      qword ptr [r10 + 0x78], rcx
0148711a: mov      qword ptr [rsp + 0x50], rcx
0148711f: mov      qword ptr [rsp + 0x50], rcx
01487124: mov      qword ptr [rbx], r14
01487127: mov      dword ptr [rbx + 0x20], ecx
0148712a: mov      dword ptr [rbx + 0x24], 1
01487131: mov      word ptr [rbx + 0x29], 0x100
01487137: mov      qword ptr [rsp + 0x50], rcx
0148713c: mov      byte ptr [rbx + 0x28], 1
01487140: mov      eax, ecx
01487142: mov      qword ptr [rbx + 8], rcx
01487146: mov      qword ptr [rbx + 0x10], rcx
0148714a: mov      qword ptr [rbx + 0x18], rcx
0148714e: mov      qword ptr [rbx + 0x2c], rcx
01487152: mov      qword ptr [rbx + 0x34], rcx
01487156: mov      qword ptr [rbx + 0x3c], rcx
0148715a: mov      qword ptr [rbx + 0x44], rcx
0148715e: mov      qword ptr [rbx + 0x54], rcx
01487162: mov      rax, qword ptr [r14 + 0xc]
01487166: mov      qword ptr [rbx + 0x4c], rax
0148716a: mov      dword ptr [rbx + 0x64], ecx
0148716d: mov      qword ptr [rbx + 0x70], rcx
01487171: mov      qword ptr [rbx + 0x78], rcx
01487175: mov      rax, qword ptr [r13 + 0x10]
01487179: mov      qword ptr [rsp + 0x50], rcx
0148717e: test     rax, rax
01487181: jne      0x1487189
01487183: mov      qword ptr [r13 + 0x10], rdx
01487187: jmp      0x148719d
01487189: mov      rcx, qword ptr [rax + 0x18]
0148718d: test     rcx, rcx
01487190: jne      0x1487198
01487192: mov      qword ptr [rax + 0x18], rdx
01487196: jmp      0x148719d
01487198: call     0x18f5aa0
0148719d: mov      rcx, rdx
014871a0: mov      qword ptr [rdx + 8], r13
014871a4: call     0x18f58f0
014871a9: mov      byte ptr [r13 + 0x28], 1
014871ae: mov      rax, qword ptr [r13 + 0x10]
014871b2: test     rax, rax
014871b5: jne      0x14871bd
014871b7: mov      qword ptr [r13 + 0x10], r10
014871bb: jmp      0x14871d4
014871bd: mov      rcx, qword ptr [rax + 0x18]
014871c1: test     rcx, rcx
014871c4: jne      0x14871cc
014871c6: mov      qword ptr [rax + 0x18], r10
014871ca: jmp      0x14871d4
014871cc: mov      rdx, r10
014871cf: call     0x18f5aa0
014871d4: mov      rcx, r10
014871d7: mov      qword ptr [r10 + 8], r13
014871db: call     0x18f58f0
014871e0: mov      byte ptr [r13 + 0x28], 1
014871e5: mov      rax, qword ptr [r13 + 0x10]
014871e9: test     rax, rax
014871ec: jne      0x14871f4
014871ee: mov      qword ptr [r13 + 0x10], rbx
014871f2: jmp      0x148720b
014871f4: mov      rcx, qword ptr [rax + 0x18]
014871f8: test     rcx, rcx
014871fb: jne      0x1487203
014871fd: mov      qword ptr [rax + 0x18], rbx
01487201: jmp      0x148720b
01487203: mov      rdx, rbx
01487206: call     0x18f5aa0
0148720b: mov      rcx, rbx
0148720e: mov      qword ptr [rbx + 8], r13
01487212: call     0x18f58f0
01487217: mov      byte ptr [r13 + 0x28], 1
0148721c: cmp      dword ptr [r15 + 0x227350], 4
01487224: je       0x1487259
01487226: mov      r10, qword ptr [r15 + 0x227340]
0148722d: mov      dword ptr [r15 + 0x227350], 4
01487238: test     r10, r10
0148723b: je       0x1487251
0148723d: nop      dword ptr [rax]
01487240: mov      rcx, r10
01487243: call     0x18f58f0
01487248: mov      r10, qword ptr [r10 + 0x18]
0148724c: test     r10, r10
0148724f: jne      0x1487240
01487251: mov      byte ptr [r15 + 0x227358], 1
01487259: cmp      qword ptr [r13 + 8], 0
0148725e: mov      dword ptr [r13 + 0x24], 1
01487266: je       0x1487270
01487268: mov      rcx, r13
0148726b: call     0x18f58f0
01487270: mov      rcx, r15
01487273: mov      dword ptr [r15 + 0x2274e8], 0x41a00000
0148727e: mov      byte ptr [r15 + 0x2274d8], 1
01487286: mov      dword ptr [r15 + 0x227468], 0x41a00000
01487291: mov      byte ptr [r15 + 0x227458], 1
01487299: call     0x148f060
0148729e: lea      rbx, [r15 + 0xb44f8]
014872a5: mov      edx, 1
014872aa: mov      rcx, rbx
014872ad: call     0x14467b0
014872b2: movss    xmm0, dword ptr [rip + 0xf40662] ; RVA 0x23c791c
014872ba: mov      rcx, rbx
014872bd: movss    dword ptr [rsp + 0x54], xmm0
014872c3: mov      dword ptr [rsp + 0x50], 0
014872cb: mov      rdx, qword ptr [rsp + 0x50]
014872d0: call     0x1447610
014872d5: mov      qword ptr [rsp + 0x50], 0x3f000000
014872de: mov      rcx, rbx
014872e1: mov      rdx, qword ptr [rsp + 0x50]
014872e6: call     0x144f0d0
014872eb: mov      qword ptr [rsp + 0x50], 0x3f000000
014872f4: mov      rcx, rbx
014872f7: mov      rdx, qword ptr [rsp + 0x50]
014872fc: call     0x144f040
01487301: movaps   xmm1, xmm8
01487305: mov      rcx, rbx
01487308: call     0x1448a40
0148730d: lea      rdx, [rsp + 0x70]
01487312: mov      dword ptr [rsp + 0x70], 0x3f800000
0148731a: mov      rcx, rbx
0148731d: mov      dword ptr [rsp + 0x74], 0x3f800000
01487325: mov      dword ptr [rsp + 0x78], 0x3f800000
0148732d: call     0x1448600
01487332: mov      rdx, rbx
01487335: lea      rcx, [r15 + 0x38]
01487339: call     0x144c530
0148733e: lea      rcx, [r15 + 0x38]
01487342: call     0x144c230
01487347: lea      r13, [r15 + 0xb6b18]
0148734e: mov      edx, 1
01487353: mov      rcx, r13
01487356: call     0x14467b0
0148735b: mov      dword ptr [rsp + 0x50], 0
01487363: mov      rcx, r13
01487366: mov      dword ptr [rsp + 0x54], 0x42340000
0148736e: mov      rdx, qword ptr [rsp + 0x50]
01487373: call     0x14470d0
01487378: mov      dword ptr [rsp + 0x50], 0x3f000000
01487380: mov      rcx, r13
01487383: mov      dword ptr [rsp + 0x54], 0x3f000000
0148738b: mov      rdx, qword ptr [rsp + 0x50]
01487390: call     0x144f0d0
01487395: mov      dword ptr [rsp + 0x50], 0x3f000000
0148739d: mov      rcx, r13
014873a0: mov      dword ptr [rsp + 0x54], 0x3f000000
014873a8: mov      rdx, qword ptr [rsp + 0x50]
014873ad: call     0x144f040
014873b2: movaps   xmm1, xmm8
014873b6: mov      rcx, r13
014873b9: call     0x1448a40
014873be: lea      rdx, [rsp + 0x70]
014873c3: mov      dword ptr [rsp + 0x70], 0x3f800000
014873cb: mov      rcx, r13
014873ce: mov      dword ptr [rsp + 0x74], 0x3f800000
014873d6: mov      dword ptr [rsp + 0x78], 0x3f800000
014873de: call     0x1448600
014873e3: mov      rdx, r13
014873e6: mov      rcx, rbx
014873e9: call     0x144c530
014873ee: mov      rcx, rbx
014873f1: call     0x144c230
014873f6: lea      rbx, [r15 + 0xb6c28]
014873fd: mov      edx, 5
01487402: mov      rcx, rbx
01487405: call     0x14467b0
0148740a: movss    xmm7, dword ptr [rip + 0xf3f816] ; RVA 0x23c6c28
01487412: mov      rcx, rbx
01487415: movaps   xmm1, xmm7
01487418: mov      dword ptr [rbx + 0x110], 0xffffffff
01487422: call     0x1448a40
01487427: mov      qword ptr [rsp + 0x70], 0
01487430: lea      rdx, [rsp + 0x70]
01487435: mov      dword ptr [rsp + 0x78], 0
0148743d: mov      rcx, rbx
01487440: call     0x1448600
01487445: mov      edx, 0x32
0148744a: mov      rcx, rbx
0148744d: call     0x1449160
01487452: mov      edx, 6
01487457: mov      rcx, rbx
0148745a: call     0x1449020
0148745f: mov      eax, dword ptr [rbx]
01487461: and      eax, 0x3c0000
01487466: cmp      eax, 0x80000
0148746b: jne      0x148747b
0148746d: movups   xmm0, xmmword ptr [rip + 0x2346c5c] ; RVA 0x37ce0d0
01487474: movups   xmmword ptr [rbx + 0x110], xmm0
0148747b: mov      rdx, rbx
0148747e: mov      rcx, r13
01487481: call     0x144c530
01487486: mov      rcx, r13
01487489: call     0x144c230
0148748e: lea      rsi, [r15 + 0xb6d40]
01487495: mov      rcx, rsi
01487498: call     0x143ea20
0148749d: movabs   rdi, 0x9c02d37a657590d7
014874a7: movabs   rbx, 0xf6978e86e4f4b0d5
014874b1: mov      r8, rdi
014874b4: mov      rdx, rbx
014874b7: xor      r9d, r9d
014874ba: mov      rcx, rsi
014874bd: call     0x14501a0
014874c2: mov      edx, 6
014874c7: mov      rcx, rsi
014874ca: call     0x1449020
014874cf: mov      eax, dword ptr [rsi]
014874d1: and      eax, 0x3c0000
014874d6: cmp      eax, 0x80000
014874db: jne      0x14874eb
014874dd: movups   xmm0, xmmword ptr [rip + 0x2346bec] ; RVA 0x37ce0d0
014874e4: movups   xmmword ptr [rsi + 0x110], xmm0
014874eb: movss    xmm6, dword ptr [rip + 0xf3f7e1] ; RVA 0x23c6cd4
014874f3: lea      rdx, [rsp + 0x70]
014874f8: movaps   xmm0, xmm8
014874fc: mov      dword ptr [rsp + 0x58], 0
01487504: mov      eax, dword ptr [rsp + 0x58]
01487508: mov      rcx, rsi
0148750b: unpcklps xmm0, xmm6
0148750e: movsd    qword ptr [rsp + 0x70], xmm0
01487514: mov      dword ptr [rsp + 0x78], eax
01487518: call     0x1448600
0148751d: mov      edx, 0x33
01487522: mov      rcx, rsi
01487525: call     0x1449160
0148752a: mov      rdx, rsi
0148752d: mov      rcx, r13
01487530: call     0x144c530
01487535: mov      rcx, r13
01487538: call     0x144c230
0148753d: xor      r10d, r10d
01487540: mov      dword ptr [rsp + 0x60], 0x3f000000
01487548: mov      dword ptr [rsp + 0x40], r10d
0148754d: lea      rax, [rbp - 0x80]
01487551: movss    dword ptr [rsp + 0x38], xmm9
01487558: lea      rcx, [r15 + 0xb6e98]
0148755f: mov      byte ptr [rsp + 0x30], r10b
01487564: xorps    xmm0, xmm0
01487567: mov      qword ptr [rsp + 0x28], rax
0148756c: mov      edx, r10d
0148756f: mov      dword ptr [rsp + 0x64], 0x3f000000
01487577: mov      r8, qword ptr [rsp + 0x60]
0148757c: mov      dword ptr [rsp + 0x50], 0x3f000000
01487584: mov      dword ptr [rsp + 0x54], 0x3f000000
0148758c: mov      r9, qword ptr [rsp + 0x50]
01487591: mov      dword ptr [rsp + 0x20], 0x34
01487599: mov      dword ptr [rbp - 0x80], r10d
0148759d: mov      dword ptr [rbp - 0x7c], 0xd
014875a4: mov      dword ptr [rbp - 0x78], 0xbde3922b
014875ab: movups   xmmword ptr [rbp - 0x74], xmm0
014875af: mov      qword ptr [rsp + 0x68], r10
014875b4: call     0x17a2f00
014875b9: movaps   xmm0, xmm8
014875bd: mov      dword ptr [rsp + 0x58], 0
014875c5: mov      eax, dword ptr [rsp + 0x58]
014875c9: lea      rcx, [r15 + 0xb7928]
014875d0: unpcklps xmm0, xmm6
014875d3: lea      rdx, [rsp + 0x70]
014875d8: movsd    qword ptr [rsp + 0x70], xmm0
014875de: mov      dword ptr [rsp + 0x78], eax
014875e2: call     0x1448600
014875e7: lea      rdx, [r15 + 0xb6e98]
014875ee: mov      rcx, r13
014875f1: call     0x144c530
014875f6: mov      rcx, r13
014875f9: call     0x144c230
014875fe: lea      r14, [r15 + 0xb8c18]
01487605: mov      rcx, r14
01487608: call     0x143ea20
0148760d: movabs   rsi, 0xb6a14c35af5f4e4
01487617: xor      r9d, r9d
0148761a: mov      r8, rsi
0148761d: mov      rdx, rbx
01487620: mov      rcx, r14
01487623: call     0x14501a0
01487628: mov      dword ptr [rsp + 0x50], 0x41200000
01487630: mov      rcx, r14
01487633: mov      dword ptr [rsp + 0x54], 0x42640000
0148763b: mov      rdx, qword ptr [rsp + 0x50]
01487640: call     0x14470d0
01487645: movaps   xmm0, xmm8
01487649: mov      dword ptr [rsp + 0x58], 0
01487651: mov      eax, dword ptr [rsp + 0x58]
01487655: lea      rdx, [rsp + 0x70]
0148765a: unpcklps xmm0, xmm6
0148765d: mov      rcx, r14
01487660: movsd    qword ptr [rsp + 0x70], xmm0
01487666: mov      dword ptr [rsp + 0x78], eax
0148766a: call     0x1448600
0148766f: mov      dword ptr [rsp + 0x50], 0x3f000000
01487677: mov      rcx, r14
0148767a: mov      dword ptr [rsp + 0x54], 0x3f000000
01487682: mov      rdx, qword ptr [rsp + 0x50]
01487687: call     0x144f0d0
0148768c: mov      dword ptr [rsp + 0x50], 0x3f000000
01487694: mov      rcx, r14
01487697: mov      dword ptr [rsp + 0x54], 0x3f000000
0148769f: mov      rdx, qword ptr [rsp + 0x50]
014876a4: call     0x144f040
014876a9: mov      edx, 0x36
014876ae: mov      rcx, r14
014876b1: call     0x1449160
014876b6: mov      rdx, r14
014876b9: mov      rcx, r13
014876bc: call     0x144c530
014876c1: mov      rcx, r13
014876c4: call     0x144c230
014876c9: lea      r13, [r15 + 0xb4608]
014876d0: mov      edx, 1
014876d5: mov      rcx, r13
014876d8: call     0x14467b0
014876dd: mov      dword ptr [rsp + 0x50], 0
014876e5: mov      rcx, r13
014876e8: mov      dword ptr [rsp + 0x54], 0x42340000
014876f0: mov      rdx, qword ptr [rsp + 0x50]
014876f5: call     0x14470d0
014876fa: mov      dword ptr [rsp + 0x50], 0x3f000000
01487702: mov      rcx, r13
01487705: mov      dword ptr [rsp + 0x54], 0x3f000000
0148770d: mov      rdx, qword ptr [rsp + 0x50]
01487712: call     0x144f0d0
01487717: mov      dword ptr [rsp + 0x50], 0x3f000000
0148771f: mov      rcx, r13
01487722: mov      dword ptr [rsp + 0x54], 0x3f000000
0148772a: mov      rdx, qword ptr [rsp + 0x50]
0148772f: call     0x144f040
01487734: movaps   xmm0, xmm8
01487738: mov      dword ptr [rsp + 0x58], 0x3f800000
01487740: mov      eax, dword ptr [rsp + 0x58]
01487744: lea      rdx, [rsp + 0x70]
01487749: unpcklps xmm0, xmm8
0148774d: mov      rcx, r13
01487750: movsd    qword ptr [rsp + 0x70], xmm0
01487756: mov      dword ptr [rsp + 0x78], eax
0148775a: call     0x1448600
0148775f: movaps   xmm1, xmm9
01487763: mov      rcx, r13
01487766: call     0x1448a40
0148776b: mov      rdx, r13
0148776e: lea      rcx, [r15 + 0xb44f8]
01487775: call     0x144c530
0148777a: lea      rcx, [r15 + 0xb44f8]
01487781: call     0x144c230
01487786: lea      r14, [r15 + 0xb4718]
0148778d: mov      edx, 5
01487792: mov      rcx, r14
01487795: call     0x14467b0
0148779a: movaps   xmm1, xmm7
0148779d: mov      dword ptr [r14 + 0x110], 0xffffffff
014877a8: mov      rcx, r14
014877ab: call     0x1448a40
014877b0: lea      rdx, [rsp + 0x70]
014877b5: mov      qword ptr [rsp + 0x70], 0
014877be: mov      rcx, r14
014877c1: mov      dword ptr [rsp + 0x78], 0
014877c9: call     0x1448600
014877ce: mov      edx, 0x32
014877d3: mov      rcx, r14
014877d6: call     0x1449160
014877db: mov      edx, 6
014877e0: mov      rcx, r14
014877e3: call     0x1449020
014877e8: mov      eax, dword ptr [r14]
014877eb: and      eax, 0x3c0000
014877f0: cmp      eax, 0x80000
014877f5: jne      0x1487806
014877f7: movups   xmm0, xmmword ptr [rip + 0x23468d2] ; RVA 0x37ce0d0
014877fe: movups   xmmword ptr [r14 + 0x110], xmm0
01487806: mov      rdx, r14
01487809: mov      rcx, r13
0148780c: call     0x144c530
01487811: mov      rcx, r13
01487814: call     0x144c230
01487819: lea      r14, [r15 + 0xb4830]
01487820: mov      rcx, r14
01487823: call     0x143ea20
01487828: xor      r9d, r9d
0148782b: mov      r8, rdi
0148782e: mov      rdx, rbx
01487831: mov      rcx, r14
01487834: call     0x14501a0
01487839: mov      edx, 6
0148783e: mov      rcx, r14
01487841: call     0x1449020
01487846: mov      eax, dword ptr [r14]
01487849: and      eax, 0x3c0000
0148784e: cmp      eax, 0x80000
01487853: jne      0x1487864
01487855: movups   xmm0, xmmword ptr [rip + 0x2346874] ; RVA 0x37ce0d0
0148785c: movups   xmmword ptr [r14 + 0x110], xmm0
01487864: movss    xmm1, dword ptr [rip + 0xf3f0bc] ; RVA 0x23c6928
0148786c: lea      rdx, [rsp + 0x70]
01487871: movss    xmm6, dword ptr [rip + 0xf3f423] ; RVA 0x23c6c9c
01487879: mov      rcx, r14
0148787c: unpcklps xmm1, xmm6
0148787f: mov      dword ptr [rsp + 0x58], 0x3eeeeeef
01487887: mov      eax, dword ptr [rsp + 0x58]
0148788b: movsd    qword ptr [rsp + 0x70], xmm1
01487891: mov      dword ptr [rsp + 0x78], eax
01487895: call     0x1448600
0148789a: mov      edx, 0x33
0148789f: mov      rcx, r14
014878a2: call     0x1449160
014878a7: mov      rdx, r14
014878aa: mov      rcx, r13
014878ad: call     0x144c530
014878b2: mov      rcx, r13
014878b5: call     0x144c230
014878ba: xor      eax, eax
014878bc: mov      dword ptr [rsp + 0x60], 0x3f000000
014878c4: mov      dword ptr [rsp + 0x40], eax
014878c8: lea      rcx, [r15 + 0xb4988]
014878cf: movss    dword ptr [rsp + 0x38], xmm9
014878d6: xorps    xmm0, xmm0
014878d9: mov      byte ptr [rsp + 0x30], al
014878dd: mov      qword ptr [rsp + 0x68], rax
014878e2: mov      rdx, qword ptr [rsp + 0x68]
014878e7: mov      dword ptr [rbp - 0x60], eax
014878ea: lea      rax, [rbp - 0x60]
014878ee: mov      qword ptr [rsp + 0x28], rax
014878f3: mov      dword ptr [rsp + 0x64], 0x3f000000
014878fb: mov      r8, qword ptr [rsp + 0x60]
01487900: mov      dword ptr [rsp + 0x50], 0x3f000000
01487908: mov      dword ptr [rsp + 0x54], 0x3f000000
01487910: mov      r9, qword ptr [rsp + 0x50]
01487915: mov      dword ptr [rsp + 0x20], 0x34
0148791d: mov      dword ptr [rbp - 0x5c], 0xc
01487924: mov      dword ptr [rbp - 0x58], 0xd1aa7131
0148792b: movups   xmmword ptr [rbp - 0x54], xmm0
0148792f: call     0x17a2f00
01487934: movaps   xmm1, xmm8
01487938: lea      rcx, [r15 + 0xb5418]
0148793f: call     0x1448a40
01487944: lea      rdx, [rsp + 0x70]
01487949: mov      dword ptr [rsp + 0x70], 0x3f800000
01487951: lea      rcx, [r15 + 0xb5418]
01487958: mov      dword ptr [rsp + 0x74], 0x3f800000
01487960: mov      dword ptr [rsp + 0x78], 0x3f800000
01487968: call     0x1448600
0148796d: lea      rdx, [r15 + 0xb4988]
01487974: mov      rcx, r13
01487977: call     0x144c530
0148797c: mov      rcx, r13
0148797f: call     0x144c230
01487984: lea      rdi, [r15 + 0xb6708]
0148798b: mov      rcx, rdi
0148798e: call     0x143ea20
01487993: xor      r9d, r9d
01487996: mov      r8, rsi
01487999: mov      rdx, rbx
0148799c: mov      rcx, rdi
0148799f: call     0x14501a0
014879a4: mov      dword ptr [rsp + 0x50], 0x41200000
014879ac: mov      rcx, rdi
014879af: mov      dword ptr [rsp + 0x54], 0x42640000
014879b7: mov      rdx, qword ptr [rsp + 0x50]
014879bc: call     0x14470d0
014879c1: movss    xmm0, dword ptr [rip + 0xf3ef5f] ; RVA 0x23c6928
014879c9: lea      rdx, [rsp + 0x70]
014879ce: unpcklps xmm0, xmm6
014879d1: mov      rcx, rdi
014879d4: mov      dword ptr [rsp + 0x58], 0x3eeeeeef
014879dc: mov      eax, dword ptr [rsp + 0x58]
014879e0: movsd    qword ptr [rsp + 0x70], xmm0
014879e6: mov      dword ptr [rsp + 0x78], eax
014879ea: call     0x1448600
014879ef: mov      dword ptr [rsp + 0x50], 0x3f000000
014879f7: mov      rcx, rdi
014879fa: mov      dword ptr [rsp + 0x54], 0x3f000000
01487a02: mov      rdx, qword ptr [rsp + 0x50]
01487a07: call     0x144f0d0
01487a0c: mov      dword ptr [rsp + 0x50], 0x3f000000
01487a14: mov      rcx, rdi
01487a17: mov      dword ptr [rsp + 0x54], 0x3f000000
01487a1f: mov      rdx, qword ptr [rsp + 0x50]
01487a24: call     0x144f040
01487a29: mov      edx, 0x36
01487a2e: mov      rcx, rdi
01487a31: call     0x1449160
01487a36: mov      rdx, rdi
01487a39: mov      rcx, r13
01487a3c: call     0x144c530
01487a41: mov      rcx, r13
01487a44: call     0x144c230
01487a49: lea      rbx, [r15 + 0xb6860]
01487a50: mov      rcx, rbx
01487a53: call     0x143af10
01487a58: xor      r9d, r9d
01487a5b: mov      byte ptr [rsp + 0x28], 0
01487a60: xor      r8d, r8d
01487a63: movss    dword ptr [rsp + 0x20], xmm8
01487a6a: mov      rcx, rbx
01487a6d: lea      edx, [r9 + 4]
01487a71: call     0x11f79b0
01487a76: mov      ecx, dword ptr [rbx]
01487a78: mov      eax, ecx
01487a7a: and      eax, 0x3c0000
01487a7f: cmp      eax, 0x1c0000
01487a84: je       0x1487aa3
01487a86: and      ecx, 0x3c0000
01487a8c: cmp      ecx, 0x200000
01487a92: jne      0x1487ab0
01487a94: mov      edx, 0x2baa24a7
01487a99: mov      rcx, rbx
01487a9c: call     0x1441690
01487aa1: jmp      0x1487ab0
01487aa3: mov      edx, 0x2baa24a7
01487aa8: mov      rcx, rbx
01487aab: call     0x143bf00
01487ab0: movaps   xmm0, xmm8
01487ab4: mov      dword ptr [rsp + 0x58], 0x3f800000
01487abc: mov      eax, dword ptr [rsp + 0x58]
01487ac0: lea      rdx, [rsp + 0x70]
01487ac5: unpcklps xmm0, xmm8
01487ac9: mov      rcx, rbx
01487acc: movsd    qword ptr [rsp + 0x70], xmm0
01487ad2: mov      dword ptr [rsp + 0x78], eax
01487ad6: call     0x1448600
01487adb: movaps   xmm1, xmm9
01487adf: mov      rcx, rbx
01487ae2: call     0x1448a40
01487ae7: mov      dword ptr [rsp + 0x50], 0x3f000000
01487aef: mov      rcx, rbx
01487af2: mov      dword ptr [rsp + 0x54], 0x3f000000
01487afa: mov      rdx, qword ptr [rsp + 0x50]
01487aff: call     0x144f0d0
01487b04: mov      dword ptr [rsp + 0x50], 0x3f000000
01487b0c: mov      rcx, rbx
01487b0f: mov      dword ptr [rsp + 0x54], 0x3f000000
01487b17: mov      rdx, qword ptr [rsp + 0x50]
01487b1c: call     0x144f040
01487b21: mov      edx, 0x46
01487b26: mov      rcx, rbx
01487b29: call     0x1449160
01487b2e: mov      rdx, rbx
01487b31: mov      rcx, r13
01487b34: call     0x144c530
01487b39: mov      rcx, r13
01487b3c: call     0x144c230
01487b41: mov      qword ptr [rsp + 0x60], 0x3f000000
01487b4a: lea      rcx, [r15 + 0xb8d70]
01487b51: mov      rdx, qword ptr [rsp + 0x60]
01487b56: mov      r9d, 0x33
01487b5c: mov      qword ptr [rsp + 0x50], 0x3f000000
01487b65: mov      r8, qword ptr [rsp + 0x50]
01487b6a: call     0x19cfa70
01487b6f: lea      rdx, [r15 + 0xb8d70]
01487b76: lea      rcx, [r15 + 0x38]
01487b7a: call     0x144c530
01487b7f: lea      rcx, [r15 + 0x38]
01487b83: call     0x144c230
01487b88: mov      r10, qword ptr [rip + 0x1e9ef11] ; RVA 0x3326aa0
01487b8f: lea      r9, [r15 + 0x239c18]
01487b96: xor      r8d, r8d
01487b99: mov      byte ptr [rsp + 0x20], 0
01487b9e: lea      rcx, [r15 + 0xb8d70]
01487ba5: mov      edx, dword ptr [r10 + 0x55f648]
01487bac: mov      dword ptr [r15 + 0x239c14], edx
01487bb3: call     0x19d1040
01487bb8: mov      edx, dword ptr [r15 + 0x239c14]
01487bbf: lea      rcx, [r15 + 0xb8d70]
01487bc6: call     0x19d1d00
01487bcb: mov      rcx, r15
01487bce: call     0x148f810
01487bd3: xor      edx, edx
01487bd5: mov      rcx, r15
01487bd8: call     0x1488c60
01487bdd: movss    xmm1, dword ptr [rip + 0xf40053] ; RVA 0x23c7c38
01487be5: lea      rcx, [r15 + 0xc1938]
01487bec: mov      byte ptr [rsp + 0x38], 1
01487bf1: mov      dword ptr [rsp + 0x50], 0x3f800000
01487bf9: mov      dword ptr [rsp + 0x54], 0x3f800000
01487c01: mov      rax, qword ptr [rsp + 0x50]
01487c06: mov      dword ptr [rsp + 0x60], 0x3f800000
01487c0e: mov      dword ptr [rsp + 0x64], 0x3f800000
01487c16: mov      r9, qword ptr [rsp + 0x60]
01487c1b: mov      dword ptr [rsp + 0x68], 0xc2200000
01487c23: mov      dword ptr [rsp + 0x6c], 0xc32c0000
01487c2b: mov      r8, qword ptr [rsp + 0x68]
01487c30: mov      dword ptr [rsp + 0x28], 0x64
01487c38: mov      qword ptr [rsp + 0x20], rax
01487c3d: call     0x19087a0
01487c42: lea      rdx, [r15 + 0xc1938]
01487c49: lea      rcx, [r15 + 0x38]
01487c4d: call     0x144c530
01487c52: lea      rcx, [r15 + 0x38]
01487c56: call     0x144c230
01487c5b: mov      qword ptr [rsp + 0x50], 0x3f000000
01487c64: mov      qword ptr [rsp + 0x60], 0x3f000000
01487c6d: mov      dword ptr [rsp + 0x68], 0
01487c75: mov      r9, qword ptr [rsp + 0x50]
01487c7a: lea      rcx, [r15 + 0x20f3d0]
01487c81: mov      r8, qword ptr [rsp + 0x60]
01487c86: mov      dword ptr [rsp + 0x6c], 0x43700000
01487c8e: mov      rdx, qword ptr [rsp + 0x68]
01487c93: mov      dword ptr [rsp + 0x20], 0x50
01487c9b: call     0x19ba180
01487ca0: lea      rdi, [r15 + 0x148]
01487ca7: mov      rcx, rdi
01487caa: lea      rdx, [r15 + 0x20f3d0]
01487cb1: call     0x144c530
01487cb6: mov      rcx, rdi
01487cb9: call     0x144c230
01487cbe: mov      dword ptr [rsp + 0x60], 0x3f000000
01487cc6: lea      rcx, [r15 + 0x213520]
01487ccd: mov      dword ptr [rsp + 0x64], 0x3f000000
01487cd5: mov      r8, qword ptr [rsp + 0x60]
01487cda: mov      qword ptr [rsp + 0x68], 0
01487ce3: mov      rdx, qword ptr [rsp + 0x68]
01487ce8: mov      dword ptr [rsp + 0x50], 0x3f000000
01487cf0: mov      dword ptr [rsp + 0x54], 0x3f000000
01487cf8: mov      r9, qword ptr [rsp + 0x50]
01487cfd: call     0x19c9a30
01487d02: lea      rdx, [r15 + 0x213520]
01487d09: mov      rcx, rdi
01487d0c: call     0x144c530
01487d11: mov      rcx, rdi
01487d14: call     0x144c230
01487d19: mov      qword ptr [rsp + 0x60], 0x3f000000
01487d22: lea      rcx, [r15 + 0x214770]
01487d29: mov      r8, qword ptr [rsp + 0x60]
01487d2e: mov      dword ptr [rsp + 0x68], 0
01487d36: mov      dword ptr [rsp + 0x6c], 0x43700000
01487d3e: mov      rdx, qword ptr [rsp + 0x68]
01487d43: mov      qword ptr [rsp + 0x50], 0x3f000000
01487d4c: mov      r9, qword ptr [rsp + 0x50]
01487d51: mov      dword ptr [rsp + 0x20], 0x50
01487d59: call     0x19bb350
01487d5e: lea      rdx, [r15 + 0x214770]
01487d65: mov      rcx, rdi
01487d68: call     0x144c530
01487d6d: mov      rcx, rdi
01487d70: call     0x144c230
01487d75: mov      r10, qword ptr [rip + 0x1e9e58c] ; RVA 0x3326308
01487d7c: lea      rcx, [rip + 0xdd7575] ; RVA 0x225f2f8
01487d83: movss    xmm1, dword ptr [rip + 0xf3f445] ; RVA 0x23c71d0
01487d8b: mov      rax, qword ptr [r10 + 0x10]
01487d8f: mov      rdx, qword ptr [rax + 0xf0]
01487d96: call     rdx
01487d98: lea      rbx, [r15 + 0xb43a0]
01487d9f: mov      rcx, rbx
01487da2: call     0x143ea20
01487da7: movabs   rdx, 0x3c6484761c78b9a0
01487db1: xor      r8d, r8d
01487db4: mov      rcx, rbx
01487db7: call     0x144f770
01487dbc: mov      rcx, rbx
01487dbf: call     0x144f650
01487dc4: test     rax, rax
01487dc7: je       0x1487dd7
01487dc9: movaps   xmm2, xmm9
01487dcd: mov      edx, 0x4c680e90
01487dd2: call     0x1449680
01487dd7: mov      dword ptr [rsp + 0x50], 0x44f00000
01487ddf: mov      rcx, rbx
01487de2: mov      dword ptr [rsp + 0x54], 0x44870000
01487dea: mov      rdx, qword ptr [rsp + 0x50]
01487def: call     0x14470d0
01487df4: mov      dword ptr [rsp + 0x50], 0x3f000000
01487dfc: mov      rcx, rbx
01487dff: mov      dword ptr [rsp + 0x54], 0x3f000000
01487e07: mov      rdx, qword ptr [rsp + 0x50]
01487e0c: call     0x144f0d0
01487e11: mov      dword ptr [rsp + 0x50], 0x3f000000
01487e19: mov      rcx, rbx
01487e1c: mov      dword ptr [rsp + 0x54], 0x3f000000
01487e24: mov      rdx, qword ptr [rsp + 0x50]
01487e29: call     0x144f040
01487e2e: movaps   xmm1, xmm9
01487e32: mov      rcx, rbx
01487e35: call     0x1448a40
01487e3a: lea      rdx, [rsp + 0x70]
01487e3f: mov      dword ptr [rsp + 0x70], 0x3f4ccccd
01487e47: mov      rcx, rbx
01487e4a: mov      dword ptr [rsp + 0x74], 0x3f4ccccd
01487e52: mov      dword ptr [rsp + 0x78], 0x3f4ccccd
01487e5a: call     0x1448600
01487e5f: mov      edx, 0x4f
01487e64: mov      rcx, rbx
01487e67: call     0x1449160
01487e6c: mov      rdx, rbx
01487e6f: lea      rcx, [r15 + 0x38]
01487e73: call     0x144c530
01487e78: lea      rcx, [r15 + 0x38]
01487e7c: call     0x144c230
01487e81: xor      r10d, r10d
01487e84: mov      dword ptr [rsp + 0x60], 0x3f000000
01487e8c: mov      dword ptr [rsp + 0x28], r10d
01487e91: lea      rcx, [r15 + 0x218d50]
01487e98: mov      dword ptr [rsp + 0x64], 0x3f000000
01487ea0: mov      r8, qword ptr [rsp + 0x60]
01487ea5: mov      qword ptr [rsp + 0x68], 0
01487eae: mov      rdx, qword ptr [rsp + 0x68]
01487eb3: mov      dword ptr [rsp + 0x50], 0x3f000000
01487ebb: mov      dword ptr [rsp + 0x54], 0x3f000000
01487ec3: mov      r9, qword ptr [rsp + 0x50]
01487ec8: mov      dword ptr [rsp + 0x20], 0x64
01487ed0: call     0x179eb60
01487ed5: lea      rdx, [r15 + 0x218d50]
01487edc: lea      rcx, [r15 + 0x38]
01487ee0: call     0x144c530
01487ee5: lea      rcx, [r15 + 0x38]
01487ee9: call     0x144c230
01487eee: mov      dword ptr [rsp + 0x60], 0
01487ef6: lea      rcx, [r15 + 0x2257f8]
01487efd: mov      dword ptr [rsp + 0x64], 0x3f800000
01487f05: mov      r8, qword ptr [rsp + 0x60]
01487f0a: mov      dword ptr [rsp + 0x68], 0x42340000
01487f12: mov      dword ptr [rsp + 0x6c], 0xc32c0000
01487f1a: mov      rdx, qword ptr [rsp + 0x68]
01487f1f: mov      dword ptr [rsp + 0x50], 0
01487f27: mov      dword ptr [rsp + 0x54], 0x3f800000
01487f2f: mov      r9, qword ptr [rsp + 0x50]
01487f34: call     0x19a9510
01487f39: lea      rdx, [r15 + 0x2257f8]
01487f40: lea      rcx, [r15 + 0x38]
01487f44: call     0x144c530
01487f49: lea      rcx, [r15 + 0x38]
01487f4d: call     0x144c230
01487f52: lea      rcx, [r15 + 0x227530]
01487f59: lea      r8, [r15 + 0x38]
01487f5d: call     0x188cb90
01487f62: mov      rax, qword ptr gs:[0x58]
01487f6b: mov      ecx, dword ptr [rip + 0x1e9ce17] ; RVA 0x3324d88
01487f71: mov      edx, 0x10
01487f76: mov      rcx, qword ptr [rax + rcx*8]
01487f7a: mov      eax, dword ptr [rdx + rcx]
01487f7d: cmp      dword ptr [rip + 0x234accd], eax ; RVA 0x37d2c50
01487f83: jg       0x1488287
01487f89: movss    xmm0, dword ptr [rip + 0xf3fa0b] ; RVA 0x23c799c
01487f91: lea      rbx, [r15 + 0x230af8]
01487f98: movss    xmm1, dword ptr [rip + 0x1e76e0c] ; RVA 0x32fedac
01487fa0: lea      r8, [rip + 0x234d749] ; RVA 0x37d56f0
01487fa7: movss    xmm3, dword ptr [rip + 0x1e76df5] ; RVA 0x32feda4
01487faf: mov      edx, 5
01487fb4: movss    xmm2, dword ptr [rip + 0x1e76dec] ; RVA 0x32feda8
01487fbc: mov      rcx, rbx
01487fbf: divss    xmm1, xmm0
01487fc3: mov      dword ptr [rip + 0x234d733], 0x41200000 ; RVA 0x37d5700
01487fcd: mov      dword ptr [rip + 0x234d761], 0xb3ed036e ; RVA 0x37d5738
01487fd7: mov      dword ptr [rip + 0x234d75b], 0x19d1a1d5 ; RVA 0x37d573c
01487fe1: mov      dword ptr [rip + 0x234d761], 0x3f800000 ; RVA 0x37d574c
01487feb: mov      dword ptr [rip + 0x234d74b], 0x41200000 ; RVA 0x37d5740
01487ff5: mov      dword ptr [rip + 0x234d749], 0 ; RVA 0x37d5748
01487fff: mov      byte ptr [rip + 0x234d75a], 0 ; RVA 0x37d5760
01488006: divss    xmm3, xmm0
0148800a: divss    xmm2, xmm0
0148800e: movss    xmm0, dword ptr [rip + 0xf3f4fe] ; RVA 0x23c7514
01488016: movss    dword ptr [rip + 0x234d6f2], xmm1 ; RVA 0x37d5710
0148801e: movss    dword ptr [rip + 0x234d6f6], xmm1 ; RVA 0x37d571c
01488026: movss    dword ptr [rip + 0x234d6fa], xmm1 ; RVA 0x37d5728
0148802e: movss    dword ptr [rip + 0x234d6fe], xmm1 ; RVA 0x37d5734
01488036: movss    xmm1, dword ptr [rip + 0xf3f52e] ; RVA 0x23c756c
0148803e: movss    dword ptr [rip + 0x234d6b6], xmm1 ; RVA 0x37d56fc
01488046: movss    xmm1, dword ptr [rip + 0xf3e82a] ; RVA 0x23c6878
0148804e: movss    dword ptr [rip + 0x234d6a2], xmm0 ; RVA 0x37d56f8
01488056: movss    xmm0, dword ptr [rip + 0xf3f622] ; RVA 0x23c7680
0148805e: movss    dword ptr [rip + 0x234d6ea], xmm1 ; RVA 0x37d5750
01488066: movaps   xmm1, xmmword ptr [rip + 0xf418f3] ; RVA 0x23c9960
0148806d: movss    dword ptr [rip + 0x234d68f], xmm0 ; RVA 0x37d5704
01488075: movss    xmm0, dword ptr [rip + 0xf3eb1b] ; RVA 0x23c6b98
0148807d: movups   xmmword ptr [rip + 0x234d6e0], xmm1 ; RVA 0x37d5764
01488084: movss    xmm1, dword ptr [rip + 0xf3e95c] ; RVA 0x23c69e8
0148808c: movss    dword ptr [rip + 0x234d6b0], xmm0 ; RVA 0x37d5744
01488094: movss    xmm0, dword ptr [rip + 0xf3e7f4] ; RVA 0x23c6890
0148809c: movss    dword ptr [rip + 0x234d6dc], xmm1 ; RVA 0x37d5780
014880a4: movaps   xmm1, xmmword ptr [rip + 0xf43765] ; RVA 0x23cb810
014880ab: movss    dword ptr [rip + 0x234d6a9], xmm0 ; RVA 0x37d575c
014880b3: movss    xmm0, dword ptr [rip + 0xf3f51d] ; RVA 0x23c75d8
014880bb: movaps   xmmword ptr [rip + 0x234d6ce], xmm1 ; RVA 0x37d5790
014880c2: movss    dword ptr [rip + 0x234d63e], xmm3 ; RVA 0x37d5708
014880ca: movss    dword ptr [rip + 0x234d63a], xmm2 ; RVA 0x37d570c
014880d2: movss    dword ptr [rip + 0x234d63a], xmm3 ; RVA 0x37d5714
014880da: movss    dword ptr [rip + 0x234d636], xmm2 ; RVA 0x37d5718
014880e2: movss    dword ptr [rip + 0x234d636], xmm3 ; RVA 0x37d5720
014880ea: movss    dword ptr [rip + 0x234d632], xmm2 ; RVA 0x37d5724
014880f2: movss    dword ptr [rip + 0x234d632], xmm3 ; RVA 0x37d572c
014880fa: movss    dword ptr [rip + 0x234d62e], xmm2 ; RVA 0x37d5730
01488102: movss    dword ptr [rip + 0x234d67e], xmm0 ; RVA 0x37d5788
0148810a: call     0x188b2a0
0148810f: mov      dl, 1
01488111: mov      rcx, rbx
01488114: call     0x1450850
01488119: mov      dword ptr [rsp + 0x50], 0x3f000000
01488121: mov      rcx, rbx
01488124: mov      dword ptr [rsp + 0x54], 0x3f800000
0148812c: mov      rdx, qword ptr [rsp + 0x50]
01488131: call     0x144f0d0
01488136: mov      dword ptr [rsp + 0x50], 0x3f000000
0148813e: mov      rcx, rbx
01488141: mov      dword ptr [rsp + 0x54], 0x3f800000
01488149: mov      rdx, qword ptr [rsp + 0x50]
0148814e: call     0x144f040
01488153: movss    xmm1, dword ptr [rip + 0xf40159] ; RVA 0x23c82b4
0148815b: mov      rcx, rbx
0148815e: movss    dword ptr [rsp + 0x54], xmm1
01488164: mov      dword ptr [rsp + 0x50], 0
0148816c: mov      rdx, qword ptr [rsp + 0x50]
01488171: call     0x1447610
01488176: mov      rdx, rbx
01488179: lea      rcx, [r15 + 0x38]
0148817d: call     0x144c530
01488182: lea      rcx, [r15 + 0x38]
01488186: call     0x144c230
0148818b: movss    xmm0, dword ptr [rip + 0xf3f85d] ; RVA 0x23c79f0
01488193: movss    dword ptr [rsp + 0x68], xmm0
01488199: mov      dword ptr [rsp + 0x50], 0x3f000000
014881a1: mov      dword ptr [rsp + 0x54], 0x3f800000
014881a9: mov      dword ptr [rsp + 0x60], 0x3f000000
014881b1: mov      dword ptr [rsp + 0x64], 0x3f800000
014881b9: movss    xmm1, dword ptr [rip + 0xf3f56f] ; RVA 0x23c7730
014881c1: lea      rcx, [r15 + 0x239428]
014881c8: movss    xmm0, dword ptr [rip + 0xf3fff4] ; RVA 0x23c81c4
014881d0: mov      rax, qword ptr [rsp + 0x50]
014881d5: mov      r9, qword ptr [rsp + 0x60]
014881da: movss    dword ptr [rsp + 0x6c], xmm1
014881e0: mov      r8, qword ptr [rsp + 0x68]
014881e5: movss    dword ptr [rsp + 0x74], xmm0
014881eb: mov      dword ptr [rsp + 0x70], 0
014881f3: mov      rdx, qword ptr [rsp + 0x70]
014881f8: mov      qword ptr [rsp + 0x20], rax
014881fd: call     0x19a9e40
01488202: lea      rcx, [r15 + 0x239538]
01488209: mov      edx, 0x30e6532b
0148820e: call     0x143bf00
01488213: lea      rdx, [r15 + 0x239428]
0148821a: lea      rcx, [r15 + 0x38]
0148821e: call     0x144c530
01488223: lea      rcx, [r15 + 0x38]
01488227: call     0x144c230
0148822c: xor      edx, edx
0148822e: lea      rcx, [r15 + 0x239428]
01488235: call     0x1450850
0148823a: movaps   xmm1, xmm9
0148823e: mov      rcx, r15
01488241: call     0x14831e0
01488246: mov      rcx, qword ptr [rbp - 0x40]
0148824a: xor      rcx, rsp
0148824d: call     0x20886a0
01488252: lea      r11, [rsp + 0x110]
0148825a: mov      rbx, qword ptr [r11 + 0x38]
0148825e: mov      rsi, qword ptr [r11 + 0x40]
01488262: mov      rdi, qword ptr [r11 + 0x48]
01488266: movaps   xmm6, xmmword ptr [r11 - 0x10]
0148826b: movaps   xmm7, xmmword ptr [r11 - 0x20]
01488270: movaps   xmm8, xmmword ptr [r11 - 0x30]
01488275: movaps   xmm9, xmmword ptr [r11 - 0x40]
0148827a: mov      rsp, r11
0148827d: pop      r15
0148827f: pop      r14
01488281: pop      r13
01488283: pop      r12
01488285: pop      rbp
01488286: ret      
01488287: lea      rcx, [rip + 0x234a9c2] ; RVA 0x37d2c50
0148828e: call     0x2088904
01488293: cmp      dword ptr [rip + 0x234a9b6], -1 ; RVA 0x37d2c50
0148829a: jne      0x1487f89
014882a0: lea      rcx, [rip + 0x234d449] ; RVA 0x37d56f0
014882a7: call     0x148fad0
014882ac: lea      rcx, [rip + 0x234a99d] ; RVA 0x37d2c50
014882b3: call     0x20888a4
014882b8: jmp      0x1487f89