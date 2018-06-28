//
//  ApiService+Movies.swift
//  Movies
//
//  Created by Ivan Tkachenko on 6/27/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import Foundation
import ReactiveKit

extension ApiService: MoviesRemoteDataSource {
    
    func queryNowPlayingMovies(page: Int) -> Signal<MoviesResult, ApiError> {
        return query(.nowPlayingMovies, parameters: ["page": page])
    }
    
}
