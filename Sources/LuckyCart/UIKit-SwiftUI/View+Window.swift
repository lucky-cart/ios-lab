//
//  View+Window.swift
//
//  LuckyCartLab - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 18/01/2022.
//

import SwiftUI

#if os(macOS)

extension View {
    
    private func newWindowInternal(title: String, geometry: NSRect, style: NSWindow.StyleMask, delegate: NSWindowDelegate) -> NSWindow {
        let window = NSWindow(
            contentRect: geometry,
            styleMask: style,
            backing: .buffered,
            defer: false)
        window.center()
        window.isReleasedWhenClosed = false
        window.title = title
        window.makeKeyAndOrderFront(nil)
        window.delegate = delegate
        return window
    }
    
    /// opens the target view in a new Mac OS window
    public func openNewWindow(title: String,
                              delegate: NSWindowDelegate,
                              geometry: NSRect = NSRect(x: 20, y: 20, width: 640, height: 480),
                              style:NSWindow.StyleMask = [.titled, .closable, .miniaturizable, .resizable]) {
        self.newWindowInternal(title: title, geometry: geometry, style: style, delegate: delegate).contentView = NSHostingView(rootView: self)
    }
}

#endif
