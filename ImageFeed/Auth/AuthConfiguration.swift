//
//  AuthConfiguration.swift
//  ImageFeed
//
//  Created by Dmitry Markovskiy on 03.02.2024.
//

import Foundation

enum Constants {
    static let accessKey = "7-qLaXhBcikJF9_yqJYa5sQrSDtm9oh84rEAhEfP_ys"
    static let secretKey = "xmyGHGwIJS0NdUxJ8ZPlYEOTNw-BmjPKB7NZTlWzMjU"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    static var standart: AuthConfiguration {
        AuthConfiguration(
            accessKey: Constants.accessKey,
            secretKey: Constants.secretKey,
            redirectURI: Constants.redirectURI,
            accessScope: Constants.accessScope,
            authURLString: Constants.unsplashAuthorizeURLString,
            defaultBaseURL: Constants.defaultBaseURL
        )
    }
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
}
