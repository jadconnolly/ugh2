        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 13:59:55 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE SIMPS__genmod
          INTERFACE 
            SUBROUTINE SIMPS(FUNC,A,B,DX,SS)
              REAL(KIND=8) :: FUNC
              EXTERNAL FUNC
              REAL(KIND=8) :: A
              REAL(KIND=8) :: B
              REAL(KIND=8) :: DX
              REAL(KIND=8) :: SS
            END SUBROUTINE SIMPS
          END INTERFACE 
        END MODULE SIMPS__genmod
