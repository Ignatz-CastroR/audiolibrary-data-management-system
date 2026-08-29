      ******************************************************************
      * Author: ENG. JOSE IGNACIO CASTRO DE R.
      * Date: 2026/08/25, 18:25, CLOUDY NIGHT
      * Place: DESAMPARADOS CENTRO, SAN JOSE, COSTA RICA
      * Copybook: TIMESTAMP
      * Purpose: Internal structure of a "time-stamp moment" produced
      * by the TIME-NOW function
      * and consumed by the TIME-ELAPSED function.
      * Declared with COPY in
      * every program that needs to store, pass, or compare
      * a moment [including the potential future ATTEMPTED-LOGINS
      * module], so they all share the exact same layout instead of
      * retyping it.
      * Usage:    01 LK-MY-MOMENT.
      *               COPY TIMESTAMP.
      * Security: NONE
      ******************************************************************
           05 TS-DAYS               PIC S9(9)  COMP-5.
           05 TS-CENTISECONDS-OF-DAY PIC S9(9) COMP-5.
