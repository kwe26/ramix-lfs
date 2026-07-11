.extern fact

n: DQ 5

.entry main:
  LI R0, n
  LOAD64 R0, R0
  CALL fact
  HALT
