import { Find } from "./Find";
import { Mine } from "./Mine";
import { Moment } from "./Moment";
import { Recommend } from "./Recommend";
import { tabStore } from "../models/TabStore";

interface TabClass {
  text: string
  icon: ResourceStr
}

@Builder
export function LayoutBuilder() {
  Layout();
}

@ComponentV2
struct Layout {
  @Local currentIndex:number = tabStore.selectedIndex;
  tabData: TabClass[] = [
    {text: '推荐', icon: $r('app.media.ic_recommend')},
    {text: '发现', icon: $r('app.media.ic_find')},
    {text: '动态', icon: $r('app.media.ic_moment')},
    {text: '我的', icon: $r('app.media.ic_mine')}
  ]

  pathStack: NavPathStack = new NavPathStack();

  @Builder tabBuilder(item: TabClass,index: number){
    Column({space:5}){
      Image(item.icon)
        .width(24)
        .fillColor(this.currentIndex=== index ?'#52B55A' : '#D4E2D9')
      Text(item.text)
        .fontSize(14)
        .fontColor(this.currentIndex=== index ?'#FFFFFF':'#D7E4DC')

    }

  }

  build() {
    NavDestination() {
      Tabs({barPosition : BarPosition.End }){
        ForEach(this.tabData,(item: TabClass,index: number)=> {
          TabContent(){
            if(this.currentIndex ===0){
              Recommend()
            }else if(this.currentIndex===1){
              Find()
            }else if(this.currentIndex===2){
              Moment()
            }else if(this.currentIndex===3){
              Mine()
            }
          }
          .tabBar(this.tabBuilder(item,index)) // 自定义导航栏 ->@Builder
          .backgroundColor('#ffc7fccf')
          .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
        })

      }
      .backgroundColor('#396A4F')
      .onSelected((index:number)=>{
        this.currentIndex = index
        // 同步当前选中的 tab 到全局 store，便于登录/注册成功后指定跳转到“我的”页
        tabStore.selectedIndex = index
      })
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    }
    //.title('Layout Page')
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack;
      // 读取登录/注册流程中设置的目标 tab 索引
      this.currentIndex = tabStore.selectedIndex;
    })
  }
}