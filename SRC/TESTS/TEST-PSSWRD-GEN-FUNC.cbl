      ******************************************************************
      * Author: ENG. JOSE IGNACIO CASTRO DE R.
      * Place: DESAMPARADOS CENTRO, SAN JOSE, COSTA RICA
      * Program tested: PSSWRD-GEN-FUNC.cbl
      * Purpose: Generates and displays 20 sample passwords from
      * the PSSWRD-GEN-FUNC COBOL function, then runs 300 more silently
      * to check for the two defects the original version had [an
      * internal blank space from the STRING/loop-counter pointer
      * collision, and a length outside the intended 12-15 range],
      * plus one more check: that VERIFY-PSSWRD-FUNC independently
      * accepts every single one, since PSSWRD-GEN-FUNC now regenerates
      * internally until that same function accepts its own output.
      * All three counts should read 0.
      * Tectonics: go build -buildmode=c-shared -o
      * SECURE_RANDOM_NUMBER_GEN.dll SECURE_RANDOM_NUMBER_GEN.go
      *     ********************
      * cobc -x -fstatic-call TEST-PSSWRD-GEN-FUNC.cbl
      * PSSWRD-GEN-FUNC.cbl VERIFY-PSSWRD-FUNC.cbl
      * SECURE_RANDOM_NUMBER_GEN.dll -o TEST-PSSWRD-GEN-FUNC
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. TEST-PSSWRD-GEN-FUNC.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       REPOSITORY.
           FUNCTION PSSWRD-GEN-FUNC
           FUNCTION VERIFY-PSSWRD-FUNC.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-RESULT.
           05 WS-PASSWORD    PIC X(15).
           05 WS-STATUS      PIC 9.
       01 WS-RECHECK        PIC 9.
       01 WS-I             PIC 9(3).
       01 WS-J             PIC 9(2).
       01 WS-USED-LEN       PIC 9(2).
       01 WS-GAP-COUNT      PIC 9(3) VALUE 0.
       01 WS-BAD-LEN-COUNT  PIC 9(3) VALUE 0.
       01 WS-REJECT-COUNT   PIC 9(3) VALUE 0.
       01 WS-HAS-GAP        PIC X.

       PROCEDURE DIVISION.

       MAIN-PAR.

      * Part 1: show 20 real passwords, so you can actually look
      * at them.

           DISPLAY "=== 20 sample passwords ===".
           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 20
               MOVE FUNCTION PSSWRD-GEN-FUNC TO WS-RESULT
               DISPLAY WS-I ": [" WS-PASSWORD "] status="
                   WS-STATUS
           END-PERFORM

      * Part 2: run 300 more, silently, checking for the two
      * defects the original version actually had, plus one more:
      * that VERIFY-PSSWRD-FUNC independently agrees every result is
      * actually valid.

           DISPLAY " ".
           DISPLAY "=== Running 300 more, checking for defects ===".
           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 300
               MOVE FUNCTION PSSWRD-GEN-FUNC TO WS-RESULT
               MOVE FUNCTION LENGTH(FUNCTION TRIM(WS-PASSWORD))
                   TO WS-USED-LEN

               IF WS-USED-LEN < 12 OR WS-USED-LEN > 15
                   ADD 1 TO WS-BAD-LEN-COUNT
               END-IF

               MOVE "N" TO WS-HAS-GAP
               PERFORM VARYING WS-J FROM 1 BY 1
                   UNTIL WS-J > WS-USED-LEN
                   IF WS-PASSWORD(WS-J:1) = SPACE
                       MOVE "Y" TO WS-HAS-GAP
                   END-IF
               END-PERFORM
               IF WS-HAS-GAP = "Y"
                   ADD 1 TO WS-GAP-COUNT
               END-IF

               MOVE FUNCTION VERIFY-PSSWRD-FUNC(WS-PASSWORD)
                   TO WS-RECHECK
               IF WS-RECHECK NOT = 1
                   ADD 1 TO WS-REJECT-COUNT
               END-IF
           END-PERFORM

           DISPLAY " ".
           DISPLAY "Passwords outside 12-15 characters (want 0): "
               WS-BAD-LEN-COUNT.
           DISPLAY "Passwords with an internal gap (want 0): "
               WS-GAP-COUNT.
           DISPLAY "Passwords VERIFY-PSSWRD-FUNC rejected (want 0): "
               WS-REJECT-COUNT.

           ACCEPT OMITTED

           STOP RUN RETURNING 0.

       END PROGRAM TEST-PSSWRD-GEN-FUNC.


      * B"H.
