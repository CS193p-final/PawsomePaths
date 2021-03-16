//
//  FBButton.swift
//  Hex
//
//  Created by Duong Pham on 3/16/21.
//

import SwiftUI
import Firebase
import FBSDKLoginKit

struct FBButton: View {
    @AppStorage("logged") var logged = false
    @AppStorage("email") var email = ""
    @State var loginManager = LoginManager()
    
    var body: some View {
        Button {
            if logged {
                loginManager.logOut()
                email = ""
                logged = false
            }
            else {
                loginManager.logIn(permissions: ["email"], from: nil) { (result, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                        return
                    }
                    if AccessToken.current != nil {
                        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                        Auth.auth().signIn(with: credential) { (res, error) in
                            if error != nil {
                                print((error?.localizedDescription)!)
                                return
                            }
                            print("FB login success")
                            logged = true
                        }
                    }
                    let request = GraphRequest(graphPath: "me", parameters: ["fields": "email"])
                    request.start { (_, res, _) in
                        guard let profileData = res as? [String: Any] else { return }
                        email = profileData["email"] as! String
                    }
                    
                }
            }
        } label: {
            Text(logged ? "Log out" : "Connect with FB")
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.vertical, 10)
                .padding(.horizontal, 35)
                .background(Color.blue)
                .clipShape(Capsule())
        }

    }
}
