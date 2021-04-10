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
    var image: UIImage?
    var requestSent = false
}

struct FriendList: View {
    @EnvironmentObject var viewRouter: ViewRouter

    var databaseRef: DatabaseReference! = Database.database().reference()
    var storageRef = Storage.storage().reference()
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
                        Group {
                            if let uiImage = friend.image {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipped()
                                    .clipShape(Circle())
                                    .frame(width: 80, height: 80)
                            } else {
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipped()
                                    .clipShape(Circle())
                                    .frame(width: 80, height: 80)
                            }
                        }
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
                    
                    for (fbID, name) in friendList {
                        print(fbID, name)
                        databaseRef.child("facebook_users/\(fbID)").getData { (error, snapshot) in
                            guard let friendID = snapshot.value as? String else {
                                friends.append(Friend(name: name, image: nil))
                                return
                            }
                            storageRef.child("users/\(friendID)/avatar.png").getData(maxSize: 1024*1024) { (data, error) in
                                if let error = error {
                                    print("Can't load profile pic. Error = \(error.localizedDescription)\nUsing default image")
                                    friends.append(Friend(name: name, image: nil))
                                    return
                                }
                                friends.append(Friend(name: name, image: UIImage(data: data!)))
                            }
                        }
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
