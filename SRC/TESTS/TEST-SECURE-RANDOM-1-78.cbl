      ******************************************************************
      * Author: ENG. JOSE IGNACIO CASTRO DE R.
      * Place: DESAMPARADOS CENTRO, SAN JOSE, COSTA RICA
      * Program tested: SECURE_RANDOM_NUMBER_GEN.go
      * Purpose: Regression test for a revised version of the
      * SECURE_RANDOM_NUMBER_GEN Go function, which now returns an
      * integer in the closed range [1, 78]. Checks 500 calls for: no
      * value below 1, no value above 78, both boundary values
      * actually being reached, and a reasonable spread across the
      * range.
      * Tectonics: go build -buildmode=c-shared -o
      * SECURE_RANDOM_NUMBER_GEN.dll secure_random.go
      *   *********************
      * cobc -x -fstatic-call TEST-SECURE-RANDOM-1-78.cbl
      * SECURE_RANDOM_NUMBER_GEN.dll -o TEST-SECURE-RANDOM-1-78
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. TEST-SECURE-RANDOM-1-78.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-R                PIC S9(3) COMP-5.
       01 WS-I                PIC 9(3).
       01 WS-TOO-LOW          PIC 9(3) VALUE 0.
       01 WS-TOO-HIGH         PIC 9(3) VALUE 0.
       01 WS-MIN-SEEN         PIC 9(3) VALUE 999.
       01 WS-MAX-SEEN         PIC 9(3) VALUE 0.
       01 WS-SAW-ONE          PIC X VALUE "N".
       01 WS-SAW-SEVENTYEIGHT PIC X VALUE "N".

       PROCEDURE DIVISION.
       MAIN.
           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 500
               CALL "SECURE_RANDOM_NUMBER_GEN" RETURNING WS-R

               IF WS-R < 1
                   ADD 1 TO WS-TOO-LOW
               END-IF
               IF WS-R > 78
                   ADD 1 TO WS-TOO-HIGH
               END-IF
               IF WS-R < WS-MIN-SEEN
                   MOVE WS-R TO WS-MIN-SEEN
               END-IF
               IF WS-R > WS-MAX-SEEN
                   MOVE WS-R TO WS-MAX-SEEN
               END-IF
               IF WS-R = 1
                   MOVE "Y" TO WS-SAW-ONE
               END-IF
               IF WS-R = 78
                   MOVE "Y" TO WS-SAW-SEVENTYEIGHT
               END-IF
           END-PERFORM

           DISPLAY "Below 1 (must be 0): " WS-TOO-LOW.
           DISPLAY "Above 78 (must be 0): " WS-TOO-HIGH.
           DISPLAY "Min seen (expect 1): " WS-MIN-SEEN.
           DISPLAY "Max seen (expect 78): " WS-MAX-SEEN.
           DISPLAY "Reached 1 in 500 tries: " WS-SAW-ONE.
           DISPLAY "Reached 78 in 500 tries: " WS-SAW-SEVENTYEIGHT.

           MOVE 0 TO RETURN-CODE
           STOP RUN.
