//
//  LCGameModel.swift
//  
//
//  Created by Lucky Cart on 19/01/2023.
//

import Foundation

public struct LCGamesExperience: Codable {
    let experienceId: String
    let operationId: String
    let generatedAt: String?
    let expiresAt: String?
    let experienceUrl: URL?
    let images: LCGameImages?
}

public struct LCGameImages: Codable {
    let thumbnailUrl: URL?
    let desktopUrl: URL?
    let mobileUrl: URL?
    let tabletUrl: URL?
}
