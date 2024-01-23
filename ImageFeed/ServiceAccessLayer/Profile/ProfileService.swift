//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Dmitry Markovskiy on 15.01.2024.
//

import Foundation

final class ProfileService {
    
    
    static let shared = ProfileService()
    //static let didChangeProfile = 
    
    private let session = URLSession.shared
    private var task: URLSessionTask?
    
    private var lastToken: String?
    
    private(set) var profile: Profile?
    
    //@MainActor
    func fetchProfile(_ token: String) async throws -> ProfileResult {
        var request = createProfileRequest(token: token)
        
        let response = try await session.data(for: request)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let result = try decoder.decode(ProfileResult.self, from: response.0)
        
//        self.profile = Profile(username: result.username,
//                               name: result.firstName + " " + (result.lastName ?? ""),
//                               loginName: "@" + result.username,
//                               bio: result.bio ?? "")
        
        return result
    }
    
    func convertTask(_ token: String) async throws {
        Task {
            let result = try await self.fetchProfile(_: token)
            
            let username = result.username
            let name = result.firstName + " " + (result.lastName ?? "")
            let loginName = "@" + result.username
            let bio = result.bio ?? ""
            
            self.profile = Profile(username: username, name: name, loginName: loginName, bio: bio)
            //self.delegate?.didReceiveProfile()
            //print(profile)
        }
    }
    
    /*
    func fetchProfile(
        _ token: String,
        completion: @escaping (Result<ProfileResult, Error>) -> Void
    ){
        //assert(Thread.isMainThread)
        //if lastToken == token { return }
        //task?.cancel()
        //lastToken = token
        
        var request = createProfileRequest(token: token)
        print(request)
        session.dataTask(with: request) { data, response, error in
            guard let data else {
                if let error {
                    completion(.failure(error))
                }
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let profileResult = try decoder.decode(ProfileResult.self, from: data)
                completion(.success(profileResult))
            } catch {
                completion(.failure(NetworkError.invalidData))
            }
            
            
            
        }.resume()
        
        
        
//        let task = session.data(for: request) { (result: Result<Data, Error>) in
//            
//        }
        //let decoder = JSONDecoder()
        //decoder.keyDecodingStrategy = .convertFromSnakeCase
        //request.httpBody = try decoder.decode(ProfileResult)
    }*/
    
    
    
    
    
    
}

extension ProfileService {
    struct ProfileResult: Decodable {
        let username: String
        let firstName: String
        let lastName: String?
        let bio: String?
        
//        private enum CodingKeys: String, CodingKey {
//            case username = "username"
//            case firstName = "first_name"
//            case lastName = "last_name"
//            case bio = "bio"
//        }
    }
    
    struct Profile: Codable {
        let username: String
        let name: String
        let loginName: String
        let bio: String
        
//        init(result: ProfileResult) {
//            self.username = result.username
//            self.name = result.firstName + " " + (result.lastName ?? "")
//            self.loginName = "@" + result.username
//            self.bio = result.bio ?? ""
//        }
        
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
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
