package main

import "C"

import (
	"errors"
	"fmt"
	"net"
	"net/mail"
	"net/smtp"
	"net/textproto"
	"strings"
	"time"
)

// Fixed widths matching the COBOL LINKAGE SECTION fields this function
// is called with. COBOL passes fixed-length, space-padded buffers
// with no null terminator at all, so these exact widths/string-lengths [not a scan
// for a null byte, which is what C.GoString would do] are what tell
// Go where each field actually ends. Using C.GoString here instead of
// C.GoStringN would risk reading past the real content into whatever
// memory happens to follow it.

// "emailFieldWidth" and "smtpUserWidth" both match the 60 characters
// used for an e-mail address field elsewhere in this project [see
// LS-EMAIL-ADDRESS in CONFIG-INFO-MOD.cbl/MAIN.cbl], since both are
// themselves e-mail addresses. There is no separate from-address
// width at all: the sending account is used as its own from-address,
// since every provider in "knownProviders" requires the two to match
// for a personal account anyways. "smtpPasswordWidth" is sized well
// beyond any real app password length seen from Google, Yahoo,
// Microsoft, or Apple [all 16 characters or fewer] specifically to
// avoid the kind of undersized-field truncation this project has
// already found and fixed more than once before. There is no host or
// port width here at all either: see "knownProviders" infra.

const (
	emailFieldWidth    = 60 // This matches the COBOL program sending field of PIC X(60).
	passwordFieldWidth = 15 // This matches the COBOL program sending field of PIC X(15).
	smtpUserWidth      = 60
	smtpPasswordWidth  = 30
)

// Status codes ARE returned to the calling COBOL program via RETURNING.
// 0 MEANS success; every failure path returns a distinct negative value
// so the calling COBOL program can tell them apart.

const (
	statusSuccess              C.int = 0
	statusInvalidEmail         C.int = -1
	statusMissingConfig        C.int = -2
	statusConnectionFailed     C.int = -3
	statusServerRejected       C.int = -4
	statusSendFailed           C.int = -5
	statusNoInternetConnection C.int = -6
	statusUnknownProvider      C.int = -7
)

// "smtpServer" is the host and port a recognized provider expects.

type smtpServer struct {
	host string
	port string
}

// "knownProviders" maps an email domain [lowercase, no leading "@"] to
// the correct outgoing mail server for that provider. Settings below
// were verified against current documentation the same day this
// function was coded, not assumed.
// It is worth mentioning that policies and
// requirements at every one of these providers have genuinely changed
// in recent years [all four now require a provider-specific "app
// password" rather than a normal account password, for instance]; thus,
// this list most likely shall need active mainteninance, rather than being trusted indefinitely.

var knownProviders = map[string]smtpServer{
	"gmail.com":      {host: "smtp.gmail.com", port: "587"},

	"yahoo.com":      {host: "smtp.mail.yahoo.com", port: "587"},
	"ymail.com":      {host: "smtp.mail.yahoo.com", port: "587"},
	"rocketmail.com": {host: "smtp.mail.yahoo.com", port: "587"},

// Outlook.com, Hotmail, Live, and MSN are all the same consumer
// service on the same backend nowadays.
// VITAL NOTE: this is deliberately NOT the same server a paid Microsoft 365 business account uses.

	"outlook.com":    {host: "smtp-mail.outlook.com", port: "587"},
	"hotmail.com":    {host: "smtp-mail.outlook.com", port: "587"},
	"live.com":       {host: "smtp-mail.outlook.com", port: "587"},
	"msn.com":        {host: "smtp-mail.outlook.com", port: "587"},

// icloud.com, me.com, and mac.com are all the same Apple Mail backend.

	"icloud.com":     {host: "smtp.mail.me.com", port: "587"},
	"me.com":         {host: "smtp.mail.me.com", port: "587"},
	"mac.com":        {host: "smtp.mail.me.com", port: "587"},
}

// The "lookupSMTPServer" function extracts the domain from an email address and
// looks it up in "knownProviders". The match is case-insensitive, since
// "X-DOMAIN.com" and "x-domain.com" are the same domain to every real mail
// system even, though they are different strings to a plain Go map.

func lookupSMTPServer(email string) (smtpServer, bool) {
	at := strings.LastIndex(email, "@")
	if at == -1 {
		return smtpServer{}, false
	}
	domain := strings.ToLower(email[at+1:])
	server, found := knownProviders[domain]
	return server, found
}

// "internetCheckTarget" is a well-known, extremely high-uptime host used
// purely to test whether there is a running internet connection on the host computer at all.
// This is not related directly in any way to the actual mail server process.
// A hostname is used rather than a raw IP
// address so this check also exercises DNS resolution, which the real
// SMTP connection will need to succeed anyways.

const internetCheckTarget = "google.com:443"
const internetCheckTimeout = 3 * time.Second

