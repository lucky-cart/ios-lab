//
//  Image+LCImage.swift
//
//  LuckyCart Framework - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 24/01/2022.

import Foundation
import SwiftUI

/// A convenient macOS/iOS swiftUI Image initializer

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
