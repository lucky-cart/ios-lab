//
//  LCLinkView.swift
//
//  LuckyCartLab - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 18/01/2022.
//

import SwiftUI
//import LuckyCart

public struct LCLinkView: View {
    
    @State var link: LCLink
    
    @State var isOpen: Bool = false
    
    /// The handler that gets called when the user closes the game view.
    ///
    /// The time spent by the user on the view is returned in the callback closure
    var didClose: ((Double)->Void)?
    
    var placeHolder: Image?
    
    
    public init(link: LCLink, didClose: ((Double)->Void)? = nil, placeHolder: Image? = nil) {
        self._link = State(initialValue: link)
        self.didClose = didClose
        self.placeHolder = placeHolder
    }
    
    public var body: some View {
        ZStack(alignment: .center) {
            
                if let image = link.image  {
                    Image(uiImage: image).resizable()
                }

                if link.isEnabled {
                Button("") {
                    isOpen = true
                }.scaledToFill()
                    .sheet(isPresented: $isOpen, content: {
                        let openDate = Date()
                        
                        VStack {
                            LCWebView(request: URLRequest(url: link.url))
                            Button("Close") {
                                isOpen = false
                                didClose?(-openDate.timeIntervalSinceNow)
                            }
                            .modifier(LCButtonModifier(color: .blue))
                        }
                    })
            }
        }
        .grayscale(link.isEnabled ? 0.0 : 0.8)
        .opacity(computeOpacity())
        .scaledToFit()
        .cornerRadius(10)
        .task {
            guard link.image == nil, let imageURL = link.imageUrl else { return }
            LuckyCart.shared.getImage(url: imageURL) { response in
                switch response {
                case .failure(let error):
                    print("[luckycart.linkView] Error \(error)")
                case .success(let image):
                    link.image = image
                }
            }
        }
    }
    
    func computeOpacity() -> Double {
        if link.image == nil { return 0 }
        if link.isEnabled { return 1.0 }
        return 0.5
    }
}

#if DEBUG

struct LCLinkView_Previews: PreviewProvider {
    static var previews: some View {
        LCLinkView(link: LuckyCart.testBanner.link, placeHolder: Image("luckyCartBanner"))
    }
}

#endif
