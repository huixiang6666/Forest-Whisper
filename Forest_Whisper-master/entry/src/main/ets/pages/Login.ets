import { AppStorageV2 } from '@kit.ArkUI'
import { userDataManager } from '../utils/UserDataManager'
import { tabStore } from '../models/TabStore'

@Builder
export function LoginBuilder() {
  Login();
}

@ComponentV2
struct Login {
  pathStack: NavPathStack = AppStorageV2.connect(NavPathStack, 'navStack', () => new NavPathStack())!
  @Local account: string = ''
  @Local password: string = ''
  @Local errorMessage: string = ''

  build() {
    NavDestination() {
      Column({ space: 30 }) {
        Blank()

        // Logo或标题
        Text('云音乐')
          .fontSize(32)
          .fontWeight(FontWeight.Bold)
          .fontColor('#ffffff')
          .margin({ bottom: 40 })

        // 输入框区域
        Column({ space: 20 }) {
          // 账号输入框
          TextInput({ placeholder: '请输入账号' })
            .placeholderColor('#ff808080')
            .backgroundColor('#fff0f0f0')
            .width('80%')
            .height(50)
            .padding({ left: 16, right: 16 })
            .borderRadius(8)
            .fontColor('#ff161616')
            .onChange((value: string) => {
              this.account = value
              this.errorMessage = ''
            })

          // 密码输入框
          TextInput({ placeholder: '请输入密码' })
            .placeholderColor('#ff808080')
            .backgroundColor('#fff0f0f0')
            .width('80%')
            .height(50)
            .padding({ left: 16, right: 16 })
            .borderRadius(8)
            .type(InputType.Password)
            .fontColor('#ff161616')
            .onChange((value: string) => {
              this.password = value
              this.errorMessage = ''
            })

          // 错误提示
          if (this.errorMessage) {
            Text(this.errorMessage)
              .fontSize(12)
              .fontColor('#ffff0000')
              .width('80%')
              .textAlign(TextAlign.Start)
          }

          // 登录按钮
          Button('登录')
            .width('80%')
            .height(50)
            .fontSize(16)
            .backgroundColor('#ff318959')
            .fontColor(Color.White)
            .borderRadius(8)
            .enabled(this.account.length > 0 && this.password.length > 0)
            .onClick(async () => {
              const user = await userDataManager.getUser(this.account, this.password)
              if (user) {
                userDataManager.setCurrentUser(user)
                // 登录成功后跳转到底部导航页，并默认选中“我的”标签
                tabStore.selectedIndex = 3
                this.pathStack.replacePathByName('Layout', null, false)
              } else {
                this.errorMessage = '账号或密码错误'
              }
            })
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)

        Blank()

        // 注册按钮
        Row() {
          Text('还没有账号？')
            .fontSize(14)
            .fontColor('#cccccc')
          Text('注册')
            .fontSize(14)
            .fontColor('#52B55A')
            .fontWeight(FontWeight.Medium)
            .onClick(() => {
              this.pathStack.pushPathByName('Register', null, false)
            })
        }
        .margin({ bottom: 40 })
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#ff213b24')
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}

