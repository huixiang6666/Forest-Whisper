import { AppStorageV2 } from '@kit.ArkUI'
import { userDataManager, UserData } from '../utils/UserDataManager'

interface songItemType {
  img: string;
  name: string;
  author: string;
  url: string;
  id: string;
}

interface momentListType {
  author: string;
  avatar: string | ResourceStr;
  content: string;
  comment: number;
  like: number;
  song: songItemType;
}

@Entry
@Component
export struct Moment {
  private pathStack: NavPathStack = AppStorageV2.connect(NavPathStack, 'navStack', () => new NavPathStack())!

  // 发表动态相关状态
  @State showPublishDialog: boolean = false
  @State publishContent: string = ''

  // 歌曲列表
  @State songs: songItemType[] = [
    {
      img:'https://pic1.imgdb.cn/item/694251eecf318614eda2ee49.jpg',
      name:'Hard Rain',
      author:'Rain Sounds',
      url:'http://music.163.com/song/media/outer/url?id=1424130839.mp3',
      id:'0001'
    },
    {
      img:'https://pic1.imgdb.cn/item/694251eecf318614eda2ee4c.jpg',
      name:'Relaxing Rain',
      author:'Rain Sounds',
      url:'http://music.163.com/song/media/outer/url?id=1427745575.mp3',
      id:'0002'
    },
    {
      img:'https://pic1.imgdb.cn/item/6942529fcf318614eda2f87a.jpg',
      name:'Sleep Rain Sounds',
      author:'Rain Sounds',
      url:'http://music.163.com/song/media/outer/url?id=1427745572.mp3',
      id:'0003'
    },
    {
      img:'https://pic1.imgdb.cn/item/694251fdcf318614eda2ef24.jpg',
      name:'Rain On Roof',
      author:'Rain Sounds',
      url:'http://music.163.com/song/media/outer/url?id=1427745579.mp3',
      id:'0004'
    },
  ]

  // 动态列表 - 使用State使其可更新
  @State momentList: momentListType[] = [
    {
      author: 'Feast-aws',
      avatar: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/h0.jpg',
      content: '喜欢听着雨声入睡',
      comment: 604,
      like: 23382,
      song: {
        img:'https://pic1.imgdb.cn/item/694251eecf318614eda2ee49.jpg',
        name:'Hard Rain',
        author:'Rain Sounds',
        url:'http://music.163.com/song/media/outer/url?id=1424130839.mp3',
        id:'0001'
      }
    },
    {
      author: 'CeeYet',
      avatar: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/h1.jpg',
      content: '雨声很大，睡意很浅',
      comment: 1237,
      like: 5482,
      song: {
        img:'https://pic1.imgdb.cn/item/694251eecf318614eda2ee4c.jpg',
        name:'Relaxing Rain',
        author:'Rain Sounds',
        url:'http://music.163.com/song/media/outer/url?id=1427745575.mp3',
        id:'0002'
      }
    },
    {
      author: 'Z_HOUSC',
      avatar: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/h2.jpg',
      content: '闭上眼',
      comment: 8425,
      like: 4234,
      song: {
        img:'https://pic1.imgdb.cn/item/6942529fcf318614eda2f87a.jpg',
        name:'Sleep Rain Sounds',
        author:'Rain Sounds',
        url:'http://music.163.com/song/media/outer/url?id=1427745572.mp3',
        id:'0003'
      }
    },
    {
      author: '逆转大师',
      avatar: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/h3.jpg',
      content: '希望有个好梦',
      comment: 7658,
      like: 11545,
      song: {
        img:'https://pic1.imgdb.cn/item/694251fdcf318614eda2ef24.jpg',
        name:'Rain On Roof',
        author:'Rain Sounds',
        url:'http://music.163.com/song/media/outer/url?id=1427745579.mp3',
        id:'0004'
      }
    },
    {
      author: '李',
      avatar: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/h9.jpg',
      content: '想去爬雪山',
      comment: 7362,
      like: 11482,
      song: {
        img:'https://pic1.imgdb.cn/item/694251eecf318614eda2ee49.jpg',
        name:'Hard Rain',
        author:'Rain Sounds',
        url:'http://music.163.com/song/media/outer/url?id=1424130839.mp3',
        id:'0001'
      }
    }
  ]

