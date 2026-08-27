       IDENTIFICATION DIVISION.
       PROGRAM-ID. TEST-VALIDATE-EMAIL.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       REPOSITORY.
           FUNCTION VALIDATE-EMAIL-FUNC.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-EMAIL  PIC X(60).
       01 WS-RESULT PIC 9.

       01 WS-CASES.
           05 FILLER PIC X(40) VALUE "someone@gmail.com".
           05 FILLER PIC 9     VALUE 1.
           05 FILLER PIC X(40) VALUE "jose.ignacio@yahoo.co.uk".
           05 FILLER PIC 9     VALUE 1.
           05 FILLER PIC X(40) VALUE "user+tag@example.com".
           05 FILLER PIC 9     VALUE 1.
           05 FILLER PIC X(40) VALUE "noatsign.com".
           05 FILLER PIC 9     VALUE 0.
           05 FILLER PIC X(40) VALUE "two@at@signs.com".
           05 FILLER PIC 9     VALUE 0.
           05 FILLER PIC X(40) VALUE "@missinglocal.com".
           05 FILLER PIC 9     VALUE 0.
           05 FILLER PIC X(40) VALUE "missingdomain@".
           05 FILLER PIC 9     VALUE 0.
           05 FILLER PIC X(40) VALUE "nodot@domaincom".
           05 FILLER PIC 9     VALUE 0.
           05 FILLER PIC X(40) VALUE "startdot@.com".
           05 FILLER PIC 9     VALUE 0.
           05 FILLER PIC X(40) VALUE "enddot@domain.com.".
           05 FILLER PIC 9     VALUE 0.
           05 FILLER PIC X(40) VALUE "has space@domain.com".
           05 FILLER PIC 9     VALUE 0.
           05 FILLER PIC X(40) VALUE " ".
           05 FILLER PIC 9     VALUE 0.

       01 WS-CASE-TABLE REDEFINES WS-CASES.
           05 WS-CASE OCCURS 11 TIMES.
               10 WS-CASE-EMAIL    PIC X(40).
               10 WS-CASE-EXPECTED PIC 9.

       01 WS-I PIC 9(2).
       01 WS-FAILURES PIC 9(2) VALUE 0.

       PROCEDURE DIVISION.
           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 11
               MOVE WS-CASE-EMAIL(WS-I) TO WS-EMAIL
               MOVE FUNCTION VALIDATE-EMAIL-FUNC(WS-EMAIL)
                   TO WS-RESULT
               IF WS-RESULT = WS-CASE-EXPECTED(WS-I)
                   DISPLAY "PASS  [" FUNCTION TRIM(WS-CASE-EMAIL(WS-I))
                       "] -> " WS-RESULT
               ELSE
                   DISPLAY "FAIL  [" FUNCTION TRIM(WS-CASE-EMAIL(WS-I))
                       "] -> got " WS-RESULT " expected "
                       WS-CASE-EXPECTED(WS-I)
                   ADD 1 TO WS-FAILURES
               END-IF
           END-PERFORM

           DISPLAY " "
           DISPLAY "Total failures: " WS-FAILURES.

           ACCEPT OMITTED

           STOP RUN.
