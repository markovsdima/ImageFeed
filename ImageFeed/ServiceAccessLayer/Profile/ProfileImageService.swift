//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Dmitry Markovskiy on 23.01.2024.
//

import Foundation

final class ProfileImageService {
    
    // MARK: - Public Properties
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    // MARK: - Private Properties
    private let session = URLSession.shared
    private (set) var avatarURL: String?
    
    // MARK: - Public Methods
    func fetchProfileImageURL(_ token: String, username: String?) async throws {
        guard
            let username = username,
            let request = createProfileImageRequest(token: token, username: username)
        else { return }
        
        let (data, response) = try await session.data(for: request)
        guard(response as? HTTPURLResponse)?.statusCode == 200 else { return }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let userResult = try? decoder.decode(UserResult.self, from: data) else { return }
        NotificationCenter.default
            .post(name: ProfileImageService.didChangeNotification,
                  object: self,
                  userInfo: ["URL" : avatarURL as Any])
        self.avatarURL = userResult.profileImage?.large
    }
}

private extension ProfileImageService {
    func createProfileImageRequest (token: String, username: String) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.unsplash.com"
        urlComponents.path = "/users/\(username)"
        
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
