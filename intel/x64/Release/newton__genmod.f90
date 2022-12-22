        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 13:59:55 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE NEWTON__genmod
          INTERFACE 
            SUBROUTINE NEWTON(FUNC,MAX,MIN,TOL,X,BAD)
              REAL(KIND=8) :: FUNC
              EXTERNAL FUNC
              REAL(KIND=8) :: MAX
              REAL(KIND=8) :: MIN
              REAL(KIND=8) :: TOL
              REAL(KIND=8) :: X
              LOGICAL(KIND=4) :: BAD
            END SUBROUTINE NEWTON
          END INTERFACE 
        END MODULE NEWTON__genmod
