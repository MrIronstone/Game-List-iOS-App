//
//  NetworkEngine.swift
//  GameListAppWithUIKit
//
//  Created by Hüsamettin Demirtaş on 1.07.2022.
//

import Foundation


class NetworkEngine {
    /// Executes the web call and will decode the JSON response into the Codable object provided
    /// - Parameters:
    /// - endpoint: the endpoint to make HTTP request against
    /// - completion: the JSON response converted to provided Codable object, if successful, or failure otherwise
    //1
    
    class func request<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> ()) {
        //2
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.baseURL
        components.path = endpoint.path
        components.queryItems = endpoint.parameters
        
        //3
        guard let url = components.url else { return }
        
        print("URL is (\(url)")

        
        //4
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method
                
        //5
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            
            //6 
            guard error == nil else {
                completion(.failure(error!))
                print(error?.localizedDescription ?? "Unknown Error")
                return
            }
            
            guard response != nil, let data = data else { return }
            
            // run in main thread
            DispatchQueue.main.async {
                if let responseObject = try? JSONDecoder().decode(T.self, from: data) {
                    //7
                    completion(.success(responseObject))
                }
                else {
                    let error = NSError(domain: "", code: 200, userInfo: [NSLocalizedDescriptionKey: "Failed to decode response"])
                    completion(.failure(error))
                }
            }
            
        })
        dataTask.resume()
    }
    
    // sadece url ile
    class func requestByUrl<T: Codable>(url:String, completion: @escaping (Result<T, Error>) -> ()) {
        //3
        guard let url = URL(string: url) else { return }
        
        // print("URL is (\(url)")

        
        //4
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
                
        //5
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            
            //6
            guard error == nil else {
                completion(.failure(error!))
                print(error?.localizedDescription ?? "Unknown Error")
                return
            }
            
            guard response != nil, let data = data else { return }
            
            // run in main thread
            DispatchQueue.main.async {
                if let responseObject = try? JSONDecoder().decode(T.self, from: data) {
                    //7
                    completion(.success(responseObject))
                }
                else {
                    let error = NSError(domain: "", code: 200, userInfo: [NSLocalizedDescriptionKey: "Failed to decode response"])
                    completion(.failure(error))
                }
            }
            
        })
        dataTask.resume()
    }
}
