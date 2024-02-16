
export interface XRStatic {
  requestSession(sessionId: string, userInfo: Object): Promise<void>;
  endSession(): Promise<void>;

  openWindow(windowId: string, userInfo: Object): Promise<void>;
  updateWindow(windowId: string, userInfo: Object): Promise<void>;
  closeWindow(windowId: string): Promise<void>;

  supportsMultipleScenes: boolean;
}

export const XR: XRStatic;
export type XR = XRStatic;
