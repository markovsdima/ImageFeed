//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Dmitry Markovskiy on 15.01.2024.
//

import Foundation

final class ProfileService {
    
    
    static let shared = ProfileService()
    
    private let session = URLSession.shared
    private var task: URLSessionTask?
    
    private var lastToken: String?
    
    private(set) var profile: Profile?
    
    func fetchProfile(_ token: String) async throws -> ProfileResult {
        let request = createProfileRequest(token: token)
        
        let response = try await session.data(for: request)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let result = try decoder.decode(ProfileResult.self, from: response.0)
        
        return result
    }
    
    func convertTask(_ token: String) async throws {
        
        let result = try await self.fetchProfile(_: token)
        
        let username = result.username
        let name = result.firstName + " " + (result.lastName ?? "")
        let loginName = "@" + result.username
        let bio = result.bio ?? ""
        
        self.profile = Profile(username: username, name: name, loginName: loginName, bio: bio)
    }
}

private extension ProfileService {
    func createProfileRequest (token: String) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.unsplash.com"
        urlComponents.path = "/me"
        
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
