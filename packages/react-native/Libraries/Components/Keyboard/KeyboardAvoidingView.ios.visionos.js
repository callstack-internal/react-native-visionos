/**
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @format
 * @flow strict-local
 */

import type {Props} from './KeyboardAvoidingView';

import warnOnce from '../../Utilities/warnOnce';
import View from '../View/View';
import * as React from 'react';

/**
 * KeyboardAvoidingView is not supported on VisionOS, so we return a simple View without the onLayout handler
 */
class KeyboardAvoidingView extends React.Component<Props> {
  constructor(props: Props) {
    super(props);

    warnOnce(
      'KeyboardAvoidingView-unavailable',
      'KeyboardAvoidingView is not available on visionOS platform. The system displays the keyboard in a separate window, leaving the app’s window unaffected by the keyboard’s appearance and disappearance',
    );
  }

  render(): React.Node {
    const {children, style} = this.props;
    return <View style={style}>{children}</View>;
  }
}
// $FlowExpectedError[incompatible-type]
export default KeyboardAvoidingView;
