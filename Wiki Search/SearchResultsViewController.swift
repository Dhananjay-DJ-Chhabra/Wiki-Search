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
    
    var result: [Page]?

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
        
        resultsTable.delegate = self
        resultsTable.dataSource = self
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
    
    
}
