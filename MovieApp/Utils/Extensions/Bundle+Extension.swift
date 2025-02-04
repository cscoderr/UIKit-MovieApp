//
//  Bundle+Extension.swift
//  MovieApp
//
//  Created by Tomiwa Idowu on 1/31/25.
//

import Foundation

extension Bundle {
    func decode<T: Decodable>(_ fileName: String) -> T {
        guard let url = self.url(forResource: fileName, withExtension: "json") else {
            fatalError("Unable to get \(fileName)")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Unable to get data from \(url)")
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let result = try decoder.decode(T.self, from: data)
            return result
        } catch {
            fatalError("Unable to decode data \(error)")
        }
      
    }
}
