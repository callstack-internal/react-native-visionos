/**
 * @flow strict
 * @format
 */

import type {TurboModule} from '../Libraries/TurboModule/RCTExport';

import * as TurboModuleRegistry from '../Libraries/TurboModule/TurboModuleRegistry';

export interface Spec extends TurboModule {
  // $FlowIgnore[unclear-type]
  +requestSession: (sessionId?: string, userInfo: Object) => Promise<void>;
  +endSession: () => Promise<void>;
}

export default (TurboModuleRegistry.get<Spec>('XRModule'): ?Spec);
