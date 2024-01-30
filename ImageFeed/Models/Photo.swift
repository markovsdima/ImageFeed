//
//  Photo.swift
//  ImageFeed
//
//  Created by Dmitry Markovskiy on 30.01.2024.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}
