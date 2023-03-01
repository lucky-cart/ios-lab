//
//  LCEventPayload.swift
//  
//
//  Created by Lucky Cart on 19/01/2023.
//

import Foundation

///
/// LCEventPayload
///
/// Payload model to send for events
///
/// Exemples of payloads :
/// ```
/// //PageViewed event
/// LCEventPayload(pageType: String,
///                  pageId: String,
///               storeType: String,
///                 storeId: String)
/// //CartValidated event (exemple of building method)
/// func cartToLuckyCartPayload() -> LCEventPayload {
///     var payload = LCEventPayload()
///     payload.cartId = cartId
///     payload.currency = "EUR"
///     payload.device = "web-optin"
///     payload.finalAtiAmount = finalAtiAmount
///     payload.deliveryAtiAmount = 0.0
///     payload.deliveryTfAmount = 0.0
///
///     var payloadProducts: [LCEventPayloadProduct] = []
///
///     if let products = products {
///         for product in products {
///             let p = LCEventPayloadProduct(productId: product.productId,
///                                     unitAtiAmount: product.unitAtiAmount,
///                                   unitTfAmount: product.unitTfAmount,
///                                    finalAtiAmount: product.finalAtiAmount,
///                                    finalTfAmount: product.finalTfAmount,
///                                     discountAtiAmount: product.discountAtiAmount,
///                                   discountTfAmount: product.discountTfAmount,
///                                     quantity: product.quantity,
///                                     category: product.category,
///                                     brand: product.brand,
///                                      ean: product.ean)
///          payloadProducts.append(p)
///      }
///     }
///
///     payload.products = payloadProducts
///
///     return payload
/// }
/// ```
public struct LCEventPayload: Codable {
    public var pageType: String?
    public var pageId: String?
    public var bannerType: String?
    public var bannerPosition: String?
    public var operationId: String?
    public var storeType: String?
    public var shopperEmail: String?
    public var cartId: String?
    public var transactionDate: Date?
    public var storeId: String?
    public var storeTypeId: String?
    public var currency: String?
    public var device: String?
    public var lang: String?
    public var finalAtiAmount: Double?
    public var finalTfAmount: Double?
    public var totalDiscountAtiAmount: Double?
    public var totalDiscountTfAmount: Double?
    public var deliveryAtiAmount: Double?
    public var deliveryTfAmount: Double?
    public var deliveryMode: String?
    public var deliveryDate: Date?
    public var paymentType: String?
    public var promoCode: String?
    public var promoCodeAtiAmount: Double?
    public var promoCodeLabel: String?
    public var loyaltyCard: String?
    public var hasLoyaltyCard: Bool?
    public var isNewShopper: Bool?
    public var products: [LCEventPayloadProduct]?
    
    public init(pageType: String? = nil, pageId: String? = nil, bannerType: String? = nil, bannerPosition: String? = nil, operationId: String? = nil, storeType: String? = nil, shopperEmail: String? = nil, cartId: String? = nil, transactionDate: Date? = nil, storeId: String? = nil, storeTypeId: String? = nil, currency: String? = nil, device: String? = nil, lang: String? = nil, finalAtiAmount: Double? = nil, finalTfAmount: Double? = nil, totalDiscountAtiAmount: Double? = nil, totalDiscountTfAmount: Double? = nil, deliveryAtiAmount: Double? = nil, deliveryTfAmount: Double? = nil, deliveryMode: String? = nil, deliveryDate: Date? = nil, paymentType: String? = nil, promoCode: String? = nil, promoCodeAtiAmount: Double? = nil, promoCodeLabel: String? = nil, loyaltyCard: String? = nil, hasLoyaltyCard: Bool? = nil, isNewShopper: Bool? = nil, products: [LCEventPayloadProduct]? = nil) {
        self.pageType = pageType
        self.pageId = pageId
        self.bannerType = bannerType
        self.bannerPosition = bannerPosition
        self.operationId = operationId
        self.storeType = storeType
        self.shopperEmail = shopperEmail
        self.cartId = cartId
        self.transactionDate = transactionDate
        self.storeId = storeId
        self.storeTypeId = storeTypeId
        self.currency = currency
        self.device = device
        self.lang = lang
        self.finalAtiAmount = finalAtiAmount
        self.finalTfAmount = finalTfAmount
        self.totalDiscountAtiAmount = totalDiscountAtiAmount
        self.totalDiscountTfAmount = totalDiscountTfAmount
        self.deliveryAtiAmount = deliveryAtiAmount
        self.deliveryTfAmount = deliveryTfAmount
        self.deliveryMode = deliveryMode
        self.deliveryDate = deliveryDate
        self.paymentType = paymentType
        self.promoCode = promoCode
        self.promoCodeAtiAmount = promoCodeAtiAmount
        self.promoCodeLabel = promoCodeLabel
        self.loyaltyCard = loyaltyCard
        self.hasLoyaltyCard = hasLoyaltyCard
        self.isNewShopper = isNewShopper
        self.products = products
    }
}

public struct LCEventPayloadProduct: Codable {
    public var productId: String?
    public var unitAtiAmount: Double?
    public var unitTfAmount: Double?
    public var finalAtiAmount: Double?
    public var finalTfAmount: Double?
    public var discountAtiAmount: Double?
    public var discountTfAmount: Double?
    public var quantity: Int?
    public var category: String?
    public var brand: String?
    public var ean: String?
    
    public init(productId: String? = nil, unitAtiAmount: Double? = nil, unitTfAmount: Double? = nil, finalAtiAmount: Double? = nil, finalTfAmount: Double? = nil, discountAtiAmount: Double? = nil, discountTfAmount: Double? = nil, quantity: Int? = nil, category: String? = nil, brand: String? = nil, ean: String? = nil) {
        self.productId = productId
        self.unitAtiAmount = unitAtiAmount
        self.unitTfAmount = unitTfAmount
        self.finalAtiAmount = finalAtiAmount
        self.finalTfAmount = finalTfAmount
        self.discountAtiAmount = discountAtiAmount
        self.discountTfAmount = discountTfAmount
        self.quantity = quantity
        self.category = category
        self.brand = brand
        self.ean = ean
    }
}
