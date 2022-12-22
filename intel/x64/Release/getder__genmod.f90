        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 13:59:33 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE GETDER__genmod
          INTERFACE 
            SUBROUTINE GETDER(G,DGDP,IDS,BAD,BADP)
              REAL(KIND=8) :: G
              REAL(KIND=8) :: DGDP(*)
              INTEGER(KIND=4) :: IDS
              LOGICAL(KIND=4) :: BAD
              LOGICAL(KIND=4) :: BADP(*)
            END SUBROUTINE GETDER
          END INTERFACE 
        END MODULE GETDER__genmod
