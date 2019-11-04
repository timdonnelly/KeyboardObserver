# KeyboardObserver

iOS+iPadOS keyboard-aware helpers for SwiftUI.

The SwiftUI API does not (currently) provide any native way to respond to the system keyboard when running on iOS/iPadOS. This library translates keyboard events from the UIKit world (via keyboard-related `Notification`s) into easy-to-integrate SwiftUI extensions. 

## Getting started

Add the `KeyboardObserver` Swift Package as a dependency:

#### Directly to an Xcode Project
`File` > `Swift Packages` > `Add Package Dependency`, then provide the git URL when prompted.

#### As a dependency in a Swift Package

Add an entry to `dependencies` in your package manifest (`Package.swift`)
```swift
dependencies: [
    .package(url: "git@github.com:timdonnelly/KeyboardObserver.git", from: "0.1.2")
]
```

## In Use

Be sure to import the module wherever you will be using it:

```swift
import KeyboardObserver
```

### `.avoidingKeyboard()`

This is the simplest way to make UI keyboard-aware. It automatically insets all children to account for the keyboard:

```swift
VStack {
    Text("Hello, world!")
    TextField("Title", text: $text)
}
.frame(maxWidth: .infinity, maxHeight: .infinity)
.avoidingKeyboard()
```

### `.observingKeyboard(_:)`

The binding provided to `observingKeyboard(_:)` will be assigned with an animation that matches the system keyboard.

```swift
import KeyboardObserver

struct MyView: View {

    @State private var state = KeyboardState()

    var body: some View {
        GeometryReader { proxy in
            VStack {
                Text("Hello, world!")
                TextField("Title", text: self.$text)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom, self.state.height(in: proxy))
        }
        .observingKeyboard($state)
    }

}
```

### `.onKeyboardChange(_:)`

Provide a closure to manually respond to keyboard changes.

```swift
import KeyboardObserver

struct MyView: View {

    var body: some View {
        Text("HelloWorld")
            .onKeyboardChange { state, animation in
                self.handleKeyboardChange(newState: state, animation: animation)
            }
    }
    
    private func handleKeyboardChange(newState: KeyboardState, animation: Animation?) {
        // Handle keyboard changes here (`animation` will be non-nil if the keyboard change is animated)
    }

}
```
