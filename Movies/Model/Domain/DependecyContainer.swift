//
//  DependecyContainer.swift
//  Movies
//
//  Created by Ivan Tkachenko on 6/27/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import Foundation

struct DependencyContainer: MoviesDataModelContainer {
    
    let moviesDataModel: MoviesDataModel
    
}

extension DependencyContainer {
    
    static func defaultContainer() -> DependencyContainer {
        let apiService = ApiService()
        let dataStore = DataStore()

        return DependencyContainer(
            moviesDataModel: MoviesDataModel(remoteDataSource: apiService, localDataSource: dataStore)
        )
    }
    
}
