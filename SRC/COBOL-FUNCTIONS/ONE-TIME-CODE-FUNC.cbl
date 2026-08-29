      ******************************************************************
      * Author: ENG. JOSE IGNACIO CASTRO DE R.
      * Date: 2026/08/26, 11:39, MILD-SUNNY MORNING
      * Purpose: Generates a 12-15 character one-time recovery code,
      * drawn from a 45-character list deliberately
      * trimmed of lowercase letters, the digits 0 and 1,
      * and the upper case letters I and O, so a
      * code handwritten and later retyped by the user is less
      * likely to be wrongly written or later misread.
      * Tectonics: cobc -x CALLER.cbl ONE-TIME-CODE-FUNC.cbl
      * RECOVERY_RANDOM_GEN.dll -o EXECUTABLE-FILE
      * Place: DESAMPARADOS CENTRO, SAN JOSE, COSTA RICA
      * Security: Every character comes from the RECOVERY_RANDOM_GEN
      * Go function, which uses crypto/rand [the OS's own cryptographic
      * entropy source]. It's the same primitive as in the
      * SECURE_RANDOM_NUMBER_GEN Go function, under a distinct exported
      * name so both can be called from the same COBOL program.
      ******************************************************************
       IDENTIFICATION DIVISION.
       FUNCTION-ID. ONE-TIME-CODE-FUNC.

       DATA DIVISION.

       WORKING-STORAGE SECTION.

       01 WS-RANDOM-FUNC  PIC X(20)
           VALUE "RECOVERY_RANDOM_GEN".

       01 WS-VALUES-LITERAL PIC X(45) VALUE
           "ABCDEFGHJKLMNPQRSTUVWXYZ23456789!?.@-=*+$&/%#".

       01 WS-VALUES-TABLE REDEFINES WS-VALUES-LITERAL.
           05 WS-EACH-VALUE OCCURS 45 TIMES PIC X.

       LOCAL-STORAGE SECTION.

       01 LS-SECURITY-CODE         PIC X(15).
       01 LS-PSSWRD-LENGTH         PIC 9(2).
       01 LS-RANDOM-NUM            PIC S9(3) COMP-5.
       01 LS-COUNTER               PIC 9(2).

       01 LS-STRING-POINTER        PIC 9(2).
       01 LS-CHARACTER             PIC X.

       LINKAGE SECTION.

       01 LK-PARAMS.
           05 LK-SECURITY-CODE          PIC X(15).
           05 LK-RETURN-CODE            PIC 9.
               88 LK-SUCCESS               VALUE ZERO.
               88 LK-ERROR                 VALUE 1.

       PROCEDURE DIVISION
       RETURNING LK-PARAMS.

       MAIN-PAR.

           PERFORM PASSWRD-LENGTH-PAR
           PERFORM PSSWRD-DEFINITION-PAR
           SET LK-SUCCESS TO TRUE
           MOVE LS-SECURITY-CODE TO LK-SECURITY-CODE
           PERFORM EXIT-PAR.

       PASSWRD-LENGTH-PAR.

           CALL WS-RANDOM-FUNC RETURNING LS-RANDOM-NUM

           EVALUATE LS-RANDOM-NUM
               WHEN 1 THROUGH 11
                   MOVE 12 TO LS-PSSWRD-LENGTH
               WHEN 12 THROUGH 22
                   MOVE 13 TO LS-PSSWRD-LENGTH
               WHEN 23 THROUGH 33
                   MOVE 14 TO LS-PSSWRD-LENGTH
               WHEN 34 THROUGH 45
                   MOVE 15 TO LS-PSSWRD-LENGTH
               WHEN OTHER
                   SET LK-ERROR TO TRUE
                   PERFORM EXIT-PAR
           END-EVALUATE.

       PSSWRD-DEFINITION-PAR.

           MOVE SPACES TO LS-SECURITY-CODE
           MOVE 1 TO LS-STRING-POINTER

           PERFORM VARYING LS-COUNTER FROM 1 BY 1
           UNTIL   LS-COUNTER > LS-PSSWRD-LENGTH

               CALL WS-RANDOM-FUNC RETURNING LS-RANDOM-NUM
               MOVE WS-EACH-VALUE(LS-RANDOM-NUM) TO LS-CHARACTER

               STRING LS-CHARACTER DELIMITED BY SIZE
               INTO LS-SECURITY-CODE
               WITH POINTER LS-STRING-POINTER
               END-STRING

           END-PERFORM.

       EXIT-PAR.

           EXIT FUNCTION.

       END FUNCTION ONE-TIME-CODE-FUNC.


      * B"H.
