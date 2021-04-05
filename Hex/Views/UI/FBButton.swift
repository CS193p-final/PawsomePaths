//
//  FBButton.swift
//  Hex
//
//  Created by Duong Pham on 3/16/21.
//

import SwiftUI
import Combine
import Firebase
import FBSDKLoginKit

struct FBButton: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    @AppStorage("anonymousUID") var anonymousUID = ""
    @AppStorage("UID") var uid = ""
    @AppStorage("logged") var logged = false
    @AppStorage("email") var email = ""
    @AppStorage("firstName") var firstName = ""
    @State var loginManager = LoginManager()
    
    private var fetchImageCancellable: AnyCancellable?
    
    var body: some View {
        Button {
            if logged {
                loginManager.logOut()
                try! Auth.auth().signOut()
                email = ""
                logged = false
                viewRouter.currentScreen = .welcome
                uid = anonymousUID
            }
            else {
                loginManager.logIn(permissions: ["email", "user_friends"], from: nil) { (result, error) in
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
                            let request = GraphRequest(graphPath: "me", parameters: ["fields": "email, picture, first_name, friends"])
                            request.start { (_, res, _) in
                                guard let profileData = res as? [String: Any] else { return }
                                
                                print("profile data = \(profileData)")
                                
                                email = profileData["email"] as! String
                                firstName = profileData["first_name"] as! String
                                // The url is nested 3 layers deep into the result so it's pretty messy
                                // profileData.picture.data.url
                                if let imageURL = ((profileData["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                                    //Download image from imageURL
                                    do {
                                        let data = try Data(contentsOf: URL(string: imageURL)!)
                                        let avatar = UIImage(data: data)
                                        // save avatar to application sandbox
                                        avatar?.saveToDisk(fileName: "avatar")
                                        logged = true
                                        uid = Auth.auth().currentUser!.uid
                                        viewRouter.currentScreen = .welcome
                                    } catch {
                                        print("Can't load image from path: \(imageURL)")
                                    }
                                }
                            }
                        }
                    }
                    
                }
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke()
                    .foregroundColor(.blue)
                    .frame(width: 190, height: 50, alignment: .center)
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.white)
                    .frame(width: 190, height: 50, alignment: .center)
                HStack {
                    Image("fb").scaleEffect(0.1).frame(width: 30, height: 50)
                    Text(logged ? "Log out" : "Connect with FB").fontWeight(.medium)
                        .foregroundColor(.blue)
                }
            }
        }

    }
}
