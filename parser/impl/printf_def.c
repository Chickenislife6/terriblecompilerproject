char* printf_def = "\t.file \"%s\"\r"
   "\t.text\r"
   "\t.def\tprintf;\t.sc"
   "l\t3;\t.type\t32;\t."
   "endef\r"
   "\t.seh_proc\tprintf"
   "\r"
   "printf:\r"
   "\tpushq\t%%rbp\r"
   "\t.seh_pushreg\t%%rbp"
   "\r"
   "\tpushq\t%%rbx\r"
   "\t.seh_pushreg\t%%rbx"
   "\r"
   "\tsubq\t$56, %%rsp\r"
   ""
   "\t.seh_stackalloc\t5"
   "6\r"
   "\tleaq\t48(%%rsp), %%r"
   "bp\r"
   "\t.seh_setframe\t%%rb"
   "p, 48\r"
   "\t.seh_endprologue\r"
   ""
   "\tmovq\t%%rcx, 32(%%rb"
   "p)\r"
   "\tmovq\t%%rdx, 40(%%rb"
   "p)\r"
   "\tmovq\t%%r8, 48(%%rbp"
   ")\r"
   "\tmovq\t%%r9, 56(%%rbp"
   ")\r"
   "\tleaq\t40(%%rbp), %%r"
   "ax\r"
   "\tmovq\t%%rax, -16(%%r"
   "bp)\r"
   "\tmovq\t-16(%%rbp), %%"
   "rbx\r"
   "\tmovl\t$1, %%ecx\r"
   "\tmovq\t__imp___acrt"
   "_iob_func(%%rip), %%ra"
   "x\r"
   "\tcall\t*%%rax\r"
   "\tmovq\t%%rbx, %%r8\r"
   ""
   "\tmovq\t32(%%rbp), %%r"
   "dx\r"
   "\tmovq\t%%rax, %%rcx\r"
   ""
   "\tcall\t__mingw_vfpr"
   "intf\r"
   "\tmovl\t%%eax, -4(%%rb"
   "p)\r"
   "\tmovl\t-4(%%rbp), %%e"
   "ax\r"
   "\taddq\t$56, %%rsp\r"
   ""
   "\tpopq\t%%rbx\r"
   "\tpopq\t%%rbp\r"
   "\tret\r"
   "\t.seh_endproc\r";