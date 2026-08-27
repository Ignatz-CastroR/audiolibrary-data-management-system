       IDENTIFICATION DIVISION.
       PROGRAM-ID. TEST-SEND-RECOVERY-EMAIL.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       01 WS-EMAIL                  PIC X(45).
       01 WS-RECOVERY-PASSWORD      PIC X(15) VALUE "AB3xQ7-KzM9-2Lp".
       01 WS-SMTP-USER              PIC X(45).
       01 WS-SMTP-PSWD              PIC X(30).
       01 WS-STATUS                 PIC S9(3) COMP-5.
       01 WS-CONNECTED              PIC S9(3) COMP-5.

       PROCEDURE DIVISION.

       MAIN-PAR.

           DISPLAY "=== Step 1: checking internet connection ==="
           DISPLAY SPACES
           CALL "HAS_INTERNET_CONNECTION" RETURNING WS-CONNECTED

           IF WS-CONNECTED = 1
               DISPLAY "Internet connection: available."
           ELSE
               DISPLAY "Internet connection: NOT available."
               DISPLAY "Stopping - nothing else to test without it."
               PERFORM EXIT-PAR
           END-IF
           DISPLAY SPACES

           DISPLAY "=== Step 2: recipient email address ==="
           DISPLAY SPACES
           DISPLAY "Email address: " WITH NO ADVANCING
           ACCEPT WS-EMAIL
           DISPLAY SPACES

           DISPLAY "=== Step 3: your sending account ==="
           DISPLAY SPACES
           DISPLAY "The Go function used in this part of this test
           DISPLAY "figures out the SMTP server, and "
           DISPLAY "your from-address, on its own from your email "
           DISPLAY "address - no host, port, or separate from-address "
           DISPLAY "needed. It only needs the account itself and the "
           DISPLAY "app password that account's provider generated "
           DISPLAY "for you [NEVER YOUR REAL ACCOUNT PASSWORD]."
           DISPLAY SPACES
           DISPLAY "Your full email address: " WITH NO ADVANCING
           ACCEPT WS-SMTP-USER
           DISPLAY "App password: " WITH NO ADVANCING
           ACCEPT WS-SMTP-PSWD
           DISPLAY SPACES

           DISPLAY "=== Step 4: attempting to send the email ==="
           DISPLAY SPACES
           CALL "SEND_RECOVERY_EMAIL" USING
               WS-EMAIL WS-RECOVERY-PASSWORD
               WS-SMTP-USER WS-SMTP-PSWD
               RETURNING WS-STATUS
           DISPLAY SPACES

           EVALUATE WS-STATUS
               WHEN 0
                   DISPLAY "SUCCESS: recovery email sent."
               WHEN -1
                   DISPLAY "FAILED: the recipient email is not valid."
               WHEN -2
                   DISPLAY "FAILED: username or password was left "
                   DISPLAY "blank."
               WHEN -3
                   DISPLAY "FAILED: could not connect to mail server."
               WHEN -4
                   DISPLAY "FAILED: mail server rejected the message."
               WHEN -5
                   DISPLAY "FAILED: the message could not be sent."
               WHEN -6
                   DISPLAY "FAILED: no internet connection."
               WHEN -7
                   DISPLAY "FAILED: email provider is not one this "
                   DISPLAY "Go function recognizes automatically."
               WHEN OTHER
                   DISPLAY "Unrecognized status code: " WS-STATUS
           END-EVALUATE

           ACCEPT OMITTED

           PERFORM EXIT-PAR.

       EXIT-PAR.

           STOP RUN.
