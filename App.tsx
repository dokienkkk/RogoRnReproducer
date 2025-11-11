import React, {useCallback, useEffect, useState} from 'react';
import {Button, StyleSheet, TextInput, View} from 'react-native';
import NativeRogoSdk from './specs/NativeRogoSdk';

const LOGIN_ROGO_TOKEN =
  'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJodHRwczovL2lkZW50aXR5dG9vbGtpdC5nb29nbGVhcGlzLmNvbS9nb29nbGUuaWRlbnRpdHkuaWRlbnRpdHl0b29sa2l0LnYxLklkZW50aXR5VG9vbGtpdCIsImlhdCI6MTc2Mjc1OTI4MiwiZXhwIjoxNzYyNzYyODgyLCJpc3MiOiJmaXJlYmFzZS1hZG1pbnNkay0ydnd5eEByb2dvLXN0YWdpbmctODdiOGQuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iLCJzdWIiOiJmaXJlYmFzZS1hZG1pbnNkay0ydnd5eEByb2dvLXN0YWdpbmctODdiOGQuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iLCJ1aWQiOiJzTXVnaU5mbko0YThIeUVlckRUbzVCbjdGeU8yIn0.IOTtKmok1qeC4EzPD4vUh6vjMUmDXqtf19CYM73EoPsznSfyymzvMPlQMN9cirB4JFCv_FK3A7bEbLEwUzg3Ko9zKQGxrQoQAJLkoF1DnYkjyitBJA7As6aL9Drb1XxAnfAC92aqEnmGENOBSXg5mTaGZWVo-I8fFCGpGpD48jx4AfP98suyQXasbFin2V3Lfd41cxWAY5C1ZLgj8Q66N_v9rzl4Cc88cKRGJXZcHXz4IOp-KnFLKzSvaexVCXv7K_SqwJz62ag0RuwAfJo2cHzjelsPXmOzDyfyXqjPI6HprxvmuupUYpMOoR8cGQlz7EYHbprjhKyXOe83pcwzTw';

function App(): React.JSX.Element {
  const [loginToken, setLoginToken] = useState<string>(LOGIN_ROGO_TOKEN);
  const [isAuthenticated, setIsAuthenticated] = useState<boolean>(false);

  const setupLocation = useCallback(async () => {
    try {
      await NativeRogoSdk.refreshUserData();
      const defaultLocation = NativeRogoSdk.getAppLocation();
      console.log(
        '[Rogo] [JS] Default Location',
        defaultLocation ? defaultLocation : 'null',
      );
      if (!defaultLocation) {
        const listLocation = NativeRogoSdk.allLocations();
        console.log('[Rogo] [JS] List Location', listLocation);
        if (listLocation.length > 0) {
          const location = listLocation[0];
          console.log(
            '[Rogo] [JS] Call setAppLocation with location',
            location.uuid,
          );
          NativeRogoSdk.setAppLocation(location.uuid);
          console.log('[Rogo] [JS] Call getAppLocation');
          const newDefaultLocation = NativeRogoSdk.getAppLocation();
          console.log('[Rogo] [JS] New default location', newDefaultLocation);
        } else {
          try {
            const newLocation = await NativeRogoSdk.createLocation(
              'label',
              'desc',
            );
            console.log('[Rogo] New Location', newLocation);
            NativeRogoSdk.setAppLocation(newLocation.uuid);
          } catch (error) {
            console.log('[Rogo] createLocation error', error);
          }
        }
      }
    } catch (error) {
      console.log('Setup Rogo Location Error', error);
    }
  }, []);

  const signIn = useCallback(async () => {
    try {
      console.log('login token', loginToken);
      const res = await NativeRogoSdk.signInWithToken(loginToken);
      console.log('RES LOGIN', res);
      await setupLocation();
      setIsAuthenticated(true);
    } catch (error) {
      console.log(error);
    }
  }, [loginToken, setupLocation]);

  useEffect(() => {
    const setup = async () => {
      const res = NativeRogoSdk.isAuthenticated();

      console.log('isAUthen', res);

      if (res) {
        await setupLocation();
      }

      setIsAuthenticated(res);
    };

    setup();
  }, [setupLocation]);

  return (
    <View style={styles.container}>
      {isAuthenticated ? (
        <>
          <Button
            title="Scan avaiable wile device"
            onPress={() => {
              NativeRogoSdk.scanAvaiableWileDevice();
            }}
          />
          <Button
            title="Stop Scan"
            onPress={() => {
              NativeRogoSdk.stopScan();
            }}
          />

          <Button
            title="Test Connect Wifi"
            onPress={() => {
              const ssid = 'DigitalR&D';
              const pass = 'DigitalRD@2804';
              NativeRogoSdk.connectWifi(ssid, pass);
            }}
          />
        </>
      ) : (
        <>
          <TextInput
            value={loginToken}
            onChangeText={setLoginToken}
            placeholder="Enter login token..."
            style={styles.textInput}
          />
          <Button
            title="Sign In With Login Token"
            onPress={signIn}
            disabled={!loginToken}
          />
        </>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  textInput: {
    width: '90%',
    height: 60,
    borderWidth: StyleSheet.hairlineWidth,
  },
});

export default App;
