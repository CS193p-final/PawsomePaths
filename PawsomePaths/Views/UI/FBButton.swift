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
    
    var width: CGFloat
    var height: CGFloat
    var isPad = UIDevice.current.userInterfaceIdiom == .pad
    
    @AppStorage("anonymousUID") var anonymousUID = ""
    @AppStorage("UID") var uid = ""
    @AppStorage("logged") var logged = false
    @AppStorage("email") var email = ""
    @AppStorage("firstName") var firstName = ""
    @State var loginManager = LoginManager()
    
    var databaseRef: DatabaseReference! = Database.database().reference()
    var storageRef: StorageReference! = Storage.storage().reference()

    var fetchImageCancellable: AnyCancellable?
    
    var body: some View {
        let padWidth = width / 4
        let phoneWidth = width / 1.7
        let padHeight = height / 18
        let phoneHeight = height / 12
        Button {
            if logged {
                loginManager.logOut()
                try! Auth.auth().signOut()
                email = ""
                print("before = \(firstName)")
                firstName = ""
                print("after = \(firstName)")
                logged = false
                viewRouter.currentScreen = .welcome
                uid = anonymousUID
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
                            
                            if let currentFBUser = AccessToken.current {
                                databaseRef.child("facebook_users/\(currentFBUser.userID)").setValue(Auth.auth().currentUser?.uid)
                            }
                            
                            guard let firebaseUserID = Auth.auth().currentUser?.uid else { return; }

                            let request = GraphRequest(graphPath: "me", parameters: ["fields": "email, picture, first_name"])
                            request.start { (_, res, _) in
                                guard let profileData = res as? [String: Any] else { return }
                                
                                print("profile data = \(profileData)")
                                email = profileData["email"] as! String
                                firstName = profileData["first_name"] as! String
                                databaseRef.child("users/\(firebaseUserID)/name").setValue(firstName)
                                databaseRef.child("users/\(firebaseUserID)/email").setValue(email)
                                
                                // Get friend list
//                                if let friends = (profileData["friends"] as? [String: Any])?["data"] as? [[String:Any]] {
//                                    print("friends = \(friends)")
//                                    for friend in friends {
//                                        guard let friendID = friend["id"] else { continue }
//                                        guard let friendName = friend["name"] else { continue }
//                                        databaseRef.child("users/\(firebaseUserID)/friends/\(friendID)").setValue(friendName)
//                                    }
//                                }
                                
                                // The url is nested 3 layers deep into the result so it's pretty messy
                                // profileData.picture.data.url
                                if let imageURL = ((profileData["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                                    //Download image from imageURL
                                    do {
                                        let data = try Data(contentsOf: URL(string: imageURL)!)

                                        // Upload the file to the path "images/rivers.jpg"
                                        let metadata = StorageMetadata()
                                        metadata.contentType = "image/png"
                                        storageRef.child("users/\(firebaseUserID)/avatar.png").putData(data, metadata: metadata) { (metadata, error) in
                                            guard metadata != nil else {
                                                // Uh-oh, an error occurred!
                                                print("Uh-oh, an error occurred!")
                                                print(error.debugDescription)
                                                return
                                            }
                                            print("Uploaded")
                                        }
                                        
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
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.white)
            }
            .overlay(
                HStack {
                    Image("fb").scaleEffect(0.1).frame(width: 30, height: 50)
                    Text(logged ? "Sign out" : "Sign in").fontWeight(.medium)
                        .foregroundColor(.blue)
                }
            )
            .frame(width: isPad ? padWidth : phoneWidth, height: isPad ? padHeight : phoneHeight, alignment: .center)
        }

    }
}
