//
//  RandomWordFetcher.swift
//  RandomSprintNameGenerator(SwiftVersion)
//
//  Created by Yannick Brands on 15.12.22.
//

import Foundation

class RandomWordFetcher: ObservableObject {
    
    @Published var firstLetter = ""
    @Published var wordCount = ""
    
    func getRandomWords(firstLetter: String, wordCount: String) {
        let firstLetter = firstLetter
        let wordCount = wordCount
        fetchRandomWords(url: createURL(firstletter: firstLetter, wordCount: wordCount)) { result in
//            defer {
//                self.isLoading = false
//            }
            switch result {
            case .success(let data):
                print("yay")
            case .failure(let error):
                print(error)
            }
        }
            
            
            func fetchRandomWords(url: URL, completion: @escaping (Result<[String], Error>) -> Void) {
                let urlTask = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                    if let error = error {
                        DispatchQueue.main.async { completion(.failure(error)) }
                        return
                    }
                    guard let data = data, let httpResponse = response as? HTTPURLResponse,
                          httpResponse.statusCode == 200 else {
                        DispatchQueue.main.async { completion(.failure(ResponseError.badStatusCode)) }
                        return
                    }
                    do {
                        let decodedData = try JSONDecoder().decode([String].self, from: data)
                        DispatchQueue.main.async {
                            print(decodedData)
                            completion(.success(decodedData)) }
                    } catch {
                        DispatchQueue.main.async { completion(.failure(error)) }
                    }
                }
                urlTask.resume()
            }
            
            func createURL(firstletter: String, wordCount: String)  -> URL {
                let firstletter = firstletter
                let wordCount = wordCount
                
                var urlComponents = URLComponents()
                urlComponents.scheme = "https"
                urlComponents.host = "random-word-form.herokuapp.com"
                urlComponents.path = "/random/noun/\(firstletter)"
                
                urlComponents.queryItems = [ URLQueryItem(name: "count", value: wordCount) ]
                let url = urlComponents.url
                print(url!)
                return url!
            }
        }
        enum ResponseError: Error {
            case badStatusCode
        }
    }
//         e.g. https://random-word-form.herokuapp.com/random/noun/a?count=3 , letter and count based on input

