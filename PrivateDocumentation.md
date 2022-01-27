
# <font color='#10409F'>Lucky Cart Connection Layer and Server Model</font>

<b>Lucky Cart Connection engine and Swift Private API</b>

## <font color='#707080'>Networking</font>

### <font color='#DF0040'>LCAuthorization</font>

LuckyCart signer object. It stores the auth_key/secret (`LCAuthorization`) for the server and generates a signature (`LCSignature`)

### <font color='#DF0040'>LCNetwork</font>

LuckyCart Networking Layer is responsible of running the sessions (`URLSession`) and running requests (`LCRequest` transformed to system `URLRequest`)

### <font color='#DF0040'>LCRequest</font>

LuckyCart Request Base.

### <font color='#DF0040'>LCServer</font>

LuckyCart Server Abstraction to represent the API and PromoMatching servers

## <font color='#707080'>Private Server Model</font>

### <font color='#DF0040'>Model.Customer</font>

- id `String`
- static guest `Customer(id: "unknown")`

### <font color='#DF0040'>Model.Cart</font>

- id: String

### <font color='#DF0040'>Model.Game</font>

- code `String`
- isGamePlayable `Bool`
- gameResult `LCGameResult`
- desktopGameUrl `URL`
- desktopGameImage `URL`
- mobileGameUrl `URL`
- mobileGameImage `URL`

### <font color='#DF0040'>Model.Games</font>

- games: `[Model.Game]` 

### <font color='#DF0040'>Model.BannerSpaces</font>

- typealias to `[String: [String]]`

### <font color='#DF0040'>Model.Banner</font>

- image_url `URL`
- redirect_url `URL`
- name `String`
- campaign `String`
- space `String`
- action `BannerAction`


### <font color='#DF0040'>Model.BannerAction</font>

- type `String`
- ref `String`

## <font color='#707080'>Requests</font>

### <font color='#DF0040'>LCRequest+GetBanner.swift</font>

Fetch a banner by its identifier.

##### Example

```
let request: LCRequest<Model.Banner> = try network.buildRequest(name: .getBanner,
                                                                parameters: parameters,
                                                                body: nil)
try network.run(request) { response in
                switch response {
                case .success(let result):
                // Got a `Model.Banner` Result
                case .failure(let error):
            }

```

##### URL

```
https://api.luckycart.com/cart/games?authKey={{auth_key}}&cartId={{cart_id}}&customerId={{customer_id}}
```

##### JSON Response

```
{
    "games": [
        {
            "code": "QLWG-SHYR-MGBZ-SLXK",
            "isGamePlayable": true,
            "gameResult": "not-played",
            "desktopGameUrl": "https://api.luckycart.com/replacement/QLWG-SHYR-MGBZ-SLXK/desktop/url",
            "desktopGameImage": "https://api.luckycart.com/replacement/QLWG-SHYR-MGBZ-SLXK/desktop/image",
            "mobileGameUrl": "https://api.luckycart.com/replacement/QLWG-SHYR-MGBZ-SLXK/mobile/url",
            "mobileGameImage": "https://api.luckycart.com/replacement/QLWG-SHYR-MGBZ-SLXK/mobile/image"
        }
    ]
}
```


###  <font color='#DF0040'>LCRequest+GetBannerSpaces.swift</font>

Fetch all banner spaces. The first executed request.

```
let request: LCRequest<Model.BannerSpaces> = try network.buildRequest(name: .getBannerSpaces,
                                                                      parameters: parameters,
                                                                      body: nil)
try network.run(request) { response in
                switch response {
                case .success(let result):
                // Got a `Model.BannerSpaces` Result
                case .failure(let error):
            }

```

##### URL

```
https://promomatching.luckycart.com/{{auth_key}}/{{customer_id}}/banners/mobile/list
```

##### JSON Response
```
{
    "homepage": [
        "banner"
    ],
    "categories": [
        "banner_100",
        "banner_200",
        "search_100",
        "search_200"
    ]
}
```

###  <font color='#DF0040'>LCRequest+GetGames</font>

Fetch all available games for current user.

##### Example

```
let request: LCRequest<Model.BannerSpaces> = try network.buildRequest(name: .getGames,
                                                                      parameters: parameters,
                                                                      body: nil)
try network.run(request) { response in
                switch response {
                case .success(let result):
                // Got a `[Model.Game]` Result
                case .failure(let error):
            }

```

