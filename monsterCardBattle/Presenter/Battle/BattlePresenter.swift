import Foundation
import SwiftUI

protocol BattlePresenterProtocol: ObservableObject {
    var state: BattleViewState { get }
    func selectCard(id: UUID)
    func attack()
    func reset()
}

final class BattlePresenter: BattlePresenterProtocol {
    @Published private(set) var state: BattleViewState
    @Published var isAttackButtonDisabled: Bool = false  // 攻撃ボタン制御用


    private let useCase: BattleUseCaseProtocol
    private let cards: [MonsterData]
    private let basePlayer: PlayerData
    private var player: PlayerData
    private var selectedCardID: UUID?

    private var enemyDamageClearTask: DispatchWorkItem?
    private var playerDamageClearTask: DispatchWorkItem?

    init(
        cards: [MonsterData],
        player: PlayerData,
        useCase: BattleUseCaseProtocol
    ) {
        self.cards = cards
        self.basePlayer = player
        self.player = player
        self.useCase = useCase
        self.selectedCardID = nil

        let initialState = BattlePresenter.makeState(
            snapshot: useCase.currentSnapshot(),
            enemy: useCase.enemy,
            player: player,
            cards: cards,
            selectedCardID: nil,
            enemyDamage: nil,
            playerDamage: nil
        )
        self.state = initialState
    }

    func selectCard(id: UUID) {
        guard selectedCardID != id else { return }
        selectedCardID = id
        publishState(enemyDamage: state.enemyDamagePopup, playerDamage: state.playerDamagePopup)
    }

    func attack() {
        guard !isAttackButtonDisabled else { return }
        guard let selectedID = selectedCardID,
              let card = cards.first(where: { $0.id == selectedID }) else { return }

        isAttackButtonDisabled = true // 🔒 攻撃無効化

        // === ① プレイヤー攻撃 ===
        let playerAction = useCase.playerAttack(using: card)
        player = player.withCurrentHP(playerAction.snapshot.playerHP)

        // 敵HP更新・ダメージ表示（この時点で1回だけ）
        publishState(
            snapshot: playerAction.snapshot,
            enemyDamage: playerAction.enemyDamageTaken,
            playerDamage: nil
        )

        // プレイヤー攻撃ダメージポップアップは0.5秒後に消す
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.clearEnemyDamagePopup()
        }

        // === ② 敵の反撃（もし準備できていれば） ===
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }

            if let enemyAction = self.useCase.enemyAttackIfReady(defendingCard: card) {
                self.player = self.player.withCurrentHP(enemyAction.snapshot.playerHP)

                // 💡 このフェーズでは「敵のダメージ」を再び更新しない
                self.publishState(
                    snapshot: enemyAction.snapshot,
                    enemyDamage: nil,
                    playerDamage: enemyAction.playerDamageTaken
                )

                // 敵攻撃ダメージポップアップを0.5秒後に消す
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.clearPlayerDamagePopup()
                }
            }

            // 攻撃フェーズ完了後にボタンを再度有効化
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isAttackButtonDisabled = false
            }
        }
    }


    func reset() {
        cancelDamageClearTasks()
        let snapshot = useCase.reset()
        player = basePlayer
        selectedCardID = nil
        publishState(snapshot: snapshot, enemyDamage: nil, playerDamage: nil)
    }

    // MARK: - Private

    private func publishState(
        snapshot: BattleSnapshot? = nil,
        enemyDamage: Int?,
        playerDamage: Int?
    ) {
        let snapshotValue = snapshot ?? useCase.currentSnapshot()
        let enemy = useCase.enemy
        state = BattlePresenter.makeState(
            snapshot: snapshotValue,
            enemy: enemy,
            player: player,
            cards: cards,
            selectedCardID: selectedCardID,
            enemyDamage: enemyDamage,
            playerDamage: playerDamage
        )
    }

    private func publishState(enemyDamage: Int?, playerDamage: Int?) {
        publishState(snapshot: nil, enemyDamage: enemyDamage, playerDamage: playerDamage)
    }

    private func scheduleDamageClear() {
        if state.enemyDamagePopup != nil {
            let task = DispatchWorkItem { [weak self] in
                self?.clearEnemyDamagePopup()
            }
            enemyDamageClearTask = task
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: task)
        }

        if state.playerDamagePopup != nil {
            let task = DispatchWorkItem { [weak self] in
                self?.clearPlayerDamagePopup()
            }
            playerDamageClearTask = task
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: task)
        }
    }

    private func cancelDamageClearTasks() {
        enemyDamageClearTask?.cancel()
        playerDamageClearTask?.cancel()
        enemyDamageClearTask = nil
        playerDamageClearTask = nil
    }

    private func clearEnemyDamagePopup() {
        publishState(enemyDamage: nil, playerDamage: state.playerDamagePopup)
    }

    private func clearPlayerDamagePopup() {
        publishState(enemyDamage: state.enemyDamagePopup, playerDamage: nil)
    }

    private static func makeState(
        snapshot: BattleSnapshot,
        enemy: EnemyData,
        player: PlayerData,
        cards: [MonsterData],
        selectedCardID: UUID?,
        enemyDamage: Int?,
        playerDamage: Int?
    ) -> BattleViewState {
        let enemyInfo = BattleViewState.EnemyInfo(
            name: enemy.name,
            level: enemy.level,
            attack: enemy.atk,
            defense: enemy.df,
            maxHP: enemy.maxHP,
            currentHP: snapshot.enemyHP,
            frameColor: Self.color(for: enemy.frameStyle),
            remainingTurnText: "あと\(max(snapshot.enemyTurnCount - 1, 0))ターン",
            isTurnImminent: snapshot.enemyTurnCount <= 1
        )

        let playerInfo = BattleViewState.PlayerInfo(
            name: player.name,
            level: player.level,
            maxHP: player.maxHP,
            currentHP: snapshot.playerHP
        )

        let cardInfos = cards.map { card in
            BattleViewState.CardInfo(
                id: card.id,
                name: card.name,
                attack: card.atk,
                defense: card.df,
                frameColor: Self.color(for: card.frameStyle),
                isSelected: selectedCardID == card.id
            )
        }

        return BattleViewState(
            enemy: enemyInfo,
            player: playerInfo,
            cards: cardInfos,
            enemyDamagePopup: enemyDamage,
            playerDamagePopup: playerDamage,
            result: snapshot.result
        )
    }

    private static func color(for style: CardFrameStyle) -> Color {
        switch style {
        case .aqua:
            return Color(UIColor.cyan)
        case .magenta:
            return Color(UIColor.magenta)
        case .aurora:
            return Color(UIColor.yellow)
        case .crimson:
            return Color.red
        case .emerald:
            return Color.green
        case .gold:
            return Color.yellow
        }
    }
}
