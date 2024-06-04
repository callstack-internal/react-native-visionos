/**
 * @flow strict
 * @format
 */

import type {TurboModule} from '../../../../Libraries/TurboModule/RCTExport';

import * as TurboModuleRegistry from '../../../../Libraries/TurboModule/TurboModuleRegistry';

export type WindowManagerConstants = {|
  +supportsMultipleScenes?: boolean,
|};

export interface Spec extends TurboModule {
  +getConstants: () => WindowManagerConstants;

  // $FlowIgnore[unclear-type]
  +openWindow: (windowId: string, userInfo: Object) => Promise<void>;
  // $FlowIgnore[unclear-type]
  +updateWindow: (windowId: string, userInfo: Object) => Promise<void>;
  +closeWindow: (windowId: string) => Promise<void>;
}

export default (TurboModuleRegistry.get<Spec>('WindowManager'): ?Spec);
