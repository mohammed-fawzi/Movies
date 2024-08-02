//
//  UIViewController+Extention.swift
//  Movies
//
//  Created by Mohamed Fawzy on 02/08/2024.
//

import UIKit

fileprivate var containerView: UIView!
extension UIViewController {
    
    ///Shows a center alert on the caller UIViewController
    /// - Parameters:
    /// - WithTitle: title of the alert
    /// - andErrorMessage: message of the alert
    func showAlert(withTitle title: String, andErrorMessage message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    
    ///Shows a blocking loading screen on the caller UIViewController
    func showLoadingIndicator(){
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        containerView.backgroundColor = .black
        containerView.alpha = 0
        UIView.animate(withDuration: 0.25) { containerView.alpha = 0.6 }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    ///Dismiss loading screen on the caller UIViewController
    func dismissLoadingIndicator(){
        DispatchQueue.main.async {
            containerView.removeFromSuperview()
            containerView = nil
        }
    }
}
