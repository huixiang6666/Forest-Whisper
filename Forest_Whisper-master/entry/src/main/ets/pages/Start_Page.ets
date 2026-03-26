

@Builder
export function StartBuilder() {
  PageOne();
}

@Component
struct PageOne {
  // 跳转对象
  pathStack: NavPathStack = new NavPathStack();
  aboutToAppear(): void {
    setTimeout(() => {
      this.pathStack.replacePathByName("Layout", null, false)
    },3000)
  }

  build() {
    NavDestination() {
      //Button('Click to Layout')
        //.onClick(()=> {
       //   this.pathStack.pushPathByName("Layout", null, false);
       // })
      Stack({alignContent: Alignment.TopEnd}) {
        Image($r('app.media.poster05'))
          .width('100%')
          .height('100%')
          .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
        Button('Skip')
          .backgroundColor(Color.Grey)
          .margin(15)
          .onClick(() => {
            this.pathStack.replacePathByName("Layout", null, false);
          })
      }
    }
    //.title('Start Page')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack;
    })
  }
}