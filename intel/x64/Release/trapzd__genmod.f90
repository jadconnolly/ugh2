        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 13:59:55 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE TRAPZD__genmod
          INTERFACE 
            SUBROUTINE TRAPZD(FUNC,A,B,S,J)
              REAL(KIND=8) :: FUNC
              EXTERNAL FUNC
              REAL(KIND=8) :: A
              REAL(KIND=8) :: B
              REAL(KIND=8) :: S
              INTEGER(KIND=4) :: J
            END SUBROUTINE TRAPZD
          END INTERFACE 
        END MODULE TRAPZD__genmod
