RANGE 0x12f53a0-0x12f53c7
012f53a0: mov      qword ptr [rsp + 8], rcx
012f53a5: push     rbx
012f53a6: push     rbp
012f53a7: push     rsi
012f53a8: push     rdi
012f53a9: push     r14
012f53ab: sub      rsp, 0x50
012f53af: mov      rbp, qword ptr [rip + 0x2178182] ; RVA 0x346d538
012f53b6: mov      edi, r8d
012f53b9: movaps   xmmword ptr [rsp + 0x40], xmm6
012f53be: movaps   xmm6, xmm1
012f53c1: movaps   xmmword ptr [rsp + 0x20], xmm8
RANGE 0x12f53c7-0x12f550b
012f53c7: movaps   xmmword ptr [rsp + 0x30], xmm7
012f53cc: movss    xmm7, dword ptr [rip + 0x10d198c] ; RVA 0x23c6d60
012f53d4: lea      rbx, [rbp + 0x375d8]
012f53db: mov      rcx, rbx
012f53de: movaps   xmm1, xmm7
012f53e1: call     0x1448a40
012f53e6: lea      rcx, [rbp + 0xc60]
012f53ed: call     0x1448a40
012f53f2: lea      rcx, [rbp + 0x6f8]
012f53f9: movaps   xmm1, xmm6
012f53fc: call     0x144d750
012f5401: test     byte ptr [rbp + 0x6f8], 0xa
012f5408: je       0x12f5416
012f540a: lea      rcx, [rbp + 0x6f8]
012f5411: call     0x144de90
012f5416: mov      rax, qword ptr [rip + 0x20311d3] ; RVA 0x33265f0
012f541d: xorps    xmm8, xmm8
012f5421: cmp      dword ptr [rax + 0x20], 0
012f5425: jbe      0x12f5466
012f5427: mov      eax, dword ptr [rax + 0x12edc]
012f542d: test     eax, eax
012f542f: je       0x12f5466
012f5431: lea      rcx, [rbx + 0x228]
012f5438: cmp      eax, 0xd
012f543b: je       0x12f548a
012f543d: cmp      eax, 0xf
012f5440: je       0x12f5454
012f5442: mov      edx, 0x2719ed00
012f5447: call     0x143bf00
012f544c: movaps   xmm1, xmm7
012f544f: jmp      0x12f54ed
012f5454: mov      edx, 0x73ccb177
012f5459: call     0x143bf00
012f545e: movaps   xmm1, xmm7
012f5461: jmp      0x12f54ed
012f5466: mov      eax, dword ptr [rbx + 0x4e4]
012f546c: test     eax, eax
012f546e: je       0x12f54ea
012f5470: movss    xmm0, dword ptr [rbx + 0x4e0]
012f5478: comiss   xmm0, xmm8
012f547c: jbe      0x12f54ea
012f547e: cmp      eax, 4
012f5481: jne      0x12f5499
012f5483: lea      rcx, [rbx + 0x228]
012f548a: mov      edx, 0xc9dc2a0f
012f548f: call     0x143bf00
012f5494: movaps   xmm1, xmm7
012f5497: jmp      0x12f54ed
012f5499: cmp      eax, 3
012f549c: jne      0x12f54b4
012f549e: lea      rcx, [rbx + 0x228]
012f54a5: mov      edx, 0x925356cd
012f54aa: call     0x143bf00
012f54af: movaps   xmm1, xmm7
012f54b2: jmp      0x12f54ed
012f54b4: cmp      eax, 1
012f54b7: jne      0x12f54cf
012f54b9: lea      rcx, [rbx + 0x228]
012f54c0: mov      edx, 0xa3490656
012f54c5: call     0x143bf00
012f54ca: movaps   xmm1, xmm7
012f54cd: jmp      0x12f54ed
012f54cf: cmp      eax, 7
012f54d2: jne      0x12f54f5
012f54d4: lea      rcx, [rbx + 0x228]
012f54db: mov      edx, 0x9603aa40
012f54e0: call     0x143bf00
012f54e5: movaps   xmm1, xmm7
012f54e8: jmp      0x12f54ed
012f54ea: xorps    xmm1, xmm1
012f54ed: mov      rcx, rbx
012f54f0: call     0x1448a40
012f54f5: movss    xmm0, dword ptr [rbx + 0x4e0]
012f54fd: xor      r14d, r14d
012f5500: comiss   xmm0, xmm8
012f5504: movaps   xmm7, xmmword ptr [rsp + 0x30]
012f5509: jbe      0x12f553e
RANGE 0x12f550b-0x12f556f
012f550b: mov      rax, qword ptr [rip + 0x217801e] ; RVA 0x346d530
012f5512: cmp      dword ptr [rax + 0x190c], r14d
012f5519: jne      0x12f553e
012f551b: subss    xmm0, xmm6
012f551f: comiss   xmm8, xmm0
012f5523: movss    dword ptr [rbx + 0x4e0], xmm0
012f552b: jb       0x12f553e
012f552d: mov      edx, 0xf5e89d3a
012f5532: mov      dword ptr [rbx + 0x4e4], r14d
012f5539: call     0x1327ec0
012f553e: mov      r10, qword ptr [rip + 0x21878e3] ; RVA 0x347ce28
012f5545: cmp      byte ptr [rbp], r14b
012f5549: je       0x12f59b6
012f554f: cmp      dword ptr [r10 + 0x4294], r14d
012f5556: jne      0x12f59b6
012f555c: cmp      dword ptr [r10 + 0x4298], r14d
012f5563: jne      0x12f59b6
012f5569: cmp      edi, dword ptr [rip + 0x218f219] ; RVA 0x3484788
RANGE 0x12f556f-0x12f562b
012f556f: mov      qword ptr [rsp + 0x98], r15
012f5577: je       0x12f59a6
012f557d: lea      rcx, [rbp + 0x363e0]
012f5584: movaps   xmm1, xmm6
012f5587: call     0x17924b0
012f558c: movss    xmm0, dword ptr [rbp + 0x361cc]
012f5594: lea      rcx, [rbp + 0x36a60]
012f559b: mulss    xmm0, dword ptr [rbp + 0x361bc]
012f55a3: movaps   xmm1, xmm6
012f55a6: movss    dword ptr [rbp + 0x36938], xmm0
012f55ae: addss    xmm1, dword ptr [rbp + 0x24e320]
012f55b6: movss    dword ptr [rbp + 0x24e320], xmm1
012f55be: call     0x17a2580
012f55c3: mov      r9, qword ptr [rip + 0x2177f96] ; RVA 0x346d560
012f55ca: mov      esi, edi
012f55cc: mov      eax, dword ptr [r9 + 0x1fc]
012f55d3: cmp      dword ptr [r9 + 0x1f8], eax
012f55da: jne      0x12f55e6
012f55dc: movzx    eax, word ptr [r9 + 0x1f00]
012f55e4: jmp      0x12f55fb
012f55e6: dec      eax
012f55e8: and      eax, 0x1f
012f55eb: imul     rax, rax, 0xe8
012f55f2: movzx    eax, word ptr [rax + r9 + 0x200]
012f55fb: mov      ebx, 0xffffffff
012f5600: cmp      ax, 7
012f5604: jne      0x12f56db
012f560a: mov      rcx, r9
012f560d: call     0x127ba30
012f5612: mov      eax, dword ptr [rax + 4]
012f5615: cmp      eax, dword ptr [rip + 0x218e605] ; RVA 0x3483c20
012f561b: je       0x12f56db
012f5621: mov      rcx, qword ptr [rip + 0x20316f8] ; RVA 0x3326d20
012f5628: mov      edx, r14d
RANGE 0x12f562b-0x12f5659
012f562b: mov      qword ptr [rsp + 0x90], r13
012f5633: mov      r10d, dword ptr [rcx + 0x100]
012f563a: mov      r15d, dword ptr [rcx + 0x108]
012f5641: imul     r15d, eax
012f5645: lea      r13d, [r10 - 1]
012f5649: test     r10d, r10d
012f564c: je       0x12f56d3
012f5652: mov      r11, qword ptr [rcx + 0xf8]
RANGE 0x12f5659-0x12f56d3
012f5659: mov      qword ptr [rsp + 0x88], r12
012f5661: mov      r12d, dword ptr [rcx + 0x104]
012f5668: nop      dword ptr [rax + rax]
012f5670: mov      ecx, r13d
012f5673: lea      r8d, [rdx + r15]
012f5677: and      r8, rcx
012f567a: mov      ecx, dword ptr [r11 + r8*8]
012f567e: cmp      ecx, r12d
012f5681: je       0x12f5690
012f5683: cmp      ecx, eax
012f5685: je       0x12f5694
012f5687: inc      edx
012f5689: cmp      edx, r10d
012f568c: jb       0x12f5670
012f568e: jmp      0x12f56cb
012f5690: cmp      ecx, eax
012f5692: jne      0x12f56cb
012f5694: cmp      dword ptr [r11 + r8*8 + 4], ebx
012f5699: je       0x12f56cb
012f569b: mov      rcx, r9
012f569e: call     0x127ba30
012f56a3: mov      rcx, qword ptr [rip + 0x2030dbe] ; RVA 0x3326468
012f56aa: lea      rdx, [rsp + 0x80]
012f56b2: mov      r8d, dword ptr [rax + 4]
012f56b6: call     0x606520
012f56bb: mov      eax, dword ptr [rsp + 0x80]
012f56c2: cmp      eax, dword ptr [rip + 0x218f0c0] ; RVA 0x3484788
012f56c8: cmovne   esi, eax
012f56cb: mov      r12, qword ptr [rsp + 0x88]
RANGE 0x12f56d3-0x12f56db
012f56d3: mov      r13, qword ptr [rsp + 0x90]
RANGE 0x12f56db-0x12f5990
012f56db: mov      r8d, esi
012f56de: lea      rdx, [rsp + 0x80]
012f56e6: call     0x606630
012f56eb: mov      r8d, dword ptr [rsp + 0x80]
012f56f3: cmp      r8d, dword ptr [rip + 0x218f08e] ; RVA 0x3484788
012f56fa: je       0x12f59a6
012f5700: lea      rcx, [rbp + 0x304f0]
012f5707: call     0x17c7550
012f570c: lea      rcx, [rbp + 0xc740]
012f5713: movaps   xmm1, xmm6
012f5716: call     0x1857610
012f571b: movaps   xmm1, xmm6
012f571e: lea      rcx, [rbp + 0xfb18]
012f5725: call     0x185ae70
012f572a: mov      rax, qword ptr [rip + 0x2030c0f] ; RVA 0x3326340
012f5731: cmp      dword ptr [rax + 0xac21c], 3
012f5738: jne      0x12f57a6
012f573a: mov      rax, qword ptr [rip + 0x21876e7] ; RVA 0x347ce28
012f5741: cmp      dword ptr [rax + 0x4294], r14d
012f5748: jne      0x12f57a6
012f574a: cmp      dword ptr [rax + 0x4298], r14d
012f5751: jne      0x12f57a6
012f5753: cmp      byte ptr [rbp + 1], r14b
012f5757: jne      0x12f57a6
012f5759: mov      rax, qword ptr [rip + 0x2177dd0] ; RVA 0x346d530
012f5760: cmp      dword ptr [rax + 0x190c], r14d
012f5767: jne      0x12f57a6
012f5769: mov      rdx, qword ptr [rip + 0x2187780] ; RVA 0x347cef0
012f5770: mov      rcx, qword ptr [rip + 0x21876d9] ; RVA 0x347ce50
012f5777: mov      rdx, qword ptr [rdx + 0xb398]
012f577e: call     0x1366d30
012f5783: test     rax, rax
012f5786: je       0x12f57a6
012f5788: cmp      byte ptr [rbp + 0x46d904], r14b
012f578f: je       0x12f57a6
012f5791: mov      byte ptr [rbp + 0x46d904], r14b
012f5798: lea      rcx, [rbp + 0x4ef250]
012f579f: mov      edx, dword ptr [rax]
012f57a1: call     0x1a10200
012f57a6: cmp      byte ptr [rbp + 0x8818], r14b
012f57ad: je       0x12f57c0
012f57af: mov      eax, dword ptr [rbp + 0x4ef250]
012f57b5: shr      eax, 4
012f57b8: test     al, 1
012f57ba: jne      0x12f57c0
012f57bc: mov      dl, 1
012f57be: jmp      0x12f57c2
012f57c0: xor      edx, edx
012f57c2: lea      rcx, [rbp + 0xd70]
012f57c9: call     0x1450850
012f57ce: lea      rcx, [rbp + 0xd70]
012f57d5: movaps   xmm1, xmm6
012f57d8: call     0x18ffb10
012f57dd: cmp      byte ptr [rbp + 0x53e0], r14b
012f57e4: je       0x12f5812
012f57e6: mov      eax, dword ptr [rbp + 0x4ef250]
012f57ec: shr      eax, 4
012f57ef: test     al, 1
012f57f1: jne      0x12f5812
012f57f3: mov      dl, 1
012f57f5: lea      rcx, [rbp + 0x5688]
012f57fc: call     0x1450850
012f5801: lea      rcx, [rbp + 0x5688]
012f5808: movaps   xmm1, xmm6
012f580b: call     0x19d6c30
012f5810: jmp      0x12f5820
012f5812: lea      rcx, [rbp + 0x5688]
012f5819: xor      edx, edx
012f581b: call     0x1450850
012f5820: lea      rcx, [rbp + 0x8940]
012f5827: cmp      byte ptr [rbp + 0x53e0], r14b
012f582e: jne      0x12f584a
012f5830: cmp      byte ptr [rbp + 0x8818], r14b
012f5837: jne      0x12f584a
012f5839: mov      eax, dword ptr [rbp + 0x4ef250]
012f583f: shr      eax, 4
012f5842: test     al, 1
012f5844: je       0x12f584a
012f5846: mov      al, 1
012f5848: jmp      0x12f584c
012f584a: xor      eax, eax
012f584c: movaps   xmm1, xmm6
012f584f: mov      byte ptr [rcx + 0x3dd0], al
012f5855: call     0x19020d0
012f585a: cmp      byte ptr [rbp + 1], r14b
012f585e: jne      0x12f586f
012f5860: movaps   xmm2, xmm6
012f5863: lea      rcx, [rbp + 0xfb18]
012f586a: call     0x185bb20
012f586f: mov      r8b, 1
012f5872: movaps   xmm1, xmm6
012f5875: mov      rcx, rbp
012f5878: call     0x12f3c70
012f587d: mov      rax, qword ptr [rip + 0x2030abc] ; RVA 0x3326340
012f5884: mov      ecx, dword ptr [rax + 0xac21c]
012f588a: cmp      ecx, 4
012f588d: jne      0x12f58a3
012f588f: lea      rcx, [rbp + 0x24e340]
012f5896: mov      r8d, esi
012f5899: movaps   xmm1, xmm6
012f589c: call     0x12ebc50
012f58a1: jmp      0x12f58ba
012f58a3: cmp      ecx, 3
012f58a6: jne      0x12f58ba
012f58a8: lea      rcx, [rbp + 0x46d900]
012f58af: mov      r8d, esi
012f58b2: movaps   xmm1, xmm6
012f58b5: call     0x137e7e0
012f58ba: cmp      byte ptr [rbp + 1], r14b
012f58be: je       0x12f58c9
012f58c0: movss    xmm8, dword ptr [rip + 0x10d1e9f] ; RVA 0x23c7768
012f58c9: mov      rax, qword ptr [rip + 0x2187558] ; RVA 0x347ce28
012f58d0: cmp      dword ptr [rax + 0x4294], r14d
012f58d7: jne      0x12f58f0
012f58d9: cmp      dword ptr [rax + 0x4298], r14d
012f58e0: jne      0x12f58f0
012f58e2: movaps   xmm1, xmm8
012f58e6: call     0x139e150
012f58eb: call     0x13a17c0
012f58f0: cmp      edi, dword ptr [rip + 0x218e32a] ; RVA 0x3483c20
012f58f6: mov      r8, qword ptr [rip + 0x2030b6b] ; RVA 0x3326468
012f58fd: je       0x12f5959
012f58ff: mov      edx, dword ptr [r8 + 0xd8]
012f5906: mov      r9d, dword ptr [r8 + 0xe0]
012f590d: imul     r9d, edi
012f5911: lea      esi, [rdx - 1]
012f5914: test     edx, edx
012f5916: je       0x12f5959
012f5918: mov      r10, qword ptr [r8 + 0xd0]
012f591f: mov      r11d, dword ptr [r8 + 0xdc]
012f5926: nop      word ptr [rax + rax]
012f5930: mov      eax, esi
012f5932: lea      ecx, [r14 + r9]
012f5936: and      rcx, rax
012f5939: mov      eax, dword ptr [r10 + rcx*8]
012f593d: cmp      eax, r11d
012f5940: je       0x12f5950
012f5942: cmp      eax, edi
012f5944: je       0x12f5954
012f5946: inc      r14d
012f5949: cmp      r14d, edx
012f594c: jb       0x12f5930
012f594e: jmp      0x12f5959
012f5950: cmp      eax, edi
012f5952: jne      0x12f5959
012f5954: mov      ebx, dword ptr [r10 + rcx*8 + 4]
012f5959: mov      eax, ebx
012f595b: imul     rcx, rax, 0x38
012f595f: cmp      dword ptr [rcx + r8 + 0x2e0], 3
012f5968: je       0x12f5980
012f596a: call     0x8f3280
012f596f: test     al, al
012f5971: jne      0x12f5980
012f5973: call     0x6076c0
012f5978: test     al, al
012f597a: jne      0x12f5980
012f597c: mov      al, 1
012f597e: jmp      0x12f5982
012f5980: xor      al, al
012f5982: mov      byte ptr [rbp + 0x24e336], al
012f5988: mov      r15, qword ptr [rsp + 0x98]
RANGE 0x12f5990-0x12f59a6
012f5990: movaps   xmm6, xmmword ptr [rsp + 0x40]
012f5995: movaps   xmm8, xmmword ptr [rsp + 0x20]
012f599b: add      rsp, 0x50
012f599f: pop      r14
012f59a1: pop      rdi
012f59a2: pop      rsi
012f59a3: pop      rbp
012f59a4: pop      rbx
012f59a5: ret      
RANGE 0x12f59a6-0x12f59b6
012f59a6: xor      r8d, r8d
012f59a9: movaps   xmm1, xmm6
012f59ac: mov      rcx, rbp
012f59af: call     0x12f3c70
012f59b4: jmp      0x12f5988
RANGE 0x12f59b6-0x12f5b61
012f59b6: call     0x12f3120
012f59bb: test     al, al
012f59bd: jne      0x12f5a31
012f59bf: mov      eax, dword ptr [r10 + 0x42b0]
012f59c6: sub      eax, 1
012f59c9: movsxd   rcx, eax
012f59cc: mov      rax, rcx
012f59cf: js       0x12f5a77
012f59d5: lea      rdx, [r10 + 0x429c]
012f59dc: lea      rdx, [rdx + rcx*4]
012f59e0: cmp      dword ptr [rdx], 0x17
012f59e3: je       0x12f5a31
012f59e5: sub      rdx, 4
012f59e9: sub      rax, 1
012f59ed: jns      0x12f59e0
012f59ef: lea      rax, [r10 + 0x429c]
012f59f6: mov      rdx, rcx
012f59f9: lea      rax, [rax + rcx*4]
012f59fd: nop      dword ptr [rax]
012f5a00: cmp      dword ptr [rax], 8
012f5a03: je       0x12f5a31
012f5a05: sub      rax, 4
012f5a09: sub      rdx, 1
012f5a0d: jns      0x12f5a00
012f5a0f: lea      rax, [r10 + 0x429c]
012f5a16: lea      rax, [rax + rcx*4]
012f5a1a: nop      word ptr [rax + rax]
012f5a20: cmp      dword ptr [rax], 5
012f5a23: je       0x12f5a31
012f5a25: sub      rax, 4
012f5a29: sub      rcx, 1
012f5a2d: jns      0x12f5a20
012f5a2f: jmp      0x12f5a77
012f5a31: mov      rax, qword ptr [rip + 0x2030908] ; RVA 0x3326340
012f5a38: mov      ecx, dword ptr [rax + 0xac21c]
012f5a3e: cmp      ecx, 3
012f5a41: jne      0x12f5a54
012f5a43: lea      rcx, [rbp + 0x46f600]
012f5a4a: movaps   xmm1, xmm6
012f5a4d: call     0x18fdec0
012f5a52: jmp      0x12f5a77
012f5a54: cmp      ecx, 4
012f5a57: jne      0x12f5a77
012f5a59: lea      rcx, [rbp + 0x4646b8]
012f5a60: movaps   xmm1, xmm6
012f5a63: call     0x1871000
012f5a68: lea      rcx, [rbp + 0x469818]
012f5a6f: movaps   xmm1, xmm6
012f5a72: call     0x18708f0
012f5a77: lea      rcx, [rbp + 0xc740]
012f5a7e: movaps   xmm1, xmm6
012f5a81: call     0x1857610
012f5a86: lea      rcx, [rbp + 0xfb18]
012f5a8d: movaps   xmm1, xmm6
012f5a90: call     0x185ae70
012f5a95: call     0x12f3120
012f5a9a: test     al, al
012f5a9c: je       0x12f5ac6
012f5a9e: cmp      byte ptr [rbp + 0x8818], r14b
012f5aa5: je       0x12f5ac6
012f5aa7: mov      dl, 1
012f5aa9: lea      rcx, [rbp + 0xd70]
012f5ab0: call     0x1450850
012f5ab5: lea      rcx, [rbp + 0xd70]
012f5abc: movaps   xmm1, xmm6
012f5abf: call     0x18ffb10
012f5ac4: jmp      0x12f5ad4
012f5ac6: lea      rcx, [rbp + 0xd70]
012f5acd: xor      edx, edx
012f5acf: call     0x1450850
012f5ad4: call     0x12f3120
012f5ad9: test     al, al
012f5adb: je       0x12f5b05
012f5add: cmp      byte ptr [rbp + 0x53e0], r14b
012f5ae4: je       0x12f5b05
012f5ae6: mov      dl, 1
012f5ae8: lea      rcx, [rbp + 0x5688]
012f5aef: call     0x1450850
012f5af4: lea      rcx, [rbp + 0x5688]
012f5afb: movaps   xmm1, xmm6
012f5afe: call     0x19d6c30
012f5b03: jmp      0x12f5b13
012f5b05: lea      rcx, [rbp + 0x5688]
012f5b0c: xor      edx, edx
012f5b0e: call     0x1450850
012f5b13: xor      r8d, r8d
012f5b16: movaps   xmm1, xmm6
012f5b19: mov      rcx, rbp
012f5b1c: call     0x12f3c70
012f5b21: cmp      byte ptr [rbp + 1], r14b
012f5b25: je       0x12f5b39
012f5b27: movss    xmm1, dword ptr [rip + 0x10d1c39] ; RVA 0x23c7768
012f5b2f: call     0x139e150
012f5b34: call     0x13a17c0
012f5b39: mov      rax, qword ptr [rip + 0x2030800] ; RVA 0x3326340
012f5b40: cmp      dword ptr [rax + 0xac21c], 3
012f5b47: jne      0x12f5990
012f5b4d: lea      rcx, [rbp + 0x46d900]
012f5b54: movaps   xmm1, xmm6
012f5b57: call     0x137ea20
012f5b5c: jmp      0x12f5990