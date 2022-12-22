        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 13:59:47 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE SUBST__genmod
          INTERFACE 
            SUBROUTINE SUBST(A,LDA,IPVT,N,B,ERROR)
              INTEGER(KIND=4) :: LDA
              REAL(KIND=8) :: A(LDA,*)
              INTEGER(KIND=4) :: IPVT(*)
              INTEGER(KIND=4) :: N
              REAL(KIND=8) :: B(*)
              LOGICAL(KIND=4) :: ERROR
            END SUBROUTINE SUBST
          END INTERFACE 
        END MODULE SUBST__genmod
