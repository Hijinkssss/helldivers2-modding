RANGE 0x1825e70-0x1826e0c
01825e70: mov      rax, rsp
01825e73: mov      qword ptr [rax + 0x10], rbx
01825e77: mov      qword ptr [rax + 0x18], rbp
01825e7b: mov      qword ptr [rax + 0x20], rsi
01825e7f: push     rdi
01825e80: push     r12
01825e82: push     r13
01825e84: push     r14
01825e86: push     r15
01825e88: sub      rsp, 0xa0
01825e8f: movaps   xmmword ptr [rax - 0x38], xmm6
01825e93: mov      rax, qword ptr [rip + 0xe16176] ; RVA 0x263c010
01825e9a: xor      rax, rsp
01825e9d: mov      qword ptr [rsp + 0x78], rax
01825ea2: mov      r13, rcx
01825ea5: mov      qword ptr [rsp + 0x40], rcx
01825eaa: add      rcx, 0xf48
01825eb1: mov      r15d, r9d
01825eb4: mov      ebx, r8d
01825eb7: call     0x1814ee0
01825ebc: lea      rcx, [r13 + 0x33b8]
01825ec3: call     0x17a2580
01825ec8: lea      rcx, [r13 + 0x56e0]
01825ecf: call     0x17a2580
01825ed4: lea      rcx, [r13 + 0x8d70]
01825edb: call     0x17a2580
01825ee0: lea      rcx, [r13 + 0xb218]
01825ee7: call     0x17a2580
01825eec: mov      rdi, qword ptr [rip + 0x1b0044d] ; RVA 0x3326340
01825ef3: lea      rcx, [r13 + 0x220]
01825efa: mov      edx, dword ptr [rdi + 0xac4e8]
01825f00: call     0x18167f0
01825f05: mov      edx, dword ptr [rdi + 0xac4e8]
01825f0b: lea      rcx, [r13 + 0x2fc0]
01825f12: call     0x18167f0
01825f17: mov      edx, dword ptr [rdi + 0xac4e8]
01825f1d: lea      rcx, [r13 + 0x3f80]
01825f24: call     0x18167f0
01825f29: mov      edx, dword ptr [rdi + 0xac4e8]
01825f2f: lea      rcx, [r13 + 0x62a8]
01825f36: call     0x18167f0
01825f3b: mov      edx, dword ptr [rdi + 0xac4e8]
01825f41: lea      rcx, [r13 + 0x9ab8]
01825f48: call     0x18167f0
01825f4d: lea      rcx, [r13 + 0x618]
01825f54: call     0x144f650
01825f59: test     rax, rax
01825f5c: je       0x1825f71
01825f5e: movss    xmm2, dword ptr [r13 + 0x164]
01825f67: mov      edx, 0x46ee8889
01825f6c: call     0x1449680
01825f71: lea      rcx, [r13 + 0x770]
01825f78: call     0x144f650
01825f7d: test     rax, rax
01825f80: je       0x1825f95
01825f82: movss    xmm2, dword ptr [r13 + 0x164]
01825f8b: mov      edx, 0x46ee8889
01825f90: call     0x1449680
01825f95: lea      rcx, [r13 + 0xb38]
01825f9c: call     0x144f650
01825fa1: test     rax, rax
01825fa4: je       0x1825fb9
01825fa6: movss    xmm2, dword ptr [r13 + 0xa7c]
01825faf: mov      edx, 0x46ee8889
01825fb4: call     0x1449680
01825fb9: lea      rcx, [r13 + 0xdf0]
01825fc0: call     0x144f650
01825fc5: test     rax, rax
01825fc8: je       0x1825fdd
01825fca: movss    xmm2, dword ptr [r13 + 0xa7c]
01825fd3: mov      edx, 0x46ee8889
01825fd8: call     0x1449680
01825fdd: mov      r12d, 3
01825fe3: lea      rdi, [r13 + 0x2018]
01825fea: mov      qword ptr [rsp + 0x48], r12
01825fef: mov      esi, r12d
01825ff2: lea      rcx, [rdi - 0x2b0]
01825ff9: call     0x144f650
01825ffe: test     rax, rax
01826001: je       0x1826015
01826003: movss    xmm2, dword ptr [rdi - 0x36c]
0182600b: mov      edx, 0x46ee8889
01826010: call     0x1449680
01826015: mov      rcx, rdi
01826018: call     0x144f650
0182601d: test     rax, rax
01826020: je       0x1826034
01826022: movss    xmm2, dword ptr [rdi - 0x36c]
0182602a: mov      edx, 0x46ee8889
0182602f: call     0x1449680
01826034: add      rdi, 0x678
0182603b: sub      rsi, 1
0182603f: jne      0x1825ff2
01826041: lea      rdi, [r13 + 0x4738]
01826048: mov      r14, r12
0182604b: nop      dword ptr [rax + rax]
01826050: movss    xmm6, dword ptr [rdi - 0x36c]
01826058: lea      rsi, [rdi - 0x2b0]
0182605f: mov      rcx, rsi
01826062: call     0x144f650
01826067: test     rax, rax
0182606a: je       0x182610e
01826070: call     0x144f650
01826075: test     dword ptr [rsi], 0x10040
0182607b: mov      rbp, rax
0182607e: jne      0x18260be
01826080: mov      edx, 0x40
01826085: call     0x144cdd0
0182608a: mov      rcx, qword ptr [rip + 0x1b00277] ; RVA 0x3326308
01826091: mov      r9, qword ptr [rdi - 0x1b8]
01826098: mov      rdx, qword ptr [rcx + 0xd0]
0182609f: mov      rcx, qword ptr [r9 + 8]
018260a3: mov      r8, qword ptr [rdx + 0x240]
018260aa: mov      rdx, rbp
018260ad: call     r8
018260b0: mov      rdx, rax
018260b3: mov      rcx, rsi
018260b6: mov      rbp, rax
018260b9: call     0x144f6e0
018260be: mov      rax, qword ptr [rip + 0x1b00243] ; RVA 0x3326308
018260c5: movaps   xmm2, xmm6
018260c8: mov      edx, 0x46ee8889
018260cd: mov      rcx, rbp
018260d0: mov      r8, qword ptr [rax + 0x28]
018260d4: call     qword ptr [r8]
018260d7: mov      ecx, dword ptr [rsi]
018260d9: mov      eax, ecx
018260db: shr      eax, 1
018260dd: test     al, 1
018260df: jne      0x18260e6
018260e1: or       ecx, 2
018260e4: mov      dword ptr [rsi], ecx
018260e6: mov      rcx, qword ptr [rdi - 0x1c0]
018260ed: test     rcx, rcx
018260f0: je       0x182610e
018260f2: mov      edx, dword ptr [rcx]
018260f4: mov      eax, edx
018260f6: shr      eax, 3
018260f9: test     al, 1
018260fb: jne      0x182610e
018260fd: or       edx, 8
01826100: mov      dword ptr [rcx], edx
01826102: mov      rcx, qword ptr [rcx + 0xf0]
01826109: test     rcx, rcx
0182610c: jne      0x18260f2
0182610e: movss    xmm6, dword ptr [rdi - 0x36c]
01826116: mov      rcx, rdi
01826119: call     0x144f650
0182611e: test     rax, rax
01826121: je       0x18261cc
01826127: call     0x144f650
0182612c: mov      ecx, dword ptr [rdi]
0182612e: mov      r10, rax
01826131: test     ecx, 0x10040
01826137: jne      0x1826172
01826139: mov      r9, qword ptr [rdi + 0xf8]
01826140: or       ecx, 0x40
01826143: mov      dword ptr [rdi], ecx
01826145: mov      rcx, qword ptr [rip + 0x1b001bc] ; RVA 0x3326308
0182614c: mov      rdx, qword ptr [rcx + 0xd0]
01826153: mov      rcx, qword ptr [r9 + 8]
01826157: mov      r8, qword ptr [rdx + 0x240]
0182615e: mov      rdx, rax
01826161: call     r8
01826164: mov      rdx, rax
01826167: mov      rcx, rdi
0182616a: mov      r10, rax
0182616d: call     0x144f6e0
01826172: mov      rax, qword ptr [rip + 0x1b0018f] ; RVA 0x3326308
01826179: movaps   xmm2, xmm6
0182617c: mov      edx, 0x46ee8889
01826181: mov      rcx, r10
01826184: mov      r8, qword ptr [rax + 0x28]
01826188: call     qword ptr [r8]
0182618b: mov      ecx, dword ptr [rdi]
0182618d: mov      eax, ecx
0182618f: shr      eax, 1
01826191: test     al, 1
01826193: jne      0x182619a
01826195: or       ecx, 2
01826198: mov      dword ptr [rdi], ecx
0182619a: mov      rcx, qword ptr [rdi + 0xf0]
018261a1: test     rcx, rcx
018261a4: je       0x18261cc
018261a6: nop      word ptr [rax + rax]
018261b0: mov      edx, dword ptr [rcx]
018261b2: mov      eax, edx
018261b4: shr      eax, 3
018261b7: test     al, 1
018261b9: jne      0x18261cc
018261bb: or       edx, 8
018261be: mov      dword ptr [rcx], edx
018261c0: mov      rcx, qword ptr [rcx + 0xf0]
018261c7: test     rcx, rcx
018261ca: jne      0x18261b0
018261cc: add      rdi, 0x678
018261d3: sub      r14, 1
018261d7: jne      0x1826050
018261dd: lea      ebp, [r14 + 6]
018261e1: lea      r14, [rip - 0x18261e8] ; RVA 0x0
018261e8: lea      rdi, [r13 + 0x6c08]
018261ef: nop      
018261f0: movss    xmm6, dword ptr [rdi - 0x514]
018261f8: lea      rsi, [rdi - 0x458]
018261ff: mov      rcx, rsi
01826202: call     0x144f650
01826207: test     rax, rax
0182620a: je       0x18262ed
01826210: call     0x144f650
01826215: mov      r10, rax
01826218: mov      eax, dword ptr [rsi]
0182621a: test     eax, 0x10040
0182621f: jne      0x182629d
01826221: mov      rcx, qword ptr [rip + 0x1b000e0] ; RVA 0x3326308
01826228: or       eax, 0x40
0182622b: mov      r9, qword ptr [rdi - 0x360]
01826232: mov      dword ptr [rsi], eax
01826234: mov      rdx, qword ptr [rcx + 0xd0]
0182623b: mov      rcx, qword ptr [r9 + 8]
0182623f: mov      r8, qword ptr [rdx + 0x240]
01826246: mov      rdx, r10
01826249: call     r8
0182624c: mov      r10, rax
0182624f: mov      eax, dword ptr [rsi]
01826251: shr      eax, 0x12
01826254: and      eax, 0xf
01826257: add      eax, -3
0182625a: cmp      eax, 0xa
0182625d: ja       0x182629d
0182625f: mov      ecx, dword ptr [r14 + rax*4 + 0x18274d8]
01826267: add      rcx, r14
0182626a: jmp      rcx
0182626c: mov      qword ptr [rdi - 0x310], r10
01826273: jmp      0x182629d
01826275: mov      qword ptr [rdi - 0x2b0], r10
0182627c: jmp      0x182629d
0182627e: mov      qword ptr [rdi - 0x1b0], r10
01826285: jmp      0x182629d
01826287: mov      qword ptr [rdi + 0x18], r10
0182628b: jmp      0x182629d
0182628d: mov      qword ptr [rdi + 0xcf0], r10
01826294: jmp      0x182629d
01826296: mov      qword ptr [rdi - 0x320], r10
0182629d: mov      rax, qword ptr [rip + 0x1b00064] ; RVA 0x3326308
018262a4: movaps   xmm2, xmm6
018262a7: mov      edx, 0x46ee8889
018262ac: mov      rcx, r10
018262af: mov      r8, qword ptr [rax + 0x28]
018262b3: call     qword ptr [r8]
018262b6: mov      ecx, dword ptr [rsi]
018262b8: mov      eax, ecx
018262ba: shr      eax, 1
018262bc: test     al, 1
018262be: jne      0x18262c5
018262c0: or       ecx, 2
018262c3: mov      dword ptr [rsi], ecx
018262c5: mov      rcx, qword ptr [rdi - 0x368]
018262cc: test     rcx, rcx
018262cf: je       0x18262ed
018262d1: mov      edx, dword ptr [rcx]
018262d3: mov      eax, edx
018262d5: shr      eax, 3
018262d8: test     al, 1
018262da: jne      0x18262ed
018262dc: or       edx, 8
018262df: mov      dword ptr [rcx], edx
018262e1: mov      rcx, qword ptr [rcx + 0xf0]
018262e8: test     rcx, rcx
018262eb: jne      0x18262d1
018262ed: movss    xmm6, dword ptr [rdi - 0x514]
018262f5: lea      rsi, [rdi - 0x1a8]
018262fc: mov      rcx, rsi
018262ff: call     0x144f650
01826304: test     rax, rax
01826307: je       0x18263ec
0182630d: call     0x144f650
01826312: mov      r10, rax
01826315: mov      eax, dword ptr [rsi]
01826317: test     eax, 0x10040
0182631c: jne      0x1826393
0182631e: mov      rcx, qword ptr [rip + 0x1afffe3] ; RVA 0x3326308
01826325: or       eax, 0x40
01826328: mov      r9, qword ptr [rdi - 0xb0]
0182632f: mov      dword ptr [rsi], eax
01826331: mov      rdx, qword ptr [rcx + 0xd0]
01826338: mov      rcx, qword ptr [r9 + 8]
0182633c: mov      r8, qword ptr [rdx + 0x240]
01826343: mov      rdx, r10
01826346: call     r8
01826349: mov      r10, rax
0182634c: mov      eax, dword ptr [rsi]
0182634e: shr      eax, 0x12
01826351: and      eax, 0xf
01826354: add      eax, -3
01826357: cmp      eax, 0xa
0182635a: ja       0x1826393
0182635c: mov      ecx, dword ptr [r14 + rax*4 + 0x1827504]
01826364: add      rcx, r14
01826367: jmp      rcx
01826369: mov      qword ptr [rdi - 0x60], r10
0182636d: jmp      0x1826393
0182636f: mov      qword ptr [rdi], r10
01826372: jmp      0x1826393
01826374: mov      qword ptr [rdi + 0x100], r10
0182637b: jmp      0x1826393
0182637d: mov      qword ptr [rdi + 0x2c8], r10
01826384: jmp      0x1826393
01826386: mov      qword ptr [rdi + 0xfa0], r10
0182638d: jmp      0x1826393
0182638f: mov      qword ptr [rdi - 0x70], r10
01826393: mov      rax, qword ptr [rip + 0x1afff6e] ; RVA 0x3326308
0182639a: movaps   xmm2, xmm6
0182639d: mov      edx, 0x46ee8889
018263a2: mov      rcx, r10
018263a5: mov      r8, qword ptr [rax + 0x28]
018263a9: call     qword ptr [r8]
018263ac: mov      ecx, dword ptr [rsi]
018263ae: mov      eax, ecx
018263b0: shr      eax, 1
018263b2: test     al, 1
018263b4: jne      0x18263bb
018263b6: or       ecx, 2
018263b9: mov      dword ptr [rsi], ecx
018263bb: mov      rcx, qword ptr [rdi - 0xb8]
018263c2: test     rcx, rcx
018263c5: je       0x18263ec
018263c7: nop      word ptr [rax + rax]
018263d0: mov      edx, dword ptr [rcx]
018263d2: mov      eax, edx
018263d4: shr      eax, 3
018263d7: test     al, 1
018263d9: jne      0x18263ec
018263db: or       edx, 8
018263de: mov      dword ptr [rcx], edx
018263e0: mov      rcx, qword ptr [rcx + 0xf0]
018263e7: test     rcx, rcx
018263ea: jne      0x18263d0
018263ec: add      rdi, 0x678
018263f3: sub      rbp, 1
018263f7: jne      0x18261f0
018263fd: lea      rdi, [r13 + 0xa418]
01826404: mov      rbp, r12
01826407: nop      word ptr [rax + rax]
01826410: movss    xmm6, dword ptr [rdi - 0x514]
01826418: lea      rsi, [rdi - 0x458]
0182641f: mov      rcx, rsi
01826422: call     0x144f650
01826427: test     rax, rax
0182642a: je       0x182650d
01826430: call     0x144f650
01826435: mov      r10, rax
01826438: mov      eax, dword ptr [rsi]
0182643a: test     eax, 0x10040
0182643f: jne      0x18264bd
01826441: mov      rcx, qword ptr [rip + 0x1affec0] ; RVA 0x3326308
01826448: or       eax, 0x40
0182644b: mov      r9, qword ptr [rdi - 0x360]
01826452: mov      dword ptr [rsi], eax
01826454: mov      rdx, qword ptr [rcx + 0xd0]
0182645b: mov      rcx, qword ptr [r9 + 8]
0182645f: mov      r8, qword ptr [rdx + 0x240]
01826466: mov      rdx, r10
01826469: call     r8
0182646c: mov      r10, rax
0182646f: mov      eax, dword ptr [rsi]
01826471: shr      eax, 0x12
01826474: and      eax, 0xf
01826477: add      eax, -3
0182647a: cmp      eax, 0xa
0182647d: ja       0x18264bd
0182647f: mov      ecx, dword ptr [r14 + rax*4 + 0x1827530]
01826487: add      rcx, r14
0182648a: jmp      rcx
0182648c: mov      qword ptr [rdi - 0x310], r10
01826493: jmp      0x18264bd
01826495: mov      qword ptr [rdi - 0x2b0], r10
0182649c: jmp      0x18264bd
0182649e: mov      qword ptr [rdi - 0x1b0], r10
018264a5: jmp      0x18264bd
018264a7: mov      qword ptr [rdi + 0x18], r10
018264ab: jmp      0x18264bd
018264ad: mov      qword ptr [rdi + 0xcf0], r10
018264b4: jmp      0x18264bd
018264b6: mov      qword ptr [rdi - 0x320], r10
018264bd: mov      rax, qword ptr [rip + 0x1affe44] ; RVA 0x3326308
018264c4: movaps   xmm2, xmm6
018264c7: mov      edx, 0x46ee8889
018264cc: mov      rcx, r10
018264cf: mov      r8, qword ptr [rax + 0x28]
018264d3: call     qword ptr [r8]
018264d6: mov      ecx, dword ptr [rsi]
018264d8: mov      eax, ecx
018264da: shr      eax, 1
018264dc: test     al, 1
018264de: jne      0x18264e5
018264e0: or       ecx, 2
018264e3: mov      dword ptr [rsi], ecx
018264e5: mov      rcx, qword ptr [rdi - 0x368]
018264ec: test     rcx, rcx
018264ef: je       0x182650d
018264f1: mov      edx, dword ptr [rcx]
018264f3: mov      eax, edx
018264f5: shr      eax, 3
018264f8: test     al, 1
018264fa: jne      0x182650d
018264fc: or       edx, 8
018264ff: mov      dword ptr [rcx], edx
01826501: mov      rcx, qword ptr [rcx + 0xf0]
01826508: test     rcx, rcx
0182650b: jne      0x18264f1
0182650d: movss    xmm6, dword ptr [rdi - 0x514]
01826515: lea      rsi, [rdi - 0x1a8]
0182651c: mov      rcx, rsi
0182651f: call     0x144f650
01826524: test     rax, rax
01826527: je       0x182660c
0182652d: call     0x144f650
01826532: mov      r10, rax
01826535: mov      eax, dword ptr [rsi]
01826537: test     eax, 0x10040
0182653c: jne      0x18265b3
0182653e: mov      rcx, qword ptr [rip + 0x1affdc3] ; RVA 0x3326308
01826545: or       eax, 0x40
01826548: mov      r9, qword ptr [rdi - 0xb0]
0182654f: mov      dword ptr [rsi], eax
01826551: mov      rdx, qword ptr [rcx + 0xd0]
01826558: mov      rcx, qword ptr [r9 + 8]
0182655c: mov      r8, qword ptr [rdx + 0x240]
01826563: mov      rdx, r10
01826566: call     r8
01826569: mov      r10, rax
0182656c: mov      eax, dword ptr [rsi]
0182656e: shr      eax, 0x12
01826571: and      eax, 0xf
01826574: add      eax, -3
01826577: cmp      eax, 0xa
0182657a: ja       0x18265b3
0182657c: mov      ecx, dword ptr [r14 + rax*4 + 0x182755c]
01826584: add      rcx, r14
01826587: jmp      rcx
01826589: mov      qword ptr [rdi - 0x60], r10
0182658d: jmp      0x18265b3
0182658f: mov      qword ptr [rdi], r10
01826592: jmp      0x18265b3
01826594: mov      qword ptr [rdi + 0x100], r10
0182659b: jmp      0x18265b3
0182659d: mov      qword ptr [rdi + 0x2c8], r10
018265a4: jmp      0x18265b3
018265a6: mov      qword ptr [rdi + 0xfa0], r10
018265ad: jmp      0x18265b3
018265af: mov      qword ptr [rdi - 0x70], r10
018265b3: mov      rax, qword ptr [rip + 0x1affd4e] ; RVA 0x3326308
018265ba: movaps   xmm2, xmm6
018265bd: mov      edx, 0x46ee8889
018265c2: mov      rcx, r10
018265c5: mov      r8, qword ptr [rax + 0x28]
018265c9: call     qword ptr [r8]
018265cc: mov      ecx, dword ptr [rsi]
018265ce: mov      eax, ecx
018265d0: shr      eax, 1
018265d2: test     al, 1
018265d4: jne      0x18265db
018265d6: or       ecx, 2
018265d9: mov      dword ptr [rsi], ecx
018265db: mov      rcx, qword ptr [rdi - 0xb8]
018265e2: test     rcx, rcx
018265e5: je       0x182660c
018265e7: nop      word ptr [rax + rax]
018265f0: mov      edx, dword ptr [rcx]
018265f2: mov      eax, edx
018265f4: shr      eax, 3
018265f7: test     al, 1
018265f9: jne      0x182660c
018265fb: or       edx, 8
018265fe: mov      dword ptr [rcx], edx
01826600: mov      rcx, qword ptr [rcx + 0xf0]
01826607: test     rcx, rcx
0182660a: jne      0x18265f0
0182660c: add      rdi, 0x678
01826613: sub      rbp, 1
01826617: jne      0x1826410
0182661d: mov      eax, dword ptr [rip + 0x1c5e365] ; RVA 0x3484988
01826623: cmp      ebx, eax
01826625: je       0x18274ce
0182662b: cmp      r15d, eax
0182662e: je       0x18274ce
01826634: mov      esi, dword ptr [rip + 0x1c5d5e6] ; RVA 0x3483c20
0182663a: cmp      r15d, esi
0182663d: je       0x18274ce
01826643: mov      r8, qword ptr [rip + 0x1b0003e] ; RVA 0x3326688
0182664a: xor      r14d, r14d
0182664d: mov      ecx, r14d
01826650: mov      r9d, dword ptr [r8 + 0x1038]
01826657: mov      r10d, dword ptr [r8 + 0x1040]
0182665e: imul     r10d, r15d
01826662: lea      edi, [r9 - 1]
01826666: test     r9d, r9d
01826669: je       0x18274ce
0182666f: mov      r11, qword ptr [r8 + 0x1030]
01826676: mov      ebx, dword ptr [r8 + 0x103c]
0182667d: nop      dword ptr [rax]
01826680: mov      eax, edi
01826682: lea      edx, [rcx + r10]
01826686: and      rdx, rax
01826689: mov      eax, dword ptr [r11 + rdx*8]
0182668d: cmp      eax, ebx
0182668f: je       0x18266aa
01826691: cmp      eax, r15d
01826694: je       0x18266b3
01826696: inc      ecx
01826698: cmp      ecx, r9d
0182669b: jb       0x1826680
0182669d: mov      rcx, r13
018266a0: call     0x18289a0
018266a5: jmp      0x1827496
018266aa: cmp      eax, r15d
018266ad: jne      0x18274ce
018266b3: mov      edi, 0xffffffff
018266b8: cmp      dword ptr [r11 + rdx*8 + 4], edi
018266bd: je       0x18274ce
018266c3: mov      r10d, dword ptr [r8 + 0x1040]
018266ca: lea      ebp, [r9 - 1]
018266ce: imul     r10d, r15d
018266d2: mov      ecx, r14d
018266d5: test     r9d, r9d
018266d8: je       0x1826729
018266da: nop      word ptr [rax + rax]
018266e0: mov      eax, ebp
018266e2: lea      edx, [rcx + r10]
018266e6: and      rdx, rax
018266e9: mov      eax, dword ptr [r11 + rdx*8]
018266ed: cmp      eax, ebx
018266ef: je       0x18266ff
018266f1: cmp      eax, r15d
018266f4: je       0x1826704
018266f6: inc      ecx
018266f8: cmp      ecx, r9d
018266fb: jb       0x18266e0
018266fd: jmp      0x1826729
018266ff: cmp      eax, r15d
01826702: jne      0x1826729
01826704: mov      eax, dword ptr [r11 + rdx*8 + 4]
01826709: cmp      eax, edi
0182670b: je       0x1826729
0182670d: imul     rcx, rax, 0x1b8
01826714: mov      rax, qword ptr [r8 + 0x1058]
0182671b: cmp      dword ptr [rcx + rax + 0x19c], 2
01826723: jae      0x18274ce
01826729: mov      rbp, qword ptr [rip + 0x1b005f0] ; RVA 0x3326d20
01826730: mov      ecx, r14d
01826733: mov      r8d, dword ptr [rbp + 0x100]
0182673a: mov      r9d, dword ptr [rbp + 0x108]
01826741: imul     r9d, r15d
01826745: lea      ebx, [r8 - 1]
01826749: test     r8d, r8d
0182674c: je       0x1826786
0182674e: mov      r10, qword ptr [rbp + 0xf8]
01826755: mov      r11d, dword ptr [rbp + 0x104]
0182675c: nop      dword ptr [rax]
01826760: mov      eax, ebx
01826762: lea      edx, [rcx + r9]
01826766: and      rdx, rax
01826769: mov      eax, dword ptr [r10 + rdx*8]
0182676d: cmp      eax, r11d
01826770: je       0x1826908
01826776: cmp      eax, r15d
01826779: je       0x1826911
0182677f: inc      ecx
01826781: cmp      ecx, r8d
01826784: jb       0x1826760
01826786: mov      eax, edi
01826788: mov      r13, qword ptr [rip + 0x1affc91] ; RVA 0x3326420
0182678f: lea      r12, [rbp + 0x150]
01826796: mov      ecx, eax
01826798: imul     rax, rcx, 0xa7aec
0182679f: mov      r8d, dword ptr [r13 + 0x38]
018267a3: mov      ecx, r14d
018267a6: mov      r9d, dword ptr [r13 + 0x40]
018267aa: add      r12, rax
018267ad: imul     r9d, r15d
018267b1: lea      ebx, [r8 - 1]
018267b5: test     r8d, r8d
018267b8: je       0x18267f6
018267ba: mov      r10, qword ptr [r13 + 0x30]
018267be: mov      r11d, dword ptr [r13 + 0x3c]
018267c2: nop      dword ptr [rax]
018267c6: nop      word ptr [rax + rax]
018267d0: mov      eax, ebx
018267d2: lea      edx, [rcx + r9]
018267d6: and      rdx, rax
018267d9: mov      eax, dword ptr [r10 + rdx*8]
018267dd: cmp      eax, r11d
018267e0: je       0x182691b
018267e6: cmp      eax, r15d
018267e9: je       0x1826924
018267ef: inc      ecx
018267f1: cmp      ecx, r8d
018267f4: jb       0x18267d0
018267f6: mov      ebx, dword ptr [rip + 0x1c5d438] ; RVA 0x3483c34
018267fc: cmp      ebx, esi
018267fe: je       0x1826855
01826800: mov      rax, qword ptr [rip + 0x1b004d9] ; RVA 0x3326ce0
01826807: mov      ecx, r14d
0182680a: mov      r8d, dword ptr [rax + 0x38]
0182680e: mov      r9d, dword ptr [rax + 0x40]
01826812: imul     r9d, ebx
01826816: lea      ebp, [r8 - 1]
0182681a: test     r8d, r8d
0182681d: je       0x1826855
0182681f: mov      r10, qword ptr [rax + 0x30]
01826823: mov      r11d, dword ptr [rax + 0x3c]
01826827: nop      word ptr [rax + rax]
01826830: mov      eax, ebp
01826832: lea      edx, [rcx + r9]
01826836: and      rdx, rax
01826839: mov      eax, dword ptr [r10 + rdx*8]
0182683d: cmp      eax, r11d
01826840: je       0x1826944
01826846: cmp      eax, ebx
01826848: je       0x182694c
0182684e: inc      ecx
01826850: cmp      ecx, r8d
01826853: jb       0x1826830
01826855: mov      ebp, edi
01826857: cmp      ebx, esi
01826859: je       0x18268a7
0182685b: mov      rax, qword ptr [rip + 0x1affc5e] ; RVA 0x33264c0
01826862: xor      ecx, ecx
01826864: mov      r8d, dword ptr [rax + 0x38]
01826868: mov      r9d, dword ptr [rax + 0x40]
0182686c: imul     r9d, ebx
01826870: lea      r14d, [r8 - 1]
01826874: test     r8d, r8d
01826877: je       0x18268a7
01826879: mov      r10, qword ptr [rax + 0x30]
0182687d: mov      r11d, dword ptr [rax + 0x3c]
01826881: mov      eax, r14d
01826884: lea      edx, [rcx + r9]
01826888: and      rdx, rax
0182688b: mov      eax, dword ptr [r10 + rdx*8]
0182688f: cmp      eax, r11d
01826892: je       0x1826956
01826898: cmp      eax, ebx
0182689a: je       0x182695e
018268a0: inc      ecx
018268a2: cmp      ecx, r8d
018268a5: jb       0x1826881
018268a7: mov      r14d, edi
018268aa: cmp      ebp, edi
018268ac: jne      0x18268b7
018268ae: cmp      r14d, edi
018268b1: je       0x18274c9
018268b7: mov      rax, qword ptr [rsp + 0x40]
018268bc: cmp      byte ptr [rax + 0xbcd0], 0
018268c3: jne      0x18269ae
018268c9: cmp      ebx, dword ptr [rax + 0xbcd4]
018268cf: jne      0x18268de
018268d1: cmp      byte ptr [rax + 0xbcd1], 0
018268d8: je       0x18269ae
018268de: mov      dword ptr [rax + 0xbcd4], ebx
018268e4: cmp      r14d, edi
018268e7: je       0x1826968
018268e9: mov      r15, qword ptr [rsp + 0x40]
018268ee: mov      eax, dword ptr [rip + 0x1c5e094] ; RVA 0x3484988
018268f4: mov      rcx, r15
018268f7: mov      dword ptr [r15 + 0xbcd8], eax
018268fe: call     0x1827b50
01826903: jmp      0x1826996
01826908: cmp      eax, r15d
0182690b: jne      0x1826786
01826911: mov      eax, dword ptr [r10 + rdx*8 + 4]
01826916: jmp      0x1826788
0182691b: cmp      eax, r15d
0182691e: jne      0x18267f6
01826924: mov      eax, dword ptr [r10 + rdx*8 + 4]
01826929: cmp      eax, edi
0182692b: je       0x18267f6
01826931: imul     rcx, rax, 0x1d0
01826938: mov      rax, qword ptr [r13 + 0x60]
0182693c: mov      ebx, dword ptr [rcx + rax]
0182693f: jmp      0x18267fc
01826944: cmp      eax, ebx
01826946: jne      0x1826855
0182694c: mov      ebp, dword ptr [r10 + rdx*8 + 4]
01826951: jmp      0x1826857
01826956: cmp      eax, ebx
01826958: jne      0x18268a7
0182695e: mov      r14d, dword ptr [r10 + rdx*8 + 4]
01826963: jmp      0x18268aa
01826968: xor      r9d, r9d
0182696b: mov      byte ptr [rsp + 0x20], 1
01826970: mov      r8d, r15d
01826973: lea      rdx, [rsp + 0x30]
01826978: mov      rcx, r13
0182697b: call     0x786920
01826980: mov      r15, qword ptr [rsp + 0x40]
01826985: mov      ecx, dword ptr [rax]
01826987: mov      dword ptr [r15 + 0xbcd8], ecx
0182698e: mov      rcx, r15
01826991: call     0x1827670
01826996: mov      rcx, r15
01826999: call     0x1827fa0
0182699e: mov      byte ptr [r15 + 0xbcd1], 0
018269a6: mov      esi, dword ptr [rip + 0x1c5d274] ; RVA 0x3483c20
018269ac: jmp      0x18269b1
018269ae: mov      r15, rax
018269b1: movabs   rcx, 0x2300000002
018269bb: call     0x585b80
018269c0: mov      r9d, eax
018269c3: shl      r9, 5
018269c7: cmp      byte ptr [r9 + r12 + 0x1b68], 0
018269d0: je       0x18269e3
018269d2: mov      qword ptr [rsp + 0x38], 0
018269db: xor      r12d, r12d
018269de: jmp      0x1826b30
018269e3: movabs   rcx, 0x2400000002
018269ed: call     0x585b80
018269f2: mov      r9d, eax
018269f5: shl      r9, 5
018269f9: cmp      byte ptr [r9 + r12 + 0x1b68], 0
01826a02: je       0x1826a18
01826a04: mov      qword ptr [rsp + 0x38], 1
01826a0d: mov      r12d, 1
01826a13: jmp      0x1826b30
01826a18: movabs   rcx, 0x2100000002
01826a22: call     0x585b80
01826a27: mov      r9d, eax
01826a2a: shl      r9, 5
01826a2e: cmp      byte ptr [r9 + r12 + 0x1b68], 0
01826a37: je       0x1826a44
01826a39: mov      r12d, 2
01826a3f: jmp      0x1826b2b
01826a44: movabs   rcx, 0x2200000002
01826a4e: call     0x585b80
01826a53: mov      r9d, eax
01826a56: shl      r9, 5
01826a5a: cmp      byte ptr [r9 + r12 + 0x1b68], 0
01826a63: je       0x1826a75
01826a65: mov      r12d, 3
01826a6b: mov      qword ptr [rsp + 0x38], r12
01826a70: jmp      0x1826b35
01826a75: cmp      byte ptr [r15 + 0xbcd0], 0
01826a7d: jne      0x1827496
01826a83: movabs   rcx, 0x1f00000002
01826a8d: call     0x585b80
01826a92: mov      r9d, eax
01826a95: shl      r9, 5
01826a99: cmp      byte ptr [r9 + r12 + 0x1b68], 0
01826aa2: je       0x1826ab2
01826aa4: mov      qword ptr [rsp + 0x38], 0
01826aad: xor      r12d, r12d
01826ab0: jmp      0x1826b30
01826ab2: movabs   rcx, 0x2000000002
01826abc: call     0x585b80
01826ac1: mov      r9d, eax
01826ac4: shl      r9, 5
01826ac8: cmp      byte ptr [r9 + r12 + 0x1b68], 0
01826ad1: jne      0x1826a04
01826ad7: movabs   rcx, 0x1d00000002
01826ae1: call     0x585b80
01826ae6: mov      r9d, eax
01826ae9: shl      r9, 5
01826aed: cmp      byte ptr [r9 + r12 + 0x1b68], 0
01826af6: je       0x1826b00
01826af8: mov      r12d, 2
01826afe: jmp      0x1826b2b
01826b00: movabs   rcx, 0x1e00000002
01826b0a: call     0x585b80
01826b0f: mov      r9d, eax
01826b12: shl      r9, 5
01826b16: cmp      byte ptr [r9 + r12 + 0x1b68], 0
01826b1f: je       0x1826df6
01826b25: mov      r12d, 3
01826b2b: mov      qword ptr [rsp + 0x38], r12
01826b30: mov      qword ptr [rsp + 0x48], r12
01826b35: cmp      ebp, edi
01826b37: je       0x1826c6b
01826b3d: cmp      ebx, esi
01826b3f: je       0x1826b8e
01826b41: mov      rax, qword ptr [rip + 0x1b00198] ; RVA 0x3326ce0
01826b48: xor      ecx, ecx
01826b4a: mov      r8d, dword ptr [rax + 0x38]
01826b4e: mov      r9d, dword ptr [rax + 0x40]
01826b52: imul     r9d, ebx
01826b56: lea      r15d, [r8 - 1]
01826b5a: test     r8d, r8d
01826b5d: je       0x1826b8e
01826b5f: mov      r10, qword ptr [rax + 0x30]
01826b63: mov      r11d, dword ptr [rax + 0x3c]
01826b67: nop      word ptr [rax + rax]
01826b70: mov      eax, r15d
01826b73: lea      edx, [rcx + r9]
01826b77: and      rdx, rax
01826b7a: mov      eax, dword ptr [r10 + rdx*8]
01826b7e: cmp      eax, r11d
01826b81: je       0x1826bd1
01826b83: cmp      eax, ebx
01826b85: je       0x1826bd5
01826b87: inc      ecx
01826b89: cmp      ecx, r8d
01826b8c: jb       0x1826b70
01826b8e: mov      eax, edi
01826b90: mov      ecx, eax
01826b92: mov      rax, qword ptr [rip + 0x1b00147] ; RVA 0x3326ce0
01826b99: imul     rdx, rcx, 0xfc
01826ba0: mov      rax, qword ptr [rax + 0x58]
01826ba4: add      rdx, r12
01826ba7: mov      r13d, dword ptr [rax + rdx*4 + 0x350]
01826baf: mov      rax, qword ptr [rip + 0x1aff8b2] ; RVA 0x3326468
01826bb6: cmp      dword ptr [rax + 0x88], 0
01826bbd: je       0x1826bdc
01826bbf: mov      edx, dword ptr [rax + 0x3a8]
01826bc5: lea      rcx, [rsp + 0x30]
01826bca: call     0xfd9ba0
01826bcf: jmp      0x1826beb
01826bd1: cmp      eax, ebx
01826bd3: jne      0x1826b8e
01826bd5: mov      eax, dword ptr [r10 + rdx*8 + 4]
01826bda: jmp      0x1826b90
01826bdc: mov      eax, dword ptr [rip + 0x1c5d052] ; RVA 0x3483c34
01826be2: mov      dword ptr [rsp + 0x30], eax
01826be6: lea      rax, [rsp + 0x30]
01826beb: mov      eax, dword ptr [rax]
01826bed: cmp      eax, esi
01826bef: je       0x1826c56
01826bf1: mov      rcx, qword ptr [rip + 0x1b00128] ; RVA 0x3326d20
01826bf8: xor      edx, edx
01826bfa: mov      r9d, dword ptr [rcx + 0x100]
01826c01: mov      r10d, dword ptr [rcx + 0x108]
01826c08: imul     r10d, eax
01826c0c: lea      r12d, [r9 - 1]
01826c10: test     r9d, r9d
01826c13: je       0x1826c56
01826c15: mov      r11, qword ptr [rcx + 0xf8]
01826c1c: mov      r15d, dword ptr [rcx + 0x104]
01826c23: nop      dword ptr [rax]
01826c27: nop      word ptr [rax + rax]
01826c30: mov      ecx, r12d
01826c33: lea      r8d, [rdx + r10]
01826c37: and      r8, rcx
01826c3a: mov      ecx, dword ptr [r11 + r8*8]
01826c3e: cmp      ecx, r15d
01826c41: je       0x1826e73
01826c47: cmp      ecx, eax
01826c49: je       0x1826e7b
01826c4f: inc      edx
01826c51: cmp      edx, r9d
01826c54: jb       0x1826c30
01826c56: mov      edx, 0xabfd0ae7
01826c5b: call     0x1327ec0
01826c60: mov      r15, qword ptr [rsp + 0x40]
01826c65: mov      esi, dword ptr [rip + 0x1c5cfb5] ; RVA 0x3483c20
01826c6b: cmp      r14d, edi
01826c6e: je       0x1826dc5
01826c74: mov      r13, qword ptr [rip + 0x1aff845] ; RVA 0x33264c0
01826c7b: cmp      ebx, esi
01826c7d: je       0x1826cc6
01826c7f: mov      r8d, dword ptr [r13 + 0x38]
01826c83: xor      ecx, ecx
01826c85: mov      r9d, dword ptr [r13 + 0x40]
01826c89: imul     r9d, ebx
01826c8d: lea      r15d, [r8 - 1]
01826c91: test     r8d, r8d
01826c94: je       0x1826cc6
01826c96: mov      r10, qword ptr [r13 + 0x30]
01826c9a: mov      r11d, dword ptr [r13 + 0x3c]
01826c9e: nop      
01826ca0: mov      eax, r15d
01826ca3: lea      edx, [rcx + r9]
01826ca7: and      rdx, rax
01826caa: mov      eax, dword ptr [r10 + rdx*8]
01826cae: cmp      eax, r11d
01826cb1: je       0x1827121
01826cb7: cmp      eax, ebx
01826cb9: je       0x1827129
01826cbf: inc      ecx
01826cc1: cmp      ecx, r8d
01826cc4: jb       0x1826ca0
01826cc6: mov      eax, edi
01826cc8: mov      r12, qword ptr [rsp + 0x38]
01826ccd: mov      ecx, eax
01826ccf: lea      rax, [rcx + rcx*4]
01826cd3: mov      rcx, qword ptr [r13 + 0x58]
01826cd7: lea      rdx, [r12 + rax*2]
01826cdb: mov      ecx, dword ptr [rcx + rdx*4 + 0x18]
01826cdf: cmp      ecx, 1
01826ce2: jne      0x1826d3d
01826ce4: cmp      ebx, esi
01826ce6: je       0x1826d2d
01826ce8: mov      rax, qword ptr [rip + 0x1aff7d1] ; RVA 0x33264c0
01826cef: xor      edx, edx
01826cf1: mov      r8d, dword ptr [rax + 0x38]
01826cf5: mov      r9d, dword ptr [rax + 0x40]
01826cf9: imul     r9d, ebx
01826cfd: lea      esi, [r8 - 1]
01826d01: test     r8d, r8d
01826d04: je       0x1826d2d
01826d06: mov      r10, qword ptr [rax + 0x30]
01826d0a: mov      r11d, dword ptr [rax + 0x3c]
01826d0e: nop      
01826d10: mov      eax, esi
01826d12: lea      ecx, [rdx + r9]
01826d16: and      rcx, rax
01826d19: mov      eax, dword ptr [r10 + rcx*8]
01826d1d: cmp      eax, r11d
01826d20: je       0x1826d2d
01826d22: cmp      eax, ebx
01826d24: je       0x1826d2d
01826d26: inc      edx
01826d28: cmp      edx, r8d
01826d2b: jb       0x1826d10
01826d2d: mov      edx, ebx
01826d2f: mov      rcx, r13
01826d32: call     0x6c85e0
01826d37: mov      esi, dword ptr [rip + 0x1c5cee3] ; RVA 0x3483c20
01826d3d: mov      r11, qword ptr [rip + 0x1aff77c] ; RVA 0x33264c0
01826d44: cmp      ebx, esi
01826d46: je       0x1826d95
01826d48: mov      r8d, dword ptr [r11 + 0x38]
01826d4c: xor      ecx, ecx
01826d4e: mov      r9d, dword ptr [r11 + 0x40]
01826d52: imul     r9d, ebx
01826d56: lea      r15d, [r8 - 1]
01826d5a: test     r8d, r8d
01826d5d: je       0x1826d95
01826d5f: mov      r10, qword ptr [r11 + 0x30]
01826d63: mov      esi, dword ptr [r11 + 0x3c]
01826d67: nop      word ptr [rax + rax]
01826d70: mov      eax, r15d
01826d73: lea      edx, [rcx + r9]
01826d77: and      rdx, rax
01826d7a: mov      eax, dword ptr [r10 + rdx*8]
01826d7e: cmp      eax, esi
01826d80: je       0x1827133
01826d86: cmp      eax, ebx
01826d88: je       0x182713b
01826d8e: inc      ecx
01826d90: cmp      ecx, r8d
01826d93: jb       0x1826d70
01826d95: mov      eax, edi
01826d97: mov      ecx, eax
01826d99: lea      rax, [rcx + rcx*4]
01826d9d: mov      rcx, qword ptr [r11 + 0x58]
01826da1: lea      rdx, [r12 + rax*2]
01826da5: mov      ecx, dword ptr [rcx + rdx*4 + 0x18]
01826da9: cmp      ecx, 1
01826dac: jne      0x1826db8
01826dae: mov      edx, 0xdcba0145
01826db3: call     0x1327ec0
01826db8: mov      r15, qword ptr [rsp + 0x40]
01826dbd: mov      byte ptr [r15 + 0xbcd1], 1
01826dc5: mov      rbx, qword ptr [rip + 0x1c4676c] ; RVA 0x346d538
01826dcc: lea      rcx, [rbx + 0x3e8e38]
01826dd3: call     0x17b9040
01826dd8: mov      edx, 1
01826ddd: mov      byte ptr [rbx + 0x3eaed2], 1
01826de4: lea      rcx, [rbx + 0x3e8e38]
01826deb: call     0x17b9bf0
01826df0: mov      esi, dword ptr [rip + 0x1c5ce2a] ; RVA 0x3483c20
01826df6: cmp      byte ptr [r15 + 0xbcd0], 0
01826dfe: jne      0x1827496
01826e04: movss    xmm6, dword ptr [rip + 0xba0760] ; RVA 0x23c756c
RANGE 0x1826e0c-0x1826e73
01826e0c: movaps   xmmword ptr [rsp + 0x80], xmm7
01826e14: movss    xmm7, dword ptr [rip + 0xba05e4] ; RVA 0x23c7400
01826e1c: cmp      ebp, edi
01826e1e: je       0x1827326
01826e24: mov      edx, dword ptr [r15 + 0xbcd8]
01826e2b: call     0x742fe0
01826e30: mov      edx, dword ptr [r15 + 0xbcd8]
01826e37: mov      ebp, eax
01826e39: mov      dword ptr [rsp + 0x30], eax
01826e3d: call     0x743670
01826e42: mov      ecx, dword ptr [r15 + 0xbcd8]
01826e49: mov      r12d, eax
01826e4c: mov      esi, dword ptr [rip + 0x1c5cdce] ; RVA 0x3483c20
01826e52: movd     xmm1, ebp
01826e56: movd     xmm0, eax
01826e5a: cvtdq2ps xmm0, xmm0
01826e5d: cvtdq2ps xmm1, xmm1
01826e60: divss    xmm1, xmm0
01826e64: cmp      ecx, esi
01826e66: jne      0x1827145
01826e6c: mov      ebx, edi
01826e6e: jmp      0x182719a
RANGE 0x1826e73-0x1827145
01826e73: cmp      ecx, eax
01826e75: jne      0x1826c56
01826e7b: mov      ecx, dword ptr [r11 + r8*8 + 4]
01826e80: cmp      ecx, edi
01826e82: je       0x1826c56
01826e88: lea      eax, [r13 - 3]
01826e8c: test     eax, 0xfffffff7
01826e91: jne      0x1826f49
01826e97: imul     r9, rcx, 0x1238
01826e9e: xorps    xmm0, xmm0
01826ea1: movups   xmmword ptr [rsp + 0x60], xmm0
01826ea6: xor      eax, eax
01826ea8: mov      qword ptr [rsp + 0x50], 0x66
01826eb1: mov      qword ptr [rsp + 0x70], rax
01826eb6: lea      r8, [rsp + 0x50]
01826ebb: mov      qword ptr [rsp + 0x58], 0x79
01826ec4: nop      dword ptr [rax]
01826ec8: nop      dword ptr [rax + rax]
01826ed0: mov      edx, dword ptr [r8]
01826ed3: add      r8, 8
01826ed7: mov      ecx, edx
01826ed9: and      edx, 0x3f
01826edc: shr      rcx, 6
01826ee0: mov      rax, qword ptr [rsp + rcx*8 + 0x60]
01826ee5: bts      rax, rdx
01826ee9: mov      qword ptr [rsp + rcx*8 + 0x60], rax
01826eee: lea      rax, [rsp + 0x60]
01826ef3: cmp      r8, rax
01826ef6: jne      0x1826ed0
01826ef8: mov      r8, qword ptr [rip + 0x1affe21] ; RVA 0x3326d20
01826eff: mov      rax, qword ptr [r9 + r8 + 0x53e890]
01826f07: test     qword ptr [rsp + 0x70], rax
01826f0c: mov      rax, qword ptr [r9 + r8 + 0x53e880]
01826f14: mov      rdx, qword ptr [r9 + r8 + 0x53e888]
01826f1c: sete     cl
01826f1f: and      rax, qword ptr [rsp + 0x60]
01826f24: test     rax, -2
01826f2a: sete     al
01826f2d: and      cl, al
01826f2f: and      rdx, qword ptr [rsp + 0x68]
01826f34: movzx    eax, cl
01826f37: mov      ecx, 0
01826f3c: cmovne   eax, ecx
01826f3f: test     al, al
01826f41: je       0x1826c56
01826f47: jmp      0x1826f4b
01826f49: xor      ecx, ecx
01826f4b: mov      r15, qword ptr [rip + 0x1affd8e] ; RVA 0x3326ce0
01826f52: cmp      ebx, esi
01826f54: je       0x1826f9d
01826f56: mov      r8d, dword ptr [r15 + 0x38]
01826f5a: mov      r9d, dword ptr [r15 + 0x40]
01826f5e: imul     r9d, ebx
01826f62: lea      esi, [r8 - 1]
01826f66: test     r8d, r8d
01826f69: je       0x1826f9d
01826f6b: mov      r10, qword ptr [r15 + 0x30]
01826f6f: mov      r11d, dword ptr [r15 + 0x3c]
01826f73: nop      dword ptr [rax]
01826f77: nop      word ptr [rax + rax]
01826f80: mov      eax, esi
01826f82: lea      edx, [rcx + r9]
01826f86: and      rdx, rax
01826f89: mov      eax, dword ptr [r10 + rdx*8]
01826f8d: cmp      eax, r11d
01826f90: je       0x1826fe5
01826f92: cmp      eax, ebx
01826f94: je       0x1826fe9
01826f96: inc      ecx
01826f98: cmp      ecx, r8d
01826f9b: jb       0x1826f80
01826f9d: mov      eax, edi
01826f9f: mov      ecx, eax
01826fa1: mov      rax, qword ptr [r15 + 0x58]
01826fa5: imul     rdx, rcx, 0xfc
01826fac: mov      rcx, r15
01826faf: add      rdx, qword ptr [rsp + 0x48]
01826fb4: mov      r8d, dword ptr [rax + rdx*4 + 0x350]
01826fbc: mov      edx, ebx
01826fbe: call     0x7552d0
01826fc3: lea      eax, [r13 - 1]
01826fc7: cmp      eax, 0xa
01826fca: ja       0x18270fb
01826fd0: lea      rdx, [rip - 0x1826fd7] ; RVA 0x0
01826fd7: cdqe     
01826fd9: mov      ecx, dword ptr [rdx + rax*4 + 0x1827588]
01826fe0: add      rcx, rdx
01826fe3: jmp      rcx
01826fe5: cmp      eax, ebx
01826fe7: jne      0x1826f9d
01826fe9: mov      eax, dword ptr [r10 + rdx*8 + 4]
01826fee: jmp      0x1826f9f
01826ff0: mov      edx, 0xdcba0145
01826ff5: call     0x1327ec0
01826ffa: jmp      0x1827101
01826fff: mov      edx, 0xba7e20b5
01827004: call     0x1327ec0
01827009: mov      r15, qword ptr [rsp + 0x40]
0182700e: mov      byte ptr [r15 + 0xbcd1], 1
01827016: jmp      0x1826c65
0182701b: mov      edx, 0xe7a09c02
01827020: call     0x1327ec0
01827025: mov      r15, qword ptr [rsp + 0x40]
0182702a: mov      byte ptr [r15 + 0xbcd1], 1
01827032: jmp      0x1826c65
01827037: mov      edx, 0x447bf902
0182703c: call     0x1327ec0
01827041: mov      r15, qword ptr [rsp + 0x40]
01827046: mov      byte ptr [r15 + 0xbcd1], 1
0182704e: jmp      0x1826c65
01827053: mov      edx, 0xc61179bb
01827058: call     0x1327ec0
0182705d: mov      r15, qword ptr [rsp + 0x40]
01827062: mov      byte ptr [r15 + 0xbcd1], 1
0182706a: jmp      0x1826c65
0182706f: mov      edx, 0x48099f3e
01827074: call     0x1327ec0
01827079: mov      r15, qword ptr [rsp + 0x40]
0182707e: mov      byte ptr [r15 + 0xbcd1], 1
01827086: jmp      0x1826c65
0182708b: mov      edx, 0xf0fa7507
01827090: call     0x1327ec0
01827095: mov      r15, qword ptr [rsp + 0x40]
0182709a: mov      byte ptr [r15 + 0xbcd1], 1
018270a2: jmp      0x1826c65
018270a7: mov      edx, 0x166f7eeb
018270ac: call     0x1327ec0
018270b1: mov      r15, qword ptr [rsp + 0x40]
018270b6: mov      byte ptr [r15 + 0xbcd1], 1
018270be: jmp      0x1826c65
018270c3: mov      edx, 0x20a07e99
018270c8: call     0x1327ec0
018270cd: mov      r15, qword ptr [rsp + 0x40]
018270d2: mov      byte ptr [r15 + 0xbcd1], 1
018270da: jmp      0x1826c65
018270df: mov      edx, 0x157edbb4
018270e4: call     0x1327ec0
018270e9: mov      r15, qword ptr [rsp + 0x40]
018270ee: mov      byte ptr [r15 + 0xbcd1], 1
018270f6: jmp      0x1826c65
018270fb: cmp      r13d, 1
018270ff: jne      0x182710f
01827101: mov      rcx, qword ptr [rip + 0x1c46458] ; RVA 0x346d560
01827108: xor      edx, edx
0182710a: call     0x1278cc0
0182710f: mov      r15, qword ptr [rsp + 0x40]
01827114: mov      byte ptr [r15 + 0xbcd1], 1
0182711c: jmp      0x1826c65
01827121: cmp      eax, ebx
01827123: jne      0x1826cc6
01827129: mov      eax, dword ptr [r10 + rdx*8 + 4]
0182712e: jmp      0x1826cc8
01827133: cmp      eax, ebx
01827135: jne      0x1826d95
0182713b: mov      eax, dword ptr [r10 + rdx*8 + 4]
01827140: jmp      0x1826d97
RANGE 0x1827145-0x1827496
01827145: mov      r13, qword ptr [rip + 0x1affbfc] ; RVA 0x3326d48
0182714c: xor      edx, edx
0182714e: mov      r9d, dword ptr [r13 + 0x30]
01827152: mov      r10d, dword ptr [r13 + 0x38]
01827156: imul     r10d, ecx
0182715a: lea      ebp, [r9 - 1]
0182715e: test     r9d, r9d
01827161: je       0x1827194
01827163: mov      r11, qword ptr [r13 + 0x28]
01827167: mov      ebx, dword ptr [r13 + 0x34]
0182716b: nop      dword ptr [rax + rax]
01827170: mov      eax, ebp
01827172: lea      r8d, [rdx + r10]
01827176: and      r8, rax
01827179: mov      eax, dword ptr [r11 + r8*8]
0182717d: cmp      eax, ebx
0182717f: je       0x1827265
01827185: cmp      eax, ecx
01827187: je       0x182726d
0182718d: inc      edx
0182718f: cmp      edx, r9d
01827192: jb       0x1827170
01827194: mov      ebx, edi
01827196: mov      ebp, dword ptr [rsp + 0x30]
0182719a: movss    xmm0, dword ptr [r15 + 0x19e4]
018271a3: ucomiss  xmm0, xmm1
018271a6: jp       0x18271aa
018271a8: je       0x18271c5
018271aa: lea      rcx, [r15 + 0xf48]
018271b1: movss    dword ptr [r15 + 0x19e4], xmm1
018271ba: call     0x18151b0
018271bf: mov      esi, dword ptr [rip + 0x1c5ca5b] ; RVA 0x3483c20
018271c5: lea      r13, [r15 + 0xb38]
018271cc: test     r12d, r12d
018271cf: jle      0x18271fd
018271d1: xor      r9d, r9d
018271d4: mov      r8d, ebp
018271d7: mov      edx, 0xeb646556
018271dc: mov      rcx, r13
018271df: call     0x143c940
018271e4: xor      r9d, r9d
018271e7: mov      r8d, r12d
018271ea: mov      edx, 0x4442eb89
018271ef: mov      rcx, r13
018271f2: call     0x143c940
018271f7: mov      esi, dword ptr [rip + 0x1c5ca23] ; RVA 0x3483c20
018271fd: cmp      r12d, dword ptr [r15 + 0xbcec]
01827204: je       0x182732d
0182720a: mov      rcx, r13
0182720d: mov      dword ptr [r15 + 0xbcec], r12d
01827214: call     0x144e110
01827219: mov      dword ptr [rsp + 0x3c], 0x41c00000
01827221: lea      rcx, [r15 + 0xa28]
01827228: cmp      ebx, edi
0182722a: je       0x182730f
01827230: movss    xmm0, dword ptr [r15 + 0xf64]
01827239: mulss    xmm0, dword ptr [r15 + 0xf54]
01827242: addss    xmm0, xmm6
01827246: addss    xmm0, xmm7
0182724a: movss    dword ptr [rsp + 0x38], xmm0
01827250: mov      rdx, qword ptr [rsp + 0x38]
01827255: call     0x14470d0
0182725a: mov      esi, dword ptr [rip + 0x1c5c9c0] ; RVA 0x3483c20
01827260: jmp      0x182732d
01827265: cmp      eax, ecx
01827267: jne      0x1827194
0182726d: mov      ebx, dword ptr [r11 + r8*8 + 4]
01827272: cmp      ebx, edi
01827274: je       0x1827196
0182727a: cmp      ecx, esi
0182727c: je       0x18272c2
0182727e: mov      r10d, dword ptr [r13 + 0x38]
01827282: lea      r15d, [r9 - 1]
01827286: imul     r10d, ecx
0182728a: xor      edx, edx
0182728c: test     r9d, r9d
0182728f: je       0x18272bd
01827291: mov      ebp, dword ptr [r13 + 0x34]
01827295: nop      word ptr [rax + rax]
018272a0: mov      eax, r15d
018272a3: lea      r8d, [rdx + r10]
018272a7: and      r8, rax
018272aa: mov      eax, dword ptr [r11 + r8*8]
018272ae: cmp      eax, ebp
018272b0: je       0x18272f6
018272b2: cmp      eax, ecx
018272b4: je       0x18272fa
018272b6: inc      edx
018272b8: cmp      edx, r9d
018272bb: jb       0x18272a0
018272bd: mov      r15, qword ptr [rsp + 0x40]
018272c2: mov      eax, edi
018272c4: mov      ecx, eax
018272c6: mov      rax, qword ptr [r13 + 0x58]
018272ca: lea      rdx, [rcx + rcx*2]
018272ce: cmp      byte ptr [rax + rdx*4 + 8], 0
018272d3: jne      0x18272e9
018272d5: mov      edx, dword ptr [r15 + 0xbcd8]
018272dc: call     0x764ee0
018272e1: test     al, al
018272e3: jne      0x1827196
018272e9: movss    xmm1, dword ptr [rip + 0xb9fa6f] ; RVA 0x23c6d60
018272f1: jmp      0x1827196
018272f6: cmp      eax, ecx
018272f8: jne      0x1827306
018272fa: mov      eax, dword ptr [r11 + r8*8 + 4]
018272ff: mov      r15, qword ptr [rsp + 0x40]
01827304: jmp      0x18272c4
01827306: mov      r15, qword ptr [rsp + 0x40]
0182730b: mov      eax, edi
0182730d: jmp      0x18272c4
0182730f: movss    xmm0, dword ptr [r15 + 0xb54]
01827318: mulss    xmm0, dword ptr [r15 + 0xb44]
01827321: jmp      0x1827242
01827326: lea      r13, [r15 + 0xb38]
0182732d: mov      rax, qword ptr [rip + 0x1aff134] ; RVA 0x3326468
01827334: cmp      dword ptr [rax + 0x88], 0
0182733b: je       0x182734f
0182733d: mov      edx, dword ptr [rax + 0x3a8]
01827343: lea      rcx, [rsp + 0x30]
01827348: call     0xfd9ba0
0182734d: jmp      0x182735e
0182734f: mov      eax, dword ptr [rip + 0x1c5c8df] ; RVA 0x3483c34
01827355: mov      dword ptr [rsp + 0x30], eax
01827359: lea      rax, [rsp + 0x30]
0182735e: mov      edx, dword ptr [rax]
01827360: cmp      edx, dword ptr [rip + 0x1c5d622] ; RVA 0x3484988
01827366: je       0x182748e
0182736c: cmp      r14d, edi
0182736f: je       0x182748e
01827375: mov      r11, qword ptr [rip + 0x1aff3bc] ; RVA 0x3326738
0182737c: cmp      edx, esi
0182737e: je       0x18273c7
01827380: mov      r8d, dword ptr [r11 + 0x30]
01827384: mov      r9d, dword ptr [r11 + 0x38]
01827388: imul     r9d, edx
0182738c: lea      esi, [r8 - 1]
01827390: test     r8d, r8d
01827393: je       0x18273c7
01827395: mov      r10, qword ptr [r11 + 0x28]
01827399: xor      ebp, ebp
0182739b: mov      ebx, dword ptr [r11 + 0x34]
0182739f: nop      
018273a0: mov      eax, esi
018273a2: lea      ecx, [r9 + rbp]
018273a6: and      rcx, rax
018273a9: mov      eax, dword ptr [r10 + rcx*8]
018273ad: cmp      eax, ebx
018273af: je       0x18273be
018273b1: cmp      eax, edx
018273b3: je       0x18273c2
018273b5: inc      ebp
018273b7: cmp      ebp, r8d
018273ba: jb       0x18273a0
018273bc: jmp      0x18273c7
018273be: cmp      eax, edx
018273c0: jne      0x18273c7
018273c2: mov      edi, dword ptr [r10 + rcx*8 + 4]
018273c7: mov      rax, qword ptr [r11 + 0x58]
018273cb: mov      ecx, edi
018273cd: mov      edi, dword ptr [rax + rcx*8]
018273d0: mov      rcx, r11
018273d3: inc      edi
018273d5: call     0x9addc0
018273da: movd     xmm1, edi
018273de: mov      ebx, eax
018273e0: cvtdq2ps xmm1, xmm1
018273e3: movd     xmm0, eax
018273e7: cvtdq2ps xmm0, xmm0
018273ea: divss    xmm1, xmm0
018273ee: movss    xmm0, dword ptr [r15 + 0x19e4]
018273f7: ucomiss  xmm0, xmm1
018273fa: jp       0x18273fe
018273fc: je       0x1827413
018273fe: lea      rcx, [r15 + 0xf48]
01827405: movss    dword ptr [r15 + 0x19e4], xmm1
0182740e: call     0x18151b0
01827413: test     ebx, ebx
01827415: jle      0x182743d
01827417: xor      r9d, r9d
0182741a: mov      r8d, edi
0182741d: mov      edx, 0xeb646556
01827422: mov      rcx, r13
01827425: call     0x143c940
0182742a: xor      r9d, r9d
0182742d: mov      r8d, ebx
01827430: mov      edx, 0x4442eb89
01827435: mov      rcx, r13
01827438: call     0x143c940
0182743d: cmp      ebx, dword ptr [r15 + 0xbcec]
01827444: je       0x182748e
01827446: mov      rcx, r13
01827449: mov      dword ptr [r15 + 0xbcec], ebx
01827450: call     0x144e110
01827455: movss    xmm0, dword ptr [r15 + 0xb54]
0182745e: lea      rcx, [r15 + 0xa28]
01827465: mulss    xmm0, dword ptr [r15 + 0xb44]
0182746e: mov      dword ptr [rsp + 0x3c], 0x41c00000
01827476: addss    xmm0, xmm6
0182747a: addss    xmm0, xmm7
0182747e: movss    dword ptr [rsp + 0x38], xmm0
01827484: mov      rdx, qword ptr [rsp + 0x38]
01827489: call     0x14470d0
0182748e: movaps   xmm7, xmmword ptr [rsp + 0x80]
RANGE 0x1827496-0x18275b4
01827496: mov      rcx, qword ptr [rsp + 0x78]
0182749b: xor      rcx, rsp
0182749e: call     0x20886a0
018274a3: lea      r11, [rsp + 0xa0]
018274ab: mov      rbx, qword ptr [r11 + 0x38]
018274af: mov      rbp, qword ptr [r11 + 0x40]
018274b3: mov      rsi, qword ptr [r11 + 0x48]
018274b7: movaps   xmm6, xmmword ptr [r11 - 0x10]
018274bc: mov      rsp, r11
018274bf: pop      r15
018274c1: pop      r14
018274c3: pop      r13
018274c5: pop      r12
018274c7: pop      rdi
018274c8: ret      
018274c9: mov      r13, qword ptr [rsp + 0x40]
018274ce: mov      rcx, r13
018274d1: call     0x18289a0
018274d6: jmp      0x1827496
018274d8: insb     byte ptr [rdi], dx