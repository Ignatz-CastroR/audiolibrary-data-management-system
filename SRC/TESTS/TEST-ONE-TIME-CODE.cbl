       IDENTIFICATION DIVISION.
       PROGRAM-ID. TEST-ONE-TIME-CODE.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       REPOSITORY.
           FUNCTION ONE-TIME-CODE-FUNC.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-RESULT.
           05 WS-CODE        PIC X(15).
           05 WS-STATUS      PIC 9.
       01 WS-PASSWORD-R   PIC S9(3) COMP-5.
       01 WS-I            PIC 9(3).
       01 WS-J            PIC 9(2).
       01 WS-USED-LEN      PIC 9(2).
       01 WS-GAP-COUNT     PIC 9(3) VALUE 0.
       01 WS-BAD-LEN-COUNT PIC 9(3) VALUE 0.
       01 WS-HAS-GAP       PIC X.

       PROCEDURE DIVISION.

       MAIN-PAR.

      * Part 1: show 10 real recovery ONE-TIME codes.

           DISPLAY "=== 10 sample recovery codes ===".
           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 10
               MOVE FUNCTION ONE-TIME-CODE-FUNC TO WS-RESULT
               DISPLAY WS-I ": [" WS-CODE "] status=" WS-STATUS
           END-PERFORM

      * Part 2: prove the PSSWRD-GEN-FUNC COBOL function
      * still works, called in the SAME run as
      * the ONE-TIME-CODE-FUNC COBOL function. This is the direct
      * test that the rename of the subordinate Go functions actually
      * fixed the collision.

           DISPLAY " ".
           DISPLAY "=== Calling the ORIGINAL password RNG too ===".
           CALL "SECURE_RANDOM_NUMBER_GEN" RETURNING WS-PASSWORD-R
           DISPLAY "Password RNG (expect 1-78): " WS-PASSWORD-R.
           IF WS-PASSWORD-R < 1 OR WS-PASSWORD-R > 78
               DISPLAY "  ERROR: out of the 1-78 range!"
           ELSE
               DISPLAY "  OK: correctly in the 1-78 range."
           END-IF

      * Part 3: run 300 more recovery codes, checking for defects.

           DISPLAY " ".
           DISPLAY "=== Running 300 more, checking for defects ===".
           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 300
               MOVE FUNCTION ONE-TIME-CODE-FUNC TO WS-RESULT
               MOVE FUNCTION LENGTH(FUNCTION TRIM(WS-CODE))
                   TO WS-USED-LEN

               IF WS-USED-LEN < 12 OR WS-USED-LEN > 15
                   ADD 1 TO WS-BAD-LEN-COUNT
               END-IF

               MOVE "N" TO WS-HAS-GAP
               PERFORM VARYING WS-J FROM 1 BY 1
                   UNTIL WS-J > WS-USED-LEN
                   IF WS-CODE(WS-J:1) = SPACE
                       MOVE "Y" TO WS-HAS-GAP
                   END-IF
               END-PERFORM
               IF WS-HAS-GAP = "Y"
                   ADD 1 TO WS-GAP-COUNT
               END-IF
           END-PERFORM

           DISPLAY " ".
           DISPLAY "Codes outside 12-15 characters (want 0): "
               WS-BAD-LEN-COUNT.
           DISPLAY "Codes with an internal gap (want 0): "
               WS-GAP-COUNT.

           MOVE 0 TO RETURN-CODE
           STOP RUN.
