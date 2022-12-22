        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 16:22:40 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE NPUPDT__genmod
          INTERFACE 
            SUBROUTINE NPUPDT(LSUMRY,N,LDR,ALFA,GLF1,GLF2,QPCURV,GQ1,GQ2&
     &,HPQ,RPQ,R,WRK1,WRK2)
              INTEGER(KIND=4) :: LDR
              INTEGER(KIND=4) :: N
              CHARACTER(LEN=5) :: LSUMRY
              REAL(KIND=8) :: ALFA
              REAL(KIND=8) :: GLF1
              REAL(KIND=8) :: GLF2
              REAL(KIND=8) :: QPCURV
              REAL(KIND=8) :: GQ1(N)
              REAL(KIND=8) :: GQ2(N)
              REAL(KIND=8) :: HPQ(N)
              REAL(KIND=8) :: RPQ(N)
              REAL(KIND=8) :: R(LDR,*)
              REAL(KIND=8) :: WRK1(N)
              REAL(KIND=8) :: WRK2(N)
            END SUBROUTINE NPUPDT
          END INTERFACE 
        END MODULE NPUPDT__genmod
