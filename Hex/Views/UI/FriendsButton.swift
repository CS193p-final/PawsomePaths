//
//  FriendsButton.swift
//  Hex
//
//  Created by Giang Nguyenn on 4/26/21.
//

import SwiftUI

struct FriendsButton: View {
    var width: CGFloat
    var height: CGFloat
    var isPad = UIDevice.current.userInterfaceIdiom == .pad
    
    var body: some View {
        let padHeight: CGFloat = height / 18
        let phoneHeight: CGFloat = height / 12
        let padWidth: CGFloat = width / 5
        let phoneWidth: CGFloat = width / 2.3

        Button(action: {
            print("friend list")
            // TODO: Show friend list
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke()
                    .foregroundColor(.blue)
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.white)
            }
            .frame(width: isPad ? padWidth : phoneWidth, height: isPad ? padHeight : phoneHeight, alignment: .center)
            .overlay(
                HStack{
                    Image(systemName: "person.3").imageScale(.large)
                    Text("Friends").fontWeight(.medium)
                }
                .foregroundColor(.blue)
            )

        })
    }

}

//struct FriendsButton_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendsButton()
//    }
//}
