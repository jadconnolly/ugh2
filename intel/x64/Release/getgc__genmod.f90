        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 14:00:15 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE GETGC__genmod
          INTERFACE 
            SUBROUTINE GETGC(LC,LG,LDC,ITER)
              INTEGER(KIND=4) :: LDC
              REAL(KIND=8) :: LC(LDC,*)
              REAL(KIND=8) :: LG(*)
              INTEGER(KIND=4) :: ITER
            END SUBROUTINE GETGC
          END INTERFACE 
        END MODULE GETGC__genmod
