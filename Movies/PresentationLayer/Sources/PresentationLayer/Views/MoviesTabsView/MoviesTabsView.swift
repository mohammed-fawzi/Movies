//
//  MoviesTabsView.swift
//  
//
//  Created by Mohamed Fawzy on 06/08/2024.
//

import SwiftUI

public struct MoviesTabsView: View {
    let dependencyContainer: AppDependencyContainer
    init(dependencyContainer: AppDependencyContainer) {
        self.dependencyContainer = dependencyContainer
    }
    public var body: some View {
        let trendingTitle = "Trending"
        let nowPlayingTitle = "Now Playing"
        let upcomingTitle = "Upcoming"
        TabView {
            dependencyContainer.makeListView(ofType: .trending, title: trendingTitle)
                .tabItem {Text(trendingTitle)}

            dependencyContainer.makeListView(ofType: .nowPlaying,title: nowPlayingTitle)
                .tabItem {Text(nowPlayingTitle)}
            
            dependencyContainer.makeListView(ofType: .upcoming, title: upcomingTitle)
                .tabItem {Text(upcomingTitle)}
                
        }
        .frame(maxHeight: .infinity)
        .ignoresSafeArea()
        .onAppear(){
           setupTabBarAppearance()
           setupTabBarItemAppearance()
        }
    }
    
  
}

// MARK: - Tab Bar Appearance
extension MoviesTabsView {
    private func setupTabBarItemAppearance(){
        let font = UIFont.systemFont(ofSize: 16, weight: .bold)
        let keys = NSAttributedString.Key.self
        UITabBarItem.appearance().setTitleTextAttributes([keys.font:font],
                                                         for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([keys.foregroundColor:UIColor.white],
                                                         for: .selected)
    }
    
    private func setupTabBarAppearance(){
        let appearance = UITabBar.appearance()
        appearance.backgroundColor = UIColor(.background)
        appearance.barTintColor = UIColor(.background)
        appearance.tintColor = .white
    }
}

#Preview {
    MoviesTabsView(dependencyContainer: AppDependencyContainer())
}
