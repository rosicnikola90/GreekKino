//
//  NetworkService.swift
//  greek_kino
//
//  Created by Nikola Rosic on 2.8.24..
//

import Foundation


struct NetworkService {
    
    static let shared = NetworkService()
    
    private init() {}
    
    func get<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                let statusError = NSError(domain: "NetworkErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response from server, status code: \((response as? HTTPURLResponse)?.statusCode ?? 0)"])
                completion(.failure(statusError))
                return
            }
            
            guard let data = data else {
                let dataError = NSError(domain: "NetworkErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received from server"])
                completion(.failure(dataError))
                return
            }
            
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
