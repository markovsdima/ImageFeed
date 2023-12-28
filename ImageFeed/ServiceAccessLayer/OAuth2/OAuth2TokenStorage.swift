//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Dmitry Markovskiy on 26.12.2023.
//

import Foundation

final class OAuth2TokenStorage {
    private let userDefaults = UserDefaults.standard
    
    let accessToken = ""
    
    var token: String? {
        get {
            userDefaults.string(forKey: accessToken)
        }
        set {
            userDefaults.setValue(newValue, forKey: accessToken)
        }
    }
}
