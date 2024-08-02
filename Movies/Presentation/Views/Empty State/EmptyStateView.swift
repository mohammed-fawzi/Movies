//
//  EmptyStateView.swift
//  Movies
//
//  Created by Mohamed Fawzy on 02/08/2024.
//

import UIKit

class EmptyStateView: UIView {
    @IBOutlet weak var tryAgainBtn: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    var tryAgainAction: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupEmptyStateView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupEmptyStateView()
    }
    
    private func setupEmptyStateView(){
        loadAndSnapToEdges()
    }
    
    @IBAction func tryAgainBtnTapped(sender: UIButton){
        tryAgainAction?()
    }
}
