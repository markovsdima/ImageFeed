//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Dmitry Markovskiy on 28.01.2024.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
}
