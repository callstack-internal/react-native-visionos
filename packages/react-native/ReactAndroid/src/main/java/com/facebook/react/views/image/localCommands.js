const {
  createBuild,
  createLog,
  createRun,
  getRunOptions,
  getLogOptions,
  getBuildOptions,
} = require('@react-native-community/cli-platform-apple');

const platformName = 'visionos';

const run = {
  name: 'run-visionos',
  description: 'builds your app and starts it on visionOS simulator',
  func: createRun({platformName}),
  examples: [
    {
      desc: 'Run on a specific simulator',
      cmd: 'npx @callstack/react-native-visionos run-visionos --simulator "Apple Vision Pro"',
    },
  ],
  options: getRunOptions({platformName}),
};

const log = {
  name: 'log-visionos',
  description: 'starts visionOS device syslog tail',
  func: createLog({platformName: 'visionos'}),
  options: getLogOptions({platformName}),
};

const build = {
  name: 'build-visionos',
  description: 'builds your app for visionOS platform',
  func: createBuild({platformName}),
  examples: [
      {
      desc: 'Build the app for all visionOS devices in Release mode',
      cmd: 'npx @callstack/react-native-visionos build-visionos --mode "Release"',
      },
  ],
  options: getBuildOptions({platformName}),
};

module.exports = [run, log, build];
