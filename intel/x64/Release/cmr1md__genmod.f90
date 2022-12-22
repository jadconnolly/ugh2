        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 14:00:04 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE CMR1MD__genmod
          INTERFACE 
            SUBROUTINE CMR1MD(N,NRANK,LDR,LENV,LENW,R,V,W,C,S)
              INTEGER(KIND=4) :: LDR
              INTEGER(KIND=4) :: N
              INTEGER(KIND=4) :: NRANK
              INTEGER(KIND=4) :: LENV
              INTEGER(KIND=4) :: LENW
              REAL(KIND=8) :: R(LDR,*)
              REAL(KIND=8) :: V(N)
              REAL(KIND=8) :: W(N)
              REAL(KIND=8) :: C(N)
              REAL(KIND=8) :: S(N)
            END SUBROUTINE CMR1MD
          END INTERFACE 
        END MODULE CMR1MD__genmod
