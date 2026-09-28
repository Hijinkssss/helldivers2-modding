RANGE 0x17b5a85-0x17b5b21
017b5a85: movabs   rdx, 0x1fc3c735d4547c90
017b5a8f: mov      dword ptr [rbp + 0x67], 0x3f800000
017b5a96: xor      r8d, r8d
017b5a99: mov      dword ptr [rbp + 0x6b], 0x3f800000
017b5aa0: mov      rcx, rbx
017b5aa3: mov      rax, qword ptr [rbp + 0x67]
017b5aa7: mov      qword ptr [rbx + 0x11c], rax
017b5aae: mov      dword ptr [rbx + 0x110], 0xffffffff
017b5ab8: mov      qword ptr [rbx + 0x148], r15
017b5abf: mov      qword ptr [rbx + 0x150], r15
017b5ac6: call     0x144f770
017b5acb: mov      rcx, rbx
017b5ace: call     0x144f650
017b5ad3: test     rax, rax
017b5ad6: je       0x17b5ae9
017b5ad8: lea      r8, [rip + 0xa2d121] ; RVA 0x21e2c00
017b5adf: mov      edx, 0x7701209e
017b5ae4: call     0x1449830
017b5ae9: mov      rcx, rbx
017b5aec: call     0x144f650
017b5af1: test     rax, rax
017b5af4: je       0x17b5b5c
017b5af6: call     0x144f650
017b5afb: mov      rdx, rax
017b5afe: call     0x1449370
017b5b03: mov      rcx, qword ptr [rip + 0x1b707fe] ; RVA 0x3326308
017b5b0a: lea      r8, [rip + 0xa2f897] ; RVA 0x21e53a8
017b5b11: mov      edx, 0xe13777ce
017b5b16: mov      r9, qword ptr [rcx + 0x28]
017b5b1a: mov      rcx, rax
017b5b1d: call     qword ptr [r9 + 8]