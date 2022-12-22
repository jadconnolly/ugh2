        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 16:22:40 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE CMDGEN__genmod
          INTERFACE 
            SUBROUTINE CMDGEN(JOB,N,NCLIN,NMOVED,ITER,NUMINF,ISTATE,BL, &
     &BU,FEATOL,FEATLU,X)
              INTEGER(KIND=4) :: NCLIN
              INTEGER(KIND=4) :: N
              CHARACTER(LEN=1) :: JOB
              INTEGER(KIND=4) :: NMOVED
              INTEGER(KIND=4) :: ITER
              INTEGER(KIND=4) :: NUMINF
              INTEGER(KIND=4) :: ISTATE(N+NCLIN)
              REAL(KIND=8) :: BL(N+NCLIN)
              REAL(KIND=8) :: BU(N+NCLIN)
              REAL(KIND=8) :: FEATOL(N+NCLIN)
              REAL(KIND=8) :: FEATLU(N+NCLIN)
              REAL(KIND=8) :: X(N)
            END SUBROUTINE CMDGEN
          END INTERFACE 
        END MODULE CMDGEN__genmod
