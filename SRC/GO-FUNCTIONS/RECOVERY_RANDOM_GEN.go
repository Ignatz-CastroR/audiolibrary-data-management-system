package main
import "C"
import ("crypto/rand"; "math/big")
// See SECURE_RANDOM_NUMBER_GEN.go for the full explanation, since we have here the
// same primitive, renamed only because cobc's [the GNU COBOL compiler] own module base-name
// length limit rejected a longer, more descriptive name. The same observations made in SECURE_RANDOM_NUMBER_GEN.go
// apply here. Notice that here the final closed range of returned stochastic integers is [1, 45].

//export RECOVERY_RANDOM_GEN
func RECOVERY_RANDOM_GEN() C.int {
	n, err := rand.Int(rand.Reader, big.NewInt(45))
	if err != nil {
		return -1 
		}
	return C.int(n.Int64() + 1)
}
func main() {}
