import { AppStorageV2 } from '@kit.ArkUI'
import { TimerState } from '../models/timerState'
import { timerManager } from '../utils/TimerManager'

interface TimerOption {
  label: string
  minutes: number
}

@Builder
export function TimerBuilder() {
  Timer();
}

@ComponentV2
struct Timer {
  pathStack: NavPathStack = AppStorageV2.connect(NavPathStack, 'navStack', () => new NavPathStack())!
  
  // 使用全局定时器状态
  timerState: TimerState = AppStorageV2.connect(TimerState, 'timerState', () => new TimerState())!
  
  // 本地状态用于时间选择（仅在未计时时可修改）
  @Local localSelectedTime: number = 10

  timerOptions: TimerOption[] = [
    { label: '10分钟', minutes: 10 },
    { label: '30分钟', minutes: 30 },
    { label: '60分钟', minutes: 60 },
    { label: '90分钟', minutes: 90 },
    { label: '120分钟', minutes: 120 }
  ]

  aboutToAppear() {
    // 初始化定时器管理器
    timerManager.setTimerState(this.timerState)
    // 同步本地选择时间
    this.localSelectedTime = this.timerState.selectedTime
    // 如果正在计时，更新剩余时间
    if (this.timerState.isCounting) {
      timerManager.updateRemainingTime()
    }
  }

  startTimer() {
    timerManager.startTimer(this.localSelectedTime)
    // 同步到全局状态
    this.timerState.selectedTime = this.localSelectedTime
  }

  stopTimer() {
    timerManager.stopTimer()
  }

  formatTime(seconds: number): string {
    const mins = Math.floor(seconds / 60)
    const secs = seconds % 60
    return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`
  }

  build() {
    NavDestination() {
      Column({ space: 30 }) {
        // 返回按钮
        Row() {
          Image($r('app.media.ic_back'))
            .width(24)
            .height(24)
            .fillColor('#ff161616')
            .onClick(() => {
              this.pathStack.pop()
            })
          Blank()
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 16 })

        // 闹钟图标
        Image($r('app.media.67d605c9725eaa3b56c9f33be1c52842'))
          .width(80)
          .height(80)
          .fillColor('#318959')
          .margin({ top: 40 })

        // 时间选择
        Column({ space: 16 }) {
          Text('选择定时时间')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#ff161616')

          Column({ space: 12 }) {
            ForEach(this.timerOptions, (option: TimerOption) => {
              Row() {
                Text(option.label)
                  .fontSize(16)
                  .fontColor(this.localSelectedTime === option.minutes ? '#318959' : '#ff161616')
                  .layoutWeight(1)
                if (this.localSelectedTime === option.minutes) {
                  Image($r('app.media.ic_more'))
                    .width(20)
                    .height(20)
                    .fillColor('#318959')
                }
              }
              .width('100%')
              .height(50)
              .padding({ left: 20, right: 20 })
              .backgroundColor(this.localSelectedTime === option.minutes ? '#fffaf8f7' : '#fff')
              .border({ 
                width: this.localSelectedTime === option.minutes ? 2 : 1,
                color: this.localSelectedTime === option.minutes ? '#318959' : '#e0e0e0',
                radius: 8
              })
              .onClick(() => {
                if (!this.timerState.isCounting) {
                  this.localSelectedTime = option.minutes
                }
              })
            })
          }
          .width('100%')
        }
        .width('100%')
        .padding({ left: 20, right: 20 })

        // 倒计时显示
        if (this.timerState.isCounting) {
          Text(this.formatTime(this.timerState.remainingSeconds))
            .fontSize(48)
            .fontWeight(FontWeight.Bold)
            .fontColor('#318959')
            .margin({ top: 20 })
        }

        Blank()

        // 确认和取消按钮
        Row({ space: 20 }) {
          Button('取消')
            .width('40%')
            .height(50)
            .fontSize(16)
            .backgroundColor('#ffcccccc')
            .fontColor('#ff161616')
            .onClick(() => {
              this.stopTimer()
              this.pathStack.pop()
            })

          Button(this.timerState.isCounting ? '停止' : '确认')
            .width('40%')
            .height(50)
            .fontSize(16)
            .backgroundColor('#318959')
            .fontColor(Color.White)
            .onClick(() => {
              if (this.timerState.isCounting) {
                this.stopTimer()
              } else {
                this.startTimer()
              }
            })
        }
        .width('100%')
        .padding({ left: 20, right: 20, bottom: 40 })
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#fffaf8f7')
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}

