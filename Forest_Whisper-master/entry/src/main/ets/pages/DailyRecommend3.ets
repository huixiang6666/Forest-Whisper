import { SongItemType } from "../models/music"
import { AppStorageV2, router } from "@kit.ArkUI"
import { playerManager } from "../utils/AvPlayerManager"

interface SongListInfoType {
  title: string;
  desc: string;
}

@Builder
export function DailyRecommend3Builder() {
  DailyRecommend3();
}

@ComponentV2
struct DailyRecommend3 {
  songs: SongItemType[] = [
    {
      img:'https://pic1.imgdb.cn/item/6950f444a0c391c56de5e1bc.jpg',
      name:'宁静睡眠 432赫兹',
      author:'焦虑自愈',
      url:'http://music.163.com/song/media/outer/url?id=1893368574.mp3',
      id:'0000'
    },
    {
      img:'https://pic1.imgdb.cn/item/6950f445a0c391c56de5e1bf.jpg',
      name:'脑波',
      author:'焦虑自愈',
      url:'http://music.163.com/song/media/outer/url?id=1899235057.mp3',
      id:'0001'

    },
    {
      img:'https://pic1.imgdb.cn/item/6950f444a0c391c56de5e1bb.jpg',
      name:'疗愈之音·轻柔助眠氛围冥想曲',
      author:'声音疗愈师',
      url:'http://music.163.com/song/media/outer/url?id=2680211713.mp3',
      id:'0002'
    },
    {
      img:'https://pic1.imgdb.cn/item/6950f444a0c391c56de5e1bd.jpg',
      name:'银河系脑洞助眠瑜伽（meditation）',
      author:'咖啡与书店',
      url:'http://music.163.com/song/media/outer/url?id=2158889076.mp3',
      id:'0003'
    },


  ]

  pathStack: NavPathStack = AppStorageV2.connect(NavPathStack, 'navStack', () => new NavPathStack())!

  songListInfo: SongListInfoType = {
    title: '氛围冥想',
    desc: '氛围冥想 | 专注深度冥想  焕发宁静氛围 | '
  };

  build() {
    NavDestination() {
      Column() {
        Stack({ alignContent: Alignment.TopStart }) {
          Row() {
            Blank();
          }
          .width('100%')
          .height('100%')
          .backgroundColor('#ff42c135');

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

          Row({ space: 20 }) {
            // 使用当前歌单第一首歌曲的封面作为歌单大图
            Image(this.songs[0].img)
              .width(160)
              .height(160)
              .borderRadius(8);

            Column({ space: 8 }) {
              Text(this.songListInfo.title)
                .fontSize(26)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White);

              Text(this.songListInfo.desc)
                .fontSize(14)
                .fontColor('#fff4faf8')
                .margin({ top: 4 });
            }
            .layoutWeight(1);
          }
          .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
          .padding({ left: 24, right: 24, top: 80 });

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

        Column({ space: 12 }) {
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

          if (this.songs.length === 0) {
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

