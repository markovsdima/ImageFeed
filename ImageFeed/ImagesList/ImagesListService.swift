//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Dmitry Markovskiy on 29.01.2024.
//

import Foundation

final class ImagesListService {
    
    // MARK: - Public Properties
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    // MARK: - Private Properties
    private (set) var photos: [Photo] = []
    private let session = URLSession.shared
    private var lastLoadedPage: Int = 0
    private let dateFormatter = ISO8601DateFormatter()
    private var isFetching: Bool = false
    
    // MARK: - Initializers
    private init() {}
    
    // MARK: - Public Methods
    func fetchPhotosNextPage() async throws -> [PhotoResult] {
        let nextPage = lastLoadedPage + 1
        guard let request = createImagesListRequest(nextPage: nextPage) else { return [] }
        let response = try await session.data(for: request)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let result = try decoder.decode([PhotoResult].self, from: response.0)
        
        self.lastLoadedPage = nextPage
        return result
    }
    
    @MainActor
    func photosTask() {
        Task(priority: .userInitiated) {
            do {
                if isFetching == true { return }
                self.isFetching = true
                assert(Thread.isMainThread)
                let result = try await self.fetchPhotosNextPage()
                var photos: [Photo] = []
                result.forEach { photo in
                    photos.append(self.convert(photo: photo))
                }
                self.photos += photos
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
                self.isFetching = false
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func convert(photo: PhotoResult) -> Photo {
        return Photo(
            id: photo.id,
            size: CGSize(width: Double(photo.width), height: Double(photo.height)),
            createdAt: dateFormatter.date(from: photo.createdAt ?? ""),
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
    
    func changeLike(photoId: String, isLike: Bool) async throws {
        let method = isLike ?  "POST" : "DELETE"
        guard let request = createChangeLikeRequest(photoId: photoId, method: method) else { return }
        
        let response = try await session.data(for: request)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let result = try decoder.decode(IsLiked.self, from: response.0)
        let isLiked = result.photo.likedByUser
        
        if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
            let photo = self.photos[index]
            
            let newPhoto = Photo(
                id: photo.id,
                size: photo.size,
                createdAt: photo.createdAt,
                welcomeDescription: photo.welcomeDescription,
                thumbImageURL: photo.thumbImageURL,
                largeImageURL: photo.largeImageURL,
                isLiked: !photo.isLiked
            )
            
            self.photos[index] = newPhoto
        }
    }
    
    func createChangeLikeRequest(photoId: String, method: String) -> URLRequest? {
        guard let token = OAuth2Service.shared.authToken else {
            assertionFailure("token is nil")
            return nil
        }
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.unsplash.com"
        urlComponents.path = "/photos/\(photoId)/like"
        
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
