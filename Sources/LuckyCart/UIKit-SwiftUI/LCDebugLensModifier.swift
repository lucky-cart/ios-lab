//
//  LCDebugLensModifier.swift
//
//  LuckyCartLab - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 20/01/2022.
//


import SwiftUI

public struct LCDebugLensModifier: ViewModifier {
    
    var color: Color = .blue
    @State var message: String? = nil
    
    public init(color: Color = .red, message: String? = nil) {
        self.color = color
        self.message = message
    }
    public func body(content: Content) -> some View {
        ZStack {
            content
#if DEBUG
            if let message = message {
                VStack(alignment: .center) {
                    ZStack(alignment: .center) {
                        VStack(spacing: 16) {
                            Label("LuckyCart Error", systemImage: "exclamationmark.triangle").font(.headline)
                            Text(message).font(.caption)
#if os(tvOS)
                            Button("Close") {
                                self.message = nil
                            }
#endif
                        }
                    }
#if !os(tvOS)
                    .onTapGesture {
                        self.message = nil
                    }
#endif
                    .padding(16)
                }
                .foregroundColor(.white)
                .background(color.opacity(0.9))
                .cornerRadius(8)
                .shadow(radius: 12)
                .padding(16)
                Spacer()
            }
#endif
        }
        .onReceive(LuckyCart.shared.$lastError) { error in
            self.message = error?.localizedDescription
        }
    }
}

#if DEBUG

struct LCDebugLensModifier_Previews: PreviewProvider {
    static var previews: some View {
        Text("Test Debug Lens")
            .padding(50)
            .modifier(LCDebugLensModifier())
    }
}

#endif
