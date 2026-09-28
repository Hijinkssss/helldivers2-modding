RANGE 0x1030260-0x1030d2d
01030260: mov      qword ptr [rsp + 8], rbx
01030265: push     rdi
01030266: sub      rsp, 0x20
0103026a: lea      rbx, [rcx + 0xbc]
01030271: mov      r10, rdx
01030274: mov      rcx, rbx
01030277: call     0x102c410
0103027c: mov      rcx, qword ptr [rip + 0x22f6085] ; RVA 0x3326308
01030283: mov      edx, r8d
01030286: mov      rax, qword ptr [rcx + 0x128]
0103028d: mov      rcx, r10
01030290: mov      r9, qword ptr [rax + 0x10]
01030294: call     r9
01030297: mov      rdi, rax
0103029a: test     rax, rax
0103029d: je       0x1030d22
010302a3: mov      rcx, qword ptr [rip + 0x22f605e] ; RVA 0x3326308
010302aa: mov      r8d, 0x22
010302b0: mov      rdx, qword ptr [rcx + 0x128]
010302b7: mov      rcx, rax
010302ba: mov      r9, qword ptr [rdx + 0x78]
010302be: lea      rdx, [rip + 0x122f04b] ; RVA 0x225f310
010302c5: call     r9
010302c8: cmp      eax, 0x25
010302cb: jb       0x1030d22
010302d1: mov      rax, qword ptr [rip + 0x22f6030] ; RVA 0x3326308
010302d8: lea      rdx, [rip + 0x122ef41] ; RVA 0x225f220
010302df: movss    xmm2, dword ptr [rbx]
010302e3: mov      rcx, qword ptr [rax + 0x128]
010302ea: mov      rax, qword ptr [rcx + 0x88]
010302f1: mov      rcx, rdi
010302f4: call     rax
010302f6: mov      rax, qword ptr [rip + 0x22f600b] ; RVA 0x3326308
010302fd: lea      rdx, [rip + 0x122efac] ; RVA 0x225f2b0
01030304: movss    xmm2, dword ptr [rbx + 4]
01030309: movss    dword ptr [rbx], xmm0
0103030d: mov      rcx, qword ptr [rax + 0x128]
01030314: mov      rax, qword ptr [rcx + 0x88]
0103031b: mov      rcx, rdi
0103031e: call     rax
01030320: mov      rax, qword ptr [rip + 0x22f5fe1] ; RVA 0x3326308
01030327: lea      rdx, [rip + 0x122ef62] ; RVA 0x225f290
0103032e: movzx    r8d, byte ptr [rbx + 8]
01030333: movss    dword ptr [rbx + 4], xmm0
01030338: mov      rcx, qword ptr [rax + 0x128]
0103033f: mov      rax, qword ptr [rcx + 0x90]
01030346: mov      rcx, rdi
01030349: call     rax
0103034b: movzx    r8d, byte ptr [rbx + 9]
01030350: lea      rdx, [rip + 0x122ef49] ; RVA 0x225f2a0
01030357: mov      byte ptr [rbx + 8], al
0103035a: mov      rax, qword ptr [rip + 0x22f5fa7] ; RVA 0x3326308
01030361: mov      rcx, qword ptr [rax + 0x128]
01030368: mov      rax, qword ptr [rcx + 0x90]
0103036f: mov      rcx, rdi
01030372: call     rax
01030374: movss    xmm2, dword ptr [rbx + 0xc]
01030379: lea      rdx, [rip + 0x122ef98] ; RVA 0x225f318
01030380: mov      byte ptr [rbx + 9], al
01030383: mov      rax, qword ptr [rip + 0x22f5f7e] ; RVA 0x3326308
0103038a: mov      rcx, qword ptr [rax + 0x128]
01030391: mov      rax, qword ptr [rcx + 0x88]
01030398: mov      rcx, rdi
0103039b: call     rax
0103039d: mov      rax, qword ptr [rip + 0x22f5f64] ; RVA 0x3326308
010303a4: lea      rdx, [rip + 0x122efcd] ; RVA 0x225f378
010303ab: movss    xmm2, dword ptr [rbx + 0x10]
010303b0: movss    dword ptr [rbx + 0xc], xmm0
010303b5: mov      rcx, qword ptr [rax + 0x128]
010303bc: mov      rax, qword ptr [rcx + 0x88]
010303c3: mov      rcx, rdi
010303c6: call     rax
010303c8: mov      rax, qword ptr [rip + 0x22f5f39] ; RVA 0x3326308
010303cf: lea      rdx, [rip + 0x122efba] ; RVA 0x225f390
010303d6: movss    dword ptr [rbx + 0x10], xmm0
010303db: xor      r8d, r8d
010303de: mov      rcx, qword ptr [rax + 0x128]
010303e5: mov      rax, qword ptr [rcx + 0x68]
010303e9: mov      rcx, rdi
010303ec: call     rax
010303ee: test     rax, rax
010303f1: je       0x1030402
010303f3: mov      rcx, rax
010303f6: call     0x11e75b0
010303fb: test     eax, eax
010303fd: js       0x1030402
010303ff: mov      dword ptr [rbx + 0x18], eax
01030402: mov      rax, qword ptr [rip + 0x22f5eff] ; RVA 0x3326308
01030409: lea      rdx, [rip + 0x122ef40] ; RVA 0x225f350
01030410: xor      r8d, r8d
01030413: mov      rcx, qword ptr [rax + 0x128]
0103041a: mov      rax, qword ptr [rcx + 0x68]
0103041e: mov      rcx, rdi
01030421: call     rax
01030423: test     rax, rax
01030426: je       0x1030447
01030428: mov      rcx, rax
0103042b: call     0x11e75b0
01030430: test     eax, eax
01030432: js       0x1030447
01030434: mov      eax, eax
01030436: lea      rcx, [rip + 0x2795113] ; RVA 0x37c5550
0103043d: mov      ecx, dword ptr [rcx + rax*4]
01030440: test     ecx, ecx
01030442: js       0x1030447
01030444: mov      dword ptr [rbx + 0x1c], ecx
01030447: mov      rax, qword ptr [rip + 0x22f5eba] ; RVA 0x3326308
0103044e: lea      rdx, [rip + 0x122ef0b] ; RVA 0x225f360
01030455: xor      r8d, r8d
01030458: mov      rcx, qword ptr [rax + 0x128]
0103045f: mov      rax, qword ptr [rcx + 0x68]
01030463: mov      rcx, rdi
01030466: call     rax
01030468: test     rax, rax
0103046b: je       0x103047c
0103046d: mov      rcx, rax
01030470: call     0x11e75b0
01030475: test     eax, eax
01030477: js       0x103047c
01030479: mov      dword ptr [rbx + 0x20], eax
0103047c: mov      rax, qword ptr [rip + 0x22f5e85] ; RVA 0x3326308
01030483: lea      rdx, [rip + 0x122ef36] ; RVA 0x225f3c0
0103048a: mov      r8d, dword ptr [rbx + 0x24]
0103048e: mov      rcx, qword ptr [rax + 0x128]
01030495: mov      rax, qword ptr [rcx + 0x78]
01030499: mov      rcx, rdi
0103049c: call     rax
0103049e: mov      r8d, dword ptr [rbx + 0x30]
010304a2: lea      rdx, [rip + 0x122eef7] ; RVA 0x225f3a0
010304a9: mov      dword ptr [rbx + 0x24], eax
010304ac: mov      rax, qword ptr [rip + 0x22f5e55] ; RVA 0x3326308
010304b3: mov      rcx, qword ptr [rax + 0x128]
010304ba: mov      rax, qword ptr [rcx + 0x78]
010304be: mov      rcx, rdi
010304c1: call     rax
010304c3: mov      r8d, dword ptr [rbx + 0x28]
010304c7: lea      rdx, [rip + 0x122eee2] ; RVA 0x225f3b0
010304ce: mov      dword ptr [rbx + 0x30], eax
010304d1: mov      rax, qword ptr [rip + 0x22f5e30] ; RVA 0x3326308
010304d8: mov      rcx, qword ptr [rax + 0x128]
010304df: mov      rax, qword ptr [rcx + 0x78]
010304e3: mov      rcx, rdi
010304e6: call     rax
010304e8: movzx    r8d, byte ptr [rbx + 0x3c]
010304ed: lea      rdx, [rip + 0x122ef24] ; RVA 0x225f418
010304f4: mov      dword ptr [rbx + 0x28], eax
010304f7: mov      rax, qword ptr [rip + 0x22f5e0a] ; RVA 0x3326308
010304fe: mov      rcx, qword ptr [rax + 0x128]
01030505: mov      rax, qword ptr [rcx + 0x90]
0103050c: mov      rcx, rdi
0103050f: call     rax
01030511: movzx    r8d, byte ptr [rbx + 0x3d]
01030516: lea      rdx, [rip + 0x122ef0b] ; RVA 0x225f428
0103051d: mov      byte ptr [rbx + 0x3c], al
01030520: mov      rax, qword ptr [rip + 0x22f5de1] ; RVA 0x3326308
01030527: mov      rcx, qword ptr [rax + 0x128]
0103052e: mov      rax, qword ptr [rcx + 0x90]
01030535: mov      rcx, rdi
01030538: call     rax
0103053a: movzx    r8d, byte ptr [rbx + 0x3e]
0103053f: lea      rdx, [rip + 0x122eea2] ; RVA 0x225f3e8
01030546: mov      byte ptr [rbx + 0x3d], al
01030549: mov      rax, qword ptr [rip + 0x22f5db8] ; RVA 0x3326308
01030550: mov      rcx, qword ptr [rax + 0x128]
01030557: mov      rax, qword ptr [rcx + 0x90]
0103055e: mov      rcx, rdi
01030561: call     rax
01030563: movzx    r8d, byte ptr [rbx + 0x42]
01030568: lea      rdx, [rip + 0x122ee91] ; RVA 0x225f400
0103056f: mov      byte ptr [rbx + 0x3e], al
01030572: mov      rax, qword ptr [rip + 0x22f5d8f] ; RVA 0x3326308
01030579: mov      rcx, qword ptr [rax + 0x128]
01030580: mov      rax, qword ptr [rcx + 0x90]
01030587: mov      rcx, rdi
0103058a: call     rax
0103058c: mov      r8d, dword ptr [rbx + 0x34]
01030590: lea      rdx, [rip + 0x122eee9] ; RVA 0x225f480
01030597: mov      byte ptr [rbx + 0x42], al
0103059a: mov      rax, qword ptr [rip + 0x22f5d67] ; RVA 0x3326308
010305a1: mov      rcx, qword ptr [rax + 0x128]
010305a8: mov      rax, qword ptr [rcx + 0x78]
010305ac: mov      rcx, rdi
010305af: call     rax
010305b1: movzx    r8d, byte ptr [rbx + 0x38]
010305b6: lea      rdx, [rip + 0x122eedb] ; RVA 0x225f498
010305bd: mov      dword ptr [rbx + 0x34], eax
010305c0: mov      rax, qword ptr [rip + 0x22f5d41] ; RVA 0x3326308
010305c7: mov      rcx, qword ptr [rax + 0x128]
010305ce: mov      rax, qword ptr [rcx + 0x90]
010305d5: mov      rcx, rdi
010305d8: call     rax
010305da: movzx    r8d, byte ptr [rbx + 0x39]
010305df: lea      rdx, [rip + 0x122ee5a] ; RVA 0x225f440
010305e6: mov      byte ptr [rbx + 0x38], al
010305e9: mov      rax, qword ptr [rip + 0x22f5d18] ; RVA 0x3326308
010305f0: mov      rcx, qword ptr [rax + 0x128]
010305f7: mov      rax, qword ptr [rcx + 0x90]
010305fe: mov      rcx, rdi
01030601: call     rax
01030603: mov      byte ptr [rbx + 0x39], al
01030606: mov      rax, qword ptr [rip + 0x22f5cfb] ; RVA 0x3326308
0103060d: mov      rcx, qword ptr [rax + 0x128]
01030614: lea      rdx, [rip + 0x122ee45] ; RVA 0x225f460
0103061b: movzx    r8d, byte ptr [rbx + 0x3a]
01030620: mov      rax, qword ptr [rcx + 0x90]
01030627: mov      rcx, rdi
0103062a: call     rax
0103062c: movzx    r8d, byte ptr [rbx + 0x3b]
01030631: lea      rdx, [rip + 0x122ee98] ; RVA 0x225f4d0
01030638: mov      byte ptr [rbx + 0x3a], al
0103063b: mov      rax, qword ptr [rip + 0x22f5cc6] ; RVA 0x3326308
01030642: mov      rcx, qword ptr [rax + 0x128]
01030649: mov      rax, qword ptr [rcx + 0x90]
01030650: mov      rcx, rdi
01030653: call     rax
01030655: movzx    r8d, byte ptr [rbx + 0x3f]
0103065a: lea      rdx, [rip + 0x122ee87] ; RVA 0x225f4e8
01030661: mov      byte ptr [rbx + 0x3b], al
01030664: mov      rax, qword ptr [rip + 0x22f5c9d] ; RVA 0x3326308
0103066b: mov      rcx, qword ptr [rax + 0x128]
01030672: mov      rax, qword ptr [rcx + 0x90]
01030679: mov      rcx, rdi
0103067c: call     rax
0103067e: movzx    r8d, byte ptr [rbx + 0x40]
01030683: lea      rdx, [rip + 0x122ee26] ; RVA 0x225f4b0
0103068a: mov      byte ptr [rbx + 0x3f], al
0103068d: mov      rax, qword ptr [rip + 0x22f5c74] ; RVA 0x3326308
01030694: mov      rcx, qword ptr [rax + 0x128]
0103069b: mov      rax, qword ptr [rcx + 0x90]
010306a2: mov      rcx, rdi
010306a5: call     rax
010306a7: movss    xmm2, dword ptr [rbx + 0x44]
010306ac: lea      rdx, [rip + 0x122ee0d] ; RVA 0x225f4c0
010306b3: mov      byte ptr [rbx + 0x40], al
010306b6: mov      rax, qword ptr [rip + 0x22f5c4b] ; RVA 0x3326308
010306bd: mov      rcx, qword ptr [rax + 0x128]
010306c4: mov      rax, qword ptr [rcx + 0x88]
010306cb: mov      rcx, rdi
010306ce: call     rax
010306d0: mov      rax, qword ptr [rip + 0x22f5c31] ; RVA 0x3326308
010306d7: lea      rdx, [rip + 0x122ee52] ; RVA 0x225f530
010306de: movss    xmm2, dword ptr [rbx + 0x48]
010306e3: movss    dword ptr [rbx + 0x44], xmm0
010306e8: mov      rcx, qword ptr [rax + 0x128]
010306ef: mov      rax, qword ptr [rcx + 0x88]
010306f6: mov      rcx, rdi
010306f9: call     rax
010306fb: mov      rax, qword ptr [rip + 0x22f5c06] ; RVA 0x3326308
01030702: lea      rdx, [rip + 0x122ee37] ; RVA 0x225f540
01030709: movss    xmm2, dword ptr [rbx + 0x4c]
0103070e: movss    dword ptr [rbx + 0x48], xmm0
01030713: mov      rcx, qword ptr [rax + 0x128]
0103071a: mov      rax, qword ptr [rcx + 0x88]
01030721: mov      rcx, rdi
01030724: call     rax
01030726: mov      rax, qword ptr [rip + 0x22f5bdb] ; RVA 0x3326308
0103072d: lea      rdx, [rip + 0x122edcc] ; RVA 0x225f500
01030734: mov      r8d, dword ptr [rbx + 0x50]
01030738: movss    dword ptr [rbx + 0x4c], xmm0
0103073d: mov      rcx, qword ptr [rax + 0x128]
01030744: mov      rax, qword ptr [rcx + 0x78]
01030748: mov      rcx, rdi
0103074b: call     rax
0103074d: mov      r8d, dword ptr [rbx + 0x54]
01030751: lea      rdx, [rip + 0x122edc0] ; RVA 0x225f518
01030758: mov      dword ptr [rbx + 0x50], eax
0103075b: mov      rax, qword ptr [rip + 0x22f5ba6] ; RVA 0x3326308
01030762: mov      rcx, qword ptr [rax + 0x128]
01030769: mov      rax, qword ptr [rcx + 0x78]
0103076d: mov      rcx, rdi
01030770: call     rax
01030772: mov      r8d, dword ptr [rbx + 0x58]
01030776: lea      rdx, [rip + 0x122ee13] ; RVA 0x225f590
0103077d: mov      dword ptr [rbx + 0x54], eax
01030780: mov      rax, qword ptr [rip + 0x22f5b81] ; RVA 0x3326308
01030787: mov      rcx, qword ptr [rax + 0x128]
0103078e: mov      rax, qword ptr [rcx + 0x78]
01030792: mov      rcx, rdi
01030795: call     rax
01030797: mov      dword ptr [rbx + 0x58], eax
0103079a: mov      rax, qword ptr [rip + 0x22f5b67] ; RVA 0x3326308
010307a1: mov      rcx, qword ptr [rax + 0x128]
010307a8: mov      rax, qword ptr [rcx + 0x78]
010307ac: lea      rdx, [rip + 0x122eded] ; RVA 0x225f5a0
010307b3: mov      r8d, dword ptr [rbx + 0x5c]
010307b7: mov      rcx, rdi
010307ba: call     rax
010307bc: mov      r8d, dword ptr [rbx + 0x60]
010307c0: lea      rdx, [rip + 0x122ed89] ; RVA 0x225f550
010307c7: mov      dword ptr [rbx + 0x5c], eax
010307ca: mov      rax, qword ptr [rip + 0x22f5b37] ; RVA 0x3326308
010307d1: mov      rcx, qword ptr [rax + 0x128]
010307d8: mov      rax, qword ptr [rcx + 0x78]
010307dc: mov      rcx, rdi
010307df: call     rax
010307e1: mov      r8d, dword ptr [rbx + 0x64]
010307e5: lea      rdx, [rip + 0x122ed84] ; RVA 0x225f570
010307ec: mov      dword ptr [rbx + 0x60], eax
010307ef: mov      rax, qword ptr [rip + 0x22f5b12] ; RVA 0x3326308
010307f6: mov      rcx, qword ptr [rax + 0x128]
010307fd: mov      rax, qword ptr [rcx + 0x78]
01030801: mov      rcx, rdi
01030804: call     rax
01030806: mov      r8d, dword ptr [rbx + 0x68]
0103080a: lea      rdx, [rip + 0x122edd7] ; RVA 0x225f5e8
01030811: mov      dword ptr [rbx + 0x64], eax
01030814: mov      rax, qword ptr [rip + 0x22f5aed] ; RVA 0x3326308
0103081b: mov      rcx, qword ptr [rax + 0x128]
01030822: mov      rax, qword ptr [rcx + 0x78]
01030826: mov      rcx, rdi
01030829: call     rax
0103082b: mov      r8d, dword ptr [rbx + 0x6c]
0103082f: lea      rdx, [rip + 0x122edca] ; RVA 0x225f600
01030836: mov      dword ptr [rbx + 0x68], eax
01030839: mov      rax, qword ptr [rip + 0x22f5ac8] ; RVA 0x3326308
01030840: mov      rcx, qword ptr [rax + 0x128]
01030847: mov      rax, qword ptr [rcx + 0x78]
0103084b: mov      rcx, rdi
0103084e: call     rax
01030850: mov      r8d, dword ptr [rbx + 0x70]
01030854: lea      rdx, [rip + 0x122ed5d] ; RVA 0x225f5b8
0103085b: mov      dword ptr [rbx + 0x6c], eax
0103085e: mov      rax, qword ptr [rip + 0x22f5aa3] ; RVA 0x3326308
01030865: mov      rcx, qword ptr [rax + 0x128]
0103086c: mov      rax, qword ptr [rcx + 0x78]
01030870: mov      rcx, rdi
01030873: call     rax
01030875: mov      r8d, dword ptr [rbx + 0x74]
01030879: lea      rdx, [rip + 0x122ed50] ; RVA 0x225f5d0
01030880: mov      dword ptr [rbx + 0x70], eax
01030883: mov      rax, qword ptr [rip + 0x22f5a7e] ; RVA 0x3326308
0103088a: mov      rcx, qword ptr [rax + 0x128]
01030891: mov      rax, qword ptr [rcx + 0x78]
01030895: mov      rcx, rdi
01030898: call     rax
0103089a: mov      r8d, dword ptr [rbx + 0x78]
0103089e: lea      rdx, [rip + 0x122eda3] ; RVA 0x225f648
010308a5: mov      dword ptr [rbx + 0x74], eax
010308a8: mov      rax, qword ptr [rip + 0x22f5a59] ; RVA 0x3326308
010308af: mov      rcx, qword ptr [rax + 0x128]
010308b6: mov      rax, qword ptr [rcx + 0x78]
010308ba: mov      rcx, rdi
010308bd: call     rax
010308bf: mov      r8d, dword ptr [rbx + 0x7c]
010308c3: lea      rdx, [rip + 0x122ed8e] ; RVA 0x225f658
010308ca: mov      dword ptr [rbx + 0x78], eax
010308cd: mov      rax, qword ptr [rip + 0x22f5a34] ; RVA 0x3326308
010308d4: mov      rcx, qword ptr [rax + 0x128]
010308db: mov      rax, qword ptr [rcx + 0x78]
010308df: mov      rcx, rdi
010308e2: call     rax
010308e4: mov      r8d, dword ptr [rbx + 0x80]
010308eb: lea      rdx, [rip + 0x122ed26] ; RVA 0x225f618
010308f2: mov      dword ptr [rbx + 0x7c], eax
010308f5: mov      rax, qword ptr [rip + 0x22f5a0c] ; RVA 0x3326308
010308fc: mov      rcx, qword ptr [rax + 0x128]
01030903: mov      rax, qword ptr [rcx + 0x78]
01030907: mov      rcx, rdi
0103090a: call     rax
0103090c: mov      dword ptr [rbx + 0x80], eax
01030912: mov      rax, qword ptr [rip + 0x22f59ef] ; RVA 0x3326308
01030919: mov      rcx, qword ptr [rax + 0x128]
01030920: mov      rax, qword ptr [rcx + 0x78]
01030924: mov      r8d, dword ptr [rbx + 0x84]
0103092b: lea      rdx, [rip + 0x122ecfe] ; RVA 0x225f630
01030932: mov      rcx, rdi
01030935: call     rax
01030937: mov      r8d, dword ptr [rbx + 0x88]
0103093e: lea      rdx, [rip + 0x122ed4b] ; RVA 0x225f690
01030945: mov      dword ptr [rbx + 0x84], eax
0103094b: mov      rax, qword ptr [rip + 0x22f59b6] ; RVA 0x3326308
01030952: mov      rcx, qword ptr [rax + 0x128]
01030959: mov      rax, qword ptr [rcx + 0x78]
0103095d: mov      rcx, rdi
01030960: call     rax
01030962: mov      r8d, dword ptr [rbx + 0x8c]
01030969: lea      rdx, [rip + 0x122ed30] ; RVA 0x225f6a0
01030970: mov      dword ptr [rbx + 0x88], eax
01030976: mov      rax, qword ptr [rip + 0x22f598b] ; RVA 0x3326308
0103097d: mov      rcx, qword ptr [rax + 0x128]
01030984: mov      rax, qword ptr [rcx + 0x78]
01030988: mov      rcx, rdi
0103098b: call     rax
0103098d: mov      r8d, dword ptr [rbx + 0x90]
01030994: lea      rdx, [rip + 0x122eccd] ; RVA 0x225f668
0103099b: mov      dword ptr [rbx + 0x8c], eax
010309a1: mov      rax, qword ptr [rip + 0x22f5960] ; RVA 0x3326308
010309a8: mov      rcx, qword ptr [rax + 0x128]
010309af: mov      rax, qword ptr [rcx + 0x78]
010309b3: mov      rcx, rdi
010309b6: call     rax
010309b8: mov      r8d, dword ptr [rbx + 0x94]
010309bf: lea      rdx, [rip + 0x122ecb2] ; RVA 0x225f678
010309c6: mov      dword ptr [rbx + 0x90], eax
010309cc: mov      rax, qword ptr [rip + 0x22f5935] ; RVA 0x3326308
010309d3: mov      rcx, qword ptr [rax + 0x128]
010309da: mov      rax, qword ptr [rcx + 0x78]
010309de: mov      rcx, rdi
010309e1: call     rax
010309e3: mov      r8d, dword ptr [rbx + 0x98]
010309ea: lea      rdx, [rip + 0x122ecdf] ; RVA 0x225f6d0
010309f1: mov      dword ptr [rbx + 0x94], eax
010309f7: mov      rax, qword ptr [rip + 0x22f590a] ; RVA 0x3326308
010309fe: mov      rcx, qword ptr [rax + 0x128]
01030a05: mov      rax, qword ptr [rcx + 0x78]
01030a09: mov      rcx, rdi
01030a0c: call     rax
01030a0e: mov      r8d, dword ptr [rbx + 0x9c]
01030a15: lea      rdx, [rip + 0x122ecc4] ; RVA 0x225f6e0
01030a1c: mov      dword ptr [rbx + 0x98], eax
01030a22: mov      rax, qword ptr [rip + 0x22f58df] ; RVA 0x3326308
01030a29: mov      rcx, qword ptr [rax + 0x128]
01030a30: mov      rax, qword ptr [rcx + 0x78]
01030a34: mov      rcx, rdi
01030a37: call     rax
01030a39: mov      r8d, dword ptr [rbx + 0xa0]
01030a40: lea      rdx, [rip + 0x122ec69] ; RVA 0x225f6b0
01030a47: mov      dword ptr [rbx + 0x9c], eax
01030a4d: mov      rax, qword ptr [rip + 0x22f58b4] ; RVA 0x3326308
01030a54: mov      rcx, qword ptr [rax + 0x128]
01030a5b: mov      rax, qword ptr [rcx + 0x78]
01030a5f: mov      rcx, rdi
01030a62: call     rax
01030a64: mov      r8d, dword ptr [rbx + 0xa4]
01030a6b: lea      rdx, [rip + 0x122ec4e] ; RVA 0x225f6c0
01030a72: mov      dword ptr [rbx + 0xa0], eax
01030a78: mov      rax, qword ptr [rip + 0x22f5889] ; RVA 0x3326308
01030a7f: mov      rcx, qword ptr [rax + 0x128]
01030a86: mov      rax, qword ptr [rcx + 0x78]
01030a8a: mov      rcx, rdi
01030a8d: call     rax
01030a8f: mov      r8d, dword ptr [rbx + 0xa8]
01030a96: lea      rdx, [rip + 0x122ec7b] ; RVA 0x225f718
01030a9d: mov      dword ptr [rbx + 0xa4], eax
01030aa3: mov      rax, qword ptr [rip + 0x22f585e] ; RVA 0x3326308
01030aaa: mov      rcx, qword ptr [rax + 0x128]
01030ab1: mov      rax, qword ptr [rcx + 0x78]
01030ab5: mov      rcx, rdi
01030ab8: call     rax
01030aba: mov      r8d, dword ptr [rbx + 0xac]
01030ac1: mov      dword ptr [rbx + 0xa8], eax
01030ac7: mov      rax, qword ptr [rip + 0x22f583a] ; RVA 0x3326308
01030ace: mov      rcx, qword ptr [rax + 0x128]
01030ad5: mov      rax, qword ptr [rcx + 0x78]
01030ad9: lea      rdx, [rip + 0x122ec48] ; RVA 0x225f728
01030ae0: mov      rcx, rdi
01030ae3: call     rax
01030ae5: mov      r8d, dword ptr [rbx + 0xb0]
01030aec: lea      rdx, [rip + 0x122ebfd] ; RVA 0x225f6f0
01030af3: mov      dword ptr [rbx + 0xac], eax
01030af9: mov      rax, qword ptr [rip + 0x22f5808] ; RVA 0x3326308
01030b00: mov      rcx, qword ptr [rax + 0x128]
01030b07: mov      rax, qword ptr [rcx + 0x78]
01030b0b: mov      rcx, rdi
01030b0e: call     rax
01030b10: mov      r8d, dword ptr [rbx + 0xb4]
01030b17: lea      rdx, [rip + 0x122ebe2] ; RVA 0x225f700
01030b1e: mov      dword ptr [rbx + 0xb0], eax
01030b24: mov      rax, qword ptr [rip + 0x22f57dd] ; RVA 0x3326308
01030b2b: mov      rcx, qword ptr [rax + 0x128]
01030b32: mov      rax, qword ptr [rcx + 0x78]
01030b36: mov      rcx, rdi
01030b39: call     rax
01030b3b: mov      r8d, dword ptr [rbx + 0xc4]
01030b42: lea      rdx, [rip + 0x122ec2f] ; RVA 0x225f778
01030b49: mov      dword ptr [rbx + 0xb4], eax
01030b4f: mov      rax, qword ptr [rip + 0x22f57b2] ; RVA 0x3326308
01030b56: mov      rcx, qword ptr [rax + 0x128]
01030b5d: mov      rax, qword ptr [rcx + 0x78]
01030b61: mov      rcx, rdi
01030b64: call     rax
01030b66: mov      r8d, dword ptr [rbx + 0xb8]
01030b6d: lea      rdx, [rip + 0x122ec1c] ; RVA 0x225f790
01030b74: mov      dword ptr [rbx + 0xc4], eax
01030b7a: mov      rax, qword ptr [rip + 0x22f5787] ; RVA 0x3326308
01030b81: mov      rcx, qword ptr [rax + 0x128]
01030b88: mov      rax, qword ptr [rcx + 0x78]
01030b8c: mov      rcx, rdi
01030b8f: call     rax
01030b91: mov      r8d, dword ptr [rbx + 0xbc]
01030b98: lea      rdx, [rip + 0x122eba1] ; RVA 0x225f740
01030b9f: mov      ecx, 2
01030ba4: cmp      eax, ecx
01030ba6: cmovl    ecx, eax
01030ba9: mov      rax, qword ptr [rip + 0x22f5758] ; RVA 0x3326308
01030bb0: mov      dword ptr [rbx + 0xb8], ecx
01030bb6: mov      rcx, qword ptr [rax + 0x128]
01030bbd: mov      rax, qword ptr [rcx + 0x78]
01030bc1: mov      rcx, rdi
01030bc4: call     rax
01030bc6: mov      r8d, dword ptr [rbx + 0xc0]
01030bcd: lea      rdx, [rip + 0x122eb84] ; RVA 0x225f758
01030bd4: mov      dword ptr [rbx + 0xbc], eax
01030bda: mov      rax, qword ptr [rip + 0x22f5727] ; RVA 0x3326308
01030be1: mov      rcx, qword ptr [rax + 0x128]
01030be8: mov      rax, qword ptr [rcx + 0x78]
01030bec: mov      rcx, rdi
01030bef: call     rax
01030bf1: movzx    r8d, byte ptr [rbx + 0x41]
01030bf6: lea      rdx, [rip + 0x122ebdb] ; RVA 0x225f7d8
01030bfd: mov      dword ptr [rbx + 0xc0], eax
01030c03: mov      rax, qword ptr [rip + 0x22f56fe] ; RVA 0x3326308
01030c0a: mov      rcx, qword ptr [rax + 0x128]
01030c11: mov      rax, qword ptr [rcx + 0x90]
01030c18: mov      rcx, rdi
01030c1b: call     rax
01030c1d: movzx    r8d, byte ptr [rbx + 0xc9]
01030c25: lea      rdx, [rip + 0x122ebc4] ; RVA 0x225f7f0
01030c2c: mov      byte ptr [rbx + 0x41], al
01030c2f: mov      rax, qword ptr [rip + 0x22f56d2] ; RVA 0x3326308
01030c36: mov      rcx, qword ptr [rax + 0x128]
01030c3d: mov      rax, qword ptr [rcx + 0x90]
01030c44: mov      rcx, rdi
01030c47: call     rax
01030c49: movzx    r8d, byte ptr [rbx + 0xc8]
01030c51: lea      rdx, [rip + 0x122eb48] ; RVA 0x225f7a0
01030c58: mov      byte ptr [rbx + 0xc9], al
01030c5e: mov      rax, qword ptr [rip + 0x22f56a3] ; RVA 0x3326308
01030c65: mov      rcx, qword ptr [rax + 0x128]
01030c6c: mov      rax, qword ptr [rcx + 0x90]
01030c73: mov      rcx, rdi
01030c76: call     rax
01030c78: mov      byte ptr [rbx + 0xc8], al
01030c7e: mov      rax, qword ptr [rip + 0x22f5683] ; RVA 0x3326308
01030c85: mov      rcx, qword ptr [rax + 0x128]
01030c8c: mov      rax, qword ptr [rcx + 0x78]
01030c90: lea      rdx, [rip + 0x122eb29] ; RVA 0x225f7c0
01030c97: mov      r8d, dword ptr [rbx + 0xcc]
01030c9e: mov      rcx, rdi
01030ca1: call     rax
01030ca3: mov      r8d, dword ptr [rbx + 0xd0]
01030caa: lea      rdx, [rip + 0x122eb77] ; RVA 0x225f828
01030cb1: mov      dword ptr [rbx + 0xcc], eax
01030cb7: mov      rax, qword ptr [rip + 0x22f564a] ; RVA 0x3326308
01030cbe: mov      rcx, qword ptr [rax + 0x128]
01030cc5: mov      rax, qword ptr [rcx + 0x78]
01030cc9: mov      rcx, rdi
01030ccc: call     rax
01030cce: movzx    r8d, byte ptr [rbx + 0xd4]
01030cd6: lea      rdx, [rip + 0x122eb5b] ; RVA 0x225f838
01030cdd: mov      dword ptr [rbx + 0xd0], eax
01030ce3: mov      rax, qword ptr [rip + 0x22f561e] ; RVA 0x3326308
01030cea: mov      rcx, qword ptr [rax + 0x128]
01030cf1: mov      rax, qword ptr [rcx + 0x90]
01030cf8: mov      rcx, rdi
01030cfb: call     rax
01030cfd: mov      rdx, rdi
01030d00: mov      byte ptr [rbx + 0xd4], al
01030d06: call     0x102c540
01030d0b: mov      rax, qword ptr [rip + 0x22f55f6] ; RVA 0x3326308
01030d12: mov      rcx, rdi
01030d15: mov      rdx, qword ptr [rax + 0x128]
01030d1c: call     qword ptr [rdx + 0x160]
01030d22: mov      rbx, qword ptr [rsp + 0x30]
01030d27: add      rsp, 0x20
01030d2b: pop      rdi
01030d2c: ret      