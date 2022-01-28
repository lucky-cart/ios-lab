//
//  LCGameView.swift
//
//  LuckyCartLab - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 18/01/2022.
//

import SwiftUI

public struct LCGameView: View {
    @State var cartId: String?
    @Binding var game: LCGame
    
    var reloadGamesOnClose: Bool = true
    
    public init(cartId: String, game: Binding<LCGame>) {
        self._game = game
        self._cartId = State(initialValue: cartId)
        print("[luckycart.gameview] Init game view ( \(game.id) - Playable : \(game.isGamePlayable) - Result : \(game.gameResult)")
    }
    
    public var body: some View {
#if os(macOS)
        let link = $game.desktopLink
#else
        let link = $game.mobileLink
#endif
        
        LCLinkView(link: link,
                   didClose: { timeInSecondsSpentInGame in
            print("[luckycart.gameview] User has spent \(timeInSecondsSpentInGame) seconds in game.")
            if let cartId = cartId, reloadGamesOnClose{
                LuckyCart.shared.reloadGames(cartId: cartId)
            }
        }, placeHolder: Image("luckyCartGame"))
    }
}

#if DEBUG

struct LCGameView_Previews: PreviewProvider {
    static var previews: some View {
        LCGameView(cartId: LuckyCart.testCart, game: .constant(LuckyCart.testGame))
    }
}

#endif
