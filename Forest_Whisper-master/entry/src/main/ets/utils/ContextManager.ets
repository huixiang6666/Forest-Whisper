import { common } from '@kit.AbilityKit'

class ContextManager {
  private static instance: ContextManager = new ContextManager()
  private abilityContext: common.UIAbilityContext | null = null

  static getInstance(): ContextManager {
    return ContextManager.instance
  }

  setContext(context: common.UIAbilityContext): void {
    console.info('ContextManager: Setting context')
    this.abilityContext = context
  }

  getContext(): common.UIAbilityContext | null {
    console.info('ContextManager: Getting context, available:', this.abilityContext ? 'yes' : 'no')
    return this.abilityContext
  }

  terminateSelf(): void {
    if (this.abilityContext) {
      this.abilityContext.terminateSelf()
    }
  }
}

export const contextManager = ContextManager.getInstance()

