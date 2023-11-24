/**
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @format
 * @flow strict-local
 */

import type {EventSubscription} from '../../vendor/emitter/EventEmitter';
import type {
  KeyboardEvent,
  KeyboardEventDefinitions,
  KeyboardMetrics,
} from './Keyboard';

import warnOnce from '../../Utilities/warnOnce';

/**
 * The Keyboard module is not supported on VisionOS
 */
class Keyboard {
  constructor() {
    warnOnce(
      'Keyboard-unavailable',
      'Keyboard is not available on visionOS platform. The system displays the keyboard in a separate window, leaving the app’s window unaffected by the keyboard’s appearance and disappearance',
    );
    return;
  }

  addListener<K: $Keys<KeyboardEventDefinitions>>(
    eventType: K,
    listener: (...$ElementType<KeyboardEventDefinitions, K>) => mixed,
    context?: mixed,
  ): EventSubscription {
    return {remove() {}};
  }

  removeAllListeners<K: $Keys<KeyboardEventDefinitions>>(eventType: ?K): void {}

  dismiss(): void {}

  isVisible(): boolean {
    return false;
  }

  metrics(): ?KeyboardMetrics {}

  scheduleLayoutAnimation(event: KeyboardEvent): void {}
}

// $FlowExpectedError[incompatible-type]
module.exports = (new Keyboard(): Keyboard);
