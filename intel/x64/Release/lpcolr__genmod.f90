        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 14:00:04 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE LPCOLR__genmod
          INTERFACE 
            SUBROUTINE LPCOLR(NRZ,LDR,R,RZZ)
              INTEGER(KIND=4) :: LDR
              INTEGER(KIND=4) :: NRZ
              REAL(KIND=8) :: R(LDR,*)
              REAL(KIND=8) :: RZZ
            END SUBROUTINE LPCOLR
          END INTERFACE 
        END MODULE LPCOLR__genmod
