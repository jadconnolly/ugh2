        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 14:00:04 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE XCMR1MD__genmod
          INTERFACE 
            SUBROUTINE XCMR1MD(N,NU,NRANK,LDR,LENV,LENW,R,U,V,W,C,S)
              INTEGER(KIND=4) :: LDR
              INTEGER(KIND=4) :: N
              INTEGER(KIND=4) :: NU
              INTEGER(KIND=4) :: NRANK
              INTEGER(KIND=4) :: LENV
              INTEGER(KIND=4) :: LENW
              REAL(KIND=8) :: R(LDR,*)
              REAL(KIND=8) :: U(N,*)
              REAL(KIND=8) :: V(N)
              REAL(KIND=8) :: W(N)
              REAL(KIND=8) :: C(N)
              REAL(KIND=8) :: S(N)
            END SUBROUTINE XCMR1MD
          END INTERFACE 
        END MODULE XCMR1MD__genmod
