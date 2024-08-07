//
//  MoviesListView.swift
//
//
//  Created by Mohamed Fawzy on 06/08/2024.
//

import SwiftUI
import DomainLayer

// MARK: - MoviesListView
 struct MoviesListView: View {
    @ObservedObject private var viewModel: MoviesListViewModel
    var title: String = ""
    let makeDetailsView: (Movie)-> MovieDetailsView
   
     init(title: String,
          viewModel: MoviesListViewModel,
         makeDetailsView: @escaping (Movie)-> MovieDetailsView){
        self.viewModel = viewModel
        self.makeDetailsView = makeDetailsView
        self.title = title
    }
    
    public var body: some View {
        if viewModel.showEmptyState {
            EmptyStateView(tryAgainAction: viewModel.tryAgainButtonDidTapped)
        }else {
            MainView(title: title,
                     viewModel: viewModel,
                     makeDetailsView: makeDetailsView)
        }
    }
}

// MARK: - MainView
 fileprivate struct MainView: View {
    @ObservedObject private var viewModel: MoviesListViewModel
    @State private var searchText = ""
    @Environment(\.isSearching) private var isSearching: Bool
    let makeDetailsView: (Movie)-> MovieDetailsView
    var title: String = ""

     init(title: String,
          viewModel: MoviesListViewModel,
         makeDetailsView: @escaping (Movie)-> MovieDetailsView){
        self.viewModel = viewModel
        self.makeDetailsView = makeDetailsView
        self.title = title
    }
     
    var body: some View {
        NavigationStack {
            VStack {
                TagsView(tags: viewModel.genreFilters,
                         selectionEnabled: true,
                         tagAction: viewModel.didTapFilter)
                .padding([.bottom])

                MoviesList(viewModel: viewModel,
                           makeDetailsView: makeDetailsView)
            }
            .background(Color(.background))
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            UIRefreshControl.appearance().tintColor = .white
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        }
        .refreshable {
          viewModel.refresh()
        }
        
        .searchable(text: $searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Search For Your Favorite Movie")
        .onSubmit(of: .search) {
            viewModel.searchButtonDidTapped(withText: searchText)
        }
        .onChange(of: searchText) { _,_ in
            if searchText.isEmpty && !isSearching {
                viewModel.cancelSearchButtonDidTapped()
            }
        }
        .alert(isPresented: $viewModel.showErrorAlert) {
            Alert(title: Text("OOPs"),
                  message: Text(viewModel.errorMessage),
                  dismissButton: .default(Text("Dismiss")))
        }
    }
}


// MARK: - MoviesList
 fileprivate struct MoviesList: View {
    @ObservedObject private var viewModel: MoviesListViewModel
     let makeDetailsView: (Movie)-> MovieDetailsView
     
     init(viewModel: MoviesListViewModel,
         makeDetailsView: @escaping (Movie)-> MovieDetailsView){
        self.viewModel = viewModel
        self.makeDetailsView = makeDetailsView
    }

    var body: some View {
            List(0..<viewModel.getNumberOfMovies(), id: \.self){ index in
                let movie = viewModel.getMovie(atIndex: index)
                    MovieCardView(movie: movie)
                    .onAppear{
                      viewModel.didShowRow(atIndex: index)
                     }
                    .background(NavigationLink("",destination: makeDetailsView(movie)))
                    .frame(maxWidth: .infinity)
                    .listRowInsets(EdgeInsets())
            }
            .listStyle(.plain)
            if viewModel.showFooterActivityIndicator {
                ProgressView()
                    .tint(.white)
                    .background(.clear)
            }
    }
}

// MARK: - Preview
#Preview {
    AppDependencyContainer().makeListView(ofType: .trending)
}

