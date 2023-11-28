/**
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @format
 */

'use strict';

const {getDefaultConfig} = require('@react-native/metro-config');
const {mergeConfig} = require('metro-config');
const path = require('path');

// todo: extract to package
const PlatformResolver = (config = {}) => {
  const platformName =
    config.platformName ?? '@callstack/react-native-visionos';

  return (context, moduleName, platform) => {
    let modifiedModuleName = moduleName;
    if (moduleName === 'react-native') {
      modifiedModuleName = platformName;
    } else if (moduleName.startsWith('react-native/')) {
      modifiedModuleName = `${platformName}/${modifiedModuleName.slice(
        'react-native/'.length,
      )}`;
    }

    return context.resolveRequest(context, modifiedModuleName, platform);
  };
};

/**
 * This cli config is needed for development purposes, e.g. for running
 * integration tests during local development or on CI services.
 *
 * @type {import('metro-config').MetroConfig}
 */
const config = {
  // Make Metro able to resolve required external dependencies
  watchFolders: [
    path.resolve(__dirname, '../../node_modules'),
    path.resolve(__dirname, '../assets'),
    path.resolve(__dirname, '../community-cli-plugin'),
    path.resolve(__dirname, '../dev-middleware'),
    path.resolve(__dirname, '../normalize-color'),
    path.resolve(__dirname, '../polyfills'),
    path.resolve(__dirname, '../react-native'),
    path.resolve(__dirname, '../virtualized-lists'),
  ],
  resolver: {
    blockList: [/..\/react-native\/sdks\/hermes/],
    extraNodeModules: {
      'react-native': path.resolve(__dirname, '../react-native'),
    },
    resolveRequest: PlatformResolver(),
    sourceExts: getDefaultConfig(__dirname).resolver.sourceExts?.flatMap(
      ext => [`visionos.${ext}`, ext],
    ),
  },
};

module.exports = mergeConfig(getDefaultConfig(__dirname), config);
