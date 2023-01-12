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
    @Published var randomWords = [RandomWordElement]()
    @Published var voterAmount = ""
    var isReadyToFetch: Bool {
        !firstLetter.isEmpty && !wordCount.isEmpty && !voterAmount.isEmpty
    }
    
    func getRandomWords(firstLetter: String, wordCount: String) {
        let firstLetter = firstLetter
        let wordCount = wordCount
        fetchRandomWords(url: createURL(firstletter: firstLetter, wordCount: wordCount)) { result in
            switch result {
            case .success(let data):
                for randomWord in data {
                    self.randomWords.append(RandomWordElement(randomWord: randomWord, voteCount: 0))
                }
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
                return url!
            }
    }
    enum ResponseError: Error {
        case badStatusCode
    }
    func prepForTiebreaker(topVoteCount: Int) {
        randomWords = randomWords.filter { $0.voteCount == topVoteCount }
        for index in 0..<randomWords.count {
            randomWords[index].voteCount = 0
        }
    }
}


extension RandomWordFetcher {
    struct RandomWordElement: Hashable {
        let randomWord: String
        var voteCount: Int
    }
}
