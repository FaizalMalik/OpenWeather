//
//  RequestService.swift
//  OpenWeatherApp
//
//  Created by Faizal on 07/07/2021.
//  Copyright © 2018 Faizal. All rights reserved.
//


import Foundation


// Protocol for MOCK/Real
protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionTaskProtocol
}

protocol URLSessionTaskProtocol {
    func resumeTask()
}



final class RequestService {
        
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    
    func requestDataFromServer(urlstring : String, params:[String:String] = [:], completion : @escaping (Result<Data, ErrorResult>)->Void)->URLSessionTask?{
        
        guard var url = URL(string: urlstring) else {
            completion(.failure(.network(string: "invalid url")))
            return nil
        }
        if !params.isEmpty, let processedURL = processUrl(params: params, url: url) {
            url = processedURL
        }
        var request = RequestFactory.request(method: .GET, url: url)
        
        if let reachability = Reachability(), !reachability.isReachable{
            request.cachePolicy = .returnCacheDataDontLoad
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error{
                completion(Result.failure(ErrorResult.network(string: "error occured while requesting : \(error)")))
                return
            }
            
            if let data = data{
                completion(Result.success(data))
            }
        }
        task.resumeTask()
        return task as? URLSessionTask
    }
    func processUrl(params: [String:String], url:URL) -> URL? {
        if let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        {
            var components = urlComponents
            components.queryItems = params.map { arg -> URLQueryItem in
                let (key, value) = arg
                return URLQueryItem(name: key, value: value)
            }
            components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
            return components.url
        }
        return nil
    }
}


//MARK: Conform the protocol
extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping URLSessionProtocol.DataTaskResult) -> URLSessionTaskProtocol
    {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionTask
    }
}

extension URLSessionTask: URLSessionTaskProtocol {
    func resumeTask (){
        self.resume()
    }
}

