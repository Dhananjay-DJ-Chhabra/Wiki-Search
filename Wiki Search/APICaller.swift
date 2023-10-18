//
//  APICaller.swift
//  Wiki Search
//
//  Created by Dhananjay Chhabra on 18/10/23.
//

import Foundation



class APICaller{
    static let shared = APICaller()
    
    func getSearchResults(query: String, completionHandler: @escaping (Result<WikiSearchResult, Error>) -> Void){
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        
        guard let url = URL(string: "https://en.wikipedia.org/w/api.php?format=json&action=query&generator=search&gsrnamespace=0&gsrsearch=\(encodedQuery)&gsrlimit=10&prop=pageimages%7Cextracts&pilimit=max&exintro&explaintext&exsentences=1&exlimit=max") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)){ data, _, error in
            guard let data = data, error == nil else {return}
            do{
                let results = try JSONDecoder().decode(WikiSearchResult.self, from: data)
                completionHandler(.success(results))
            }catch{
                completionHandler(.failure(error))
            }
        }
        task.resume()
    }
    
    
}
