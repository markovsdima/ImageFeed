//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Dmitry Markovskiy on 29.01.2024.
//

import Foundation

final class ImagesListService {
    private (set) var photos: [Photo] = []
    
    static let shared = ImagesListService()
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private let session = URLSession.shared
    
    private var lastLoadedPage: Int = 0
    
    private var isFetching: Bool = false
    
    
    func fetchPhotosNextPage() async throws -> [PhotoResult] {
//        isFetching = true
//        defer {
//            isFetching = false
//        }
        let nextPage = lastLoadedPage + 1
        guard let request = createImagesListRequest(nextPage: nextPage) else { return [] }
        let response = try await session.data(for: request)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let result = try decoder.decode([PhotoResult].self, from: response.0)
        
//        result.forEach { photo in
//            self.photos.append(self.convert(photo: photo))
//        }
        
        self.lastLoadedPage = nextPage
        return result
    }
    
    func photosTask() {
//        if isFetching == true {
//            print("IsFetchingError")
//            return
//        }
        Task(priority: .userInitiated) {
            do {
                //if isFetching == true { return }
                let result = try await fetchPhotosNextPage()
                var photos: [Photo] = []
                result.forEach { photo in
                    photos.append(self.convert(photo: photo))
                }
                self.photos += photos
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func convert(photo: PhotoResult) -> Photo {
        return Photo(
            id: photo.id,
            size: CGSize(width: Double(photo.width), height: Double(photo.height)),
            createdAt: ISO8601DateFormatter().date(from: photo.createdAt ?? ""),
            welcomeDescription: photo.description,
            thumbImageURL: photo.urls.thumb,
            largeImageURL: photo.urls.full,
            isLiked: photo.likedByUser)
    }
    
    func createImagesListRequest(nextPage: Int) -> URLRequest? {
        guard let token = OAuth2Service.shared.authToken else {
            assertionFailure("token is nil")
            return nil
        }
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.unsplash.com"
        urlComponents.path = "/photos"
        
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: String(nextPage)),
            URLQueryItem(name: "per_page", value: "10")
        ]
        
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}

extension ImagesListService {
    
    
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
}
