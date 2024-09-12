let apple;
try {
  apple = require('@react-native-community/cli-platform-apple');
} catch {
  if (verbose) {
    console.warn(
      '@react-native-community/cli-platform-apple not found, the react-native.config.js may be unusable.',
    );
  }
}

const platformName = 'visionos';

const run = {
  name: 'run-visionos',
  description: 'builds your app and starts it on visionOS simulator',
  func: apple.createRun({platformName}),
  examples: [
    {
      desc: 'Run on a specific simulator',
      cmd: 'npx @callstack/react-native-visionos run-visionos --simulator "Apple Vision Pro"',
    },
  ],
  options: apple.getRunOptions({platformName}),
};

const log = {
  name: 'log-visionos',
  description: 'starts visionOS device syslog tail',
  func: apple.createLog({platformName: 'visionos'}),
  options: apple.getLogOptions({platformName}),
};

const build = {
  name: 'build-visionos',
  description: 'builds your app for visionOS platform',
  func: apple.createBuild({platformName}),
  examples: [
      {
      desc: 'Build the app for all visionOS devices in Release mode',
      cmd: 'npx @callstack/react-native-visionos build-visionos --mode "Release"',
      },
  ],
  options: apple.getBuildOptions({platformName}),
};

module.exports = [run, log, build];
