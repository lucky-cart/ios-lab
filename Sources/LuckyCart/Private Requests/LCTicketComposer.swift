//
//  LCTicketComposer.swift
//
//  LuckyCart Framework - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 14/01/2022.
//

import Foundation

/// LCTicketComposer
///
/// A utility class to generate json.
/// All LCTicketComposer objects must implement a `makeDictionary` to be exportable in JSON.
///
/// It is used to aggregate the necessary json information and the custom information, ensuring their is no key overrides
/// Client can create any LCTicketComposer conforming object to parse their submodels by classes.

public protocol LCTicketComposer {
    
    /// makeDictionary
    ///
    /// Returns the dictionary ready for JSON conversion
    
    func makeDictionary() throws -> [String: Any]
}

public extension LCTicketComposer {
    
    /// Access property in the dictionary by key
    
    subscript (key: String) -> Any? {
        get {
            return try? makeDictionary()[key]
        }
    }
    
    /// append
    ///
    /// Append the dictionary to a passed dictionary.
    /// An exception is thrown if the key already exists.
    
    func append(to dictionary: inout [String: Any]) throws {
        for (key,value) in try makeDictionary() {
            if dictionary[key] != nil {
                print("[luckycart.ticketComposer] Key `\(key)` already set")
                throw LuckyCart.Err.ticketComposerKeyAlreadyPresent
            }
            dictionary[key] = value
        }
    }
}

/// LCDictionaryComposer
///
/// A generic TicketComposer that wraps a dictionary

public struct LCDictionaryComposer: LCTicketComposer {
    public var dictionary: [String: Any?]
    
    public init(dictionary: [String: Any?]) {
        self.dictionary = dictionary
    }
    
    public func makeDictionary() throws -> [String: Any] {
        return (dictionary.filter { $0.value != nil }) as [String: Any]
    }
}
