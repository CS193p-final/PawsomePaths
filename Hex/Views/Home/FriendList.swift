//
//  FriendList.swift
//  Hex
//
//  Created by Duong Pham on 4/2/21.
//

import SwiftUI
import Firebase

struct Friend: Identifiable {
    var id: UUID = UUID()
    var name: String
    var requestSent = false
}

struct FriendList: View {
    @EnvironmentObject var viewRouter: ViewRouter

    var databaseRef: DatabaseReference! = Database.database().reference()

    @State var friends: [Friend] = []
    
    var body: some View {
        VStack {
            Button (action: {
                viewRouter.currentScreen = .welcome
            }, label: {
                Text("Back")
            })
            
            ScrollView {
                ForEach(friends) { friend in
                    HStack {
                        Image(systemName: "person.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                            .clipShape(Circle())
                            .frame(width: 80, height: 80)
                        VStack(alignment: .leading, spacing: 10) {
                            Text(friend.name)
                            Button(action: {
                                sendRequest(friend)
                            }, label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .frame(height: 35)
                                        .foregroundColor(.blue)
                                    Text(friend.requestSent ? "Sent" : "Challenge")
                                        .font(.system(size: 13))
                                        .foregroundColor(.white)
                                }
                            })
                            Spacer()
                        }
                    }
                }
            }
        
        }
        .onAppear {
            if let currentUser = Auth.auth().currentUser {
                databaseRef.child("users/\(currentUser.uid)/friends").getData { (error, snapshot) in
                    if let error = error {
                        print("Error getting user's friends: \(error)")
                        return
                    }
                    if !snapshot.exists() {
                        print("Snapshot is empty")
                        return
                    }
                    let friendList = snapshot.value as! [String: String]
                    
                    for friend in friendList.values {
                        friends.append(Friend(name: friend))
                    }
                }
            }
            
        }

    }
    
    private func sendRequest(_ friend: Friend) {
        guard let id = friends.firstIndex(matching: friend) else { return }
        friends[id].requestSent = true
    }
}

struct FriendList_Previews: PreviewProvider {
    static var previews: some View {
        FriendList()
    }
}
