//
//  ViewController.swift
//  Wiki Search
//
//  Created by Dhananjay Chhabra on 18/10/23.
//

import UIKit

protocol DismissKeyboard: AnyObject{
    func dismissKeyboardOnTap()
}

class MainViewController: UIViewController {
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search across Wikipedia ..."
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    private let searchImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(systemName: "magnifyingglass.circle.fill")
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = 10
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    private let getStartedLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Get Started !!"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let browseLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Go ahead and start browsing across Wikipedia 🔍"
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search Wikipedia"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        navigationItem.searchController = searchController

        view.backgroundColor = .systemBackground
        
        searchController.searchResultsUpdater = self
        
        setUpView()
        
        let removeKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(removeKeyboard))
        view.addGestureRecognizer(removeKeyboardTap)
        
    }
    
    @objc func removeKeyboard(){
        resignKeyboardFirstResponder()
        searchController.isActive = false
    }
    
    @objc func resignKeyboardFirstResponder(){
        searchController.searchBar.resignFirstResponder()
    }
    
    func setUpView(){
        searchImageView.image = searchImageView.image?.withRenderingMode(.alwaysTemplate)
        searchImageView.tintColor = .label
        view.addSubview(searchImageView)
        NSLayoutConstraint.activate([
            searchImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            searchImageView.heightAnchor.constraint(equalToConstant: view.bounds.width / 2),
            searchImageView.widthAnchor.constraint(equalToConstant: view.bounds.width / 2)
        ])
        
        view.addSubview(getStartedLabel)
        NSLayoutConstraint.activate([
            getStartedLabel.topAnchor.constraint(equalTo: searchImageView.bottomAnchor, constant: 20),
            getStartedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            getStartedLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        view.addSubview(browseLabel)
        NSLayoutConstraint.activate([
            browseLabel.topAnchor.constraint(equalTo: getStartedLabel.bottomAnchor, constant: 20),
            browseLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            browseLabel.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.7),
            browseLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20)
        ])
    }

}

extension MainViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text
        
        guard let trimmedQuery = query,
              !trimmedQuery.trimmingCharacters(in: .whitespaces).isEmpty,
              trimmedQuery.trimmingCharacters(in: .whitespaces).count >= 1 else { return }
        guard let searchResultsController = searchController.searchResultsController as? SearchResultsViewController else { return }
        searchResultsController.dismissKeyboardDelegate = self
        
        var pageResults: [Page] = []
        
        APICaller.shared.getSearchResults(query: trimmedQuery) { result in
            switch result {
            case .success(let results):
                let pages = results.query.pages
                for (_, page) in pages {
                    pageResults.append(page)
                }
                DispatchQueue.main.async {
                    searchResultsController.resultsTable.isHidden = false
                    searchResultsController.removeNoDataFoundView()
                    searchResultsController.result = pageResults
                    searchResultsController.resultsTable.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    searchResultsController.setUpNoDataFoundView()
                }
                print(error.localizedDescription)
            }
        }
    }
}

extension MainViewController: DismissKeyboard{
    func dismissKeyboardOnTap() {
        resignKeyboardFirstResponder()
    }
}
