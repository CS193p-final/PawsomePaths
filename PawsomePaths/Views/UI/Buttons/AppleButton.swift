//
//  AppleButton.swift
//  PawsomePaths
//
//  Created by Duong Pham on 5/5/21.
//
import SwiftUI
import CryptoKit
import FirebaseAuth
import AuthenticationServices

struct AppleButton: View {
   
    @AppStorage("anonymousUID") var anonymousUID = ""
    @AppStorage("UID") var uid = ""
    @AppStorage("logged") var logged = false
    @AppStorage("email") var email = ""
    @AppStorage("firstName") var firstName = ""
    @State var currentNonce:String?

    var width: CGFloat
    var height: CGFloat
    var isPad = UIDevice.current.userInterfaceIdiom == .pad

    //Hashing function using CryptoKit
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
        }.joined()

        return hashString
    }
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
    
    var body: some View {
        let padWidth = width / 4
        let phoneWidth = width / 1.7
        let padHeight = height / 18
        let phoneHeight = height / 12
        
        SignInWithAppleButton { request in
            let nonce = randomNonceString()
            currentNonce = nonce
            request.requestedScopes = [.fullName, .email]
            request.nonce = sha256(nonce)
        } onCompletion: { result in
            switch result {
            case .success(let authResults):
                switch authResults.credential {
                case let appleIDCredential as ASAuthorizationAppleIDCredential:
                    guard let nonce = currentNonce else {
                        fatalError("Invalid state: A login callback was received, but no login request was sent.")
                    }
                    guard let appleIDToken = appleIDCredential.identityToken else {
                        fatalError("Invalid state: A login callback was received, but no login request was sent.")
                    }
                    guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                        print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                        return
                    }
                    let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString,rawNonce: nonce)
                    Auth.auth().signIn(with: credential) { (authResult, error) in
                        if (error != nil) {
                            // Error. If error.code == .MissingOrInvalidNonce, make sure
                            // you're sending the SHA256-hashed nonce as a hex string with
                            // your request to Apple.
                            print(error?.localizedDescription as Any)
                            return
                        }
                        print("signed in")
                        
                        // Update player's name the first time they log in using apple.
                        if let fullName = appleIDCredential.fullName {
                            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                            changeRequest?.displayName = fullName.givenName
                            changeRequest?.commitChanges { (error) in
                                if error != nil {
                                    print("Failed to update player's name")
                                }
                            }
                        }
                        print(Auth.auth().currentUser?.displayName)
                        logged = true
                        if let name = Auth.auth().currentUser?.displayName {
                            firstName = name
                        }
                        
                    }
                    print("\(String(describing: Auth.auth().currentUser?.uid))")
                default:
                    break
                }
            default:
                break
            }
        }
        .signInWithAppleButtonStyle(.white)
        .frame(width: isPad ? padWidth : phoneWidth, height: isPad ? padHeight : phoneHeight, alignment: .center)
    }

}
