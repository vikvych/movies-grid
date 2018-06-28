//
//  ApiService.swift
//  Movies
//
//  Created by Ivan Tkachenko on 6/27/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import Foundation
import Alamofire
import ReactiveKit

enum ApiAction: String {
    case nowPlayingMovies = "movie/now_playing"
}

class ApiService {
    
    private let queue: DispatchQueue
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .custom { decoder in
            let dateString = try! decoder.singleValueContainer().decode(String.self)
            
            if let date = dateFormatter.date(from: dateString) {
                return date
            } else {
                throw DecodingError.typeMismatch(Date.self, DecodingError.Context.init(codingPath: decoder.codingPath, debugDescription: Strings.Error.invalidDateFormat))
            }
        }
        
        return decoder
    }()
    
    init(queue: DispatchQueue = DispatchQueue(label: ApiConfig.queueName, attributes: [.concurrent])) {
        self.queue = queue
    }
    
    func query<T: Decodable>(_ action: ApiAction, method: HTTPMethod = .get, parameters: Parameters? = nil) -> Signal<T, ApiError> {
        let queue = self.queue
        let decoder = self.decoder
        
        return Signal { observer in
            guard
                let url = URL(string: ApiConfig.endpoint)?.appendingPathComponent(action.rawValue)
                else {
                    observer.failed(.invalidParams)
                    
                    return NonDisposable.instance
            }
            
            let params = (parameters ?? Parameters()).merging(["api_key": ApiConfig.apiKey]) { $1 }
            let request = Alamofire
                .request(url, method: method, parameters: params)
                .responseData(queue: queue) { dataResponse in
                    guard let responseData = dataResponse.value else {
                        if let error = dataResponse.error {
                            return observer.failed(.networkError(error: error))
                        } else {
                            return observer.failed(.emptyResponse)
                        }
                    }
                    
                    let data: T
                    
                    do {
                        data = try decoder.decode(T.self, from: responseData)
                    } catch {
                        return observer.failed(.failedToParse(error: error))
                    }
                    
                    observer.completed(with: data)
            }
            
            return BlockDisposable {
                request.cancel()
            }
        }
    }
    
}
