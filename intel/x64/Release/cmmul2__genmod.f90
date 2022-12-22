        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 14:00:04 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE CMMUL2__genmod
          INTERFACE 
            SUBROUTINE CMMUL2(N,NRZ,NZ,ZEROLM,NOTOPT,NUMINF,TRUSML,     &
     &SMLLST,JSMLST,TINYST,JTINY,GQ)
              INTEGER(KIND=4) :: N
              INTEGER(KIND=4) :: NRZ
              INTEGER(KIND=4) :: NZ
              REAL(KIND=8) :: ZEROLM
              INTEGER(KIND=4) :: NOTOPT
              INTEGER(KIND=4) :: NUMINF
              REAL(KIND=8) :: TRUSML
              REAL(KIND=8) :: SMLLST
              INTEGER(KIND=4) :: JSMLST
              REAL(KIND=8) :: TINYST
              INTEGER(KIND=4) :: JTINY
              REAL(KIND=8) :: GQ(N)
            END SUBROUTINE CMMUL2
          END INTERFACE 
        END MODULE CMMUL2__genmod
