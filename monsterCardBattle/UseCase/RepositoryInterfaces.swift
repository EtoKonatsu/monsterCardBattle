import Foundation

protocol MonsterCardRepositoryProtocol {
    func fetchStarterDeck() -> [MonsterData]
}

protocol EnemyRepositoryProtocol {
    func fetchBossEnemy() -> EnemyData
}

protocol PlayerRepositoryProtocol {
    func createDefaultPlayer(maxHP: Int) -> PlayerData
}
