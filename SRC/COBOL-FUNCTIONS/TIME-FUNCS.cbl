      ******************************************************************
      * Author: ENG. JOSE IGNACIO CASTRO DE R.
      * Purpose: General-purpose time measurement library for the
      * music cataloging project. The function TIME-NOW captures
      * the current moment into an "opaque" structure [TIMESTAMP.cpy];
      * the TIME-ELAPSED function computes the temporal distance
      * between the present moment and the
      * moment previously captured with the TIME-NOW function.
      * Neither function touches external memory: the caller program
      * is responsible for keeping whichever moments it cares about
      * [e.g. a possible ATTEMPTED-LOGINS module that persists the
      * moment of the final password input allowed attempt, locks the
      * program temporarily, and measures when the block time has ended.
      * Requires: copybook TIMESTAMP.cpy [in the same folder or
      * by using the COB_COPY_DIR option when compiling], or by using
      * "-I ../COPYBOOKS" when compiling.
      * Tectonics: cobc -c TIME-FUNCS.cbl -I ../COPYBOOKS
      * [needs the -I flag: the copybook lives in a
      * separate folder {the COPYBOOKS/ subfolder}, and
      * cobc only checks the same present directory
      * as the source folder by default].
      * Place: DESAMPARADOS CENTRO, SAN JOSE, COSTA RICA
      * Security: No I/O at all. Read-only access to the system clock.
      ******************************************************************

       IDENTIFICATION DIVISION.
       FUNCTION-ID. TIME-NOW.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       01 WS-CENTISECONDS-PER-HOUR   PIC S9(9) COMP-5 VALUE 360000.
       01 WS-CENTISECONDS-PER-MINUTE PIC S9(9) COMP-5 VALUE 6000.
       01 WS-CENTISECONDS-PER-SECOND PIC S9(9) COMP-5 VALUE 100.

       LOCAL-STORAGE SECTION.
       01 LS-SYSTEM-DATE-TIME.
           05 LS-DATE-YYYYMMDD   PIC 9(8).
           05 LS-HOUR            PIC 9(2).
           05 LS-MINUTE          PIC 9(2).
           05 LS-SECOND          PIC 9(2).
           05 LS-CENTISECOND     PIC 9(2).
           05 LS-DATE-REMAINDER  PIC X(5).

       LINKAGE SECTION.
       01 LK-CURRENT-MOMENT.
           COPY TIMESTAMP.
       01 LK-RETURN-CODE        PIC 9.
           88 TN-SUCCESS                     VALUE ZERO.
           88 TN-ERROR-INVALID-CLOCK         VALUE 1.

       PROCEDURE DIVISION
           USING LK-CURRENT-MOMENT
           RETURNING LK-RETURN-CODE.

       MAIN.

           MOVE FUNCTION CURRENT-DATE TO LS-SYSTEM-DATE-TIME

           MOVE FUNCTION INTEGER-OF-DATE(LS-DATE-YYYYMMDD)
               TO TS-DAYS OF LK-CURRENT-MOMENT

      * The built-in function INTEGER-OF-DATE returns ZERO when the
      * date it received is
      * not valid. A healthy system clock should never trigger
      * this, but we have opted to check instead of assuming.

           IF TS-DAYS OF LK-CURRENT-MOMENT = ZERO
               MOVE ZERO TO TS-CENTISECONDS-OF-DAY OF LK-CURRENT-MOMENT
               SET TN-ERROR-INVALID-CLOCK TO TRUE
               PERFORM EXIT-PAR
           END-IF

           COMPUTE TS-CENTISECONDS-OF-DAY OF LK-CURRENT-MOMENT =
               LS-HOUR    * WS-CENTISECONDS-PER-HOUR +
               LS-MINUTE  * WS-CENTISECONDS-PER-MINUTE +
               LS-SECOND  * WS-CENTISECONDS-PER-SECOND +
               LS-CENTISECOND
           END-COMPUTE

           SET TN-SUCCESS TO TRUE
           PERFORM EXIT-PAR.

       EXIT-PAR.

           EXIT FUNCTION.

       END FUNCTION TIME-NOW.


       IDENTIFICATION DIVISION.
       FUNCTION-ID. TIME-ELAPSED.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       01 WS-CENTISECONDS-PER-DAY   PIC S9(9) COMP-5 VALUE 8640000.

       LOCAL-STORAGE SECTION.
       01 LS-DAYS-DIFFERENCE         PIC S9(9)  COMP-5.
       01 LS-CENTISECONDS-DIFFERENCE PIC S9(9)  COMP-5.

       LINKAGE SECTION.
       01 LK-START-MOMENT.
           COPY TIMESTAMP.
       01 LK-CURRENT-MOMENT.
           COPY TIMESTAMP.
       01 LK-ELAPSED-TIME       PIC S9(12) COMP-5.
       01 LK-RETURN-CODE        PIC 9.
           88 TE-SUCCESS                     VALUE ZERO.
           88 TE-ERROR-REVERSED-ORDER        VALUE 1.

       PROCEDURE DIVISION
           USING LK-START-MOMENT, LK-CURRENT-MOMENT,
               LK-ELAPSED-TIME
           RETURNING LK-RETURN-CODE.

       MAIN.

           COMPUTE LS-DAYS-DIFFERENCE =
               TS-DAYS OF LK-CURRENT-MOMENT -
               TS-DAYS OF LK-START-MOMENT
           END-COMPUTE

           COMPUTE LS-CENTISECONDS-DIFFERENCE =
               TS-CENTISECONDS-OF-DAY OF LK-CURRENT-MOMENT -
               TS-CENTISECONDS-OF-DAY OF LK-START-MOMENT
           END-COMPUTE

      * The only "borrow" needed in this whole calculation is as follo-
      * ws: if the current moment falls earlier in the day than the
      * start moment, take one full day from LS-DAYS-DIFFERENCE and add
      * it, in centiseconds, to LS-CENTISECONDS-DIFFERENCE.

           IF LS-CENTISECONDS-DIFFERENCE < ZERO
               SUBTRACT 1 FROM LS-DAYS-DIFFERENCE
               ADD WS-CENTISECONDS-PER-DAY TO LS-CENTISECONDS-DIFFERENCE
           END-IF

      * After the "borrow", LS-CENTISECONDS-DIFFERENCE is always >= 0;
      * the sign of the whole result depends only on the days.

           IF LS-DAYS-DIFFERENCE < ZERO
               MOVE ZERO TO LK-ELAPSED-TIME
               SET TE-ERROR-REVERSED-ORDER TO TRUE
               PERFORM EXIT-PAR
           END-IF

           COMPUTE LK-ELAPSED-TIME =
               LS-DAYS-DIFFERENCE * WS-CENTISECONDS-PER-DAY +
               LS-CENTISECONDS-DIFFERENCE
           END-COMPUTE

           SET TE-SUCCESS TO TRUE
           PERFORM EXIT-PAR.

       EXIT-PAR.

           EXIT FUNCTION.

       END FUNCTION TIME-ELAPSED.

      * B"H.
