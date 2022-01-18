//
//  LCGameView.swift
//
//  LuckyCartLab - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 18/01/2022.
//

import SwiftUI
//import LuckyCart

public struct LCGameView: View {
    @State var game: LCGame
    
    public init(game: LCGame) {
        _game = State(initialValue: game)
    }
    
    public var body: some View {
        LCLinkView(link: game.mobileLink, placeHolder: Image("luckyCartGame"))
    }
}

#if DEBUG

struct LCGameView_Previews: PreviewProvider {
    static var previews: some View {
        LCGameView(game: LuckyCart.testGame)
    }
}

#endif
