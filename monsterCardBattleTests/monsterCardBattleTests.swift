//
//  monsterCardBattleTests.swift
//  monsterCardBattleTests
//
//  Created by 江藤小夏 on 2025/09/16.
//

import Testing
@testable import monsterCardBattle

// MARK: - BattleCalculation Tests

struct BattleCalculationTests {

    @Test func ダメージ計算_ATKがDFより大きい場合() {
        let damage = BattleCalculation.calculateDamage(attackerATK: 13, defenderDF: 5)
        #expect(damage == 8)
    }

    @Test func ダメージ計算_ATKがDFより小さい場合は0() {
        let damage = BattleCalculation.calculateDamage(attackerATK: 3, defenderDF: 10)
        #expect(damage == 0)
    }

    @Test func ダメージ計算_ATKとDFが同じ場合は0() {
        let damage = BattleCalculation.calculateDamage(attackerATK: 10, defenderDF: 10)
        #expect(damage == 0)
    }

    @Test func 敵攻撃ダメージ計算() {
        let damage = BattleCalculation.calculateEnemyAttack(enemyATK: 13, defendingCardDF: 5)
        #expect(damage == 8)
    }

    @Test func ターン更新_まだ攻撃しない() {
        let result = BattleCalculation.updateEnemyTurn(currentCount: 3, interval: 4)
        #expect(result.newCount == 2)
        #expect(result.shouldEnemyAttack == false)
    }

    @Test func ターン更新_攻撃してリセット() {
        let result = BattleCalculation.updateEnemyTurn(currentCount: 1, interval: 4)
        #expect(result.newCount == 4)
        #expect(result.shouldEnemyAttack == true)
    }
}

// MARK: - BattleUseCase Tests

struct BattleUseCaseTests {

    private func makeEnemy(maxHP: Int = 50, atk: Int = 13, df: Int = 5, enemyTurn: Int = 4) -> EnemyData {
        EnemyData(
            name: "テスト敵",
            level: 5,
            atk: atk,
            df: df,
            maxHP: maxHP,
            currentHP: maxHP,
            enemyTurn: enemyTurn,
            frameStyle: .emerald
        )
    }

    private func makeCard(atk: Int = 13, df: Int = 5) -> MonsterData {
        MonsterData(name: "テストカード", atk: atk, df: df, hp: 10, frameStyle: .aqua)
    }

    @Test func 初期スナップショット() {
        let enemy = makeEnemy(maxHP: 50)
        let useCase = BattleUseCase(enemy: enemy, playerMaxHP: 30)
        let snapshot = useCase.currentSnapshot()

        #expect(snapshot.enemyHP == 50)
        #expect(snapshot.playerHP == 30)
        #expect(snapshot.enemyTurnCount == 4)
        #expect(snapshot.result == .none)
    }

    @Test func プレイヤー攻撃で敵HPが減る() {
        let enemy = makeEnemy(maxHP: 50, df: 5)
        let useCase = BattleUseCase(enemy: enemy, playerMaxHP: 30)
        let card = makeCard(atk: 13) // ダメージ = 13 - 5 = 8

        let result = useCase.playerAttack(using: card)

        #expect(result.enemyDamageTaken == 8)
        #expect(result.snapshot.enemyHP == 42)
        #expect(result.snapshot.result == .none)
    }

    @Test func プレイヤー攻撃で敵を倒すとwin() {
        let enemy = makeEnemy(maxHP: 5, df: 0)
        let useCase = BattleUseCase(enemy: enemy, playerMaxHP: 30)
        let card = makeCard(atk: 10)

        let result = useCase.playerAttack(using: card)

        #expect(result.snapshot.enemyHP == 0)
        #expect(result.snapshot.result == .win)
    }

    @Test func 敵のターンが来るまで攻撃しない() {
        let enemy = makeEnemy(enemyTurn: 4)
        let useCase = BattleUseCase(enemy: enemy, playerMaxHP: 30)
        let card = makeCard()

        // ターン4 → 3 (攻撃しない)
        let result = useCase.enemyAttackIfReady(defendingCard: card)

        #expect(result != nil)
        #expect(result!.playerDamageTaken == nil)
        #expect(result!.snapshot.enemyTurnCount == 3)
    }

