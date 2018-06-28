//
//  MoviesViewModel.swift
//  Movies
//
//  Created by Ivan Tkachenko on 6/27/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import Foundation
import ReactiveKit

struct MoviesViewModel {
    
    let items = Property<[Movie]>([])
    
    private let dependencyContainer: MoviesDataModelContainer
    private let querySubject = SafePublishSubject<Void>()
    private let lastPage = Property(0)

    init(dependencyContainer: MoviesDataModelContainer) {
        self.dependencyContainer = dependencyContainer
    }
    
    func movies() -> SafeSignal<[Movie]> {
        return dependencyContainer.moviesDataModel.nowPlaying()
            .feedNext(into: items)
    }
    
    func queryMovies() -> LoadingSignal<Void, AppError> {
        let dataModel = dependencyContainer.moviesDataModel
        
        return querySubject.start(with: ())
            .with(latestFrom: lastPage) { _, page in page }
            .flatMapLatest { page in
                dataModel
                    .queryNowPlayingMovies(page: page + 1, forceUpdate: 0 == page)
                    .toLoadingSignal()
            }
            .mapValue { result in self.lastPage.value = result.page }
    }
    
    func requery() {
        lastPage.value = 0
        querySubject.next()
    }
    
    func queryNext() {
        querySubject.on(.next(()))
    }
    
}
