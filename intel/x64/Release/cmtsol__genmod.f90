        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 16:22:40 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE CMTSOL__genmod
          INTERFACE 
            SUBROUTINE CMTSOL(MODE,NROWT,N,T,Y)
              INTEGER(KIND=4) :: N
              INTEGER(KIND=4) :: NROWT
              INTEGER(KIND=4) :: MODE
              REAL(KIND=8) :: T(NROWT,*)
              REAL(KIND=8) :: Y(N)
            END SUBROUTINE CMTSOL
          END INTERFACE 
        END MODULE CMTSOL__genmod
