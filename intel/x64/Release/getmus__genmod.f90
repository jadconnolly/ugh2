        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 14:00:15 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE GETMUS__genmod
          INTERFACE 
            SUBROUTINE GETMUS(ITER,JTER,IS,SOLVNT,ABORT)
              INTEGER(KIND=4) :: ITER
              INTEGER(KIND=4) :: JTER
              INTEGER(KIND=4) :: IS(*)
              LOGICAL(KIND=4) :: SOLVNT(*)
              LOGICAL(KIND=4) :: ABORT
            END SUBROUTINE GETMUS
          END INTERFACE 
        END MODULE GETMUS__genmod
