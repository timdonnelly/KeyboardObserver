import SwiftUI

// Represents the current state of the system keyboard.
public struct KeyboardState: Equatable {
    
    public init(frame: CGRect? = nil) {
        self.frame = frame
    }
    
    // The keyboard frame in global (screen) coordinates
    public var frame: CGRect?
    
    // Returns the keyboard height relative to the bottom of the view
    // represented by the given geometry proxy.
    public func height(in proxy: GeometryProxy) -> CGFloat {
        if let frame = frame, proxy.frame(in: .global).intersects(frame) {
            return proxy.frame(in: .global).maxY - frame.minY
        } else {
            return 0.0
        }
    }
    
}
