      ******************************************************************
      * Author: ENG. JOSE IGNACIO CASTRO DE R.
      * Date: 2026/08/28, 12:58, CLOUDY AFTERNOON.
      * Place: DESAMPARADOS CENTRO, SAN JOSE, COSTA RICA.
      * Purpose: Reads the user's saved account configuration
      * [DAT-FILES/CONFIG.dat] and makes it available to the calling
      * program: presently, just the chosen interface language.
      * Growing into the module that owns the account
      * registration/settings screen itself - see MAIN.cbl's
      * "COBOL-MODULES/ ... not yet built" note in the project layout.
      * Tectonics: cobc -c CONFIG-INFO-MOD.cbl [or -m for a module],
      * before being bound to MAIN.cbl.
      * Security: PRESENTLY, NO CONCERNS - CONFIG-FILE holds no
      * secrets yet [only the language code]. This will need
      * revisiting once this module also reads/writes the account's
      * password and recovery code.
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. CONFIG-INFO-MOD IS INITIAL.

       ENVIRONMENT DIVISION.

       CONFIGURATION SECTION.

       SPECIAL-NAMES.
           CRT STATUS IS LS-KEY.

       SOURCE-COMPUTER. LA-LIGURIANA-05.
       OBJECT-COMPUTER. LA-BELLA-GEORGIANA-07.

       REPOSITORY.
           FUNCTION PSSWRD-GEN-FUNC,
           FUNCTION ONE-TIME-CODE-FUNC,
           FUNCTION VALIDATE-EMAIL-FUNC.

       INPUT-OUTPUT SECTION.

       FILE-CONTROL.

           SELECT CONFIG-FILE
           ASSIGN TO "DAT-FILES\CONFIG.dat",
           ORGANIZATION IS LINE SEQUENTIAL,
           FILE STATUS IS LS-FILE-STATUS,
           RECORD DELIMITER IS LINE-SEQUENTIAL,
           SHARING WITH ALL OTHER.

       DATA DIVISION.

       FILE SECTION.

       FD CONFIG-FILE IS EXTERNAL.
       01 FD-CONFIG-DETAILS.
           05 FD-LANGUAGE                     PIC 9.
           05 FD-USER-NAME                    PIC X(60).
           05 FD-PSSWRD                       PIC X(15).
           05 FD-ONE-TIME-RECOVERY-CODE       PIC X(15).

       WORKING-STORAGE SECTION.

       01 WS-SYSTERM-VARIABLES.
           05 WS-COLORS.
             06 WS-BASE-COLORS.
               10 WS-BLACK                   PIC 9 VALUE 0.
               10 WS-BLUE                    PIC 9 VALUE 1.
               10 WS-GREEN                   PIC 9 VALUE 2.
               10 WS-CYAN                    PIC 9 VALUE 3.
               10 WS-RED                     PIC 9 VALUE 4.
               10 WS-MAGENTA                 PIC 9 VALUE 5.
               10 WS-BROWN                   PIC 9 VALUE 6.
               10 WS-WHITE                   PIC 9 VALUE 7.
               10 WS-GRAY                    PIC 9 VALUE 8.
               10 WS-BRIGHT-BLUE             PIC 9 VALUE 9.
               10 WS-BRIGHT-GREEN            PIC 99 VALUE 10.
               10 WS-BRIGHT-CYAN             PIC 99 VALUE 11.
               10 WS-BRIGHT-RED              PIC 99 VALUE 12.
               10 WS-BRIGHT-MAGENTA          PIC 99 VALUE 13.
               10 WS-YELLOW                  PIC 99 VALUE 14.
               10 WS-BRIGHT-WHITE            PIC 99 VALUE 15.
             06 WS-SHADOW-COLORS.
               10 WS-SHADOW-1.
                   15 WS-FG-1                PIC 9.
                   15 WS-BG-1                PIC 9.
               10 WS-SHADOW-2.
                   15 WS-FG-2                PIC 9.
                   15 WS-BG-2                PIC 9.

       01 WS-FUNCTIONS-NAMES.
           05 WS-NANOSLEEP    PIC X(40) VALUE "CBL_OC_NANOSLEEP".

       LOCAL-STORAGE SECTION.

       01 LS-SYSTEM-LANGUAGE                  PIC 9.
           88 LS-ENGLISH                             VALUE 1.
           88 LS-SPANISH                             VALUE 2.

       01 LS-INTERACTIVE-MENU-ITEMS.
           05 LS-KEY                    PIC 9(4)  VALUE ZERO.
           05 LS-MENU-SELECTION         PIC 9     VALUE 1.
           05 LS-MENU-PAUSE             PIC 9(10) VALUE 1700000000.

       01 LS-CONFIG-DATA-ITEMS.
           05 LS-USER-NAME                     PIC X(60).
           05 LS-PSSWRD                        PIC X(15).
           05 LS-ONE-TIME-RECOVERY-CODE        PIC X(15).
           05 LS-EMAIL-ADDRESS                 PIC X(60).
           05 LS-SMTP-PSSWRD                   PIC X(30).

       01 LS-FILE-STATUS                       PIC X(02).
           88 LS-NO-FILE                                  VALUE "35".
           88 LS-FILE-FOUND                               VALUE "00".

       01 LS-CALL-FUNCS-LINK-VARS.
           05 LS-LINK-1                        PIC 9.

       LINKAGE SECTION.

       01 LK-RETURN-CODE                       PIC S9.

       SCREEN SECTION.

       01 EN-BASIC-CONFIG-DATA-SCREEN.

           05 BLANK SCREEN BACKGROUND-COLOR WS-CYAN HIGHLIGHT.

           05 BACKGROUND-COLOR WS-BLACK LINE 3 COLUMN 11 PIC X(160)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 4 COLUMN 11 PIC X(160)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 5 COLUMN 11 PIC X(160)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 6 COLUMN 11 PIC X(160)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 7 COLUMN 11 PIC X(160)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 8 COLUMN 11 PIC X(160)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 9 COLUMN 11 PIC X(160)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 10 COLUMN 11 PIC X(160)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 11 COLUMN 11 PIC X(160)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 12 COLUMN 11 PIC X(160)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 13 COLUMN 11 PIC X(160)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 14 COLUMN 11 PIC X(160)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 15 COLUMN 11 PIC X(160)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 16 COLUMN 11 PIC X(160)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 17 COLUMN 11 PIC X(160)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 18 COLUMN 11 PIC X(160)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 19 COLUMN 11 PIC X(160)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 20 COLUMN 11 PIC X(160)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 21 COLUMN 11 PIC X(160)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 22 COLUMN 11 PIC X(160)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 23 COLUMN 11 PIC X(160)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 24 COLUMN 11 PIC X(160)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 25 COLUMN 11 PIC X(160)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 26 COLUMN 11 PIC X(160)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 27 COLUMN 11 PIC X(160)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 28 COLUMN 11 PIC X(160)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 29 COLUMN 11 PIC X(160)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 30 COLUMN 11 PIC X(160)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 31 COLUMN 11 PIC X(160)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 32 COLUMN 11 PIC X(160)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 33 COLUMN 11 PIC X(160)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 34 COLUMN 11 PIC X(160)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 35 COLUMN 11 PIC X(160)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 36 COLUMN 11 PIC X(160)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 37 COLUMN 11 PIC X(160)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 38 COLUMN 11 PIC X(160)
           VALUE SPACES.

           05 BACKGROUND-COLOR WS-BROWN LINE 2 COLUMN 10 PIC X(155)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 3 COLUMN 10 PIC X(155)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 4 COLUMN 10 PIC X(155)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 5 COLUMN 10 PIC X(155)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 6 COLUMN 10 PIC X(155)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 7 COLUMN 10 PIC X(155)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 8 COLUMN 10 PIC X(155)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 9 COLUMN 10 PIC X(155)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 10 COLUMN 10 PIC X(155)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 11 COLUMN 10 PIC X(155)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 12 COLUMN 10 PIC X(155)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 13 COLUMN 10 PIC X(155)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 14 COLUMN 10 PIC X(155)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 15 COLUMN 10 PIC X(155)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 16 COLUMN 10 PIC X(155)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 17 COLUMN 10 PIC X(155)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 18 COLUMN 10 PIC X(155)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 19 COLUMN 10 PIC X(155)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 20 COLUMN 10 PIC X(155)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 21 COLUMN 10 PIC X(155)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 22 COLUMN 10 PIC X(155)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 23 COLUMN 10 PIC X(155)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 24 COLUMN 10 PIC X(155)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 25 COLUMN 10 PIC X(155)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 26 COLUMN 10 PIC X(155)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 27 COLUMN 10 PIC X(155)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 28 COLUMN 10 PIC X(155)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 29 COLUMN 10 PIC X(155)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 30 COLUMN 10 PIC X(155)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 31 COLUMN 10 PIC X(155)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 32 COLUMN 10 PIC X(155)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 33 COLUMN 10 PIC X(155)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 34 COLUMN 10 PIC X(155)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 35 COLUMN 10 PIC X(155)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 36 COLUMN 10 PIC X(155)
           VALUE SPACES.

       PROCEDURE DIVISION
       USING LK-RETURN-CODE.

       MAIN-PAR.

      * COB_SCREEN_EXCEPTIONS is deliberately NOT set here. This
      * module currently only reads CONFIG-FILE - no ACCEPT of any
      * kind yet - so the setting has nothing to affect today. It is
      * flagged here anyway because this module is the one meant to
      * grow into the account registration/settings screen: an
      * outside COBOL/Go experiment on this same GnuCOBOL build
      * already worked through this exact question for that kind of
      * screen and found that (1) COB_SCREEN_EXCEPTIONS only matters
      * for a single-field ACCEPT [field_accept], never for ACCEPT
      * OMITTED; (2) SET ENVIRONMENT does not actually take effect
      * for it at runtime on this build regardless; (3) no Go
      * function can fix that, since nothing called from within a
      * COBOL program can run before cob_init(), which is what
      * consults this setting on startup - so a Go-based workaround
      * was tried and confirmed impossible, not merely unneeded; and
      * (4) the only two things confirmed to work [editing GnuCOBOL's
      * own runtime.cfg machine-wide, or a separate launcher .exe
      * spawning the real program as a child process] both add
      * deployment complexity that is not worth it. The validated
      * path for this module, once it needs real typing AND
      * arrow-key navigation together, is to bypass ACCEPT entirely
      * and read the raw keyboard through a small Go bridge instead -
      * see UNIFIED-RAWKEY.cbl outside this repository for the
      * working reference implementation this module should follow.

           OPEN INPUT CONFIG-FILE

           IF NOT LS-FILE-FOUND THEN
               MOVE -1 TO LK-RETURN-CODE
               PERFORM EXIT-PAR
           END-IF

           READ CONFIG-FILE INTO FD-CONFIG-DETAILS

           MOVE FD-LANGUAGE TO LS-SYSTEM-LANGUAGE

           EVALUATE LS-SYSTEM-LANGUAGE
               WHEN 1
                   SET LS-ENGLISH TO TRUE
               WHEN 2
                   SET LS-SPANISH TO TRUE
           END-EVALUATE


           .

       EXIT-PAR.

           EXIT PROGRAM.

       END PROGRAM CONFIG-INFO-MOD.
