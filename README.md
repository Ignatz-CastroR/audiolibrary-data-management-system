# Audio Library Data Management System

A COBOL-based catalog system built to migrate a 20-year personal music
collection out of a pile of inconsistent Excel spreadsheets and into a
properly structured, secure SQLite database, with an ongoing COBOL
application for adding and managing records afterward.

## Why COBOL

This project is deliberately COBOL-first. The goal isn't nostalgia [far from
it]; it's demonstrating that COBOL fundamentals [file handling, calling
conventions, LINKAGE SECTION design, indexed-file architecture, and much more]
can be combined with modern engineering practices [automated testing,
cryptographically sound randomness, and clean interop with a modern language
where COBOL genuinely has no native answer of its own], and used in tandem
with modern programming languages to produce industry-level, useful,
non-trivial applications.

## Where COBOL needs help, and how it gets it

GnuCOBOL, the compiler this project uses, has no built-in cryptographically
secure random number generator, no password hashing, and no simple and
direct SQL database driver access, among other things. The same is true
of every COBOL implementation, since none of this was ever part of any
COBOL standard. Rather than risking a flawed, hand-rolled reproduction of
any of these, this project bridges to small, focused Go functions for
exactly the pieces of functionality COBOL can't do on its own, for
instance, crypto/rand for anything security-relevant, and [planned] a
SQLite driver for the database layer. Everything else stays pure COBOL.

## Project layout

    SRC/
      MAIN.cbl              Entry point [currently a placeholder - see
                            DOCS/ARCHITECTURE-DECISIONS.md for the
                            planned login/menu flow]
      COBOL-FUNCTIONS/      Standalone, independently-tested utility
                            functions [time arithmetic, secure password
                            and recovery-code generation]
      COBOL-MODULES/        Larger interactive modules [login, settings,
                            menus]; not yet built
      COPYBOOKS/            Shared record layouts, included via COPY
      TESTS/                Test programs proving each function in
                            COBOL-FUNCTIONS/ actually works: built
                            and run before every change is trusted
      GO-FUNCTIONS/         Go bridges for anything COBOL can't do
                            natively
      DAT-FILES/            Runtime data [configuration files,
                            indexed files, the SQLite
                            database]; never committed; see .gitignore

## Building

Requires GnuCOBOL [cobc] and Go, both compiled ahead of time on a machine
with internet access. The resulting binaries need no internet and no
installed compiler on the machine they run on.

Important: files that use a copybook from COPYBOOKS/ need the -I
flag, since cobc only searches the same directory as the source file
by default. This applies whether you're building a function on its
own or a test alongside it: both sides need the flag if both use
the copybook.

Examples:

    cobc -c SRC/COBOL-FUNCTIONS/TIME-FUNCS.cbl -I SRC/COPYBOOKS
    cobc -x SRC/TESTS/TEST-TIMES-FUNCS.cbl SRC/COBOL-FUNCTIONS/TIME-FUNCS.cbl -I SRC/COPYBOOKS -o TEST-TIMES-FUNCS

Go functions build as C-shared libraries and link against the COBOL side with -fstatic-call.

Example:

    go build -buildmode=c-shared -o SECURE_RANDOM_NUMBER_GEN.dll SRC/GO-FUNCTIONS/SECURE_RANDOM_NUMBER_GEN.go
    cobc -x -fstatic-call SRC/TESTS/TEST-PSSWRD-GEN-FUNC.cbl SRC/COBOL-FUNCTIONS/PSSWRD-GEN-FUNC.cbl SECURE_RANDOM_NUMBER_GEN.dll -o TEST-PSSWRD-GEN-FUNC

Some functions call the Go bridge by a name stored in a variable
rather than a literal, which means -fstatic-call can't resolve it at
link time: it falls back to GnuCOBOL's own runtime module search
instead. If a compiled test can't find its .dll at runtime, set
COB_LIBRARY_PATH to the folder holding it before running.

Example:

    set COB_LIBRARY_PATH=SRC\GO-FUNCTIONS
    TEST-PSSWRD-GEN-FUNC.exe

Running each test in SRC/TESTS/ against its corresponding function
is how every function in this repository is verified before being
considered done. See CHANGE-LOG.md for what's been caught this way.

## Status

Actively in development. Part of the utility layer [time arithmetic, secure
password generation, one-time recovery codes, and e-mail-based password
recovery] is already built and has dedicated test coverage; the e-mail
recovery functionality has been verified end-to-end against real Gmail
and Yahoo accounts. The interactive login/menu system and the
Excel-to-SQLite migration pipeline are designed [see DOCS/] but have not been
implemented yet.

## License

See LICENSE.

B"H.