// The "hasInternetConnection" function makes a best-effort check for basic network
// reachability by attempting a PLAIN TCP check against a host that
// is VIRTUALLY always up.
// This is a sanity check, not a guarantee:
// a captive portal [common on public WiFi] can accept this connection
// without providing real internet access, and conditions can change
// in the moments between this check and the actual send attempt.
// This function's real, practical purpose here is to fail fast and clearly on a
// machine with no internet at all, rather than waiting through a full
// SMTP connection timeout to discover the same thing.

func hasInternetConnection() bool {
	conn, err := net.DialTimeout("tcp", internetCheckTarget, internetCheckTimeout)
	if err != nil {
		return false
	}
	conn.Close()
	return true
}

// "HAS_INTERNET_CONNECTION" exposes the same check above as its own,
// separately callable step. This is extremely useful for a caller program that wants to report
// connectivity status on its own, before deciding whether to attempt
// anything else, rather than only finding out indirectly through
// "SEND_RECOVERY_EMAIL"'s status code. It deliberately calls the exact
// same internal helper "SEND_RECOVERY_EMAIL" itself uses, rather than a
// separate copy of the same logic, SO THE 2 CAN NEVER DRIFT APART.
// Returns 1 if a connection was made, 0 otherwise.

//export HAS_INTERNET_CONNECTION
func HAS_INTERNET_CONNECTION() C.int {
	if hasInternetConnection() {
		return 1
	}
	return 0
}

// "buildMessage" assembles a plain, complete RFC 5322 email: headers
// and body together, ready to hand to "smtp.SendMail" as raw bytes.
// No action is needed: this recovery password is useless without also knowing
// the account's registered email address.
// NOTE: since the finished COBOL application will work both in English and
// Spanish, an expansion of this function shall be necessary later on
// in order to deliver the message either in English or in Spanish,
// according the language settings chosen by the user in the
// COBOL application.

func buildMessage(from, to, recoveryPassword string) []byte {
	headers := fmt.Sprintf(
		"From: %s\r\nTo: %s\r\nSubject: Password Recovery - MUZIKA KALIMERA\r\n"+
			"MIME-Version: 1.0\r\nContent-Type: text/plain; charset=\"utf-8\"\r\n\r\n",
		from, to,
	)

	body := "A password recovery was requested for your MUZIKA KALIMERA " +
		"account.\r\n\r\n" +
		"Your one-time recovery password is:\r\n\r\n    " + recoveryPassword + "\r\n\r\n" +
		"Enter this password in the program, then choose a new " +
		"password right away. This recovery password only works " +
		"once.\r\n\r\n" +
		"If you did not request this, no action is needed.\r\n"

	return []byte(headers + body)
}

// SEND_RECOVERY_EMAIL is the function the calling COBOL program calls. It first confirms
// the network is reachable at all, then validates the recipient's
// email address using Go's own standards-based parser rather than a
// hand-rolled check, then automatically determines the correct
// outgoing mail server from the sending account's own domain; no
// host or port is accepted as a parameter at all, so the person
// using the caller program never needs to know or enter a raw SMTP hostname.
// The sending account is also used as its own from-address, rather
// than accepting a separate one: real, serious e-mail providers require the 2 to
// match for a personal account.

//export SEND_RECOVERY_EMAIL
func SEND_RECOVERY_EMAIL(
	emailPtr *C.char, passwordPtr *C.char,
	smtpUserPtr *C.char, smtpPasswordPtr *C.char,
) C.int {
	if !hasInternetConnection() {
		return statusNoInternetConnection
	}

	email := strings.TrimSpace(C.GoStringN(emailPtr, C.int(emailFieldWidth)))
	recoveryPassword := strings.TrimSpace(C.GoStringN(passwordPtr, C.int(passwordFieldWidth)))

	if _, err := mail.ParseAddress(email); err != nil {
		return statusInvalidEmail
	}

	user := strings.TrimSpace(C.GoStringN(smtpUserPtr, C.int(smtpUserWidth)))
	pass := strings.TrimSpace(C.GoStringN(smtpPasswordPtr, C.int(smtpPasswordWidth)))

	if user == "" || pass == "" {
		return statusMissingConfig
	}

	server, found := lookupSMTPServer(user)
	if !found {
		return statusUnknownProvider
	}

	auth := smtp.PlainAuth("", user, pass, server.host)
	message := buildMessage(user, email, recoveryPassword)
	addr := server.host + ":" + server.port

	err := smtp.SendMail(addr, auth, user, []string{email}, message)
	if err != nil {
		var opErr *net.OpError
		var protoErr *textproto.Error
		switch {
		case errors.As(err, &opErr):
			// Could not even reach the server [DNS failure, refused connection, network unreachable, etc.]
			return statusConnectionFailed
		case errors.As(err, &protoErr):
			// The server was reached and responded, but explicitly
			// rejected the request [bad credentials, unknown
			// recipient, policy rejection] with a real SMTP status
			// code attached to "protoErr.Code", if ever needed for
			// logging.
			return statusServerRejected
		default:
			// Anything else: authentication mechanism failures and
			// similar don't expose a distinct type from "net/smtp",
			// so they fall here in an honest and transparent way, rather than being
			// misclassified as one of the two cases above.
			return statusSendFailed
		}
	}

	return statusSuccess
}

func main() {}

// B"H.