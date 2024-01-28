//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Dmitry Markovskiy on 28.01.2024.
//

import Foundation

struct ProfileResult: Decodable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
}
