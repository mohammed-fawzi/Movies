//
//  TagCollectionViewCell.swift
//  Movies
//
//  Created by Mohamed Fawzy on 03/08/2024.
//

import UIKit

struct TagCellConstants {
    static var unselectedBackgroundColor: UIColor = .cardSecondry
    static var selectedBackgroundColor: UIColor =  .accessory
    static var iconSize: CGSize = CGSize(width: 20, height: 20)
    static var stackSpacing: CGFloat = 5
    static var nameLabelFont: UIFont = .systemFont(ofSize: 14, weight: .semibold)
    static var unselectedNameLabelColor: UIColor =  .textSecondry
    static var selectedNameLabelColor: UIColor = .black
    static var tagHeight: CGFloat = 30
    static var tagPadding = UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 10)
}

class TagCollectionViewCell: UICollectionViewCell {
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = TagCellConstants.nameLabelFont
        label.textAlignment = .center
        return label
    }()
    
    private var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var contentStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = TagCellConstants.stackSpacing
        return stackView
    }()
    
    override var isSelected: Bool {
        didSet {setColors()}
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI(){
        setColors()
        contentView.layer.cornerRadius = TagCellConstants.tagHeight/2
        icon.anchor(width: TagCellConstants.iconSize.width,
                    height: TagCellConstants.iconSize.height)
        setupContentStack()
    }
    
    private func setColors(){
        contentView.backgroundColor = isSelected ? TagCellConstants.selectedBackgroundColor : TagCellConstants.unselectedBackgroundColor
        nameLabel.textColor = isSelected ? TagCellConstants.selectedNameLabelColor : TagCellConstants.unselectedNameLabelColor
    }
    
    private func setupContentStack(){
        contentStack.addArrangedSubview(icon)
        contentStack.addArrangedSubview(nameLabel)
        contentView.addSubview(contentStack)
        contentStack.anchor(top: contentView.topAnchor,
                            leading: contentView.leadingAnchor,
                            bottom: contentView.bottomAnchor,
                            trailing: contentView.trailingAnchor,
                            paddingTop: TagCellConstants.tagPadding.top,
                            paddingLeft: TagCellConstants.tagPadding.left,
                            paddingBottom: TagCellConstants.tagPadding.bottom,
                            paddingRight: -TagCellConstants.tagPadding.right)
    }
    
    func configure(withTag tag: Tag){
        nameLabel.text = tag.name
        guard let image = tag.icon else {icon.isHidden = true; return}
        icon.image = image
        icon.tintColor = tag.iconColor
        icon.isHidden = false
    }
}

// MARK: - Width Calculation
extension TagCollectionViewCell {
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = [NSAttributedString.Key.font : TagCellConstants.nameLabelFont]
        let labelWidth = nameLabel.text!.size(withAttributes: attributes).width
        let iconWidth = icon.image != nil ? icon.frame.width : 0
        let extraPadding: CGFloat = 5
        frame.size.width = labelWidth + iconWidth +
        TagCellConstants.stackSpacing +
        TagCellConstants.tagPadding.left + TagCellConstants.tagPadding.right + extraPadding
        layoutAttributes.frame = frame
        layoutIfNeeded()
        return layoutAttributes
    }
}
