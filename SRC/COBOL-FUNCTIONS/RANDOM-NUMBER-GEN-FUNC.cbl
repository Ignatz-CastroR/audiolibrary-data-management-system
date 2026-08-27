      ******************************************************************
      * Author:   ENG. JOSE IGNACIO CASTRO DE R.
      * Place: DESAMPARADOS CENTRO, SAN JOSE, COSTA RICA
      * Date: 2026/08/25,15:13, SUNNY AFTERNOON
      * Purpose:  Returns a 2-digit random number (00-99) for the music
      * cataloging project. Seeds the built-in generator
      * exactly once per run, from the system clock, using centiseconds.
      * on the first call, after a brief, nanosecond-scale delay to keep
      * rapid, separate runs of this program from landing on
      * the same clock reading; every later call in the same
      * run simply advances the same generator with
      * FUNCTION RANDOM [no seed], which needs no
      * further sleeping or reseeding at all. This
      * intentionally does NOT re-implement any part of a
      * linear congruential generator by hand; the built-in
      * one is trusted to do its own job.
      * Tectonics: cobc -c RANDOM-NUMBER-GEN-FUNC.cbl [or -m for a
      * module], before being linked to a calling program.
      * Security: Not cryptographically secure. The function
      * RANDOM-NUMBER-GEN-FUNC is a
      * general-purpose RNG seeded from the wall clock. Do not attempt
      * to use this function for anything where an attacker gaining
      * the ability to predict or influence the time-based output would
      * matter [session tokens, recovery codes, passwords, etc.].
      ******************************************************************
       IDENTIFICATION DIVISION.
       FUNCTION-ID. RANDOM-NUMBER-GEN-FUNC.

       DATA DIVISION.

      * Given that WORKING-STORAGE SECTION data persists between calls
      * [unlike LOCAL-STORAGE, which resets on every call], we have
      * placed the seeding flag and delay constant here:
      * WS-ALREADY-SEEDED starts false and flips true exactly once,
      * while the delay itself stays fixed. Therefore, the seeding
      * happens only once.

       WORKING-STORAGE SECTION.

       01 WS-ALREADY-SEEDED    PIC X VALUE "N".
           88 WS-SEEDED                     VALUE "Y".

      * A one-time, correctly-sized time delay
      *[5 centi seconds = 50 ms = 50,000,000 ns]
      * taken ONLY on the first call in a run, before reading the
      * clock to seed.
      * Without it, launching
      * this function back-to-back [as a fresh process each time,
      * e.g. from a shell loop] can land two separate runs in the
      * exact same hundredth-of-a-second, producing an identical
      * "random" seed.

       01 WS-SEEDING-DELAY-NANOSECONDS
                                PIC 9(08) COMP VALUE 50000000.

      * Given that the values in the LOCAL-STORAGE SECTION are erased
      * after each call [each call is a fresh start for these
      * data items], we have coded here the data that varies from one
      * call to the next.

       LOCAL-STORAGE SECTION.
       01 LS-SEED-SOURCE       PIC 9(8).
       01 LS-FRACTION          PIC 9V9(9).

       LINKAGE SECTION.
       01 LK-RESULT            PIC 9(2).

       PROCEDURE DIVISION
           RETURNING LK-RESULT.

       MAIN.

           IF WS-SEEDED
               MOVE FUNCTION RANDOM TO LS-FRACTION
           ELSE
               CALL "CBL_OC_NANOSLEEP"
                   USING WS-SEEDING-DELAY-NANOSECONDS
               ACCEPT LS-SEED-SOURCE FROM TIME
               MOVE FUNCTION RANDOM(LS-SEED-SOURCE) TO LS-FRACTION
               SET WS-SEEDED TO TRUE
           END-IF

      * LS-FRACTION is always in [0, 1); thus, this is always in the
      * closed range [0, 99]; that is to say, there is no overflow,
      * and therefore, no ON SIZE ERROR is needed.

           COMPUTE LK-RESULT = FUNCTION INTEGER(LS-FRACTION * 100)

           EXIT FUNCTION.

       END FUNCTION RANDOM-NUMBER-GEN-FUNC.

      * B"H.
