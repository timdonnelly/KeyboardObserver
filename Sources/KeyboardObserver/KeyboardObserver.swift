import SwiftUI
import Combine

extension View {
    
    // Calls the provided action when the system keyboard changes.
    public func onKeyboardChange(_ action: @escaping (KeyboardState, Animation?) -> Void) -> some View {
        KeyboardObserverView(content: self, action: action)
    }
    
    // Updates the provided keyboard state when the system keyboard changes.
    // The change is performed with an animation that matches the duration
    // and timing of the keyboard transition animation.
    public func observingKeyboard(_ state: Binding<KeyboardState>) -> some View {
        onKeyboardChange { newState, animation in
            withAnimation(animation) {
                state.wrappedValue = newState
            }
        }
        
    }
    
}

fileprivate struct KeyboardObserverView<Content: View>: View {
    
    var content: Content
    var action: (KeyboardState, Animation?) -> Void
    
    var body: some View {
        content.onReceive(publisher, perform: handle(keyboardNotification:))
    }
    
    private var publisher: AnyPublisher<Notification, Never> {
        NotificationCenter
            .default
            .publisher(for: UIResponder.keyboardWillChangeFrameNotification)
            .eraseToAnyPublisher()
    }
    
    private func handle(keyboardNotification: Notification) {
        guard let userInfo = keyboardNotification.userInfo else { return }
        let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        let animation = Animation(keyboardNotification: keyboardNotification)
        action(KeyboardState(frame: frame), animation)
    }
    
}



extension Animation {
    
    fileprivate init?(keyboardNotification: Notification) {
        guard let userInfo = keyboardNotification.userInfo else { return nil }
        
        guard let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue, duration > 0.0 else { return nil }

        if let rawAnimationCurve = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue,
            let animationCurve = UIView.AnimationCurve(rawValue: rawAnimationCurve) {
            switch animationCurve {
            case .easeIn:
                self = .easeIn(duration: duration)
            case .easeOut:
                self = .easeOut(duration: duration)
            case .linear:
                self = .linear(duration: duration)
            case .easeInOut:
                self = .easeInOut(duration: duration)
            @unknown default:
                // The 'hidden' private keyboard curve is the integer 7, which does not
                // map to a known case. @unknown default handles this nicely.
                self = .systemKeyboardAnimation
            }
        } else {
            self = .systemKeyboardAnimation
        }
    }
    
    // These values are used with a CASpringAnimation to drive the default
    // system keyboard animation as of iOS 13.
    fileprivate static var systemKeyboardAnimation: Animation {
        .interpolatingSpring(mass: 3, stiffness: 1000, damping: 500, initialVelocity: 0.0)
    }
    
}
