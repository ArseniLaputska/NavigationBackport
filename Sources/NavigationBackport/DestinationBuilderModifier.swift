import Foundation
import Perception
import SwiftUI

/// Modifier for appending a new destination builder.
struct DestinationBuilderModifier<TypedData>: ViewModifier {
    let typedDestinationBuilder: DestinationBuilder<TypedData>
    
    @Environment(DestinationBuilderHolder.self) var destinationBuilder
    
    func body(content: Content) -> some View {
        destinationBuilder.appendBuilder(typedDestinationBuilder)
        
        return content
            .environment(destinationBuilder)
    }
}
