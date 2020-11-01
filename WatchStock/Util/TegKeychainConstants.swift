//
//  TegKeychainConstants.swift
//  WatchStock
//
//  Created by Bona Deny S on 10/10/20.
//  Copyright © 2020 Bona Deny S. All rights reserved.
//

import Foundation
import Security

public struct KeychainSwiftConstants {
  public static var accessGroup: String { return toString(kSecAttrAccessGroup) }
  

  public static var accessible: String { return toString(kSecAttrAccessible) }
  
  public static var attrAccount: String { return toString(kSecAttrAccount) }

  public static var attrSynchronizable: String { return toString(kSecAttrSynchronizable) }
  
  public static var klass: String { return toString(kSecClass) }
  
  public static var matchLimit: String { return toString(kSecMatchLimit) }
  
  public static var returnData: String { return toString(kSecReturnData) }
  
  public static var valueData: String { return toString(kSecValueData) }
    
  public static var returnReference: String { return toString(kSecReturnPersistentRef) }
  
  public static var returnAttributes : String { return toString(kSecReturnAttributes) }
    
  public static var secMatchLimitAll : String { return toString(kSecMatchLimitAll) }
    
  static func toString(_ value: CFString) -> String {
    return value as String
  }
}


