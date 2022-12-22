        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 13:59:32 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE ZBAD__genmod
          INTERFACE 
            FUNCTION ZBAD(Y,IDS,Z,TEXT,ENDTST,TEXT1)
              REAL(KIND=8) :: Y(*)
              INTEGER(KIND=4) :: IDS
              REAL(KIND=8) :: Z(6,14)
              CHARACTER(*) :: TEXT
              LOGICAL(KIND=4) :: ENDTST
              CHARACTER(*) :: TEXT1
              LOGICAL(KIND=4) :: ZBAD
            END FUNCTION ZBAD
          END INTERFACE 
        END MODULE ZBAD__genmod
