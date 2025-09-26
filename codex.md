# monsterCardBattle アーキテクチャ改善方針

## 現状の整理
- `Calculation/BattleProcess.swift` が `ObservableObject` として UI 状態（HP、演出テキスト、結果判定）やアニメーション遅延処理まで抱えており、UseCase と View の責務が混在している。
- `BattleProcess` から `EnemyData` / `MonsterData` をそのまま吐き出しており、View 層でそのまま扱う前提になっている。
- `Data/EnemyData.swift` と `Data/MonsterData.swift` が `SwiftUI.Color` を保持し、モデル層が UI 依存になっている。このため永続化やテストが困難。
- `View/Battle/BattleInitView.swift` が `MonsterCardRepository` や `PlayerRepository` を直接参照し、さらに `BattleProcess` を生成している。View がリポジトリと UseCase の組み立てまで担っており層が逆転。
- `Repository/*.swift` がすべて `static let` / `static func` で実装され、プロトコル境界や依存注入ができず差し替えが難しい。
- `PlayerRepository.createBattleProcess` が UseCase (`BattleProcess`) を構築しており、データ層→UseCase への逆依存が発生している。

## 目標アーキテクチャ
```
View (SwiftUI) → Presenter → UseCase → Repository → DataSource
```
- View は Presenter が公開する `ViewState` を監視するだけにし、副作用の実行やリポジトリ呼び出しは行わない。
- Presenter（このプロジェクトでは ViewModel 相当の役割を統合して担う） は UseCase から受け取ったドメインイベントを UI 向けの形式（例: 数値フォーマット、`Color` 変換）に変換する。
- UseCase は純粋なビジネスロジックを担当し、必要なデータアクセスは `Repository` プロトコル経由で行う。View から Repository を直接呼ぶ経路は廃止する。
- Repository は `EnemyRepositoryProtocol` / `MonsterCardRepositoryProtocol` などの抽象で定義し、実装はデータソース（メモリ、JSON、CoreData など）に閉じ込める。
- 依存関係は上位層が下位層の抽象に依存する形で `App` 起動時に組み立てる。

## リファクタリング手順案
1. **ドメインモデルの純化**
   - `EnemyData` / `MonsterData` から `Color` を削除し、属性は enum や ID で表現。
   - `PlayerData` にも UI 依存が入らないよう見直す。
2. **UseCase 層の再設計**
   - 現在の `BattleProcess` を `BattleUseCase`（ロジックのみ）と `BattlePresenter` or `BattleViewModel` に分離。
   - `BattleUseCaseProtocol` を定義し、攻撃やターン進行をメソッド化。結果はイベント/DTO (`BattleEvent`, `BattleSnapshot` など) で返す。
3. **Presenter の導入（ViewModel 役と統合）**
   - `BattlePresenterProtocol` を定義し、UseCase の結果を受けて `@Published BattleViewState` を更新。
   - View は `BattleViewState` を描画し、ユーザー操作は Presenter 経由で UseCase に渡す。
4. **Repository 抽象化と DI**
   - `MonsterCardRepositoryProtocol` / `EnemyRepositoryProtocol` / `PlayerRepositoryProtocol` を定義。
   - 既存の `static` 実装を上記プロトコル適合クラス/構造体に変更し、実体は `@MainActor` のコンポジションルート（`monsterCardBattleApp`）で生成。
   - View からリポジトリを直接呼ばないよう、Presenter/UseCase へ依存注入する。
   - DI 構築のために `AppDependencyContainer`（仮称）を用意し、App 起動時に UseCase・Presenter・Repository を組み立てて View に注入する。
5. **テスト整備**
   - UseCase のビジネスロジックをユニットテストで検証（ダメージ計算、ターン進行、勝敗判定など）。
   - Presenter のマッピングテスト（属性 enum→`Color` 変換など）を用意。
   - UI は可能ならスナップショットテストで検証。

## 実装時のポイント
- `DispatchQueue.main.asyncAfter` のような UI タイマー処理は Presenter で扱うか、UseCase から「攻撃完了イベント」を返し View がアニメーションを決める形にする。
- `BattleUseCase` は同期/非同期の両方に対応できるよう設計し、将来的なネットワーク対戦にも拡張しやすくする。
- データ取得が API などに拡張された場合も、UseCase ↔ Repository 間を変えずに済むよう `Result` / エラーハンドリングを導入しておく。
- `AppDependencyContainer` が生成した Presenter を View に渡すファクトリーメソッドを用意し、将来的には Resolver や Factory パターンに発展できる構成にする。

## DI 構築イメージ
- `AppDependencyContainer`
  - `let enemyRepository: EnemyRepositoryProtocol`
  - `let monsterRepository: MonsterCardRepositoryProtocol`
  - `func makeBattlePresenter() -> BattlePresenterProtocol`
- `monsterCardBattleApp` の `WindowGroup` で `let container = AppDependencyContainer()` を生成し、`EnvironmentValues.battlePresenterFactory` に `container.makeBattlePresenter` を設定。
- Presenter はコンテナから受け取った UseCase/Repository にのみ依存し、View との接合点はプロトコル経由に限定する。

## チェックリスト
- [x] View から Repository を直接呼んでいる箇所をすべて削除し、Presenter 経由に変更したか。
- [x] UseCase 層の型が SwiftUI に依存していないか（`ObservableObject`・`@Published`・`Color` などを排除）。
- [x] Repository がプロトコルを介して注入されているか。
- [x] Presenter が UI 表示用の `ViewState` を提供しているか。
- [ ] UseCase / Presenter / Repository のテストが用意されているか。

## 実装済み構成メモ
- `BattleUseCase` がバトル進行ロジックと状態 (`BattleSnapshot`) を管理。
- `BattlePresenter` が `BattleViewState` を生成し、カード選択や攻撃入力を仲介。
- `AppDependencyContainer` でリポジトリの具象実装を束ね、View へ Presenter を注入。
- `AppDependencyContainer` がカード/敵データの取得と UseCase 生成まで担い、Presenter は完成済みの依存だけを受け取る。
- モデルの `CardFrameStyle` を Presenter 側で `Color` にマッピングして UI 非依存を維持。
- `EnvironmentValues.battlePresenterFactory` を介して View は DI コンテナの存在を意識せず Presenter を取得。
- フォルダ構成は `View/`, `Presenter/`, `UseCase/`, `Repository/`, `Domain/Entity` のレイヤとし、旧 `Data` フォルダは `Repository` に統合。
