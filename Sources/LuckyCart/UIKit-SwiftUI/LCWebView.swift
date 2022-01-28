//
//  LCWebView.swift
//
//  LuckyCartLab - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 11/01/2022.
//

import SwiftUI
//import LuckyCart

#if !os(tvOS) && !os(watchOS)
import WebKit

/// HTML not supported on tvOS - use TVML
/// https://developer.apple.com/documentation/tvmljs

#if os(macOS)
typealias PlatformViewReprentable = NSViewRepresentable
#else
typealias PlatformViewReprentable = UIViewRepresentable
#endif


/// LCWebView
///
/// A multiplatform WebView
///
/// For now, A LuckyCart application can be build on any platform, but
/// HTML being forbidden on tvOS and watchOS apps, content should be provided in apple TVML.
/// If there is a need for compatibility, complete this class.

struct LCWebView : PlatformViewReprentable {
    
    let request: URLRequest
    
#if os(macOS)
    
    typealias NSViewType = WKWebView
    
    func makeNSView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        nsView.load(request)
    }
    
#else
    
    func makeUIView(context: Context) -> WKWebView  {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
    
#endif
    
}

#else

import LuckyCart

// MARK: - TV OS Version

public struct LCWebView: View {
    
    @EnvironmentObject var luckyCart: LuckyCart
    
    var request: URLRequest
    
    public var body: some View {
        VStack {
            Text("HTML Not supported - Use TVML")
            if let url = request.url?.absoluteString {
                Text("\(url)")
            }
        }
        .padding()
        .font(.headline)
        
    }
}


#endif

#if DEBUG
struct WebView_Previews : PreviewProvider {
    static var previews: some View {
        LCWebView(request: URLRequest(url: LuckyCart.testGame.desktopLink.url))
    }
}
#endif
