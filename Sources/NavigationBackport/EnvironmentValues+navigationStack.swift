import SwiftUI

struct UseNavigationStackPolicyKey: EnvironmentKey {
    static let defaultValue = UseNavigationStackPolicy.whenAvailable
}

struct IsWithinNavigationStackKey: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    @Entry var useNavigationStack: UseNavigationStackPolicy = {
        UseNavigationStackPolicy.whenAvailable
    }()
    
    @Entry var isWithinNavigationStack: Bool = {
        false
    }()
}
