//
//  File.swift
//  
//
//  Created by Mohamed Fawzy on 06/08/2024.
//

import SwiftUI

// MARK: - TagsView
struct TagsView: View {
    var tags: [Tag]
    // used to enable only one tag selection
    @State private var selectedTag: Int? = nil
    /// set this property to enable tags selection
    let selectionEnabled: Bool
    /// when selection is enabled will be called upon selection
    /// - Parameters:
    ///   - id: clicked tag id.
    ///   - isSelected: indicate the status of the tag selected or unselected.
    var tagAction: ((_ id:Int,_ isSelected: Bool)->Void)?
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(tags,id: \.id) { item in
                    TagView(tag: item, tagAction: tagAction, selectedTag: $selectedTag)
                        .disabled(!selectionEnabled)
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}

// MARK: - TagView
  struct TagView: View {
    var tag: Tag
    var tagAction: ((_ id:Int,_ isSelected: Bool)->Void)?
    @Binding var selectedTag: Int?
    private var isHighlited: Bool {
          return selectedTag == tag.id
      }
      
    var body: some View {
        Button(action:{
            // if already selected then unselect it
            if isHighlited {
                selectedTag = nil
            }else {
                selectedTag = tag.id
            }
            tagAction?(tag.id,isHighlited)
        }){
            HStack {
                if let icon = tag.icon {
                    Image(uiImage: icon)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(tag.iconColor ?? .accessory)
                        .frame(width: Constants.iconSize.width,height:  Constants.iconSize.height)
                }
                
                Text(tag.name)
                    .font(.subheadline)
                    .bold()
                    .foregroundStyle(isHighlited ? Constants.selectedNameLabelColor : Constants.unselectedNameLabelColor)
            }
            
        }
        .buttonStyle(.borderless)
        .padding()
        .background(isHighlited ? Constants.selectedBackgroundColor : Constants.unselectedBackgroundColor)
        .frame(maxHeight: Constants.tagHeight)
        .clipShape(RoundedRectangle(cornerRadius: Constants.tagHeight/2))
    }
}
