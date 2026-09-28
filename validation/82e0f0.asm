RANGE 0x82e0f0-0x82e169
0082e0f0: mov      qword ptr [rsp + 0x18], rbx
0082e0f5: mov      qword ptr [rsp + 0x20], rsi
0082e0fa: push     rdi
0082e0fb: sub      rsp, 0x40
0082e0ff: mov      rax, qword ptr [rip + 0x1e0df0a] ; RVA 0x263c010
0082e106: xor      rax, rsp
0082e109: mov      qword ptr [rsp + 0x38], rax
0082e10e: cmp      edx, -1
0082e111: je       0x82e279
0082e117: mov      eax, edx
0082e119: mov      rsi, qword ptr [rcx + rax*8 + 0x110]
0082e121: test     rsi, rsi
0082e124: je       0x82e279
0082e12a: mov      rcx, qword ptr [rip + 0x2af8557] ; RVA 0x3326688
0082e131: mov      edx, dword ptr [rsi + 8]
0082e134: call     0x927050
0082e139: test     al, al
0082e13b: jne      0x82e279
0082e141: mov      r10, qword ptr [rip + 0x2af8550] ; RVA 0x3326698
0082e148: xor      ebx, ebx
0082e14a: cmp      edx, dword ptr [rip + 0x2c55ad0] ; RVA 0x3483c20
0082e150: mov      eax, edx
0082e152: jne      0x82e15b
0082e154: mov      eax, 0xffffffff
0082e159: jmp      0x82e1c4
0082e15b: mov      r9d, dword ptr [r10 + 0x20]
0082e15f: mov      edx, ebx
0082e161: mov      r11d, dword ptr [r10 + 0x28]
0082e165: imul     r11d, eax
RANGE 0x82e169-0x82e1c4
0082e169: mov      qword ptr [rsp + 0x50], rbp
0082e16e: mov      qword ptr [rsp + 0x58], r14
0082e173: lea      r14d, [r9 - 1]
0082e177: test     r9d, r9d
0082e17a: je       0x82e1b5
0082e17c: mov      rdi, qword ptr [r10 + 0x18]
0082e180: mov      ebp, dword ptr [r10 + 0x24]
0082e184: nop      dword ptr [rax]
0082e188: nop      dword ptr [rax + rax]
0082e190: mov      ecx, r14d
0082e193: lea      r8d, [rdx + r11]
0082e197: and      r8, rcx
0082e19a: mov      ecx, dword ptr [rdi + r8*8]
0082e19e: cmp      ecx, ebp
0082e1a0: je       0x82e22f
0082e1a6: cmp      ecx, eax
0082e1a8: je       0x82e233
0082e1ae: inc      edx
0082e1b0: cmp      edx, r9d
0082e1b3: jb       0x82e190
0082e1b5: mov      eax, 0xffffffff
0082e1ba: mov      rbp, qword ptr [rsp + 0x50]
0082e1bf: mov      r14, qword ptr [rsp + 0x58]
RANGE 0x82e1c4-0x82e22f
0082e1c4: mov      ecx, eax
0082e1c6: mov      rax, qword ptr [r10 + 0x38]
0082e1ca: imul     rdx, rcx, 0xac
0082e1d1: lea      rcx, [rsp + 0x20]
0082e1d6: mov      edx, dword ptr [rdx + rax]
0082e1d9: call     0xfd9980
0082e1de: mov      edx, dword ptr [rsp + 0x20]
0082e1e2: cmp      edx, dword ptr [rip + 0x2c55a4c] ; RVA 0x3483c34
0082e1e8: je       0x82e246
0082e1ea: mov      rax, qword ptr [rip + 0x2af8b67] ; RVA 0x3326d58
0082e1f1: mov      r8d, dword ptr [rax + 0x48]
0082e1f5: mov      r10d, dword ptr [rax + 0x50]
0082e1f9: imul     r10d, edx
0082e1fd: lea      edi, [r8 - 1]
0082e201: test     r8d, r8d
0082e204: je       0x82e246
0082e206: mov      r9, qword ptr [rax + 0x40]
0082e20a: mov      r11d, dword ptr [rax + 0x4c]
0082e20e: nop      
0082e210: mov      eax, edi
0082e212: lea      ecx, [rbx + r10]
0082e216: and      rcx, rax
0082e219: mov      eax, dword ptr [r9 + rcx*8]
0082e21d: cmp      eax, r11d
0082e220: je       0x82e23a
0082e222: cmp      eax, edx
0082e224: je       0x82e23e
0082e226: inc      ebx
0082e228: cmp      ebx, r8d
0082e22b: jb       0x82e210
0082e22d: jmp      0x82e246
RANGE 0x82e22f-0x82e23a
0082e22f: cmp      ecx, eax
0082e231: jne      0x82e1b5
0082e233: mov      eax, dword ptr [rdi + r8*8 + 4]
0082e238: jmp      0x82e1ba
RANGE 0x82e23a-0x82e298
0082e23a: cmp      eax, edx
0082e23c: jne      0x82e246
0082e23e: cmp      dword ptr [r9 + rcx*8 + 4], -1
0082e244: jne      0x82e275
0082e246: mov      rax, qword ptr [rip + 0x2af80bb] ; RVA 0x3326308
0082e24d: xor      edx, edx
0082e24f: mov      rcx, qword ptr [rax + 0x18]
0082e253: mov      rax, qword ptr [rcx + 0x88]
0082e25a: mov      ecx, dword ptr [rsi + 0xc]
0082e25d: call     rax
0082e25f: mov      eax, dword ptr [rax + 8]
0082e262: mov      dword ptr [rsp + 0x30], eax
0082e266: movss    xmm0, dword ptr [rsp + 0x30]
0082e26c: comiss   xmm0, dword ptr [rip + 0x1b99a59] ; RVA 0x23c7ccc
0082e273: jbe      0x82e279
0082e275: mov      al, 1
0082e277: jmp      0x82e27b
0082e279: xor      al, al
0082e27b: mov      rcx, qword ptr [rsp + 0x38]
0082e280: xor      rcx, rsp
0082e283: call     0x20886a0
0082e288: mov      rbx, qword ptr [rsp + 0x60]
0082e28d: mov      rsi, qword ptr [rsp + 0x68]
0082e292: add      rsp, 0x40
0082e296: pop      rdi
0082e297: ret      