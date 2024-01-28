//
//  ImageUrl.swift
//  ImageFeed
//
//  Created by Dmitry Markovskiy on 28.01.2024.
//

import Foundation

struct ImageUrl: Decodable {
    let small: String
    let medium: String
    let large: String
}
