0804844b <main>:
 804844b: 8d 4c 24 04           lea    ecx,[esp+0x4]
 804844f: 83 e4 f0              and    esp,0xfffffff0
 8048452: ff 71 fc              push   DWORD PTR [ecx-0x4]
 8048455: 55                    push   ebp
 8048456: 89 e5                 mov    ebp,esp
 8048458: 53                    push   ebx
 8048459: 51                    push   ecx
 804845a: 83 ec 10              sub    esp,0x10
 804845d: 89 cb                 mov    ebx,ecx
 804845f: 8b 43 04              mov    eax,DWORD PTR [ebx+0x4]
 8048462: 83 c0 04              add    eax,0x4
 8048465: 8b 00                 mov    eax,DWORD PTR [eax]
 8048467: 83 ec 04              sub    esp,0x4

 ; sscanf the first argument of argv (argv[1]), data variable
 804846a: ff 75 ec              push   DWORD PTR [ebp-0x14]
 804846d: 68 10 86 04 08        push   0x8048610
 8048472: 50                    push   eax
 8048473: e8 c8 fe ff ff        call   8048340 <__isoc99_sscanf@plt>
 8048478: 83 c4 10              add    esp,0x10
 804847b: 8b 43 04              mov    eax,DWORD PTR [ebx+0x4]
 804847e: 83 c0 08              add    eax,0x8
 8048481: 8b 00                 mov    eax,DWORD PTR [eax]
 8048483: 83 ec 04              sub    esp,0x4

 ; sscanf the second argument of argv (argv[2]), magic variable
 8048486: 8d 55 e8              lea    edx,[ebp-0x18]
 8048489: 52                    push   edx
 804848a: 68 13 86 04 08        push   0x8048613
 804848f: 50                    push   eax
 8048490: e8 ab fe ff ff        call   8048340 <__isoc99_sscanf@plt>
 8048495: 83 c4 10              add    esp,0x10
 8048498: 8b 45 e8              mov    eax,DWORD PTR [ebp-0x18]

 ; check magic == 0x31337987 (825457031 in decimal)
 804849b: 3d 87 79 33 31        cmp    eax,0x31337987
 80484a0: 75 10                 jne    80484b2 <main+0x67>
 80484a2: 83 ec 0c              sub    esp,0xc
 80484a5: 68 16 86 04 08        push   0x8048616
 80484aa: e8 61 fe ff ff        call   8048310 <puts@plt>
 80484af: 83 c4 10              add    esp,0x10
 80484b2: 8b 45 e8              mov    eax,DWORD PTR [ebp-0x18]

 ; check convoluted predicate part 1 (magic < 100)
 80484b5: 83 f8 63              cmp    eax,0x63
 80484b8: 7f 66                 jg     8048520 <main+0xd5>
 80484ba: 8b 4d e8              mov    ecx,DWORD PTR [ebp-0x18]
 80484bd: ba 89 88 88 88        mov    edx,0x88888889
 80484c2: 89 c8                 mov    eax,ecx
 80484c4: f7 ea                 imul   edx
 80484c6: 8d 04 0a              lea    eax,[edx+ecx*1]
 80484c9: c1 f8 03              sar    eax,0x3
 80484cc: 89 c2                 mov    edx,eax
 80484ce: 89 c8                 mov    eax,ecx
 80484d0: c1 f8 1f              sar    eax,0x1f
 80484d3: 29 c2                 sub    edx,eax
 80484d5: 89 d0                 mov    eax,edx
 80484d7: 89 c2                 mov    edx,eax
 80484d9: c1 e2 04              shl    edx,0x4
 80484dc: 29 c2                 sub    edx,eax
 80484de: 89 c8                 mov    eax,ecx
 80484e0: 29 d0                 sub    eax,edx
 80484e2: 83 f8 02              cmp    eax,0x2

 ; check convoluted predicate part 2 (magic % 15 == 2)
 80484e5: 75 39                 jne    8048520 <main+0xd5>
 80484e7: 8b 4d e8              mov    ecx,DWORD PTR [ebp-0x18]
 80484ea: ba e9 a2 8b 2e        mov    edx,0x2e8ba2e9
 80484ef: 89 c8                 mov    eax,ecx
 80484f1: f7 ea                 imul   edx
 80484f3: d1 fa                 sar    edx,1
 80484f5: 89 c8                 mov    eax,ecx
 80484f7: c1 f8 1f              sar    eax,0x1f
 80484fa: 29 c2                 sub    edx,eax
 80484fc: 89 d0                 mov    eax,edx
 80484fe: c1 e0 02              shl    eax,0x2
 8048501: 01 d0                 add    eax,edx
 8048503: 01 c0                 add    eax,eax
 8048505: 01 d0                 add    eax,edx
 8048507: 29 c1                 sub    ecx,eax
 8048509: 89 ca                 mov    edx,ecx
 804850b: 83 fa 06              cmp    edx,0x6

 ; check convoluted predicate part 3 (magic % 11 == 6). only 17 will match
 804850e: 75 10                 jne    8048520 <main+0xd5>
 8048510: 83 ec 0c              sub    esp,0xc
 8048513: 68 29 86 04 08        push   0x8048629
 8048518: e8 f3 fd ff ff        call   8048310 <puts@plt>
 804851d: 83 c4 10              add    esp,0x10
 8048520: c7 45 f4 00 00 00 00  mov    DWORD PTR [ebp-0xc],0x0
 8048527: c7 45 f0 00 00 00 00  mov    DWORD PTR [ebp-0x10],0x0

 ; Start of loop
 804852e: eb 17                 jmp    8048547 <main+0xfc>
 8048530: 8b 55 f0              mov    edx,DWORD PTR [ebp-0x10]
 8048533: 8b 45 ec              mov    eax,DWORD PTR [ebp-0x14]
 8048536: 01 d0                 add    eax,edx
 8048538: 0f b6 00              movzx  eax,BYTE PTR [eax]

 ; compare with Z and add to counter
 804853b: 3c 5a                 cmp    al,0x5a
 804853d: 75 04                 jne    8048543 <main+0xf8>
 804853f: 83 45 f4 01           add    DWORD PTR [ebp-0xc],0x1
 8048543: 83 45 f0 01           add    DWORD PTR [ebp-0x10],0x1
 8048547: 83 7d f0 63           cmp    DWORD PTR [ebp-0x10],0x63
 804854b: 7e e3                 jle    8048530 <main+0xe5>

 ; check (count >= 8 && count <= 16)
 804854d: 83 7d f4 07           cmp    DWORD PTR [ebp-0xc],0x7
 8048551: 7e 16                 jle    8048569 <main+0x11e>
 8048553: 83 7d f4 10           cmp    DWORD PTR [ebp-0xc],0x10
 8048557: 7f 10                 jg     8048569 <main+0x11e>
 8048559: 83 ec 0c              sub    esp,0xc
 804855c: 68 47 86 04 08        push   0x8048647
 8048561: e8 aa fd ff ff        call   8048310 <puts@plt>
 8048566: 83 c4 10              add    esp,0x10

 ; return 0
 8048569: b8 00 00 00 00        mov    eax,0x0
 804856e: 8d 65 f8              lea    esp,[ebp-0x8]
 8048571: 59                    pop    ecx
 8048572: 5b                    pop    ebx
 8048573: 5d                    pop    ebp
 8048574: 8d 61 fc              lea    esp,[ecx-0x4]
 8048577: c3                    ret
 8048578: 66 90                 xchg   ax,ax
 804857a: 66 90                 xchg   ax,ax
 804857c: 66 90                 xchg   ax,ax
 804857e: 66 90                 xchg   ax,ax
