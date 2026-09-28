RANGE 0x17b7120-0x17b8ba1
017b7120: mov      rax, rsp
017b7123: mov      qword ptr [rax + 0x10], rbx
017b7127: mov      qword ptr [rax + 0x18], rsi
017b712b: mov      qword ptr [rax + 0x20], rdi
017b712f: push     rbp
017b7130: push     r12
017b7132: push     r13
017b7134: push     r14
017b7136: push     r15
017b7138: lea      rbp, [rax - 0xc8]
017b713f: sub      rsp, 0x1a0
017b7146: movaps   xmmword ptr [rax - 0x38], xmm6
017b714a: movaps   xmmword ptr [rax - 0x48], xmm7
017b714e: movaps   xmmword ptr [rax - 0x58], xmm8
017b7153: movaps   xmmword ptr [rax - 0x68], xmm9
017b7158: movaps   xmmword ptr [rax - 0x78], xmm10
017b715d: movaps   xmmword ptr [rax - 0x98], xmm12
017b7165: movaps   xmmword ptr [rax - 0xa8], xmm13
017b716d: movaps   xmmword ptr [rax - 0xb8], xmm14
017b7175: movaps   xmmword ptr [rax - 0xc8], xmm15
017b717d: mov      rax, qword ptr [rip + 0xe84e8c] ; RVA 0x263c010
017b7184: xor      rax, rsp
017b7187: mov      qword ptr [rbp - 0x10], rax
017b718b: mov      rax, qword ptr [rcx + 0x2078]
017b7192: xor      r12d, r12d
017b7195: mov      ebx, dword ptr [rip + 0x1ccca85] ; RVA 0x3483c20
017b719b: add      rax, 0x10
017b719f: mov      r11, qword ptr [rip + 0x1b6f2c2] ; RVA 0x3326468
017b71a6: movaps   xmm12, xmm1
017b71aa: movss    dword ptr [rbp - 0x80], xmm12
017b71b0: mov      esi, r8d
017b71b3: mov      dword ptr [rsp + 0x48], r8d
017b71b8: mov      r15, rcx
017b71bb: mov      qword ptr [rsp + 0x28], rax
017b71c0: cmp      r8d, ebx
017b71c3: je       0x17b7225
017b71c5: mov      r8d, dword ptr [r11 + 0xd8]
017b71cc: mov      ecx, r12d
017b71cf: mov      r9d, dword ptr [r11 + 0xe0]
017b71d6: imul     r9d, esi
017b71da: lea      r14d, [r8 - 1]
017b71de: test     r8d, r8d
017b71e1: je       0x17b7225
017b71e3: mov      r10, qword ptr [r11 + 0xd0]
017b71ea: mov      edi, dword ptr [r11 + 0xdc]
017b71f1: nop      dword ptr [rax]
017b71f5: nop      word ptr [rax + rax]
017b7200: mov      eax, r14d
017b7203: lea      edx, [rcx + r9]
017b7207: and      rdx, rax
017b720a: mov      eax, dword ptr [r10 + rdx*8]
017b720e: cmp      eax, edi
017b7210: je       0x17b7397
017b7216: cmp      eax, esi
017b7218: je       0x17b739f
017b721e: inc      ecx
017b7220: cmp      ecx, r8d
017b7223: jb       0x17b7200
017b7225: mov      eax, 0xffffffff
017b722a: mov      ecx, eax
017b722c: shl      rcx, 5
017b7230: mov      edx, dword ptr [rcx + r11 + 0x3a8]
017b7238: lea      rcx, [rsp + 0x50]
017b723d: call     0xfd9ba0
017b7242: mov      edi, dword ptr [rsp + 0x50]
017b7246: mov      ecx, edi
017b7248: call     0xfd9d40
017b724d: mov      r13, qword ptr [rip + 0x1b6facc] ; RVA 0x3326d20
017b7254: mov      qword ptr [rsp + 0x60], r13
017b7259: mov      qword ptr [rsp + 0x70], rax
017b725e: cmp      edi, ebx
017b7260: je       0x17b72b6
017b7262: mov      r8d, dword ptr [r13 + 0x100]
017b7269: mov      ecx, r12d
017b726c: mov      r9d, dword ptr [r13 + 0x108]
017b7273: imul     r9d, edi
017b7277: lea      r14d, [r8 - 1]
017b727b: test     r8d, r8d
017b727e: je       0x17b72b6
017b7280: mov      r10, qword ptr [r13 + 0xf8]
017b7287: mov      r11d, dword ptr [r13 + 0x104]
017b728e: nop      
017b7290: mov      eax, r14d
017b7293: lea      edx, [rcx + r9]
017b7297: and      rdx, rax
017b729a: mov      eax, dword ptr [r10 + rdx*8]
017b729e: cmp      eax, r11d
017b72a1: je       0x17b73a9
017b72a7: cmp      eax, edi
017b72a9: je       0x17b73b1
017b72af: inc      ecx
017b72b1: cmp      ecx, r8d
017b72b4: jb       0x17b7290
017b72b6: mov      r14d, 0xffffffff
017b72bc: mov      r11, qword ptr [rip + 0x1b6fab5] ; RVA 0x3326d78
017b72c3: mov      eax, r14d
017b72c6: imul     rax, rax, 0x78
017b72ca: mov      qword ptr [rbp - 0x70], rax
017b72ce: cmp      edi, ebx
017b72d0: je       0x17b7328
017b72d2: mov      r8d, dword ptr [r11 + 0x28]
017b72d6: xor      ecx, ecx
017b72d8: mov      r9d, dword ptr [r11 + 0x30]
017b72dc: imul     r9d, edi
017b72e0: lea      r12d, [r8 - 1]
017b72e4: test     r8d, r8d
017b72e7: je       0x17b7325
017b72e9: mov      r10, qword ptr [r11 + 0x20]
017b72ed: mov      ebx, dword ptr [r11 + 0x2c]
017b72f1: nop      dword ptr [rax]
017b72f5: nop      word ptr [rax + rax]
017b7300: mov      eax, r12d
017b7303: lea      edx, [rcx + r9]
017b7307: and      rdx, rax
017b730a: mov      eax, dword ptr [r10 + rdx*8]
017b730e: cmp      eax, ebx
017b7310: je       0x17b73bb
017b7316: cmp      eax, edi
017b7318: je       0x17b73bf
017b731e: inc      ecx
017b7320: cmp      ecx, r8d
017b7323: jb       0x17b7300
017b7325: xor      r12d, r12d
017b7328: mov      eax, 0xffffffff
017b732d: mov      ecx, eax
017b732f: mov      rax, qword ptr [r11 + 0x48]
017b7333: shl      rcx, 6
017b7337: mov      edx, dword ptr [rcx + rax + 8]
017b733b: lea      rcx, [r15 + 0x330]
017b7342: sub      edx, 2
017b7345: test     edx, 0xfffffffd
017b734b: mov      rdx, qword ptr [r15 + 0x2090]
017b7352: setne    byte ptr [rsp + 0x20]
017b7357: call     0x1447610
017b735c: mov      rax, qword ptr [rsp + 0x28]
017b7361: xorps    xmm13, xmm13
017b7365: movss    xmm8, dword ptr [rip + 0xc0f9f2] ; RVA 0x23c6d60
017b736e: movaps   xmm15, xmm8
017b7372: movss    xmm14, dword ptr [rax + 0x14]
017b7378: mov      rax, qword ptr [rip + 0x1b6efc1] ; RVA 0x3326340
017b737f: movzx    ecx, byte ptr [rax + 0xac4d4]
017b7386: mov      byte ptr [r15 + 0x209c], cl
017b738d: test     cl, cl
017b738f: je       0x17b73d9
017b7391: movaps   xmm7, xmm8
017b7395: jmp      0x17b73dc
017b7397: cmp      eax, esi
017b7399: jne      0x17b7225
017b739f: mov      eax, dword ptr [r10 + rdx*8 + 4]
017b73a4: jmp      0x17b722a
017b73a9: cmp      eax, edi
017b73ab: jne      0x17b72b6
017b73b1: mov      r14d, dword ptr [r10 + rdx*8 + 4]
017b73b6: jmp      0x17b72bc
017b73bb: cmp      eax, edi
017b73bd: jne      0x17b73cc
017b73bf: mov      eax, dword ptr [r10 + rdx*8 + 4]
017b73c4: xor      r12d, r12d
017b73c7: jmp      0x17b732d
017b73cc: mov      eax, 0xffffffff
017b73d1: xor      r12d, r12d
017b73d4: jmp      0x17b732d
017b73d9: xorps    xmm7, xmm7
017b73dc: mov      rax, qword ptr [r15 + 0x2078]
017b73e3: cmp      qword ptr [rax + 0x70], 0
017b73e8: je       0x17b742c
017b73ea: movss    xmm0, dword ptr [rax + 0x68]
017b73ef: lea      rcx, [r15 + 0x440]
017b73f6: movss    dword ptr [rsp + 0x40], xmm0
017b73fc: movss    dword ptr [rsp + 0x44], xmm0
017b7402: mov      rdx, qword ptr [rsp + 0x40]
017b7407: call     0x14470d0
017b740c: mov      rdx, qword ptr [r15 + 0x2078]
017b7413: lea      rcx, [r15 + 0x440]
017b741a: xor      r8d, r8d
017b741d: mov      rdx, qword ptr [rdx + 0x70]
017b7421: call     0x144f770
017b7426: movaps   xmm1, xmm8
017b742a: jmp      0x17b742f
017b742c: xorps    xmm1, xmm1
017b742f: lea      rcx, [r15 + 0x440]
017b7436: call     0x1448a40
017b743b: mov      rax, qword ptr [rsp + 0x28]
017b7440: mov      ebx, r12d
017b7443: movss    xmm10, dword ptr [rip + 0xc10624] ; RVA 0x23c7a70
017b744c: cmp      dword ptr [rax + 8], 0
017b7450: jle      0x17b7552
017b7456: movss    xmm6, dword ptr [rip + 0xc10062] ; RVA 0x23c74c0
017b745e: lea      rdi, [rbp - 0x50]
017b7462: mov      rsi, rax
017b7465: lea      r13, [rax + 0x18]
017b7469: nop      dword ptr [rax]
017b7470: mov      rdx, qword ptr [rsi]
017b7473: lea      r12, [r15 + 0xf00]
017b747a: movsxd   rax, ebx
017b747d: imul     rcx, rax, 0x158
017b7484: lea      rax, [r15 + 0x1460]
017b748b: add      rax, rcx
017b748e: add      r12, rcx
017b7491: mov      rcx, r12
017b7494: mov      qword ptr [rsp + 0x30], rax
017b7499: call     0x14470d0
017b749e: movss    xmm0, dword ptr [rsi]
017b74a2: movss    xmm1, dword ptr [rsi + 4]
017b74a7: addss    xmm0, xmm6
017b74ab: mov      rcx, qword ptr [rsp + 0x30]
017b74b0: addss    xmm1, xmm6
017b74b4: movss    dword ptr [rsp + 0x40], xmm0
017b74ba: movss    dword ptr [rsp + 0x44], xmm1
017b74c0: mov      rdx, qword ptr [rsp + 0x40]
017b74c5: call     0x14470d0
017b74ca: comiss   xmm13, dword ptr [r15 + 0x20b4]
017b74d2: jae      0x17b74de
017b74d4: cmp      dword ptr [r15 + 0x2084], 4
017b74dc: je       0x17b74ea
017b74de: movaps   xmm1, xmm8
017b74e2: mov      rcx, r12
017b74e5: call     0x1448a40
017b74ea: mov      rdx, qword ptr [r13]
017b74ee: xor      r8d, r8d
017b74f1: mov      rcx, r12
017b74f4: call     0x144f770
017b74f9: mov      rdx, qword ptr [r13]
017b74fd: xor      r8d, r8d
017b7500: mov      rcx, qword ptr [rsp + 0x30]
017b7505: call     0x144f770
017b750a: mov      eax, dword ptr [rsi + 8]
017b750d: movaps   xmm2, xmm10
017b7511: movd     xmm1, ebx
017b7515: add      r13, 8
017b7519: cvtdq2ps xmm1, xmm1
017b751c: inc      ebx
017b751e: movd     xmm0, eax
017b7522: cvtdq2ps xmm0, xmm0
017b7525: divss    xmm2, xmm0
017b7529: mulss    xmm2, xmm1
017b752d: addss    xmm2, dword ptr [rsi + 0xc]
017b7532: movss    dword ptr [rdi], xmm2
017b7536: add      rdi, 4
017b753a: cmp      ebx, eax
017b753c: jl       0x17b7470
017b7542: mov      edi, dword ptr [rsp + 0x50]
017b7546: xor      r12d, r12d
017b7549: mov      esi, dword ptr [rsp + 0x48]
017b754d: mov      r13, qword ptr [rsp + 0x60]
017b7552: cmp      byte ptr [r15 + 0x209b], 0
017b755a: jne      0x17b75a7
017b755c: comiss   xmm13, dword ptr [r15 + 0x20b4]
017b7564: jae      0x17b7570
017b7566: cmp      dword ptr [r15 + 0x2084], 4
017b756e: je       0x17b75a7
017b7570: mov      rax, qword ptr [r15 + 0x2078]
017b7577: test     byte ptr [rax + 8], 0x20
017b757b: jne      0x17b758d
017b757d: lea      rcx, [r15 + 0x848]
017b7584: movaps   xmm1, xmm8
017b7588: call     0x1448a40
017b758d: cmp      byte ptr [r15 + 0x209c], 0
017b7595: je       0x17b75a7
017b7597: lea      rcx, [r15 + 0x9a0]
017b759e: movaps   xmm1, xmm8
017b75a2: call     0x1448a40
017b75a7: cmp      byte ptr [rsp + 0x20], 0
017b75ac: je       0x17b75c2
017b75ae: mov      rax, qword ptr [rbp - 0x70]
017b75b2: mov      byte ptr [rsp + 0x20], 1
017b75b7: test     byte ptr [rax + r13 + 0x547830], 1
017b75c0: jne      0x17b75c7
017b75c2: mov      byte ptr [rsp + 0x20], 0
017b75c7: mov      ebx, dword ptr [rip + 0x1ccd3bb] ; RVA 0x3484988
017b75cd: cmp      esi, ebx
017b75cf: je       0x17b7611
017b75d1: mov      r8d, esi
017b75d4: lea      rdx, [rsp + 0x48]
017b75d9: call     0x606630
017b75de: mov      ecx, dword ptr [rsp + 0x48]
017b75e2: mov      ebx, dword ptr [rip + 0x1ccd3a0] ; RVA 0x3484988
017b75e8: cmp      ecx, ebx
017b75ea: je       0x17b7611
017b75ec: lea      r8, [rsp + 0x48]
017b75f1: mov      qword ptr [rbp - 0x70], 0
017b75f9: lea      rdx, [rbp - 0x70]
017b75fd: mov      qword ptr [rbp - 0x68], 0
017b7605: mov      dword ptr [rbp - 0x60], r12d
017b7609: call     0x827670
017b760e: mov      ebx, dword ptr [rbp - 0x70]
017b7611: mov      ecx, ebx
017b7613: call     0xfd9d40
017b7618: cmp      ebx, dword ptr [rip + 0x1ccc616] ; RVA 0x3483c34
017b761e: mov      r13, rax
017b7621: mov      rcx, qword ptr [rip + 0x1b6ed18] ; RVA 0x3326340
017b7628: movaps   xmm0, xmmword ptr [rip + 0xc12fb1] ; RVA 0x23ca5e0
017b762f: movaps   xmm1, xmmword ptr [rip + 0xc1282a] ; RVA 0x23c9e60
017b7636: movups   xmmword ptr [rbp - 0x40], xmm0
017b763a: movsxd   rdx, dword ptr [rcx + 0xac4c0]
017b7641: movaps   xmm0, xmmword ptr [rip + 0xc11088] ; RVA 0x23c86d0
017b7648: movups   xmmword ptr [rbp - 0x30], xmm1
017b764c: mov      qword ptr [rsp + 0x40], rax
017b7651: lea      rcx, [rdx + rdx*2]
017b7655: mov      qword ptr [rsp + 0x60], 0
017b765e: movups   xmmword ptr [rbp - 0x20], xmm0
017b7662: mov      eax, dword ptr [rbp + rcx*4 - 0x38]
017b7666: movsd    xmm0, qword ptr [rbp + rcx*4 - 0x40]
017b766c: movsd    qword ptr [rbp - 0x70], xmm0
017b7671: mov      dword ptr [rbp - 0x68], eax
017b7674: mov      dword ptr [rsp + 0x68], 0
017b767c: je       0x17b781f
017b7682: mov      rsi, qword ptr [rip + 0x1b6f54f] ; RVA 0x3326bd8
017b7689: xor      ecx, ecx
017b768b: mov      r8d, dword ptr [rsi + 0x848]
017b7692: mov      r9d, dword ptr [rsi + 0x850]
017b7699: imul     r9d, ebx
017b769d: lea      r12d, [r8 - 1]
017b76a1: test     r8d, r8d
017b76a4: je       0x17b781f
017b76aa: mov      r10, qword ptr [rsi + 0x840]
017b76b1: mov      r11d, dword ptr [rsi + 0x84c]
017b76b8: nop      dword ptr [rax + rax]
017b76c0: mov      eax, r12d
017b76c3: lea      edx, [rcx + r9]
017b76c7: and      rdx, rax
017b76ca: mov      eax, dword ptr [r10 + rdx*8]
017b76ce: cmp      eax, r11d
017b76d1: je       0x17b76e3
017b76d3: cmp      eax, ebx
017b76d5: je       0x17b76eb
017b76d7: inc      ecx
017b76d9: cmp      ecx, r8d
017b76dc: jb       0x17b76c0
017b76de: jmp      0x17b781f
017b76e3: cmp      eax, ebx
017b76e5: jne      0x17b781f
017b76eb: cmp      dword ptr [r10 + rdx*8 + 4], -1
017b76f1: je       0x17b781f
017b76f7: mov      rcx, r13
017b76fa: call     0x506fe0
017b76ff: cmp      byte ptr [rax + 0x1c], 0
017b7703: je       0x17b781f
017b7709: mov      r8d, dword ptr [rsi + 0x848]
017b7710: xor      ecx, ecx
017b7712: mov      r9d, dword ptr [rsi + 0x850]
017b7719: imul     r9d, ebx
017b771d: lea      r12d, [r8 - 1]
017b7721: test     r8d, r8d
017b7724: je       0x17b775e
017b7726: mov      r10, qword ptr [rsi + 0x840]
017b772d: mov      r11d, dword ptr [rsi + 0x84c]
017b7734: nop      dword ptr [rax]
017b7738: nop      dword ptr [rax + rax]
017b7740: mov      eax, r12d
017b7743: lea      edx, [rcx + r9]
017b7747: and      rdx, rax
017b774a: mov      eax, dword ptr [r10 + rdx*8]
017b774e: cmp      eax, r11d
017b7751: je       0x17b778c
017b7753: cmp      eax, ebx
017b7755: je       0x17b7790
017b7757: inc      ecx
017b7759: cmp      ecx, r8d
017b775c: jb       0x17b7740
017b775e: mov      eax, 0xffffffff
017b7763: mov      r13, qword ptr [rsi + 0x870]
017b776a: mov      ecx, eax
017b776c: lea      rax, [rcx + rcx*4]
017b7770: cmp      byte ptr [r13 + rax*4 + 8], 0
017b7776: je       0x17b7797
017b7778: mov      dword ptr [rbp - 0x70], 0
017b777f: mov      qword ptr [rbp - 0x6c], 0x3f800000
017b7787: jmp      0x17b781f
017b778c: cmp      eax, ebx
017b778e: jne      0x17b775e
017b7790: mov      eax, dword ptr [r10 + rdx*8 + 4]
017b7795: jmp      0x17b7763
017b7797: mov      r9d, dword ptr [rsi + 0x850]
017b779e: lea      r12d, [r8 - 1]
017b77a2: imul     r9d, ebx
017b77a6: xor      ecx, ecx
017b77a8: test     r8d, r8d
017b77ab: je       0x17b77e6
017b77ad: mov      r10, qword ptr [rsi + 0x840]
017b77b4: mov      r11d, dword ptr [rsi + 0x84c]
017b77bb: nop      dword ptr [rax + rax]
017b77c0: mov      eax, r12d
017b77c3: lea      edx, [rcx + r9]
017b77c7: and      rdx, rax
017b77ca: mov      eax, dword ptr [r10 + rdx*8]
017b77ce: cmp      eax, r11d
017b77d1: je       0x17b7882
017b77d7: cmp      eax, ebx
017b77d9: je       0x17b788a
017b77df: inc      ecx
017b77e1: cmp      ecx, r8d
017b77e4: jb       0x17b77c0
017b77e6: mov      eax, 0xffffffff
017b77eb: mov      ecx, eax
017b77ed: lea      rax, [rcx + rcx*4]
017b77f1: movss    xmm0, dword ptr [r13 + rax*4 + 4]
017b77f8: comiss   xmm0, xmm13
017b77fc: jbe      0x17b781f
017b77fe: movss    xmm0, dword ptr [rip + 0xc0f3fe] ; RVA 0x23c6c04
017b7806: movss    xmm1, dword ptr [rip + 0xc0ee66] ; RVA 0x23c6674
017b780e: movss    dword ptr [rbp - 0x6c], xmm0
017b7813: movss    dword ptr [rbp - 0x68], xmm1
017b7818: mov      dword ptr [rbp - 0x70], 0x3f800000
017b781f: cmp      ebx, dword ptr [rip + 0x1ccc3fb] ; RVA 0x3483c20
017b7825: je       0x17b7911
017b782b: mov      r8, qword ptr [rip + 0x1b6f516] ; RVA 0x3326d48
017b7832: xor      ecx, ecx
017b7834: mov      r9d, dword ptr [r8 + 0x30]
017b7838: mov      r10d, dword ptr [r8 + 0x38]
017b783c: imul     r10d, ebx
017b7840: lea      r12d, [r9 - 1]
017b7844: test     r9d, r9d
017b7847: je       0x17b7911
017b784d: mov      r11, qword ptr [r8 + 0x28]
017b7851: mov      esi, dword ptr [r8 + 0x34]
017b7855: nop      word ptr [rax + rax]
017b7860: mov      eax, r12d
017b7863: lea      edx, [rcx + r10]
017b7867: and      rdx, rax
017b786a: mov      eax, dword ptr [r11 + rdx*8]
017b786e: cmp      eax, esi
017b7870: je       0x17b7894
017b7872: cmp      eax, ebx
017b7874: je       0x17b7898
017b7876: inc      ecx
017b7878: cmp      ecx, r9d
017b787b: jb       0x17b7860
017b787d: jmp      0x17b7911
017b7882: cmp      eax, ebx
017b7884: jne      0x17b77e6
017b788a: mov      eax, dword ptr [r10 + rdx*8 + 4]
017b788f: jmp      0x17b77eb
017b7894: cmp      eax, ebx
017b7896: jne      0x17b7911
017b7898: cmp      dword ptr [r11 + rdx*8 + 4], -1
017b789e: je       0x17b7911
017b78a0: mov      r10d, dword ptr [r8 + 0x38]
017b78a4: lea      r12d, [r9 - 1]
017b78a8: imul     r10d, ebx
017b78ac: xor      ecx, ecx
017b78ae: test     r9d, r9d
017b78b1: je       0x17b78e5
017b78b3: nop      dword ptr [rax]
017b78b7: nop      word ptr [rax + rax]
017b78c0: mov      eax, r12d
017b78c3: lea      edx, [rcx + r10]
017b78c7: and      rdx, rax
017b78ca: mov      eax, dword ptr [r11 + rdx*8]
017b78ce: cmp      eax, esi
017b78d0: je       0x17b79a3
017b78d6: cmp      eax, ebx
017b78d8: je       0x17b79ab
017b78de: inc      ecx
017b78e0: cmp      ecx, r9d
017b78e3: jb       0x17b78c0
017b78e5: mov      eax, 0xffffffff
017b78ea: mov      ecx, eax
017b78ec: mov      rax, qword ptr [r8 + 0x50]
017b78f0: lea      rdx, [rcx + rcx*8]
017b78f4: cmp      byte ptr [rax + rdx*8 + 0x11], 0
017b78f9: je       0x17b7911
017b78fb: movsd    xmm0, qword ptr [rip + 0xa2a6d5] ; RVA 0x21e1fd8
017b7903: mov      eax, dword ptr [rip + 0xa2a6d7] ; RVA 0x21e1fe0
017b7909: movsd    qword ptr [rbp - 0x70], xmm0
017b790e: mov      dword ptr [rbp - 0x68], eax
017b7911: movzx    r12d, byte ptr [rsp + 0x20]
017b7917: lea      rcx, [rip + 0xa2a6ba] ; RVA 0x21e1fd8
017b791e: test     r12b, r12b
017b7921: lea      rax, [rbp - 0x70]
017b7925: lea      rdx, [rsp + 0x30]
017b792a: cmovne   rax, rcx
017b792e: lea      rcx, [r15 + 0x440]
017b7935: movsd    xmm3, qword ptr [rax]
017b7939: mov      r13d, dword ptr [rax + 8]
017b793d: movsd    qword ptr [rsp + 0x30], xmm3
017b7943: mov      dword ptr [rsp + 0x38], r13d
017b7948: call     0x1448600
017b794d: cmp      byte ptr [r15 + 0x209b], 0
017b7955: lea      rdx, [rbp - 0x70]
017b7959: movsd    xmm4, qword ptr [rsp + 0x60]
017b795f: movsd    qword ptr [rbp - 0x70], xmm3
017b7964: mov      dword ptr [rbp - 0x68], r13d
017b7968: je       0x17b79b5
017b796a: lea      rcx, [r15 + 0xaf8]
017b7971: call     0x1448600
017b7976: mov      eax, dword ptr [rsp + 0x68]
017b797a: lea      rdx, [rbp - 0x70]
017b797e: lea      rcx, [r15 + 0xda8]
017b7985: mov      dword ptr [rbp - 0x68], eax
017b7988: movsd    qword ptr [rbp - 0x70], xmm4
017b798d: call     0x1448600
017b7992: movaps   xmm1, xmm7
017b7995: lea      rcx, [r15 + 0xda8]
017b799c: call     0x1448a40
017b79a1: jmp      0x17b79c1
017b79a3: cmp      eax, ebx
017b79a5: jne      0x17b78e5
017b79ab: mov      eax, dword ptr [r11 + rdx*8 + 4]
017b79b0: jmp      0x17b78ea
017b79b5: lea      rcx, [r15 + 0x848]
017b79bc: call     0x1448600
017b79c1: cmp      dword ptr [r15 + 0x2084], 0
017b79c9: je       0x17b79d0
017b79cb: test     r12b, r12b
017b79ce: je       0x17b7a4a
017b79d0: mov      edi, dword ptr [rsp + 0x68]
017b79d4: lea      rsi, [r15 + 0x1460]
017b79db: mov      r12d, 4
017b79e1: nop      dword ptr [rax]
017b79e5: nop      word ptr [rax + rax]
017b79f0: lea      rcx, [rsi - 0x560]
017b79f7: movsd    qword ptr [rbp - 0x70], xmm3
017b79fc: lea      rdx, [rbp - 0x70]
017b7a00: mov      dword ptr [rbp - 0x68], r13d
017b7a04: call     0x1448600
017b7a09: lea      rdx, [rsp + 0x60]
017b7a0e: movsd    qword ptr [rsp + 0x60], xmm4
017b7a14: mov      rcx, rsi
017b7a17: mov      dword ptr [rsp + 0x68], edi
017b7a1b: call     0x1448600
017b7a20: cmp      byte ptr [r15 + 0x209b], 0
017b7a28: je       0x17b7a39
017b7a2a: lea      rcx, [r15 + 0xda8]
017b7a31: movaps   xmm1, xmm7
017b7a34: call     0x1448a40
017b7a39: add      rsi, 0x158
017b7a40: sub      r12, 1
017b7a44: jne      0x17b79f0
017b7a46: mov      edi, dword ptr [rsp + 0x50]
017b7a4a: mov      r9, qword ptr [rip + 0x1b6eb47] ; RVA 0x3326598
017b7a51: mov      edx, r14d
017b7a54: mov      eax, r14d
017b7a57: imul     rcx, rax, 0x38
017b7a5b: mov      rax, qword ptr [r9 + 0x38]
017b7a5f: mov      r8d, dword ptr [rcx + rax + 0x1c]
017b7a64: mov      rcx, r9
017b7a67: call     0x68adb0
017b7a6c: mov      esi, dword ptr [rip + 0x1ccc1ae] ; RVA 0x3483c20
017b7a72: xor      r13d, r13d
017b7a75: mov      r8, qword ptr [rip + 0x1b6eadc] ; RVA 0x3326558
017b7a7c: mov      qword ptr [rbp - 0x70], rax
017b7a80: cmp      edi, esi
017b7a82: je       0x17b7ad6
017b7a84: mov      r9d, dword ptr [r8 + 0x48a8]
017b7a8b: mov      ecx, r13d
017b7a8e: mov      r10d, dword ptr [r8 + 0x48b0]
017b7a95: imul     r10d, edi
017b7a99: lea      r12d, [r9 - 1]
017b7a9d: test     r9d, r9d
017b7aa0: je       0x17b7ad6
017b7aa2: mov      r11, qword ptr [r8 + 0x48a0]
017b7aa9: mov      r14d, dword ptr [r8 + 0x48ac]
017b7ab0: mov      eax, r12d
017b7ab3: lea      edx, [rcx + r10]
017b7ab7: and      rdx, rax
017b7aba: mov      eax, dword ptr [r11 + rdx*8]
017b7abe: cmp      eax, r14d
017b7ac1: je       0x17b7b6b
017b7ac7: cmp      eax, edi
017b7ac9: je       0x17b7b73
017b7acf: inc      ecx
017b7ad1: cmp      ecx, r9d
017b7ad4: jb       0x17b7ab0
017b7ad6: mov      ecx, 0xffffffff
017b7adb: mov      eax, ecx
017b7add: imul     rcx, rax, 0x2c
017b7ae1: mov      rax, qword ptr [r8 + 0x48d8]
017b7ae8: cmp      byte ptr [rcx + rax + 0x20], 0
017b7aed: je       0x17b7b88
017b7af3: cmp      edi, esi
017b7af5: je       0x17b7b4e
017b7af7: mov      r9d, dword ptr [r8 + 0x48a8]
017b7afe: mov      ecx, r13d
017b7b01: mov      r10d, dword ptr [r8 + 0x48b0]
017b7b08: imul     r10d, edi
017b7b0c: lea      r12d, [r9 - 1]
017b7b10: test     r9d, r9d
017b7b13: je       0x17b7b4e
017b7b15: mov      r11, qword ptr [r8 + 0x48a0]
017b7b1c: mov      r14d, dword ptr [r8 + 0x48ac]
017b7b23: nop      dword ptr [rax]
017b7b27: nop      word ptr [rax + rax]
017b7b30: mov      eax, r12d
017b7b33: lea      edx, [rcx + r10]
017b7b37: and      rdx, rax
017b7b3a: mov      eax, dword ptr [r11 + rdx*8]
017b7b3e: cmp      eax, r14d
017b7b41: je       0x17b7b7d
017b7b43: cmp      eax, edi
017b7b45: je       0x17b7b81
017b7b47: inc      ecx
017b7b49: cmp      ecx, r9d
017b7b4c: jb       0x17b7b30
017b7b4e: mov      eax, 0xffffffff
017b7b53: mov      ecx, eax
017b7b55: mov      rax, qword ptr [r8 + 0x48d0]
017b7b5c: imul     rdx, rcx, 0xa4
017b7b63: movss    xmm1, dword ptr [rdx + rax + 0x48]
017b7b69: jmp      0x17b7b8c
017b7b6b: cmp      eax, edi
017b7b6d: jne      0x17b7ad6
017b7b73: mov      ecx, dword ptr [r11 + rdx*8 + 4]
017b7b78: jmp      0x17b7adb
017b7b7d: cmp      eax, edi
017b7b7f: jne      0x17b7b4e
017b7b81: mov      eax, dword ptr [r11 + rdx*8 + 4]
017b7b86: jmp      0x17b7b53
017b7b88: movaps   xmm1, xmm13
017b7b8c: mov      rcx, qword ptr [rsp + 0x70]
017b7b91: call     0x508db0
017b7b96: mov      rcx, rax
017b7b99: cmp      edi, esi
017b7b9b: je       0x17b7bee
017b7b9d: mov      r9, qword ptr [rip + 0x1b6f17c] ; RVA 0x3326d20
017b7ba4: mov      edx, r13d
017b7ba7: mov      r10d, dword ptr [r9 + 0x100]
017b7bae: mov      r11d, dword ptr [r9 + 0x108]
017b7bb5: imul     r11d, edi
017b7bb9: lea      r12d, [r10 - 1]
017b7bbd: test     r10d, r10d
017b7bc0: je       0x17b7bee
017b7bc2: mov      rsi, qword ptr [r9 + 0xf8]
017b7bc9: mov      r14d, dword ptr [r9 + 0x104]
017b7bd0: mov      eax, r12d
017b7bd3: lea      r8d, [rdx + r11]
017b7bd7: and      r8, rax
017b7bda: mov      eax, dword ptr [rsi + r8*8]
017b7bde: cmp      eax, r14d
017b7be1: je       0x17b7c1f
017b7be3: cmp      eax, edi
017b7be5: je       0x17b7c23
017b7be7: inc      edx
017b7be9: cmp      edx, r10d
017b7bec: jb       0x17b7bd0
017b7bee: xor      dl, dl
017b7bf0: divss    xmm1, dword ptr [rcx + 8]
017b7bf5: test     dl, dl
017b7bf7: mov      eax, 0x20
017b7bfc: mov      rdx, qword ptr [rbp - 0x70]
017b7c00: mov      r8d, 0x28
017b7c06: cmove    eax, r8d
017b7c0a: mov      rax, qword ptr [rax + rdx]
017b7c0e: mov      qword ptr [rsp + 0x30], rax
017b7c13: comiss   xmm13, xmm1
017b7c17: jbe      0x17b7c87
017b7c19: movaps   xmm0, xmm13
017b7c1d: jmp      0x17b7c8f
017b7c1f: cmp      eax, edi
017b7c21: jne      0x17b7bee
017b7c23: cmp      dword ptr [rsi + r8*8 + 4], -1
017b7c29: je       0x17b7bee
017b7c2b: mov      r11d, dword ptr [r9 + 0x108]
017b7c32: lea      r12d, [r10 - 1]
017b7c36: imul     r11d, edi
017b7c3a: mov      edx, r13d
017b7c3d: test     r10d, r10d
017b7c40: je       0x17b7c60
017b7c42: mov      eax, r12d
017b7c45: lea      r8d, [rdx + r11]
017b7c49: and      r8, rax
017b7c4c: mov      eax, dword ptr [rsi + r8*8]
017b7c50: cmp      eax, r14d
017b7c53: je       0x17b7c7c
017b7c55: cmp      eax, edi
017b7c57: je       0x17b7c80
017b7c59: inc      edx
017b7c5b: cmp      edx, r10d
017b7c5e: jb       0x17b7c42
017b7c60: mov      eax, 0xffffffff
017b7c65: mov      edx, eax
017b7c67: imul     rax, rdx, 0x1b8
017b7c6e: movzx    edx, byte ptr [rax + r9 + 0x546a90]
017b7c77: jmp      0x17b7bf0
017b7c7c: cmp      eax, edi
017b7c7e: jne      0x17b7c60
017b7c80: mov      eax, dword ptr [rsi + r8*8 + 4]
017b7c85: jmp      0x17b7c65
017b7c87: movaps   xmm0, xmm8
017b7c8b: minss    xmm0, xmm1
017b7c8f: movss    xmm4, dword ptr [r15 + 0x20a0]
017b7c98: movaps   xmm2, xmm8
017b7c9c: movsd    xmm6, qword ptr [rip + 0xc142ec] ; RVA 0x23cbf90
017b7ca4: subss    xmm2, xmm0
017b7ca8: mulss    xmm0, dword ptr [rsp + 0x34]
017b7cae: xorps    xmm1, xmm1
017b7cb1: movss    xmm5, dword ptr [rip + 0xc0f98b] ; RVA 0x23c7644
017b7cb9: mulss    xmm2, dword ptr [rsp + 0x30]
017b7cbf: addss    xmm2, xmm0
017b7cc3: movsd    xmm0, qword ptr [rip + 0xc0eb5d] ; RVA 0x23c6828
017b7ccb: movaps   xmm3, xmm2
017b7cce: subss    xmm3, xmm4
017b7cd2: cvtss2sd xmm1, xmm3
017b7cd6: andps    xmm1, xmm6
017b7cd9: comisd   xmm0, xmm1
017b7cdd: ja       0x17b7d03
017b7cdf: movaps   xmm0, xmm12
017b7ce3: mulss    xmm0, xmm5
017b7ce7: comiss   xmm13, xmm0
017b7ceb: jbe      0x17b7cf3
017b7ced: movaps   xmm2, xmm13
017b7cf1: jmp      0x17b7cfb
017b7cf3: movaps   xmm2, xmm8
017b7cf7: minss    xmm2, xmm0
017b7cfb: mulss    xmm2, xmm3
017b7cff: addss    xmm2, xmm4
017b7d03: movss    dword ptr [r15 + 0x20a0], xmm2
017b7d0c: mov      esi, dword ptr [rip + 0x1ccbf0e] ; RVA 0x3483c20
017b7d12: cmp      edi, esi
017b7d14: je       0x17b7d5e
017b7d16: mov      rax, qword ptr [rip + 0x1b6e87b] ; RVA 0x3326598
017b7d1d: mov      edx, r13d
017b7d20: mov      r8d, dword ptr [rax + 0x20]
017b7d24: mov      r9d, dword ptr [rax + 0x28]
017b7d28: imul     r9d, edi
017b7d2c: lea      r14d, [r8 - 1]
017b7d30: test     r8d, r8d
017b7d33: je       0x17b7d5e
017b7d35: mov      r10, qword ptr [rax + 0x18]
017b7d39: mov      r11d, dword ptr [rax + 0x24]
017b7d3d: nop      dword ptr [rax]
017b7d40: mov      eax, r14d
017b7d43: lea      ecx, [rdx + r9]
017b7d47: and      rcx, rax
017b7d4a: mov      eax, dword ptr [r10 + rcx*8]
017b7d4e: cmp      eax, r11d
017b7d51: je       0x17b7d5e
017b7d53: cmp      eax, edi
017b7d55: je       0x17b7d5e
017b7d57: inc      edx
017b7d59: cmp      edx, r8d
017b7d5c: jb       0x17b7d40
017b7d5e: mov      rdi, qword ptr [r15 + 0x2078]
017b7d65: movss    xmm9, dword ptr [rip + 0xc0ed52] ; RVA 0x23c6ac0
017b7d6e: movss    xmm7, dword ptr [rip + 0xc1027e] ; RVA 0x23c7ff4
017b7d76: mov      qword ptr [rsp + 0x48], rdi
017b7d7b: mov      eax, dword ptr [rdi + 8]
017b7d7e: test     al, 1
017b7d80: je       0x17b7fab
017b7d86: mov      rax, qword ptr [rip + 0x1b6e57b] ; RVA 0x3326308
017b7d8d: mov      rcx, qword ptr [rax + 0xd0]
017b7d94: call     qword ptr [rcx + 0x2b8]
017b7d9a: mulss    xmm14, dword ptr [r15 + 0x20a0]
017b7da3: mov      qword ptr [rsp + 0x30], rax
017b7da8: movss    xmm4, dword ptr [rsp + 0x30]
017b7dae: movss    xmm3, dword ptr [rsp + 0x34]
017b7db4: mov      rax, qword ptr [rip + 0x1cb57a5] ; RVA 0x346d560
017b7dbb: movss    xmm2, dword ptr [r15 + 0x2088]
017b7dc4: mulss    xmm4, xmm9
017b7dc9: mulss    xmm3, xmm9
017b7dce: movaps   xmm0, xmm4
017b7dd1: mulss    xmm0, dword ptr [rax + 0xdc]
017b7dd9: movaps   xmm1, xmm3
017b7ddc: mulss    xmm1, dword ptr [rax + 0xe0]
017b7de4: addss    xmm4, xmm0
017b7de8: addss    xmm3, xmm1
017b7dec: movss    xmm1, dword ptr [r15 + 0x208c]
017b7df5: subss    xmm2, xmm4
017b7df9: subss    xmm1, xmm3
017b7dfd: andps    xmm2, xmmword ptr [rip + 0xc1417c] ; RVA 0x23cbf80
017b7e04: andps    xmm1, xmmword ptr [rip + 0xc14175] ; RVA 0x23cbf80
017b7e0b: maxss    xmm2, xmm1
017b7e0f: addss    xmm2, dword ptr [rdi + 0x48]
017b7e14: maxss    xmm14, xmm2
017b7e19: movaps   xmm0, xmm14
017b7e1d: divss    xmm0, dword ptr [rdi + 0x4c]
017b7e22: comiss   xmm13, xmm0
017b7e26: jbe      0x17b7e2e
017b7e28: movaps   xmm1, xmm13
017b7e2c: jmp      0x17b7e36
017b7e2e: movaps   xmm1, xmm8
017b7e32: minss    xmm1, xmm0
017b7e36: movaps   xmm0, xmm8
017b7e3a: movaps   xmm15, xmm1
017b7e3e: mulss    xmm15, dword ptr [rdi + 0x50]
017b7e44: subss    xmm0, xmm1
017b7e48: addss    xmm15, xmm0
017b7e4d: mov      rdi, qword ptr [rip + 0x1b6eef4] ; RVA 0x3326d48
017b7e54: mov      esi, dword ptr [rip + 0x1ccbdc6] ; RVA 0x3483c20
017b7e5a: mov      r14, qword ptr [rsp + 0x28]
017b7e5f: mov      rax, qword ptr [r15 + 0x2078]
017b7e66: test     byte ptr [rax + 8], 2
017b7e6a: je       0x17b8b33
017b7e70: cmp      ebx, dword ptr [rip + 0x1ccbdbe] ; RVA 0x3483c34
017b7e76: je       0x17b7ed6
017b7e78: mov      rax, qword ptr [rip + 0x1b6ed59] ; RVA 0x3326bd8
017b7e7f: mov      ecx, r13d
017b7e82: mov      r8d, dword ptr [rax + 0x848]
017b7e89: mov      r9d, dword ptr [rax + 0x850]
017b7e90: imul     r9d, ebx
017b7e94: lea      r14d, [r8 - 1]
017b7e98: test     r8d, r8d
017b7e9b: je       0x17b7ed6
017b7e9d: mov      r10, qword ptr [rax + 0x840]
017b7ea4: mov      r11d, dword ptr [rax + 0x84c]
017b7eab: nop      dword ptr [rax + rax]
017b7eb0: mov      eax, r14d
017b7eb3: lea      edx, [rcx + r9]
017b7eb7: and      rdx, rax
017b7eba: mov      eax, dword ptr [r10 + rdx*8]
017b7ebe: cmp      eax, r11d
017b7ec1: je       0x17b86a6
017b7ec7: cmp      eax, ebx
017b7ec9: je       0x17b86ae
017b7ecf: inc      ecx
017b7ed1: cmp      ecx, r8d
017b7ed4: jb       0x17b7eb0
017b7ed6: mov      r11, qword ptr [rip + 0x1b6e783] ; RVA 0x3326660
017b7edd: cmp      ebx, esi
017b7edf: je       0x17b7f27
017b7ee1: mov      r8d, dword ptr [r11 + 0x30]
017b7ee5: mov      ecx, r13d
017b7ee8: mov      r9d, dword ptr [r11 + 0x38]
017b7eec: imul     r9d, ebx
017b7ef0: lea      r12d, [r8 - 1]
017b7ef4: test     r8d, r8d
017b7ef7: je       0x17b7f27
017b7ef9: mov      r10, qword ptr [r11 + 0x28]
017b7efd: mov      r14d, dword ptr [r11 + 0x34]
017b7f01: mov      eax, r12d
017b7f04: lea      edx, [rcx + r9]
017b7f08: and      rdx, rax
017b7f0b: mov      eax, dword ptr [r10 + rdx*8]
017b7f0f: cmp      eax, r14d
017b7f12: je       0x17b8757
017b7f18: cmp      eax, ebx
017b7f1a: je       0x17b875f
017b7f20: inc      ecx
017b7f22: cmp      ecx, r8d
017b7f25: jb       0x17b7f01
017b7f27: mov      eax, 0xffffffff
017b7f2c: mov      ecx, eax
017b7f2e: mov      rax, qword ptr [r11 + 0x58]
017b7f32: movzx    r13d, byte ptr [rcx + rax]
017b7f37: test     r13b, r13b
017b7f3a: jne      0x17b87c6
017b7f40: cmp      ebx, dword ptr [rip + 0x1ccbcee] ; RVA 0x3483c34
017b7f46: je       0x17b87c6
017b7f4c: mov      r8, qword ptr [rip + 0x1b6e84d] ; RVA 0x33267a0
017b7f53: xor      ecx, ecx
017b7f55: mov      r9d, dword ptr [r8 + 0x30]
017b7f59: mov      r10d, dword ptr [r8 + 0x38]
017b7f5d: imul     r10d, ebx
017b7f61: lea      r12d, [r9 - 1]
017b7f65: test     r9d, r9d
017b7f68: je       0x17b87c6
017b7f6e: mov      r11, qword ptr [r8 + 0x28]
017b7f72: mov      r14d, dword ptr [r8 + 0x34]
017b7f76: nop      word ptr [rax + rax]
017b7f80: mov      eax, r12d
017b7f83: lea      edx, [rcx + r10]
017b7f87: and      rdx, rax
017b7f8a: mov      eax, dword ptr [r11 + rdx*8]
017b7f8e: cmp      eax, r14d
017b7f91: je       0x17b8769
017b7f97: cmp      eax, ebx
017b7f99: je       0x17b876d
017b7f9f: inc      ecx
017b7fa1: cmp      ecx, r9d
017b7fa4: jb       0x17b7f80
017b7fa6: jmp      0x17b87c6
017b7fab: mov      rdi, qword ptr [rip + 0x1b6ed96] ; RVA 0x3326d48
017b7fb2: test     al, 4
017b7fb4: je       0x17b7e5a
017b7fba: cmp      ebx, dword ptr [rip + 0x1ccbc74] ; RVA 0x3483c34
017b7fc0: mov      r14, qword ptr [rip + 0x1b6ec59] ; RVA 0x3326c20
017b7fc7: je       0x17b8020
017b7fc9: mov      r8d, dword ptr [r14 + 0x28]
017b7fcd: mov      ecx, r13d
017b7fd0: mov      r9d, dword ptr [r14 + 0x30]
017b7fd4: imul     r9d, ebx
017b7fd8: lea      r12d, [r8 - 1]
017b7fdc: test     r8d, r8d
017b7fdf: je       0x17b8020
017b7fe1: mov      r10, qword ptr [r14 + 0x20]
017b7fe5: mov      r11d, dword ptr [r14 + 0x2c]
017b7fe9: nop      dword ptr [rax]
017b7ff0: mov      eax, r12d
017b7ff3: lea      edx, [rcx + r9]
017b7ff7: and      rdx, rax
017b7ffa: mov      eax, dword ptr [r10 + rdx*8]
017b7ffe: cmp      eax, r11d
017b8001: je       0x17b8010
017b8003: cmp      eax, ebx
017b8005: je       0x17b8014
017b8007: inc      ecx
017b8009: cmp      ecx, r8d
017b800c: jb       0x17b7ff0
017b800e: jmp      0x17b8020
017b8010: cmp      eax, ebx
017b8012: jne      0x17b8020
017b8014: cmp      dword ptr [r10 + rdx*8 + 4], -1
017b801a: jne      0x17b8107
017b8020: cmp      ebx, esi
017b8022: je       0x17b8080
017b8024: mov      r8d, dword ptr [rdi + 0x30]
017b8028: mov      ecx, r13d
017b802b: mov      r9d, dword ptr [rdi + 0x38]
017b802f: imul     r9d, ebx
017b8033: lea      r12d, [r8 - 1]
017b8037: test     r8d, r8d
017b803a: je       0x17b8080
017b803c: mov      r10, qword ptr [rdi + 0x28]
017b8040: mov      r11d, dword ptr [rdi + 0x34]
017b8044: nop      dword ptr [rax]
017b8048: nop      dword ptr [rax + rax]
017b8050: mov      eax, r12d
017b8053: lea      edx, [rcx + r9]
017b8057: and      rdx, rax
017b805a: mov      eax, dword ptr [r10 + rdx*8]
017b805e: cmp      eax, r11d
017b8061: je       0x17b8070
017b8063: cmp      eax, ebx
017b8065: je       0x17b8074
017b8067: inc      ecx
017b8069: cmp      ecx, r8d
017b806c: jb       0x17b8050
017b806e: jmp      0x17b8080
017b8070: cmp      eax, ebx
017b8072: jne      0x17b8080
017b8074: cmp      dword ptr [r10 + rdx*8 + 4], -1
017b807a: jne      0x17b8107
017b8080: cmp      ebx, dword ptr [rip + 0x1ccbbae] ; RVA 0x3483c34
017b8086: je       0x17b80de
017b8088: mov      rax, qword ptr [rip + 0x1b6eb49] ; RVA 0x3326bd8
017b808f: mov      ecx, r13d
017b8092: mov      r8d, dword ptr [rax + 0x848]
017b8099: mov      r9d, dword ptr [rax + 0x850]
017b80a0: imul     r9d, ebx
017b80a4: lea      r12d, [r8 - 1]
017b80a8: test     r8d, r8d
017b80ab: je       0x17b80de
017b80ad: mov      r10, qword ptr [rax + 0x840]
017b80b4: mov      r11d, dword ptr [rax + 0x84c]
017b80bb: nop      dword ptr [rax + rax]
017b80c0: mov      eax, r12d
017b80c3: lea      edx, [rcx + r9]
017b80c7: and      rdx, rax
017b80ca: mov      eax, dword ptr [r10 + rdx*8]
017b80ce: cmp      eax, r11d
017b80d1: je       0x17b80eb
017b80d3: cmp      eax, ebx
017b80d5: je       0x17b80ef
017b80d7: inc      ecx
017b80d9: cmp      ecx, r8d
017b80dc: jb       0x17b80c0
017b80de: mov      byte ptr [r15 + 0x209a], 1
017b80e6: jmp      0x17b8d84
017b80eb: cmp      eax, ebx
017b80ed: jne      0x17b80de
017b80ef: cmp      dword ptr [r10 + rdx*8 + 4], -1
017b80f5: je       0x17b80de
017b80f7: mov      rcx, qword ptr [rsp + 0x40]
017b80fc: call     0x506fe0
017b8101: cmp      byte ptr [rax + 0x1c], 0
017b8105: je       0x17b80de
017b8107: cmp      ebx, dword ptr [rip + 0x1ccbb27] ; RVA 0x3483c34
017b810d: je       0x17b81c6
017b8113: mov      r8d, dword ptr [r14 + 0x28]
017b8117: mov      ecx, r13d
017b811a: mov      r9d, dword ptr [r14 + 0x30]
017b811e: imul     r9d, ebx
017b8122: lea      r12d, [r8 - 1]
017b8126: test     r8d, r8d
017b8129: je       0x17b8166
017b812b: mov      r10, qword ptr [r14 + 0x20]
017b812f: mov      r11d, dword ptr [r14 + 0x2c]
017b8133: nop      dword ptr [rax]
017b8137: nop      word ptr [rax + rax]
017b8140: mov      eax, r12d
017b8143: lea      edx, [rcx + r9]
017b8147: and      rdx, rax
017b814a: mov      eax, dword ptr [r10 + rdx*8]
017b814e: cmp      eax, r11d
017b8151: je       0x17b821d
017b8157: cmp      eax, ebx
017b8159: je       0x17b8225
017b815f: inc      ecx
017b8161: cmp      ecx, r8d
017b8164: jb       0x17b8140
017b8166: mov      rax, qword ptr [rip + 0x1b6ea6b] ; RVA 0x3326bd8
017b816d: mov      ecx, r13d
017b8170: mov      r8d, dword ptr [rax + 0x848]
017b8177: mov      r9d, dword ptr [rax + 0x850]
017b817e: imul     r9d, ebx
017b8182: lea      r14d, [r8 - 1]
017b8186: test     r8d, r8d
017b8189: je       0x17b81c6
017b818b: mov      r10, qword ptr [rax + 0x840]
017b8192: mov      r11d, dword ptr [rax + 0x84c]
017b8199: nop      dword ptr [rax]
017b81a0: mov      eax, r14d
017b81a3: lea      edx, [rcx + r9]
017b81a7: and      rdx, rax
017b81aa: mov      eax, dword ptr [r10 + rdx*8]
017b81ae: cmp      eax, r11d
017b81b1: je       0x17b8480
017b81b7: cmp      eax, ebx
017b81b9: je       0x17b8488
017b81bf: inc      ecx
017b81c1: cmp      ecx, r8d
017b81c4: jb       0x17b81a0
017b81c6: cmp      ebx, esi
017b81c8: je       0x17b7e5a
017b81ce: mov      r8d, dword ptr [rdi + 0x30]
017b81d2: mov      ecx, r13d
017b81d5: mov      r9d, dword ptr [rdi + 0x38]
017b81d9: imul     r9d, ebx
017b81dd: lea      r14d, [r8 - 1]
017b81e1: test     r8d, r8d
017b81e4: je       0x17b7e5a
017b81ea: mov      r10, qword ptr [rdi + 0x28]
017b81ee: mov      r11d, dword ptr [rdi + 0x34]
017b81f2: mov      eax, r14d
017b81f5: lea      edx, [rcx + r9]
017b81f9: and      rdx, rax
017b81fc: mov      eax, dword ptr [r10 + rdx*8]
017b8200: cmp      eax, r11d
017b8203: je       0x17b8591
017b8209: cmp      eax, ebx
017b820b: je       0x17b8599
017b8211: inc      ecx
017b8213: cmp      ecx, r8d
017b8216: jb       0x17b81f2
017b8218: jmp      0x17b7e5a
017b821d: cmp      eax, ebx
017b821f: jne      0x17b8166
017b8225: cmp      dword ptr [r10 + rdx*8 + 4], -1
017b822b: je       0x17b8166
017b8231: mov      r11d, dword ptr [r14 + 0x30]
017b8235: lea      r12d, [r8 - 1]
017b8239: mov      r9d, r11d
017b823c: mov      ecx, r13d
017b823f: imul     r9d, ebx
017b8243: test     r8d, r8d
017b8246: je       0x17b8275
017b8248: mov      esi, dword ptr [r14 + 0x2c]
017b824c: nop      dword ptr [rax]
017b8250: mov      eax, r12d
017b8253: lea      edx, [rcx + r9]
017b8257: and      rdx, rax
017b825a: mov      eax, dword ptr [r10 + rdx*8]
017b825e: cmp      eax, esi
017b8260: je       0x17b82f9
017b8266: cmp      eax, ebx
017b8268: je       0x17b8301
017b826e: inc      ecx
017b8270: cmp      ecx, r8d
017b8273: jb       0x17b8250
017b8275: mov      eax, 0xffffffff
017b827a: mov      ecx, eax
017b827c: lea      esi, [r8 - 1]
017b8280: imul     r11d, ebx
017b8284: lea      r12, [rcx + rcx*4]
017b8288: mov      ecx, r13d
017b828b: test     r8d, r8d
017b828e: je       0x17b82bd
017b8290: mov      r9, r10
017b8293: mov      r10d, dword ptr [r14 + 0x2c]
017b8297: nop      word ptr [rax + rax]
017b82a0: mov      eax, esi
017b82a2: lea      edx, [rcx + r11]
017b82a6: and      rdx, rax
017b82a9: mov      eax, dword ptr [r9 + rdx*8]
017b82ad: cmp      eax, r10d
017b82b0: je       0x17b830b
017b82b2: cmp      eax, ebx
017b82b4: je       0x17b830f
017b82b6: inc      ecx
017b82b8: cmp      ecx, r8d
017b82bb: jb       0x17b82a0
017b82bd: mov      eax, 0xffffffff
017b82c2: mov      rcx, qword ptr [r14 + 0x38]
017b82c6: mov      edx, eax
017b82c8: mov      rcx, qword ptr [rcx + rdx*8]
017b82cc: call     0x5052c0
017b82d1: movss    xmm3, dword ptr [rax + 0x18]
017b82d6: movss    xmm4, dword ptr [rax + 0x30]
017b82db: mov      rax, qword ptr [r14 + 0x40]
017b82df: movss    xmm0, dword ptr [rax + r12*8 + 4]
017b82e6: movaps   xmm2, xmm0
017b82e9: divss    xmm2, xmm3
017b82ed: comiss   xmm13, xmm2
017b82f1: jbe      0x17b8316
017b82f3: movaps   xmm1, xmm13
017b82f7: jmp      0x17b831e
017b82f9: cmp      eax, ebx
017b82fb: jne      0x17b8275
017b8301: mov      eax, dword ptr [r10 + rdx*8 + 4]
017b8306: jmp      0x17b827a
017b830b: cmp      eax, ebx
017b830d: jne      0x17b82bd
017b830f: mov      eax, dword ptr [r9 + rdx*8 + 4]
017b8314: jmp      0x17b82c2
017b8316: movaps   xmm1, xmm8
017b831a: minss    xmm1, xmm2
017b831e: comiss   xmm0, xmm3
017b8321: subss    xmm0, xmm3
017b8325: subss    xmm4, xmm3
017b8329: seta     al
017b832c: divss    xmm0, xmm4
017b8330: comiss   xmm13, xmm0
017b8334: jbe      0x17b833c
017b8336: movaps   xmm4, xmm13
017b833a: jmp      0x17b8344
017b833c: movaps   xmm4, xmm8
017b8340: minss    xmm4, xmm0
017b8344: test     al, al
017b8346: je       0x17b8450
017b834c: movaps   xmm0, xmm4
017b834f: mulss    xmm0, dword ptr [rip + 0xc0eb81] ; RVA 0x23c6ed8
017b8357: comiss   xmm13, xmm0
017b835b: jbe      0x17b8363
017b835d: movaps   xmm3, xmm13
017b8361: jmp      0x17b836b
017b8363: movaps   xmm3, xmm8
017b8367: minss    xmm3, xmm0
017b836b: mov      rax, qword ptr [rip + 0x1ccb8c6] ; RVA 0x3483c38
017b8372: movabs   rcx, 0x5851f42d4c957f2d
017b837c: imul     rax, rcx
017b8380: movabs   rcx, 0x14057b7ef767814f
017b838a: add      rax, rcx
017b838d: mov      qword ptr [rip + 0x1ccb8a4], rax ; RVA 0x3483c38
017b8394: movss    xmm1, dword ptr [r15 + 0x20ac]
017b839d: comiss   xmm13, xmm1
017b83a1: jbe      0x17b83a8
017b83a3: movaps   xmm0, xmm7
017b83a6: jmp      0x17b83ac
017b83a8: movaps   xmm0, xmm8
017b83ac: xorps    xmm2, xmm2
017b83af: shr      rax, 0x20
017b83b3: cvtsi2ss xmm2, rax
017b83b8: mulss    xmm2, dword ptr [rip + 0xc0e168] ; RVA 0x23c6528
017b83c0: mulss    xmm2, dword ptr [rip + 0xc0f528] ; RVA 0x23c78f0
017b83c8: mulss    xmm2, xmm3
017b83cc: mulss    xmm3, xmm5
017b83d0: mulss    xmm2, xmm0
017b83d4: xorps    xmm0, xmm0
017b83d7: cvtss2sd xmm0, xmm3
017b83db: addss    xmm2, xmm1
017b83df: movaps   xmm5, xmm2
017b83e2: movss    dword ptr [r15 + 0x20ac], xmm2
017b83eb: mulss    xmm5, xmm12
017b83f0: addss    xmm5, dword ptr [r15 + 0x20b0]
017b83f9: cvtps2pd xmm1, xmm5
017b83fc: movss    dword ptr [r15 + 0x20b0], xmm5
017b8405: andps    xmm1, xmm6
017b8408: comisd   xmm1, xmm0
017b840c: jb       0x17b8437
017b840e: comiss   xmm13, xmm5
017b8412: jbe      0x17b8419
017b8414: movaps   xmm0, xmm7
017b8417: jmp      0x17b841d
017b8419: movaps   xmm0, xmm8
017b841d: mulss    xmm3, xmm0
017b8421: mulss    xmm2, xmm7
017b8425: movss    dword ptr [r15 + 0x20b0], xmm3
017b842e: movss    dword ptr [r15 + 0x20ac], xmm2
017b8437: movaps   xmm0, xmm8
017b843b: movaps   xmm1, xmm4
017b843e: mulss    xmm1, dword ptr [rip + 0xc0e876] ; RVA 0x23c6cbc
017b8446: subss    xmm0, xmm4
017b844a: addss    xmm1, xmm0
017b844e: jmp      0x17b845b
017b8450: mov      qword ptr [r15 + 0x20ac], 0
017b845b: mov      rax, qword ptr [rsp + 0x48]
017b8460: movaps   xmm0, xmm8
017b8464: subss    xmm0, xmm1
017b8468: mulss    xmm1, dword ptr [rax + 0x64]
017b846d: mulss    xmm0, xmm14
017b8472: movaps   xmm14, xmm0
017b8476: addss    xmm14, xmm1
017b847b: jmp      0x17b7e54
017b8480: cmp      eax, ebx
017b8482: jne      0x17b81c6
017b8488: cmp      dword ptr [r10 + rdx*8 + 4], -1
017b848e: je       0x17b81c6
017b8494: mov      r11, qword ptr [rip + 0x1b6e73d] ; RVA 0x3326bd8
017b849b: mov      ecx, r13d
017b849e: mov      r8d, dword ptr [r11 + 0x848]
017b84a5: mov      r9d, dword ptr [r11 + 0x850]
017b84ac: imul     r9d, ebx
017b84b0: lea      esi, [r8 - 1]
017b84b4: test     r8d, r8d
017b84b7: je       0x17b84f4
017b84b9: mov      r10, qword ptr [r11 + 0x840]
017b84c0: mov      edi, dword ptr [r11 + 0x84c]
017b84c7: nop      word ptr [rax + rax]
017b84d0: mov      eax, esi
017b84d2: lea      edx, [rcx + r9]
017b84d6: and      rdx, rax
017b84d9: mov      eax, dword ptr [r10 + rdx*8]
017b84dd: cmp      eax, edi
017b84df: je       0x17b857f
017b84e5: cmp      eax, ebx
017b84e7: je       0x17b8587
017b84ed: inc      ecx
017b84ef: cmp      ecx, r8d
017b84f2: jb       0x17b84d0
017b84f4: mov      eax, 0xffffffff
017b84f9: mov      ecx, eax
017b84fb: movaps   xmm2, xmm8
017b84ff: mov      rax, qword ptr [r11 + 0x870]
017b8506: movaps   xmm1, xmm8
017b850a: lea      rdx, [rcx + rcx*4]
017b850e: minss    xmm2, dword ptr [rax + rdx*4 + 4]
017b8514: mov      rax, qword ptr [rsp + 0x48]
017b8519: lea      rcx, [r15 + 0xaf8]
017b8520: mov      qword ptr [r15 + 0x20ac], 0
017b852b: subss    xmm1, xmm2
017b852f: movaps   xmm0, xmm2
017b8532: mulss    xmm0, dword ptr [rax + 0x64]
017b8537: mulss    xmm1, xmm14
017b853c: movaps   xmm14, xmm1
017b8540: movaps   xmm1, xmm13
017b8544: addss    xmm14, xmm0
017b8549: call     0x1448a40
017b854e: lea      rcx, [r15 + 0xc50]
017b8555: call     0x1448a40
017b855a: lea      rcx, [r15 + 0xda8]
017b8561: call     0x1448a40
017b8566: ucomiss  xmm2, xmm13
017b856a: jp       0x17b7e4d
017b8570: jne      0x17b7e4d
017b8576: movaps   xmm15, xmm13
017b857a: jmp      0x17b7e4d
017b857f: cmp      eax, ebx
017b8581: jne      0x17b84f4
017b8587: mov      eax, dword ptr [r10 + rdx*8 + 4]
017b858c: jmp      0x17b84f9
017b8591: cmp      eax, ebx
017b8593: jne      0x17b7e5a
017b8599: cmp      dword ptr [r10 + rdx*8 + 4], -1
017b859f: je       0x17b7e5a
017b85a5: mov      r9d, dword ptr [rdi + 0x38]
017b85a9: lea      r14d, [r8 - 1]
017b85ad: imul     r9d, ebx
017b85b1: mov      ecx, r13d
017b85b4: test     r8d, r8d
017b85b7: je       0x17b85e6
017b85b9: nop      dword ptr [rax]
017b85c0: mov      eax, r14d
017b85c3: lea      edx, [rcx + r9]
017b85c7: and      rdx, rax
017b85ca: mov      eax, dword ptr [r10 + rdx*8]
017b85ce: cmp      eax, r11d
017b85d1: je       0x17b8689
017b85d7: cmp      eax, ebx
017b85d9: je       0x17b8691
017b85df: inc      ecx
017b85e1: cmp      ecx, r8d
017b85e4: jb       0x17b85c0
017b85e6: mov      eax, 0xffffffff
017b85eb: mov      rcx, qword ptr [rdi + 0x40]
017b85ef: mov      edx, eax
017b85f1: mov      rcx, qword ptr [rcx + rdx*8]
017b85f5: call     0x50e1f0
017b85fa: mov      r8d, dword ptr [rdi + 0x30]
017b85fe: mov      r12, rax
017b8601: mov      r9d, dword ptr [rdi + 0x38]
017b8605: mov      ecx, r13d
017b8608: imul     r9d, ebx
017b860c: lea      r14d, [r8 - 1]
017b8610: test     r8d, r8d
017b8613: je       0x17b863e
017b8615: mov      r10, qword ptr [rdi + 0x28]
017b8619: mov      r11d, dword ptr [rdi + 0x34]
017b861d: nop      dword ptr [rax]
017b8620: mov      eax, r14d
017b8623: lea      edx, [rcx + r9]
017b8627: and      rdx, rax
017b862a: mov      eax, dword ptr [r10 + rdx*8]
017b862e: cmp      eax, r11d
017b8631: je       0x17b869b
017b8633: cmp      eax, ebx
017b8635: je       0x17b869f
017b8637: inc      ecx
017b8639: cmp      ecx, r8d
017b863c: jb       0x17b8620
017b863e: mov      eax, 0xffffffff
017b8643: mov      r14, qword ptr [rsp + 0x28]
017b8648: movaps   xmm14, xmm8
017b864c: mov      ecx, eax
017b864e: mov      rax, qword ptr [rdi + 0x50]
017b8652: lea      rdx, [rcx + rcx*8]
017b8656: movss    xmm0, dword ptr [rax + rdx*8 + 0xc]
017b865c: divss    xmm0, dword ptr [r12 + 0x94]
017b8666: mov      rax, qword ptr [rsp + 0x48]
017b866b: mulss    xmm0, xmm0
017b866f: subss    xmm14, xmm0
017b8674: mulss    xmm0, dword ptr [rax + 0x64]
017b8679: mulss    xmm14, dword ptr [r14 + 0x14]
017b867f: addss    xmm14, xmm0
017b8684: jmp      0x17b7e5f
017b8689: cmp      eax, ebx
017b868b: jne      0x17b85e6
017b8691: mov      eax, dword ptr [r10 + rdx*8 + 4]
017b8696: jmp      0x17b85eb
017b869b: cmp      eax, ebx
017b869d: jne      0x17b863e
017b869f: mov      eax, dword ptr [r10 + rdx*8 + 4]
017b86a4: jmp      0x17b8643
017b86a6: cmp      eax, ebx
017b86a8: jne      0x17b7ed6
017b86ae: cmp      dword ptr [r10 + rdx*8 + 4], -1
017b86b4: je       0x17b7ed6
017b86ba: mov      rcx, qword ptr [rsp + 0x40]
017b86bf: call     0x506fe0
017b86c4: cmp      byte ptr [rax + 0x1c], 0
017b86c8: je       0x17b7ed6
017b86ce: mov      r11, qword ptr [rip + 0x1b6e503] ; RVA 0x3326bd8
017b86d5: mov      ecx, r13d
017b86d8: mov      r8d, dword ptr [r11 + 0x848]
017b86df: mov      r9d, dword ptr [r11 + 0x850]
017b86e6: imul     r9d, ebx
017b86ea: lea      esi, [r8 - 1]
017b86ee: test     r8d, r8d
017b86f1: je       0x17b871d
017b86f3: mov      r10, qword ptr [r11 + 0x840]
017b86fa: mov      edi, dword ptr [r11 + 0x84c]
017b8701: mov      eax, esi
017b8703: lea      edx, [rcx + r9]
017b8707: and      rdx, rax
017b870a: mov      eax, dword ptr [r10 + rdx*8]
017b870e: cmp      eax, edi
017b8710: je       0x17b874c
017b8712: cmp      eax, ebx
017b8714: je       0x17b8750
017b8716: inc      ecx
017b8718: cmp      ecx, r8d
017b871b: jb       0x17b8701
017b871d: mov      eax, 0xffffffff
017b8722: mov      ecx, eax
017b8724: movaps   xmm1, xmm8
017b8728: mov      rax, qword ptr [r11 + 0x870]
017b872f: lea      rdx, [rcx + rcx*4]
017b8733: minss    xmm1, dword ptr [rax + rdx*4 + 4]
017b8739: mulss    xmm1, xmm10
017b873e: movss    dword ptr [r15 + 0x20b0], xmm1
017b8747: jmp      0x17b89d6
017b874c: cmp      eax, ebx
017b874e: jne      0x17b871d
017b8750: mov      eax, dword ptr [r10 + rdx*8 + 4]
017b8755: jmp      0x17b8722
017b8757: cmp      eax, ebx
017b8759: jne      0x17b7f27
017b875f: mov      eax, dword ptr [r10 + rdx*8 + 4]
017b8764: jmp      0x17b7f2c
017b8769: cmp      eax, ebx
017b876b: jne      0x17b87c6
017b876d: cmp      dword ptr [r11 + rdx*8 + 4], -1
017b8773: je       0x17b87c6
017b8775: mov      r10d, dword ptr [r8 + 0x38]
017b8779: lea      r12d, [r9 - 1]
017b877d: imul     r10d, ebx
017b8781: xor      ecx, ecx
017b8783: test     r9d, r9d
017b8786: je       0x17b87b6
017b8788: nop      dword ptr [rax + rax]
017b8790: mov      eax, r12d
017b8793: lea      edx, [rcx + r10]
017b8797: and      rdx, rax
017b879a: mov      eax, dword ptr [r11 + rdx*8]
017b879e: cmp      eax, r14d
017b87a1: je       0x17b8851
017b87a7: cmp      eax, ebx
017b87a9: je       0x17b8859
017b87af: inc      ecx
017b87b1: cmp      ecx, r9d
017b87b4: jb       0x17b8790
017b87b6: mov      eax, 0xffffffff
017b87bb: mov      ecx, eax
017b87bd: mov      rax, qword ptr [r8 + 0x48]
017b87c1: movzx    r13d, byte ptr [rax + rcx*8]
017b87c6: cmp      ebx, esi
017b87c8: je       0x17b880d
017b87ca: mov      r8d, dword ptr [rdi + 0x30]
017b87ce: xor      ecx, ecx
017b87d0: mov      r9d, dword ptr [rdi + 0x38]
017b87d4: imul     r9d, ebx
017b87d8: lea      esi, [r8 - 1]
017b87dc: test     r8d, r8d
017b87df: je       0x17b880d
017b87e1: mov      r10, qword ptr [rdi + 0x28]
017b87e5: mov      r11d, dword ptr [rdi + 0x34]
017b87e9: nop      dword ptr [rax]
017b87f0: mov      eax, esi
017b87f2: lea      edx, [rcx + r9]
017b87f6: and      rdx, rax
017b87f9: mov      eax, dword ptr [r10 + rdx*8]
017b87fd: cmp      eax, r11d
017b8800: je       0x17b8863
017b8802: cmp      eax, ebx
017b8804: je       0x17b8867
017b8806: inc      ecx
017b8808: cmp      ecx, r8d
017b880b: jb       0x17b87f0
017b880d: mov      rax, qword ptr [r15 + 0x2078]
017b8814: movss    xmm2, dword ptr [rax + 0x5c]
017b8819: test     r13b, r13b
017b881c: je       0x17b894f
017b8822: xor      r13d, r13d
017b8825: movss    xmm1, dword ptr [rax + 0x54]
017b882a: movaps   xmm0, xmm12
017b882e: mulss    xmm0, dword ptr [rax + 0x58]
017b8833: addss    xmm0, dword ptr [r15 + 0x20ac]
017b883c: comiss   xmm1, xmm0
017b883f: ja       0x17b897b
017b8845: movaps   xmm1, xmm2
017b8848: minss    xmm1, xmm0
017b884c: jmp      0x17b897b
017b8851: cmp      eax, ebx
017b8853: jne      0x17b87b6
017b8859: mov      eax, dword ptr [r11 + rdx*8 + 4]
017b885e: jmp      0x17b87bb
017b8863: cmp      eax, ebx
017b8865: jne      0x17b880d
017b8867: cmp      dword ptr [r10 + rdx*8 + 4], -1
017b886d: je       0x17b880d
017b886f: test     r13b, r13b
017b8872: jne      0x17b88df
017b8874: mov      r9d, dword ptr [rdi + 0x38]
017b8878: lea      esi, [r8 - 1]
017b887c: xor      r13d, r13d
017b887f: imul     r9d, ebx
017b8883: mov      ecx, r13d
017b8886: test     r8d, r8d
017b8889: je       0x17b88ad
017b888b: nop      dword ptr [rax + rax]
017b8890: mov      eax, esi
017b8892: lea      edx, [rcx + r9]
017b8896: and      rdx, rax
017b8899: mov      eax, dword ptr [r10 + rdx*8]
017b889d: cmp      eax, r11d
017b88a0: je       0x17b88d4
017b88a2: cmp      eax, ebx
017b88a4: je       0x17b88d8
017b88a6: inc      ecx
017b88a8: cmp      ecx, r8d
017b88ab: jb       0x17b8890
017b88ad: mov      eax, 0xffffffff
017b88b2: mov      ecx, eax
017b88b4: mov      rax, qword ptr [rdi + 0x58]
017b88b8: lea      rdx, [rcx + rcx*2]
017b88bc: cmp      byte ptr [rax + rdx*4 + 9], r13b
017b88c1: jne      0x17b88e2
017b88c3: mov      rax, qword ptr [r15 + 0x2078]
017b88ca: movss    xmm2, dword ptr [rax + 0x5c]
017b88cf: jmp      0x17b8952
017b88d4: cmp      eax, ebx
017b88d6: jne      0x17b88ad
017b88d8: mov      eax, dword ptr [r10 + rdx*8 + 4]
017b88dd: jmp      0x17b88b2
017b88df: xor      r13d, r13d
017b88e2: mov      r9d, dword ptr [rdi + 0x38]
017b88e6: lea      esi, [r8 - 1]
017b88ea: imul     r9d, ebx
017b88ee: mov      ecx, r13d
017b88f1: test     r8d, r8d
017b88f4: je       0x17b891d
017b88f6: nop      word ptr [rax + rax]
017b8900: mov      eax, esi
017b8902: lea      edx, [rcx + r9]
017b8906: and      rdx, rax
017b8909: mov      eax, dword ptr [r10 + rdx*8]
017b890d: cmp      eax, r11d
017b8910: je       0x17b8944
017b8912: cmp      eax, ebx
017b8914: je       0x17b8948
017b8916: inc      ecx
017b8918: cmp      ecx, r8d
017b891b: jb       0x17b8900
017b891d: mov      eax, 0xffffffff
017b8922: mov      ecx, eax
017b8924: mov      rax, qword ptr [rdi + 0x50]
017b8928: lea      rdx, [rcx + rcx*8]
017b892c: cmp      byte ptr [rax + rdx*8 + 0x11], 0
017b8931: jne      0x17b88c3
017b8933: mov      rax, qword ptr [r15 + 0x2078]
017b893a: movss    xmm2, dword ptr [rax + 0x5c]
017b893f: jmp      0x17b8825
017b8944: cmp      eax, ebx
017b8946: jne      0x17b891d
017b8948: mov      eax, dword ptr [r10 + rdx*8 + 4]
017b894d: jmp      0x17b8922
017b894f: xor      r13d, r13d
017b8952: movss    xmm3, dword ptr [r15 + 0x20ac]
017b895b: movaps   xmm0, xmm12
017b895f: mulss    xmm0, dword ptr [rax + 0x60]
017b8964: subss    xmm3, xmm0
017b8968: comiss   xmm13, xmm3
017b896c: jbe      0x17b8974
017b896e: movaps   xmm1, xmm13
017b8972: jmp      0x17b897b
017b8974: movaps   xmm1, xmm2
017b8977: minss    xmm1, xmm3
017b897b: movss    dword ptr [r15 + 0x20ac], xmm1
017b8984: mulss    xmm1, xmm12
017b8989: addss    xmm1, dword ptr [r15 + 0x20b0]
017b8992: comiss   xmm1, xmm10
017b8996: movss    dword ptr [r15 + 0x20b0], xmm1
017b899f: ja       0x17b89ae
017b89a1: movss    xmm0, dword ptr [rip + 0xc0f98b] ; RVA 0x23c8334
017b89a9: comiss   xmm0, xmm1
017b89ac: jbe      0x17b89d6
017b89ae: comiss   xmm13, xmm1
017b89b2: jbe      0x17b89b9
017b89b4: movaps   xmm0, xmm7
017b89b7: jmp      0x17b89bd
017b89b9: movaps   xmm0, xmm8
017b89bd: mulss    xmm0, xmm7
017b89c1: mulss    xmm0, xmm10
017b89c6: addss    xmm0, xmm1
017b89ca: movss    dword ptr [r15 + 0x20b0], xmm0
017b89d3: movaps   xmm1, xmm0
017b89d6: mov      r14, qword ptr [rsp + 0x28]
017b89db: mov      ecx, r13d
017b89de: mov      r8d, dword ptr [r14 + 8]
017b89e2: test     r8d, r8d
017b89e5: jle      0x17b8b33
017b89eb: cmp      r8d, 0x10
017b89ef: jb       0x17b8ae8
017b89f5: movss    xmm2, dword ptr [r14 + 0xc]
017b89fb: mov      eax, r8d
017b89fe: movdqa   xmm5, xmmword ptr [rip + 0xc1073a] ; RVA 0x23c9140
017b8a06: movaps   xmm3, xmm1
017b8a09: movd     xmm0, r8d
017b8a0e: pshufd   xmm0, xmm0, 0
017b8a13: shufps   xmm2, xmm2, 0
017b8a17: shufps   xmm3, xmm3, 0
017b8a1b: and      eax, 0x8000000f
017b8a20: jge      0x17b8a29
017b8a22: dec      eax
017b8a24: or       eax, 0xfffffff0
017b8a27: inc      eax
017b8a29: movaps   xmm4, xmmword ptr [rip + 0xc134e0] ; RVA 0x23cbf10
017b8a30: lea      r9, [rbp - 0x30]
017b8a34: cvtdq2ps xmm0, xmm0
017b8a37: mov      edx, r8d
017b8a3a: mov      r10d, 8
017b8a40: sub      edx, eax
017b8a42: divps    xmm4, xmm0
017b8a45: nop      word ptr [rax + rax]
017b8a50: lea      eax, [r10 - 4]
017b8a54: movd     xmm0, ecx
017b8a58: pshufd   xmm0, xmm0, 0
017b8a5d: add      ecx, 0x10
017b8a60: paddd    xmm0, xmm5
017b8a64: cvtdq2ps xmm1, xmm0
017b8a67: movd     xmm0, eax
017b8a6b: lea      eax, [r10 + 4]
017b8a6f: mulps    xmm1, xmm4
017b8a72: pshufd   xmm0, xmm0, 0
017b8a77: paddd    xmm0, xmm5
017b8a7b: addps    xmm1, xmm2
017b8a7e: addps    xmm1, xmm3
017b8a81: movups   xmmword ptr [r9 - 0x20], xmm1
017b8a86: cvtdq2ps xmm1, xmm0
017b8a89: movd     xmm0, r10d
017b8a8e: add      r10d, 0x10
017b8a92: mulps    xmm1, xmm4
017b8a95: pshufd   xmm0, xmm0, 0
017b8a9a: paddd    xmm0, xmm5
017b8a9e: addps    xmm1, xmm2
017b8aa1: addps    xmm1, xmm3
017b8aa4: movups   xmmword ptr [r9 - 0x10], xmm1
017b8aa9: cvtdq2ps xmm1, xmm0
017b8aac: movd     xmm0, eax
017b8ab0: mulps    xmm1, xmm4
017b8ab3: pshufd   xmm0, xmm0, 0
017b8ab8: paddd    xmm0, xmm5
017b8abc: addps    xmm1, xmm2
017b8abf: addps    xmm1, xmm3
017b8ac2: movups   xmmword ptr [r9], xmm1
017b8ac6: cvtdq2ps xmm1, xmm0
017b8ac9: mulps    xmm1, xmm4
017b8acc: addps    xmm1, xmm2
017b8acf: addps    xmm1, xmm3
017b8ad2: movups   xmmword ptr [r9 + 0x10], xmm1
017b8ad7: add      r9, 0x40
017b8adb: cmp      ecx, edx
017b8add: jl       0x17b8a50
017b8ae3: cmp      ecx, r8d
017b8ae6: jge      0x17b8b33
017b8ae8: movss    xmm1, dword ptr [r14 + 0xc]
017b8aee: lea      rdx, [rbp - 0x50]
017b8af2: movss    xmm2, dword ptr [r15 + 0x20b0]
017b8afb: movd     xmm0, r8d
017b8b00: cvtdq2ps xmm0, xmm0
017b8b03: movsxd   rax, ecx
017b8b06: lea      rdx, [rdx + rax*4]
017b8b0a: divss    xmm10, xmm0
017b8b0f: nop      
017b8b10: movd     xmm0, ecx
017b8b14: inc      ecx
017b8b16: cvtdq2ps xmm0, xmm0
017b8b19: mulss    xmm0, xmm10
017b8b1e: addss    xmm0, xmm1
017b8b22: addss    xmm0, xmm2
017b8b26: movss    dword ptr [rdx], xmm0
017b8b2a: add      rdx, 4
017b8b2e: cmp      ecx, r8d
017b8b31: jl       0x17b8b10
017b8b33: mov      rax, qword ptr [r15 + 0x2078]
017b8b3a: cmp      byte ptr [rax + 0xc], 0
017b8b3e: je       0x17b8b9b
017b8b40: cmp      byte ptr [r15 + 0x209b], 0
017b8b48: je       0x17b8b6d
017b8b4a: lea      rcx, [r15 + 0xaf8]
017b8b51: movaps   xmm1, xmm8
017b8b55: call     0x1448a40
017b8b5a: cmp      byte ptr [r15 + 0x209c], 0
017b8b62: je       0x17b8b9b
017b8b64: lea      rcx, [r15 + 0xda8]
017b8b6b: jmp      0x17b8b92
017b8b6d: movss    xmm1, dword ptr [rip + 0xc0de73] ; RVA 0x23c69e8
017b8b75: lea      rcx, [r15 + 0xc50]
017b8b7c: call     0x1448a40
017b8b81: cmp      byte ptr [r15 + 0x209c], 0
017b8b89: je       0x17b8b9b
017b8b8b: lea      rcx, [r15 + 0x9a0]
017b8b92: movaps   xmm1, xmm8
017b8b96: call     0x1448a40
017b8b9b: cmp      ebx, dword ptr [rip + 0x1ccb093] ; RVA 0x3483c34
RANGE 0x17b8ba1-0x17b8d5d
017b8ba1: movaps   xmmword ptr [rsp + 0x140], xmm11
017b8baa: mov      qword ptr [rsp + 0x28], r13
017b8baf: je       0x17b8c15
017b8bb1: mov      rax, qword ptr [rip + 0x1b6e020] ; RVA 0x3326bd8
017b8bb8: mov      ecx, r13d
017b8bbb: mov      r8d, dword ptr [rax + 0x848]
017b8bc2: mov      r9d, dword ptr [rax + 0x850]
017b8bc9: imul     r9d, ebx
017b8bcd: lea      edi, [r8 - 1]
017b8bd1: test     r8d, r8d
017b8bd4: je       0x17b8c15
017b8bd6: mov      r10, qword ptr [rax + 0x840]
017b8bdd: mov      r11d, dword ptr [rax + 0x84c]
017b8be4: nop      dword ptr [rax]
017b8be8: nop      dword ptr [rax + rax]
017b8bf0: mov      eax, edi
017b8bf2: lea      edx, [rcx + r9]
017b8bf6: and      rdx, rax
017b8bf9: mov      eax, dword ptr [r10 + rdx*8]
017b8bfd: cmp      eax, r11d
017b8c00: je       0x17b8de4
017b8c06: cmp      eax, ebx
017b8c08: je       0x17b8dec
017b8c0e: inc      ecx
017b8c10: cmp      ecx, r8d
017b8c13: jb       0x17b8bf0
017b8c15: movss    xmm11, dword ptr [rsp + 0x28]
017b8c1c: movss    xmm10, dword ptr [rsp + 0x2c]
017b8c23: cmp      dword ptr [r14 + 8], 0
017b8c28: jle      0x17b8d4a
017b8c2e: movss    xmm12, dword ptr [rip + 0xc0da19] ; RVA 0x23c6650
017b8c37: lea      rsi, [rbp - 0x50]
017b8c3b: nop      dword ptr [rax + rax]
017b8c40: movss    xmm9, dword ptr [rsi]
017b8c45: lea      rbx, [r15 + 0xf00]
017b8c4c: movaps   xmm0, xmm9
017b8c50: movsxd   rax, r13d
017b8c53: imul     rcx, rax, 0x158
017b8c5a: mulss    xmm0, xmm12
017b8c5f: xorps    xmm8, xmm8
017b8c63: cvtss2sd xmm8, xmm14
017b8c68: lea      rdi, [r15 + 0x1460]
017b8c6f: add      rbx, rcx
017b8c72: add      rdi, rcx
017b8c75: cvtps2pd xmm6, xmm0
017b8c78: movaps   xmm0, xmm6
017b8c7b: call     0x210c2b0
017b8c80: mulsd    xmm0, xmm8
017b8c85: xorps    xmm7, xmm7
017b8c88: cvtsd2ss xmm7, xmm0
017b8c8c: movaps   xmm0, xmm6
017b8c8f: call     0x2107c80
017b8c94: mulsd    xmm0, xmm8
017b8c99: xorps    xmm1, xmm1
017b8c9c: mov      rcx, rbx
017b8c9f: movaps   xmm3, xmm11
017b8ca3: movaps   xmm2, xmm10
017b8ca7: addss    xmm3, xmm7
017b8cab: cvtsd2ss xmm1, xmm0
017b8caf: movss    dword ptr [rsp + 0x30], xmm3
017b8cb5: addss    xmm2, xmm1
017b8cb9: movss    dword ptr [rsp + 0x34], xmm2
017b8cbf: mov      rdx, qword ptr [rsp + 0x30]
017b8cc4: call     0x1447610
017b8cc9: movss    dword ptr [rsp + 0x40], xmm3
017b8ccf: mov      rcx, rdi
017b8cd2: movss    dword ptr [rsp + 0x44], xmm2
017b8cd8: mov      rdx, qword ptr [rsp + 0x40]
017b8cdd: call     0x1447610
017b8ce2: cmp      byte ptr [r14 + 0x10], 0
017b8ce7: jne      0x17b8ced
017b8ce9: movaps   xmm9, xmm13
017b8ced: movaps   xmm1, xmm9
017b8cf1: mov      rcx, rbx
017b8cf4: call     0x1448e60
017b8cf9: mov      rcx, rdi
017b8cfc: call     0x1448e60
017b8d01: comiss   xmm13, dword ptr [r15 + 0x20b4]
017b8d09: jae      0x17b8d15
017b8d0b: cmp      dword ptr [r15 + 0x2084], 4
017b8d13: je       0x17b8d33
017b8d15: movaps   xmm1, xmm15
017b8d19: mov      rcx, rbx
017b8d1c: call     0x1448a40
017b8d21: cmp      byte ptr [r15 + 0x209c], 0
017b8d29: je       0x17b8d33
017b8d2b: mov      rcx, rdi
017b8d2e: call     0x1448a40
017b8d33: inc      r13d
017b8d36: add      rsi, 4
017b8d3a: cmp      r13d, dword ptr [r14 + 8]
017b8d3e: jl       0x17b8c40
017b8d44: movss    xmm12, dword ptr [rbp - 0x80]
017b8d4a: cmp      dword ptr [r15 + 0x2084], 0
017b8d52: movaps   xmm11, xmmword ptr [rsp + 0x140]
017b8d5b: je       0x17b8d84
RANGE 0x17b8d5d-0x17b8de4
017b8d5d: movss    xmm0, dword ptr [r15 + 0x20b4]
017b8d66: subss    xmm0, xmm12
017b8d6b: comiss   xmm13, xmm0
017b8d6f: movss    dword ptr [r15 + 0x20b4], xmm0
017b8d78: jbe      0x17b8d84
017b8d7a: xor      edx, edx
017b8d7c: mov      rcx, r15
017b8d7f: call     0x17b9180
017b8d84: mov      rcx, qword ptr [rbp - 0x10]
017b8d88: xor      rcx, rsp
017b8d8b: call     0x20886a0
017b8d90: lea      r11, [rsp + 0x1a0]
017b8d98: mov      rbx, qword ptr [r11 + 0x38]
017b8d9c: mov      rsi, qword ptr [r11 + 0x40]
017b8da0: mov      rdi, qword ptr [r11 + 0x48]
017b8da4: movaps   xmm6, xmmword ptr [r11 - 0x10]
017b8da9: movaps   xmm7, xmmword ptr [r11 - 0x20]
017b8dae: movaps   xmm8, xmmword ptr [r11 - 0x30]
017b8db3: movaps   xmm9, xmmword ptr [r11 - 0x40]
017b8db8: movaps   xmm10, xmmword ptr [r11 - 0x50]
017b8dbd: movaps   xmm12, xmmword ptr [r11 - 0x70]
017b8dc2: movaps   xmm13, xmmword ptr [r11 - 0x80]
017b8dc7: movaps   xmm14, xmmword ptr [r11 - 0x90]
017b8dcf: movaps   xmm15, xmmword ptr [r11 - 0xa0]
017b8dd7: mov      rsp, r11
017b8dda: pop      r15
017b8ddc: pop      r14
017b8dde: pop      r13
017b8de0: pop      r12
017b8de2: pop      rbp
017b8de3: ret      
RANGE 0x17b8de4-0x17b8f66
017b8de4: cmp      eax, ebx
017b8de6: jne      0x17b8c15
017b8dec: mov      ebx, dword ptr [r10 + rdx*8 + 4]
017b8df1: cmp      ebx, -1
017b8df4: je       0x17b8c15
017b8dfa: mov      rcx, qword ptr [rsp + 0x40]
017b8dff: call     0x506fe0
017b8e04: cmp      byte ptr [rax + 0x1c], 0
017b8e08: je       0x17b8c15
017b8e0e: mov      rax, qword ptr [rip + 0x1b6ddc3] ; RVA 0x3326bd8
017b8e15: lea      rbx, [rbx + rbx*4]
017b8e19: lea      rcx, [rsp + 0x48]
017b8e1e: mov      rdi, qword ptr [rax + 0x870]
017b8e25: mov      edx, dword ptr [rdi + rbx*4 + 0xc]
017b8e29: call     0xfd9ba0
017b8e2e: mov      ecx, dword ptr [rsp + 0x48]
017b8e32: cmp      ecx, dword ptr [rip + 0x1ccbb50] ; RVA 0x3484988
017b8e38: je       0x17b8c15
017b8e3e: call     0xfd9d40
017b8e43: mov      r9d, dword ptr [rdi + rbx*4 + 0x10]
017b8e48: lea      rdx, [rbp - 0x70]
017b8e4c: mov      r8, rax
017b8e4f: call     0x916fa0
017b8e54: mov      rax, qword ptr [rip + 0x1b6d4ad] ; RVA 0x3326308
017b8e5b: mov      rcx, qword ptr [rax + 0xd0]
017b8e62: call     qword ptr [rcx + 0x2b8]
017b8e68: mov      rdx, qword ptr [rip + 0x1cb46f1] ; RVA 0x346d560
017b8e6f: lea      r8, [rbp - 0x70]
017b8e73: mov      qword ptr [rsp + 0x30], rax
017b8e78: mov      rax, qword ptr [rip + 0x1b6d489] ; RVA 0x3326308
017b8e7f: mov      rdx, qword ptr [rdx]
017b8e82: mov      rcx, qword ptr [rax + 0x20]
017b8e86: mov      rax, qword ptr [rcx + 0xf8]
017b8e8d: lea      rcx, [rsp + 0x60]
017b8e92: call     rax
017b8e94: movss    xmm6, dword ptr [rsp + 0x30]
017b8e9a: movss    xmm7, dword ptr [rsp + 0x34]
017b8ea0: comiss   xmm6, xmm7
017b8ea3: movsd    xmm0, qword ptr [rax]
017b8ea7: mov      eax, dword ptr [rax + 8]
017b8eaa: movss    xmm4, dword ptr [rip + 0xc0ef0a] ; RVA 0x23c7dbc
017b8eb2: movss    xmm5, dword ptr [rip + 0xc0ee96] ; RVA 0x23c7d50
017b8eba: movsd    qword ptr [rsp + 0x70], xmm0
017b8ec0: mov      dword ptr [rsp + 0x78], eax
017b8ec4: jbe      0x17b8ed3
017b8ec6: movaps   xmm4, xmm5
017b8ec9: divss    xmm4, xmm7
017b8ecd: mulss    xmm4, xmm6
017b8ed1: jmp      0x17b8ede
017b8ed3: movaps   xmm5, xmm4
017b8ed6: divss    xmm5, xmm6
017b8eda: mulss    xmm5, xmm7
017b8ede: movss    xmm2, dword ptr [rsp + 0x70]
017b8ee4: movaps   xmm0, xmm6
017b8ee7: movss    xmm3, dword ptr [rsp + 0x74]
017b8eed: movaps   xmm1, xmm7
017b8ef0: mulss    xmm0, xmm9
017b8ef5: mulss    xmm1, xmm9
017b8efa: subss    xmm2, xmm0
017b8efe: movss    xmm0, dword ptr [rsp + 0x78]
017b8f04: comiss   xmm0, xmm8
017b8f08: subss    xmm3, xmm1
017b8f0c: mulss    xmm2, xmm4
017b8f10: divss    xmm2, xmm6
017b8f14: mulss    xmm3, xmm5
017b8f18: movss    dword ptr [rsp + 0x30], xmm2
017b8f1e: divss    xmm3, xmm7
017b8f22: movss    dword ptr [rsp + 0x34], xmm3
017b8f28: mov      rax, qword ptr [rsp + 0x30]
017b8f2d: mov      qword ptr [rsp + 0x28], rax
017b8f32: mov      rax, qword ptr [r15 + 0x14]
017b8f36: movss    xmm11, dword ptr [rsp + 0x28]
017b8f3d: movss    xmm10, dword ptr [rsp + 0x2c]
017b8f44: mov      qword ptr [rsp + 0x30], rax
017b8f49: divss    xmm11, dword ptr [rsp + 0x30]
017b8f50: divss    xmm10, dword ptr [rsp + 0x34]
017b8f57: jbe      0x17b8c23
017b8f5d: movaps   xmm15, xmm13
017b8f61: jmp      0x17b8c23