//
//  File.swift
//  
//
//  Created by Tristan Leblanc on 23/01/2022.
//

import Foundation

// MARK: - getBannerDetails -

/// LCRequestName
///
/// Defines the request primitives
/// - the name ("myrequest")
/// - the server to use ( api or promomatching )
/// - the path to access resource from server base
/// - the method ( "GET", "POST" )

extension LCRequestName {
    
    /// getImaget
    ///
    /// The url of the image to retrieve
    ///
    /// Scheme:
    /// ```
    /// <any image url>
    /// ```
    ///
    /// Results:
    /// ```
    /// <Image Data>
    /// ```
    
    static let getImage = LCRequestName(rawValue: "getImage",
                                         server: .any,
                                         path: "",
                                         method: "GET")
}
