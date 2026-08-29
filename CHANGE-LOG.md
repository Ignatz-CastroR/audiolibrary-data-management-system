# Change Log

Format follows [Keep a Changelog][https://keepachangelog.com/].

## [2026-08-29]

### Fixed
- Documentation-only pass across `SRC/`, prompted by an unrelated,
  outside COBOL/Go experiment that surfaced several stale references
  by comparison. Nothing in this entry touches program logic.
- `VALIDATE-EMAIL-FUNC.cbl` and three files in `SRC/TESTS/`
  []`TEST-ONE-TIME-CODE.cbl`, `TEST-VALIDATE-EMAIL.cbl`,
  `TEST-SEND-RECOVERY-EMAIL.cbl`] were missing the standard
  Author/Place/Purpose/Tectonics header every other source file in
  this repository carries. Added, matching the existing convention.
- `CONFIG-INFO-MOD.cbl`'s header had an empty `Purpose:` field left
  over from when the file was first scaffolded. Filled in to
  describe what the module actually does today.
- `ONE-TIME-CODE-FUNC.cbl`'s header claimed the recovery-code
  alphabet excludes the upper-case letter 'O' [to avoid confusion with
  the digit 0]. It did not; see the `[2026-08-29] [follow-up]` entry
  below, where the upper-case letter 'O' was actually pulled from the alphabet instead of
  just correcting the claim.
- `RECOVERY_RANDOM_GEN.go` pointed to a `SECURE_RANDOM_NUMBER_GEN_
  RECOVERY.go` that has never existed in this repository under that
  name; corrected both references to `SECURE_RANDOM_NUMBER_GEN.go`.
- `TIME-FUNCS.cbl` and `TEST-TIMES-FUNCS.cbl` both still carried a
  `-I ../COPYBOOKSTIMESTAMP.cpy` in their own header text: the
  copybook filename run together with the folder name, missing the
  separator, left over from when the `-I` flag was first documented
  [see 2026-08-26 below]. `-I` takes a folder, not a file; corrected
  both to `-I ../COPYBOOKS`. `TEST-TIMES-FUNCS.cbl`'s header also
  still called the tested file `TIMES-FUNCS.cbl` in two places;
  the same stale name the 2026-08-26 entry below already fixed
  elsewhere, just not here yet. Corrected to `TIME-FUNCS.cbl`.
- `TEST-RANDOM-NUMBER-GEN.cbl`'s header likewise still called the
  tested file `RANDOM-NUMBER-GEN.cbl` in its `Tectonics` line.
  Corrected to `RANDOM-NUMBER-GEN-FUNC.cbl`. NOTE: this file's actual
  `REPOSITORY`/`FUNCTION` calls had the same stale name, a real
  compile-time problem rather than a documentation one: see the
  `[2026-08-29] [follow-up]` entry below for that fix.
- `TEST-PSSWRD-GEN-FUNC.cbl` and `TEST-SECURE-RANDOM-1-78.cbl` both
  still pointed their `Tectonics` at a lower-case `secure_random.go`
  that was renamed to `SECURE_RANDOM_NUMBER_GEN.go` before either
  test file was written. Corrected both.
- `TIMESTAMP.cpy`'s header was dated `2016/08/25` [ten years off
  from every other file touched that same week]. Corrected to
  `2026/08/25`.
- `PSSWRD-GEN-FUNC.cbl`'s header misspelled "password" as "passwrord"
  and "password's" as "passwrods's". Corrected.
- A stray typo in `MAIN.cbl`'s English language-confirmation screen
  read "PRESS THW 'BACKSPACE' KEY"; corrected to "THE". User-facing
  text, not a header, but caught in the same pass.
- `ONE-TIME-CODE-FUNC.cbl`'s header still credited "NACHO" as
  author, the only file left using that byline instead of the
  formal one every other file in this repository settled on.
  Corrected for consistency.

## [2026-08-29] [follow-up]

