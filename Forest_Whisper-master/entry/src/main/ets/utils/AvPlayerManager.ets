import { media } from '@kit.MediaKit'
import { GlobalMusic } from '../models/globalMusic'
import { SongItemType } from '../models/music'
import { AppStorageV2 } from '@kit.ArkUI'

class AvPlayerManager {
  // 属性 方法
  // 播放器
  player: media.AVPlayer | null = null
  isPlaying: boolean = false
  // 共享播放数据
  currentSong: GlobalMusic = AppStorageV2.connect(GlobalMusic, 'SONG_KEY', () => new GlobalMusic())!
  // 防止重复触发播放完成事件
  private isHandlingComplete: boolean = false

  // 创建播放器
  async init() {
    if (!this.player) {
      this.player = await media.createAVPlayer()
    }
    this.player.on('stateChange', (state) => {
      console.info('AvPlayer stateChange:', state)
      if (state === 'initialized') {
        this.player?.prepare()
      } else if (state === 'prepared') {
        this.player?.play()
      } else if (state === 'completed') {
        // 播放完成，自动播放下一首
        this.handlePlaybackComplete()
      } else if (state === 'error') {
        // 播放错误
        console.error('AvPlayer error state, current URL:', this.currentSong.url)
        this.isPlaying = false
      }
    })

    // 错误监听
    this.player.on('error', (error) => {
      console.error('AvPlayer error event:', JSON.stringify(error))
      console.error('Failed URL:', this.currentSong.url)
      this.isPlaying = false
    })

    // 时间变化
    this.player.on('durationUpdate', (duration) => {
      this.currentSong.duration = duration
    })
    this.player.on('timeUpdate', (time) => {
      this.currentSong.time = time
    })
  }

  // 处理播放完成
  private async handlePlaybackComplete() {
    // 防止重复触发
    if (this.isHandlingComplete) {
      return
    }
    this.isHandlingComplete = true

    const list = this.currentSong.playList
    if (list.length === 0) {
      this.isHandlingComplete = false
      return
    }
    // 自动播放下一首
    await this.nextSong()
    
    // 延迟重置标志，防止快速切换歌曲时的问题
    setTimeout(() => {
      this.isHandlingComplete = false
    }, 1000)
  }

  private updateCurrent(song: SongItemType, index: number) {
    this.currentSong.img = song.img
    this.currentSong.name = song.name
    this.currentSong.author = song.author
    this.currentSong.url = song.url
    this.currentSong.id = song.id
    this.currentSong.playIndex = index
  }

  // 播放歌曲 + 设置资源播放
  async singPlay(song: SongItemType, list?: SongItemType[]) {
    // 如果外部传入完整列表，则直接作为播放列表，并从第一首开始播放
    if (list && list.length > 0) {
      this.currentSong.playList = list
      // 确保从列表的第一首开始播放（即使传入的song不在列表开头）
      const targetIndex = list.findIndex((item: SongItemType) => item.id === song.id)
      const startIndex = targetIndex >= 0 ? targetIndex : 0
      await this.playSong(list[startIndex], startIndex)
    } else if (this.currentSong.playList.length === 0) {
      // 如果没有传入列表且当前列表为空，则创建单曲列表
      this.currentSong.playList = [song]
      await this.playSong(song, 0)
    } else {
      // 如果已有播放列表，查找当前歌曲在列表中的位置
      const useList: SongItemType[] = this.currentSong.playList
      let targetIndex: number = useList.findIndex((item: SongItemType) => item.id === song.id)
      if (targetIndex === -1) {
        useList.unshift(song)
        targetIndex = 0
        this.currentSong.playList = useList
      }
      await this.playSong(useList[targetIndex], targetIndex)
    }
  }

  async playSong(song: SongItemType, index: number = 0) {
    try {
      await this.init()
      // 重置播放完成标志
      this.isHandlingComplete = false
      await this.player?.reset()
      this.currentSong.duration = 0
      this.currentSong.time = 0
      this.updateCurrent(song, index)
      // 设置播放源并播放
      // AVPlayer 支持直接设置 URL
      console.info('Playing song:', song.name, 'URL:', song.url)
      this.player!.url = song.url
      await this.player?.prepare()
      this.player?.play()
      this.isPlaying = true
    } catch (error) {
      console.error('Failed to play song:', song.name, 'Error:', JSON.stringify(error))
      console.error('Song URL:', song.url)
      this.isPlaying = false
    }
  }

  async togglePlay(): Promise<boolean> {
    await this.init()
    if (!this.player) {
      return false
    }
    // 如果没有播放源，尝试播放当前列表第一首
    if (!this.currentSong.url) {
      const song = this.currentSong.playList[0]
      if (song) {
        await this.playSong(song)
        return this.isPlaying
      } else if (this.currentSong.playList.length === 0) {
        return false
      }
    }
    if (this.isPlaying) {
      this.player?.pause()
      this.isPlaying = false
    } else {
      this.player?.play()
      this.isPlaying = true
    }
    return this.isPlaying
  }

  async nextSong() {
    const list = this.currentSong.playList
    if (list.length === 0) {
      return
    }
    const nextIndex = (this.currentSong.playIndex + 1) % list.length
    const song = list[nextIndex]
    await this.playSong(song, nextIndex)
    this.currentSong.playIndex = nextIndex
  }

  async prevSong() {
    const list = this.currentSong.playList
    if (list.length === 0) {
      return
    }
    const prevIndex = (this.currentSong.playIndex - 1 + list.length) % list.length
    const song = list[prevIndex]
    await this.playSong(song, prevIndex)
    this.currentSong.playIndex = prevIndex
  }

  async changeSong() {
    await this.player?.reset()
    this.currentSong.duration = 0
    this.currentSong.time = 0
  }

  seekPlay(value: number) {
    this.player?.seek(value)
  }
}

export const playerManager: AvPlayerManager = new AvPlayerManager()