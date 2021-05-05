//
//  InviteButton.swift
//  Hex
//
//  Created by Duong Pham on 3/26/21.
//

import SwiftUI
import FirebaseDynamicLinks

struct InviteButton: View {
    @State var show = false
    @State var inviteURL: URL?
    var width: CGFloat
    var height: CGFloat
    var isPad = UIDevice.current.userInterfaceIdiom == .pad
    
    func createInviteLink() {
        // Create link
        let linkParameter = URL(string: "https://apps.apple.com/us/app/pawsome-paths/id1559984377")!
        
        guard let shareLink = DynamicLinkComponents(link: linkParameter, domainURIPrefix: "https://gdhex.page.link") else {
            // Couldn't reate FDL components
            return
        }
        
        if let myBundleId = Bundle.main.bundleIdentifier {
            shareLink.iOSParameters = DynamicLinkIOSParameters(bundleID: myBundleId)
        }
        shareLink.iOSParameters?.appStoreID = "1559984377"
        shareLink.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        shareLink.socialMetaTagParameters?.title = "Pawsome Paths"
        shareLink.socialMetaTagParameters?.descriptionText = "Checkout this awesome game"
        
        shareLink.socialMetaTagParameters?.imageURL = URL(string: "https://i.ibb.co/g60j3Fp/itachicat.jpg")
        
        DispatchQueue.main.async {
            shareLink.shorten { (urßl, warnings, error) in
                if error != nil {
                    return
                }
                guard let url = url else { return }
                self.inviteURL = url
            }
        }
        
    }
    
    var body: some View {
        // This is the workaround for the bug: https://developer.apple.com/forums/thread/652080
        // Swift UI on iOS 14 not assigning new object to @State property
        let padWidth = width / 4
        let phoneWidth = width / 1.7
        let padHeight = height / 18
        let phoneHeight = height / 12

        Button(action: {
            show = true
        }, label: {
            ZStack {
                Text("\(inviteURL?.absoluteString ?? "")")
                    .frame(width: 0, height: 0)
                    .hidden()
                    .zIndex(-1)
                RoundedRectangle(cornerRadius: 10)
                    .stroke()
                    .foregroundColor(.blue)
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.white)
            }
            .frame(width: isPad ? padWidth : phoneWidth, height: isPad ? padHeight : phoneHeight, alignment: .center)
            .overlay(
                HStack{
                    Image(systemName: "envelope.open.fill").imageScale(.large)
                    Text("Invite Friends").fontWeight(.medium)
                }
                .foregroundColor(.blue)
            )

        })
        .onAppear(perform: {
            createInviteLink()
        })
        .sheet(isPresented: $show, content: {
            let promoText = "Check out this great board game"
            if let url = self.inviteURL {
                ActivityViewController(activityItems: [promoText, url], applicationActivities: nil)
            }
        })
    }
    
}

struct ActivityViewController: UIViewControllerRepresentable {

    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}

}
