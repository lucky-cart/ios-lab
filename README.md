# LuckyCartSDK

Lucky Cart iOS SDK is a Framework to implement Lucky Cart Services into your shopping App.

## Installation

The package is a Swift Package that you can include into your projet

On your Xcode Menu clic on "File" and "Add Packages ..." 
In the search field you can paste the Github repo URL to add the Package into your Project.

## Dependencies

LuckyCart uses [SDWebImage](https://github.com/SDWebImage/SDWebImage) to upload and display banner images. 

## How to use it

### Workflow for using Lucky Cart

![Lucky Cart Workflow](./luckycart-workflow.png)

When your identified customer navigate into your market place, at the openning of the homepage or categories pages you can send an PageViewed Event. once the Event's completion block is called, you can request for a single banner or a list of banners. It is then up to you to integrate the banner view into your page and configure it.

Once the customer has placed an order, you can send a CartValidated event. Once the response is received, you can request a game experience from Lucky Cart. A completion block will inform you of the template to send to the banner view in order to give your customer access to the game.

### Configuration

Into the AppDelegate you have to set your SiteKey to access to Lucky Cart API

```
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        LuckyCart.shared.setSiteKey("siteKeyToken")
        ....
        return true
    }
```
At the customer login you have to set the user to allowed Lucky Cart to send you banners or games experiences. 

```
LuckyCart.shared.setUser(customerId)
```

**To use Lucky Cart, you have to set your siteKey and the user identifier.**


It's possible to configure some other parameters of the SDK like the number of retries, delay beween each retry and base URL for Lucky Cart's APIs.

```
LuckCart.shared.configuration.apiRetries = 5 //Int
LuckCart.shared.configuration.apiRetryDelay = 0.5 //Double
LuckCart.shared.configuration.eventBaseUrl = "https://shopper-events.luckycart.com/v1" //String
LuckCart.shared.configuration.displayerBaseUrl = "https://displayer.luckycart.com" //String
LuckCart.shared.configuration.gameBaseUrl = "https://game-experience-api.luckycart.com/v1" //String
```
 
### Single banner experience

#### PageViewed Event

Event to be sent at each page opening of your store or those you will have chosen.

You will need to fill in your payload to call this function as follows (you can find implementation exemple with the sample app) :

```
// Exemple for a homepage 
let payload = LCEventPayload(pageType: "Homepage", 
							storeType: "1234", 
							  storeId: "sup")

LuckyCart.shared.sendShopperEvent(eventName: .pageViewed, 
										   payload: payload) { [weak self] eventSended in
     // Do something
}

// Exemple for a category page
let payload = LCEventPayload(pageType: "categories", 
								pageId: "id100", 
								storeType: "1234", 
								storeId: "sup")
LuckyCart.shared.sendShopperEvent(eventName: .pageViewed, 
									payload: payload) { [weak self] eventSended in
    // Do Something
}
									 
```

#### Request the banner data

After sending a PageViewed event, you can request a banner to display on your page with the following function:

```
LuckyCart.shared.getBannerExperienceDetail(pageType: pageType,
                                                   format: "banner",
                                                   pageId: pageId,
                                                   store: storeId,
                                               storeType: storeType) { [weak self] bannerExperience in
    // This block is executing when you receive the banner data 
    // that you have to forward to the bannerView
}
```

#### display the banner

To display the banner on your page you can use the LCBannerView. It can be used as a simple view, a TableViewCell or a CollectionViewCell.


```
let bannerView = LCBannerView.load(owner: self)
bannerView.storeId = storeId
bannerView.storeType = storeType
bannerView.pageId = pageId
bannerView.pageType = pageType
bannerView.bannerExperience = singleBannerExperience

// In a Table View implementation
tableView.register(LCContainerCell.self, 
					forCellReuseIdentifier: LCBannerView.identifier())
let cell = bannerView.dequeue(tableView, indexPath)

// In a Collection View implementation
collectionView.register(LCContainerCollectionViewCell.self, 
						forCellReuseIdentifier: LCBannerView.identifier())
let cell = bannerView.dequeue(collectionView, indexPath)
```

Depending on your implementation, you should refresh your layout to show the banner view. It is possible to receive a Notification to update the interface.

```
NotificationCenter.default.addObserver(self,
                                       selector: #selector(reloadViews(_:)),
                                       name: NSNotification.Name("LuckyCartBannerImageLoadedNotification"),
                                       object: nil)
// Exemple for TableView
@objc
func reloadViews(_ notification: Notification) {
    self.tableView.beginUpdates()
    self.tableView.setNeedsDisplay()
    self.tableView.endUpdates()
}

```

The BannerView will itself send the BannerViewed and BannerClicked events to Lucky Cart. For this, it is important to give the right values storeId, storeType, pageId and pageType.

#### Navigation

When clicking on a banner, it is possible to redirect the user to a landing page of your store. Since navigation is dependent on the technical implementation of your application, Lucky Cart has chosen to notify the host application to let it manage the navigation. 

Here is an example of management: 

```
NotificationCenter.default.addObserver(self,
                                   selector: #selector(inShopAction(_:)),
                                   name: NSNotification.Name("LuckyCartBannerInShopAction"),
                                   object: nil)
// The notification will send a userInfo dictionary 
// with "shopInShopRedirectMobile" key and a string value                               
@objc
func inShopAction(_ notification: Notification) {
	guard let dict = notification.userInfo,
	      let inShopPath = dict["shopInShopRedirectMobile"] as? String,
	isVisible() else { return }
	    
	if inShopPath == "query_200" {
	    //Open the destination page
	}
	else if inShopPath == "query_100" {
	    //Open the destination page
	}
}
```

### Multiple banners experience

#### PageViewed Event

Event to be sent at each page opening of your store or those you will have chosen.

You will need to fill in your payload to call this function as follows (you can find implementation exemple with the sample app) :

```
// Exemple for a homepage 
let payload = LCEventPayload(pageType: "Homepage", 
							storeType: "1234", 
							  storeId: "sup")

LuckyCart.shared.sendShopperEvent(eventName: .pageViewed, 
										   payload: payload) { [weak self] eventSended in
     // Do something
}

// Exemple for a category page
let payload = LCEventPayload(pageType: "categories", 
								pageId: "id100", 
								storeType: "1234", 
								storeId: "sup")
LuckyCart.shared.sendShopperEvent(eventName: .pageViewed, 
									payload: payload) { [weak self] eventSended in
    // Do Something
}
									 
```

#### Request the banners list data

After sending a PageViewed event, you can request a list of banners to display on your page with the following function:

```
LuckyCart.shared.getBannersExperience(pageType: pageType,
                                                   format: "banner",
                                                   pageId: pageId,
                                                   store: storeId,
                                               storeType: storeType) { [weak self] bannerExperiences in
    // This block is executing when you receive the array of banner data 
    // that you have to forward to the bannersView
}
```

#### display the banners list

To display the list of banners on your page you can use the LCBannersView. It can be used as a simple view, a TableViewCell or a CollectionViewCell.

```
let bannersView = LCBannersView.load(owner: self)
bannersView.storeId = storeId
bannersView.storeType = storeType
bannersView.pageId = pageId
bannersView.pageType = pageType
bannersView.bannerExperiences = multipleBannerExperiences

// In a Table View implementation
tableView.register(LCContainerCell.self, 
					forCellReuseIdentifier: LCBannersView.identifier())
let cell = bannersView.dequeue(tableView, indexPath)

// In a Collection View implementation
collectionView.register(LCContainerCollectionViewCell.self, 
						forCellReuseIdentifier: LCBannersView.identifier())
let cell = bannersView.dequeue(collectionView, indexPath)
```

Depending on your implementation, you should refresh your layout to show the banner view. It is possible to receive a Notification to update the interface.

```
NotificationCenter.default.addObserver(self,
                                       selector: #selector(reloadViews(_:)),
                                       name: NSNotification.Name("LuckyCartBannerImageLoadedNotification"),
                                       object: nil)
```

The BannersView will itself send the BannerViewed and BannerClicked events to Lucky Cart for each banner. For this, it is important to give the right values storeId, storeType, pageId and pageType. 

#### Navigation

When clicking on a banner, it is possible to redirect the user to a landing page of your store. Since navigation is dependent on the technical implementation of your application, Lucky Cart has chosen to notify the host application to let it manage the navigation. 

Here is an example of management: 

```
NotificationCenter.default.addObserver(self,
                                   selector: #selector(inShopAction(_:)),
                                   name: NSNotification.Name("LuckyCartBannerInShopAction"),
                                   object: nil)
// The notification will send a userInfo dictionary 
// with "shopInShopRedirectMobile" key and a string value                               
@objc
func inShopAction(_ notification: Notification) {
	guard let dict = notification.userInfo,
	      let inShopPath = dict["shopInShopRedirectMobile"] as? String,
	isVisible() else { return }
	    
	if inShopPath == "query_200" {
	    //Open the destination page
	}
	else if inShopPath == "query_100" {
	    //Open the destination page
	}
}
```

### Game experience

#### CartValidated Event

Event to be sent following the payment of the cart so that Lucky Cart generates the game corresponding to the customer's order.

You will need to fill in your payload to call this function as follows (you can find implementation exemple with the sample app) :

```
let payload = Cart.shared.cartToLuckyCartPayload() 
            LuckyCart.shared.sendShopperEvent(eventName: .cartValidated, 
            									payload: payload) { eventSended in
     // Do Something
}

// Exemple of convertion function of cart

func cartToLuckyCartPayload() -> LCEventPayload {
    var payload = LCEventPayload()
    payload.cartId = cartId
    payload.currency = "EUR"
    payload.device = "iPhone12.2"
    payload.finalAtiAmount = finalAtiAmount
    payload.deliveryAtiAmount = 0.0
    payload.deliveryTfAmount = 0.0
    
    var payloadProducts: [LCEventPayloadProduct] = []
    
    if let products = products {
        for product in products {
            let p = LCEventPayloadProduct(productId: product.productId,
                                          unitAtiAmount: product.unitAtiAmount,
                                          unitTfAmount: product.unitTfAmount,
                                          finalAtiAmount: product.finalAtiAmount,
                                          finalTfAmount: product.finalTfAmount,
                                          discountAtiAmount: product.discountAtiAmount,
                                          discountTfAmount: product.discountTfAmount,
                                          quantity: product.quantity,
                                          category: product.category,
                                          brand: product.brand,
                                          ean: product.ean)
            payloadProducts.append(p)
        }
    }
    
    payload.products = payloadProducts
    
    return payload
}
```

#### Request the Game Experiences

After sending a CartValidated event, you can request a Game Experience to display on your payement validation page with the following function:

```
let gameFilter = LCGameFilter(filters: [
                    LCFilter(filterProperty: "cartId",
                             filterValue: Cart.shared.cartId)
                ])
LuckyCart.shared.getGamesAccess(filters: gameFilter) { [weak self] gamesExperiences in
    // This block is executing when you receive the array of game data 
    // that you have to forward one to the bannerView
    // by default this request ask for only one experience
}
```

#### Display the game experience

The Game Experience is like presenting a banner to the user but the action will be different with the opening of a webview containing the game for the client.
To display the banner on your page you can use the LCBannerView. It can be used as a simple view, a TableViewCell or a CollectionViewCell.

```
let bannerView = LCBannerView.load(owner: self)
bannerView.gameExperience = gameExperience
bannerView.parentViewController = self

// In a Table View implementation
tableView.register(LCContainerCell.self, 
					forCellReuseIdentifier: LCBannerView.identifier())
let cell = bannerView.dequeue(tableView, indexPath)

// In a Collection View implementation
collectionView.register(LCContainerCollectionViewCell.self, 
						forCellReuseIdentifier: LCBannerView.identifier())
let cell = bannerView.dequeue(collectionView, indexPath)
```
Depending on your implementation, you should refresh your layout to show the banner view. It is possible to receive a Notification to update the interface.

```
NotificationCenter.default.addObserver(self,
                                       selector: #selector(reloadViews(_:)),
                                       name: NSNotification.Name("LuckyCartBannerImageLoadedNotification"),
                                       object: nil)
// Exemple for TableView
@objc
func reloadViews(_ notification: Notification) {
    self.tableView.beginUpdates()
    self.tableView.setNeedsDisplay()
    self.tableView.endUpdates()
}

```
The BannerView with gameExperience model will itself open the game in a modal page over the current page.

### Sample App

You can find the Lucky Cart Sample App for iOS at [https://github.com/lucky-cart/lucky-cart-client-sample-ios](https://github.com/lucky-cart/lucky-cart-client-sample-ios)

**Thank you to use Lucky Cart**

