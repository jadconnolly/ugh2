        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 14:00:04 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE NGGNBU__genmod
          INTERFACE 
            SUBROUTINE NGGNBU(N,NU,NRANK,LDR,I,J,R,U,C,S)
              INTEGER(KIND=4) :: LDR
              INTEGER(KIND=4) :: N
              INTEGER(KIND=4) :: NU
              INTEGER(KIND=4) :: NRANK
              INTEGER(KIND=4) :: I
              INTEGER(KIND=4) :: J
              REAL(KIND=8) :: R(LDR,*)
              REAL(KIND=8) :: U(N,*)
              REAL(KIND=8) :: C(N)
              REAL(KIND=8) :: S(N)
            END SUBROUTINE NGGNBU
          END INTERFACE 
        END MODULE NGGNBU__genmod
