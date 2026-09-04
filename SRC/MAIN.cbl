      ******************************************************************
      * Author: ENG. JOSE IGNACIO CASTRO DE R.
      * Date: 2026/08/26, 13:03, CLOUDY AFTERNOON.
      * Purpose: Entry point for the audio catalog system. Currently
      *          a placeholder pending the login/menu architecture -
      *          see DOCS/ARCHITECTURE-DECISIONS.md.
      * Tectonics: cobc -x MAIN.cbl
      * Place: DESAMPARADOS CENTRO, SAN JOSE, COSTA RICA
      * Security: N/A - placeholder, no logic yet, SO THERE ARE NO REAL
      * THINGS WHICH SHOULD POTENTIALLY BE KEPT SECRET FOR NOW.
      ******************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID. MAIN IS RECURSIVE.
       AUTHOR. ENG. JOSE IGNACIO CASTRO DE R.
       INSTALLATION.
       DATE-WRITTEN. 2026/08/26, 13:03, CLOUDY AFTERNOON.
       DATE-MODIFIED. 2026/08/27, 10:59, SUNNY MORNING.
       DATE-COMPILED.
       SECURITY.


       ENVIRONMENT DIVISION.

       CONFIGURATION SECTION.

       SPECIAL-NAMES.
           CRT STATUS IS WS-KEY.

       SOURCE-COMPUTER. LA-LIGURIANA-05.
       OBJECT-COMPUTER. LA-BELLA-GEORGIANA-07.

       INPUT-OUTPUT SECTION.

       FILE-CONTROL.

           SELECT CONFIG-FILE
           ASSIGN TO "DAT-FILES\CONFIG.dat",
           ORGANIZATION IS LINE SEQUENTIAL,
           FILE STATUS IS WS-FILE-STATUS,
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
           05 WS-CODEPAGE-CMD              PIC X(30)
                                           VALUE "chcp 1252 > NUL".
           05 WS-INTERACTIVE-MENU-ITEMS.
               10 WS-KEY                    PIC 9(4)  VALUE ZERO.
               10 WS-MENU-SELECTION         PIC 9 VALUE 1.
               10 WS-MENU-PAUSE             PIC 9(10)
                                            VALUE 1700000000.
           05 WS-SYSTEM-LANGUAGE            PIC 9.
               88 WS-ENGLISH                      VALUE 1.
               88 WS-SPANISH                      VALUE 2.
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

       01 WS-FILE-STATUS                     PIC X(02).
           88 WS-NO-FILE                           VALUE "35".
           88 WS-FILE-FOUND                        VALUE "00".

       01 WS-CALL-MODULES-LINK-VARS.
           05 WS-LINK-1          PIC 9.

       01 WS-FUNCTIONS-NAMES.
           05 WS-NANOSLEEP    PIC X(40) VALUE "CBL_OC_NANOSLEEP".

       REPORT SECTION.

       SCREEN SECTION.

      * Opening, front page of the program.

       01 OPENING-SCREEN.

      * Clearing screen and setting the background color.

           05 BLANK SCREEN BACKGROUND-COLOR WS-WHITE HIGHLIGHT.

      * Setting the black shadow effect for the menu box.

           05 BACKGROUND-COLOR WS-BLACK LINE 4 COLUMN 26 PIC X(87)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 5 COLUMN 26 PIC X(87)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 6 COLUMN 26 PIC X(87)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 7 COLUMN 26 PIC X(87)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 8 COLUMN 26 PIC X(87)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 9 COLUMN 26 PIC X(87)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 10  COLUMN 26 PIC X(87)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 11 COLUMN 26 PIC X(87)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 12 COLUMN 26 PIC X(87)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 13 COLUMN 26 PIC X(87)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 14 COLUMN 26 PIC X(87)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 15 COLUMN 26 PIC X(87)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 16 COLUMN 26 PIC X(87)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 17 COLUMN 26 PIC X(87)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 18 COLUMN 26 PIC X(87)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 19 COLUMN 26 PIC X(87)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 20 COLUMN 26 PIC X(87)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 21 COLUMN 26 PIC X(87)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 22 COLUMN 26 PIC X(87)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 23 COLUMN 26 PIC X(87)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 24 COLUMN 26 PIC X(87)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 25 COLUMN 26 PIC X(87)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 26 COLUMN 26 PIC X(87)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 27 COLUMN 26 PIC X(87)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 28 COLUMN 26 PIC X(87)
              VALUE SPACES.

           05 BACKGROUND-COLOR WS-CYAN LINE 3 COLUMN 25 PIC X(84)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-CYAN LINE 4 COLUMN 25 PIC X(84)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-CYAN LINE 5 COLUMN 25 PIC X(84)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-CYAN LINE 6 COLUMN 25 PIC X(84)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-CYAN LINE 7 COLUMN 25 PIC X(84)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-CYAN LINE 8 COLUMN 25 PIC X(84)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-CYAN LINE 9 COLUMN 25 PIC X(84)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-CYAN LINE 10 COLUMN 25 PIC X(84)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-CYAN LINE 11 COLUMN 25 PIC X(84)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-CYAN LINE 12 COLUMN 25 PIC X(84)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-CYAN LINE 13 COLUMN 25 PIC X(84)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-CYAN LINE 14 COLUMN 25 PIC X(84)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-CYAN LINE 15 COLUMN 25 PIC X(84)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-CYAN LINE 16 COLUMN 25 PIC X(84)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-CYAN LINE 17 COLUMN 25 PIC X(84)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-CYAN LINE 18 COLUMN 25 PIC X(84)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-CYAN LINE 19 COLUMN 25 PIC X(84)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-CYAN LINE 20 COLUMN 25 PIC X(84)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-CYAN LINE 21 COLUMN 25 PIC X(84)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-CYAN LINE 22 COLUMN 25 PIC X(84)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-CYAN LINE 23 COLUMN 25 PIC X(84)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-CYAN LINE 24 COLUMN 25 PIC X(84)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-CYAN LINE 25 COLUMN 25 PIC X(84)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-CYAN LINE 26 COLUMN 25 PIC X(84)
              VALUE SPACES.

           05 BACKGROUND-COLOR WS-BLUE LINE 4 COLUMN 26 PIC X(82)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLUE LINE 5 COLUMN 26 PIC X(82)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLUE LINE 6 COLUMN 26 PIC X(82)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLUE LINE 7 COLUMN 26 PIC X(82)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLUE LINE 8 COLUMN 26 PIC X(82)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLUE LINE 9 COLUMN 26 PIC X(82)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLUE LINE 10 COLUMN 26 PIC X(82)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLUE LINE 11 COLUMN 26 PIC X(82)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLUE LINE 12 COLUMN 26 PIC X(82)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLUE LINE 13 COLUMN 26 PIC X(82)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLUE LINE 14 COLUMN 26 PIC X(82)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLUE LINE 15 COLUMN 26 PIC X(82)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLUE LINE 16 COLUMN 26 PIC X(82)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLUE LINE 17 COLUMN 26 PIC X(82)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLUE LINE 18 COLUMN 26 PIC X(82)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLUE LINE 19 COLUMN 26 PIC X(82)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLUE LINE 20 COLUMN 26 PIC X(82)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLUE LINE 21 COLUMN 26 PIC X(82)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLUE LINE 22 COLUMN 26 PIC X(82)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLUE LINE 23 COLUMN 26 PIC X(82)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLUE LINE 24 COLUMN 26 PIC X(82)
              VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLUE LINE 25 COLUMN 26 PIC X(82)
              VALUE SPACES.

           05 FOREGROUND-COLOR WS-GREEN BACKGROUND-COLOR WS-BLUE
              HIGHLIGHT LINE 4 COLUMN 59
              VALUE "MUZIKA KALIMERA".
           05 FOREGROUND-COLOR WS-BROWN BACKGROUND-COLOR WS-BLUE
              LINE 6 COLUMN 30
              VALUE "Audiolibrary repository management system".
           05 FOREGROUND-COLOR WS-BROWN BACKGROUND-COLOR WS-BLUE
              LINE 8 COLUMN 30
              VALUE "Sistema de manejo de repositorio de audiolibrería".

           05 FOREGROUND-COLOR WS-RED BACKGROUND-COLOR WS-BLUE
              LINE 9 COLUMN 26
              VALUE
           "------------------------------------------------------------
      -    "----------------------".

           05 FOREGROUND-COLOR WS-RED BACKGROUND-COLOR WS-BLUE
              HIGHLIGHT
              LINE 11 COLUMN 30
              VALUE
              "Programmed with/Programado con:     GNUCOBOL".

           05 FOREGROUND-COLOR WS-WHITE BACKGROUND-COLOR WS-BLUE
              LINE 13 COLUMN 30
              VALUE "AUTHOR/AUTOR: ENG/ING JOSÉ IGNACIO CASTRO DE R.".

           05 FOREGROUND-COLOR WS-WHITE BACKGROUND-COLOR WS-BLUE
              LINE 14 COLUMN 30
              VALUE "EMAIL/CORREO ELECTRÓNICO: JOSEIGNACIO512CASTRO@YAHO
      -    "O.COM".

           05 FOREGROUND-COLOR WS-BRIGHT-GREEN
              BACKGROUND-COLOR WS-BLUE
              LINE 16 COLUMN 30 VALUE "2026".

           05 BACKGROUND-COLOR WS-MAGENTA LINE 20 COLUMN 49
              PIC X(36) VALUE SPACES.
           05 BACKGROUND-COLOR WS-MAGENTA LINE 21 COLUMN 49
              PIC X(36) VALUE SPACES.
           05 BACKGROUND-COLOR WS-MAGENTA LINE 22 COLUMN 49
              PIC X(36) VALUE SPACES.
           05 BACKGROUND-COLOR WS-MAGENTA LINE 23 COLUMN 49
              PIC X(36) VALUE SPACES.
           05 BACKGROUND-COLOR WS-MAGENTA LINE 24 COLUMN 49
              PIC X(36) VALUE SPACES.

           05 FOREGROUND-COLOR WS-WHITE BACKGROUND-COLOR WS-MAGENTA
              LINE 21 COLUMN 51
              VALUE "PRESS 'ENTER' TO CONTINUE".
           05 FOREGROUND-COLOR WS-WHITE BACKGROUND-COLOR WS-MAGENTA
              LINE 23 COLUMN 51
              VALUE "PRESIONA 'ENTER' PARA CONTINUAR".

      ******************************************************************

      * Screen fro the user choosing a language option; dislayed for
      * first time users.

       01 SET-LANGUAGE-SCREEN.

      * Clearing screen and setting the background color.

           05 BLANK SCREEN BACKGROUND-COLOR WS-CYAN HIGHLIGHT.

      * Setting the black shadow effect for the menu box.

           05 BACKGROUND-COLOR WS-BLACK LINE 4 COLUMN 22 PIC X(83)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 5 COLUMN 22 PIC X(83)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 6 COLUMN 22 PIC X(83)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 7 COLUMN 22 PIC X(83)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 8 COLUMN 22 PIC X(83)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 9 COLUMN 22 PIC X(83)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 10 COLUMN 22 PIC X(83)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 11 COLUMN 22 PIC X(83)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 12 COLUMN 22 PIC X(83)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 13 COLUMN 22 PIC X(83)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 14 COLUMN 22 PIC X(83)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 15 COLUMN 22 PIC X(83)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 16 COLUMN 22 PIC X(83)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 17 COLUMN 22 PIC X(83)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 18 COLUMN 22 PIC X(83)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 19 COLUMN 22 PIC X(83)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 20 COLUMN 22 PIC X(83)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 21 COLUMN 22 PIC X(83)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 22 COLUMN 22 PIC X(83)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 23 COLUMN 22 PIC X(83)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 24 COLUMN 22 PIC X(83)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 25 COLUMN 22 PIC X(83)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 26 COLUMN 22 PIC X(83)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 27 COLUMN 22 PIC X(83)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BLACK LINE 28 COLUMN 22 PIC X(83)
           VALUE SPACES.

      * Setting the color and format of the menu box.

           05 BACKGROUND-COLOR WS-BROWN LINE 3 COLUMN 21 PIC X(80)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 4 COLUMN 21 PIC X(80)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 5 COLUMN 21 PIC X(80)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 6 COLUMN 21 PIC X(80)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 7 COLUMN 21 PIC X(80)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 8 COLUMN 21 PIC X(80)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 9 COLUMN 21 PIC X(80)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 10 COLUMN 21 PIC X(80)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 11 COLUMN 21 PIC X(80)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 12 COLUMN 21 PIC X(80)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 13 COLUMN 21 PIC X(80)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 14 COLUMN 21 PIC X(80)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 15 COLUMN 21 PIC X(80)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 16 COLUMN 21 PIC X(80)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 17 COLUMN 21 PIC X(80)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 18 COLUMN 21 PIC X(80)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 19 COLUMN 21 PIC X(80)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 20 COLUMN 21 PIC X(80)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 21 COLUMN 21 PIC X(80)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 22 COLUMN 21 PIC X(80)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 23 COLUMN 21 PIC X(80)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 24 COLUMN 21 PIC X(80)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-BROWN LINE 25 COLUMN 21 PIC X(80)
           VALUE SPACES.

      * Settting the text messages to be displayed in the menu box.

           05 FOREGROUND-COLOR WS-BLUE BACKGROUND-COLOR WS-BROWN
           LINE 4 COLUMN 25
           VALUE "IN WHAT LANGUAGE DO YOU WANT TO CONTINUE?".
           05 FOREGROUND-COLOR WS-BLUE
           BACKGROUND-COLOR WS-BROWN
           LINE 6 COLUMN 25
           VALUE
           "[THE OPTION SELECTED WILL BE SAVED IN YOUR ACCOUNT CONFIGURA
      -    "TION;".
           05 FOREGROUND-COLOR WS-BLUE
           BACKGROUND-COLOR WS-BROWN
           LINE 7 COLUMN 25
           VALUE
           "YOU'LL BE ABLE TO CHANGE THIS OPTION LATER IN YOUR ACCOUNT'S
      -    " SETTINGS.]".

           05 FOREGROUND-COLOR WS-BLUE BACKGROUND-COLOR WS-BROWN
           LINE 11 COLUMN 25
           VALUE "¿EN QUÉ LENGUA DESEAS CONTINUAR?".
           05 FOREGROUND-COLOR WS-BLUE
           BACKGROUND-COLOR WS-BROWN
           LINE 13 COLUMN 25
           VALUE
           "[LA OPCIÓN SELECCIONADA SE GARDARÁ EN LA CONFIGURACIÓN DE TU
      -    " CUENTA;".
           05 FOREGROUND-COLOR WS-BLUE
           BACKGROUND-COLOR WS-BROWN
           LINE 14 COLUMN 25
           VALUE
           "SERÁS LUEGO CAPAZ DE CAMBIAR ESTA OPCIÓN EN LOS AJUSTES DE T
      -    "U CUENTA.]".

           05 FOREGROUND-COLOR WS-RED
           BACKGROUND-COLOR WS-BROWN
           LINE 16 COLUMN 21
           VALUE
           "------------------------------------------------------------
      -    "--------------------".

           05 FOREGROUND-COLOR WS-FG-1 BACKGROUND-COLOR WS-BG-1
           HIGHLIGHT LINE 19 COLUMN 57 VALUE "1. ENGLISH".
           05 FOREGROUND-COLOR WS-FG-2 BACKGROUND-COLOR WS-BG-2
           HIGHLIGHT LINE 22 COLUMN 57 VALUE "2. ESPAÑOL".

       01 EN-LNG-SETTING-CONFIRM-SCREEN.

           05 BACKGROUND-COLOR WS-MAGENTA LINE 15 COLUMN 30 PIC X(90)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-MAGENTA LINE 16 COLUMN 30 PIC X(90)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-MAGENTA LINE 17 COLUMN 30 PIC X(90)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-MAGENTA LINE 18 COLUMN 30 PIC X(90)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-MAGENTA LINE 19 COLUMN 30 PIC X(90)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-MAGENTA LINE 20 COLUMN 30 PIC X(90)
           VALUE SPACES.

           05 FOREGROUND-COLOR WS-WHITE BACKGROUND-COLOR WS-MAGENTA
           LINE 16 COLUMN 32
           VALUE "YOU HAVE CHOSEN ENGLISH AS YOUR ACCOUNT'S LANGUAGE.".
           05 FOREGROUND-COLOR WS-WHITE BACKGROUND-COLOR WS-MAGENTA
           LINE 17 COLUMN 32
           VALUE
           "IF YOU ARE SATISFIED WITH THIS SELECTION, PRESS 'ENTER' TO C
      -    "ONTINUE.".
           05 FOREGROUND-COLOR WS-WHITE BACKGROUND-COLOR WS-MAGENTA
           LINE 18 COLUMN 32
           VALUE
           "SHOULD YOU BE DISSATISFIED WITH THIS CHOICE, PRESS THE 'BACK
      -    "SPACE' KEY".
           05 FOREGROUND-COLOR WS-WHITE BACKGROUND-COLOR WS-MAGENTA
           LINE 19 COLUMN 32
           VALUE
           "[THE ERASING KEY]; THIS'LL GET YOU BACK TO THE PREVIOUS MENU
      -    " SO YOU MAY CHOOSE AGAIN.".

       01 SP-LNG-SETTING-CONFIRM-SCREEN.

           05 BACKGROUND-COLOR WS-MAGENTA LINE 15 COLUMN 30 PIC X(90)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-MAGENTA LINE 16 COLUMN 30 PIC X(90)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-MAGENTA LINE 17 COLUMN 30 PIC X(90)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-MAGENTA LINE 18 COLUMN 30 PIC X(90)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-MAGENTA LINE 19 COLUMN 30 PIC X(90)
           VALUE SPACES.
           05 BACKGROUND-COLOR WS-MAGENTA LINE 20 COLUMN 30 PIC X(90)
           VALUE SPACES.

           05 FOREGROUND-COLOR WS-WHITE BACKGROUND-COLOR WS-MAGENTA
           LINE 16 COLUMN 32
           VALUE "HAS ELEGIDO ESPAÑOL COMO LA LENGUA DE TU CUENTA.".
           05 FOREGROUND-COLOR WS-WHITE BACKGROUND-COLOR WS-MAGENTA
           LINE 17 COLUMN 32
           VALUE
           "SI ESTÁS SATISFECHO CON TU ELECCIÓN, PRESIONA 'ENTER' PARA C
      -    "ONTINUAR.".
           05 FOREGROUND-COLOR WS-WHITE BACKGROUND-COLOR WS-MAGENTA
           LINE 18 COLUMN 32
           VALUE
           "SI NO ESTÁS CONFORME CON LA ELECCIÓN HECHA, PRESIONA LA TECL
      -    "A DE RETROCESO [DE BORRAR];".
           05 FOREGROUND-COLOR WS-WHITE BACKGROUND-COLOR WS-MAGENTA
           LINE 19 COLUMN 32
           VALUE
           "ESTO TE LLEVARÁ DE VUELTA AL MENÚ ANTERIOR PARA QUE PUEDAS E
      -    "LEGIR DE NUEVO.".

       PROCEDURE DIVISION.

       MASTER-PAR.

      * The very first action this master COBOL source code file
      * executes is ordering the system to set "chcp 1252".
      * This ensures that everything after this instruction, in the
      * compiled .exe application file, displays correctly both
      * Spanish and English characters without corruptions.

           CALL "SYSTEM" USING WS-CODEPAGE-CMD

           SET ENVIRONMENT "COB_SCREEN_EXCEPTIONS" TO "1"

      * COB_SCREEN_EXCEPTIONS is deliberately NOT set here anymore.
      * That setting only changes whether a single-field ACCEPT
      * [field_accept] reports Up/Down/Page Up/Page Down/Escape;
      * this program only ever drives its menus through ACCEPT
      * OMITTED [see FRONT-PAGE-PAR and SET-LANGUAGE-PAR below],
      * which already reports those keys reliably on its own,
      * regardless of this setting. Separately, an outside COBOL/Go
      * experiment on this same GnuCOBOL build confirmed that SET
      * ENVIRONMENT does NOT actually take effect at runtime for this
      * setting, and that no Go function can fix that either: nothing
      * called from within a COBOL program [not even its very first
      * statement] can run before cob_init(), which is what
      * consults this setting on startup. Only two things were ever
      * confirmed to work: editing GnuCOBOL's own runtime.cfg
      * directly [machine-wide, not per-program], or a separate
      * launcher .exe that sets the variable and spawns the real
      * program as a fresh child process. Neither is worth the
      * deployment complexity for what this program actually needs
      * today. If a future screen in this project ever needs BOTH
      * real character typing AND reliable arrow-key navigation at
      * once [ACCEPT OMITTED cannot type; a single-field ACCEPT's
      * own arrow-key reporting was independently confirmed
      * unreliable on this build, correctly configured or not], the
      * validated fix is to bypass GnuCOBOL's ACCEPT entirely and
      * read the raw keyboard directly through a small Go bridge
      * function, not to keep chasing this setting.

           PERFORM FRONT-PAGE-PAR

           PERFORM FIRST-READ-PAR

           STOP RUN.

       FRONT-PAGE-PAR.

           PERFORM WITH TEST AFTER UNTIL WS-KEY = 0
               DISPLAY OPENING-SCREEN
               ACCEPT OMITTED
               IF WS-KEY = 2005 THEN
                   PERFORM EXIT-PAR
               ELSE IF WS-KEY = 0 THEN
                   EXIT PARAGRAPH
               ELSE
                   CONTINUE
               END-IF
           END-PERFORM.

       FIRST-READ-PAR.

           OPEN INPUT CONFIG-FILE

           IF WS-NO-FILE THEN
               PERFORM SET-LANGUAGE-PAR
           ELSE
               READ CONFIG-FILE INTO FD-CONFIG-DETAILS
               CLOSE CONFIG-FILE
           END-IF

           ACCEPT OMITTED

           PERFORM EXIT-PAR.

       SET-LANGUAGE-PAR.

           PERFORM UPDATING-COLORS-PAR

           PERFORM WITH TEST AFTER UNTIL WS-KEY = 0
               DISPLAY SET-LANGUAGE-SCREEN
               ACCEPT OMITTED
               IF WS-KEY = 2005 THEN
                   PERFORM EXIT-PAR
               END-IF
               EVALUATE WS-KEY
                   WHEN 2003
                       IF WS-MENU-SELECTION = 1 THEN
                           MOVE 2 TO WS-MENU-SELECTION
                       ELSE
                           SUBTRACT 1 FROM WS-MENU-SELECTION
                       END-IF
                       PERFORM UPDATING-COLORS-PAR
                   WHEN 2004
                       IF WS-MENU-SELECTION = 2 THEN
                           MOVE 1 TO WS-MENU-SELECTION
                       ELSE
                           ADD 1 TO WS-MENU-SELECTION
                       END-IF
                       PERFORM UPDATING-COLORS-PAR
                   WHEN 2001
                       MOVE 1 TO WS-MENU-SELECTION
                       PERFORM UPDATING-COLORS-PAR
                   WHEN 2002
                       MOVE 2 TO WS-MENU-SELECTION
                       PERFORM UPDATING-COLORS-PAR
                   WHEN OTHER
                       CONTINUE
               END-EVALUATE
           END-PERFORM

           PERFORM CONFIRM-SELECTION-PAR

           PERFORM CONFIRM-LANG-SET-PAR

           EVALUATE WS-MENU-SELECTION
               WHEN 1
                   SET WS-ENGLISH TO TRUE
               WHEN 2
                   SET WS-SPANISH TO TRUE
           END-EVALUATE

           OPEN OUTPUT CONFIG-FILE

           IF NOT WS-FILE-FOUND THEN
               PERFORM EXIT-PAR
           END-IF

           INITIALIZE FD-CONFIG-DETAILS

           MOVE WS-SYSTEM-LANGUAGE TO FD-LANGUAGE

           WRITE FD-CONFIG-DETAILS

           CLOSE CONFIG-FILE

           EXIT PARAGRAPH.

       UPDATING-COLORS-PAR.

           MOVE WS-WHITE  TO WS-FG-1
           MOVE WS-BROWN  TO WS-BG-1
           MOVE WS-WHITE  TO WS-FG-2
           MOVE WS-BROWN  TO WS-BG-2

           EVALUATE WS-MENU-SELECTION
               WHEN 1
                   MOVE WS-BLACK        TO WS-FG-1
                   MOVE WS-GREEN        TO WS-BG-1
               WHEN 2
                   MOVE WS-BLACK        TO WS-FG-2
                   MOVE WS-GREEN        TO WS-BG-2
           END-EVALUATE.

       CONFIRM-SELECTION-PAR.

           EVALUATE WS-MENU-SELECTION
               WHEN 1
                   MOVE WS-BLACK TO WS-FG-1
                   MOVE WS-WHITE TO WS-BG-1
               WHEN 2
                   MOVE WS-BLACK TO WS-FG-2
                   MOVE WS-WHITE TO WS-BG-2
           END-EVALUATE

           DISPLAY SET-LANGUAGE-SCREEN

           CALL WS-NANOSLEEP USING WS-MENU-PAUSE.

       CONFIRM-LANG-SET-PAR.

           EVALUATE WS-MENU-SELECTION
               WHEN 1
                   PERFORM
                   WITH TEST AFTER
                   UNTIL WS-KEY = 0
                       DISPLAY EN-LNG-SETTING-CONFIRM-SCREEN
                       ACCEPT OMITTED
                       IF WS-KEY = 2013 THEN
                           MOVE 0 TO WS-KEY
                           PERFORM SET-LANGUAGE-PAR
                       ELSE IF WS-KEY = 0 THEN
                           EXIT PARAGRAPH
                       ELSE
                           CONTINUE
                       END-IF
                   END-PERFORM
               WHEN 2
                   PERFORM
                   WITH TEST AFTER
                   UNTIL WS-KEY = 0
                       DISPLAY SP-LNG-SETTING-CONFIRM-SCREEN
                       ACCEPT OMITTED
                       IF WS-KEY = 2013 THEN
                           MOVE 0 TO WS-KEY
                           PERFORM SET-LANGUAGE-PAR
                       ELSE IF WS-KEY = 0 THEN
                           EXIT PARAGRAPH
                       ELSE
                           CONTINUE
                       END-IF
                   END-PERFORM
           END-EVALUATE.

       EXIT-PAR.

           STOP RUN RETURNING 0.

       END PROGRAM MAIN.



      * B"H.
