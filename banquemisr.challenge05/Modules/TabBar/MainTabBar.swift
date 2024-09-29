//
//  MainTabBar.swift
//  banquemisr.challenge05
//
//  Created by Youssif Hany on 29/09/2024.
//

import UIKit

class MainTabBar: UITabBarController {

    override func viewDidLoad() {
            super.viewDidLoad()
            
            let nowPlayingVC = createNavController(for: "MoviesListViewController", title: "Now Playing", image: "play.fill", movieType: .nowPlaying)
            let popularVC = createNavController(for: "MoviesListViewController", title: "Popular", image: "globe", movieType: .popular)
            let upcomingVC = createNavController(for: "MoviesListViewController", title: "Upcoming", image: "square.and.arrow.down.fill", movieType: .upcoming)
            
            viewControllers = [nowPlayingVC, popularVC, upcomingVC]
        }
        
        private func createNavController(for storyboardID: String, title: String, image: String, movieType: NetworkManager.MovieType) -> UINavigationController {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let moviesListVC = storyboard.instantiateViewController(withIdentifier: storyboardID) as! MoviesListViewController
            moviesListVC.movieType = movieType
            let navController = UINavigationController(rootViewController: moviesListVC)
            navController.tabBarItem.title = title
            navController.tabBarItem.image = UIImage(systemName: image)
            return navController
        }

}
