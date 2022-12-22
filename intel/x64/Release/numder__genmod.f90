        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 14:00:14 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE NUMDER__genmod
          INTERFACE 
            SUBROUTINE NUMDER(G,DGDP,PPP,FDNORM,BL,BU,SUM,NVAR,BAD,BADP,&
     &MODE)
              REAL(KIND=8) :: G
              REAL(KIND=8) :: DGDP(*)
              REAL(KIND=8) :: PPP(*)
              REAL(KIND=8) :: FDNORM
              REAL(KIND=8) :: BL(*)
              REAL(KIND=8) :: BU(*)
              REAL(KIND=8) :: SUM
              INTEGER(KIND=4) :: NVAR
              LOGICAL(KIND=4) :: BAD
              LOGICAL(KIND=4) :: BADP(14)
              INTEGER(KIND=4) :: MODE
            END SUBROUTINE NUMDER
          END INTERFACE 
        END MODULE NUMDER__genmod
