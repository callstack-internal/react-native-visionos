/**
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @format
 */

import chalk from 'chalk';
import {logger} from '@react-native-community/cli-tools';
import path from 'path';

function printInitScript(
  projectName: string,
) {
  const relativeXcodeProjectPath = `visionos/${projectName}.xcworkspace`;
  const projectDir = path.resolve();

  const instructions = `
    ${chalk.cyan(`Run instructions for ${chalk.bold('visionOS')}`)}:
    • cd "${projectDir}/ios"

    • Install Cocoapods
      • bundle install # you need to run this only once in your project.
      • bundle exec pod install
      • cd ..
      
    • npx react-native run-visionos
    ${chalk.dim('- or -')}
    • Open ${relativeXcodeProjectPath} in Xcode or run "xed -b ${relativeXcodeProjectPath}"
    • Hit the Run button
    `;

  logger.log(`
  ${instructions}
  `);
}

export default printInitScript;
