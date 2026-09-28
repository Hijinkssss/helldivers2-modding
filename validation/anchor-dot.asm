RANGE 0x17b4f92-0x17b5013
017b4f92: lea      rdi, [r13 + 0x848]
017b4f99: mov      eax, ecx
017b4f9b: bts      ecx, 0xe
017b4f9f: btr      eax, 0xe
017b4fa3: test     dl, dl
017b4fa5: mov      edx, 3
017b4faa: cmove    ecx, eax
017b4fad: mov      dword ptr [r13], ecx
017b4fb1: mov      rcx, rdi
017b4fb4: call     0x14467b0
017b4fb9: mov      qword ptr [rbp + 0x67], r15
017b4fbd: mov      rax, r15
017b4fc0: mov      qword ptr [rdi + 0x114], rax
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