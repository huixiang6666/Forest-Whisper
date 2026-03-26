# 云音乐 (Yun Music)

一个基于 HarmonyOS 开发的音乐播放应用，专注于助眠音乐和放松氛围音乐，提供完整的音乐播放、用户管理、社交互动等功能。

## 📱 项目简介

云音乐是一款专为 HarmonyOS 平台设计的音乐应用，主要特色包括：
- 🎵 丰富的助眠音乐库（古琴、竖琴、自然声音等）
- 💤 助眠 Tips 功能，提供专业的睡眠建议
- ⏰ 定时播放功能，支持后台计时
- 👥 用户系统，支持登录、注册和收藏功能
- 📱 社交动态功能，用户可以分享音乐和心情
- 🎨 精美的 UI 设计，提供良好的用户体验

## ✨ 主要功能

### 1. 音乐播放
- 在线音乐播放
- 播放列表管理
- 播放进度控制
- 上一首/下一首切换
- 自动播放下一首
- 循环播放

### 2. 每日推荐
- **乐器助眠**：古琴、竖琴等传统乐器音乐
- **助眠脑波**：432Hz 频率的助眠音乐
- **氛围冥想**：冥想和放松音乐
- **自然噪声**：雨声、自然声音等白噪音

### 3. 用户系统
- 用户注册和登录
- 个人资料管理
- 收藏歌曲功能
- "我喜欢的音乐" 歌单
- 收藏歌曲统计

### 4. 社交功能
- 失眠广场：用户发布动态
- 动态分享：分享音乐和心情
- 点赞和评论功能

### 5. 助眠 Tips
- 专业的睡眠建议文章
- 图文并茂的内容展示
- 可滚动阅读体验

### 6. 定时功能
- 定时播放设置（10/30/60/90/120分钟）
- 后台计时功能
- 时间到达自动关闭应用

## 🛠️ 技术栈

- **开发框架**：HarmonyOS ArkUI
- **开发语言**：ArkTS
- **状态管理**：AppStorageV2
- **媒体播放**：@kit.MediaKit (AVPlayer)
- **导航**：NavPathStack
- **数据存储**：UserDataManager (本地存储)

## 📁 项目结构

```
entry/src/main/ets/
├── entryability/          # 应用入口
│   └── EntryAbility.ets
├── models/                # 数据模型
│   ├── globalMusic.ets    # 全局音乐状态
│   ├── music.ets          # 歌曲数据模型
│   ├── TabStore.ets       # Tab 状态管理
│   └── timerState.ets     # 定时器状态
├── pages/                 # 页面组件
│   ├── Index.ets          # 入口页面
│   ├── Start_Page.ets     # 启动页
│   ├── Layout_page.ets    # 主布局页
│   ├── Recommend.ets       # 推荐页
│   ├── Find.ets           # 发现页
│   ├── Moment.ets          # 动态页
│   ├── Mine.ets            # 我的页面
│   ├── Play.ets            # 播放页
│   ├── Login.ets           # 登录页
│   ├── Register.ets        # 注册页
│   ├── SleepTips.ets       # 助眠Tips页
│   ├── Timer.ets           # 定时器页
│   ├── Love_Songlist.ets   # 我喜欢的音乐
│   ├── Songlist.ets        # 歌单页
│   └── DailyRecommend*.ets # 每日推荐页面
└── utils/                 # 工具类
    ├── AvPlayerManager.ets # 播放器管理
    ├── UserDataManager.ets # 用户数据管理
    ├── ContextManager.ets  # 上下文管理
    ├── TimerManager.ets    # 定时器管理
    └── DailyRecommendUtil.ets # 每日推荐工具
```

## 🚀 快速开始

### 环境要求

- HarmonyOS SDK API 9+
- DevEco Studio 4.0+
- Node.js 14+

### 安装步骤

1. **克隆项目**
   ```bash
   git clone <repository-url>
   cd Yun_Music
   ```

2. **安装依赖**
   ```bash
   npm install
   ```

3. **使用 DevEco Studio 打开项目**
   - 打开 DevEco Studio
   - 选择 `Open` -> 选择项目目录
   - 等待项目同步完成

4. **运行项目**
   - 连接 HarmonyOS 设备或启动模拟器
   - 点击 `Run` 按钮运行应用

## 📱 页面说明

### 主要页面

- **推荐页 (Recommend)**：展示每日推荐音乐和助眠 Tips 轮播图
- **发现页 (Find)**：音乐分类浏览
- **动态页 (Moment)**：用户发布的动态和音乐分享
- **我的页 (Mine)**：用户信息、收藏歌单等
- **播放页 (Play)**：音乐播放控制界面

### 功能页面

- **登录/注册**：用户账户管理
- **助眠 Tips**：睡眠建议文章详情
- **定时器**：定时播放设置
- **我喜欢的音乐**：收藏歌曲列表

## 🎯 核心功能实现

### 音乐播放管理

使用 `AvPlayerManager` 统一管理音乐播放：
- 播放器初始化和状态管理
- 播放列表管理
- 自动播放下一首
- 播放进度控制

### 状态管理

使用 `AppStorageV2` 实现全局状态管理：
- 当前播放歌曲信息
- 播放列表
- 用户登录状态
- 定时器状态

### 用户数据管理

使用 `UserDataManager` 管理用户数据：
- 用户注册和登录
- 收藏歌曲管理
- 本地数据持久化

### 定时器功能

使用 `TimerManager` 实现后台计时：
- 定时器状态持久化
- 后台继续计时
- 时间到达自动关闭应用

## 🔧 配置说明

### 权限配置

应用需要以下权限：
- `ohos.permission.INTERNET`：网络访问权限（用于在线音乐播放）

### 路由配置

路由配置位于 `entry/src/main/resources/base/profile/route_map.json`

## 📝 开发规范

- 使用 ArkTS 语言开发
- 遵循 HarmonyOS 开发规范
- 使用 `@ComponentV2` 和 `@Component` 装饰器
- 使用 `AppStorageV2` 进行状态管理
- 异步操作使用 `async/await`

## 🐛 已知问题

- 部分音乐 URL 可能因网络问题无法播放
- 定时器在应用完全退出后可能无法继续运行（系统限制）

## 📄 许可证

本项目仅供学习和参考使用。

## 👥 贡献

欢迎提交 Issue 和 Pull Request！

## 📞 联系方式

如有问题或建议，请通过 Issue 反馈。

---

**注意**：本项目为学习项目，音乐资源来自网络，仅供学习交流使用。
