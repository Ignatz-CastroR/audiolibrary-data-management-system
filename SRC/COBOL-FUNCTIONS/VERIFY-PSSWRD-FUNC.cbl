      ******************************************************************
      * Author: ENG. JOSE IGNACIO CASTRO DE R.
      * Place: DESAMPARADOS CENTRO, SAN JOSE, COSTA RICA.
      * Date: 2026/08/29, 13:11, SEMI CLOUDY AFTERNOON.
      * Purpose: Verifies that a candidate password
      * [12 - 15 characters in length]
      * contains at least one upper case letter, one lower case
      * letter, and one digit; and at least one special character from
      * the closed 16-character set "!?.@-_:;=*+$&/%#" [the exact same
      * set PSSWRD-GEN-FUNC's own 78-character charachter-list draws its
      * specials from]; and no character outside that same universe
      * [A-Z, a-z, 0-9, plus those 16 specials]. A blank space is not
      * separately checked for: it simply belongs to none of those
      * categories, so it is caught as an illegal character like any
      * other one'd be.
      * This exists as much to gate a manually-typed password as to
      * sanity-check a PSSWRD-GEN-FUNC suggestion: nothing stops a
      * user from ignoring the suggestion and typing their own
      * password instead, so both paths need to clear this same check
      * before a password is ever accepted.
      * Returns 1 for a valid password, 0 for an invalid one [the
      * same polarity found in the VALIDATE-EMAIL-FUNC function].
      * Tectonics: cobc -c VERIFY-PSSWRD-FUNC.cbl [or -m for a
      * module], before being bound to a calling COBOL program.
      * Security: No I/O at all. Read-only, in-memory,
      * character-by-character classification of the candidate
      * password. Does not retain, log, or echo the password anywhere.
      ******************************************************************
       IDENTIFICATION DIVISION.
       FUNCTION-ID. VERIFY-PSSWRD-FUNC.

       DATA DIVISION.

       WORKING-STORAGE SECTION.

      * Single, actual point of definition for the 16 allowed special
      * characters - CLASSIFY-PSSWRD-PAR below tests membership in
      * this exact field via INSPECT, rather than repeating the list
      * a second time as a hard-coded chain of comparisons. Kept in
      * the exact same content as PSSWRD-GEN-FUNC's own alphabet, on
      * purpose. Initialized once at load time; not rebuilt on every
      * call.
       01 WS-SPECIAL-CHARS PIC X(16) VALUE "!?.@-_:;=*+$&/%#".

       LOCAL-STORAGE SECTION.

       01 LS-PSSWRD-LENGTH   PIC 9(2).
       01 LS-COUNTER         PIC 9(2).
       01 LS-CHARACTER       PIC X.
       01 LS-SPECIAL-COUNT   PIC 9(2).

       01 LS-HAS-UPPER       PIC X VALUE "N".
           88 LS-FOUND-UPPER    VALUE "Y".
       01 LS-HAS-LOWER       PIC X VALUE "N".
           88 LS-FOUND-LOWER    VALUE "Y".
       01 LS-HAS-DIGIT       PIC X VALUE "N".
           88 LS-FOUND-DIGIT    VALUE "Y".
       01 LS-HAS-SPECIAL     PIC X VALUE "N".
           88 LS-FOUND-SPECIAL  VALUE "Y".
       01 LS-HAS-ILLEGAL     PIC X VALUE "N".
           88 LS-FOUND-ILLEGAL  VALUE "Y".

       01 LS-STILL-VALID     PIC X VALUE "Y".
           88 PSSWRD-STILL-VALID  VALUE "Y".
           88 PSSWRD-NOW-INVALID  VALUE "N".

       LINKAGE SECTION.

       01 LK-PSSWRD          PIC X(15).
       01 LK-RESULT          PIC 9.

       PROCEDURE DIVISION USING LK-PSSWRD RETURNING LK-RESULT.

       MAIN-PAR.

           MOVE FUNCTION LENGTH(FUNCTION TRIM(LK-PSSWRD))
               TO LS-PSSWRD-LENGTH

           IF LS-PSSWRD-LENGTH < 12 OR LS-PSSWRD-LENGTH > 15
               SET PSSWRD-NOW-INVALID TO TRUE
           END-IF

           IF PSSWRD-STILL-VALID
               PERFORM CLASSIFY-PSSWRD-PAR
               IF NOT LS-FOUND-UPPER OR NOT LS-FOUND-LOWER
                       OR NOT LS-FOUND-DIGIT OR NOT LS-FOUND-SPECIAL
                       OR LS-FOUND-ILLEGAL
                   SET PSSWRD-NOW-INVALID TO TRUE
               END-IF
           END-IF

           IF PSSWRD-STILL-VALID
               MOVE 1 TO LK-RESULT
           ELSE
               MOVE 0 TO LK-RESULT
           END-IF

           EXIT FUNCTION.

       CLASSIFY-PSSWRD-PAR.

      * Deliberately only walks the first LS-PSSWRD-LENGTH positions
      * [the trimmed, actually-typed content]; never the trailing
      * padding spaces PIC X(15) leaves behind past what was typed.
      * Any space found in that range is therefore a real, embedded
      * one, correctly caught below and classified as an illegal
      * character.

           PERFORM VARYING LS-COUNTER FROM 1 BY 1
           UNTIL   LS-COUNTER > LS-PSSWRD-LENGTH

               MOVE LK-PSSWRD(LS-COUNTER:1) TO LS-CHARACTER

               EVALUATE TRUE
                   WHEN LS-CHARACTER >= "A" AND LS-CHARACTER <= "Z"
                       SET LS-FOUND-UPPER TO TRUE
                   WHEN LS-CHARACTER >= "a" AND LS-CHARACTER <= "z"
                       SET LS-FOUND-LOWER TO TRUE
                   WHEN LS-CHARACTER >= "0" AND LS-CHARACTER <= "9"
                       SET LS-FOUND-DIGIT TO TRUE
                   WHEN OTHER
                       MOVE 0 TO LS-SPECIAL-COUNT
                       INSPECT WS-SPECIAL-CHARS TALLYING
                           LS-SPECIAL-COUNT FOR ALL LS-CHARACTER
                       IF LS-SPECIAL-COUNT > 0
                           SET LS-FOUND-SPECIAL TO TRUE
                       ELSE
                           SET LS-FOUND-ILLEGAL TO TRUE
                       END-IF
               END-EVALUATE

           END-PERFORM.

       END FUNCTION VERIFY-PSSWRD-FUNC.

      * B"H.
