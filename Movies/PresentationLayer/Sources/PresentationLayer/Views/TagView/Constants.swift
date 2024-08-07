//
//  File.swift
//  
//
//  Created by Mohamed Fawzy on 07/08/2024.
//

import SwiftUI



extension TagView {
    struct Constants {
        static var unselectedBackgroundColor: Color = .cardSecondry
        static var selectedBackgroundColor: Color =  .accessory
        static var iconSize: CGSize = CGSize(width: 20, height: 20)
        static var stackSpacing: CGFloat = 5
        static var nameLabelFont: UIFont = .systemFont(ofSize: 14, weight: .semibold)
        static var unselectedNameLabelColor: Color =  .textSecondry
        static var selectedNameLabelColor: Color = .black
        static var tagHeight: CGFloat = 30
        static var tagPadding = UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 10)
    }
}

