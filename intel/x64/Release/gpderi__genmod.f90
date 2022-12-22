        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 13:59:33 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE GPDERI__genmod
          INTERFACE 
            SUBROUTINE GPDERI(ID,Q,G,DG,MINFXC,ERROR)
              INTEGER(KIND=4) :: ID
              REAL(KIND=8) :: Q(*)
              REAL(KIND=8) :: G
              REAL(KIND=8) :: DG(*)
              LOGICAL(KIND=4) :: MINFXC
              LOGICAL(KIND=4) :: ERROR
            END SUBROUTINE GPDERI
          END INTERFACE 
        END MODULE GPDERI__genmod
