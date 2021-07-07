//
//  RequestHandler.swift
//  OpenWeatherApp
//
//  Created by Faizal on 07/07/2021.
//  Copyright © 2018 Faizal. All rights reserved.
//



import Foundation

class ResponseHandler {
    
    func networkResponse<T:Parceable>(completion : @escaping ((Result<[T], ErrorResult>)->Void))->((Result<Data, ErrorResult>)->Void){
        
        return {   response in
            DispatchQueue.global(qos: .background).async {
                switch response {
                case .success(let data) :
                    ParserHelper.parse(data: data, completion: completion)
                    break
                case .failure(let error) :
//                    print("Network error \(error)")
                    completion(.failure(.network(string: "Network error " + error.localizedDescription)))
                    break
                }
                
            }
            
        }
        
    }
    
    func networkResponse<T:Parceable>(completion : @escaping ((Result<T, ErrorResult>)->Void))->((Result<Data, ErrorResult>)->Void){
        
        return {   response in
            DispatchQueue.global(qos: .background).async {
                switch response {
                case .success(let data) :
                    ParserHelper.parse(data: data, completion: completion)
                    break
                case .failure(let error) :
//                    print("Network error \(error)")
                    completion(.failure(.network(string: "Network error " + error.localizedDescription)))
                    break
                }
                
            }
            
        }
        
    }
}
