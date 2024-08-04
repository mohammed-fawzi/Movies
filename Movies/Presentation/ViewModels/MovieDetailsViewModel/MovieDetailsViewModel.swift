//
//  MovieDetailsViewModel.swift
//  Movies
//
//  Created by Mohamed Fawzy on 03/08/2024.
//

import Foundation
import Combine
import DomainLayer
import Common

class MovieDetailsViewModel {
    // MARK: - Properties
    private let movie: Movie
    private var movieDetails: MovieDetails?
    private let useCase: MovieUseCaseProtocol
    private let coordinator: Coordinator
    // MARK: - Subjects
    @Published private(set) var poster = ""
    @Published private(set) var title = ""
    @Published private(set) var overview = ""
    @Published private(set) var genres = ""
    @Published private(set) var tags = [(name:String, icon: String?,iconColor: String?)]()
    @Published private(set) var errorMessage = ""

    init(useCase: MovieUseCaseProtocol, movie: Movie, coordinator: Coordinator) {
        self.movie = movie
        self.useCase = useCase
        self.coordinator = coordinator
        setIntialMovieDetails()
    }
}

// MARK: - Fetching Extra Movie details
extension MovieDetailsViewModel {
    func viewDidLoad(){
        useCase.getMovie(withId: movie.id) { [weak self] result in
            switch result {
            case .success(let movieDetails):
                self?.handleFetchingMovieDetailsSuccess(movieDetails: movieDetails)
            case .failure(let error):
                self?.handleFetchingMovieDetialsFailure(error: error)
            }
        }
    }
    
    private func handleFetchingMovieDetailsSuccess(movieDetails: MovieDetails){
        self.movieDetails = movieDetails
        setGenres()
        setTags()
    }
    
    private func handleFetchingMovieDetialsFailure(error: MoviesError){
        errorMessage = error.customMessage
    }
}

// MARK: - Actions
extension MovieDetailsViewModel {
    func homePageButtonDidTapped(){
        guard let url = movieDetails?.homePageUrl else {return}
        coordinator.openExternalURL(url: url)
    }
}

// MARK: - Init UI
extension MovieDetailsViewModel {
    private func setIntialMovieDetails(){
        poster = movie.posterUrl ?? ""
        title = movie.title ?? ""
        overview = movie.overview ?? ""
    }
    
    private func setGenres() {
        guard let genres = movieDetails?.genres else {return}
        self.genres = genres.joined(separator:", ")
    }
}

// MARK: - Tags
extension MovieDetailsViewModel {
    
    private func setTags(){
        setSpokenLanguagesTag()
        setScoreTag()
        setReleaseDate()
        setRuntimeTag()
        setStatusTag()
        setBudgetTag()
        setRevenueTag()
    }
    private func setRuntimeTag(){
        guard let runtime = movieDetails?.runtime else{return}
        tags.append((name: "\(runtime) Min",
                     icon: "clock.arrow.circlepath",
                     iconColor: "TextSecondryColor"))
    }
    
    private func setStatusTag(){
        guard let status = movieDetails?.status else {return}
        tags.append((name: status,
                     icon: nil,
                     iconColor: nil))
    }
    
    private func setSpokenLanguagesTag(){
        guard let langs = movieDetails?.spokenLanguage else {return}
        tags.append((name: langs.joined(separator: ",").uppercased(),
                     icon: nil,
                     iconColor: nil))
    }
    
    private func setBudgetTag(){
        guard let budget = movieDetails?.budget else {return}
        let formattedbudget = Double(budget)/1000000
        let roundedVal = String(format: "%.1f", formattedbudget)
        tags.append((name: "Budget: \(roundedVal)M",
                     icon: nil,
                     iconColor: nil))
    }
    
    private func setRevenueTag(){
        guard let revenue = movieDetails?.revenue else {return}
        let formattedRevenue = Double(revenue)/1000000
        let roundedVal = String(format: "%.1f", formattedRevenue)
        tags.append((name: "Revenue: \(roundedVal)M",
                     icon: nil,
                     iconColor: nil))
    }
    
    private func setScoreTag(){
        guard let score = movieDetails?.score else {return}
        let roundedScore = String(format: "%.1f", score)
        tags.append((name: roundedScore,
                     icon: "star.fill",
                     iconColor: "AccessoryColor"))
    }
    
    private func setReleaseDate(){
        guard let releaseDate = movieDetails?.releaseDate else {return}
        tags.append((name: releaseDate,
                     icon: nil,
                     iconColor: nil))
    }
}
