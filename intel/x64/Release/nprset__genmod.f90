        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 16:22:40 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE NPRSET__genmod
          INTERFACE 
            SUBROUTINE NPRSET(UNITQ,N,NFREE,NZ,NQ,NROWR,IPERM,KX,GQ,R,ZY&
     &,WORK,QRWORK)
              INTEGER(KIND=4) :: NROWR
              INTEGER(KIND=4) :: NQ
              INTEGER(KIND=4) :: N
              LOGICAL(KIND=4) :: UNITQ
              INTEGER(KIND=4) :: NFREE
              INTEGER(KIND=4) :: NZ
              INTEGER(KIND=4) :: IPERM(N)
              INTEGER(KIND=4) :: KX(N)
              REAL(KIND=8) :: GQ(N)
              REAL(KIND=8) :: R(NROWR,*)
              REAL(KIND=8) :: ZY(NQ,*)
              REAL(KIND=8) :: WORK(N)
              REAL(KIND=8) :: QRWORK(2*N)
            END SUBROUTINE NPRSET
          END INTERFACE 
        END MODULE NPRSET__genmod
