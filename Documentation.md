
# <font color='#10409F'>Lucky Cart</font>

<b>Lucky Cart Connection engine and Swift API</b>

- Connection Layer and server model
- Public API facade and client model

## <font color='#10409F'>Public API</font>


###LuckyCart.swift

### LuckyCart+Facade.swift

### LuckyCart+Model.swift

### LuckyCart+Requests.swift

### LuckyCart+Types.swift
### LuckyCartClient.swift

## <font color='#707080'>TicketComposer</font>

### LCTicketComposer.swift

### LCTicketComposer+Model.swift

## <font color='#10409F'>Private API</font>

## <font color='#707080'>Networking</font>

### LCAuthorization.swift

### LCNetwork.swift

### LCRequest.swift

### LCServer.swift

## <font color='#707080'>Private Model</font>

### LCServerModel.swift

## <font color='#707080'>Requests</font>

### LCRequest+GetBanner.swift

### LCRequest+GetBannerSpaces.swift

### LCRequest+GetBannerView.swift

### LCRequest+GetGames.swift

### LCRequest+PostCart.swift


## <font color='#10409F'>SwiftUIKit</font>

### LCBannerView.swift

### LCButtonModifier.swift

A button style provided by LuckyCart framework.
This button is used for all interactions in sheets, but can also be used by client application.

```
Button("Close") {
    // Action
}
.modifier(LCButtonModifier(color: .blue))
```
![Image](docImages/button.png)

### LCDebugLensModifier.swift

Displays the LuckyCart errors over the client application interface.<br>To enable it ( only in DEBUG mode ), apply the view modifier to the view you want to host error banner. Typically the window root view.

```swift
@main
struct MyShoppingApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
            .modifier(LCDebugLensModifier())
        }
    }
}
```

![Image](docImages/debugLensModifierScreenshot.png)

### LCGameView.swift

### LCLinkView.swift

### LCViewProtocols.swift

### LCWebView.swift

### View+Window.swift

## <font color='#10409F'>Debug Extensions</font>

### LuckyCart+Debug.swift

### LCServerModel+Debug.swift

### LCTicketComposer+Debug.swift


--

©2022 Lucky Cart


