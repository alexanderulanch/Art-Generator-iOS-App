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
    
    func getVariations(formDataField: [String : Any],
                       fieldName: String,
                       fileName: String,
                       fileData: Data) async throws -> ResponseModel {
        guard let apiKey else { fatalError("Could not get APIKey") }
        guard let url = URL(string: baseURL + "variations") else { fatalError("Error: Invalid URL") }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let httpBody = NSMutableData()
        
        func convertFormField(name: String,
                              value: Any,
                              boundary: String) -> String {
            var fieldString = "--\(boundary)\r\n"
            fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n"
            fieldString += "\(value)\r\n"
            return fieldString
        }
        
        func convertFileData(fieldName: String,
                             fileName:String,
                             mimeType: String,
                             fileData: Data,
                             boundary: String) -> Data {
            let data = NSMutableData()
            data.appendString("--\(boundary)\r\n")
            data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
            data.appendString("Content-Type: \(mimeType)\r\n\r\n")
            data.append(fileData)
            data.appendString("\r\n")
            return data as Data
        }
        
        for (key, value) in formDataField {
            let formString = convertFormField(name: key,
                                              value: value,
                                              boundary: boundary)
            httpBody.appendString(formString)
        }
        
        let imageData = convertFileData(fieldName: fieldName, fileName: fileName, mimeType: "image/png", fileData: fileData, boundary: boundary)
        
        httpBody.append(imageData)
        httpBody.appendString("--\(boundary)--")
        request.httpBody = httpBody as Data
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse) != nil else { fatalError("Error: Data request error.") }
        do {
            return try JSONDecoder().decode(ResponseModel.self, from: data)
        } catch {
            throw error
        }
    }
}

extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
