      ******************************************************************
      * Author: ENG. JOSE IGNACIO CASTRO DE R.
      * Date: 2026/08/29, 14:02, SEMI CLOUDY AFTERNOON.
      * Place: DESAMPARADOS CENTRO, SAN JOSE, COSTA RICA.
      * Program tested: VERIFY-PSSWRD-FUNC.cbl
      * Purpose: Regression test running 11 fixed cases [3 valid, 8
      * invalid] against VERIFY-PSSWRD-FUNC: too short, all-blank, a
      * missing upper case letter, a missing lower case letter, a
      * missing digit, a missing special character, an illegal
      * character, and an embedded space, alongside three genuinely
      * valid passwords at the 12 and 15-character length boundaries.
      * Reports PASS/FAIL per case and
      * the total function failure count [want 0].
      * Tectonics: cobc -x -fstatic-call TEST-VERIFY-PSSWRD-FUNC.cbl
      * VERIFY-PSSWRD-FUNC.cbl -o TEST-VERIFY-PSSWRD-FUNC
      * Security: NO CONCERNS FOR THE TIME BEING.
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. TEST-VERIFY-PSSWRD-FUNC.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       REPOSITORY.
           FUNCTION VERIFY-PSSWRD-FUNC.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-PSSWRD  PIC X(15).
       01 WS-RESULT  PIC 9.

       01 WS-CASES.
           05 FILLER PIC X(15) VALUE "Abcdefghij1!".
           05 FILLER PIC 9     VALUE 1.
           05 FILLER PIC X(15) VALUE "Ab3!Cd5?Ef7@Gh9".
           05 FILLER PIC 9     VALUE 1.
           05 FILLER PIC X(15) VALUE "Xy9#Zk2$Qw5&L".
           05 FILLER PIC 9     VALUE 1.
           05 FILLER PIC X(15) VALUE "Ab3!Cd5?Ef7".
           05 FILLER PIC 9     VALUE 0.
           05 FILLER PIC X(15) VALUE " ".
           05 FILLER PIC 9     VALUE 0.
           05 FILLER PIC X(15) VALUE "ab3!cd5?ef7@gh9".
           05 FILLER PIC 9     VALUE 0.
           05 FILLER PIC X(15) VALUE "AB3!CD5?EF7@GH9".
           05 FILLER PIC 9     VALUE 0.
           05 FILLER PIC X(15) VALUE "Ab!CdE?FgH@IjK#".
           05 FILLER PIC 9     VALUE 0.
           05 FILLER PIC X(15) VALUE "Ab3Cd5Ef7Gh9Ijk".
           05 FILLER PIC 9     VALUE 0.
           05 FILLER PIC X(15) VALUE "Ab3!Cd5?Ef7(Gh".
           05 FILLER PIC 9     VALUE 0.
           05 FILLER PIC X(15) VALUE "Ab3! Cd5?Ef7@G".
           05 FILLER PIC 9     VALUE 0.

       01 WS-CASE-TABLE REDEFINES WS-CASES.
           05 WS-CASE OCCURS 11 TIMES.
               10 WS-CASE-PSSWRD   PIC X(15).
               10 WS-CASE-EXPECTED PIC 9.

       01 WS-I PIC 9(2).

       01 WS-FAILURES    PIC 9(2) VALUE 0.

       PROCEDURE DIVISION.
           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 11
               MOVE WS-CASE-PSSWRD(WS-I) TO WS-PSSWRD
               MOVE FUNCTION VERIFY-PSSWRD-FUNC(WS-PSSWRD)
                   TO WS-RESULT
               IF WS-RESULT = WS-CASE-EXPECTED(WS-I)
                   DISPLAY "PASS  [" FUNCTION TRIM(WS-CASE-PSSWRD(WS-I))
                       "] -> " WS-RESULT
               ELSE
                   DISPLAY "FAIL  [" FUNCTION TRIM(WS-CASE-PSSWRD(WS-I))
                       "] -> got " WS-RESULT " expected "
                       WS-CASE-EXPECTED(WS-I)
                   ADD 1 TO WS-FAILURES
               END-IF
           END-PERFORM

           DISPLAY SPACES
           DISPLAY "TOTAL AMOUNT OF TIMES THE FUNCTION FAILED: "
           WS-FAILURES

           ACCEPT OMITTED

           STOP RUN.
