        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 13:59:47 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE FACTOR__genmod
          INTERFACE 
            SUBROUTINE FACTOR(A,LDA,N,IPVT,ERROR)
              INTEGER(KIND=4) :: LDA
              REAL(KIND=8) :: A(LDA,*)
              INTEGER(KIND=4) :: N
              INTEGER(KIND=4) :: IPVT(*)
              LOGICAL(KIND=4) :: ERROR
            END SUBROUTINE FACTOR
          END INTERFACE 
        END MODULE FACTOR__genmod
