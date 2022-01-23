//
//  File.swift
//  
//
//  Created by Tristan Leblanc on 23/01/2022.
//

import SwiftUI

public struct LCGameResultViewModifier: ViewModifier {

    var gameResult: LCGameResult
    
    public init(gameResult: LCGameResult) {
        self.gameResult = gameResult
    }
 
    public func body(content: Content) -> some View {
        ZStack {
            content
            switch gameResult {
            case .won:
                Image(systemName: "checkmark.seal.fill").foregroundColor(.red)
            case .lost:
                Image(systemName: "xmark.seal.fill").foregroundColor(.red)
            default:
                ZStack {}
            }
        }
    }
}
