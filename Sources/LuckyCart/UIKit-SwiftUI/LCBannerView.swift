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
        LCLinkView(link: .constant(banner.link), clickAction: { link in
            switch banner.action.type {
            case .boutique:
                if !banner.action.ref.isEmpty {
                    banner.action.execute()
                    return false
                }
                return true
                // Open the sheet if no action set
            default:
                return true
            }
        })
    }
}

public struct LCAsyncSimpleBannerView: View {
    @State var bannerSpaceId: String
    @State var bannerId: String
    @State var format: String
    @State var banner: LCBanner?
    
    public init(bannerSpaceId: String,
                bannerId: String,
                format: String) {
        _bannerSpaceId = State(initialValue: bannerSpaceId)
        _bannerId = State(initialValue: bannerId)
        _format = State(initialValue: format)
    }
    
    public var body: some View {
        VStack {
            if let banner = banner {
                LCSimpleBannerView(banner: banner)
            } else {
                HStack {
                    Text("Loading Banner").font(.title2).foregroundColor(.gray)
                }
            }
        }
        .task {
            LuckyCart.shared.banner(with: bannerId,
                                    bannerSpaceIdentifier: bannerSpaceId,
                                    format: format,
                                    failure: { error in
            }) { banner in
                self.banner = banner
            }
        }
    }
}
