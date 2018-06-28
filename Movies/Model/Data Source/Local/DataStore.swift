//
//  DataStore.swift
//  Movies
//
//  Created by Ivan Tkachenko on 6/27/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import Foundation
import ReactiveKit

class DataStore: MoviesLocalDataSource {
    
    static let defaultQueueName = "DataStoreQueue"
    
    private let queue: DispatchQueue
    private let moviesInfoSubject = SafeReplayOneSubject<[MoviesResult]>()
    
    private var _moviesInfo = [MoviesResult]()
    private var moviesInfo: [MoviesResult] {
        set {
            queue.async {
                self._moviesInfo = newValue
                self.moviesInfoSubject.next(newValue)
            }
        }
        get {
            return _moviesInfo
        }
    }
    
    init(queue: DispatchQueue = DispatchQueue(label: DataStore.defaultQueueName)) {
        self.queue = queue
    }

    func nowPlaying() -> Signal<[Movie], NoError> {
        return moviesInfoSubject.map { info in
            info.flatMap { $0.results }
        }
    }
    
    func save(_ moviesResult: MoviesResult, forceUpdate: Bool) {
        moviesInfo = forceUpdate ? [moviesResult] : moviesInfo + [moviesResult]
    }
    
}
