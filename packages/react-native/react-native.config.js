/**
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @format
 */

'use strict';

const localCommands = require('./local-cli/localCommands');
const android = require('@react-native-community/cli-platform-android');
const {
  getDependencyConfig,
  getProjectConfig,
} = require('@react-native-community/cli-platform-apple');
const ios = require('@react-native-community/cli-platform-ios');
const {
  bundleCommand,
  ramBundleCommand,
  startCommand,
} = require('@react-native/community-cli-plugin');

module.exports = {
  commands: [
    ...ios.commands,
    ...android.commands,
    bundleCommand,
    ramBundleCommand,
    startCommand,
    ...localCommands,
  ],
  platforms: {
    visionos: {
      npmPackageName: '@callstack/react-native-visionos',
      projectConfig: getProjectConfig({platformName: 'visionos'}),
      dependencyConfig: getDependencyConfig({platformName: 'visionos'}),
    },
    ios: {
      projectConfig: ios.projectConfig,
      dependencyConfig: ios.dependencyConfig,
    },
    android: {
      projectConfig: android.projectConfig,
      dependencyConfig: android.dependencyConfig,
    },
  },
};
