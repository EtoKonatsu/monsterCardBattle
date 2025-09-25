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

    private let monsterRepository: MonsterCardRepositoryProtocol
    private let enemyRepository: EnemyRepositoryProtocol
    private let playerRepository: PlayerRepositoryProtocol
    private let useCase: BattleUseCaseProtocol
    private var player: PlayerData
    private var cards: [MonsterData]
    private var selectedCardID: UUID?

    private var enemyDamageClearTask: DispatchWorkItem?
    private var playerDamageClearTask: DispatchWorkItem?

    init(
        monsterRepository: MonsterCardRepositoryProtocol,
        enemyRepository: EnemyRepositoryProtocol,
        playerRepository: PlayerRepositoryProtocol,
        useCaseBuilder: (EnemyData, Int) -> BattleUseCaseProtocol = { BattleUseCase(enemy: $0, playerMaxHP: $1) }
    ) {
        self.monsterRepository = monsterRepository
        self.enemyRepository = enemyRepository
        self.playerRepository = playerRepository

        let cards = monsterRepository.fetchStarterDeck()
        let enemy = enemyRepository.fetchBossEnemy()
        let totalHP = cards.reduce(0) { $0 + $1.hp }
        let player = playerRepository.createDefaultPlayer(maxHP: totalHP)
        let useCase = useCaseBuilder(enemy, player.maxHP)

        self.cards = cards
        self.player = player
        self.useCase = useCase
        self.selectedCardID = nil

        let initialState = BattlePresenter.makeState(
            snapshot: useCase.currentSnapshot(),
            enemy: enemy,
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
        guard let selectedID = selectedCardID,
              let card = cards.first(where: { $0.id == selectedID }) else {
            return
        }

        let actionResult = useCase.playerAttack(using: card)
        player = player.withCurrentHP(actionResult.snapshot.playerHP)
        cancelDamageClearTasks()
        publishState(
            snapshot: actionResult.snapshot,
            enemyDamage: actionResult.enemyDamageTaken,
            playerDamage: actionResult.playerDamageTaken
        )
        scheduleDamageClear()
    }

    func reset() {
        cancelDamageClearTasks()
        let snapshot = useCase.reset()
        player = playerRepository.createDefaultPlayer(maxHP: useCase.playerMaxHP)
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
