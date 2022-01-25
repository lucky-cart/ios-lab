//
//  LCBannerView.swift
//
//  LuckyCartLab - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 12/01/2022.
//

import SwiftUI

public protocol LCBannerView: View {
    var banner: LCBanner { get set }
}

/// A very simple banner view that displays the link image, 
public struct LCSimpleBannerView: LCBannerView {
    @State public var banner: LCBanner
    
    public init(banner: LCBanner) {
        _banner = State(initialValue: banner)
    }
    
    public var body: some View {
        LCLinkView(link: .constant(banner.link)) { link in
            switch banner.action.type {
            case .boutique:
                //                if !banner.action.ref.isEmpty {
                banner.action.execute()
                return false
                //               }
                //return true
                // Open the sheet if no action set
            default:
                return true
            }
        }
        .frame(minWidth:32, maxWidth: 2000, minHeight:32, maxHeight: 360, alignment: .center)
    }
}

public struct LCAsyncSimpleBannerView: View {
    @State var bannerSpaceId: LCBannerSpaceIdentifier
    @State var bannerId: LCBannerIdentifier
    @State var banner: LCBanner?
    
    public init(bannerSpaceId: LCBannerSpaceIdentifier, bannerId: LCBannerIdentifier) {
        _bannerSpaceId = State(initialValue: bannerSpaceId)
        _bannerId = State(initialValue: bannerId)
    }
    
    public var body: some View {
        VStack {
            if let banner = banner {
                LCSimpleBannerView(banner: banner)
            } else {
                HStack {
                    Text("Loading Banner").font(.title2).foregroundColor(.gray)
                }
                .frame(minWidth:32, maxWidth: 2000, minHeight:32, maxHeight: 360, alignment: .center)
            }
        }
        .task {
            LuckyCart.shared.banner(with: bannerId,
                                    bannerSpaceIdentifier: bannerSpaceId,
                                    failure: { error in
            }) { banner in
                self.banner = banner
            }
        }
    }
}
