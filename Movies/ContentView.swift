//
//  ContentView.swift
//  Movies
//
//  Created by Mohamed Fawzy on 06/08/2024.
//

import SwiftUI
import PresentationLayer

struct ContentView: View {
    let dependencyContainer = AppDependencyContainer()
    var body: some View {
        dependencyContainer.makeTabsView()
    }
}
