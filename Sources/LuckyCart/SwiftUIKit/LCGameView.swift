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
    
    @Binding var game: LCGame
        
    public init(game: Binding<LCGame>) {
        _game = game
        print("Display link view game ( \(game.id) - Playable : \(game.isGamePlayable) - Result : \(game.gameResult)")
    }
    
    public var body: some View {
        
        LCLinkView(link: game.mobileLink,
                   didClose: { timeInSecondsSpentInGame in
            print("[luckycart.gameview] User has spent \(timeInSecondsSpentInGame) seconds in game.")
            LuckyCart.shared.reloadGames()
        },
                   placeHolder: Image("luckyCartGame"))
    }
}

#if DEBUG

struct LCGameView_Previews: PreviewProvider {
    static var previews: some View {
        LCGameView(game: .constant(LuckyCart.testGame))
    }
}

#endif
