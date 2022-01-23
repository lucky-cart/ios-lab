//
//  File.swift
//  
//
//  Created by Tristan Leblanc on 23/01/2022.
//

import Foundation

// MARK: - getBannerDetails -

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
