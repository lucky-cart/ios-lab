//
//  LCViewProtocols.swift
//
//  LuckyCartLab - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 19/01/2022.
//

import SwiftUI

/// Make your view conform to this protocol to display LuckyCart banners

public protocol LCBannersView: View {
    
    /// The banner space identifier containing the banner ids for this view
    var bannerSpaceId: String { get }
    
    /// The banners array.
    var banners: State<[LCBanner]> { get set }
}

public extension LCBannersView {
    
    func loadBanner(bannerId: String, format: String) {
        LuckyCart.shared.banner(with: bannerId,
                                bannerSpaceIdentifier: self.bannerSpaceId,
                                format: format,
                                failure: { error in
        }) { banner in
            self.banners.wrappedValue.append(banner)
        }
    }
}

/// Make your view conform to this protocol to display LuckyCart games

public protocol LCGamesView: View {
    var games: [LCGame] { get set }
}

/// Make your view conform to this protocol to display a "Boutique View"
/// A Boutique View is a custom view provided by client application.
///
/// The identifier will be used to match the view with an action reference

public protocol LCBoutiqueView: View {
    var boutiquePageIdentifier: String { get set }
}
