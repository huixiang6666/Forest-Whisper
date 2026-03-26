import { preferences } from '@kit.ArkData'
import { contextManager } from './ContextManager'

export interface UserData {
  username: string
  account: string
  password: string
}

class UserDataManager {
  private static instance: UserDataManager = new UserDataManager()
  private currentUser: UserData | null = null
  private userPreferences: preferences.Preferences | null = null

  static getInstance(): UserDataManager {
    return UserDataManager.instance
  }

  async init(): Promise<void> {
    try {
      console.info('UserDataManager: Initializing...')
      if (this.userPreferences) {
        console.info('UserDataManager: Already initialized')
        return
      }

      const context = contextManager.getContext()
      console.info('UserDataManager: Context obtained:', context ? 'valid' : 'null')
      if (context) {
        const options: preferences.Options = { name: 'user_data' }
        this.userPreferences = preferences.getPreferencesSync(context, options)
        console.info('UserDataManager: Preferences initialized successfully')
      } else {
        console.error('UserDataManager: Context is null!')
      }
    } catch (err) {
      console.error('UserDataManager: Failed to init:', err)
    }
  }

  async saveUser(userData: UserData): Promise<boolean> {
    try {
      console.info('UserDataManager: Starting saveUser for account:', userData.account)
      await this.init()

      if (!this.userPreferences) {
        console.error('UserDataManager: Preferences not initialized')
        return false
      }

      // 读取现有用户数据
      let users: UserData[] = []
      try {
        const usersData = this.userPreferences.getSync('users', '[]') as string
        console.info('UserDataManager: Retrieved users data:', usersData)
        users = JSON.parse(usersData) as UserData[]
        console.info('UserDataManager: Parsed users:', users.length, 'users')
      } catch (err) {
        console.info('UserDataManager: Failed to parse users data, starting with empty array:', err)
        users = []
      }

      // 检查账号是否已存在
      const existingIndex = users.findIndex(u => u.account === userData.account)
      console.info('UserDataManager: Checking existing account, found at index:', existingIndex)

      if (existingIndex >= 0) {
        // 更新现有用户
        users[existingIndex] = userData
        console.info('UserDataManager: Updated existing user')
      } else {
        // 添加新用户
        users.push(userData)
        console.info('UserDataManager: Added new user')
      }

      // 保存到偏好设置
      console.info('UserDataManager: Saving users to preferences, total users:', users.length)
      const usersData = JSON.stringify(users)
      console.info('UserDataManager: JSON content to save:', usersData)
      this.userPreferences.putSync('users', usersData)
      this.userPreferences.flush()
      console.info('UserDataManager: Preferences saved successfully')

      return true
    } catch (err) {
      console.error('UserDataManager: Failed to save user:', err)
      return false
    }
  }

  async getUser(account: string, password: string): Promise<UserData | null> {
    try {
      console.info('UserDataManager: Getting user for account:', account)
      await this.init()

      if (!this.userPreferences) {
        console.error('UserDataManager: Preferences not initialized')
        return null
      }

      const usersData = this.userPreferences.getSync('users', '[]') as string
      console.info('UserDataManager: Retrieved users data for login:', usersData)
      const users: UserData[] = JSON.parse(usersData) as UserData[]
      const user = users.find(u => u.account === account && u.password === password)
      console.info('UserDataManager: User found:', user ? 'yes' : 'no')

      return user || null
    } catch (err) {
      console.error('UserDataManager: Failed to get user:', err)
      return null
    }
  }

  setCurrentUser(user: UserData | null): void {
    this.currentUser = user
  }

  getCurrentUser(): UserData | null {
    return this.currentUser
  }

  async getFavoriteSongs(): Promise<string[]> {
    try {
      console.info('UserDataManager: Getting favorite songs')
      await this.init()
      if (!this.currentUser) {
        console.info('UserDataManager: No current user')
        return []
      }

      if (!this.userPreferences) {
        console.error('UserDataManager: Preferences not initialized')
        return []
      }

      const key = `favorites_${this.currentUser.account}`
      const favoritesData = this.userPreferences.getSync(key, '[]') as string
      console.info('UserDataManager: Retrieved favorites data:', favoritesData)
      return JSON.parse(favoritesData) as string[]
    } catch (err) {
      console.error('UserDataManager: Failed to get favorite songs:', err)
      return []
    }
  }

  async addFavoriteSong(songId: string): Promise<boolean> {
    try {
      console.info('UserDataManager: Adding favorite song:', songId)
      await this.init()
      if (!this.currentUser) {
        console.info('UserDataManager: No current user')
        return false
      }

      if (!this.userPreferences) {
        console.error('UserDataManager: Preferences not initialized')
        return false
      }

      const key = `favorites_${this.currentUser.account}`
      let favorites: string[] = []

      try {
        const favoritesData = this.userPreferences.getSync(key, '[]') as string
        favorites = JSON.parse(favoritesData) as string[]
        console.info('UserDataManager: Retrieved existing favorites:', favorites.length, 'songs')
      } catch (err) {
        console.info('UserDataManager: Failed to parse favorites data, starting with empty array:', err)
        favorites = []
      }

      if (!favorites.includes(songId)) {
        favorites.push(songId)
        console.info('UserDataManager: Added song to favorites, new count:', favorites.length)
        const favoritesData = JSON.stringify(favorites)
        this.userPreferences.putSync(key, favoritesData)
        this.userPreferences.flush()
        console.info('UserDataManager: Favorites saved successfully')
      } else {
        console.info('UserDataManager: Song already in favorites')
      }

      return true
    } catch (err) {
      console.error('UserDataManager: Failed to add favorite song:', err)
      return false
    }
  }

  async removeFavoriteSong(songId: string): Promise<boolean> {
    try {
      console.info('UserDataManager: Removing favorite song:', songId)
      await this.init()
      if (!this.currentUser) {
        console.info('UserDataManager: No current user')
        return false
      }

      if (!this.userPreferences) {
        console.error('UserDataManager: Preferences not initialized')
        return false
      }

      const key = `favorites_${this.currentUser.account}`
      let favorites: string[] = []

      try {
        const favoritesData = this.userPreferences.getSync(key, '[]') as string
        favorites = JSON.parse(favoritesData) as string[]
        console.info('UserDataManager: Retrieved existing favorites for removal:', favorites.length, 'songs')
      } catch (err) {
        console.info('UserDataManager: Failed to parse favorites data for removal:', err)
        return false
      }

      const originalLength = favorites.length
      favorites = favorites.filter(id => id !== songId)

      if (favorites.length < originalLength) {
        console.info('UserDataManager: Removed song from favorites, new count:', favorites.length)
        const favoritesData = JSON.stringify(favorites)
        this.userPreferences.putSync(key, favoritesData)
        this.userPreferences.flush()
        console.info('UserDataManager: Favorites updated successfully')
      } else {
        console.info('UserDataManager: Song not found in favorites')
      }

      return true
    } catch (err) {
      console.error('UserDataManager: Failed to remove favorite song:', err)
      return false
    }
  }

  isFavorite(songId: string): boolean {
    // 这个方法需要异步获取，暂时返回false，实际使用时需要异步检查
    return false
  }
}

export const userDataManager = UserDataManager.getInstance()

