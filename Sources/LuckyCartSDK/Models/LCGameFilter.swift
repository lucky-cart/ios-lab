//
//  LCGameFilter.swift
//  
//
//  Created by Lucky Cart on 23/01/2023.
//

import Foundation

public struct LCGameFilter: Codable {
    public var filters: [LCFilter]?
    
    public init(filters: [LCFilter]? = nil) {
        self.filters = filters
    }
}

public struct LCFilter: Codable {
    public var filterProperty: String
    public var filterValue: String
    
    public init(filterProperty: String, filterValue: String) {
        self.filterProperty = filterProperty
        self.filterValue = filterValue
    }
}
