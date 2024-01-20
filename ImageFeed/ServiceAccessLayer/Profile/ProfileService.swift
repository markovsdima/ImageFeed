//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Dmitry Markovskiy on 15.01.2024.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    private var lastToken: String?
    
    private(set) var profile: Profile?
    
    func fetchProfile(
        _ token: String,
        completion: @escaping (Result<Profile, Error>) -> Void
    ){
        assert(Thread.isMainThread)
        if lastToken == token { return }
        task?.cancel()
        lastToken = token
        
        let request = createProfileRequest(token: token)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
}

extension ProfileService {
    struct ProfileResult: Decodable {
        let userName: String
        let firstName: String
        let lastName: String
        let bio: String
    }
    
    struct Profile {
        let username: String
        let name: String
        let loginName: String
        let bio: String
    }
}

private extension ProfileService {
    func createProfileRequest (token: String) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "unsplash.com"
        urlComponents.path = "/me"
        
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
