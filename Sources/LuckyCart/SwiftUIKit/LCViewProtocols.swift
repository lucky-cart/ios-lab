//
//  File.swift
//  
//
//  Created by Tristan Leblanc on 19/01/2022.
//

import SwiftUI

/// Make your view conform to this protocol to display LuckyCart banners

public protocol BannerSpaceView: View {
    var bannerSpaceId: LCBannerSpaceIdentifier { get }
    var banners: [LCBanner] { get set }
}

/// Make your view conform to this protocol to display LuckyCart views
///
public protocol GamesView: View {
    var games: [LCGame] { get set }
}
