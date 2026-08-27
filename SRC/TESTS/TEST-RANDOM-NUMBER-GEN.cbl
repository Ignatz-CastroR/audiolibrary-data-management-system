      ******************************************************************
      * Author: ENG. JOSE IGNACIO CASTRO DE R.
      * Place: DESAMPARADOS CENTRO, SAN JOSE, COSTA RICA
      * Program tested: RANDOM-NUMBER-GEN-FUNC.cbl
      * Purpose: Regression test for THE RANDOM-NUMBER-GEN-FUNC
      * COBOL function: checks output, range, spread, average, and
      * consecutive-repeat rate over 200 calls within a single run.
      * Run this program several times back-to-back [as separate
      * processes] to also check for cross-run seed collisions: see
      * the header of RANDOM-NUMBER-GEN-FUNC.cbl for why that matters.
      * Tectonics: cobc -x TEST-RANDOM-NUMBER-GEN.cbl
      * RANDOM-NUMBER-GEN.cbl -o TEST-RANDOM-NUMBER-GEN
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. TEST-RANDOM-NUMBER-GEN.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       REPOSITORY.
           FUNCTION RANDOM-NUMBER-GEN.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-R            PIC 9(2).
       01 WS-I            PIC 9(3).
       01 WS-OUT-OF-RANGE PIC 9(3) VALUE 0.
       01 WS-MIN-SEEN     PIC 9(2) VALUE 99.
       01 WS-MAX-SEEN     PIC 9(2) VALUE 0.
       01 WS-SUM          PIC 9(6) VALUE 0.
       01 WS-REPEATS      PIC 9(3) VALUE 0.
       01 WS-PREV         PIC 9(2).

       PROCEDURE DIVISION.
       MAIN.
           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 200
               MOVE FUNCTION RANDOM-NUMBER-GEN TO WS-R
               IF WS-R > 99
                   ADD 1 TO WS-OUT-OF-RANGE
               END-IF
               IF WS-R < WS-MIN-SEEN
                   MOVE WS-R TO WS-MIN-SEEN
               END-IF
               IF WS-R > WS-MAX-SEEN
                   MOVE WS-R TO WS-MAX-SEEN
               END-IF
               ADD WS-R TO WS-SUM
               IF WS-I > 1 AND WS-R = WS-PREV
                   ADD 1 TO WS-REPEATS
               END-IF
               MOVE WS-R TO WS-PREV
           END-PERFORM

           DISPLAY "First value this run: " WS-PREV.
           DISPLAY "Out of range (>99): " WS-OUT-OF-RANGE " of 200".
           DISPLAY "Min seen: " WS-MIN-SEEN " Max seen: " WS-MAX-SEEN.
           DISPLAY "Average x100 (expect ~4500-5400): " WS-SUM.
           DISPLAY "Consecutive repeats: " WS-REPEATS
               " of 199 pairs (expect ~2)".
           STOP RUN.
