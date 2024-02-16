/**
 * @flow strict
 * @format
 */

import type {TurboModule} from '../../../../Libraries/TurboModule/RCTExport';

import * as TurboModuleRegistry from '../../../../Libraries/TurboModule/TurboModuleRegistry';

export type XRModuleConstants = {|
  +supportsMultipleScenes?: boolean,
|};

export interface Spec extends TurboModule {
  +getConstants: () => XRModuleConstants;

  // $FlowIgnore[unclear-type]
  +requestSession: (sessionId?: string, userInfo: Object) => Promise<void>;
  +endSession: () => Promise<void>;

  // $FlowIgnore[unclear-type]
  +openWindow: (windowId: string, userInfo: Object) => Promise<void>;
  // $FlowIgnore[unclear-type]
  +updateWindow: (windowId: string, userInfo: Object) => Promise<void>;
  +closeWindow: (windowId: string) => Promise<void>;
}

export default (TurboModuleRegistry.get<Spec>('XRModule'): ?Spec);
