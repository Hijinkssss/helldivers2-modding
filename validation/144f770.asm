RANGE 0x144f770-0x144f8b8
0144f770: mov      qword ptr [rsp + 8], rbx
0144f775: push     rdi
0144f776: sub      rsp, 0x20
0144f77a: movzx    edi, r8b
0144f77e: mov      rbx, rcx
0144f781: test     rdx, rdx
0144f784: jne      0x144f795
0144f786: mov      rbx, qword ptr [rsp + 0x30]
0144f78b: add      rsp, 0x20
0144f78f: pop      rdi
0144f790: jmp      0x1446a00
0144f795: mov      eax, dword ptr [rcx]
0144f797: shr      eax, 0x12
0144f79a: and      eax, 0xf
0144f79d: add      eax, -3
0144f7a0: cmp      eax, 0xa
0144f7a3: ja       0x144f881
0144f7a9: lea      r8, [rip - 0x144f7b0] ; RVA 0x0
0144f7b0: mov      ecx, dword ptr [r8 + rax*4 + 0x144f88c]
0144f7b8: add      rcx, r8
0144f7bb: jmp      rcx
0144f7bd: movzx    r8d, dil
0144f7c1: mov      rcx, rbx
0144f7c4: mov      rbx, qword ptr [rsp + 0x30]
0144f7c9: add      rsp, 0x20
0144f7cd: pop      rdi
0144f7ce: jmp      0x143f180
0144f7d3: mov      rcx, qword ptr [rbx + 0xf8]
0144f7da: call     0x12ee1e0
0144f7df: movzx    r8d, dil
0144f7e3: mov      rdx, rax
0144f7e6: mov      rcx, rbx
0144f7e9: mov      rbx, qword ptr [rsp + 0x30]
0144f7ee: add      rsp, 0x20
0144f7f2: pop      rdi
0144f7f3: jmp      0x14453a0
0144f7f8: movzx    r8d, dil
0144f7fc: mov      rcx, rbx
0144f7ff: mov      rbx, qword ptr [rsp + 0x30]
0144f804: add      rsp, 0x20
0144f808: pop      rdi
0144f809: jmp      0x143c250
0144f80e: movzx    r8d, dil
0144f812: mov      rcx, rbx
0144f815: mov      rbx, qword ptr [rsp + 0x30]
0144f81a: add      rsp, 0x20
0144f81e: pop      rdi
0144f81f: jmp      0x143e720
0144f824: movzx    r8d, dil
0144f828: mov      rcx, rbx
0144f82b: mov      rbx, qword ptr [rsp + 0x30]
0144f830: add      rsp, 0x20
0144f834: pop      rdi
0144f835: jmp      0x14419d0
0144f83a: movzx    r8d, dil
0144f83e: mov      rcx, rbx
0144f841: mov      rbx, qword ptr [rsp + 0x30]
0144f846: add      rsp, 0x20
0144f84a: pop      rdi
0144f84b: jmp      0x1443c70
0144f850: movzx    r8d, dil
0144f854: mov      rcx, rbx
0144f857: mov      rbx, qword ptr [rsp + 0x30]
0144f85c: add      rsp, 0x20
0144f860: pop      rdi
0144f861: jmp      0x143fb10
0144f866: mov      rcx, qword ptr [rbx + 0xf8]
0144f86d: call     0x12ee1e0
0144f872: movzx    r8d, dil
0144f876: mov      rdx, rax
0144f879: mov      rcx, rbx
0144f87c: call     0x14466c0
0144f881: mov      rbx, qword ptr [rsp + 0x30]
0144f886: add      rsp, 0x20
0144f88a: pop      rdi
0144f88b: ret      
0144f88c: mov      ebp, 0xd30144f7
0144f891: test     dword ptr [rcx + rax - 0x7f], 0x810144f8
0144f899: clc      
0144f89a: add      eax, r15d
0144f89d: test     dword ptr [rcx + rax + 0x24], 0xe0144f8
0144f8a5: clc      
0144f8a6: add      dword ptr [rdx], r15d
0144f8a9: clc      
0144f8aa: add      dword ptr [rax - 8], r10d
0144f8ae: add      dword ptr [rcx + 0x660144f8], r8d
0144f8b5: clc      