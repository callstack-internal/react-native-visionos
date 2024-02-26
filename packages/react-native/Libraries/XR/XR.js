/**
 * @format
 * @flow strict
 * @jsdoc
 */

import NativeXRModule from './NativeXRModule';

const XR = {
  // $FlowIgnore[unclear-type]
  requestSession: (sessionId: string, userInfo: ?Object): Promise<void> => {
    if (NativeXRModule != null && NativeXRModule.requestSession != null) {
      return NativeXRModule.requestSession(sessionId, userInfo);
    }
    return Promise.reject(new Error('NativeXRModule is not available'));
  },
  endSession: (): Promise<void> => {
    if (NativeXRModule != null && NativeXRModule.endSession != null) {
      return NativeXRModule.endSession();
    }
    return Promise.reject(new Error('NativeXRModule is not available'));
  },
};

module.exports = XR;
