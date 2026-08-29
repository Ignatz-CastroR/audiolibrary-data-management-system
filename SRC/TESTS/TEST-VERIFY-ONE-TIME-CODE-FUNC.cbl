      ******************************************************************
      * Author: ENG. JOSE IGNACIO CASTRO DE R.
      * Place: DESAMPARADOS CENTRO, SAN JOSE, COSTA RICA
      * Program tested: VERIFY-ONE-TIME-CODE-FUNC.cbl
      * Purpose: Regression test running 7 fixed cases [3 valid, 4
      * invalid] against VERIFY-ONE-TIME-CODE-FUNC: a missing digit,
      * a missing special character, a missing upper case letter, and
      * an all-blank input, alongside two genuinely valid codes and
      * one valid code that also carries characters outside the three
      * recognized categories [a lower case letter and a colon],
      * confirming those are ignored rather than rejected, on purpose.
      * Reports PASS/FAIL per case and a total failure count [want 0].
      * Tectonics: cobc -x -fstatic-call TEST-VERIFY-ONE-TIME-CODE-FUNC.cbl
      * VERIFY-ONE-TIME-CODE-FUNC.cbl -o TEST-VERIFY-ONE-TIME-CODE-FUNC
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. TEST-VERIFY-ONE-TIME-CODE-FUNC.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       REPOSITORY.
           FUNCTION VERIFY-ONE-TIME-CODE-FUNC.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-CODE    PIC X(15).
       01 WS-RESULT  PIC 9.

       01 WS-CASES.
           05 FILLER PIC X(15) VALUE "ABCDEFGH23!?".
           05 FILLER PIC 9     VALUE 1.
           05 FILLER PIC X(15) VALUE "MNPQRST456789!".
           05 FILLER PIC 9     VALUE 1.
           05 FILLER PIC X(15) VALUE "ABcd23456!?.:".
           05 FILLER PIC 9     VALUE 1.
           05 FILLER PIC X(15) VALUE "ABCDEFGH!?.@-=".
           05 FILLER PIC 9     VALUE 0.
           05 FILLER PIC X(15) VALUE "ABCDEFGH23456".
           05 FILLER PIC 9     VALUE 0.
           05 FILLER PIC X(15) VALUE "23456789!?.@-".
           05 FILLER PIC 9     VALUE 0.
           05 FILLER PIC X(15) VALUE " ".
           05 FILLER PIC 9     VALUE 0.

       01 WS-CASE-TABLE REDEFINES WS-CASES.
           05 WS-CASE OCCURS 7 TIMES.
               10 WS-CASE-CODE     PIC X(15).
               10 WS-CASE-EXPECTED PIC 9.

       01 WS-I PIC 9(2).
       01 WS-FAILURES PIC 9(2) VALUE 0.

       PROCEDURE DIVISION.
           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 7
               MOVE WS-CASE-CODE(WS-I) TO WS-CODE
               MOVE FUNCTION VERIFY-ONE-TIME-CODE-FUNC(WS-CODE)
                   TO WS-RESULT
               IF WS-RESULT = WS-CASE-EXPECTED(WS-I)
                   DISPLAY "PASS  [" FUNCTION TRIM(WS-CASE-CODE(WS-I))
                       "] -> " WS-RESULT
               ELSE
                   DISPLAY "FAIL  [" FUNCTION TRIM(WS-CASE-CODE(WS-I))
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
