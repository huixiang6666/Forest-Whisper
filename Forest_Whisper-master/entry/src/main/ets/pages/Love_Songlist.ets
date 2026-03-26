import { SongItemType } from "../models/music"
import { AppStorageV2, router } from "@kit.ArkUI"
import { playerManager } from "../utils/AvPlayerManager"
import { userDataManager } from "../utils/UserDataManager"
import { getDailyRecommendSongs } from "../utils/DailyRecommendUtil"

interface SongListInfoType {
  title: string;
  desc: string;
  author: string;
  playCount: string;
}

@Builder
export function Love_SonglistBuilder() {
  Love_Songlist();
}

@ComponentV2
struct Love_Songlist {
  @Local songs: SongItemType[] = []
  @Local isLoading: boolean = true

  pathStack: NavPathStack = AppStorageV2.connect(NavPathStack, 'navStack', () => new NavPathStack())!

  // 所有可用歌曲（用于根据ID查找）- 使用 getDailyRecommendSongs 获取所有歌曲
  allSongs: SongItemType[] = getDailyRecommendSongs()

  songListInfo: SongListInfoType = {
    title: '我喜欢的音乐',
    desc: '来说说创建歌单的理由吧～',
    author: 'Forest_Whisper',
    playCount: '0次播放'
  };

  async aboutToAppear() {
    await this.loadFavoriteSongs()
  }

  async loadFavoriteSongs() {
    this.isLoading = true
    const favoriteIds = await userDataManager.getFavoriteSongs()
    this.songs = this.allSongs.filter(song => favoriteIds.includes(song.id))
    this.isLoading = false
  }

  build() {
    NavDestination() {
      Column() {
        // 顶部图片区域 占 45%
        Stack({ alignContent: Alignment.TopStart }) {
          // 背景颜色
          Row() {
            Blank();
          }
          .width('100%')
          .height('100%')
          .backgroundColor('#ff2a5f3f');

          // 顶部导航图标
          Row() {
            Image($r('app.media.ic_back'))
              .width(24)
              .height(24)
              .fillColor(Color.White)
              .onClick(() => {
                this.pathStack.pop()
              });

            Blank();

            Row({ space: 16 }) {
              Image($r('app.media.ic_search'))
                .width(22)
                .fillColor(Color.White)

              Image($r('app.media.ic_more'))
                .width(22)
                .fillColor(Color.White);
            }
          }
          .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
          .width('100%')
          .padding({ left: 16, right: 16, top: 16 });

          // 中间歌单信息
          Row({ space: 20 }) {
            if (this.songs.length > 0) {
              Image(this.songs[0].img)
                .width(160)
                .height(160)
                .borderRadius(8);
            } else {
              Image($r('app.media.poster01'))
                .width(160)
                .height(160)
                .borderRadius(8);
            }

            Column({ space: 8 }) {
              Text(this.songListInfo.title)
                .fontSize(26)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White);

              Row() {
                Image($r('app.media.poster01'))
                  .width(26)
                  .height(26)
                  .borderRadius(13)
                  .margin({ right: 6 });

                Text(this.songListInfo.author)
                  .fontSize(14)
                  .fontColor('#ffebf1ef');
              }

              Text(this.songListInfo.desc)
                .fontSize(14)
                .fontColor('#fff4faf8')
                .margin({ top: 4 });
            }
            .layoutWeight(1);
          }
          .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
          .padding({ left: 24, right: 24, top: 80 });

          // 底部 分享 / 评论 / 收藏 按钮
          Row({ space: 24 }) {
            this.actionButton('分享', $r('app.media.ic_share'));
            this.actionButton('评论', $r('app.media.ic_comment_o'));
            this.actionButton('收藏', $r('app.media.ic_favorite'));
          }
          .height('180%')
          .width('100%')
          .padding({ left: 24, right: 24, bottom: 24 })
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.SpaceAround)
          .align(Alignment.Bottom);
        }
        .height('45%');

        // 底部歌曲列表区域 占 55%
        Column({ space: 12 }) {
          // 播放全部行
          Row({ space: 16 }) {
            Row() {
              Image($r('app.media.ic_play'))
                .width(28)
                .fillColor('#ff0e4c09');
            }
            .width(46)
            .height(46)
            .backgroundColor('#ff359232')
            .borderRadius(23)
            .justifyContent(FlexAlign.Center);

            Column({ space: 4 }) {
              Text('播放全部')
                .fontSize(18)
                .fontWeight(FontWeight.Medium)
                .fontColor('#fff5f2f2');
              Text(`共${this.songs.length}首`)
                .fontSize(12)
                .fontColor('#ffeee5e5');
            }
          }
          .onClick(() => {
            if (this.songs.length > 0) {
              this.pathStack.pushPathByName('Play', null, false);
              playerManager.singPlay(this.songs[0], this.songs);
            }
          })
          .padding({ left: 16, right: 16, top: 16 });

          // 歌曲列表
          if (this.isLoading) {
            Column() {
              Text('加载中...')
                .fontSize(16)
                .fontColor('#ff8b8b8b')
                .margin({ top: 100 })
            }
            .width('100%')
            .layoutWeight(1)
          } else if (this.songs.length === 0) {
            Column() {
              Text('暂无歌曲')
                .fontSize(16)
                .fontColor('#ff8b8b8b')
                .margin({ top: 100 })
            }
            .width('100%')
            .layoutWeight(1)
          } else {
            List() {
              ForEach(this.songs,
                (item: SongItemType, index: number) => {
                  ListItem() {
                    Row({ space: 12 }) {
                      Image(item.img)
                        .width(52)
                        .height(52)
                        .borderRadius(6);

                      Column({ space: 6 }) {
                        Text(item.name)
                          .fontSize(16)
                          .fontColor('#ffe7eaee')
                          .maxLines(1)
                          .textOverflow({ overflow: TextOverflow.Ellipsis });

                        Text(item.author)
                          .fontSize(13)
                          .fontColor('#ff8b8b8b')
                          .maxLines(1)
                          .textOverflow({ overflow: TextOverflow.Ellipsis });
                      }
                      .layoutWeight(1);

                      Image($r('app.media.ic_more'))
                        .width(20)
                        .fillColor('#ffb5b5b5');
                    }
                    .padding({ left: 16, right: 16 })
                    .height(70)
                    .onClick(() => {
                      this.pathStack.pushPathByName('Play', null, false);
                      playerManager.singPlay(item, this.songs);
                    });
                  }
                  .margin({ bottom: 4 });
                },
                (item: SongItemType, _index: number): string => item.id
              );
            }
            .edgeEffect(EdgeEffect.None)
            .divider(null);
          }
        }
        .height('55%')
        .backgroundColor('#ff333534')
        .borderRadius({
          topLeft: 24,
          topRight: 24
        });
      }
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
      .width('100%')
      .height('100%')
      .backgroundColor('#ff2b2d2a');
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack;
      // 页面加载时刷新收藏歌曲列表
      this.loadFavoriteSongs();
    });
  }

  @Builder
  private actionButton(text: string, icon: ResourceStr) {
    Row({ space: 8 }) {
      Image(icon)
        .width(22)
        .fillColor(Color.White);
      Text(text)
        .fontSize(15)
        .fontColor(Color.White);
    }
    .width(120)
    .height(48)
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#400dbc37')
    .borderRadius(24);
  }
}

