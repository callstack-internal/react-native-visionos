/**
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @format
 * @flow
 */

'use strict';

const {WindowManager, XR} = require('@callstack/react-native-visionos');
const React = require('react');
const {Alert, Button, StyleSheet, Text, View} = require('react-native');

const secondWindow = WindowManager.getWindow('SecondWindow');

const OpenXRSession = () => {
  const [isOpen, setIsOpen] = React.useState(false);

  const openXRSession = async () => {
    try {
      if (!WindowManager.supportsMultipleScenes) {
        Alert.alert('Error', 'Multiple scenes are not supported');
        return;
      }
      await XR.requestSession('TestImmersiveSpace');
      setIsOpen(true);
    } catch (e) {
      Alert.alert('Error', e.message);
      setIsOpen(false);
    }
  };

  const closeXRSession = async () => {
    await XR.endSession();
    setIsOpen(false);
  };

  const openWindow = async () => {
    try {
      await secondWindow.open({title: 'React Native Window'});
    } catch (e) {
      Alert.alert('Error', e.message);
    }
  };

  const updateWindow = async () => {
    await secondWindow.update({title: 'Updated Window'});
  };

  const closeWindow = async () => {
    await secondWindow.close();
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Is XR session open: {isOpen}</Text>
      <Button title="Open XR Session" onPress={openXRSession} />
      <Button title="Close XR Session" onPress={closeXRSession} />
      <Button title="Open Second Window" onPress={openWindow} />
      <Button title="Update Second Window" onPress={updateWindow} />
      <Button title="Close Second Window" onPress={closeWindow} />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  title: {
    fontSize: 30,
    margin: 10,
    textAlign: 'center',
  },
});

exports.title = 'XR';
exports.description = 'Spatial experiences';
exports.examples = [
  {
    title: 'Open XR Session',
    render(): React.Node {
      return <OpenXRSession />;
    },
  },
];
