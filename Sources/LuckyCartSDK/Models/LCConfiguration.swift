//
//  LCConfiguration.swift
//  
//
//  Created by Lucky Cart on 19/01/2023.
//

import Foundation

public class LCConfiguration {
    
    static let shared = LCConfiguration()
    
    public var siteKey: String?
    public var customer: String?
    
    public var eventBaseUrl: String = "https://shopper-events.luckycart.com/v1"
    public var displayerBaseUrl: String = "https://displayer.luckycart.com"
    public var gameBaseUrl: String = "https://game-experience-api.luckycart.com/v1"
    
    public var apiRetries: Int = 5
    public var apiRetryDelay: Double = 0.5
}
