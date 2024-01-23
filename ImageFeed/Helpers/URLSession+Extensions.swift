//
//  URLSession+Extensions.swift
//  ImageFeed
//
//  Created by Dmitry Markovskiy on 20.01.2024.
//

import Foundation

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletion: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        let task = dataTask(with: request) { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode
            {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletion(.success(data))
                } else {
                    fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletion(.failure(NetworkError.urlSessionError))
            }
        }
        task.resume()
        return task
    }
}

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case invalidData
}


//extension URLSession {
//    func objectTask<T: Decodable>(
//        for request: URLRequest,
//        completion: @escaping (Result<T, Error>) -> Void
//    ) -> URLSessionTask {
//        let task = dataTask(with: request, completionHandler: { data, response, error in
//            // TODO [Sprint 11] Написать реализацию
//            guard let data else {
//                if let error {
//                    completion(.failure(error))
//                }
//                return
//            }
//            let decoder = JSONDecoder()
//            decoder.keyDecodingStrategy = .convertFromSnakeCase
//            do {
//                //let profileResult = try decoder.decode(ProfileResult.self, from: data)
//                completion(.success(profileResult))
//            } catch {
//                completion(.failure(NetworkError.invalidData))
//            }
//            
//        })
//        return task
//    }
//}
