//
//  MovieDetailsView.swift
//
//
//  Created by Mohamed Fawzy on 06/08/2024.
//

import SwiftUI
import DomainLayer

fileprivate let ids = AccessibilityIds.MovieDetailsView.self

// MARK: - MovieDetailsView
struct MovieDetailsView: View {
    @ObservedObject var viewModel: MovieDetailsViewModel
    
    var body: some View {
        VStack(alignment: .center){
            CachableImage(url: viewModel.poster)
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: 250)
                .accessibilityIdentifier(ids.detailsPosterImage.rawValue)
            VStack {
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.cardPrimary)
                        .frame(maxWidth: .infinity, maxHeight: 350)
                    MovieDetailsContent(viewModel: viewModel)
                }.padding(8)
                GoToHomeButton(url: viewModel.destinationUrl)
                Spacer()
            }
            
        }
        .edgesIgnoringSafeArea(.top)
        .background(Color(.background))
        .alert(isPresented: $viewModel.showErrorAlert) {
            Alert(title: Text("OOPs"),
                  message: Text(viewModel.errorMessage),
                  dismissButton: .default(Text("Dismiss")))
        }
    }
}

// MARK: - MovieDetailsContent
fileprivate struct MovieDetailsContent: View {
    @ObservedObject var viewModel: MovieDetailsViewModel
    var body: some View {
        Group{
            VStack(alignment: .leading){
                Text(viewModel.title)
                    .font(.title)
                    .bold()
                    .foregroundStyle(Color(.textPrimary))
                    .accessibilityIdentifier(ids.detailsTitleLabel.rawValue)
                Text(viewModel.genres)
                    .font(.title3)
                    .foregroundStyle(Color(.textTernary))
                    .accessibilityIdentifier(ids.detailsGenresLabel.rawValue)
                ScrollView{
                    Text(viewModel.overview)
                        .font(.body)
                        .foregroundStyle(Color(.textSecondry))
                        .accessibilityIdentifier(ids.detailsOverviewTextView.rawValue)
                }
                TagsView(tags: createTags(), selectionEnabled: false)
                    .accessibilityIdentifier(ids.detailsTagsView.rawValue)
            }
            .padding()
        }
        .frame(maxWidth: .infinity,maxHeight:300)
        .background(Color(.clear))
        
    }
}

// MARK: - GoToHomeButton
fileprivate struct GoToHomeButton: View {
    @Environment(\.openURL) var openURL
    let url: URL?
    
    var body: some View {
        Button(action: {
            if let url = url {
                openURL(url)
            }
        }) {
            Text("Home Page")
                .frame(minWidth: 0, maxWidth: 300)
                .font(.system(size: 18))
                .padding()
                .foregroundColor(.white)
            
        }
        .background(Color(.buttonPrimary))
        .cornerRadius(25)
        .padding(.top,20)
        .accessibilityIdentifier(ids.gotoHomeButton.rawValue)
    }
}

// MARK: - Tags
extension MovieDetailsContent {
    private func createTags()-> [Tag]{
        var tags = [Tag]()
        for i in 0..<viewModel.tags.count {
            let tagTuple = viewModel.tags[i]
            let tag = createTag(id: i, data: tagTuple)
            tags.append(tag)
        }
        return tags
    }
    
    private func createTag(id: Int, data: (name:String, icon: String?,iconColor: String?) ) -> Tag {
        let icon = data.icon != nil ? UIImage(systemName: data.icon!) : nil
        let color = data.iconColor != nil ? Color(data.iconColor!, bundle: .module) : nil
        return Tag(id: id, name: data.name, icon: icon, iconColor: color)
    }
}

#Preview {
    AppDependencyContainer().makeMovieDetailsView(movie: Movie(id: 22))
}

