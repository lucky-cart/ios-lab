# <font color='#10409F'>Lucky Cart</font>

<b>Lucky Cart Connection engine and Swift API</b>

[Connection Layer and server model Documentation](PrivateDocumentation.md)

[Public API and client model Documentation](Documentation.md)
 
## <font color='#1E72AD'>Availability:</font>

- macOS   : .v11
- iOS     : .v13
- tvOS    : .v14
- watchOS : .v8

## <font color='#1E72AD'>Scheme:</font>

![LuckyCart Scheme](LuckyCartScheme.jpg)
	
## <font color='#1E72AD'>Private Part</font>

### Networking

The core classes that manage the session

### Server API

The requests set to communicate with LuckyCart API

### Server Model

The entities as sent by the server
    
- Customer
- Cart
- Game
- Games
- BannerSpaces
- BannerAction
- Banner

## <font color='#1E72AD'>Public Part</font>

### Errors

- cantFormURL
- unknownRequestName
- wrongResponseType
- authKeyMissing
- authorizationMissing

### Client Model

- LCCustomer
- LCCart
- LCLink
- LCGame
- LCGameResult
- LCBanner
- LCBannerSpaces
- LCBannerAction
- LCBannerActionType

### Ticket Composer

A tool that assists framework user to create ticket JSON.


### Debug
#### LuckyCart.swift
#### LuckyCart+Facade.swift#### LuckyCart+Model.swift#### LuckyCart+Requests.swift#### LuckyCart+Types.swift#### LuckyCartClient.swift### Networking#### LCAuthorization.swift#### LCNetwork.swift#### LCRequest.swift#### LCServer.swift### Private Model
#### LCServerModel.swift### Private Requests#### LCRequest+GetBanner.swift#### LCRequest+GetBannerSpaces.swift#### LCRequest+GetBannerView.swift#### LCRequest+GetGames.swift#### LCRequest+PostCart.swift
### SwiftUIKit#### LCBannerView.swift#### LCButtonModifier.swift#### LCDebugLensModifier.swift#### LCGameView.swift#### LCLinkView.swift#### LCViewProtocols.swift#### LCWebView.swift#### View+Window.swift### TicketComposer#### LCTicketComposer.swift#### LCTicketComposer+Model.swift


## <font color='#1E72AD'>Installation:</font>

Packages

## <font color='#1E72AD'>Author:</font>

©2022 Lucky Cart 


