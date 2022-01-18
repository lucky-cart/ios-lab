//
//  File.swift
//  
//
//  Created by Tristan Leblanc on 18/01/2022.
//

import Foundation

/// Make your app/manager/controller object conform to this protocol to use LuckyCart

public protocol LuckyCartClient {
    
    /// Starts the LuckyCart framework
    func initLuckyCart()

    /// Send the ticket to LuckyCart
    func checkOut(failure: @escaping (Error)->Void,
                  success: @escaping (LCPostCartResponse)->Void)
    
    /// Returns the client meta data
    var metaDataForLuckyCart: LCTicketComposer.MetaData { get }
    
    /// Returns the client customer data mapped to LuckyCart format
    var customerForLuckyCart: LCTicketComposer.Customer { get }
    
    /// Returns the client cart data mapped to LuckyCart format
    var cartForLuckyCart: LCTicketComposer.Cart { get }
    
    /// Returns the client order data mapped to LuckyCart format
    var orderForLuckyCart: LCTicketComposer.Order { get }
}

public extension LuckyCartClient {

    var ticketComposerForLuckyCart: LCTicketComposer {
        LCTicketComposer(customer: customerForLuckyCart,
                         cart: cartForLuckyCart,
                         order: orderForLuckyCart,
                         metaData: metaDataForLuckyCart)
    }
    
}

