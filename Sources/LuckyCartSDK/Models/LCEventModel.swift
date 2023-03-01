//
//  LCEventModel.swift
//  
//
//  Created by Lucky Cart on 19/01/2023.
//

import Foundation

public enum LCEventName: String, Codable {
    case pageViewed, cartValidated, bannerClicked, bannerViewed
}

internal class LCEventModel: Codable {
    var shopperId: String
    var siteKey: String
    var eventName: LCEventName
    var payload: LCEventPayload?
    
    init(shopperId: String = "unknown",
         siteKey: String,
         eventName: LCEventName,
         payload: LCEventPayload? = .none) {
        self.shopperId = shopperId
        self.siteKey = siteKey
        self.eventName = eventName
        self.payload = payload
    }
}
