/**
 * @format
 * @flow strict-local
 * @jsdoc
 */

import NativeEventEmitter from '../EventEmitter/NativeEventEmitter';
import Platform from '../Utilities/Platform';
import {type EventSubscription} from '../vendor/emitter/EventEmitter';
import NativeWindowManager from './NativeWindowManager';

export type WindowStateValues = 'inactive' | 'background' | 'active';

type WindowManagerEventDefinitions = {
  windowStateDidChange: [{state: WindowStateValues, windowId: string}],
};

let emitter: ?NativeEventEmitter<WindowManagerEventDefinitions>;

if (NativeWindowManager != null) {
  emitter = new NativeEventEmitter<WindowManagerEventDefinitions>(
    Platform.OS !== 'ios' ? null : NativeWindowManager,
  );
}

class WindowManager {
  static getWindow = function (id: string): Window {
    return new Window(id);
  };

  static addEventListener<K: $Keys<WindowManagerEventDefinitions>>(
    type: K,
    handler: (...$ElementType<WindowManagerEventDefinitions, K>) => void,
  ): ?EventSubscription {
    return emitter?.addListener(type, handler);
  }

  // $FlowIgnore[unsafe-getters-setters]
  static get supportsMultipleScenes(): boolean {
    if (NativeWindowManager == null) {
      return false;
    }

    const nativeConstants = NativeWindowManager.getConstants();
    return nativeConstants.supportsMultipleScenes || false;
  }
}

class Window {
  id: string;

  constructor(id: string) {
    this.id = id;
  }

  // $FlowIgnore[unclear-type]
  open(props: ?Object): Promise<void> {
    if (NativeWindowManager != null && NativeWindowManager.openWindow != null) {
      return NativeWindowManager.openWindow(this.id, props);
    }
    return Promise.reject(new Error('NativeWindowManager is not available'));
  }

  // $FlowIgnore[unclear-type]
  close(): Promise<void> {
    if (
      NativeWindowManager != null &&
      NativeWindowManager.closeWindow != null
    ) {
      return NativeWindowManager.closeWindow(this.id);
    }
    return Promise.reject(new Error('NativeWindowManager is not available'));
  }

  // $FlowIgnore[unclear-type]
  update(props: ?Object): Promise<void> {
    if (
      NativeWindowManager != null &&
      NativeWindowManager.updateWindow != null
    ) {
      return NativeWindowManager.updateWindow(this.id, props);
    }
    return Promise.reject(new Error('NativeWindowManager is not available'));
  }
}

module.exports = WindowManager;
