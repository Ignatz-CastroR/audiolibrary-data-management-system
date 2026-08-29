      ******************************************************************
      * Author: ENG. JOSE IGNACIO CASTRO DE R.
      * Purpose: Suggests a random password [12-15 characters long;
      * stochastic length] drawn from a 78-character list, using the
      * OS-backed and cryptographically secure SECURE_RANDOM_NUMBER_GEN
      * Go function, for every random choice making up the final
      * password suggestion [both the password's length, as mentioned,
      * and each individual composing character].
      * Tectonics: cobc -c PSSWRD-GEN-FUNC.cbl [or -m for a module],
      * before being bound to a calling COBOL program.
      * Place: DESAMPARADOS CENTRO, SAN JOSE, COSTA RICA
      * Date: 2026/08/26; 07:02, SHINY MORNING.
      * Security: Only as secure as the SECURE_RANDOM_NUMBER_GEN
      * Go function source's of randomness [crypto/rand].
      * Do not substitute this function with the clock-based
      * RANDOM-NUMBER-GEN-FUNC function.
      ******************************************************************
       IDENTIFICATION DIVISION.
       FUNCTION-ID. PSSWRD-GEN-FUNC.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       REPOSITORY.
           FUNCTION VERIFY-PSSWRD-FUNC.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       01 WS-RANDOM-FUNC  PIC X(25) VALUE "SECURE_RANDOM_NUMBER_GEN".

      * Single point of definition for the 78-character list,
      * initialized once at load time; not rebuilt on every call.
      * All 78 characters here are distinct.

       01 WS-VALUES-LITERAL PIC X(78) VALUE
           "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!?.@-_abcdefghijklmnopqr
      -    "stuvw:xyz;=*+$&/%#".
       01 WS-VALUES-TABLE   REDEFINES WS-VALUES-LITERAL.
           05 WS-EACH-VALUE OCCURS 78 TIMES PIC X.

       LOCAL-STORAGE SECTION.
       01 LS-PASSWORD          PIC X(15).
       01 LS-PSSWRD-LENGTH     PIC 9(2).
       01 LS-RANDOM-NUM        PIC S9(3) COMP-5.
       01 LS-COUNTER           PIC 9(2).
       01 LS-STRING-POINTER    PIC 9(2).
       01 LS-CHARACTER         PIC X.
       01 LS-RESULT-CODE       PIC 9.

       LINKAGE SECTION.
       01 LK-PARAMS.
           05 LK-PASSWORD       PIC X(15).
           05 LK-RETURN-CODE    PIC 9.
               88 LK-SUCCESS               VALUE ZERO.
               88 LK-ERROR                 VALUE 1.

       PROCEDURE DIVISION
           RETURNING LK-PARAMS.

       MAIN-PAR.

           PERFORM PASSWRD-LENGTH-PAR
           PERFORM PSSWRD-DEFINITION-PAR
           SET LK-SUCCESS TO TRUE
           MOVE LS-PASSWORD TO LK-PASSWORD
           PERFORM EXIT-PAR.

       PASSWRD-LENGTH-PAR.

           CALL WS-RANDOM-FUNC RETURNING LS-RANDOM-NUM

           EVALUATE LS-RANDOM-NUM
               WHEN 1 THROUGH 19
                   MOVE 12 TO LS-PSSWRD-LENGTH
               WHEN 20 THROUGH 39
                   MOVE 13 TO LS-PSSWRD-LENGTH
               WHEN 40 THROUGH 59
                   MOVE 14 TO LS-PSSWRD-LENGTH
               WHEN 60 THROUGH 78
                   MOVE 15 TO LS-PSSWRD-LENGTH
               WHEN OTHER
                   SET LK-ERROR TO TRUE
                   PERFORM EXIT-PAR
           END-EVALUATE.

       PSSWRD-DEFINITION-PAR.

      * Regenerates from scratch, as many times as it takes, until
      * VERIFY-PSSWRD-FUNC accepts the result. A flat PERFORM UNTIL,
      * not a self-referential PERFORM: the latter nests one stack
      * frame per retry and crashes past a few hundred consecutive
      * retries on this GnuCOBOL build [confirmed by direct test];
      * this loop carries no such risk no matter how many retries a
      * particularly unlucky draw needs.

           MOVE 0 TO LS-RESULT-CODE
           PERFORM UNTIL LS-RESULT-CODE = 1

               MOVE SPACES TO LS-PASSWORD
               MOVE 1 TO LS-STRING-POINTER

               PERFORM VARYING LS-COUNTER FROM 1 BY 1
               UNTIL   LS-COUNTER > LS-PSSWRD-LENGTH

                   CALL WS-RANDOM-FUNC RETURNING LS-RANDOM-NUM
                   MOVE WS-EACH-VALUE(LS-RANDOM-NUM) TO LS-CHARACTER

                   STRING LS-CHARACTER DELIMITED BY SIZE
                   INTO LS-PASSWORD
                   WITH POINTER LS-STRING-POINTER
                   END-STRING

               END-PERFORM

               MOVE FUNCTION VERIFY-PSSWRD-FUNC(LS-PASSWORD)
                   TO LS-RESULT-CODE

           END-PERFORM.

       EXIT-PAR.

           EXIT FUNCTION.

       END FUNCTION PSSWRD-GEN-FUNC.
