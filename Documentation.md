
# <font color='#10409F'>Lucky Cart</font>

<b>Lucky Cart Connection engine and Swift API</b>

- Connection Layer and server model
- Public API facade and client model
 
## <font color='#1E72AD'>Availability:</font>

- macOS   : .v11
- iOS     : .v13
- tvOS    : .v14
- watchOS : .v8

## <font color='#1E72AD'>Installation:</font>

### Swift Package:

 Add the <b>LuckyCart</b> Package using xCode

### CocoaPods:

 ```
 pod 'LuckyCart'
 ``` 
 
## <font color='#1E72AD'>Use in Client Application:</font>

1 - Start LuckyCart 

```
// 1 - Configure and start LuckyCart engine
    
let auth = LCAuthorization(key: <authKey>, secret: <secret>)
let luckyCartCustomer = LCCustomer(<id>)
let luckyCartCart = LCCart(<id>)
    
let luckyCart = LuckyCart(authorization: LCAuthorization, 
                          customer: LCCustomer, 
                          cart: LCCart,
                          ticketComposerClosure: {
                          
                              // Generates the ticket that will be sent to LuckyCart

                              // Fill the structures with your information here

                              let customer = LCTicketComposer.LCCustomer()
                              let order = LCTicketComposer.Order()
                              let cart = LCTicketComposer.Cart()

                              // Add any extra information here
                              let metaData = LCTicketComposer.MetaData()
                              
                              return LCTicketComposer(customer: customer, 
                                                              order: order, 
                                                              metaData: metaData, 
                                                              cart: cart)
                            })
                            

```


## <font color='#1E72AD'>Author:</font>

©2022 Lucky Cart


