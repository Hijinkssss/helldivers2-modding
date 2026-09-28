RANGE 0x144d880-0x144d8bf
0144d880: push     rdi
0144d882: sub      rsp, 0x40
0144d886: movss    xmm2, dword ptr [rdx]
0144d88a: mov      rdi, rcx
0144d88d: movss    xmm0, dword ptr [rcx + 0x114]
0144d895: ucomiss  xmm0, xmm2
0144d898: jp       0x144d8b0
0144d89a: jne      0x144d8b0
0144d89c: movss    xmm0, dword ptr [rcx + 0x118]
0144d8a4: ucomiss  xmm0, dword ptr [rdx + 4]
0144d8a8: jp       0x144d8b0
0144d8aa: je       0x144da3d
0144d8b0: cmp      byte ptr [rcx + 0x124], 0
0144d8b7: mov      rax, qword ptr [rdx]
0144d8ba: movss    xmm3, dword ptr [rdx + 4]
RANGE 0x144d8bf-0x144d8c4
0144d8bf: mov      qword ptr [rsp + 0x60], rbx
RANGE 0x144d8c4-0x144da16
0144d8c4: movaps   xmmword ptr [rsp + 0x30], xmm6
0144d8c9: movss    xmm6, dword ptr [rip + 0xf7a4eb] ; RVA 0x23c7dbc
0144d8d1: movaps   xmmword ptr [rsp + 0x20], xmm7
0144d8d6: movss    xmm7, dword ptr [rip + 0xf7a472] ; RVA 0x23c7d50
0144d8de: mov      qword ptr [rcx + 0x114], rax
0144d8e5: je       0x144d934
0144d8e7: movss    xmm0, dword ptr [rcx + 0x114]
0144d8ef: movss    xmm1, dword ptr [rcx + 0x118]
0144d8f7: divss    xmm0, xmm6
0144d8fb: divss    xmm1, xmm7
0144d8ff: movss    dword ptr [rsp + 0x50], xmm0
0144d905: movss    dword ptr [rsp + 0x54], xmm1
0144d90b: mov      rdx, qword ptr [rsp + 0x50]
0144d910: mov      qword ptr [rsp + 0x50], rdx
0144d915: divss    xmm2, dword ptr [rsp + 0x50]
0144d91b: divss    xmm3, dword ptr [rsp + 0x54]
0144d921: movss    dword ptr [rsp + 0x58], xmm2
0144d927: movss    dword ptr [rsp + 0x5c], xmm3
0144d92d: mov      rbx, qword ptr [rsp + 0x58]
0144d932: jmp      0x144d97a
0144d934: movss    xmm1, dword ptr [rcx + 0x114]
0144d93c: movss    xmm0, dword ptr [rcx + 0x118]
0144d944: divss    xmm1, xmm6
0144d948: divss    xmm0, xmm7
0144d94c: minss    xmm1, xmm0
0144d950: divss    xmm2, xmm1
0144d954: divss    xmm3, xmm1
0144d958: movss    dword ptr [rsp + 0x50], xmm2
0144d95e: movss    dword ptr [rsp + 0x54], xmm3
0144d964: mov      rbx, qword ptr [rsp + 0x50]
0144d969: movss    dword ptr [rsp + 0x58], xmm1
0144d96f: movss    dword ptr [rsp + 0x5c], xmm1
0144d975: mov      rdx, qword ptr [rsp + 0x58]
0144d97a: mov      qword ptr [rsp + 0x50], rbx
0144d97f: call     0x1447e40
0144d984: mov      rdx, rbx
0144d987: mov      rcx, rdi
0144d98a: call     0x14470d0
0144d98f: movss    xmm1, dword ptr [rsp + 0x50]
0144d995: movss    xmm2, dword ptr [rsp + 0x54]
0144d99b: subss    xmm1, xmm6
0144d99f: mov      rcx, qword ptr [rdi + 0xe8]
0144d9a6: subss    xmm2, xmm7
0144d9aa: mov      qword ptr [rdi + 0x24], rbx
0144d9ae: mulss    xmm1, dword ptr [rip + 0xf7910a] ; RVA 0x23c6ac0
0144d9b6: mulss    xmm2, dword ptr [rip + 0xf79102] ; RVA 0x23c6ac0
0144d9be: movss    dword ptr [rsp + 0x50], xmm1
0144d9c4: movss    dword ptr [rsp + 0x54], xmm2
0144d9ca: mov      rax, qword ptr [rsp + 0x50]
0144d9cf: mov      qword ptr [rdi + 0x11c], rax
0144d9d6: movss    xmm1, dword ptr [rdi + 0x11c]
0144d9de: movss    xmm0, dword ptr [rdi + 0x120]
0144d9e6: addss    xmm1, xmm1
0144d9ea: addss    xmm0, xmm0
0144d9ee: addss    xmm1, xmm6
0144d9f2: movaps   xmm6, xmmword ptr [rsp + 0x30]
0144d9f7: addss    xmm0, xmm7
0144d9fb: movaps   xmm7, xmmword ptr [rsp + 0x20]
0144da00: movss    dword ptr [rsp + 0x50], xmm1
0144da06: movss    dword ptr [rsp + 0x54], xmm0
0144da0c: mov      rbx, qword ptr [rsp + 0x50]
0144da11: test     rcx, rcx
0144da14: je       0x144da21
RANGE 0x144da16-0x144da3d
0144da16: mov      r8b, 1
0144da19: mov      rdx, rbx
0144da1c: call     0x144e4d0
0144da21: mov      rcx, qword ptr [rdi + 0xe0]
0144da28: test     rcx, rcx
0144da2b: je       0x144da38
0144da2d: mov      r8b, 1
0144da30: mov      rdx, rbx
0144da33: call     0x144e4d0
0144da38: mov      rbx, qword ptr [rsp + 0x60]
RANGE 0x144da3d-0x144da43
0144da3d: add      rsp, 0x40
0144da41: pop      rdi
0144da42: ret      