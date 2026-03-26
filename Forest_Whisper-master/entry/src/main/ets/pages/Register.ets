import { AppStorageV2 } from '@kit.ArkUI'
import { userDataManager } from '../utils/UserDataManager'
import { tabStore } from '../models/TabStore'
import type { UserData } from '../utils/UserDataManager'

@Builder
export function RegisterBuilder() {
  Register();
}

@ComponentV2
struct Register {
  pathStack: NavPathStack = AppStorageV2.connect(NavPathStack, 'navStack', () => new NavPathStack())!
  @Local username: string = ''
  @Local account: string = ''
  @Local password: string = ''
  @Local errorMessage: string = ''

  build() {
    NavDestination() {
      Column({ space: 30 }) {
        // 返回按钮
        Row() {
          Image($r('app.media.ic_back'))
            .width(24)
            .height(24)
            .fillColor('#ffffff')
            .onClick(() => {
              this.pathStack.pop()
            })
          Blank()
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 16 })

        Blank()

        // 标题
        Text('注册')
          .fontSize(32)
          .fontWeight(FontWeight.Bold)
          .fontColor('#ffffff')
          .margin({ bottom: 40 })

        // 输入框区域
        Column({ space: 20 }) {
          // 用户名输入框
          TextInput({ placeholder: '请输入用户名' })
            .placeholderColor('#ff808080')
            .backgroundColor('#fff0f0f0')
            .width('80%')
            .height(50)
            .padding({ left: 16, right: 16 })
            .borderRadius(8)
            .fontColor('#ff161616')
            .onChange((value: string) => {
              this.username = value
              this.errorMessage = ''
            })

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

          // 注册按钮
          Button('注册')
            .width('80%')
            .height(50)
            .fontSize(16)
            .backgroundColor('#ff318959')
            .fontColor(Color.White)
            .borderRadius(8)
            .enabled(this.username.length > 0 && this.account.length > 0 && this.password.length > 0)
            .onClick(async () => {
              console.info('Register: Register button clicked')
              console.info('Register: username:', this.username, 'account:', this.account, 'password length:', this.password.length)

              if (this.username.trim() === '' || this.account.trim() === '' || this.password.trim() === '') {
                console.info('Register: Validation failed - incomplete information')
                this.errorMessage = '请填写完整信息'
                return
              }

              console.info('Register: Calling userDataManager.saveUser')
              const success = await userDataManager.saveUser({
                username: this.username,
                account: this.account,
                password: this.password
              } as UserData)
              console.info('Register: saveUser returned:', success)

              if (success) {
                console.info('Register: Setting current user and navigating back')
                userDataManager.setCurrentUser({
                  username: this.username,
                  account: this.account,
                  password: this.password
                })
                // 注册成功后跳转到底部导航页，并默认选中“我的”标签
                tabStore.selectedIndex = 3
                this.pathStack.replacePathByName('Layout', null, false)
              } else {
                console.info('Register: Registration failed')
                this.errorMessage = '注册失败，请重试'
              }
            })

        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)

        Blank()
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

