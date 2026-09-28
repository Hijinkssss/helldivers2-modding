RANGE 0x17b6490-0x17b6da9
017b6490: mov      rax, rsp
017b6493: mov      qword ptr [rax + 0x18], rbx
017b6497: push     rbp
017b6498: push     rsi
017b6499: push     rdi
017b649a: push     r12
017b649c: push     r13
017b649e: push     r14
017b64a0: push     r15
017b64a2: lea      rbp, [rax - 0x5f]
017b64a6: sub      rsp, 0x100
017b64ad: movaps   xmmword ptr [rax - 0x48], xmm6
017b64b1: movaps   xmmword ptr [rax - 0x58], xmm7
017b64b5: movaps   xmmword ptr [rax - 0x98], xmm11
017b64bd: mov      rax, qword ptr [rip + 0xe85b4c] ; RVA 0x263c010
017b64c4: xor      rax, rsp
017b64c7: mov      qword ptr [rbp - 0x49], rax
017b64cb: mov      r14d, r8d
017b64ce: movaps   xmm11, xmm1
017b64d2: mov      r15, rcx
017b64d5: test     r8d, r8d
017b64d8: je       0x17b65cd
017b64de: mov      edi, dword ptr [rip + 0x1ccd73c] ; RVA 0x3483c20
017b64e4: xor      r12d, r12d
017b64e7: mov      r10, qword ptr [rip + 0x1b6ff7a] ; RVA 0x3326468
017b64ee: cmp      r8d, edi
017b64f1: je       0x17b654b
017b64f3: mov      r8d, dword ptr [r10 + 0xd8]
017b64fa: mov      ecx, r12d
017b64fd: mov      r9d, dword ptr [r10 + 0xe0]
017b6504: imul     r9d, r14d
017b6508: lea      r13d, [r8 - 1]
017b650c: test     r8d, r8d
017b650f: je       0x17b654b
017b6511: mov      r11, qword ptr [r10 + 0xd0]
017b6518: mov      ebx, dword ptr [r10 + 0xdc]
017b651f: nop      
017b6520: mov      eax, r13d
017b6523: lea      edx, [rcx + r9]
017b6527: and      rdx, rax
017b652a: mov      esi, 0xffffffff
017b652f: mov      eax, dword ptr [r11 + rdx*8]
017b6533: cmp      eax, ebx
017b6535: je       0x17b6610
017b653b: cmp      eax, r14d
017b653e: je       0x17b6619
017b6544: inc      ecx
017b6546: cmp      ecx, r8d
017b6549: jb       0x17b6520
017b654b: mov      esi, 0xffffffff
017b6550: mov      eax, esi
017b6552: mov      ecx, eax
017b6554: shl      rcx, 5
017b6558: mov      edx, dword ptr [rcx + r10 + 0x3a8]
017b6560: lea      rcx, [rsp + 0x24]
017b6565: call     0xfd9ba0
017b656a: mov      ebx, dword ptr [rsp + 0x24]
017b656e: test     ebx, ebx
017b6570: je       0x17b65cd
017b6572: cmp      ebx, edi
017b6574: je       0x17b65cd
017b6576: mov      r10, qword ptr [rip + 0x1b707a3] ; RVA 0x3326d20
017b657d: mov      ecx, r12d
017b6580: mov      r8d, dword ptr [r10 + 0x100]
017b6587: mov      r9d, dword ptr [r10 + 0x108]
017b658e: imul     r9d, ebx
017b6592: lea      r13d, [r8 - 1]
017b6596: test     r8d, r8d
017b6599: je       0x17b65cd
017b659b: mov      r11, qword ptr [r10 + 0xf8]
017b65a2: mov      edi, dword ptr [r10 + 0x104]
017b65a9: nop      dword ptr [rax]
017b65b0: mov      eax, r13d
017b65b3: lea      edx, [rcx + r9]
017b65b7: and      rdx, rax
017b65ba: mov      eax, dword ptr [r11 + rdx*8]
017b65be: cmp      eax, edi
017b65c0: je       0x17b6623
017b65c2: cmp      eax, ebx
017b65c4: je       0x17b6627
017b65c6: inc      ecx
017b65c8: cmp      ecx, r8d
017b65cb: jb       0x17b65b0
017b65cd: mov      edx, 1
017b65d2: mov      rcx, r15
017b65d5: call     0x17b9bf0
017b65da: mov      rcx, qword ptr [rbp - 0x49]
017b65de: xor      rcx, rsp
017b65e1: call     0x20886a0
017b65e6: lea      r11, [rsp + 0x100]
017b65ee: mov      rbx, qword ptr [r11 + 0x50]
017b65f2: movaps   xmm6, xmmword ptr [r11 - 0x10]
017b65f7: movaps   xmm7, xmmword ptr [r11 - 0x20]
017b65fc: movaps   xmm11, xmmword ptr [r11 - 0x60]
017b6601: mov      rsp, r11
017b6604: pop      r15
017b6606: pop      r14
017b6608: pop      r13
017b660a: pop      r12
017b660c: pop      rdi
017b660d: pop      rsi
017b660e: pop      rbp
017b660f: ret      
017b6610: cmp      eax, r14d
017b6613: jne      0x17b6550
017b6619: mov      eax, dword ptr [r11 + rdx*8 + 4]
017b661e: jmp      0x17b6552
017b6623: cmp      eax, ebx
017b6625: jne      0x17b65cd
017b6627: mov      eax, dword ptr [r11 + rdx*8 + 4]
017b662c: cmp      eax, esi
017b662e: je       0x17b65cd
017b6630: mov      qword ptr [rsp + 0x58], rax
017b6635: mov      rax, qword ptr [r10 + rax*8 + 0x110]
017b663d: test     byte ptr [rax + 0x14], 1
017b6641: je       0x17b65cd
017b6643: test     rax, rax
017b6646: je       0x17b65cd
017b6648: mov      rax, qword ptr [rip + 0x1b6fcf1] ; RVA 0x3326340
017b664f: mov      ecx, dword ptr [rax + 0xac530]
017b6655: mov      rax, qword ptr [rip + 0x1b7004c] ; RVA 0x33266a8
017b665c: mov      dword ptr [rsp + 0x24], ecx
017b6660: cmp      dword ptr [rax + 0x2c0], r12d
017b6667: je       0x17b6687
017b6669: mov      eax, dword ptr [rax + 0xcec]
017b666f: cmp      eax, 2
017b6672: jne      0x17b667e
017b6674: mov      dword ptr [rsp + 0x24], 1
017b667c: jmp      0x17b6690
017b667e: cmp      eax, 1
017b6681: je       0x17b65cd
017b6687: cmp      ecx, 2
017b668a: je       0x17b65cd
017b6690: movss    xmm7, dword ptr [rip + 0xc106c8] ; RVA 0x23c6d60
017b6698: lea      rdi, [r15 + 0x1460]
017b669f: mov      r13d, 4
017b66a5: nop      word ptr [rax + rax]
017b66b0: lea      rcx, [rdi - 0x560]
017b66b7: call     0x144f650
017b66bc: test     rax, rax
017b66bf: je       0x17b66ce
017b66c1: movaps   xmm2, xmm7
017b66c4: mov      edx, 0x46ee8889
017b66c9: call     0x1449680
017b66ce: mov      rcx, rdi
017b66d1: call     0x144f650
017b66d6: test     rax, rax
017b66d9: je       0x17b66e8
017b66db: movaps   xmm2, xmm7
017b66de: mov      edx, 0x46ee8889
017b66e3: call     0x1449680
017b66e8: add      rdi, 0x158
017b66ef: sub      r13, 1
017b66f3: jne      0x17b66b0
017b66f5: lea      rcx, [r15 + 0xaf8]
017b66fc: call     0x144f650
017b6701: test     rax, rax
017b6704: je       0x17b6713
017b6706: movaps   xmm2, xmm7
017b6709: mov      edx, 0x46ee8889
017b670e: call     0x1449680
017b6713: lea      rcx, [r15 + 0xda8]
017b671a: call     0x144f650
017b671f: test     rax, rax
017b6722: je       0x17b6731
017b6724: movaps   xmm2, xmm7
017b6727: mov      edx, 0x46ee8889
017b672c: call     0x1449680
017b6731: lea      rcx, [r15 + 0x1dc8]
017b6738: call     0x144f650
017b673d: test     rax, rax
017b6740: je       0x17b674f
017b6742: movaps   xmm2, xmm7
017b6745: mov      edx, 0x46ee8889
017b674a: call     0x1449680
017b674f: lea      rcx, [r15 + 0x19c0]
017b6756: call     0x144f650
017b675b: test     rax, rax
017b675e: je       0x17b676d
017b6760: movaps   xmm2, xmm7
017b6763: mov      edx, 0x46ee8889
017b6768: call     0x1449680
017b676d: lea      rcx, [r15 + 0x1c70]
017b6774: call     0x144f650
017b6779: test     rax, rax
017b677c: je       0x17b678b
017b677e: movaps   xmm2, xmm7
017b6781: mov      edx, 0x46ee8889
017b6786: call     0x1449680
017b678b: lea      rcx, [r15 + 0x1b18]
017b6792: call     0x144f650
017b6797: test     rax, rax
017b679a: je       0x17b67a9
017b679c: movaps   xmm2, xmm7
017b679f: mov      edx, 0x46ee8889
017b67a4: call     0x1449680
017b67a9: mov      rcx, qword ptr [r15 + 0xf0]
017b67b0: test     rcx, rcx
017b67b3: je       0x17b67c1
017b67b5: call     0x144c2e0
017b67ba: mov      qword ptr [rsp + 0x50], rax
017b67bf: jmp      0x17b67c6
017b67c1: mov      qword ptr [rsp + 0x50], r15
017b67c6: imul     rax, qword ptr [rsp + 0x58], 0x78
017b67cc: imul     rdx, qword ptr [rsp + 0x58], 0x1238
017b67d5: mov      rcx, qword ptr [rip + 0x1b70544] ; RVA 0x3326d20
017b67dc: mov      r11, qword ptr [rip + 0x1b6fc3d] ; RVA 0x3326420
017b67e3: add      rdx, rcx
017b67e6: mov      qword ptr [rsp + 0x30], rdx
017b67eb: lea      rdx, [rcx + 0x547830]
017b67f2: add      rdx, rax
017b67f5: mov      eax, dword ptr [rip + 0x1ccd425] ; RVA 0x3483c20
017b67fb: mov      qword ptr [rsp + 0x58], rdx
017b6800: cmp      ebx, eax
017b6802: je       0x17b6847
017b6804: mov      r10d, dword ptr [r11 + 0x40]
017b6808: mov      edx, r12d
017b680b: mov      r9d, dword ptr [r11 + 0x38]
017b680f: imul     r10d, ebx
017b6813: test     r9d, r9d
017b6816: je       0x17b6847
017b6818: mov      rdi, qword ptr [r11 + 0x30]
017b681c: mov      r13d, dword ptr [r11 + 0x3c]
017b6820: lea      ecx, [r9 - 1]
017b6824: lea      r8d, [rdx + r10]
017b6828: and      r8, rcx
017b682b: mov      ecx, dword ptr [rdi + r8*8]
017b682f: cmp      ecx, r13d
017b6832: je       0x17b6a24
017b6838: cmp      ecx, ebx
017b683a: je       0x17b6a2c
017b6840: inc      edx
017b6842: cmp      edx, r9d
017b6845: jb       0x17b6820
017b6847: mov      edi, dword ptr [rip + 0x1ccd3e7] ; RVA 0x3483c34
017b684d: mov      r11, qword ptr [rip + 0x1b70524] ; RVA 0x3326d78
017b6854: cmp      ebx, eax
017b6856: je       0x17b68a7
017b6858: mov      r9d, dword ptr [r11 + 0x30]
017b685c: mov      ecx, r12d
017b685f: mov      r8d, dword ptr [r11 + 0x28]
017b6863: imul     r9d, ebx
017b6867: test     r8d, r8d
017b686a: je       0x17b68a7
017b686c: mov      r10, qword ptr [r11 + 0x20]
017b6870: mov      r13d, dword ptr [r11 + 0x2c]
017b6874: nop      dword ptr [rax]
017b6878: nop      dword ptr [rax + rax]
017b6880: lea      eax, [r8 - 1]
017b6884: lea      edx, [rcx + r9]
017b6888: and      rdx, rax
017b688b: mov      eax, dword ptr [r10 + rdx*8]
017b688f: cmp      eax, r13d
017b6892: je       0x17b6a5c
017b6898: cmp      eax, ebx
017b689a: je       0x17b6a64
017b68a0: inc      ecx
017b68a2: cmp      ecx, r8d
017b68a5: jb       0x17b6880
017b68a7: mov      eax, esi
017b68a9: shl      rax, 6
017b68ad: add      rax, qword ptr [r11 + 0x48]
017b68b1: mov      qword ptr [rbp - 0x71], rax
017b68b5: cmp      byte ptr [r15 + 0x209a], r12b
017b68bc: je       0x17b68cf
017b68be: mov      edx, edi
017b68c0: mov      rcx, r15
017b68c3: call     0x17b6280
017b68c8: mov      byte ptr [r15 + 0x209a], r12b
017b68cf: mov      r13, qword ptr [rsp + 0x58]
017b68d4: xor      r9d, r9d
017b68d7: xorps    xmm0, xmm0
017b68da: xorps    xmm1, xmm1
017b68dd: psrldq   xmm0, 8
017b68e2: movq     rcx, xmm1
017b68e7: and      rcx, 0xfffffffffffffffe
017b68eb: movq     rdx, xmm0
017b68f0: mov      rax, qword ptr [r13 + 0x10]
017b68f4: bts      rdx, 0x14
017b68f9: mov      r8, qword ptr [r13 + 0x18]
017b68fd: and      rax, rdx
017b6900: cmp      rax, rdx
017b6903: mov      rax, qword ptr [r13 + 8]
017b6907: sete     dl
017b690a: and      rax, rcx
017b690d: cmp      rax, rcx
017b6910: mov      ecx, r12d
017b6913: sete     al
017b6916: and      dl, al
017b6918: and      r8, r9
017b691b: movzx    eax, dl
017b691e: cmove    ecx, eax
017b6921: test     cl, cl
017b6923: jne      0x17b65cd
017b6929: xorps    xmm0, xmm0
017b692c: mov      qword ptr [rsp + 0x40], 0x52
017b6935: xor      eax, eax
017b6937: mov      qword ptr [rsp + 0x48], 0x3a
017b6940: movups   xmmword ptr [rbp - 0x61], xmm0
017b6944: mov      qword ptr [rbp - 0x51], rax
017b6948: lea      r8, [rsp + 0x40]
017b694d: nop      dword ptr [rax]
017b6950: mov      edx, dword ptr [r8]
017b6953: add      r8, 8
017b6957: mov      ecx, edx
017b6959: and      edx, 0x3f
017b695c: shr      rcx, 6
017b6960: mov      rax, qword ptr [rbp + rcx*8 - 0x61]
017b6965: bts      rax, rdx
017b6969: mov      qword ptr [rbp + rcx*8 - 0x61], rax
017b696e: lea      rax, [rsp + 0x50]
017b6973: cmp      r8, rax
017b6976: jne      0x17b6950
017b6978: mov      r10, qword ptr [rsp + 0x30]
017b697d: xorps    xmm0, xmm0
017b6980: mov      r9, qword ptr [r10 + 0x53e880]
017b6987: mov      r8, qword ptr [r10 + 0x53e888]
017b698e: mov      rax, r9
017b6991: and      rax, qword ptr [rbp - 0x61]
017b6995: mov      r10, qword ptr [r10 + 0x53e890]
017b699c: test     rax, -2
017b69a2: mov      rdx, r10
017b69a5: setne    cl
017b69a8: test     qword ptr [rbp - 0x59], r8
017b69ac: setne    al
017b69af: or       cl, al
017b69b1: mov      eax, 1
017b69b6: and      rdx, qword ptr [rbp - 0x51]
017b69ba: movzx    r11d, cl
017b69be: movq     rcx, xmm0
017b69c3: cmovne   r11d, eax
017b69c7: psrldq   xmm0, 8
017b69cc: xor      eax, eax
017b69ce: mov      dword ptr [rsp + 0x30], r11d
017b69d3: and      r10, rax
017b69d6: mov      qword ptr [rsp + 0x40], rax
017b69db: bts      rcx, 0x30
017b69e0: movq     rax, xmm0
017b69e5: and      rcx, 0xfffffffffffffffe
017b69e9: and      r8, rax
017b69ec: cmp      r8, rax
017b69ef: sete     dl
017b69f2: and      r9, rcx
017b69f5: cmp      r9, rcx
017b69f8: mov      ecx, r12d
017b69fb: sete     al
017b69fe: and      dl, al
017b6a00: cmp      r10, qword ptr [rsp + 0x40]
017b6a05: movzx    eax, dl
017b6a08: cmove    ecx, eax
017b6a0b: test     cl, cl
017b6a0d: je       0x17b6a6e
017b6a0f: mov      rax, qword ptr [r15 + 0x2078]
017b6a16: test     byte ptr [rax + 8], 0x10
017b6a1a: jne      0x17b6a6e
017b6a1c: xor      al, al
017b6a1e: mov      byte ptr [rsp + 0x20], al
017b6a22: jmp      0x17b6a73
017b6a24: cmp      ecx, ebx
017b6a26: jne      0x17b6847
017b6a2c: mov      ecx, dword ptr [rdi + r8*8 + 4]
017b6a31: cmp      ecx, esi
017b6a33: je       0x17b6847
017b6a39: imul     rdx, rcx, 0x1d0
017b6a40: mov      rcx, qword ptr [r11 + 0x60]
017b6a44: mov      edi, dword ptr [rdx + rcx + 4]
017b6a48: cmp      edi, dword ptr [rip + 0x1ccd1e6] ; RVA 0x3483c34
017b6a4e: jne      0x17b684d
017b6a54: mov      edi, dword ptr [rdx + rcx]
017b6a57: jmp      0x17b684d
017b6a5c: cmp      eax, ebx
017b6a5e: jne      0x17b68a7
017b6a64: mov      eax, dword ptr [r10 + rdx*8 + 4]
017b6a69: jmp      0x17b68a9
017b6a6e: mov      byte ptr [rsp + 0x20], 1
017b6a73: test     r11b, r11b
017b6a76: je       0x17b6a84
017b6a78: test     byte ptr [r13], 1
017b6a7d: mov      byte ptr [rsp + 0x22], 1
017b6a82: jne      0x17b6a89
017b6a84: mov      byte ptr [rsp + 0x22], r12b
017b6a89: mov      rcx, qword ptr [rip + 0x1b6ffe0] ; RVA 0x3326a70
017b6a90: mov      edx, edi
017b6a92: call     0x776010
017b6a97: mov      rcx, qword ptr [rip + 0x1b6f9ca] ; RVA 0x3326468
017b6a9e: mov      byte ptr [rsp + 0x21], al
017b6aa2: cmp      dword ptr [rcx + 0x88], r12d
017b6aa9: je       0x17b6abd
017b6aab: mov      edx, dword ptr [rcx + 0x3a8]
017b6ab1: lea      rcx, [rsp + 0x40]
017b6ab6: call     0xfd9ba0
017b6abb: jmp      0x17b6acc
017b6abd: mov      eax, dword ptr [rip + 0x1ccd171] ; RVA 0x3483c34
017b6ac3: mov      dword ptr [rsp + 0x40], eax
017b6ac7: lea      rax, [rsp + 0x40]
017b6acc: mov      eax, dword ptr [rax]
017b6ace: cmp      eax, dword ptr [rip + 0x1ccdeb4] ; RVA 0x3484988
017b6ad4: je       0x17b6b51
017b6ada: cmp      eax, dword ptr [rip + 0x1ccd140] ; RVA 0x3483c20
017b6ae0: je       0x17b6b30
017b6ae2: mov      rcx, qword ptr [rip + 0x1b70237] ; RVA 0x3326d20
017b6ae9: mov      edx, r12d
017b6aec: mov      r10d, dword ptr [rcx + 0x108]
017b6af3: mov      r9d, dword ptr [rcx + 0x100]
017b6afa: imul     r10d, eax
017b6afe: test     r9d, r9d
017b6b01: je       0x17b6b30
017b6b03: mov      r11, qword ptr [rcx + 0xf8]
017b6b0a: mov      r13d, dword ptr [rcx + 0x104]
017b6b11: lea      ecx, [r9 - 1]
017b6b15: lea      r8d, [rdx + r10]
017b6b19: and      r8, rcx
017b6b1c: mov      ecx, dword ptr [r11 + r8*8]
017b6b20: cmp      ecx, r13d
017b6b23: je       0x17b6b46
017b6b25: cmp      ecx, eax
017b6b27: je       0x17b6b4a
017b6b29: inc      edx
017b6b2b: cmp      edx, r9d
017b6b2e: jb       0x17b6b11
017b6b30: mov      edx, esi
017b6b32: mov      rcx, qword ptr [rip + 0x1b701e7] ; RVA 0x3326d20
017b6b39: call     0x82e0f0
017b6b3e: test     al, al
017b6b40: je       0x17b6b51
017b6b42: mov      cl, 1
017b6b44: jmp      0x17b6b53
017b6b46: cmp      ecx, eax
017b6b48: jne      0x17b6b30
017b6b4a: mov      edx, dword ptr [r11 + r8*8 + 4]
017b6b4f: jmp      0x17b6b32
017b6b51: xor      cl, cl
017b6b53: mov      rax, qword ptr [rbp - 0x71]
017b6b57: movzx    edx, byte ptr [rsp + 0x21]
017b6b5c: mov      r8d, dword ptr [rax + 8]
017b6b60: lea      eax, [r8 - 2]
017b6b64: test     eax, 0xfffffffd
017b6b69: movzx    eax, byte ptr [rsp + 0x20]
017b6b6e: setne    byte ptr [rsp + 0x28]
017b6b73: cmp      byte ptr [rsp + 0x30], r12b
017b6b78: je       0x17b6b82
017b6b7a: test     dl, dl
017b6b7c: jne      0x17b6b82
017b6b7e: test     al, al
017b6b80: jne      0x17b6ba7
017b6b82: cmp      byte ptr [rsp + 0x22], r12b
017b6b87: jne      0x17b6ba7
017b6b89: cmp      dword ptr [rsp + 0x24], r12d
017b6b8e: jne      0x17b6b9c
017b6b90: test     dl, dl
017b6b92: jne      0x17b6b9c
017b6b94: test     al, al
017b6b96: je       0x17b6b9c
017b6b98: test     cl, cl
017b6b9a: je       0x17b6ba7
017b6b9c: mov      r13d, 1
017b6ba2: mov      edx, r13d
017b6ba5: jmp      0x17b6bb2
017b6ba7: mov      edx, 3
017b6bac: mov      r13d, 1
017b6bb2: mov      dword ptr [rsp + 0x24], r13d
017b6bb7: test     al, al
017b6bb9: je       0x17b6bef
017b6bbb: mov      rax, qword ptr [r15 + 0x2078]
017b6bc2: mov      ecx, dword ptr [rax + 4]
017b6bc5: cmp      ecx, 3
017b6bc8: je       0x17b6bef
017b6bca: test     ecx, ecx
017b6bcc: je       0x17b6be8
017b6bce: sub      ecx, 1
017b6bd1: je       0x17b6bde
017b6bd3: cmp      ecx, 1
017b6bd6: jne      0x17b6bf7
017b6bd8: mov      dword ptr [rsp + 0x24], edx
017b6bdc: jmp      0x17b6bf7
017b6bde: mov      dword ptr [rsp + 0x24], 3
017b6be6: jmp      0x17b6bf7
017b6be8: mov      dword ptr [rsp + 0x24], r13d
017b6bed: jmp      0x17b6bf7
017b6bef: mov      dword ptr [rsp + 0x24], 4
017b6bf7: cmp      r8d, 1
017b6bfb: je       0x17b65cd
017b6c01: mov      eax, dword ptr [rip + 0x1ccd019] ; RVA 0x3483c20
017b6c07: test     edi, edi
017b6c09: je       0x17b6c5f
017b6c0b: cmp      edi, eax
017b6c0d: je       0x17b65cd
017b6c13: mov      rcx, qword ptr [rip + 0x1b700c6] ; RVA 0x3326ce0
017b6c1a: mov      edx, r12d
017b6c1d: mov      r10d, dword ptr [rcx + 0x40]
017b6c21: mov      r9d, dword ptr [rcx + 0x38]
017b6c25: imul     r10d, edi
017b6c29: test     r9d, r9d
017b6c2c: je       0x17b6c5f
017b6c2e: mov      r11, qword ptr [rcx + 0x30]
017b6c32: mov      r13d, dword ptr [rcx + 0x3c]
017b6c36: nop      word ptr [rax + rax]
017b6c40: lea      ecx, [r9 - 1]
017b6c44: lea      r8d, [rdx + r10]
017b6c48: and      r8, rcx
017b6c4b: mov      ecx, dword ptr [r11 + r8*8]
017b6c4f: cmp      ecx, r13d
017b6c52: je       0x17b6cbd
017b6c54: cmp      ecx, edi
017b6c56: je       0x17b6cc1
017b6c58: inc      edx
017b6c5a: cmp      edx, r9d
017b6c5d: jb       0x17b6c40
017b6c5f: cmp      edi, eax
017b6c61: je       0x17b65cd
017b6c67: mov      rax, qword ptr [rip + 0x1b6f852] ; RVA 0x33264c0
017b6c6e: mov      ecx, r12d
017b6c71: mov      r8d, dword ptr [rax + 0x38]
017b6c75: mov      r9d, dword ptr [rax + 0x40]
017b6c79: imul     r9d, edi
017b6c7d: lea      r13d, [r8 - 1]
017b6c81: test     r8d, r8d
017b6c84: je       0x17b65cd
017b6c8a: mov      r10, qword ptr [rax + 0x30]
017b6c8e: mov      r11d, dword ptr [rax + 0x3c]
017b6c92: mov      eax, r13d
017b6c95: lea      edx, [rcx + r9]
017b6c99: and      rdx, rax
017b6c9c: mov      eax, dword ptr [r10 + rdx*8]
017b6ca0: cmp      eax, r11d
017b6ca3: je       0x17b6d8f
017b6ca9: cmp      eax, edi
017b6cab: je       0x17b6d97
017b6cb1: inc      ecx
017b6cb3: cmp      ecx, r8d
017b6cb6: jb       0x17b6c92
017b6cb8: jmp      0x17b65cd
017b6cbd: cmp      ecx, edi
017b6cbf: jne      0x17b6c5f
017b6cc1: cmp      dword ptr [r11 + r8*8 + 4], esi
017b6cc6: je       0x17b6c5f
017b6cc8: mov      rax, qword ptr [rip + 0x1b6f639] ; RVA 0x3326308
017b6ccf: mov      rcx, qword ptr [rax + 0xd0]
017b6cd6: call     qword ptr [rcx + 0x2b8]
017b6cdc: mov      qword ptr [rsp + 0x30], rax
017b6ce1: mov      rax, qword ptr [rip + 0x1cb6878] ; RVA 0x346d560
017b6ce8: movss    xmm4, dword ptr [rsp + 0x30]
017b6cee: movaps   xmm2, xmm4
017b6cf1: movss    xmm5, dword ptr [rsp + 0x34]
017b6cf7: movaps   xmm3, xmm5
017b6cfa: mulss    xmm2, dword ptr [rip + 0xc0fdbe] ; RVA 0x23c6ac0
017b6d02: mulss    xmm3, dword ptr [rip + 0xc0fdb6] ; RVA 0x23c6ac0
017b6d0a: movaps   xmm0, xmm2
017b6d0d: mulss    xmm0, dword ptr [rax + 0xdc]
017b6d15: movaps   xmm1, xmm3
017b6d18: mulss    xmm1, dword ptr [rax + 0xe0]
017b6d20: addss    xmm2, xmm0
017b6d24: movsd    xmm0, qword ptr [rax + 0xe4]
017b6d2c: movsd    qword ptr [rbp - 0x71], xmm0
017b6d31: addss    xmm3, xmm1
017b6d35: cmp      byte ptr [rsp + 0x28], r12b
017b6d3a: je       0x17b6d4e
017b6d3c: mov      rdx, qword ptr [rsp + 0x58]
017b6d41: test     byte ptr [rdx], 1
017b6d44: je       0x17b6d4e
017b6d46: movaps   xmm1, xmm2
017b6d49: movaps   xmm0, xmm3
017b6d4c: jmp      0x17b6d58
017b6d4e: movss    xmm0, dword ptr [rbp - 0x6d]
017b6d53: movss    xmm1, dword ptr [rbp - 0x71]
017b6d58: mov      rax, qword ptr [rsp + 0x50]
017b6d5d: movss    dword ptr [r15 + 0x2088], xmm1
017b6d66: subss    xmm1, xmm2
017b6d6a: movss    dword ptr [r15 + 0x208c], xmm0
017b6d73: subss    xmm0, xmm3
017b6d77: divss    xmm1, xmm4
017b6d7b: divss    xmm0, xmm5
017b6d7f: mulss    xmm1, dword ptr [rax + 0xc]
017b6d84: movss    dword ptr [rsp + 0x58], xmm1
017b6d8a: jmp      0x17b6f80
017b6d8f: cmp      eax, edi
017b6d91: jne      0x17b65cd
017b6d97: cmp      dword ptr [r10 + rdx*8 + 4], esi
017b6d9c: je       0x17b65cd
017b6da2: mov      rax, qword ptr [rip + 0x1b6f55f] ; RVA 0x3326308
RANGE 0x17b6da9-0x17b6f80
017b6da9: movaps   xmmword ptr [rsp + 0xd0], xmm8
017b6db2: movaps   xmmword ptr [rsp + 0xc0], xmm9
017b6dbb: movaps   xmmword ptr [rsp + 0xb0], xmm10
017b6dc4: mov      rcx, qword ptr [rax + 0xd0]
017b6dcb: call     qword ptr [rcx + 0x2b8]
017b6dd1: cmp      ebx, dword ptr [rip + 0x1ccce49] ; RVA 0x3483c20
017b6dd7: mov      r13, qword ptr [rip + 0x1cb6782] ; RVA 0x346d560
017b6dde: mov      rdi, qword ptr [rip + 0x1b6f723] ; RVA 0x3326508
017b6de5: mov      qword ptr [rsp + 0x58], rax
017b6dea: movss    xmm9, dword ptr [rsp + 0x58]
017b6df1: movss    xmm10, dword ptr [rbp - 0x7d]
017b6df7: movaps   xmm6, xmm9
017b6dfb: mulss    xmm6, dword ptr [rip + 0xc0fcbd] ; RVA 0x23c6ac0
017b6e03: movaps   xmm8, xmm10
017b6e07: mulss    xmm8, dword ptr [rip + 0xc0fcb0] ; RVA 0x23c6ac0
017b6e10: movaps   xmm0, xmm6
017b6e13: mulss    xmm0, dword ptr [r13 + 0xdc]
017b6e1c: movaps   xmm1, xmm8
017b6e20: mulss    xmm1, dword ptr [r13 + 0xe0]
017b6e29: addss    xmm6, xmm0
017b6e2d: addss    xmm8, xmm1
017b6e32: je       0x17b6e7a
017b6e34: mov      edx, dword ptr [rdi + 0x48]
017b6e37: mov      r8d, dword ptr [rdi + 0x50]
017b6e3b: imul     r8d, ebx
017b6e3f: lea      r11d, [rdx - 1]
017b6e43: test     edx, edx
017b6e45: je       0x17b6e7a
017b6e47: mov      r9, qword ptr [rdi + 0x40]
017b6e4b: mov      r10d, dword ptr [rdi + 0x4c]
017b6e4f: nop      
017b6e50: mov      eax, r11d
017b6e53: lea      ecx, [r12 + r8]
017b6e57: and      rcx, rax
017b6e5a: mov      eax, dword ptr [r9 + rcx*8]
017b6e5e: cmp      eax, r10d
017b6e61: je       0x17b6e71
017b6e63: cmp      eax, ebx
017b6e65: je       0x17b6e75
017b6e67: inc      r12d
017b6e6a: cmp      r12d, edx
017b6e6d: jb       0x17b6e50
017b6e6f: jmp      0x17b6e7a
017b6e71: cmp      eax, ebx
017b6e73: jne      0x17b6e7a
017b6e75: mov      esi, dword ptr [r9 + rcx*8 + 4]
017b6e7a: movss    xmm3, dword ptr [rip + 0xc1086a] ; RVA 0x23c76ec
017b6e82: lea      r8, [rbp - 0x71]
017b6e86: mov      eax, esi
017b6e88: imul     rcx, rax, 0x308
017b6e8f: mov      rax, qword ptr [rdi + 0x68]
017b6e93: movsd    xmm0, qword ptr [rcx + rax + 0x2e0]
017b6e9c: movsd    qword ptr [rbp - 0x71], xmm0
017b6ea1: mov      eax, dword ptr [rcx + rax + 0x2e8]
017b6ea8: movss    xmm0, dword ptr [rbp - 0x71]
017b6ead: mov      dword ptr [rbp - 0x69], eax
017b6eb0: movsd    xmm2, qword ptr [r13 + 0x1c]
017b6eb6: mov      eax, dword ptr [r13 + 0x44]
017b6eba: movaps   xmm1, xmm2
017b6ebd: mulss    xmm1, xmm3
017b6ec1: mov      dword ptr [rsp + 0x38], eax
017b6ec5: mov      eax, dword ptr [r13 + 0x24]
017b6ec9: mov      dword ptr [rbp - 0x79], eax
017b6ecc: mov      rax, qword ptr [rip + 0x1b6f435] ; RVA 0x3326308
017b6ed3: addss    xmm0, xmm1
017b6ed7: movaps   xmm1, xmm2
017b6eda: movsd    qword ptr [rsp + 0x58], xmm2
017b6ee0: shufps   xmm1, xmm1, 0x55
017b6ee4: mulss    xmm1, xmm3
017b6ee8: movss    dword ptr [rbp - 0x71], xmm0
017b6eed: movss    xmm0, dword ptr [rbp - 0x6d]
017b6ef2: addss    xmm0, xmm1
017b6ef6: movss    xmm1, dword ptr [rbp - 0x79]
017b6efb: mulss    xmm1, xmm3
017b6eff: addss    xmm1, dword ptr [rsp + 0x38]
017b6f05: movss    dword ptr [rbp - 0x6d], xmm0
017b6f0a: movss    dword ptr [rbp - 0x69], xmm1
017b6f0f: mov      rcx, qword ptr [rax + 0x20]
017b6f13: mov      rdx, qword ptr [r13]
017b6f17: mov      rax, qword ptr [rcx + 0xf8]
017b6f1e: lea      rcx, [rsp + 0x58]
017b6f23: call     rax
017b6f25: movsd    xmm1, qword ptr [rax]
017b6f29: mov      rax, qword ptr [rsp + 0x50]
017b6f2e: movaps   xmm0, xmm1
017b6f31: movss    dword ptr [r15 + 0x2088], xmm1
017b6f3a: subss    xmm1, xmm6
017b6f3e: shufps   xmm0, xmm0, 0x55
017b6f42: movss    dword ptr [r15 + 0x208c], xmm0
017b6f4b: subss    xmm0, xmm8
017b6f50: movaps   xmm8, xmmword ptr [rsp + 0xd0]
017b6f59: divss    xmm1, xmm9
017b6f5e: movaps   xmm9, xmmword ptr [rsp + 0xc0]
017b6f67: mulss    xmm1, dword ptr [rax + 0xc]
017b6f6c: divss    xmm0, xmm10
017b6f71: movaps   xmm10, xmmword ptr [rsp + 0xb0]
017b6f7a: movss    dword ptr [rsp + 0x58], xmm1
RANGE 0x17b6f80-0x17b7118
017b6f80: mulss    xmm0, dword ptr [rax + 0x10]
017b6f85: mov      rcx, r15
017b6f88: mov      edx, dword ptr [rsp + 0x24]
017b6f8c: movss    dword ptr [rbp - 0x7d], xmm0
017b6f91: mov      rax, qword ptr [rsp + 0x58]
017b6f96: mov      qword ptr [r15 + 0x2090], rax
017b6f9d: call     0x17b9bf0
017b6fa2: mov      ecx, dword ptr [r15 + 0x2080]
017b6fa9: xorps    xmm6, xmm6
017b6fac: sub      ecx, 2
017b6faf: je       0x17b7035
017b6fb5: sub      ecx, 1
017b6fb8: je       0x17b7013
017b6fba: cmp      ecx, 1
017b6fbd: jne      0x17b70bf
017b6fc3: mov      rdx, qword ptr [r15 + 0x2090]
017b6fca: lea      rcx, [r15 + 0x330]
017b6fd1: call     0x1447610
017b6fd6: cmp      dword ptr [r15 + 0x2084], 0
017b6fde: je       0x17b70bf
017b6fe4: movss    xmm0, dword ptr [r15 + 0x20b4]
017b6fed: subss    xmm0, xmm11
017b6ff2: comiss   xmm6, xmm0
017b6ff5: movss    dword ptr [r15 + 0x20b4], xmm0
017b6ffe: jbe      0x17b70bf
017b7004: xor      edx, edx
017b7006: mov      rcx, r15
017b7009: call     0x17b9180
017b700e: jmp      0x17b70bf
017b7013: cmp      qword ptr [r15 + 0x2078], 0
017b701b: je       0x17b70bf
017b7021: mov      r8d, r14d
017b7024: movaps   xmm1, xmm11
017b7028: mov      rcx, r15
017b702b: call     0x17b7120
017b7030: jmp      0x17b70bf
017b7035: movzx    esi, byte ptr [rsp + 0x21]
017b703a: xorps    xmm2, xmm2
017b703d: test     sil, sil
017b7040: je       0x17b7071
017b7042: mov      edx, ebx
017b7044: call     0x7ca040
017b7049: mov      edi, eax
017b704b: test     eax, eax
017b704d: je       0x17b706e
017b704f: mov      edx, ebx
017b7051: call     0x7c9f70
017b7056: xorps    xmm2, xmm2
017b7059: mov      ecx, eax
017b705b: xorps    xmm0, xmm0
017b705e: cvtsi2ss xmm0, rdi
017b7063: cvtsi2ss xmm2, rcx
017b7068: divss    xmm2, xmm0
017b706c: jmp      0x17b7071
017b706e: xorps    xmm2, xmm2
017b7071: cmp      byte ptr [r15 + 0x2098], sil
017b7078: je       0x17b708a
017b707a: movss    dword ptr [r15 + 0x20a4], xmm2
017b7083: mov      byte ptr [r15 + 0x2098], sil
017b708a: test     sil, sil
017b708d: je       0x17b70bf
017b708f: lea      rcx, [r15 + 0x6f0]
017b7096: call     0x144f650
017b709b: test     rax, rax
017b709e: je       0x17b70bf
017b70a0: movss    xmm0, dword ptr [r15 + 0x20a4]
017b70a9: mov      edx, 0x5d58512
017b70ae: subss    xmm2, xmm0
017b70b2: subss    xmm7, xmm0
017b70b6: divss    xmm2, xmm7
017b70ba: call     0x1449680
017b70bf: cmp      dword ptr [r15 + 0x2080], 3
017b70c7: je       0x17b65da
017b70cd: mov      rax, qword ptr [r15 + 0x2078]
017b70d4: test     rax, rax
017b70d7: je       0x17b65da
017b70dd: test     byte ptr [rax + 8], 2
017b70e1: je       0x17b65da
017b70e7: mulss    xmm11, dword ptr [rax + 0x60]
017b70ed: movss    xmm1, dword ptr [r15 + 0x20ac]
017b70f6: movaps   xmm0, xmm1
017b70f9: subss    xmm0, xmm11
017b70fe: comiss   xmm6, xmm0
017b7101: ja       0x17b710a
017b7103: movaps   xmm6, xmm1
017b7106: minss    xmm6, xmm0
017b710a: movss    dword ptr [r15 + 0x20ac], xmm6
017b7113: jmp      0x17b65da