//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Dmitry Markovskiy on 26.12.2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    // MARK: - Public Properties
    static let shared = OAuth2TokenStorage()
    
    // MARK: - Private Properties
    private let keychain = KeychainWrapper.standard
    private let accessToken = ""
    var token: String? {
        get {
            keychain.string(forKey: accessToken)
        }
        set {
            guard let newValue else {return}
            keychain.set(newValue, forKey: accessToken)
        }
    }
    
    // MARK: - Initializers
    private init() {}
    
    // MARK: - Public Methods
    func removeToken() {
        keychain.removeObject(forKey: accessToken)
    }
}
