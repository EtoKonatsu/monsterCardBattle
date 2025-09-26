import SwiftUI

typealias BattlePresenterFactory = () -> BattlePresenter

private struct BattlePresenterFactoryKey: EnvironmentKey {
    static let defaultValue: BattlePresenterFactory = {
        fatalError("BattlePresenterFactory is not configured. Provide a factory via environment.")
    }
}

extension EnvironmentValues {
    var battlePresenterFactory: BattlePresenterFactory {
        get { self[BattlePresenterFactoryKey.self] }
        set { self[BattlePresenterFactoryKey.self] = newValue }
    }
}
