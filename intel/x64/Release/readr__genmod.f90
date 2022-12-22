        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 13:59:32 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE READR__genmod
          INTERFACE 
            SUBROUTINE READR(COEFFS,ENTH,INDS,IDIM,NREACT,TNAME,EOR)
              REAL(KIND=8) :: COEFFS(15)
              REAL(KIND=8) :: ENTH(3)
              INTEGER(KIND=4) :: INDS(15)
              INTEGER(KIND=4) :: IDIM
              INTEGER(KIND=4) :: NREACT
              CHARACTER(LEN=10) :: TNAME
              LOGICAL(KIND=4) :: EOR
            END SUBROUTINE READR
          END INTERFACE 
        END MODULE READR__genmod
