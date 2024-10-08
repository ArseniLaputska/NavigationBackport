import Foundation
import Perception
import SwiftUI

/// Uniquely identifies an instance of a local destination builder.
struct LocalDestinationID: RawRepresentable, Hashable {
    let rawValue: UUID
}

/// Persistent object to hold the local destination ID and remove it when the destination builder is removed.
@Perceptible
final class LocalDestinationIDHolder {
    let id = LocalDestinationID(rawValue: UUID())
    weak var destinationBuilder: DestinationBuilderHolder?
    
    deinit {
        // On iOS 15, there are some extraneous re-renders after LocalDestinationBuilderModifier is removed from
        // the view tree. Dispatching async allows those re-renders to succeed before removing the local builder.
        DispatchQueue.main.async { [destinationBuilder, id] in
            destinationBuilder?.removeLocalBuilder(identifier: id)
        }
    }
}

/// Modifier that appends a local destination builder and ensures the Bool binding is observed and updated.
struct LocalDestinationBuilderModifier: ViewModifier {
    let isPresented: Binding<Bool>
    let builder: () -> AnyView
    
    @State var destinationID = LocalDestinationIDHolder()
    @Environment(DestinationBuilderHolder.self) var destinationBuilder
    @Environment(NavigationPathHolder.self) var pathHolder
    
    func body(content: Content) -> some View {
        destinationBuilder.appendLocalBuilder(identifier: destinationID.id, builder)
        destinationID.destinationBuilder = destinationBuilder
        
        return content
            .environment(destinationBuilder)
            .onChange(of: pathHolder.path) { _ in
                if isPresented.wrappedValue {
                    if !pathHolder.path.contains(where: { ($0 as? LocalDestinationID) == destinationID.id }) {
                        isPresented.wrappedValue = false
                    }
                }
            }
            .onChange(of: isPresented.wrappedValue) { isPresented in
                if isPresented {
                    pathHolder.path.append(destinationID.id)
                } else {
                    let index = pathHolder.path.lastIndex(where: { ($0 as? LocalDestinationID) == destinationID.id })
                    if let index {
                        pathHolder.path.remove(at: index)
                    }
                }
            }
    }
}
