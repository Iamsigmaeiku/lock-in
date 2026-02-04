# 番茄鐘 Flutter App

一個功能完整、設計現代的番茄鐘應用，採用 Material Design 3 設計語言。

## 功能特色

### 核心功能
- ⏱️ **番茄鐘計時器**
  - 工作時長預設 25 分鐘
  - 短休息 5 分鐘
  - 長休息 15 分鐘（每 4 個番茄鐘後）
  - 可自訂所有時間設定
  
- 📋 **任務管理**
  - 創建、編輯、刪除任務
  - 預估番茄鐘數量
  - 追蹤完成進度
  - 拖拽排序
  - 滑動刪除
  
- 📊 **統計分析**
  - 今日/本週完成數量
  - 專注時長統計
  - 週統計柱狀圖
  - 30 天熱力圖
  - 歷史趨勢分析
  
- 🔔 **通知提醒**
  - 時間到時推送通知
  - 支援不同階段的通知文案
  - 可開關通知和音效
  
- ⚙️ **個性化設定**
  - 自訂工作/休息時長
  - 調整長休息間隔
  - 5 種主題色彩選擇
  - 深色模式支援
  - 數據管理（清除/重置）

### UI 設計

- 🎨 Material Design 3 設計語言
- 🌈 漂亮的漸層色圓形計時器
- ✨ 流暢的動畫效果
- 📱 響應式布局
- 🌙 完整的深色模式支援

## 技術架構

### 技術棧
- **框架**: Flutter 3.5.4
- **語言**: Dart
- **狀態管理**: Provider
- **本地存儲**: 
  - SharedPreferences（設定）
  - Hive（任務與統計數據）
- **通知**: flutter_local_notifications
- **圖表**: fl_chart
- **UI 風格**: Material Design 3

### 專案結構

```
lib/
├── main.dart                    # 應用入口
├── models/                      # 數據模型
│   ├── task.dart               # 任務模型
│   ├── pomodoro_session.dart   # 番茄鐘會話
│   └── statistics.dart         # 統計數據
├── providers/                   # 狀態管理
│   ├── timer_provider.dart     # 計時器狀態
│   ├── task_provider.dart      # 任務管理
│   ├── settings_provider.dart  # 設定管理
│   └── statistics_provider.dart # 統計管理
├── services/                    # 服務層
│   └── notification_service.dart # 通知服務
├── screens/                     # 頁面
│   ├── home_screen.dart        # 主頁（計時器）
│   ├── tasks_screen.dart       # 任務列表
│   ├── statistics_screen.dart  # 統計頁面
│   └── settings_screen.dart    # 設定頁面
└── widgets/                     # 通用組件
    ├── circular_timer.dart     # 圓形計時器
    ├── task_card.dart          # 任務卡片
    └── time_picker_dialog.dart # 時間選擇器
```

## 開始使用

### 環境要求
- Flutter SDK 3.5.4 或更高版本
- Dart SDK 3.5.4 或更高版本

### 安裝步驟

1. 克隆專案
```bash
git clone <repository-url>
cd my_app
```

2. 安裝依賴
```bash
flutter pub get
```

3. 生成 Hive 適配器
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. 運行應用
```bash
flutter run
```

## 主要依賴

```yaml
dependencies:
  provider: ^6.0.0              # 狀態管理
  hive: ^2.2.3                  # 本地數據庫
  hive_flutter: ^1.1.0
  shared_preferences: ^2.2.0    # 簡單配置存儲
  flutter_local_notifications: ^17.0.0  # 通知
  fl_chart: ^0.69.0             # 圖表
  uuid: ^4.0.0                  # ID 生成
  intl: ^0.19.0                 # 日期格式化
```

## 功能使用說明

### 計時器使用
1. 在主頁點擊「開始」按鈕開始番茄鐘
2. 可隨時「暫停」或「重置」
3. 使用「跳到休息」或「跳到工作」快速切換階段
4. 選擇關聯任務以自動追蹤進度

### 任務管理
1. 點擊「+」按鈕新增任務
2. 輸入任務名稱和預估番茄鐘數
3. 左右滑動卡片可刪除任務
4. 長按並拖動可調整任務順序
5. 點擊任務卡片可編輯詳情

### 統計查看
1. 查看今日完成的番茄鐘數和專注時長
2. 本週統計柱狀圖展示每日表現
3. 熱力圖顯示最近 30 天的專注習慣
4. 追蹤總計完成數和日均表現

### 個性化設定
1. 在設定頁面調整計時器時長
2. 選擇喜歡的主題色彩
3. 開啟或關閉深色模式
4. 管理通知和音效偏好
5. 清除數據或重置設定

## 性能優化

- 使用 Provider 進行高效的狀態管理
- Hive 提供快速的本地數據存儲
- 動畫使用 AnimatedContainer 和 AnimatedSwitcher
- IndexedStack 保持頁面狀態不重建

## 未來計劃

- [ ] 支援自定義音效
- [ ] 添加專注模式（鎖定手機）
- [ ] 雲端同步功能
- [ ] 更多統計圖表類型
- [ ] 成就系統
- [ ] 好友排行榜
- [ ] 導出數據功能
- [ ] 小組件支援

## 授權

MIT License

## 貢獻

歡迎提交 Issue 和 Pull Request！
