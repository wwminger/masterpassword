package main

import (
	"fmt"
	"strconv"

	// _ "aes"

	"github.com/xianghuzhao/kdfcrypt"
)
import "C"

//form https://github.com/sethvargo/go-password/blob/main/password/generate.go
const (
	// LowerLetters is the list of lowercase letters.
	LowerLetters = "abcdefghijklmnopqrstuvwxyz"

	// UpperLetters is the list of uppercase letters.
	UpperLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

	// Digits is the list of permitted digits.
	Digits = "0123456789"

	// Symbols is the list of symbols.
	Symbols = "~!@#$%^&*()_+`-={}|[]\\:\"<>?,./"
	//10 位的密码模板
	MulitTemplate = "LLDUSULDSD"
)

var verbose bool = false
var TemplateChars = map[byte]string{
	'L': LowerLetters,
	'U': UpperLetters,
	'D': Digits,
	'S': Symbols,
}

func main() {
	// encoded, _ := kdfcrypt.Encode("password", &kdfcrypt.Option{
	// 	Algorithm:        "argon2id",
	// 	Param:            "m=65536,t=1,p=4",
	// 	RandomSaltLength: 16,
	// 	HashLength:       32,
	// })

	// // $argon2id$v=19,m=65536,t=1,p=4$mD+rvcR+6nuAV6MJFOmDjw$IqfwTPk9RMGeOv4pCE1QiURuSoi655GUVjcQAk81eXM
	// if verbose fmt.Println(encoded)

	// match, _ := kdfcrypt.Verify("password", encoded)
	// fmt.Println(match) // true

	// var (
	// 	username string = "domy"
	// 	password string = "keyi"
	// 	webname  string = "do"
	// )
	// UserKey, _ := userkey(username, password)

	// SiteKey, _ := sitekey(webname, username, 1)

	// _ = sitepw(UserKey, SiteKey)
}

// 使用*C.char 代替string
////export generate
// func generate(username, password, webname string) string {
// 	UserKey, _ := userkey(username, password)

// 	SiteKey, _ := sitekey(webname, username, 1)

// 	SitePW := sitepw(UserKey, SiteKey)
// 	return SitePW
// }

//export generate
func generate(username, password, webname *C.char) *C.char {
	UserKey, _ := userkey(C.GoString(username), C.GoString(password))

	SiteKey, _ := sitekey(C.GoString(webname), C.GoString(username), 1)

	SitePW := sitepw(UserKey, SiteKey)
	return C.CString(SitePW)
}

func userkey(username string, password string) (UserKey []byte, err error) {

	kdf, err := kdfcrypt.CreateKDF("argon2id", "m=4096,t=1,p=1")
	if err != nil {
		return nil, err
	}
	salt := username
	UserKey, err = kdf.Derive([]byte(password), []byte(salt), 32)
	if verbose {
		fmt.Println(UserKey)
	} // true
	return
}
func sitekey(webname string, username string, count int) (SiteKey []byte, err error) {

	kdf, err := kdfcrypt.CreateKDF("argon2id", "m=4096,t=1,p=1")
	if err != nil {
		return nil, err
	}
	d := strconv.Itoa(count)
	salt := []byte(username + d)
	SiteKey, err = kdf.Derive([]byte(webname), salt, 32)
	if verbose {
		fmt.Println(SiteKey) // true
	}
	return
}

// 根据模板文件 将aeskey生成密码
func sitepw(SiteKey []byte, UserKey []byte) string {
	SitePW := make([]byte, len(MulitTemplate))
	encrypted := AesEncryptCBC(SiteKey, UserKey)
	for i, c := range MulitTemplate {
		p := TemplateChars[byte(c)]
		SitePW[i] = p[int(encrypted[i+1])%len(p)]
	}
	if verbose {
		fmt.Println(string(SitePW))
	} // true

	return string(SitePW)
}