  @Builder
  MomentCard(item: momentListType) {
    // 改进的null安全检查
    if (!item || !item.song || !item.author || !item.avatar || !item.content) {
      Column({ space: 12 }) {
        Row({ space: 12 }) {
          Image($r('app.media.icon'))
            .width(40)
            .height(40)
            .borderRadius(20);

          Column({ space: 6 }) {
            Text('数据加载中...')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor('#ffaea5a5');

            Text('')
              .fontSize(14)
              .fontColor('#ffaea5a5');
          }
          .layoutWeight(1);
        }
        .alignItems(VerticalAlign.Top);

        // 歌曲卡片占位
        Row({ space: 12 }) {
          Image($r('app.media.song_0000'))
            .width(52)
            .height(52)
            .borderRadius(6);

          Column({ space: 4 }) {
            Text('加载中...')
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .fontColor('#ffaea5a5');

            Text('')
              .fontSize(12)
              .fontColor('#ffaea5a5');
          }
          .layoutWeight(1);
        }
        .padding(10)
        .backgroundColor('#ffb8afaf')
        .borderRadius(10);

        // 底部评论/点赞占位
        Row({ space: 32 }) {
          Text('💬 0')
            .fontSize(12)
            .fontColor('#ff998d8d');

          Text('👍 0')
            .fontSize(12)
            .fontColor('#ff998d8d');
        }
      }
      .padding(14)
      .backgroundColor('#ff262826')
      .borderRadius(12);
    } else {
      Column({ space: 12 }) {
        Row({ space: 12 }) {
          Image(item.avatar)
            .width(40)
            .height(40)
            .borderRadius(20)
            .objectFit(ImageFit.Cover);

          Column({ space: 6 }) {
            Text(item.author)
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor('#fff');

            Text(item.content)
              .fontSize(14)
              .fontColor('#ffaea5a5')
              .textAlign(TextAlign.Start);
          }
          .layoutWeight(1);
        }
        .alignItems(VerticalAlign.Top);

        // 歌曲卡片
        Row({ space: 12 }) {
          Image(item.song.img)
            .width(52)
            .height(52)
            .borderRadius(6)
            .objectFit(ImageFit.Cover);

          Column({ space: 4 }) {
            Text(item.song.name || '未知歌曲')
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .fontColor('#ff151414')
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis });

            Text(item.song.author || '未知艺术家')
              .fontSize(12)
              .fontColor('#ff161515')
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis });
          }
          .layoutWeight(1);
        }
        .padding(10)
        .backgroundColor('#ffb8afaf')
        .borderRadius(10);

        // 底部评论/点赞
        Row({ space: 32 }) {
          Text(`💬 ${item.comment}`)
            .fontSize(12)
            .fontColor('#ff998d8d');

          Text(`👍 ${item.like}`)
            .fontSize(12)
            .fontColor('#ff998d8d');
        }
      }
      .padding(14)
      .backgroundColor('#ff262826')
      .borderRadius(12);
    }
  }

  @Builder
  PublishDialog() {
    Stack({ alignContent: Alignment.Center }) {
      // 半透明背景
      Rect()
        .width('100%')
        .height('100%')
        .fill('#80000000')
        .onClick(() => {
          this.showPublishDialog = false
        })

      // 对话框内容
      Column({ space: 16 }) {
        // 标题
        Text('发表动态')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#ff161616')

        // 文本输入框
        TextArea({
          placeholder: '分享你的心情...',
          text: this.publishContent
        })
        .width(280)
        .height(120)
        .backgroundColor('#fff0f0f0')
        .borderRadius(8)
        .padding(12)
        .fontColor('#ff161616')
        .onChange((value: string) => {
          this.publishContent = value
        })

        // 按钮区域
        Row({ space: 12 }) {
          Button('取消')
            .width(100)
            .height(36)
            .fontSize(14)
            .backgroundColor('#fff0f0f0')
            .fontColor('#ff666666')
            .borderRadius(4)
            .onClick(() => {
              this.showPublishDialog = false
            })

          Button('发布')
            .width(100)
            .height(36)
            .fontSize(14)
            .backgroundColor('#ff318959')
            .fontColor(Color.White)
            .borderRadius(4)
            .enabled(this.publishContent.trim().length > 0)
            .onClick(() => {
              // 发布动态
              this.publishMoment()
            })
        }
      }
      .width(320)
      .padding(20)
      .backgroundColor(Color.White)
      .borderRadius(12)
    }
    .width('100%')
    .height('100%')
  }

  // 发布动态方法（非 UI 方法，放在 build 之前）
  publishMoment(): void {
    const currentUser: UserData | null = userDataManager.getCurrentUser()
    if (!currentUser) {
      console.error('未登录用户无法发布动态')
      return
    }

    if (!this.publishContent.trim()) {
      console.error('动态内容不能为空')
      return
    }

    const newMoment: momentListType = {
      author: currentUser.username,
      avatar: $r('app.media.poster05'), // 使用 Mine 页面的头像
      content: this.publishContent,
      comment: 0,
      like: 0,
      song: {
        img: 'https://pic1.imgdb.cn/item/694251eecf318614eda2ee49.jpg',
        name: 'Rhythmic Rain',
        author: 'Echoes of Nature',
        url: 'http://music.163.com/song/media/outer/url?id=1320363877.mp3',
        id: '0000'
      }
    }

    this.momentList = [newMoment, ...this.momentList]
    console.info('动态发布成功:', newMoment)

    this.showPublishDialog = false
    this.publishContent = ''
  }

  build() {
    Stack({ alignContent: Alignment.BottomEnd }) {
      // 主内容区域
      Column({ space: 16 }) {
        Text('失眠广场')
          .fontSize(24)
          .fontWeight(FontWeight.Medium)
          .fontColor('#ffc7cbca')
          .padding({ top: 16, bottom: 8 });

        List() {
          ForEach(this.momentList,
            (item: momentListType, index: number) => {
              ListItem() {
                this.MomentCard(item);
              }
              .margin({ bottom: 12 });
            },
            (item: momentListType, _index: number): string => item.song.id
          );
        }
        .divider(null)
        .edgeEffect(EdgeEffect.None);
      }
      .padding({ left: 16, right: 16, bottom: 16 })
      .width('100%')
      .height('100%')
      .backgroundColor('#ff213b24')
      .expandSafeArea();

      // 浮动加号按钮 - 仅在登录后显示
      if (userDataManager.getCurrentUser()) {
        Stack({ alignContent: Alignment.Center }) {
          Circle()
            .width(56)
            .height(56)
            .fill('#ff318959')
            .shadow({ radius: 4, color: '#40000000', offsetX: 0, offsetY: 2 })

          Text('+')
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
        }
        .width(56)
        .height(56)
        .margin({ right: 24, bottom: 24 })
        .onClick(() => {
          console.info('点击发表动态按钮')
          this.showPublishDialog = true
          this.publishContent = ''
        })
      }

      // 发表动态对话框
      if (this.showPublishDialog) {
        this.PublishDialog()
      }

    }
    .width('100%')
    .height('100%')
    .expandSafeArea();
  }
}