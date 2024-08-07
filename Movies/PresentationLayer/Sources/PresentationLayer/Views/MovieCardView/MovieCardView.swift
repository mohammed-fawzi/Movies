//
//  MovieCardView.swift
//  
//
//  Created by Mohamed Fawzy on 06/08/2024.
//

import SwiftUI
import DomainLayer


// MARK: - MovieCardView
struct MovieCardView: View {
    let movie: Movie

    init(movie: Movie) {
        self.movie = movie
    }
    
    var body: some View {
        
        Group {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.cardPrimary)
                        .frame(maxWidth: .infinity, maxHeight: 160)
                    
                    HStack(alignment: .top,spacing: 0) {
                        MovieCardPoster(url: movie.posterUrl)
                            .padding(.trailing,5)
                        MovieCardInfoView(movie: movie)
                        Spacer()
                    }.padding()
                }
            .padding()
            .listRowBackground(Color(.clear))
        }
    }
}

// MARK: - MovieCardInfoView
private struct MovieCardInfoView: View {
    let movie: Movie
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(movie.title ?? "")
                .foregroundColor(.textPrimary)
                .lineLimit(1)
                .font(.title2)
                .bold()
            
            Text(movie.releaseDate ?? "")
                .foregroundColor(.textSecondry)
                .font(.headline)
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.accessory)
                    .imageScale(.large)
                
                Text(String(format: "%.1f", movie.score ?? ""))
                    .foregroundColor(.accessory)
                    .font(.headline)
                    .bold()
            }
        }.padding(.top,10)
    }
}

// MARK: - MovieCardPoster
struct MovieCardPoster: View {
    let url: String?
    var body: some View {
        CachableImage(url: url ?? "")
            .scaledToFit()
            .frame(maxWidth: 120,maxHeight: 160)
            .offset(y:-40)
    }
}

// MARK: - Preview
#Preview {
    MovieCardView(movie: Movie(id: 2,
                               title: "Lord Of the Rings",
                               releaseDate: "2024-17-3"))
}