    @Test func 敵のターンが0になったら攻撃する() {
        let enemy = makeEnemy(atk: 13, enemyTurn: 1)
        let useCase = BattleUseCase(enemy: enemy, playerMaxHP: 30)
        let card = makeCard(df: 5) // 敵ダメージ = 13 - 5 = 8

        let result = useCase.enemyAttackIfReady(defendingCard: card)

        #expect(result != nil)
        #expect(result!.playerDamageTaken == 8)
        #expect(result!.snapshot.playerHP == 22)
    }

    @Test func 敵攻撃でプレイヤーHPが0になるとlose() {
        let enemy = makeEnemy(atk: 100, df: 0, enemyTurn: 1)
        let useCase = BattleUseCase(enemy: enemy, playerMaxHP: 10)
        let card = makeCard(df: 0)

        let result = useCase.enemyAttackIfReady(defendingCard: card)

        #expect(result != nil)
        #expect(result!.snapshot.playerHP == 0)
        #expect(result!.snapshot.result == .lose)
    }

    @Test func 勝利後は攻撃できない() {
        let enemy = makeEnemy(maxHP: 1, df: 0)
        let useCase = BattleUseCase(enemy: enemy, playerMaxHP: 30)
        let card = makeCard(atk: 10)

        // 1回目で倒す
        _ = useCase.playerAttack(using: card)

        // 2回目は無効
        let result = useCase.playerAttack(using: card)
        #expect(result.enemyDamageTaken == 0)
    }

    @Test func リセットで初期状態に戻る() {
        let enemy = makeEnemy(maxHP: 50)
        let useCase = BattleUseCase(enemy: enemy, playerMaxHP: 30)
        let card = makeCard(atk: 10)

        _ = useCase.playerAttack(using: card)
        let snapshot = useCase.reset()

        #expect(snapshot.enemyHP == 50)
        #expect(snapshot.playerHP == 30)
        #expect(snapshot.result == .none)
    }

    @Test func 敵攻撃後にターンがリセットされる() {
        let enemy = makeEnemy(enemyTurn: 1)
        let useCase = BattleUseCase(enemy: enemy, playerMaxHP: 100)
        let card = makeCard()

        // ターン1 → 0 → 攻撃 → ターン4にリセット
        _ = useCase.enemyAttackIfReady(defendingCard: card)
        let snapshot = useCase.currentSnapshot()

        #expect(snapshot.enemyTurnCount == 4)
    }
}

// MARK: - Repository Tests

struct RepositoryTests {

    @Test func モンスターカードリポジトリはカード3枚を返す() {
        let repo = MonsterCardRepository()
        let cards = repo.fetchStarterDeck()

        #expect(cards.count == 3)
        #expect(cards[0].name == "カードA")
        #expect(cards[1].name == "カードB")
        #expect(cards[2].name == "カードC")
    }

    @Test func 各カードのステータスが正しい() {
        let repo = MonsterCardRepository()
        let cards = repo.fetchStarterDeck()

        // カードA: ATK高め
        #expect(cards[0].atk == 13)
        #expect(cards[0].df == 5)
        #expect(cards[0].frameStyle == .aqua)

        // カードB: DF高め
        #expect(cards[1].atk == 5)
        #expect(cards[1].df == 12)
        #expect(cards[1].frameStyle == .magenta)

        // カードC: バランス型
        #expect(cards[2].atk == 10)
        #expect(cards[2].df == 10)
        #expect(cards[2].frameStyle == .aurora)
    }

    @Test func 敵リポジトリはドラゴンを返す() {
        let repo = EnemyRepository()
        let enemy = repo.fetchBossEnemy()

        #expect(enemy.name == "ドラゴン")
        #expect(enemy.level == 8)
        #expect(enemy.maxHP == 50)
        #expect(enemy.atk == 13)
        #expect(enemy.df == 5)
        #expect(enemy.enemyTurn == 4)
    }

    @Test func プレイヤーリポジトリはデフォルトプレイヤーを生成() {
        let repo = PlayerRepository()
        let player = repo.createDefaultPlayer(maxHP: 30)

        #expect(player.name == "こなこな")
        #expect(player.level == 1)
        #expect(player.maxHP == 30)
        #expect(player.currentHP == 30)
    }

