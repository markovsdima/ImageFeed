//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Dmitry Markovskiy on 26.12.2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    let accessToken = ""
    
    let keychain = KeychainWrapper.standard
    
    var token: String? {
        get {
            keychain.string(forKey: accessToken)
        }
        set {
            guard let newValue else {return}
            keychain.set(newValue, forKey: accessToken)
        }
    }
    
    func removeToken() {
        keychain.removeObject(forKey: accessToken)
    }
}
