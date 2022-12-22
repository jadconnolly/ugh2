        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 13:59:55 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE QROMB__genmod
          INTERFACE 
            SUBROUTINE QROMB(FUNC,A,B,SS)
              REAL(KIND=8) :: FUNC
              EXTERNAL FUNC
              REAL(KIND=8) :: A
              REAL(KIND=8) :: B
              REAL(KIND=8) :: SS
            END SUBROUTINE QROMB
          END INTERFACE 
        END MODULE QROMB__genmod
