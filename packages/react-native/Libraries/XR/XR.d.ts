
export interface XRStatic {
  requestSession(sessionId: string, userInfo: Object): Promise<void>;
  endSession(): Promise<void>;
}

export const XR: XRStatic;
export type XR = XRStatic;
