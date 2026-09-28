RANGE 0x143ece4-0x143ed9f
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