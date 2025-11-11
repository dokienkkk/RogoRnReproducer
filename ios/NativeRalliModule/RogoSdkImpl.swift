//
//  RogoSdkImpl.swift
//  RogoRNReproducer
//
//  Created by Do Kien on 10/11/25.
//

import Foundation
import RogoCore

@objcMembers class RogoSdkImpl: NSObject {
  
  var wifiSelectionHandler: ((String, String) -> ())?
  
  // MARK: - Authentication
  
  func signInWithToken(token: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
    print("[Rogo] signInWithToken \(token)")
    RGCore.shared.auth.signInWithLoginToken(loginToken: token) { response, error in
      if error == nil {
        print("[Rogo] [Native] signInWithToken success")
        resolve(true)
      } else {
        reject("Error", "signInWithToken", error)
      }
    }
  }
  
  func isAuthenticated() -> Bool {
    let isAuthenticated =  RGCore.shared.auth.isAuthenticated()
    print("[Rogo] isAuthenticated \(isAuthenticated)")
    return isAuthenticated
  }
  
  func signOut(resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
    RGCore.shared.auth.signOut { response, error in
      if error == nil {
        print("[Rogo] [Native] signOut success")
        resolve(true)
      } else {
        print("[Rogo] [Native] signOut error")
        reject("Error", "signOut", error)
      }
    }
  }
  
  func refreshUserData(resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
    RGCore.shared.refreshUserData { error in
      if error == nil {
        print("[Rogo] refreshUserData success")
        resolve(true)
      } else {
        print("[Rogo] refreshUserData error")
        reject("Error", "refreshUserData", error)
      }
    }
  }
  
  // MARK: - Location
  
  func getAppLocation() -> String? {
    let appLocation = RGCore.shared.user.selectedLocation
    print("[Rogo] getAppLocation \(String(describing: appLocation?.uuid))")
    return RGCore.shared.user.selectedLocation?.uuid
  }
  
  func setAppLocation(locationId: String) {
    print("[Rogo] setAppLocation \(locationId)")
    RGCore.shared.user.setSelectedLocation(locationId: locationId);
  }
  
  func allLocations() -> [[String: Any]] {
    let locations = RGCore.shared.user.locations
    print("[Rogo] allLocations \(locations)")
    return locations.map { location in
      return [
        "uuid": location.uuid ?? "",
        "label": location.label ?? "",
        "desc": location.desc ?? "",
        "userId": location.userID ?? "",
      ]
    }
  }
  
  func createLocation(label: String, desc: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
    RGCore.shared.user.createLocation(label: label, desc: desc) { response, error in
      if error == nil {
        let newLocation: [String: Any] = [
          "uuid": response?.uuid ?? "",
          "label": response?.label ?? "",
          "desc": response?.desc ?? "",
          "userId": response?.userID ?? "",
        ]
        resolve(newLocation)
      } else {
        reject("Error", "createLocation", error)
      }
    }
  }
  
  // MARK: - Add wile device
  //  func scanAvaiableWileDevice() {
  //    print("[Rogo] start scanAvaiableWileDevice")
  //    RGCore.shared.device.scanAvailableWileDevice(timeout: 60, limitRssi: nil) { response, error in
  //      print("[Rogo] did completed \(String(describing: response))")
  //    }
  //  }
  func scanAvaiableWileDevice() {
    print("[Rogo] start scanAvaiableWileDevice")
    //    RGCore.shared.device.scanAvailableWileDevice(timeout: 60, limitRssi: nil) { response, error in
    //      print("[Rogo] did completed \(String(describing: response))")
    //    }
    
    
    RGCore.shared.device.scanAvailableWileDevices(deviceType: nil,
                                                  timeout: 10) { response, error in
      print("Did detected a new device \(response.product?.productID)")
    } completion: { response, error in
      print("Did completed scan and found \(response?.count)")
      
      
      guard let device = response?.first else {
        return
      }
      
      RGCore.shared.device.wileDelegate = self
      RGCore.shared.device.startConfigWileDevice(device: device)
    }
  }
  
  func stopScan() {
    RGCore.shared.device.stopScanDevice()
  }
  
  func connectWifi(ssid: String, pass: String) {
    print("Rogo wifiSelectionHandler \(ssid) \(pass)")
    self.wifiSelectionHandler!(ssid, pass)
  }
}

extension RogoSdkImpl: RGBWileDelegate {
  func didConnectDeviceSuccess(setDeviceInfoHandler: ((String?, String?) -> ())?) {
    print("Rogo didConnectDeviceSuccess")
  }
  
  func didScannedWifiInfo(_ listWifiInfos: [RogoCore.RGBWifiInfo], wifiSelectionHandler: ((String, String) -> ())?) {
    print("Rogo didScannedWifiInfo")
    self.wifiSelectionHandler = wifiSelectionHandler
  }
  
  func didUpdateProgessing(percent: Int) {
    print("Rogo didUpdateProgessing \(percent)")
  }
  
  func didFailedToConnectWifi(_ ssid: String?, _ password: String?, _ wifiConnectionState: RogoCore.RGBWifiConnectionErrorType) {
    print("Rogo didFailedToConnectWifi")
  }
  
  func didFinishAddWileDevice(response: RogoCore.RGBDevice?, error: (any Error)?) {
    print("Rogo didFinishAddWileDevice")
  }
  
  
}
