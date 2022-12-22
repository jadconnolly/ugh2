        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 13:59:55 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE HALVER__genmod
          INTERFACE 
            SUBROUTINE HALVER(FUNC,MAX,MIN,TOL,X)
              REAL(KIND=8) :: FUNC
              EXTERNAL FUNC
              REAL(KIND=8) :: MAX
              REAL(KIND=8) :: MIN
              REAL(KIND=8) :: TOL
              REAL(KIND=8) :: X
            END SUBROUTINE HALVER
          END INTERFACE 
        END MODULE HALVER__genmod
