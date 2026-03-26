import { AppStorageV2 } from "@kit.ArkUI"
import { userDataManager } from "../utils/UserDataManager"
import { getDailyRecommendSongs } from "../utils/DailyRecommendUtil"
import { SongItemType } from "../models/music"

interface MinePlaylistItemType {
  id: string;
  cover: ResourceStr;
  title: string;
  desc: string;
  songCount: number;
  playCount: string;
  isFavorite: boolean;
}

@Component
export struct Mine {
  private pathStack: NavPathStack = AppStorageV2.connect(NavPathStack, 'navStack', () => new NavPathStack())!;
  @State currentUsername: string = 'Forest Whisper'
  @State favoritePlaylist: MinePlaylistItemType = {
    id: 'fav-001',
    cover: $r('app.media.poster01'),
    title: '我喜欢的音乐',
    desc: '0首 · 0次播放',
    songCount: 0,
    playCount: '0次播放',
    isFavorite: true
  };

  // 所有可用歌曲（用于根据ID查找）
  allSongs: SongItemType[] = getDailyRecommendSongs()

  async aboutToAppear() {
    const currentUser = userDataManager.getCurrentUser()
    if (currentUser) {
      this.currentUsername = currentUser.username
    }
    // 加载收藏歌曲信息
    await this.loadFavoritePlaylistInfo()
  }

  // 加载收藏歌单信息
  async loadFavoritePlaylistInfo() {
    try {
      const favoriteIds = await userDataManager.getFavoriteSongs()
      const favoriteSongs = this.allSongs.filter(song => favoriteIds.includes(song.id))
      const songCount = favoriteSongs.length
      
      this.favoritePlaylist = {
        id: 'fav-001',
        cover: $r('app.media.poster01'),
        title: '我喜欢的音乐',
        desc: `${songCount}首`,
        songCount: songCount,
        playCount: '',
        isFavorite: true
      }
    } catch (err) {
      console.error('Failed to load favorite playlist info:', err)
    }
  }

  build() {
    Column() {
      if (!userDataManager.getCurrentUser()) {
        // 未登录状态，显示登录提示
        Column({ space: 20 }) {
          Blank()

          Text('请先登录')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor('#ff161616')
            .textAlign(TextAlign.Center)

          Text('登录后即可查看个人资料和收藏的音乐')
            .fontSize(16)
            .fontColor('#ff808080')
            .textAlign(TextAlign.Center)
            .margin({ bottom: 40 })

          Button('去登录')
            .width('60%')
            .height(50)
            .fontSize(16)
            .backgroundColor('#ff318959')
            .fontColor(Color.White)
            .borderRadius(8)
            .onClick(() => {
              this.pathStack.pushPathByName('Login', null, false)
            })

          Blank()
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .backgroundColor('#fffaf8f7')
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
      } else {
        Column() {
        // 顶部图片区域 45%
        Stack({ alignContent: Alignment.Top }) {
          // 背景大图
          Image($r('app.media.start01'))
            .width('100%')
            .height('100%')
            .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
            .objectFit(ImageFit.Cover);

          // 顶部导航
          Row() {

            Row() {

              Image($r('app.media.ic_more'))
                .width(22)
                .fillColor(Color.White);
            }
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 16 });


          // 中间头像 + 用户信息
          Column({ space: 12 }) {
            // 头像
            Stack({ alignContent: Alignment.Center }) {
              Image($r('app.media.poster05'))
                .width(96)
                .height(96)
                .borderRadius(48);
            }
            .width(110)
            .height(110)
            .borderRadius(55)
            .backgroundColor('#66ffffff');

            // 用户名
            Text(this.currentUsername)
              .fontSize(22)
              .fontWeight(FontWeight.Medium)
              .fontColor(Color.White);



            // 关注 粉丝 听歌时长
            Row({ space: 24 }) {
              Column() {
                Text('1 关注')
                  .fontSize(13)
                  .fontColor(Color.White);
              }
              Column() {
                Text('0 粉丝')
                  .fontSize(13)
                  .fontColor(Color.White);
              }
              Column() {
                Text('Lv.8  874小时')
                  .fontSize(13)
                  .fontColor(Color.White);
              }
            }
          }
          .alignItems(HorizontalAlign.Center)
          .width('100%')
          .margin({ top: 80 });

        }
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
        .height('45%');

        // 下半部分介绍区域 55%
        Column() {
          // 顶部标签：音乐 / 播客 / 笔记
          Row() {
            Text('音乐')
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
              .fontColor('#fffdf7f7');

            Blank();

            Text('播客')
              .fontSize(16)
              .fontColor('#ffb0b0b0')
              .margin({ right: 24 });

            Text('笔记')
              .fontSize(16)
              .fontColor('#ffb0b0b0');
          }
          .width('100%')
          .padding({ left: 24, right: 24, top: 16, bottom: 8 });

          // 音乐二级标签：近期 / 创建 / 收藏
          Row({ space: 24 }) {
            Text('近期')
              .fontSize(14)
              .fontColor('#ffb0b0b0');

            Text('创建')
              .fontSize(14)
              .fontColor('#fffaf6f6');

            Text('收藏')
              .fontSize(14)
              .fontColor('#ffb0b0b0');
          }
          .width('100%')
          .padding({ left: 24, right: 24, bottom: 8 });

          // 可滑动的歌单列表
          Scroll() {
            Column({ space: 16 }) {
              // 我喜欢的音乐
              this.playlistItem(this.favoritePlaylist);
            }
            .padding({ left: 16, right: 16, bottom: 24, top: 8 });
          }
          .scrollBar(BarState.Off);
        }
        .height('55%')
        .backgroundColor('#ff304c3b')
        .borderRadius({
          topLeft: 24,
          topRight: 24
        });
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#ff22262d')
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#ff22262d')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }

  @Builder
  private topActionButton(label: string, icon: ResourceStr) {
    Column({ space: 6 }) {
      Row() {
        Image(icon)
          .width(18)
          .fillColor(Color.White);
      }
      .width(64)
      .height(32)
      .backgroundColor('#fafff0f0')
      .borderRadius(16)
      .justifyContent(FlexAlign.Center);

      Text(label)
        .fontSize(13)
        .fontColor('#ff136b0f');
    }
  }

  @Builder
  private playlistItem(item: MinePlaylistItemType) {
    Row({ space: 12 }) {
      Image(item.cover)
        .width(64)
        .height(64)
        .borderRadius(8);

      Column({ space: 6 }) {
        Text(item.title)
          .fontSize(16)
          .fontColor('#fff1eded');

        Text(item.isFavorite ? item.desc : `歌单 · ${item.songCount}首 · Forext_Whisper`)
          .fontSize(13)
          .fontColor('#ffd4d3d3');
      }
      .layoutWeight(1);

      Image($r('app.media.ic_more'))
        .width(20)
        .fillColor('#ffd9d7d7');
    }
    .padding({ left: 8, right: 8 })
    .onClick(() => {
      // 我喜欢的音乐跳转到Love_Songlist
      if (item.isFavorite) {
        this.pathStack.pushPathByName('Love_Songlist', null, false);
      }
    });
  }
}