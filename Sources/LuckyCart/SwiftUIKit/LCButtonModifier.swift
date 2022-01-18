//
//  LCButtonModifier.swift
//
//  LuckyCartLab - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 16/01/2022.
//

import SwiftUI

public struct LCButtonModifier: ViewModifier {

    var color: Color = .blue
    
    public func body(content: Content) -> some View {
            content
            .buttonStyle(PlainButtonStyle())
            .fixedSize()
            .padding(7)
            .frame(minWidth: 80)
            .foregroundColor(.white)
            .background(color)
            .cornerRadius(6)
    }
}

#if DEBUG

struct LCButtonModifier_Previews: PreviewProvider {
    static var previews: some View {
        Button("Test") {
            print("Test Tapped")
        }.modifier(LCButtonModifier())
    }
}

#endif
