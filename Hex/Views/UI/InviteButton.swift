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
    
    func createInviteLink() {
        // Create link
        let linkParameter = URL(string: "https://testflight.apple.com/join/bMxqwb9t")!
        
        guard let shareLink = DynamicLinkComponents(link: linkParameter, domainURIPrefix:  "https://gdhex.page.link") else {
            print("Couldn't reate FDL components")
            return
        }
        
        if let myBundleId = Bundle.main.bundleIdentifier {
            shareLink.iOSParameters = DynamicLinkIOSParameters(bundleID: myBundleId)
        }
        shareLink.iOSParameters?.appStoreID = "1559984377"
        shareLink.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        shareLink.socialMetaTagParameters?.title = "Hex Game"
        shareLink.socialMetaTagParameters?.descriptionText = "Checkout this awesome game"
        shareLink.socialMetaTagParameters?.imageURL = URL(string: "https://scontent-sea1-1.xx.fbcdn.net/v/t1.0-9/165727982_2916859945260899_8900223103201178356_o.jpg?_nc_cat=105&ccb=1-3&_nc_sid=09cbfe&_nc_ohc=O8GQZ7aQXTkAX_kYhU0&_nc_ht=scontent-sea1-1.xx&oh=83de67fe410e5e61285996d35e958235&oe=6085DC45")

        DispatchQueue.main.async {
            shareLink.shorten { (url, warnings, error) in
                if let error = error {
                    print("Error = \(error.localizedDescription)")
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
        Text("\(inviteURL?.absoluteString ?? "")")
            .hidden()
        Button(action: {
            show = true
        }, label: {
            Text("Invite Friends")
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
