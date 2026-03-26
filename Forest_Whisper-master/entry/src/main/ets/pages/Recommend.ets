import { AppStorageV2 } from '@kit.ArkUI'

interface recommendDailyType {
  img: Resource | string // 图片
  title: string // 简介文字
  type: string // 标题文字
  top: string // 标题背景色
  bottom: string // 简介背景色
}

// 简单的状态类用于存储轮播图索引
class SwiperIndexState {
  currentIndex: number = 0;
}



@Component
export struct Recommend {
  pathStack: NavPathStack = AppStorageV2.connect(NavPathStack, 'navStack', () => new NavPathStack())!
  swiperIndexState: SwiperIndexState = AppStorageV2.connect(SwiperIndexState, 'swiperIndex', () => new SwiperIndexState())!
  // 每日推荐标题
  @Builder
  titleBuilder(title: string) {
    Row() {
      Text(title)
        .fontColor('#fffdf3f3')
        .fontWeight(700)
        .layoutWeight(1)
      Image($r('app.media.ic_more'))
        .width(22)
        .fillColor('#ff0c0c0c')
    }
    .width('100%')
    .height(40)
  }

  // 每日推荐数据
  dailyRecommend: recommendDailyType[] = [
    {
      img: 'https://pic1.imgdb.cn/item/6950eb63a0c391c56de5e0d8.jpg',
      title: '助眠热播 | 今天睡个好觉',
      type: '助眠热播',
      top: '#ff44a045',
      bottom: '#ff307e32'
    },
    {
      img: 'https://pic1.imgdb.cn/item/6950eb63a0c391c56de5e0d4.jpg',
      title: '乐器助眠 | 古琴与竖琴轻声安抚你的心绪',
      type: '乐器助眠',
      top: '#ff33c8c8',
      bottom: '#ff33c8c8'
    },
    {
      img: 'https://pic1.imgdb.cn/item/6950fae5a0c391c56de5e22d.jpg',
      title: '助眠脑波 | 温柔脑波音乐助你深度睡眠 |',
      type: '助眠脑波',
      top: '#ff3eb383',
      bottom: '#ff3eb383'
    },
    {
      img: 'https://pic1.imgdb.cn/item/6950f444a0c391c56de5e1bc.jpg',
      title: '氛围冥想 | 专注深度冥想  焕发宁静氛围 | ',
      type: '氛围冥想',
      top: '#ff2b8621',
      bottom: '#ff287920'
    },
    {
      img: 'https://pic1.imgdb.cn/item/694251eecf318614eda2ee49.jpg',
      title: '自然噪声 | 倾听大自然的交响曲',
      type: '自然噪声',
      top: '#ff2d9f6e',
      bottom: '#ff29a06d'
    }
  ]
  // 轮播图数据
  swiperList: string[] = [
    'app.media.p001',
    'app.media.p002',
    'app.media.p003',
    'app.media.p004',
    'app.media.p005'
  ]

  build() {
    Scroll() {
      Column({ space: 16 }) {
        // 顶部标题 + 定时按钮
        Row() {
          Text('助眠Tips')
            .fontSize(20)
            .fontWeight(FontWeight.Medium)
            .fontColor('#fff5e9e9')
          Blank()
          Image($r('app.media.67d605c9725eaa3b56c9f33be1c52842'))
            .width(26)
            .height(26)
            .fillColor('#ff171818')
            .onClick(() => {
              this.pathStack.pushPathByName('Timer', null, false)
            })
        }
        .width('100%')
        .height(40)
        .padding({ left: 4, right: 4 })

        // 顶部轮播图
        Swiper() {
          ForEach(this.swiperList, (item: string, index: number) => {
            Image($r(item))
              .width('100%')
              .height(190)
              .objectFit(ImageFit.Contain)
              .backgroundColor('#333333')
              .border({ radius: 16 })
              .onClick(() => {
                // 存储当前选中的轮播图索引
                this.swiperIndexState.currentIndex = index;
                // 进入助眠 Tips 详情页
                this.pathStack.pushPathByName('SleepTips', null, false);
              })
          }, (item: string, index: number) => `${item}-${index}`)
        }
        .autoPlay(true)

        // 每日推荐区域
        this.titleBuilder('助眠专区')
        List() {
          ForEach(this.dailyRecommend, (item: recommendDailyType, index: number) => {
            ListItem() {
              Column() {
                Text(item.type)
                  .width('100%')
                  .height(40)
                  .backgroundColor(item.top)
                  .padding({ left: 5 })
                  .fontSize(14)
                Image(item.img)
                  .width('100%')
                  .height(120)
                  .objectFit(ImageFit.Cover)
                Text(item.title)
                  .width('100%')
                  .height(50)
                  .backgroundColor(item.bottom)
                  .padding(5)
                  .fontSize(14)
                  .maxLines(2)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
              }
              .width('40%')
              .height(220)
              .border({ radius: 10 })
              .margin({ right: 10 })
              .clip(true)
              .onClick(() => {
                // 跳转到对应的每日推荐歌单页面
                this.pathStack.pushPathByName(`DailyRecommend${index}`, null, false)
              })
            }
          })
        }
        .listDirection(Axis.Horizontal)
        .height(230)
        .scrollBar(BarState.Off)

      }
      .width('100%')
      .padding({
        left: 12,
        right: 12,
        top: 8,
        bottom: 12
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#ff213b24')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}