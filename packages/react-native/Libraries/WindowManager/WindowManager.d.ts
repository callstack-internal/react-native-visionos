export interface WindowStatic {
  id: String;
  open (props?: Object): Promise<void>;
  update (props: Object): Promise<void>;
  close (): Promise<void>;
}

export interface WindowManagerStatic {
  getWindow(id: String): Window;
  supportsMultipleScenes: boolean;
}

export const WindowManager: WindowManagerStatic;
export type WindowManager = WindowManagerStatic;
export const Window: WindowStatic;
export type Window = WindowStatic;
