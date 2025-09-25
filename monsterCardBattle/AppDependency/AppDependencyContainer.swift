import Foundation

@MainActor
final class AppDependencyContainer: ObservableObject {
    private let monsterRepository: MonsterCardRepositoryProtocol
    private let enemyRepository: EnemyRepositoryProtocol
    private let playerRepository: PlayerRepositoryProtocol

    init(
        monsterRepository: MonsterCardRepositoryProtocol = MonsterCardRepository(),
        enemyRepository: EnemyRepositoryProtocol = EnemyRepository(),
        playerRepository: PlayerRepositoryProtocol = PlayerRepository()
    ) {
        self.monsterRepository = monsterRepository
        self.enemyRepository = enemyRepository
        self.playerRepository = playerRepository
    }

    func makeBattlePresenter() -> BattlePresenter {
        BattlePresenter(
            monsterRepository: monsterRepository,
            enemyRepository: enemyRepository,
            playerRepository: playerRepository
        )
    }
}
