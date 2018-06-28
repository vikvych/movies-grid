//
//  MainFlowCoordinator.swift
//  Movies
//
//  Created by Ivan Tkachenko on 6/27/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import UIKit

class MainFlowCoordinator: NSObject, MoviesFlowCoordinator, MovieDetailsFlowCoordinator {
    
    private let navigationController: UINavigationController
    private let dependencyContainer: DependencyContainer
    
    init(navigationController: UINavigationController, dependencyContainer: DependencyContainer) {
        self.navigationController = navigationController
        self.dependencyContainer = dependencyContainer
    }
    
    func showMovies() {
        let controller = MoviesViewController()
        controller.flowCoordinator = self
        controller.viewModel = MoviesViewModel(dependencyContainer: dependencyContainer)
        navigationController.viewControllers = [controller]
    }
    
    func showMovieDetails(movie: Movie) {
        let controller = MovieDetailsViewController(nibName: MovieDetailsViewController.nibName, bundle: nil)
        controller.flowCoordinator = self
        controller.viewModel = MovieDetailsViewModel(movie: movie)
        navigationController.pushViewController(controller, animated: true)
    }
    
    func back() {
        navigationController.popViewController(animated: true)
    }
    
}
