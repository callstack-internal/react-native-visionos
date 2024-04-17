import {NativeEventSubscription} from '../EventEmitter/RCTNativeAppEventEmitter';

type WindowManagerEvents = 'windowStateDidChange';

type WindowState = {
  windowId: string;
  state: 'active' | 'inactive' | 'background';
};

export interface WindowStatic {
  id: String;
  open (props?: Object): Promise<void>;
  update (props: Object): Promise<void>;
  close (): Promise<void>;
  addEventListener (type: WindowManagerEvents, handler: (info: WindowState) => void): NativeEventSubscription;
}

export interface WindowManagerStatic {
  getWindow(id: String): Window;
  supportsMultipleScenes: boolean;
}

export const WindowManager: WindowManagerStatic;
export type WindowManager = WindowManagerStatic;
export const Window: WindowStatic;
export type Window = WindowStatic;
