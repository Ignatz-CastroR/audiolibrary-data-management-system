       IDENTIFICATION DIVISION.
       FUNCTION-ID. VALIDATE-EMAIL-FUNC.

       DATA DIVISION.
       LOCAL-STORAGE SECTION.
       01 LS-TRIMMED       PIC X(60).
       01 LS-AT-COUNT      PIC 9(2) VALUE 0.
       01 LS-SPACE-COUNT   PIC 9(2) VALUE 0.
       01 LS-DOT-COUNT     PIC 9(2) VALUE 0.
       01 LS-LOCAL-PART    PIC X(60).
       01 LS-DOMAIN-PART   PIC X(60).
       01 LS-DOMAIN-LEN    PIC 9(2).
       01 LS-STILL-VALID   PIC X VALUE "Y".
           88 EMAIL-STILL-VALID VALUE "Y".
           88 EMAIL-NOW-INVALID VALUE "N".

       LINKAGE SECTION.
       01 LK-EMAIL         PIC X(60).
       01 LK-RESULT        PIC 9.

       PROCEDURE DIVISION USING LK-EMAIL RETURNING LK-RESULT.
       MAIN-PAR.
           MOVE FUNCTION TRIM(LK-EMAIL) TO LS-TRIMMED

           IF FUNCTION LENGTH(FUNCTION TRIM(LS-TRIMMED)) = 0
               SET EMAIL-NOW-INVALID TO TRUE
           END-IF

           IF EMAIL-STILL-VALID
               INSPECT LS-TRIMMED TALLYING LS-AT-COUNT FOR ALL "@"
               IF LS-AT-COUNT NOT = 1
                   SET EMAIL-NOW-INVALID TO TRUE
               END-IF
           END-IF

           IF EMAIL-STILL-VALID
               INSPECT LS-TRIMMED TALLYING LS-SPACE-COUNT
                   FOR ALL " "
               IF LS-SPACE-COUNT NOT = FUNCTION LENGTH(LS-TRIMMED)
                       - FUNCTION LENGTH(FUNCTION TRIM(LS-TRIMMED))
                   SET EMAIL-NOW-INVALID TO TRUE
               END-IF
           END-IF

           IF EMAIL-STILL-VALID
               UNSTRING LS-TRIMMED DELIMITED BY "@"
                   INTO LS-LOCAL-PART LS-DOMAIN-PART
               IF FUNCTION LENGTH(FUNCTION TRIM(LS-LOCAL-PART)) = 0
                   SET EMAIL-NOW-INVALID TO TRUE
               END-IF
           END-IF

           IF EMAIL-STILL-VALID
               MOVE FUNCTION LENGTH(FUNCTION TRIM(LS-DOMAIN-PART))
                   TO LS-DOMAIN-LEN
               IF LS-DOMAIN-LEN = 0
                   SET EMAIL-NOW-INVALID TO TRUE
               END-IF
           END-IF

           IF EMAIL-STILL-VALID
               INSPECT LS-DOMAIN-PART TALLYING LS-DOT-COUNT
                   FOR ALL "."
               IF LS-DOT-COUNT = 0
                   SET EMAIL-NOW-INVALID TO TRUE
               END-IF
           END-IF

           IF EMAIL-STILL-VALID
               IF LS-DOMAIN-PART(1:1) = "."
                   SET EMAIL-NOW-INVALID TO TRUE
               END-IF
           END-IF

           IF EMAIL-STILL-VALID
               IF LS-DOMAIN-PART(LS-DOMAIN-LEN:1) = "."
                   SET EMAIL-NOW-INVALID TO TRUE
               END-IF
           END-IF

           IF EMAIL-STILL-VALID
               MOVE 1 TO LK-RESULT
           ELSE
               MOVE 0 TO LK-RESULT
           END-IF

           EXIT FUNCTION.

       END FUNCTION VALIDATE-EMAIL-FUNC.

      * B"H.
