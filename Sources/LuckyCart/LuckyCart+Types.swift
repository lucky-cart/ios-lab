//
//  LCTypes.swift
//
//  LuckyCart Framework - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 10/01/2022.
//

import Foundation

/// LCTypes
///
/// The common types used in LuckyCart framework.
/// These types are used either on client and server side
///
/// We choose a struct here to allow extension in modules

public typealias LCCompletion = ((Result<Any, Error>)->Void)

protocol LCIdentifiable: Identifiable {
    var code: String { get set }
}

extension LCIdentifiable {
    public var id: String {
        get { code }
        set { code = newValue }
    }
}
