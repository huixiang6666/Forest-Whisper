import { GlobalMusic } from "../models/globalMusic"
import { SongItemType } from "../models/music"
import { AppStorageV2 } from "@kit.ArkUI"
import { playerManager } from "../utils/AvPlayerManager"
import { media } from "@kit.MediaKit"
import { userDataManager } from "../utils/UserDataManager"

// 跳转页面入口函数
@Builder
export function PlayBuilder() {
  Play()
}

@ComponentV2
struct Play {
  @Local panelHeight: string = '0%'
  @Local panelOpacity: number = 0
  @Local isPlaying: boolean = false
  @Local isFavorite: boolean = false
  @Local lastSongId: string = '' // 用于跟踪歌曲ID变化
  pathStack : NavPathStack = new NavPathStack();

  // 仅作为「播放列表弹窗」的兜底数据，真正播放列表来源于 GlobalMusic.playList
  songs: SongItemType[] = []
  // 当前播放的歌曲
  @Local
  playState:GlobalMusic = AppStorageV2.connect(GlobalMusic,'SONG_KEY',()=>new GlobalMusic())!


  @Builder
  deleteButton(index: number) {
    Button('删除')
      .backgroundColor('#ec5c87')
      .fontColor('#fff')
      .width(80)
      .height('100%')
      .type(ButtonType.Normal)

  }

  async aboutToAppear(): Promise<void> {
    this.isPlaying = playerManager.isPlaying
    // 检查当前歌曲是否已收藏
    await this.checkFavorite()
    // 记录当前歌曲ID
    this.lastSongId = this.playState.id || ''
  }

  // 检查歌曲ID是否变化，如果变化则更新收藏状态
  async checkSongChanged(): Promise<void> {
    const currentSongId = this.playState.id || ''
    if (currentSongId && currentSongId !== this.lastSongId) {
      this.lastSongId = currentSongId
      await this.checkFavorite()
    }
  }

  async checkFavorite(): Promise<void> {
    if (this.playState.id) {
      const favorites = await userDataManager.getFavoriteSongs()
      this.isFavorite = favorites.includes(this.playState.id)
    } else {
      // 如果没有id，尝试从playList中获取
      const currentIndex = this.playState.playIndex
      if (this.playState.playList && this.playState.playList.length > 0 && currentIndex >= 0) {
        const currentSong = this.playState.playList[currentIndex]
        if (currentSong && currentSong.id) {
          const favorites = await userDataManager.getFavoriteSongs()
          this.isFavorite = favorites.includes(currentSong.id)
        }
      }
    }
  }

