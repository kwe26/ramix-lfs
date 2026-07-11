.globl fact:
    LI R1, %1

    CMP R2, R0, R1
    JN R2, base
    JZ R2, base

    PUSH R0

    SUB R0, R0, R1

    CALL fact

    POP R1

    MUL R0, R0, R1

    RET

base:
    LI R0, %1
    RET
