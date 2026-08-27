# Change Log

Format follows [Keep a Changelog](https://keepachangelog.com/).

2026/08/26

## [Unreleased]

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
  convention (`TIME-FUNCS.cbl` documented itself as `TIMES-FUNCS.cbl`;
  `RANDOM-NUMBER-GEN-FUNC.cbl` as `RANDOM-NUMBER-GEN.cbl`).
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
  the repository entirely. Now holds five test programs -
  `TEST-TIMES-FUNCS.cbl`, `TEST-PSSWRD-GEN-FUNC.cbl`,
  `TEST-ONE-TIME-CODE.cbl`, `TEST-RANDOM-NUMBER-GEN.cbl`, and
  `TEST-SECURE-RANDOM-1-78.cbl` - each rebuilt and rerun against the
  real multi-folder layout, not just in isolation. Setting this up
  is what surfaced the `TEST-PSSWRD-GEN-FUNC.cbl` field-size bug
  listed above; it had been silently drifting from the function it
  was meant to verify. See README.md's "Project Layout" and "Building"
  sections for what's in this folder and the exact commands to run
  each test.
- Project-specific `.gitignore`, `README.md`, and `LICENSE` [all
  previously empty placeholders]. Work was begun on the MAIN.cbl COBOL file
  [which shall be the master COBOL file], SRC/ subfolder.