    @Test func クエストリポジトリは4つのクエストを返す() {
        let repo = QuestRepository()
        let quests = repo.fetchQuests()

        #expect(quests.count == 4)
        #expect(quests[0].level == .easy)
        #expect(quests[1].level == .normal)
        #expect(quests[2].level == .hard)
        #expect(quests[3].level == .extreme)
    }
}

// MARK: - BattlePresenter Tests

struct BattlePresenterTests {

    private func makePresenter() -> BattlePresenter {
        let cards = [
            MonsterData(name: "テストカードA", atk: 10, df: 5, hp: 10, frameStyle: .aqua),
            MonsterData(name: "テストカードB", atk: 5, df: 10, hp: 10, frameStyle: .magenta),
        ]
        let player = PlayerData(name: "テスト", level: 1, maxHP: 20, currentHP: 20)
        let enemy = EnemyData(
            name: "テスト敵",
            level: 3,
            atk: 8,
            df: 3,
            maxHP: 30,
            currentHP: 30,
            enemyTurn: 4,
            frameStyle: .emerald
        )
        let useCase = BattleUseCase(enemy: enemy, playerMaxHP: 20)
        return BattlePresenter(cards: cards, player: player, useCase: useCase)
    }

    @Test @MainActor func 初期状態が正しい() {
        let presenter = makePresenter()

        #expect(presenter.state.enemy.name == "テスト敵")
        #expect(presenter.state.enemy.level == 3)
        #expect(presenter.state.enemy.maxHP == 30)
        #expect(presenter.state.player.name == "テスト")
        #expect(presenter.state.player.maxHP == 20)
        #expect(presenter.state.cards.count == 2)
        #expect(presenter.state.result == .none)
        #expect(presenter.isAttackButtonDisabled == false)
    }

    @Test @MainActor func カード選択で状態が更新される() {
        let presenter = makePresenter()
        let cardID = presenter.state.cards[0].id

        presenter.selectCard(id: cardID)

        #expect(presenter.state.cards[0].isSelected == true)
        #expect(presenter.state.cards[1].isSelected == false)
    }

    @Test @MainActor func カード未選択で攻撃しても何も起きない() {
        let presenter = makePresenter()
        let initialHP = presenter.state.enemy.currentHP

        presenter.attack()

        #expect(presenter.state.enemy.currentHP == initialHP)
    }

    @Test @MainActor func 攻撃するとボタンが無効化される() {
        let presenter = makePresenter()
        let cardID = presenter.state.cards[0].id
        presenter.selectCard(id: cardID)

        presenter.attack()

        #expect(presenter.isAttackButtonDisabled == true)
    }

    @Test @MainActor func リセットで初期状態に戻る() {
        let presenter = makePresenter()
        let cardID = presenter.state.cards[0].id
        presenter.selectCard(id: cardID)
        presenter.attack()

        presenter.reset()

        #expect(presenter.state.enemy.currentHP == 30)
        #expect(presenter.state.player.currentHP == 20)
        #expect(presenter.state.result == .none)
    }
}

// MARK: - Domain Model Tests

struct DomainModelTests {

    @Test func PlayerDataのwithCurrentHPでHP更新コピーを生成() {
        let player = PlayerData(name: "テスト", level: 1, maxHP: 30, currentHP: 30)
        let updated = player.withCurrentHP(20)

        #expect(updated.currentHP == 20)
        #expect(updated.name == "テスト")
        #expect(updated.maxHP == 30)
    }

    @Test func CardFrameStyleの全ケースが存在する() {
        let allCases = CardFrameStyle.allCases
        #expect(allCases.count == 6)
        #expect(allCases.contains(.aqua))
        #expect(allCases.contains(.magenta))
        #expect(allCases.contains(.aurora))
        #expect(allCases.contains(.crimson))
        #expect(allCases.contains(.emerald))
        #expect(allCases.contains(.gold))
    }

    @Test func DifficultyLevelの表示名が正しい() {
        #expect(DifficultyLevel.easy.displayName == "初級クエスト")
        #expect(DifficultyLevel.normal.displayName == "中級クエスト")
        #expect(DifficultyLevel.hard.displayName == "上級クエスト")
        #expect(DifficultyLevel.extreme.displayName == "超級クエスト")
    }
}
