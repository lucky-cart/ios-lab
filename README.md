# <font color='#10409F'>Lucky Cart</font>

<b>Lucky Cart Connection engine and Swift API</b>

- Connection Layer and server model
- Public API facade and client model
 
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


### Sequencer

A tool that manage the current experience stage.

- connecting
- browsing
- checkingOut
- browsingGames
- playing

 

## <font color='#1E72AD'>Installation:</font>

Packages

## <font color='#1E72AD'>Author:</font>

©2022 Lucky Cart 


