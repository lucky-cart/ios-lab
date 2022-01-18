//
//  LCBannerView.swift
//
//  LuckyCartLab - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 12/01/2022.
//

import SwiftUI
//import LuckyCart

public struct LCBannerView: View {
    @State var banner: LCBanner
    
    public init(banner: LCBanner) {
        _banner = State(initialValue: banner)
    }
    
    public var body: some View {
        LCLinkView(link: banner.link, placeHolder: Image("luckyCartBanner"))
    }
}
