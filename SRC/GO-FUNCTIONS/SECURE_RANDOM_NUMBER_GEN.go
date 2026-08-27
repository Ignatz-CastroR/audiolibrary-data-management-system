package main

import "C"
import (
	"crypto/rand"
	"math/big"
)

// This function returns a random integer in the closed range [1, 78], by using its host operating system's own
// cryptographically secure entropy source [BCryptGenRandom on Windows, for instance]. This has the advantage of not
// depending on clock time stamps naïve calculations and/or naïve modulo based insecure algorithms [which are relegated
// for non-security-critical operations]. Notice that while the second parameter fed to the "rand.Int()" function is
// indeed "big.NewInt(78) [with this highest value called 'N' from now on], this function works with 0 as the first
// digit of its interval of possible returned random integers, meaning that the returned random integers actually are
// in the closed interval [0, N -1] [in our particular case, meaning this function returns random integer values that range from
// 0 to 77, while 78 is the highest possible random integer value needed]. For this reason, only after the random
// integer has been generated, 1 is added to the result, afterwards, effectively shifting the return range to the
// closed range [1, 78] as needed. Notice that since the 1 is added after the stochastic generating process, not
// before it, no bias is introduced into the underlying draw of the whole random process.

// It is extremely important to highlight the fact that data equivalence and transference between a COBOL and a Go program,
// and viceversa, is very delicate and complex. Thus, it is understandable that in order to receive the random integer
// returned by this Go function into a COBOL program, a field of PIC S9(3) COMP-5 is utilized as the matching receiving field.


//export SECURE_RANDOM_NUMBER_GEN
func SECURE_RANDOM_NUMBER_GEN() C.int {
	n, err := rand.Int(rand.Reader, big.NewInt(78))
	if err != nil {
		return -1
	}
	return C.int(n.Int64() + 1)
}

func main() {}

//B"H.
