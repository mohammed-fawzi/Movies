//
//  MoviesTabBarViewController.swift
//  Movies
//
//  Created by Mohamed Fawzy on 02/08/2024.
//

import UIKit

class MoviesTabBarViewController: UITabBarController {
    var appDependencyContainer: AppDependencyContainer!{
        didSet{
            setupViewControllers()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setupViewControllers() {
       
        let trendingMoviesVC = appDependencyContainer.makeTrendingMoviesListViewController()
        trendingMoviesVC.tabBarItem.title = "Trending"
        
        let upcomingMoviesVC = appDependencyContainer.makeUpcomingMoviesListViewController()
        upcomingMoviesVC.tabBarItem.title = "Upcoming"
        
        let nowPlayingMoviesVC = appDependencyContainer.makeNowPlayingMoviesListViewController()
        nowPlayingMoviesVC.tabBarItem.title = "Now playing"
        
        viewControllers = [trendingMoviesVC,nowPlayingMoviesVC,upcomingMoviesVC]
       }
}
