//
//  LCImage.swift
//
//  LuckyCart Framework - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 24/01/2022.
//

#if os(macOS)

import Cocoa

public typealias LCImage = NSImage

#else

import UIKit

public typealias LCImage = UIImage

#endif
