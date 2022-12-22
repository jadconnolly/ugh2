        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 13:59:33 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE GDERIV__genmod
          INTERFACE 
            SUBROUTINE GDERIV(ID,G,DG,MINFX,ERROR)
              INTEGER(KIND=4) :: ID
              REAL(KIND=8) :: G
              REAL(KIND=8) :: DG(*)
              LOGICAL(KIND=4) :: MINFX
              LOGICAL(KIND=4) :: ERROR
            END SUBROUTINE GDERIV
          END INTERFACE 
        END MODULE GDERIV__genmod
