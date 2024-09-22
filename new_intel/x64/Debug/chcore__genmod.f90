        !COMPILER-GENERATED INTERFACE MODULE: Thu Sep 12 17:04:57 2024
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE CHCORE__genmod
          INTERFACE 
            SUBROUTINE CHCORE(DONE,FIRST,EPSA,EPSR,FX,INFORM,ITER,ITMAX,&
     &CDEST,FDEST,SDEST,ERRBND,F1,F2,H,HOPT,HPHI)
              LOGICAL(KIND=4) :: DONE
              LOGICAL(KIND=4) :: FIRST
              REAL(KIND=8) :: EPSA
              REAL(KIND=8) :: EPSR
              REAL(KIND=8) :: FX
              INTEGER(KIND=4) :: INFORM
              INTEGER(KIND=4) :: ITER
              INTEGER(KIND=4) :: ITMAX
              REAL(KIND=8) :: CDEST
              REAL(KIND=8) :: FDEST
              REAL(KIND=8) :: SDEST
              REAL(KIND=8) :: ERRBND
              REAL(KIND=8) :: F1
              REAL(KIND=8) :: F2
              REAL(KIND=8) :: H
              REAL(KIND=8) :: HOPT
              REAL(KIND=8) :: HPHI
            END SUBROUTINE CHCORE
          END INTERFACE 
        END MODULE CHCORE__genmod
