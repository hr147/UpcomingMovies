//
//  UpcomingMoviesCoordinator.swift
//  UpcomingMovies
//
//  Created by Alonso on 6/13/20.
//  Copyright © 2020 Alonso. All rights reserved.
//

import UIKit
import UpcomingMoviesDomain

class UpcomingMoviesCoordinator: NSObject, Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    
    var navigationDelegate: UpcomingMoviesNavigationDelegate!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = UpcomingMoviesViewController.instantiate()
        
        let useCaseProvider = InjectionFactory.useCaseProvider()
        let contentHandler = UpcomingMoviesContentHandler(movieUseCase: useCaseProvider.movieUseCase())
        let viewModel = UpcomingMoviesViewModel(useCaseProvider: useCaseProvider,
                                                contentHandler: contentHandler)
        
        viewController.coordinator = self
        viewController.viewModel = viewModel
        
        setNavigationDelegate()
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    // MARK: - Navigation
    
    func showDetail(for movie: Movie) {
        let movieDetailCoordinator = MovieDetailCoordinator(navigationController: navigationController)
        movieDetailCoordinator.movie = movie
        movieDetailCoordinator.parentCoordinator = self
        childCoordinators.append(movieDetailCoordinator)
        movieDetailCoordinator.start()
    }
    
    // MARK: - Navigation Configuration
    
    func setNavigationDelegate() {
        self.navigationDelegate = UpcomingMoviesNavigationDelegate()
        self.navigationController.delegate = self.navigationDelegate
    }
    
    func configureNavigationDelegate(with selectedFrame: CGRect,
                                     and imageToTransiton: UIImage?,
                                     transitionOffset: CGFloat) {
        navigationDelegate.configure(selectedFrame: selectedFrame, with: imageToTransiton)
        navigationDelegate.updateOffset(transitionOffset)
    }
    
}

extension UpcomingMoviesCoordinator: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }

        // Check whether our view controller array already contains that view controller.
        //If it does it means we’re pushing a different view controller on top rather than popping it, so exit.
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }

        // We’re still here – it means we’re popping the view controller, so we can check whether it’s a buy view controller
        if let buyViewController = fromViewController as? MovieDetailViewController,
            let coordinator = buyViewController.coordinator {
            // We're popping a buy view controller; end its coordinator
            childDidFinish(coordinator)
        }
    }
    
}
