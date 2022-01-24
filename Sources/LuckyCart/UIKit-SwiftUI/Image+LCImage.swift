//
//  File.swift
//  
//
//  Created by Tristan Leblanc on 24/01/2022.
//

import Foundation

import SwiftUI

#if os(macOS)

public extension Image {
    init(lcImage: LCImage) {
        self.init(nsImage: lcImage)
    }
}

#else

public extension Image {
    init(lcImage: LCImage) {
        self.init(uiImage: lcImage)
    }
}

#endif
