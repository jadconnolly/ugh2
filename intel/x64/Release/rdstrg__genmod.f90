        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 13:59:48 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE RDSTRG__genmod
          INTERFACE 
            SUBROUTINE RDSTRG(LUN,NSTRG,STRING,EOF)
              INTEGER(KIND=4) :: LUN
              INTEGER(KIND=4) :: NSTRG
              CHARACTER(LEN=8) :: STRING(3)
              LOGICAL(KIND=4) :: EOF
            END SUBROUTINE RDSTRG
          END INTERFACE 
        END MODULE RDSTRG__genmod
