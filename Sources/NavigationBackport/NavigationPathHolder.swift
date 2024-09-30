import Foundation
import Perception
import SwiftUI

/// An object that publishes changes to the path Array it holds.
@Perceptible
final class NavigationPathHolder {
    var path: [AnyHashable]
    
    init(path: [AnyHashable] = []) {
        self.path = path
    }
}
