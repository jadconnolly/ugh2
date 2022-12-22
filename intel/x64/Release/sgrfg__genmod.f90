        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 14:00:04 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE SGRFG__genmod
          INTERFACE 
            SUBROUTINE SGRFG(N,ALPHA,X,INCX,TOL,ZETA)
              INTEGER(KIND=4) :: N
              REAL(KIND=8) :: ALPHA
              REAL(KIND=8) :: X(*)
              INTEGER(KIND=4) :: INCX
              REAL(KIND=8) :: TOL
              REAL(KIND=8) :: ZETA
            END SUBROUTINE SGRFG
          END INTERFACE 
        END MODULE SGRFG__genmod
