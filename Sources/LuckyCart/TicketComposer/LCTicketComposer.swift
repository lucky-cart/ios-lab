//
//  LCTicketComposer.swift
//
//  LuckyCart Framework - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 14/01/2022.
//

import Foundation

public struct LCTicketComposer: LCTicketComposerEntity {
    public var customer: Customer
    public var cart: Cart
    public var order: Order
    public var metaData: MetaData
    
    public init(customer: Customer, cart: Cart, order: Order, metaData: MetaData) {
        self.customer = customer
        self.order = order
        self.cart = cart
        self.metaData = metaData
    }
    
    
    public func makeDictionary() throws -> [String: Any] {
        var out = [String: Any]()
        try customer.append(to: &out)
        try cart.append(to: &out)
        try order.append(to: &out)
        try metaData.append(to: &out)
        return out
    }
    
    /// priceString
    ///
    /// Returns a price as string
    
    public static func priceString(_ price: Double) -> String{
        let f = NumberFormatter()
        f.maximumFractionDigits = 2
        f.minimumFractionDigits = 2
        return f.string(for: price) ?? "\(price)"
    }
}
