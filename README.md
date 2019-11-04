# KeyboardObserver

Keyboard-aware helpers for SwiftUI.

## `.avoidingKeyboard()`

This is the simplest way to make UI keyboard-aware. It automatically insets all children to account for the keyboard:

```swift
VStack {
    Text("Hello, world!")
    TextField("Title", text: $text)
}
.frame(maxWidth: .infinity, maxHeight: .infinity)
.avoidingKeyboard()
```

## `.observingKeyboard(_:)`

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

## `.onKeyboardChange(_:)`

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
