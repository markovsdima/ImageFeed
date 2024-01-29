//
//  NetworkError.swift
//  ImageFeed
//
//  Created by Dmitry Markovskiy on 28.01.2024.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case invalidData
}