### Changed
- `ONE-TIME-CODE-FUNC.cbl`'s recovery-code alphabet actually had the
  upper-case letter O pulled out this time [not just its header
  corrected; see the entry above], since it reads too much like the
  digit 0 for a code meant to be handwritten and retyped. The list is
  now 45 characters. Rebalanced the four length buckets in
  `PASSWRD-LENGTH-PAR` for the new range [11/11/11/12 draws per
  12/13/14/15-character length, instead of the old 12/12/12/10]:
  every code is still 12-15 characters, only the odds behind each
  length shifted slightly. `RECOVERY_RANDOM_GEN.go`'s range moved
  from `big.NewInt(46)` to `big.NewInt(45)` to match; its own comment
  updated accordingly. `TEST-ONE-TIME-CODE.cbl` needed no change; it
  checks the 12-15 length and internal-gap invariants, not the
  alphabet size directly.
- `SEND_RECOVERY_EMAIL.go`'s `emailFieldWidth` and `smtpUserWidth`
  widened from 45 to 60, to match `LS-EMAIL-ADDRESS` as declared in
  `CONFIG-INFO-MOD.cbl`/`MAIN.cbl` [`PIC X(60)`]. At a length of 45 characters, any address
  over 45 characters arriving from those modules would have been
  silently cut off at the Go boundary before ever reaching SMTP: the
  same class of undersized-field bug already caught once in this log
  [see `TEST-PSSWRD-GEN-FUNC.cbl`, 2026-08-26]. Updated the header
  comment's width explanation to match, and widened `WS-EMAIL`/
  `WS-SMTP-USER` from `PIC X(45)` to `PIC X(60)` in both
  `TEST-SEND-RECOVERY-EMAIL.cbl` and `TEST-SEND-RECOVERY-EMAIL-LOCAL.cbl`
  so the whole call chain agrees on one width.
- `TEST-RANDOM-NUMBER-GEN.cbl`'s `REPOSITORY` declared
  `FUNCTION RANDOM-NUMBER-GEN`, missing the `-FUNC` suffix the actual
  function is named; the same missing suffix was in the
  `PROCEDURE DIVISION`'s own `MOVE FUNCTION RANDOM-NUMBER-GEN` call.
  This would not have linked against `RANDOM-NUMBER-GEN-FUNC.cbl` as
  written. Corrected both to `RANDOM-NUMBER-GEN-FUNC`.
- Removed `SET ENVIRONMENT "COB_SCREEN_EXCEPTIONS" TO "1"` from both
  `MAIN.cbl` and `CONFIG-INFO-MOD.cbl`. An outside COBOL/Go
  experiment [see `CONFIG-INFO-MOD.cbl`'s own updated header]
  independently confirmed, on this same GnuCOBOL build, that this
  statement does not take effect at runtime regardless, that the
  setting only ever mattered for a single-field `ACCEPT` [neither
  program uses one: both drive their menus with `ACCEPT OMITTED`,
  which already reports arrow keys correctly on its own], and that no
  Go function can substitute for it either: nothing called from a
  COBOL program can run before `cob_init()`, which is what actually
  reads this setting on startup. A Go-based fix for this was
  therefore ruled out on purpose, not left unexplored;
  it would've been an authentic overkill. Left a comment
  in both files' `MAIN-PAR` explaining why, and pointing at the
  validated alternative [bypassing `ACCEPT` entirely via a raw-
  keyboard-reading Go bridge] for whichever screen in this project
  needs real typing and reliable arrow-key navigation together first.

## [2026-08-29] [VERIFY-PSSWRD-FUNC]

### Added
- `COBOL-FUNCTIONS/VERIFY-PSSWRD-FUNC.cbl`. Verifies a candidate
  password is 12-15 characters, contains at least one upper case
  letter, one lower case letter, one digit, and one special
  character from the closed 16-character set `!?.@-_:;=*+$&/%#`
  [the exact same specials `PSSWRD-GEN-FUNC`'s own 78-character
  alphabet draws from], and contains no character outside that same
  universe [which also rules out blank spaces on its own, since a
  space belongs to none of those categories]. Written as a
  `FUNCTION-ID`, the same convention every other file in this folder
  uses: call it with `FUNCTION VERIFY-PSSWRD-FUNC(WS-PSSWRD)`.
  Returns 1 for a valid password, 0 for an invalid one, matching
  `VALIDATE-EMAIL-FUNC`'s own polarity. Special-character membership
  is checked against `WS-SPECIAL-CHARS` itself via `INSPECT ...
  TALLYING ... FOR ALL`, rather than repeating the 16 character list
  a second time as a hard-coded chain of comparisons: one real
  point of definition, not two that have to be kept in sync by hand.
- `TESTS/TEST-VERIFY-PSSWRD-FUNC.cbl`. Eleven fixed cases [3 valid,
  8 invalid] covering both length boundaries, an all-blank input, a
  missing upper/lower/digit/special character each, an illegal
  character, and an embedded space.

## [2026-08-27]

### Added
- `GO-FUNCTIONS/SEND_RECOVERY_EMAIL.go`. Exports two Go functions:
`HAS_INTERNET_CONNECTION()`, which checks whether an active internet
connection is available on the machine running the COBOL application,
and `SEND_RECOVERY_EMAIL()`, which sends a one-time recovery password
to a user's registered e-mail address in case he/she forgets his/her
password. `SEND_RECOVERY_EMAIL()` takes four parameters: the
recipient's e-mail address, the one-time recovery password itself,
and the sending account's own e-mail address and app password [the
from-address is filled in automatically from the sending account, so
no separate field is needed for it]. The sending account's e-mail
and app password shall be read from a CONFIGURATION.dat file [with
data initially supplied by the user] within the COBOL application.
- `TESTS/TEST-SEND-RECOVERY-EMAIL.cbl`. A COBOL program that tests
`HAS_INTERNET_CONNECTION()` and `SEND_RECOVERY_EMAIL()` together.
Verified working end-to-end: recovery password e-mail messages were
successfully sent through both a Gmail and a Yahoo sending account,
in both cases landing outside spam.

