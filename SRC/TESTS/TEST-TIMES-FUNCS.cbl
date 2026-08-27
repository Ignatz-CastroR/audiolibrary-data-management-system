      ******************************************************************
      * Author: ENG. JOSE IGNACIO CASTRO DE R.
      * Place: DESAMPARADOS CENTRO, SAN JOSE, COSTA RICA
      * Program tested: TIME-FUNCS.cbl
      * Purpose: Regression test battery for the TIME-NOW and
      * TIME-ELAPSED COBOL functions contained in
      * COBOL-FUNCTIONS/TIMES-FUNCS.cbl. Covers the classic calendar-
      * arithmetic edge cases: same minute, minute crossing,
      * hour crossing, midnight crossing, month crossing, a
      * leap-year boundary, and reversed order.
      * Requires: copybook TIMESTAMP.cpy [in the same folder or
      * by using the COB_COPY_DIR option when compiling], or by using
      * "-I .../COPYBOOKS/TIMESTAMP.cpy" when compiling.
      * Tectonics: cobc -x TEST-TIMES-FUNCS.cbl TIMES-FUNCS.cbl
      *  -I ../COPYBOOKSTIMESTAMP.cpy -o TEST-TIMES-FUNCS
      * [needs the -I flag: the copybook lives in a
      * separate folder {the COPYBOOKS/ subfolder}, and
      * cobc only checks the same present directory
      * as the source folder by default].
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. TEST-TIMES-FUNCS.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       REPOSITORY.
           FUNCTION TIME-NOW
           FUNCTION TIME-ELAPSED.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-START.
           COPY TIMESTAMP.
       01 WS-NOW.
           COPY TIMESTAMP.
       01 WS-ELAPSED   PIC S9(12) COMP-5.
       01 WS-EXPECTED  PIC S9(12) COMP-5.
       01 WS-STATUS    PIC 9.

       PROCEDURE DIVISION.

       MAIN-PAR.

      * Case 1: same minute, 5 seconds [500 centiseconds].

           MOVE 155466   TO TS-DAYS OF WS-START
           MOVE 3600000  TO TS-CENTISECONDS-OF-DAY OF WS-START
           MOVE 155466   TO TS-DAYS OF WS-NOW
           MOVE 3600500  TO TS-CENTISECONDS-OF-DAY OF WS-NOW
           MOVE 500      TO WS-EXPECTED
           PERFORM RUN-TEST-CASE.

      * Case 2: crosses a minute, same hour.

           MOVE 155466   TO TS-DAYS OF WS-START
           MOVE 3600000  TO TS-CENTISECONDS-OF-DAY OF WS-START
           MOVE 155466   TO TS-DAYS OF WS-NOW
           MOVE 3630000  TO TS-CENTISECONDS-OF-DAY OF WS-NOW
           MOVE 30000    TO WS-EXPECTED
           PERFORM RUN-TEST-CASE.

      * Case 3: crosses an hour [10:50:00 -> 11:10:00, 20 minutes]

           MOVE 155466   TO TS-DAYS OF WS-START
           MOVE 39000000 TO TS-CENTISECONDS-OF-DAY OF WS-START
           MOVE 155466   TO TS-DAYS OF WS-NOW
           MOVE 40200000 TO TS-CENTISECONDS-OF-DAY OF WS-NOW
           MOVE 1200000  TO WS-EXPECTED
           PERFORM RUN-TEST-CASE.

      * Case 4: crosses midnight [23:59:59.00 -> 00:00:01.00 the
      * next day; expected 200 centiseconds = 2 seconds]

           MOVE 155466   TO TS-DAYS OF WS-START
           MOVE 8639900  TO TS-CENTISECONDS-OF-DAY OF WS-START
           MOVE 155467   TO TS-DAYS OF WS-NOW
           MOVE 100      TO TS-CENTISECONDS-OF-DAY OF WS-NOW
           MOVE 200      TO WS-EXPECTED
           PERFORM RUN-TEST-CASE.

      * Case 5: crosses a full month [26-Aug-2026 to 26-Oct-2026,
      * exactly 61 days, same time of day]

           MOVE 155466   TO TS-DAYS OF WS-START
           MOVE 0        TO TS-CENTISECONDS-OF-DAY OF WS-START
           MOVE 155527   TO TS-DAYS OF WS-NOW
           MOVE 0        TO TS-CENTISECONDS-OF-DAY OF WS-NOW
           COMPUTE WS-EXPECTED = 61 * 8640000
           PERFORM RUN-TEST-CASE.

      * Case 6: leap-year boundary, 1-Feb-2024 to 1-Mar-2024 must
      * be 29 days [2024 was a leap year].

           MOVE FUNCTION INTEGER-OF-DATE(20240201)
               TO TS-DAYS OF WS-START
           MOVE 0 TO TS-CENTISECONDS-OF-DAY OF WS-START
           MOVE FUNCTION INTEGER-OF-DATE(20240301)
               TO TS-DAYS OF WS-NOW
           MOVE 0 TO TS-CENTISECONDS-OF-DAY OF WS-NOW
           COMPUTE WS-EXPECTED = 29 * 8640000
           PERFORM RUN-TEST-CASE.

      * Case 7: reversed order [now is BEFORE start]; must report
      * the error code, not a silent negative number

           MOVE 155466  TO TS-DAYS OF WS-START
           MOVE 3600000 TO TS-CENTISECONDS-OF-DAY OF WS-START
           MOVE 155466  TO TS-DAYS OF WS-NOW
           MOVE 1000000 TO TS-CENTISECONDS-OF-DAY OF WS-NOW
           MOVE FUNCTION TIME-ELAPSED(WS-START, WS-NOW,
               WS-ELAPSED) TO WS-STATUS
           DISPLAY "Case 7 (reversed order): status=" WS-STATUS
               " (expected 1) elapsed=" WS-ELAPSED
               " (expected 0)".

      * Case 8: real integration with the TIME-NOW function,
      * with a genuine 2 second pause between both clock readings.

           MOVE FUNCTION TIME-NOW(WS-START) TO WS-STATUS
           CALL "C$SLEEP" USING 2
           MOVE FUNCTION TIME-NOW(WS-NOW) TO WS-STATUS
           MOVE 200 TO WS-EXPECTED
           PERFORM RUN-TEST-CASE.

           STOP RUN.

       RUN-TEST-CASE.

           MOVE FUNCTION TIME-ELAPSED(WS-START, WS-NOW,
               WS-ELAPSED) TO WS-STATUS
           DISPLAY "expected=" WS-EXPECTED
               " got=" WS-ELAPSED
               " status=" WS-STATUS.
