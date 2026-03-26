import { SongItemType } from "../models/music"
import { AppStorageV2, router } from "@kit.ArkUI"
import { playerManager } from "../utils/AvPlayerManager"

interface SongListInfoType {
  title: string;
  desc: string;
}

@Builder
export function DailyRecommend1Builder() {
  DailyRecommend1();
}

@ComponentV2
struct DailyRecommend1 {
  songs: SongItemType[] = [
    {
      img:'https://pic1.imgdb.cn/item/6950eb63a0c391c56de5e0d4.jpg',
      name:'古琴禅音 冥想助眠',
      author:'怜乐',
      url:'http://music.163.com/song/media/outer/url?id=2083417309.mp3',
      id:'0000'
    },

    {
      img:'https://pic1.imgdb.cn/item/6950eb63a0c391c56de5e0d8.jpg',
      name:'古琴禅乐 大自然就在耳边',
      author:'怜乐',
      url:'http://music.163.com/song/media/outer/url?id=2083417306.mp3',
      id:'0001'

    },
    {
      img:'https://pic1.imgdb.cn/item/6950eb63a0c391c56de5e0d3.jpg',
      name:'Ethereal Elegance',
      author:'Aaron Flemming',
      url:'http://music.163.com/song/media/outer/url?id=2639399583.mp3',
      id:'0002'

    },
    {
      img:'https://pic1.imgdb.cn/item/6950eb63a0c391c56de5e0d7.jpg',
      name:'Sunshine avenue',
      author:'Philip Grass',
      url:'http://music.163.com/song/media/outer/url?id=2603138176.mp3',
      id:'0003'

    },
    {
      img:'https://pic1.imgdb.cn/item/6950eb63a0c391c56de5e0d6.jpg',
      name:'Droplets',
      author:'Camilo Branca',
      url:'http://music.163.com/song/media/outer/url?id=2671537999.mp3',
      id:'0004'

    },


  ]

  pathStack: NavPathStack = AppStorageV2.connect(NavPathStack, 'navStack', () => new NavPathStack())!

  songListInfo: SongListInfoType = {
    title: '乐器助眠',
    desc: '把雨声叠成枕头 伴你好梦 | 开启无限漫游'
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
          .backgroundColor('#ff33c8c8');

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

