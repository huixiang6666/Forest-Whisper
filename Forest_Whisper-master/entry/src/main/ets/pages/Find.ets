import { SongItemType } from "../models/music"
import { AppStorageV2 } from "@kit.ArkUI"
import { playerManager } from "../utils/AvPlayerManager"
import { getDailyRecommendSongs } from "../utils/DailyRecommendUtil"

@ComponentV2
export struct Find {
  @Local searchText: string = ''
  @Local filteredSongs: SongItemType[] = []
  @Local showSuggestions: boolean = false

  // 聚合所有每日推荐歌单中的歌曲，作为搜索数据源
  songs: SongItemType[] = getDailyRecommendSongs()
  pathStack : NavPathStack = AppStorageV2.connect(NavPathStack,'navStack',()=>new NavPathStack())!

  aboutToAppear() {
    this.filteredSongs = this.songs
  }

  // 搜索过滤函数
  filterSongs(searchText: string) {
    if (!searchText || searchText.trim() === '') {
      this.filteredSongs = this.songs
      this.showSuggestions = false
    } else {
      const lowerSearchText = searchText.toLowerCase()
      this.filteredSongs = this.songs.filter((song: SongItemType) => {
        return song.name.toLowerCase().includes(lowerSearchText) ||
               song.author.toLowerCase().includes(lowerSearchText)
      })
      this.showSuggestions = true
    }
  }

  build() {
    Column() {
      // 搜索区域
      Row() {
        Image($r('app.media.ic_search'))
          .width(22)
          .fillColor('#ff304c3b')
        TextInput({ placeholder: '搜索歌曲、歌手' })
          .placeholderColor('#817D83')
          .padding({ left: 5 })
          .fontColor('#ff161616')
          .layoutWeight(1)
          .onChange((value: string) => {
            this.searchText = value
            this.filterSongs(value)
          })
        if (this.searchText) {
          Image($r('app.media.ic_code'))
            .width(20)
            .fillColor('#ffbab6b4')
            .onClick(() => {
              this.searchText = ''
              this.filterSongs('')
            })
        }
      }
      .width('100%')
      .backgroundColor('#ffcdc8c5')
      .border({ radius: 20 })
      .padding({ left: 8, right: 8 })
      .margin({ bottom: 10 })

      // 搜索结果列表
      List() {
        ForEach(this.filteredSongs, (item: SongItemType, index: number) => {
          ListItem() {
            Row() {
              // 图
              Stack() {
                Image(item.img)
                  .width(80)
                  .border({ radius: 8 })
                  .margin({ right: 10 })

              }

              // 字
              Column() {
                Text(item.name)
                  .fontColor('#ffe5e3e3')
                  .width('100%')
                  .fontWeight(700)
                  .margin({ bottom: 15 })
                Row() {
                  Text('超清母带')
                    .fontColor('#9A8E28')
                    .border({ width: 1, color: '#9A8E28', radius: 5 })
                    .padding({
                      left: 5,
                      right: 5,
                      top: 3,
                      bottom: 3
                    })
                    .margin({ right: 10 })
                  Text(item.author)
                    .fontColor('#696969')
                }
                .width('100%')
              }
              .layoutWeight(1)

              // 更多
              Image($r('app.media.ic_more'))
                .width(24)
                .fillColor('#FEFEFE')
            }
            .width('100%')
            .height(80)
            // .backgroundColor(Color.Pink)
            .margin({ bottom: 10 })
            .onClick(() => {
              this.pathStack.pushPathByName('Play', null, false)
              playerManager.singPlay(item, this.songs)
            })
          }
        })
      }
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#ff213b24')
    .padding({ left: 10, right: 10, top: 10, bottom: 10 })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}