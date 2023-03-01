//
//  LCConfiguration+Test.swift
//
//
//  Created by Lucky Cart on 19/01/2023.
//

import Foundation

extension LCConfiguration {
    
    public func setTestSiteKey() {
        LCConfiguration.shared.siteKey = "A2ei4iyi"
    }
    
    public func setTestCustomer() {
        LCConfiguration.shared.customer = "customer1234"
    }
    
}