  number2time(number: number): string {
    // 毫秒 → 秒 → 分+秒; 先判断是否大于1分钟
    if (number > 60 * 1000) {
      const s = Math.floor(number/1000%60)
      const m = Math.floor(number/1000/60)
      const second = s.toString().padStart(2, '0')
      const minute = m.toString().padStart(2, '0')
      return minute + ':' + second
    } else {
      const s = Math.floor(number/1000%60)
      const second = s.toString().padStart(2, '0')
      return '00:' + second
    }
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Bottom }) {
        // 播放
        Column() {
          // 顶部导航栏
          Row() {
            Image($r('app.media.ic_back'))
              .width(24)
              .fillColor(Color.White)
              .onClick(() => {
                this.pathStack.pop();
              });

            Blank();

            Text('助眠')
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
              .fontColor(Color.White);

            Blank();

            Image($r('app.media.ic_auto'))
              .width(22)
              .fillColor(Color.White);
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 12, bottom: 12 });

          // 中央唱片机区域
          Stack({ alignContent: Alignment.Top }) {
            // 简化为一张大封面图，去除复杂唱片机与唱针装饰
            Stack({ alignContent: Alignment.Center }) {
              Image(this.playState.img || $r('app.media.poster01'))
                .width(260)
                .height(260)
                .borderRadius(20)
                .objectFit(ImageFit.Cover);
            }
            .width('100%')
            .height(280)
            .margin({ top: 40 });
          }
          .width('100%')
          .layoutWeight(1);

          // 歌曲信息区域
          Column({ space: 12 }) {
            // 歌曲标题
            Text(this.playState.name || '声(超真实自然环境)助眠')
              .fontSize(20)
              .fontWeight(FontWeight.Medium)
              .fontColor(Color.White)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis });

            // 作者
            Row({ space: 12 }) {
              Text(this.playState.author || 'Quadrant Shield Music')
                .fontSize(14)
                .fontColor('#ffb0b0b0');
              Blank();
            }
            .width('100%')
            .padding({ left: 24, right: 24 });

            // 进度条和时间
            Column({ space: 8 }) {
              Row({ space: 8 }) {
                Text(this.number2time(this.playState.time))
                  .fontSize(11)
                  .fontColor('#ffa0a0a0')
                  .width(50);

                Slider({
                  value: this.playState.time,
                  min: 0,
                  max: this.playState.duration || 235000
                })
                  .layoutWeight(1)
                  .blockColor('#ffd0d0d0')
                  .selectedColor('#ffd0d0d0')
                  .trackColor('#40ffffff')
                  .trackThickness(1)
                  .onChange((value) => {
                    playerManager.seekPlay(value);
                  });

                Text(this.number2time(this.playState.duration || 235000))
                  .fontSize(11)
                  .fontColor('#ffa0a0a0')
                  .width(50);
              }
              .width('100%')
              .padding({ left: 24, right: 24 });

              // 简化提示文案
              Text('轻触进度条可拖动进度')
                .fontSize(10)
                .fontColor('#ff808080')
                .margin({ top: 4 });
            }
            .width('100%')
            .alignItems(HorizontalAlign.Center);

            // 播放控制按钮
            Row({ space: 32 }) {
              Image($r('app.media.ic_auto'))
                .width(24)
                .fillColor('#ffb0b0b0');

              Image($r("app.media.ic_prev"))
                .width(24)
                .fillColor('#ffb0b0b0')
                .onClick(async () => {
                  playerManager.prevSong();
                  this.isPlaying = true;
                  // 切换歌曲后更新收藏状态
                  setTimeout(async () => {
                    await this.checkFavorite();
                  }, 100);
                });

              // 播放按钮（更大）
              Image(this.isPlaying ? $r('app.media.ic_paused') : $r('app.media.ic_play'))
                .width(48)
                .fillColor('#ffb0b0b0')
                .onClick(() => {
                  playerManager.togglePlay().then((playing: boolean) => {
                    this.isPlaying = playing;
                  });
                });

              Image($r('app.media.ic_next'))
                .width(24)
                .fillColor('#ffb0b0b0')
                .onClick(async () => {
                  playerManager.nextSong();
                  this.isPlaying = true;
                  // 切换歌曲后更新收藏状态
                  setTimeout(async () => {
                    await this.checkFavorite();
                  }, 100);
                });

              Image($r('app.media.ic_song_list'))
                .width(24)
                .fillColor('#ffb0b0b0')
                .onClick(() => {
                  this.panelHeight = '50%';
                  this.panelOpacity = 1;
                });
            }
            .width('100%')
            .justifyContent(FlexAlign.Center)
            .padding({ top: 16, bottom: 24 });

            // 底部收藏
            Row() {
              Image($r('app.media.ic_favorite'))
                .width(24)
                .fillColor(this.isFavorite ? Color.Red : Color.Gray)
                .onAppear(() => {
                  // 当收藏按钮显示时，检查歌曲是否变化
                  this.checkSongChanged()
                })
                .onClick(async () => {
                  // 检查用户是否已登录
                  const currentUser = userDataManager.getCurrentUser()
                  if (!currentUser) {
                    // 未登录，跳转到登录页面
                    this.pathStack.pushPathByName('Login', null, false)
                    return
                  }

                  let songId = this.playState.id
                  // 如果没有id，从playList中获取
                  if (!songId) {
                    const currentIndex = this.playState.playIndex
                    if (this.playState.playList && this.playState.playList.length > 0 && currentIndex >= 0) {
                      songId = this.playState.playList[currentIndex].id
                    }
                  }

                  if (songId) {
                    let success = false
                    if (this.isFavorite) {
                      // 取消收藏
                      success = await userDataManager.removeFavoriteSong(songId)
                    } else {
                      // 添加收藏
                      success = await userDataManager.addFavoriteSong(songId)
                    }
                    
                    // 操作成功后重新检查收藏状态，确保状态同步
                    if (success) {
                      await this.checkFavorite()
                    }
                  }
                });
            }
            .width('100%')
            .justifyContent(FlexAlign.Center)
            .padding({ bottom: 16 });
          }
          .width('100%')
          .padding({ bottom: 20 });
        }
        .width('100%')
        .height('100%')
        .backgroundColor('#ff2a3d4f')
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])


        // 列表
        Column() {
          Column() {

          }
          .width('100%')
          .layoutWeight(1)
          .onClick(() => {
            this.panelHeight = '0%'
            this.panelOpacity = 0
          })

          Column() {
            Row() {
              Row() {
                Image($r("app.media.ic_play"))
                  .width(20)
                  .fillColor('#ff5186')
              }
              .width(50)
              .aspectRatio(1)
              .justifyContent(FlexAlign.Center)

              Row({ space: 8 }) {
                Text(`播放列表 (0)`)
                  .fontColor(Color.White)
                  .fontSize(14)
              }
              .layoutWeight(1)

              Image($r('app.media.ic_close'))
                .fillColor('#ffa49a9a')
                .width(24)
                .height(24)
                .margin({ right: 16 })
                .onClick(() => {
                  this.panelHeight = '0%'
                  this.panelOpacity = 0
                })
            }
            .width('100%')
            .backgroundColor('#ff353333')
            .padding(8)
            .border({
              width: { bottom: 1 },
              color: '#12ec5c87'
            })
            .borderRadius({
              topLeft: 4,
              topRight: 4
            })

            // 播放列表
            List() {
              ForEach(this.playState.playList.length > 0 ? this.playState.playList : this.songs,
                (item: SongItemType, index: number) => {
                ListItem() {
                  Row() {
                    Row() {
                      Text((index + 1).toString())
                        .fontColor('#ffa49a9a')
                    }
                    .width(50)
                    .aspectRatio(1)
                    .justifyContent(FlexAlign.Center)

                    // 列表
                    Row({ space: 10 }) {
                      Column() {
                        Text(item.name)
                          .fontSize(14)
                          .fontColor('#ffa49a9a')
                        Text(item.author)
                          .fontSize(12)
                          .fontColor( Color.Gray)
                      }
                      .layoutWeight(1)
                      .alignItems(HorizontalAlign.Start)
                      .justifyContent(FlexAlign.Center)
                    }
                    .layoutWeight(1)

                    Image($r('app.media.ic_more'))
                      .width(24)
                      .height(24)
                      .margin({ right: 16 })
                      .fillColor(Color.Gray)
                  }
                  .alignItems(VerticalAlign.Center)
                }
                .swipeAction({
                  end: this.deleteButton(index)
                })
                .border({
                  width: { bottom: 1 },
                  color: '#12ec5c87'
                })
              })
            }
            .layoutWeight(1)
            .backgroundColor('#ff353333')

          }
          .height(400)
        }
        .height(this.panelHeight)
        // .height('100%')
        .animation({
          duration: 300
        })
        .backgroundColor('#ff353333')
        .opacity(this.panelOpacity)
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])


      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.Transparent)

    }
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
    .hideTitleBar(true)  // 隐藏标题栏
  }
}