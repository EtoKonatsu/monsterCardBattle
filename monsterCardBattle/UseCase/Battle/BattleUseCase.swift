import Foundation

protocol BattleUseCaseProtocol {
    var enemy: EnemyData { get }
    var playerMaxHP: Int { get }
    func currentSnapshot() -> BattleSnapshot
    func playerAttack(using card: MonsterData) -> BattleActionResult
    func enemyAttackIfReady(defendingCard: MonsterData) -> BattleActionResult?
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

    var enemy: EnemyData { enemyData }
    var playerMaxHP: Int { playerMaxHPValue }

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
            return BattleActionResult(snapshot: currentSnapshot(), enemyDamageTaken: 0, playerDamageTaken: nil, enemyWillAttackNext: false)
        }

        // 敵にダメージを与える
        let attackDamage = BattleCalculation.calculateDamage(attackerATK: card.atk, defenderDF: enemyData.df)
        enemyHP = max(enemyHP - attackDamage, 0)

        // 敵が倒れた場合
        if enemyHP <= 0 {
            currentResult = .win
        }

        // 💡 プレイヤー攻撃時はターンを減らさない
        return BattleActionResult(
            snapshot: currentSnapshot(),
            enemyDamageTaken: attackDamage,
            playerDamageTaken: nil,
            enemyWillAttackNext: false
        )
    }

    func enemyAttackIfReady(defendingCard: MonsterData) -> BattleActionResult? {
        guard currentResult == .none else { return nil }

        // ターンを1減らす
        enemyTurnCount -= 1

        // 💡 ターンがまだ残っている場合はここで更新を返す（HPは変わらない）
        guard enemyTurnCount <= 0 else {
            return BattleActionResult(
                snapshot: currentSnapshot(),
                enemyDamageTaken: 0,
                playerDamageTaken: nil,
                enemyWillAttackNext: false
            )
        }

        // ターン0 → 攻撃実行
        let enemyDamage = BattleCalculation.calculateEnemyAttack(
            enemyATK: enemyData.atk,
            defendingCardDF: defendingCard.df
        )

        playerHP = max(playerHP - enemyDamage, 0)

        // 💡 攻撃後にターンをリセット
        enemyTurnCount = enemyData.enemyTurn

        if playerHP <= 0 {
            currentResult = .lose
        }

        return BattleActionResult(
            snapshot: currentSnapshot(),
            enemyDamageTaken: 0,
            playerDamageTaken: enemyDamage,
            enemyWillAttackNext: false
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
