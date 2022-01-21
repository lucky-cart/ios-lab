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
    var link: LCLink
    @State var isOpen: Bool = false
    
    /// The handler that gets called when the user closes the game view.
    ///
    /// The time spent by the user on the view is returned in the callback closure
    var didClose: ((Double)->Void)?
    
    var placeHolder: Image?
    
    
    public init(link: LCLink, didClose: ((Double)->Void)? = nil, placeHolder: Image? = nil) {
        self.link = link
        self.didClose = didClose
        self.placeHolder = placeHolder
    }
    
    public var body: some View {
        ZStack(alignment: .center) {
            
            AsyncImage(url: link.imageUrl) { phase in
                if let image = phase.image {
                    image.resizable()
                } else if let _ = phase.error {
                    Image("luckyCartBanner").resizable()
                } else {
                    Image("luckyCartBanner").resizable().opacity(0.0)
                }
            }.grayscale(link.isEnabled ? 0.0 : 0.8)
            
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
        .scaledToFit()
        .cornerRadius(10)
        .opacity(link.isEnabled ? 1.0 : 0.4)
    }
}

#if DEBUG

struct LCLinkView_Previews: PreviewProvider {
    static var previews: some View {
        LCLinkView(link: LuckyCart.testBanner.link, placeHolder: Image("luckyCartBanner"))
    }
}

#endif
