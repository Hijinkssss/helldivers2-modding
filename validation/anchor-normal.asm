RANGE 0x17b7621-0x17b7674
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