##### URL

```
https://api.luckycart.com/cart/games?authKey={{auth_key}}&cartId={{cart_id}}&customerId={{customer_id}}
```

##### JSON Response

```
{
    "games": [
        {
            "code": "QLWG-SHYR-MGBZ-SLXK",
            "isGamePlayable": true,
            "gameResult": "not-played",
            "desktopGameUrl": "https://api.luckycart.com/replacement/QLWG-SHYR-MGBZ-SLXK/desktop/url",
            "desktopGameImage": "https://api.luckycart.com/replacement/QLWG-SHYR-MGBZ-SLXK/desktop/image",
            "mobileGameUrl": "https://api.luckycart.com/replacement/QLWG-SHYR-MGBZ-SLXK/mobile/url",
            "mobileGameImage": "https://api.luckycart.com/replacement/QLWG-SHYR-MGBZ-SLXK/mobile/image"
        }
    ]
}
```

###  <font color='#DF0040'>LCRequest+SendCart</font>

Send a subset of cart data to LuckyCart.

##### Example

```
let body = LCRequestParameters.SendCart(cart: cart,
                                          customer: customer,
                                          ticketComposer: ticketComposer)

let request: LCRequest<Model.BannerSpaces> = try network.buildRequest(name: .sendCart,
                                                                      parameters: nil,
                                                                      body: body)
try network.run(request) { response in
                switch response {
                case .success(let result):
                // Got a `Model.PostCartResponse` Result
                case .failure(let error):
            }

```
##### URL

```
https://api.luckycart.com/cart/ticket.json
```

##### Parameters

```
{
    "auth_key": "{{auth_key}}",
    "auth_ts": "{{timestamp}}",
    "auth_sign": "{{sign}}",
    "auth_v": "2.0",
}
```

##### JSON Response

```
{
    "ticket": "QLWG-SHYR-MGBZ-SLXK",
    "mobileUrl": "https://api.luckycart.com/replacement/QLWG-SHYR-MGBZ-SLXK/mobile/url",
    "tabletUrl": "https://api.luckycart.com/replacement/QLWG-SHYR-MGBZ-SLXK/tablet/url",
    "desktopUrl": "https://api.luckycart.com/replacement/QLWG-SHYR-MGBZ-SLXK/desktop/url",
    "baseMobileUrl": "https://go.luckycart.com/mobile/QLWG-SHYR-MGBZ-SLXK",
    "baseTabletUrl": "https://go.luckycart.com/tablet/QLWG-SHYR-MGBZ-SLXK",
    "baseDesktopUrl": "https://go.luckycart.com/lc__team__qa/NX5PDN/play/QLWG-SHYR-MGBZ-SLXK"
}
```


## <font color='#10409F'>Debug Extensions</font>

A collection of debug entities to feed unitary tests.

### <font color='#DF0040'>LuckyCart+Debug</font>

Public model entities static instances for test/debugging purpose.

- test
- testAuthKey `ugjArgGw`
- testSecret `p#91J#i&00!QkdSPjgGNJq`
- testCustomer `customer1234`
- testCart `cart_1234`
- testAuthorization
- testSignature `testAuthorization.computeSignature(timestamp: "664354523")`
- testGame
- testBannerSpaces    
- testBanner
- testPostCartResponse

```swift
    // Returns some LuckyCart test instance
    let luckyCart = LuckyCart.test
    let bannerSpaces = LuckyCart.testBannerSpaces
```

### <font color='#DF0040'>LCServerModel+Debug</font>

- promoTestUrl `https://promomatching.luckycart.com/61d6c677baa1676dd46bfee6/\(testCustomer.id)`
- apiTestUrl `https://api.luckycart.com`
- goTestUrl `https://go.luckycart.com`
- testCustomer `customer1234`
- testCart `cart_1234`
- testGame
- testBannerSpaces
- testBanner                                                
- testPostCartResponse

### <font color='#DF0040'>LCTicketComposer+Debug</font>

Public ticket composer entities static instances for test/debugging purpose.

- test
- testCustomer
- testOrder
- testProduct
- testCart
- testMetaData
- testTicketJson

```swift
    // Returns some LCTicketComposer test instance
    let composer = LCTicketComposer.test
    let customerComposer = LCTicketComposer.testCustomer
```


--

©2022 Lucky Cart


