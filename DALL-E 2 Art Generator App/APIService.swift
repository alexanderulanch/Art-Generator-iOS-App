//
//  APIService.swift
//  DALL-E 2 Art Generator App
//
//  Created by Alex Ulanch on 8/21/23.
//

import UIKit

class APIService {
    let baseURL = "https://api.openai.com/v1/images/"
    let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String
    
    func fetchImages(with data: Data) async throws -> ResponseModel {
        guard let apiKey else { fatalError("Could not get APIKey") }
        guard let url = URL(string: baseURL + "generations") else { fatalError("Error: Invalid URL") }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse) != nil else { fatalError("Error: Data request error.") }
        do {
            return try JSONDecoder().decode(ResponseModel.self, from: data)
        } catch {
            throw error
        }
    }
    
    func loadImage(at url: URL) async -> UIImage? {
        let request = URLRequest(url: url)
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard (response as? HTTPURLResponse) != nil else { fatalError("Error: Data request error.") }
            return UIImage(data: data)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
