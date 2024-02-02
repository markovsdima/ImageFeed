//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Dmitry Markovskiy on 30.01.2024.
//

import Foundation

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String?
    let description: String?
    let likedByUser: Bool
    let width: Int
    let height: Int
    let urls: UrlsResult
}

struct UrlsResult: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
