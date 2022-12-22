        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 13:59:32 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE SOLVE__genmod
          INTERFACE 
            FUNCTION SOLVE(C,Q,X,JCHG,ICHG,BAD)
              REAL(KIND=8) :: C(*)
              REAL(KIND=8) :: Q(*)
              REAL(KIND=8) :: X
              INTEGER(KIND=4) :: JCHG(*)
              INTEGER(KIND=4) :: ICHG
              LOGICAL(KIND=4) :: BAD
              REAL(KIND=8) :: SOLVE
            END FUNCTION SOLVE
          END INTERFACE 
        END MODULE SOLVE__genmod
