//
//  Models.swift
//  DALL-E 2 Art Generator App
//
//  Created by Alex Ulanch on 8/21/23.
//

import SwiftUI

enum Constants {
    static let imageSize = "256x256"
    static let n = 4
}

struct GenerationInput: Codable {
    var prompt: String
    var n = Constants.n
    var size = Constants.imageSize
    
    var encodedData: Data? {
        try? JSONEncoder().encode(self)
    }
}

struct DalleImage: Identifiable {
    var id = UUID()
    var uiImage: UIImage?
}

struct ResponseModel: Codable {
    struct Data: Codable {
        let url: URL
    }
    let created: Date
    let data: [Data]
}
