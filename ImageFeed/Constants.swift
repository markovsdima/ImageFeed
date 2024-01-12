//
//  Constants.swift
//  ImageFeed
//
//  Created by Dmitry Markovskiy on 02.12.2023.
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
