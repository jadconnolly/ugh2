        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 13:59:32 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE SDERIV__genmod
          INTERFACE 
            SUBROUTINE SDERIV(ID,S,DSY,DSYY,MAXS)
              INTEGER(KIND=4) :: ID
              REAL(KIND=8) :: S
              REAL(KIND=8) :: DSY(*)
              REAL(KIND=8) :: DSYY(4,*)
              LOGICAL(KIND=4) :: MAXS
            END SUBROUTINE SDERIV
          END INTERFACE 
        END MODULE SDERIV__genmod
