RANGE 0x1377810-0x137783b
01377810: sub      rsp, 0x28
01377814: mov      r10, r8
01377817: test     edx, edx
01377819: je       0x1377953
0137781f: sub      edx, 1
01377822: je       0x1377917
01377828: cmp      edx, 1
0137782b: jne      0x1377967
01377831: mov      rax, qword ptr [rip + 0x1faead0] ; RVA 0x3326308
01377838: mov      edx, r9d
RANGE 0x137783b-0x13778d0
0137783b: mov      qword ptr [rsp + 0x30], rbx
01377840: mov      qword ptr [rsp + 0x20], rdi
01377845: mov      rdi, qword ptr [rip + 0x21056cc] ; RVA 0x347cf18
0137784c: mov      rcx, qword ptr [rax + 0x128]
01377853: mov      rax, qword ptr [rcx + 0x10]
01377857: mov      rcx, r8
0137785a: call     rax
0137785c: mov      rbx, rax
0137785f: test     rax, rax
01377862: je       0x13778b4
01377864: mov      rcx, qword ptr [rip + 0x21056ad] ; RVA 0x347cf18
0137786b: mov      r8b, 1
0137786e: add      rcx, 0xa7ac8
01377875: mov      rdx, rax
01377878: call     0xaf26d0
0137787d: mov      rcx, qword ptr [rip + 0x2105694] ; RVA 0x347cf18
01377884: call     0x12f8440
01377889: movzx    ecx, byte ptr [rdi + 0xa7b02]
01377890: mov      rdx, qword ptr [rip + 0x2105681] ; RVA 0x347cf18
01377897: mov      byte ptr [rdx + 0xe1ad6], cl
0137789d: mov      rcx, qword ptr [rip + 0x1faea64] ; RVA 0x3326308
013778a4: mov      rax, qword ptr [rcx + 0x128]
013778ab: mov      rcx, rbx
013778ae: call     qword ptr [rax + 0x160]
013778b4: mov      rax, qword ptr [rip + 0x1faea5d] ; RVA 0x3326318
013778bb: call     qword ptr [rax + 0x10]
013778be: mov      rdi, qword ptr [rsp + 0x20]
013778c3: mov      rbx, qword ptr [rsp + 0x30]
013778c8: test     al, al
013778ca: je       0x1377967
RANGE 0x13778d0-0x137796c
013778d0: mov      rax, qword ptr [rip + 0x1faea41] ; RVA 0x3326318
013778d7: xorps    xmm1, xmm1
013778da: mov      rdx, qword ptr [rax + 0xa0]
013778e1: mov      rax, qword ptr [rip + 0x2105630] ; RVA 0x347cf18
013778e8: movss    xmm0, dword ptr [rax + 0xa7b68]
013778f0: comiss   xmm1, xmm0
013778f3: ja       0x1377901
013778f5: movss    xmm1, dword ptr [rip + 0x104f463] ; RVA 0x23c6d60
013778fd: minss    xmm1, xmm0
01377901: mulss    xmm1, dword ptr [rip + 0x104fed7] ; RVA 0x23c77e0
01377909: lea      rcx, [rip + 0xeee288] ; RVA 0x2265b98
01377910: add      rsp, 0x28
01377914: jmp      rdx
01377917: mov      rcx, qword ptr [rip + 0x1faea22] ; RVA 0x3326340
0137791e: mov      r8d, r9d
01377921: add      rcx, 0xac3dc
01377928: mov      rdx, r10
0137792b: call     0x1030260
01377930: mov      r8, qword ptr [rip + 0x1faea09] ; RVA 0x3326340
01377937: lea      rcx, [r8 + 0xac3dc]
0137793e: call     0x1030ee0
01377943: lea      rcx, [r8 + 0xac3dc]
0137794a: add      rsp, 0x28
0137794e: jmp      0x102f390
01377953: mov      dword ptr [rcx + 0x38], r9d
01377957: mov      rdx, r10
0137795a: add      rcx, 0x30
0137795e: add      rsp, 0x28
01377962: jmp      0xabf250
01377967: add      rsp, 0x28
0137796b: ret      