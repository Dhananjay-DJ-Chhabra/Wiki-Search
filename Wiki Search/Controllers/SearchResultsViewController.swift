//
//  SearchResultsViewController.swift
//  Wiki Search
//
//  Created by Dhananjay Chhabra on 18/10/23.
//

import UIKit

class SearchResultsViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Results"
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let resultsTable: UITableView = {
        let table = UITableView()
        table.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
        table.showsVerticalScrollIndicator = false
        table.allowsSelection = false
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let noDataFoundImage: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(systemName: "exclamationmark.circle.fill")
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = 10
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    private let noDataFoundLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Ooops!! No data Found."
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let noDataFoundContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var result: [Page]?
    
    weak var dismissKeyboardDelegate: DismissKeyboard?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
        
        resultsTable.delegate = self
        resultsTable.dataSource = self
        
        let tapToRemoveKeyboard = UITapGestureRecognizer(target: self, action: #selector(removeKeyboard))
        view.addGestureRecognizer(tapToRemoveKeyboard)
    }
    
    @objc func removeKeyboard(){
        dismissKeyboardDelegate?.dismissKeyboardOnTap()
    }
    
    func setUpView(){
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
        
        view.addSubview(resultsTable)
        NSLayoutConstraint.activate([
            resultsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            resultsTable.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            resultsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
    
    func setUpNoDataFoundView(){
        resultsTable.isHidden = true
        removeNoDataFoundView()
        
        noDataFoundImage.image = noDataFoundImage.image?.withRenderingMode(.alwaysTemplate)
        noDataFoundImage.tintColor = .label
        
        view.addSubview(noDataFoundContainerView)
        NSLayoutConstraint.activate([
            noDataFoundContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            noDataFoundContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            noDataFoundContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            noDataFoundContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
        
        noDataFoundContainerView.addSubview(noDataFoundImage)
        NSLayoutConstraint.activate([
            noDataFoundImage.topAnchor.constraint(equalTo: noDataFoundContainerView.topAnchor),
            noDataFoundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noDataFoundImage.heightAnchor.constraint(equalToConstant: view.bounds.width / 3),
            noDataFoundImage.widthAnchor.constraint(equalToConstant: view.bounds.width / 3)
        ])
        
        noDataFoundContainerView.addSubview(noDataFoundLabel)
        NSLayoutConstraint.activate([
            noDataFoundLabel.topAnchor.constraint(equalTo: noDataFoundImage.bottomAnchor, constant: 10),
            noDataFoundLabel.centerXAnchor.constraint(equalTo: noDataFoundImage.centerXAnchor),
            noDataFoundImage.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.7)
        ])
    }

    func removeNoDataFoundView(){
        noDataFoundContainerView.removeFromSuperview()
        noDataFoundImage.removeFromSuperview()
        noDataFoundLabel.removeFromSuperview()
    }

}

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let result = result else { return 0}
        return result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier, for: indexPath) as? SearchResultTableViewCell else { return UITableViewCell()}
        guard let result = result else { return UITableViewCell() }
        let currentRowData = result[indexPath.row]
        cell.configureView(title: currentRowData.title, subtitle: currentRowData.extract, iconUrl: currentRowData.thumbnail?.source)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        removeKeyboard()
    }
    
}
