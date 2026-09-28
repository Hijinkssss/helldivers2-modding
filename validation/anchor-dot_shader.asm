RANGE 0x17b4fc7-0x17b5066
017b4fc7: movabs   rbx, 0x677262d652023d08
017b4fd1: mov      dword ptr [rbp + 0x67], 0x3f800000
017b4fd8: xor      r8d, r8d
017b4fdb: mov      dword ptr [rbp + 0x6b], 0x3f800000
017b4fe2: mov      rdx, rbx
017b4fe5: mov      rax, qword ptr [rbp + 0x67]
017b4fe9: mov      rcx, rdi
017b4fec: mov      qword ptr [rdi + 0x11c], rax
017b4ff3: mov      dword ptr [rdi + 0x110], 0xffffffff
017b4ffd: mov      qword ptr [rdi + 0x148], r15
017b5004: mov      qword ptr [rdi + 0x150], r15
017b500b: call     0x144f770
017b5010: mov      rcx, rdi
017b5013: call     0x144f650
017b5018: test     rax, rax
017b501b: je       0x17b502e
017b501d: lea      r8, [rip + 0xa2dbdc] ; RVA 0x21e2c00
017b5024: mov      edx, 0x7701209e
017b5029: call     0x1449830
017b502e: mov      rcx, rdi
017b5031: call     0x144f650
017b5036: test     rax, rax
017b5039: je       0x17b509d
017b503b: call     0x144f650
017b5040: mov      rdx, rax
017b5043: call     0x1449370
017b5048: mov      rcx, qword ptr [rip + 0x1b712b9] ; RVA 0x3326308
017b504f: lea      r8, [rip + 0xa30352] ; RVA 0x21e53a8
017b5056: mov      edx, 0xe13777ce
017b505b: mov      r9, qword ptr [rcx + 0x28]
017b505f: mov      rcx, rax
017b5062: call     qword ptr [r9 + 8]