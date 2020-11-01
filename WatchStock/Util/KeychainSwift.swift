//
//  KeychainSwift.swift
//  WatchStock
//
//  Created by Bona Deny S on 10/10/20.
//  Copyright © 2020 Bona Deny S. All rights reserved.
//

import Security
import Foundation

open class KeychainSwift {
  
  var lastQueryParameters: [String: Any]?
  
  open var lastResultCode: OSStatus = noErr

  var keyPrefix = "" // Can be useful in test.
  

  open var accessGroup: String?
  
  

  open var synchronizable: Bool = false

  private let lock = NSLock()

  

  public init() { }
  
  public init(keyPrefix: String) {
    self.keyPrefix = keyPrefix
  }
  

  @discardableResult
  open func set(_ value: String, forKey key: String,
                  withAccess access: KeychainSwiftAccessOptions? = nil) -> Bool {
    
    if let value = value.data(using: String.Encoding.utf8) {
      return set(value, forKey: key, withAccess: access)
    }
    
    return false
  }
  @discardableResult
  open func set(_ value: Data, forKey key: String,
    withAccess access: KeychainSwiftAccessOptions? = nil) -> Bool {
    
    lock.lock()
    defer { lock.unlock() }
    
    deleteNoLock(key) // Delete any existing key before saving it

    let accessible = access?.value ?? KeychainSwiftAccessOptions.defaultOption.value
      
    let prefixedKey = keyWithPrefix(key)
      
    var query: [String : Any] = [
      KeychainSwiftConstants.klass       : kSecClassGenericPassword,
      KeychainSwiftConstants.attrAccount : prefixedKey,
      KeychainSwiftConstants.valueData   : value,
      KeychainSwiftConstants.accessible  : accessible
    ]
      
    query = addAccessGroupWhenPresent(query)
    query = addSynchronizableIfRequired(query, addingItems: true)
    lastQueryParameters = query
    
    lastResultCode = SecItemAdd(query as CFDictionary, nil)
    
    return lastResultCode == noErr
  }

  @discardableResult
  open func set(_ value: Bool, forKey key: String,
    withAccess access: KeychainSwiftAccessOptions? = nil) -> Bool {
  
    let bytes: [UInt8] = value ? [1] : [0]
    let data = Data(bytes)

    return set(data, forKey: key, withAccess: access)
  }

  open func get(_ key: String) -> String? {
    if let data = getData(key) {
      
      if let currentString = String(data: data, encoding: .utf8) {
        return currentString
      }
      
      lastResultCode = -67853
    }

    return nil
  }


  open func getData(_ key: String, asReference: Bool = false) -> Data? {
    lock.lock()
    defer { lock.unlock() }
    
    let prefixedKey = keyWithPrefix(key)
    
    var query: [String: Any] = [
      KeychainSwiftConstants.klass       : kSecClassGenericPassword,
      KeychainSwiftConstants.attrAccount : prefixedKey,
      KeychainSwiftConstants.matchLimit  : kSecMatchLimitOne
    ]
    
    if asReference {
      query[KeychainSwiftConstants.returnReference] = kCFBooleanTrue
    } else {
      query[KeychainSwiftConstants.returnData] =  kCFBooleanTrue
    }
    
    query = addAccessGroupWhenPresent(query)
    query = addSynchronizableIfRequired(query, addingItems: false)
    lastQueryParameters = query
    
    var result: AnyObject?
    
    lastResultCode = withUnsafeMutablePointer(to: &result) {
      SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
    }
    
    if lastResultCode == noErr {
      return result as? Data
    }
    
    return nil
  }

  open func getBool(_ key: String) -> Bool? {
    guard let data = getData(key) else { return nil }
    guard let firstBit = data.first else { return nil }
    return firstBit == 1
  }

  @discardableResult
  open func delete(_ key: String) -> Bool {
    lock.lock()
    defer { lock.unlock() }
    
    return deleteNoLock(key)
  }
  

  public var allKeys: [String] {
    var query: [String: Any] = [
      KeychainSwiftConstants.klass : kSecClassGenericPassword,
      KeychainSwiftConstants.returnData : true,
      KeychainSwiftConstants.returnAttributes: true,
      KeychainSwiftConstants.returnReference: true,
      KeychainSwiftConstants.matchLimit: KeychainSwiftConstants.secMatchLimitAll
    ]
  
    query = addAccessGroupWhenPresent(query)
    query = addSynchronizableIfRequired(query, addingItems: false)

    var result: AnyObject?

    let lastResultCode = withUnsafeMutablePointer(to: &result) {
      SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
    }
    
    if lastResultCode == noErr {
      return (result as? [[String: Any]])?.compactMap {
        $0[KeychainSwiftConstants.attrAccount] as? String } ?? []
    }
    
    return []
  }
    
  /**
   
  Same as `delete` but is only accessed internally, since it is not thread safe.
   
   - parameter key: The key that is used to delete the keychain item.
   - returns: True if the item was successfully deleted.
   
   */
  @discardableResult
  func deleteNoLock(_ key: String) -> Bool {
    let prefixedKey = keyWithPrefix(key)
    
    var query: [String: Any] = [
      KeychainSwiftConstants.klass       : kSecClassGenericPassword,
      KeychainSwiftConstants.attrAccount : prefixedKey
    ]
    
    query = addAccessGroupWhenPresent(query)
    query = addSynchronizableIfRequired(query, addingItems: false)
    lastQueryParameters = query
    
    lastResultCode = SecItemDelete(query as CFDictionary)
    
    return lastResultCode == noErr
  }


  @discardableResult
  open func clear() -> Bool {
    lock.lock()
    defer { lock.unlock() }
    
    var query: [String: Any] = [ kSecClass as String : kSecClassGenericPassword ]
    query = addAccessGroupWhenPresent(query)
    query = addSynchronizableIfRequired(query, addingItems: false)
    lastQueryParameters = query
    
    lastResultCode = SecItemDelete(query as CFDictionary)
    
    return lastResultCode == noErr
  }
  
  func keyWithPrefix(_ key: String) -> String {
    return "\(keyPrefix)\(key)"
  }
  
  func addAccessGroupWhenPresent(_ items: [String: Any]) -> [String: Any] {
    guard let accessGroup = accessGroup else { return items }
    
    var result: [String: Any] = items
    result[KeychainSwiftConstants.accessGroup] = accessGroup
    return result
  }
  
  func addSynchronizableIfRequired(_ items: [String: Any], addingItems: Bool) -> [String: Any] {
    if !synchronizable { return items }
    var result: [String: Any] = items
    result[KeychainSwiftConstants.attrSynchronizable] = addingItems == true ? true : kSecAttrSynchronizableAny
    return result
  }
}

