import SwiftUI

extension View {
    
    public func avoidingKeyboard() -> some View {
        KeyboardAvoidingView(content: self)
    }
    
}

fileprivate struct KeyboardAvoidingView<Content: View>: View {
    
    var content: Content
    
    @State var state = KeyboardState()
    
    var body: some View {
        GeometryReader { proxy in
            self.content.padding(.bottom, self.state.height(in: proxy))
        }
        .observingKeyboard(self.$state)
    }
    
}
