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

const {XR} = require('@callstack/react-native-visionos');
const React = require('react');
const {Alert, Button, StyleSheet, Text, View} = require('react-native');

const OpenXRSession = () => {
  const [isOpen, setIsOpen] = React.useState(false);

  const openXRSession = async () => {
    try {
      if (!XR.supportsMultipleScenes) {
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

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Is XR session open: {isOpen}</Text>
      <Button title="Open XR Session" onPress={openXRSession} />
      <Button title="Close XR Session" onPress={closeXRSession} />
      <Button
        title="Open Second Window"
        onPress={async () => {
          await XR.openWindow('SecondWindow');
        }}
      />
      <Button
        title="Update Second Window"
        onPress={async () => {
          await XR.updateWindow('SecondWindow', {
            title: 'Updated React Native Window',
          });
        }}
      />
      <Button
        title="Close Second Window"
        onPress={async () => {
          await XR.closeWindow('SecondWindow');
        }}
      />
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
