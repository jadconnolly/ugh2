        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 14:00:14 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE GSOL4__genmod
          INTERFACE 
            SUBROUTINE GSOL4(MODE,NVAR,PPP,GVAL,DGDP,FDNORM,BL,BU)
              INTEGER(KIND=4) :: MODE
              INTEGER(KIND=4) :: NVAR
              REAL(KIND=8) :: PPP(*)
              REAL(KIND=8) :: GVAL
              REAL(KIND=8) :: DGDP(*)
              REAL(KIND=8) :: FDNORM
              REAL(KIND=8) :: BL(*)
              REAL(KIND=8) :: BU(*)
            END SUBROUTINE GSOL4
          END INTERFACE 
        END MODULE GSOL4__genmod
