//
//  FriendList.swift
//  Hex
//
//  Created by Duong Pham on 4/2/21.
//

import SwiftUI

struct Friend: Identifiable {
    var id: UUID = UUID()
    var name: String
}

struct FriendList: View {
//    @State var activeTab = 2
    
    var friends: [Friend] = [
        Friend(name: "Duong"),
        Friend(name: "Linh"),
        Friend(name: "Tuan"),
        Friend(name: "Thien"),
    ]
    
    var body: some View {
//        TabView(selection: $activeTab) {
//            Text("Home").tabItem { Image(systemName: "list.bullet") }.tag(1)
//            Text("Friends").tabItem { Image(systemName: "person.2.fill") }.tag(2)
//        }
//        Text(friends[3].name)
        NavigationView {
            ScrollView {
                ForEach(friends, id: \.id) { friend in
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
                                print("challenge")
                            }, label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .frame(height: 35)
                                        .foregroundColor(.blue)
                                    Text("Challenge")
                                        .font(.system(size: 13))
                                        .foregroundColor(.white)
                                }
                            })
                            Spacer()
                        }
                    }
                }
            }.navigationTitle("Friends")
        }
    }
}

struct FriendList_Previews: PreviewProvider {
    static var previews: some View {
        FriendList()
    }
}
