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
        !firstLetter.isEmpty && !wordCount.isEmpty && !voterAmount.isEmpty && Int(wordCount) ?? 2 > 1
    }
    var errorCallback: ((Error) -> Void)?
    private let scheme: String
    private let host: String
    
    init(scheme: String = "https", host: String = "random-word-form.herokuapp.com") {
        self.scheme = scheme
        self.host = host
    }
    
//    private var _randomW: Bubba<[RandomWordElement]>
//    = Bubba(initialValue: [])
//    var $randomW: Publisher {
//        _randomW.projectedValue
//    }
//    var randomW: [RandomWordElement] {
//        get { _randomW.internalArray }
//        set {
//            objectWillChange.send()
//            _randomW.internalArray = newValue
//        }
//    }
//
    func getRandomWords(firstLetter: String, wordCount: String) {
        let firstLetter = firstLetter
        let wordCount = wordCount
        fetchRandomWords(url: createURL(firstletter: firstLetter, wordCount: wordCount)) { [weak self] result in
            switch result {
            case .success(let data):
                self?.randomWords = data.map {
                    RandomWordElement(randomWord: $0, voteCount: 0)
                }
//                for randomWord in data {
//                    self.randomWords.append(RandomWordElement(randomWord: randomWord, voteCount: 0))
//                }
            case .failure(let error):
                print(error)
                self?.errorCallback?(error)
            }
        }
            
            
            func fetchRandomWords(url: URL, completion: @escaping (Result<[String], Error>) -> Void) {
                let urlTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
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
                urlComponents.scheme = scheme
                urlComponents.host = host
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
