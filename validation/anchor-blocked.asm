RANGE 0x17b78ec-0x17b793d
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