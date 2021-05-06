//
//  LogoutButton.swift
//  PawsomePaths
//
//  Created by Duong Pham on 5/5/21.
//

import SwiftUI
import Combine
import Firebase
import FBSDKLoginKit

struct LogoutButton: View {
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
            try! Auth.auth().signOut()
            email = ""
            firstName = ""
            logged = false
            Auth.auth().signInAnonymously { (result, error) in
                anonymousUID = Auth.auth().currentUser!.uid
                uid = anonymousUID
            }
            viewRouter.currentScreen = .welcome
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
                    //Image("fb").scaleEffect(0.1).frame(width: 30, height: 50)
                    Text("Sign out").fontWeight(.medium)
                        .foregroundColor(.blue)
                }
            )
            .frame(width: isPad ? padWidth : phoneWidth, height: isPad ? padHeight : phoneHeight, alignment: .center)
        }

    }
}
