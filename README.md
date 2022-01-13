# <font color='#10409F'>Lucky Cart</font>

<b>Lucky Cart Connection engine and Swift API</b>

- Connection Layer and server model
- Public API facade and client model
 
## <font color='#1E72AD'>Availability:</font>

- macOS   : .v11
- iOS     : .v13
- tvOS    : .v14
- watchOS : .v8

## <font color='#1E72AD'>Description:</font>

### Networking

The core classes that manage the session

### Workflow 

- 1 - init sdk ( ) < user enters the shop
- 2 - getBannerSpaces  < user browses 
- 3 - get Banner Detail < user receives available banners 
- 4 - sendCart < user checks out

### Model

The entities as sent by the server
    
- Customer
- Cart
- Game
- Games
- BannerSpaces
- BannerAction
- Banner

### Requests

The API requests swift definitions

### LuckyCart

The public service facade

#### Errors

- cantFormURL
- unknownRequestName
- wrongResponseType
- authKeyMissing
- authorizationMissing

#### Client Model

- LCCustomer
- LCCart
- LCLink
- LCGame
- LCGameResult
- LCBanner
- LCBannerSpaces
- LCBannerAction
- LCBannerActionType



## <font color='#1E72AD'>Installation:</font>

Packages

## <font color='#1E72AD'>Author:</font>

©2022 Lucky Cart 