## [2026-08-26]

### Fixed
- `RECOVERY_RANDOM_GEN.go` still generated numbers up to 48 after the
  one-time recovery code alphabet was trimmed to 46 characters,
  silently inserting a null byte into the code whenever 47 or 48 was
  drawn; invisible on screen, meaning a handwritten copy could be
  missing a character with no visible sign of it. Range corrected to
  match the 46-character alphabet.
- `TIME-FUNCS.cbl` did not compile in this repository's folder
  layout - `cobc` only searches a source file's own directory for a
  `COPY` target by default, and the copybook lives in the separate
  `COPYBOOKS/` subfolder. Documented the required `-I` flag in the source code file
  header and in the README.
- Two files' own build instructions referenced filenames that no
  longer existed after being renamed to fit the project's naming
  convention [`TIME-FUNCS.cbl` documented itself as `TIMES-FUNCS.cbl`;
  `RANDOM-NUMBER-GEN-FUNC.cbl` as `RANDOM-NUMBER-GEN.cbl`].
- `TEST-PSSWRD-GEN-FUNC.cbl` declared its receiving field as 12
  characters, but `PSSWRD-GEN-FUNC.cbl`'s actual password field had
  since been widened to 15 to support longer passwords. The
  oversized real result was silently truncated on every call,
  corrupting the displayed status code with a stray password
  character instead of catching the mismatch. Test field resized to
  match.

### Added
- `SRC/TESTS/`. Dedicated subfolder for the test programs that verify
  each function in `SRC/COBOL-FUNCTIONS/`, previously kept outside
  the repository entirely. Now holds five test programs, namely
  `TEST-TIMES-FUNCS.cbl`, `TEST-PSSWRD-GEN-FUNC.cbl`,
  `TEST-ONE-TIME-CODE.cbl`, `TEST-RANDOM-NUMBER-GEN.cbl`, and
  `TEST-SECURE-RANDOM-1-78.cbl`; each rebuilt and rerun against the
  real multi-folder layout, not just in isolation. Setting this up
  is what surfaced the `TEST-PSSWRD-GEN-FUNC.cbl` field-size bug
  listed above; it had been silently drifting from the function it
  was meant to verify. See README.md's "Project Layout" and "Building"
  sections for what's in this folder and the exact commands to run
  each test.
- Project-specific `.gitignore`, `README.md`, and `LICENSE` [all
  previously empty placeholders]. Work was begun on the MAIN.cbl COBOL
  file [which shall be the master COBOL file] in the SRC/ subfolder.

B"H.