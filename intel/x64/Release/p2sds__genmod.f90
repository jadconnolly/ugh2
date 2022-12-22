        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 13:59:33 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE P2SDS__genmod
          INTERFACE 
            SUBROUTINE P2SDS(S,DSDP,NVAR,IDS,BAD,BADP)
              REAL(KIND=8) :: S
              REAL(KIND=8) :: DSDP(*)
              INTEGER(KIND=4) :: NVAR
              INTEGER(KIND=4) :: IDS
              LOGICAL(KIND=4) :: BAD
              LOGICAL(KIND=4) :: BADP(*)
            END SUBROUTINE P2SDS
          END INTERFACE 
        END MODULE P2SDS__genmod
