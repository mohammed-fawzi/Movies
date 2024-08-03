//
//  TagsCollectionView.swift
//  Movies
//
//  Created by Mohamed Fawzy on 03/08/2024.
//

import UIKit

protocol TagsDelegate: AnyObject{
    func didSelect(tag: Tag, atIndex index: Int)
    func didDeselect(tag: Tag, atIndex index: Int)
}

class TagsCollectionView: UIView {
    /// Inject this property to show your tags
    var tags: [Tag]?{
        didSet{collectionView.reloadData()}
    }
    
    /// Enable single Tag Selection
    var allowTagSelection: Bool = true {
        didSet {
            collectionView.allowsSelection = allowTagSelection
        }
    }
    
    /// Enable multi Tag Selection
    var allowMultiTagSelection: Bool = false {
        didSet {
            collectionView.allowsMultipleSelection = allowMultiTagSelection
        }
    }
    
    private let cellID = "TagCollectionViewCell"
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.estimatedItemSize = CGSize(width: 80, height: 30)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TagCollectionViewCell.self,
                                forCellWithReuseIdentifier: cellID)
        collectionView.accessibilityIdentifier = "tagsCollectionView"
        collectionView.allowsSelection = allowTagSelection
        collectionView.allowsMultipleSelection = allowMultiTagSelection
        return collectionView
    }()
    weak var delegate: TagsDelegate?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }

    private func setupUI(){
       addCollectionView()
    }
    
    private func addCollectionView(){
        addSubview(collectionView)
        collectionView.anchor(top: topAnchor,
                              leading: leadingAnchor,
                              bottom: bottomAnchor,
                              trailing: trailingAnchor)
    }
}

// MARK: - Data Source
extension TagsCollectionView: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tags?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let tags = tags else {return UICollectionViewCell()}
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID,
                                                      for: indexPath) as? TagCollectionViewCell
        let tag = tags[indexPath.row]
        cell?.configure(withTag: tag)
        return cell ?? UICollectionViewCell()
    }
}

// MARK: - Delegate
extension TagsCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let tag = tags?[indexPath.row] else {return false}

        let item = collectionView.cellForItem(at: indexPath)
            if item?.isSelected ?? false {
                collectionView.deselectItem(at: indexPath, animated: true)
                delegate?.didDeselect(tag: tag, atIndex: indexPath.row)
                return false
            } else {
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
                delegate?.didSelect(tag: tag, atIndex: indexPath.row)
                return true
            }
    }
}
