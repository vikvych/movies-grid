//
//  MoviesDataModel.swift
//  Movies
//
//  Created by Ivan Tkachenko on 6/27/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import Foundation
import ReactiveKit

protocol MoviesDataModelContainer {
    
    var moviesDataModel: MoviesDataModel { get }
    
}

protocol MoviesRemoteDataSource {
    
    func queryNowPlayingMovies(page: Int) -> Signal<MoviesResult, ApiError>

}

protocol MoviesLocalDataSource {
    
    func nowPlaying() -> SafeSignal<[Movie]>
    func save(_ moviesResult: MoviesResult, forceUpdate: Bool)
    
}

struct MoviesResult: Decodable {
    let page: Int
    let totalPages: Int
    let totalResults: Int
    let results: [Movie]
}

struct MoviesDataModel {
    
    private let remoteDataSource: MoviesRemoteDataSource
    private let localDataSource: MoviesLocalDataSource
    
    init(remoteDataSource: MoviesRemoteDataSource, localDataSource: MoviesLocalDataSource) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    func nowPlaying() -> SafeSignal<[Movie]> {
        return localDataSource.nowPlaying()
    }
    
    func queryNowPlayingMovies(page: Int = 1, forceUpdate: Bool = false) -> Signal<MoviesResult, AppError> {
        let localDataSource = self.localDataSource
        
        return remoteDataSource.queryNowPlayingMovies(page: page)
            .doOn(next: { localDataSource.save($0, forceUpdate: forceUpdate) })
            .mapError(AppError.api)
    }
    
}
