      ******************************************************************
      * Author: ENG. JOSE IGNACIO CASTRO DE R.
      * Date: 2026/08/29, 15:05, SEMI CLOUDY AFTERNOON.
      * Place: DESAMPARADOS CENTRO, SAN JOSE, COSTA RICA.
      * Purpose: Verifies that a one-time recovery code produced by
      * ONE-TIME-CODE-FUNC actually contains at least one upper case
      * letter, one digit, and one special character from the closed
      * 13-character set !?.@-=*+$&/%# [the exact same specials
      * ONE-TIME-CODE-FUNC's own 45 character list draws from].
      * ONE-TIME-CODE-FUNC picks each character uniformly at random
      * from that alphabet; nothing stops pure chance from drawing 12
      * to 15 letters in a row with no digit or special character in
      * the mix at all. This is a diversity gate for that outcome,
      * not a structural check: it does NOT verify length [12-15 is
      * already guaranteed by ONE-TIME-CODE-FUNC itself] and does NOT
      * reject a character outside its recognized categories [also
      * already impossible from that generator function];
      * any such character is simply ignored rather than flagged.
      * There is no lower case check: ONE-TIME-CODE-FUNC's own
      * character list contains no lower case letters at all.
      * Returns 1 for a valid code, 0 for an invalid one, the same
      * polarity as VALIDATE-EMAIL-FUNC and VERIFY-PSSWRD-FUNC.
      * Tectonics: cobc -c VERIFY-ONE-TIME-CODE-FUNC.cbl [or -m for a
      * module], before being bound to a calling COBOL program.
      * Security: No I/O at all. Read-only, in-memory,
      * character-by-character classification of the candidate code.
      * Does not retain, log, or echo the code anywhere.
      ******************************************************************
       IDENTIFICATION DIVISION.
       FUNCTION-ID. VERIFY-ONE-TIME-CODE-FUNC.

       DATA DIVISION.

       WORKING-STORAGE SECTION.

      * Single, actual point of definition for the 13 allowed special
      * characters: CLASSIFY-CODE-PAR below tests membership in this
      * exact field via INSPECT, rather than repeating the list a
      * second time as a hard-coded chain of comparisons. Kept in the
      * exact same content as ONE-TIME-CODE-FUNC's own character list,
      *  on purpose.
      * Initialized once at load time; not rebuilt on every call.

       01 WS-SPECIAL-CHARS PIC X(13) VALUE "!?.@-=*+$&/%#".

       LOCAL-STORAGE SECTION.

       01 LS-CODE-LENGTH     PIC 9(2).
       01 LS-COUNTER         PIC 9(2).
       01 LS-CHARACTER       PIC X.
       01 LS-SPECIAL-COUNT   PIC 9(2).

       01 LS-HAS-UPPER       PIC X VALUE "N".
           88 LS-FOUND-UPPER    VALUE "Y".
       01 LS-HAS-DIGIT       PIC X VALUE "N".
           88 LS-FOUND-DIGIT    VALUE "Y".
       01 LS-HAS-SPECIAL     PIC X VALUE "N".
           88 LS-FOUND-SPECIAL  VALUE "Y".

       LINKAGE SECTION.

       01 LK-SECURITY-CODE   PIC X(15).
       01 LK-RESULT          PIC 9.

       PROCEDURE DIVISION USING LK-SECURITY-CODE RETURNING LK-RESULT.

       MAIN-PAR.

           MOVE FUNCTION LENGTH(FUNCTION TRIM(LK-SECURITY-CODE))
               TO LS-CODE-LENGTH

           PERFORM CLASSIFY-CODE-PAR

           IF LS-FOUND-UPPER AND LS-FOUND-DIGIT AND LS-FOUND-SPECIAL
               MOVE 1 TO LK-RESULT
           ELSE
               MOVE 0 TO LK-RESULT
           END-IF

           EXIT FUNCTION.

       CLASSIFY-CODE-PAR.

      * Deliberately only walks the first LS-CODE-LENGTH positions
      * [the trimmed, actually-generated content], never the trailing
      * padding spaces PIC X(15) leaves behind past a 12-14 character
      * code. A character outside the three recognized categories
      * [i.e., neither upper, digit, nor special] is simply skipped:
      * see this function's header for why that is on purpose here.

           PERFORM VARYING LS-COUNTER FROM 1 BY 1
           UNTIL   LS-COUNTER > LS-CODE-LENGTH

               MOVE LK-SECURITY-CODE(LS-COUNTER:1) TO LS-CHARACTER

               EVALUATE TRUE
                   WHEN LS-CHARACTER >= "A" AND LS-CHARACTER <= "Z"
                       SET LS-FOUND-UPPER TO TRUE
                   WHEN LS-CHARACTER >= "0" AND LS-CHARACTER <= "9"
                       SET LS-FOUND-DIGIT TO TRUE
                   WHEN OTHER
                       MOVE 0 TO LS-SPECIAL-COUNT
                       INSPECT WS-SPECIAL-CHARS TALLYING
                           LS-SPECIAL-COUNT FOR ALL LS-CHARACTER
                       IF LS-SPECIAL-COUNT > 0
                           SET LS-FOUND-SPECIAL TO TRUE
                       END-IF
               END-EVALUATE

           END-PERFORM.

       END FUNCTION VERIFY-ONE-TIME-CODE-FUNC.




      * B"H.
