/**
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @flow strict-local
 * @format
 */

import {type ColorValue, type ViewStyleProp} from '../../StyleSheet/StyleSheet';
import warnOnce from '../../Utilities/warnOnce';
import * as React from 'react';

type Props = $ReadOnly<{|
  +children: React.Node,
  /**
   * An ID which is used to associate this `InputAccessoryView` to
   * specified TextInput(s).
   */
  nativeID?: ?string,
  style?: ?ViewStyleProp,
  backgroundColor?: ?ColorValue,
|}>;

/**
 * InputAccessoryView is not supported on VisionOS, so we return null
 */
class InputAccessoryView extends React.Component<Props> {
  constructor(props: Props) {
    super(props);

    warnOnce(
      'component-unavailable',
      'InputAccessoryView is not available on visionOS platform.',
    );
  }

  render(): React.Node {
    return null;
  }
}
// $FlowExpectedError[incompatible-type]
module.exports = InputAccessoryView;
