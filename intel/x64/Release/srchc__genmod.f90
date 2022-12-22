        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 14:00:04 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE SRCHC__genmod
          INTERFACE 
            SUBROUTINE SRCHC(FIRST,DONE,IMPRVD,INFORM,MAXF,NUMF,ALFMAX, &
     &EPSAF,G0,TARGTG,FTRY,GTRY,TOLABS,TOLREL,TOLTNY,ALFA,ALFBST,FBEST, &
     &GBEST)
              LOGICAL(KIND=4) :: FIRST
              LOGICAL(KIND=4) :: DONE
              LOGICAL(KIND=4) :: IMPRVD
              INTEGER(KIND=4) :: INFORM
              INTEGER(KIND=4) :: MAXF
              INTEGER(KIND=4) :: NUMF
              REAL(KIND=8) :: ALFMAX
              REAL(KIND=8) :: EPSAF
              REAL(KIND=8) :: G0
              REAL(KIND=8) :: TARGTG
              REAL(KIND=8) :: FTRY
              REAL(KIND=8) :: GTRY
              REAL(KIND=8) :: TOLABS
              REAL(KIND=8) :: TOLREL
              REAL(KIND=8) :: TOLTNY
              REAL(KIND=8) :: ALFA
              REAL(KIND=8) :: ALFBST
              REAL(KIND=8) :: FBEST
              REAL(KIND=8) :: GBEST
            END SUBROUTINE SRCHC
          END INTERFACE 
        END MODULE SRCHC__genmod
