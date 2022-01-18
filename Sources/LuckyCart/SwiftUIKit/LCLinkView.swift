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
    
    var placeHolder: Image?

    public init(link: LCLink, placeHolder: Image? = nil) {
        _link = State(initialValue: link)
        self.placeHolder = placeHolder
    }
    
    public var body: some View {
        ZStack(alignment: .center) {
            
            AsyncImage(url: link.imageUrl, content: { image in
                image.resizable().scaledToFit()
            }, placeholder: {
                placeHolder?.resizable().scaledToFit()
            })
            
            Button("") {
                isOpen = true
            }.scaledToFill()
                .sheet(isPresented: $isOpen, content: {
                    VStack {
                        LCWebView(request: URLRequest(url: link.url))
                        Button("Close") {
                            isOpen = false
                        }
                        .modifier(LCButtonModifier(color: .blue))
                    }
                })
        }
        .scaledToFit()
        .cornerRadius(10)
    }
}

#if DEBUG

struct LCLinkView_Previews: PreviewProvider {
    static var previews: some View {
        LCLinkView(link: LuckyCart.testBanner.link, placeHolder: Image("luckyCartBanner"))
    }
}

#endif
