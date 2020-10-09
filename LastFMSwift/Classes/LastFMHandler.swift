//
//  LastFMHandler.swift
//  Last.fm-Swift
//
//  Created by Daniel Chirita on 09/10/2020.
//

import Foundation

open class LastFMHandler {
    
    public typealias Completion = (Result<Data, Error>) -> Void
    
    public static let LastFMHandlerErrorDomain = "LastFMHandlerErrorDomain"
    
    public init(apiKey: String) {
        self.apiKey = apiKey
        
        assert(apiKey.count > 0, "Please provide a valid Last FM api key")
    }
    
    open func artistFor(name: String, completion: @escaping ((Result<LastFMArtist, Error>) -> ())) {
        
        self.metadataFor(artistName: name) { result in
            
            switch result {
                
            case .success(let data):
                
                guard let response = try? JSONDecoder().decode(LastFMArtistResponse.self,
                                                               from: data),
                      let artist = response.artist else {
                
                        main {
                            completion(.failure(self.defaultError))
                        }
                        
                        return
                }
                
                main {
                    completion(.success(artist))
                }
                
            case .failure(let error):
                main {
                    completion(.failure(error))
                }
            }
        }
    }
    
    open func metadataFor(artistName: String,
                          completion: @escaping Completion) {
        
        guard let url = self.urlFor(artistName: artistName) else {
            return
        }
        
        // Create GET Request
        
        var request = URLRequest(url: url)
        request.addValue("application/json",
                         forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",
                         forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        
        // Call LastFM endpoint
        
        self.task = urlSession.dataTask(with: request) { (data, response, error) in
            
            if let data = data {
                main {
                    completion(.success(data))
                }
                
            } else {
                main {
                    completion(.failure(error ?? self.defaultError))
                }
            }
        }
        
        self.task?.resume()
    }
    
    // MARK: PrivateAPI
    
    private let apiKey: String
    private lazy var urlSession: URLSession = {
       
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        return session
    }()
    
    private var task: URLSessionDataTask?
}

private extension LastFMHandler {
    
    func urlFor(artistName: String) -> URL? {
        
        let paramsFormat = "artist.getinfo&artist=%@&api_key=" + self.apiKey + "&format=json"
        
        let params = String(format: paramsFormat, artistName) as NSString
        
        guard let encodedParams = params
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                return nil
        }
        
        let urlString = "https://ws.audioscrobbler.com/2.0/?method=" + encodedParams
        
        //TODO
        //Using intemediate NSURL in order
        //URL(string:) does not work with this url format
        let retURL = NSURL(string: urlString)
        
        return retURL?.absoluteURL
    }
    
    private var defaultError: Error {
        return NSError(domain: Self.LastFMHandlerErrorDomain,
                       code: -1,
                       userInfo: nil)
    }
}

private func main(block: @escaping () -> ()) {
    
    DispatchQueue.main.async {
        block()
    }
}
