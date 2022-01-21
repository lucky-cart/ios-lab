//
//  LCAuthorization.swift
//
//  LuckyCart Framework - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 13/01/2022.
//

import Foundation
import CryptoKit

/// LCSignature
///
/// The signature object returned by authorization

struct LCSignature {
    var key: String
    var timestamp: String
    var hex: String
}

/// LCAuthorization
///
/// The use/secret key to use in network or server configuration

public struct LCAuthorization {
    let key: String
    let secret: String
    
    let version = "2.0"
    
    #if !DEBUG
    func computeSignature() -> LCSignature {
        // TODO: Finish Encryption and move in private part
        
        let date = Date()
        let timestamp = "\(Int(date.timeIntervalSinceReferenceDate))"
        let key = SymmetricKey(data: secret.data(using: .utf8)!)
        
        let signature = HMAC<SHA256>.authenticationCode(for: timestamp.data(using: .utf8)!, using: key)
        let signatureHex = Data(signature).map { String(format: "%02hhx", $0) }.joined()
        
        return LCSignature(key: self.key, timestamp: timestamp, hex: signatureHex)
    }

    #else
    /// Compute the HMAC Signature
    ///
    /// In DEBUG mode, a timestamp can be passed to the function
    func computeSignature(timestamp: String? = nil) -> LCSignature {
        // TODO: Finish Encryption and move in private part
        
        let date = Date()
        let timestamp = timestamp ?? "\(Int(date.timeIntervalSinceReferenceDate))"
        let key = SymmetricKey(data: secret.data(using: .utf8)!)
        
        let signature = HMAC<SHA256>.authenticationCode(for: timestamp.data(using: .utf8)!, using: key)
        let signatureHex = Data(signature).map { String(format: "%02hhx", $0) }.joined()
        
        return LCSignature(key: self.key, timestamp: timestamp, hex: signatureHex)
    }
    #endif
}
