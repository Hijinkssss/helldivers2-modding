RANGE 0x14467b0-0x14469f5
014467b0: mov      qword ptr [rsp + 0x10], rbx
014467b5: push     rdi
014467b6: sub      rsp, 0x20
014467ba: movaps   xmm0, xmmword ptr [rip + 0xf83e1f] ; RVA 0x23ca5e0
014467c1: xor      edi, edi
014467c3: mov      r8, qword ptr [rip + 0x20366c6] ; RVA 0x347ce90
014467ca: mov      rbx, rcx
014467cd: movups   xmmword ptr [rcx + 0x44], xmm0
014467d1: mov      dword ptr [rcx + 0xa4], edi
014467d7: movaps   xmm0, xmmword ptr [rip + 0xf83c92] ; RVA 0x23ca470
014467de: movups   xmmword ptr [rcx + 0xd0], xmm0
014467e5: mov      dword ptr [rsp + 0x30], 0x3f800000
014467ed: movaps   xmm0, xmmword ptr [rip + 0xf83dec] ; RVA 0x23ca5e0
014467f4: mov      dword ptr [rsp + 0x34], 0x3f800000
014467fc: mov      rax, qword ptr [rsp + 0x30]
01446801: mov      qword ptr [rcx + 0xc], rax
01446805: mov      qword ptr [rsp + 0x30], 0
0144680e: mov      rax, qword ptr [rsp + 0x30]
01446813: mov      qword ptr [rcx + 4], rax
01446817: mov      qword ptr [rsp + 0x30], 0
01446820: mov      rax, qword ptr [rsp + 0x30]
01446825: mov      qword ptr [rcx + 0x2c], rax
01446829: mov      dword ptr [rsp + 0x30], 0x3f800000
01446831: mov      dword ptr [rsp + 0x34], 0x3f800000
01446839: mov      rax, qword ptr [rsp + 0x30]
0144683e: mov      qword ptr [rcx + 0x14], rax
01446842: mov      qword ptr [rsp + 0x30], 0
0144684b: mov      rax, qword ptr [rsp + 0x30]
01446850: mov      qword ptr [rcx + 0x3c], rax
01446854: mov      dword ptr [rsp + 0x30], 0x3f000000
0144685c: mov      dword ptr [rsp + 0x34], 0x3f000000
01446864: mov      rax, qword ptr [rsp + 0x30]
01446869: mov      qword ptr [rcx + 0x34], rax
0144686d: mov      dword ptr [rsp + 0x30], 0x3f800000
01446875: mov      dword ptr [rsp + 0x34], 0x3f800000
0144687d: mov      rax, qword ptr [rsp + 0x30]
01446882: mov      qword ptr [rcx + 0x1c], rax
01446886: mov      eax, edi
01446888: mov      qword ptr [rcx + 0xc0], rax
0144688f: mov      qword ptr [rcx + 0xc8], rax
01446896: shl      edx, 0x12
01446899: mov      dword ptr [rcx], edx
0144689b: mov      qword ptr [rcx + 0xa8], rdi
014468a2: mov      qword ptr [rcx + 0xb0], rdi
014468a9: mov      qword ptr [rsp + 0x30], rdi
014468ae: mov      qword ptr [rsp + 0x30], rdi
014468b3: mov      dword ptr [rsp + 0x30], 0x3f800000
014468bb: mov      dword ptr [rsp + 0x34], 0x3f800000
014468c3: mov      rax, qword ptr [rsp + 0x30]
014468c8: movups   xmmword ptr [rcx + 0x54], xmm0
014468cc: mov      qword ptr [rcx + 0x24], rax
014468d0: mov      qword ptr [rcx + 0xe0], rdi
014468d7: mov      qword ptr [rcx + 0xe8], rdi
014468de: mov      qword ptr [rcx + 0xf0], rdi
014468e5: movsxd   rax, dword ptr [r8 + 0x2c5bc]
014468ec: test     eax, eax
014468ee: jns      0x14468f4
014468f0: xor      al, al
014468f2: jmp      0x14468fd
014468f4: movzx    eax, byte ptr [rax + r8 + 0x2c5b8]
014468fd: mov      qword ptr [rbx + 0x100], rdi
01446904: and      edx, 0x3c0000
0144690a: mov      qword ptr [rbx + 0x108], rdi
01446911: movzx    eax, al
01446914: imul     rcx, rax, 0x3698
0144691b: add      rcx, r8
0144691e: mov      qword ptr [rbx + 0xf8], rcx
01446925: mov      rcx, rbx
01446928: movaps   xmm0, xmmword ptr [rip + 0x11f6321] ; RVA 0x263cc50
0144692f: movups   xmmword ptr [rbx + 0x64], xmm0
01446933: movaps   xmm1, xmmword ptr [rip + 0x11f6326] ; RVA 0x263cc60
0144693a: movups   xmmword ptr [rbx + 0x74], xmm1
0144693e: movaps   xmm0, xmmword ptr [rip + 0x11f632b] ; RVA 0x263cc70
01446945: movups   xmmword ptr [rbx + 0x84], xmm0
0144694c: movaps   xmm1, xmmword ptr [rip + 0x11f632d] ; RVA 0x263cc80
01446953: movups   xmmword ptr [rbx + 0x94], xmm1
0144695a: cmp      edx, 0x300000
01446960: je       0x1446971
01446962: mov      rdx, rdi
01446965: mov      qword ptr [rsp + 0x30], rdi
0144696a: call     0x144a350
0144696f: jmp      0x1446976
01446971: call     0x1445560
01446976: cmp      word ptr [rbx + 0xbc], di
0144697d: je       0x14469dd
0144697f: mov      edx, dword ptr [rbx + 0xb8]
01446985: mov      eax, edx
01446987: bts      eax, 0xc
0144698b: mov      word ptr [rbx + 0xbc], di
01446992: mov      dword ptr [rbx + 0xb8], eax
01446998: cmp      eax, edx
0144699a: je       0x14469dd
0144699c: not      edx
0144699e: and      edx, eax
014469a0: and      edx, 0xffff2fff
014469a6: je       0x14469bc
014469a8: mov      rcx, qword ptr [rbx + 0xe0]
014469af: test     rcx, rcx
014469b2: je       0x14469bc
014469b4: mov      r8b, 1
014469b7: call     0x144c370
014469bc: mov      ecx, dword ptr [rbx]
014469be: mov      eax, ecx
014469c0: shr      eax, 2
014469c3: test     al, 1
014469c5: jne      0x14469dd
014469c7: or       ecx, 4
014469ca: mov      dword ptr [rbx], ecx
014469cc: mov      rcx, qword ptr [rbx + 0xf0]
014469d3: test     rcx, rcx
014469d6: je       0x14469dd
014469d8: call     0x144d170
014469dd: or       dword ptr [rbx], 0x11
014469e0: mov      dword ptr [rbx + 0xb8], 0x77ff
014469ea: mov      rbx, qword ptr [rsp + 0x38]
014469ef: add      rsp, 0x20
014469f3: pop      rdi
014469f4: ret      