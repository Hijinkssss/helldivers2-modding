RANGE 0x776010-0x7760ba
00776010: mov      qword ptr [rsp + 0x18], rbx
00776015: push     rbp
00776016: push     rsi
00776017: push     rdi
00776018: push     r14
0077601a: push     r15
0077601c: sub      rsp, 0x20
00776020: mov      ebx, dword ptr [rip + 0x2d0dc0e] ; RVA 0x3483c34
00776026: mov      r15, rcx
00776029: cmp      edx, ebx
0077602b: je       0x776071
0077602d: mov      r9d, dword ptr [rcx + 0x28]
00776031: xor      esi, esi
00776033: mov      r11d, dword ptr [rcx + 0x30]
00776037: mov      r8d, esi
0077603a: imul     r11d, edx
0077603e: lea      r14d, [r9 - 1]
00776042: test     r9d, r9d
00776045: je       0x776071
00776047: mov      rdi, qword ptr [rcx + 0x20]
0077604b: mov      ebp, dword ptr [rcx + 0x2c]
0077604e: nop      
00776050: mov      eax, r14d
00776053: lea      ecx, [r8 + r11]
00776057: and      rcx, rax
0077605a: mov      eax, dword ptr [rdi + rcx*8]
0077605d: lea      r10, [rdi + rcx*8]
00776061: cmp      eax, ebp
00776063: je       0x776084
00776065: cmp      eax, edx
00776067: je       0x776088
00776069: inc      r8d
0077606c: cmp      r8d, r9d
0077606f: jb       0x776050
00776071: xor      al, al
00776073: mov      rbx, qword ptr [rsp + 0x60]
00776078: add      rsp, 0x20
0077607c: pop      r15
0077607e: pop      r14
00776080: pop      rdi
00776081: pop      rsi
00776082: pop      rbp
00776083: ret      
00776084: cmp      eax, edx
00776086: jne      0x776071
00776088: mov      r14d, dword ptr [r10 + 4]
0077608c: cmp      r14d, -1
00776090: je       0x776071
00776092: mov      edi, dword ptr [rip + 0x2d0db88] ; RVA 0x3483c20
00776098: mov      r11, qword ptr [rip + 0x2bb0691] ; RVA 0x3326730
0077609f: cmp      edx, edi
007760a1: je       0x776119
007760a3: mov      r9d, dword ptr [r11 + 0x20]
007760a7: mov      r8d, esi
007760aa: mov      ebp, dword ptr [r11 + 0x28]
007760ae: imul     ebp, edx
007760b1: lea      r10d, [r9 - 1]
007760b5: test     r9d, r9d
007760b8: je       0x776119
RANGE 0x7760ba-0x776119
007760ba: mov      qword ptr [rsp + 0x50], r12
007760bf: mov      r12, qword ptr [r11 + 0x18]
007760c3: mov      qword ptr [rsp + 0x58], r13
007760c8: mov      r13d, dword ptr [r11 + 0x24]
007760cc: nop      dword ptr [rax]
007760d0: mov      eax, r10d
007760d3: lea      ecx, [r8 + rbp]
007760d7: and      rcx, rax
007760da: mov      eax, dword ptr [r12 + rcx*8]
007760de: lea      r10, [r12 + rcx*8]
007760e2: cmp      eax, r13d
007760e5: je       0x7760f9
007760e7: cmp      eax, edx
007760e9: je       0x7760fd
007760eb: inc      r8d
007760ee: lea      r10d, [r9 - 1]
007760f2: cmp      r8d, r9d
007760f5: jb       0x7760d0
007760f7: jmp      0x77610f
007760f9: cmp      eax, edx
007760fb: jne      0x77610f
007760fd: mov      eax, dword ptr [r10 + 4]
00776101: cmp      eax, -1
00776104: je       0x77610f
00776106: mov      ecx, eax
00776108: mov      rax, qword ptr [r11 + 0x38]
0077610c: mov      ebx, dword ptr [rax + rcx*4]
0077610f: mov      r12, qword ptr [rsp + 0x50]
00776114: mov      r13, qword ptr [rsp + 0x58]
RANGE 0x776119-0x7761c5
00776119: mov      rcx, qword ptr [r15 + 0x38]
0077611d: mov      rcx, qword ptr [rcx + r14*8]
00776121: call     0x4fd220
00776126: mov      rbp, rax
00776129: cmp      ebx, edi
0077612b: je       0x776071
00776131: mov      rcx, qword ptr [rip + 0x2bb0508] ; RVA 0x3326640
00776138: mov      r8d, dword ptr [rcx + 0x20]
0077613c: mov      r9d, dword ptr [rcx + 0x28]
00776140: imul     r9d, ebx
00776144: lea      edi, [r8 - 1]
00776148: test     r8d, r8d
0077614b: je       0x776071
00776151: mov      r10, qword ptr [rcx + 0x18]
00776155: mov      r11d, dword ptr [rcx + 0x24]
00776159: nop      dword ptr [rax]
00776160: mov      eax, edi
00776162: lea      ecx, [rsi + r9]
00776166: and      rcx, rax
00776169: mov      eax, dword ptr [r10 + rcx*8]
0077616d: lea      rdx, [r10 + rcx*8]
00776171: cmp      eax, r11d
00776174: je       0x776186
00776176: cmp      eax, ebx
00776178: je       0x77618e
0077617a: inc      esi
0077617c: cmp      esi, r8d
0077617f: jb       0x776160
00776181: jmp      0x776071
00776186: cmp      eax, ebx
00776188: jne      0x776071
0077618e: cmp      dword ptr [rdx + 4], -1
00776192: je       0x776071
00776198: mov      edi, dword ptr [rbp + 4]
0077619b: test     edi, edi
0077619d: je       0x776071
007761a3: mov      edx, ebx
007761a5: call     0x7cbe60
007761aa: cmp      eax, edi
007761ac: jne      0x776071
007761b2: mov      rbx, qword ptr [rsp + 0x60]
007761b7: mov      al, 1
007761b9: add      rsp, 0x20
007761bd: pop      r15
007761bf: pop      r14
007761c1: pop      rdi
007761c2: pop      rsi
007761c3: pop      rbp
007761c4: ret      