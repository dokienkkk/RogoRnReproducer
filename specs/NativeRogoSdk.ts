import type {TurboModule} from 'react-native';
import {TurboModuleRegistry} from 'react-native';

export interface IoTLocation {
  uuid: string;
  label: string;
  desc: string;
  userId: string;
}

export interface Spec extends TurboModule {
  // *************************************************
  // *********** Authentication **********************
  // *************************************************
  signInWithToken: (token: string) => Promise<boolean>;
  isAuthenticated: () => boolean;
  signOut: () => Promise<boolean>;

  // *************************************************
  // *********** Sync Data ***************************
  // *************************************************
  refreshUserData: () => Promise<boolean>;

  // *************************************************
  // *********** Location ****************************
  // *************************************************
  getAppLocation: () => string;
  allLocations: () => Array<IoTLocation>;
  createLocation: (label: string, desc: string) => Promise<IoTLocation>;
  setAppLocation: (locationId: string) => void;

  // *************************************************
  // *********** Add WILE Device *********************
  // *************************************************
  scanAvaiableWileDevice: () => void;
  stopScan: () => void;
}

export default TurboModuleRegistry.getEnforcing<Spec>('NativeRogoSdk');
