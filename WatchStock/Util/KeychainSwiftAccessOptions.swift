//
//  KeychainSwiftAccessOptions.swift
//  WatchStock
//
//  Created by Bona Deny S on 10/10/20.
//  Copyright © 2020 Bona Deny S. All rights reserved.
//

import Security

public enum KeychainSwiftAccessOptions {
  
  case accessibleWhenUnlocked
  
  case accessibleWhenUnlockedThisDeviceOnly

  case accessibleAfterFirstUnlock

  case accessibleAfterFirstUnlockThisDeviceOnly

  case accessibleWhenPasscodeSetThisDeviceOnly
  
  static var defaultOption: KeychainSwiftAccessOptions {
    return .accessibleWhenUnlocked
  }
  
  var value: String {
    switch self {
    case .accessibleWhenUnlocked:
      return toString(kSecAttrAccessibleWhenUnlocked)
      
    case .accessibleWhenUnlockedThisDeviceOnly:
      return toString(kSecAttrAccessibleWhenUnlockedThisDeviceOnly)
      
    case .accessibleAfterFirstUnlock:
      return toString(kSecAttrAccessibleAfterFirstUnlock)
      
    case .accessibleAfterFirstUnlockThisDeviceOnly:
      return toString(kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly)
      
    case .accessibleWhenPasscodeSetThisDeviceOnly:
      return toString(kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly)
    }
  }
  
  func toString(_ value: CFString) -> String {
    return KeychainSwiftConstants.toString(value)
  }
}

