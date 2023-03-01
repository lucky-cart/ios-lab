//
//  LCBannerModel.swift
//  
//
//  Created by Lucky Cart on 19/01/2023.
//

import Foundation


public struct LCBannerModel: Codable {
    public let banner: LCBannerExperience?
    public let bannerList : [LCBannerExperience]?
}

public struct LCBannerExperience: Codable {
    public let experienceId: String?
    public let operationId: String?
    public let spaceId: String?
    public let imageUrl: URL?
    public let spaceRedirect: URL?
    public let shopInShopRedirect: String?
    public let helpRedirect: URL?
    public let shopInShopRedirectMobile: LCBannerExperienceRedirectMobile?
}

public struct LCBannerExperienceRedirectMobile: Codable {
    public let type: String?
    public let ref: String?
}
