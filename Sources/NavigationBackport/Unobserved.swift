import SwiftUI
import Perception

/// A wrapper that allows access to an observable object without publishing its changes.
@Perceptible
final class Unobserved<Object: Perceptible> {
    let object: Object
    
    init(object: Object) {
        self.object = object
    }
}
