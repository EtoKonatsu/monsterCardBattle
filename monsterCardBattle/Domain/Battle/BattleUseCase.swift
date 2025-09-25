import Foundation

protocol BattleUseCaseProtocol {
    var enemy: EnemyData { get }
    var playerMaxHP: Int { get }
    func currentSnapshot() -> BattleSnapshot
    func playerAttack(using card: MonsterData) -> BattleActionResult
    func reset() -> BattleSnapshot
}

final class BattleUseCase: BattleUseCaseProtocol {
    private let enemyData: EnemyData
    private let playerMaxHPValue: Int

    private var enemyHP: Int
    private var playerHP: Int
    private var enemyTurnCount: Int
    private var currentResult: BattleResult = .none

    init(enemy: EnemyData, playerMaxHP: Int) {
        self.enemyData = enemy
        self.playerMaxHPValue = playerMaxHP
        self.enemyHP = enemy.maxHP
        self.playerHP = playerMaxHP
        self.enemyTurnCount = enemy.enemyTurn
    }

    var enemy: EnemyData {
        enemyData
    }

    var playerMaxHP: Int {
        playerMaxHPValue
    }

    func currentSnapshot() -> BattleSnapshot {
        BattleSnapshot(
            enemyHP: enemyHP,
            playerHP: playerHP,
            enemyTurnCount: enemyTurnCount,
            result: currentResult
        )
    }

    func playerAttack(using card: MonsterData) -> BattleActionResult {
        guard currentResult == .none else {
            return BattleActionResult(
                snapshot: currentSnapshot(),
                enemyDamageTaken: 0,
                playerDamageTaken: nil,
                enemyWillAttackNext: false
            )
        }

        let attackDamage = BattleCalculation.calculateDamage(
            attackerATK: card.atk,
            defenderDF: enemyData.df
        )
        enemyHP = max(enemyHP - attackDamage, 0)

        if enemyHP <= 0 {
            currentResult = .win
            return BattleActionResult(
                snapshot: currentSnapshot(),
                enemyDamageTaken: attackDamage,
                playerDamageTaken: nil,
                enemyWillAttackNext: false
            )
        }

        let updatedTurn = BattleCalculation.updateEnemyTurn(
            currentCount: enemyTurnCount,
            interval: enemyData.enemyTurn
        )
        enemyTurnCount = updatedTurn.newCount

        var playerDamage: Int? = nil
        var shouldAttackNext = updatedTurn.shouldEnemyAttack

        if updatedTurn.shouldEnemyAttack {
            let enemyDamage = BattleCalculation.calculateEnemyAttack(
                enemyATK: enemyData.atk,
                defendingCardDF: card.df
            )
            playerHP = max(playerHP - enemyDamage, 0)
            playerDamage = enemyDamage
            shouldAttackNext = false

            if playerHP <= 0 {
                currentResult = .lose
            }
        }

        return BattleActionResult(
            snapshot: currentSnapshot(),
            enemyDamageTaken: attackDamage,
            playerDamageTaken: playerDamage,
            enemyWillAttackNext: shouldAttackNext
        )
    }

    func reset() -> BattleSnapshot {
        enemyHP = enemyData.maxHP
        playerHP = playerMaxHPValue
        enemyTurnCount = enemyData.enemyTurn
        currentResult = .none
        return currentSnapshot()
    }
}
