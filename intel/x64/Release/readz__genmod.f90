        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 13:59:32 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE READZ__genmod
          INTERFACE 
            SUBROUTINE READZ(COEFFS,INDS,ICT,IDIM,TNAME,TAG)
              REAL(KIND=8) :: COEFFS(15)
              INTEGER(KIND=4) :: INDS(15)
              INTEGER(KIND=4) :: ICT
              INTEGER(KIND=4) :: IDIM
              CHARACTER(LEN=10) :: TNAME
              CHARACTER(LEN=3) :: TAG
            END SUBROUTINE READZ
          END INTERFACE 
        END MODULE READZ__genmod
