//
//  WelcomeView.swift
//  Hex
//
//  Created by Giang Nguyenn on 2/16/21.
//

import SwiftUI
import FBSDKLoginKit
import FirebaseAuth

struct WelcomeView: View {
    @State private var twoPlayerGameView = false
    @State private var singlePlayerGameView = false
    @State private var onlineGameView = false
    @State private var howToPlayView = false
    
    var body: some View {
        if (twoPlayerGameView) {
            GameView(hexGame: TwoPlayersGame(name: "twoPlayer"))
        } else if (singlePlayerGameView) {
            GameView(hexGame: SinglePlayerGame(name: "singlePlayer"))
        } else if (onlineGameView) {
            OnlineGameView(hexGame: OnlineGame())
        }
        else if (howToPlayView) {
            HowToPlayView(soundOn: true)
        }
        else {
            Button {
                twoPlayerGameView = true
                playSound("MouseClick", type: "mp3", soundOn: true)
            } label: {
                RoundedRectangle(cornerRadius: 10).opacity(0.3)
                    .frame(width: 250, height: 75, alignment: .center)
                    .overlay(Text("2 Players"))
                    .font(Font.custom("KronaOne-Regular", size: 20))
                    .foregroundColor(Color(red: 0.1758, green: 0.515625, blue: 0.53901, opacity: 1))
            }
            
            Button {
                playSound("MouseClick", type: "mp3", soundOn: true)
                singlePlayerGameView = true
            } label: {
                RoundedRectangle(cornerRadius: 10).opacity(0.3)
                    .frame(width: 250, height: 75, alignment: .center)
                    .overlay(Text("Single Player"))
                    .font(Font.custom("KronaOne-Regular", size: 20))
                    .foregroundColor(Color(red: 0.1758, green: 0.515625, blue: 0.53901, opacity: 1))
            }
            
            Button {
                playSound("MouseClick", type: "mp3", soundOn: true)
                onlineGameView = true
            } label: {
                RoundedRectangle(cornerRadius: 10).opacity(0.3)
                    .frame(width: 250, height: 75, alignment: .center)
                    .overlay(Text("Play Online"))
                    .font(Font.custom("KronaOne-Regular", size: 20))
                    .foregroundColor(Color(red: 0.1758, green: 0.515625, blue: 0.53901, opacity: 1))
            }
            
            Button {
                playSound("MouseClick", type: "mp3", soundOn: true)
                howToPlayView = true
            } label: {
                RoundedRectangle(cornerRadius: 10).opacity(0.3)
                    .frame(width: 250, height: 75, alignment: .center)
                    .overlay(Text("How To Play"))
                    .font(Font.custom("KronaOne-Regular", size: 20))
                    .foregroundColor(Color(red: 0.1758, green: 0.515625, blue: 0.53901, opacity: 1))
            }
            
            login()
                .frame(width: 250, height: 75, alignment: .center)
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}

struct login: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        return login.Coordinator()
    }
    
    func makeUIView(context: Context) -> FBLoginButton {
        let button = FBLoginButton()
        button.delegate = context.coordinator
        button.permissions = ["email"]
        return button
    }
    
    func updateUIView(_ uiView: FBLoginButton, context: Context) {
        
    }
    
    class Coordinator: NSObject, LoginButtonDelegate {
        
        func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
            if error != nil {
                print("Error 1: ")
                print((error?.localizedDescription)!)
                return
            }
            
            if AccessToken.current != nil {
                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                print(credential)
                print(AccessToken.current!.tokenString)
                Auth.auth().signIn(with: credential) { (res, error) in
                    if error != nil {
                        print("Error 2: ")
                        print((error?.localizedDescription)!)
                        return
                    }
                    else {
                        print("FB login success")
                    }
                }
                
                
            }
        }
        
        func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
            try! Auth.auth().signOut()
        }
        
    }

    
}
