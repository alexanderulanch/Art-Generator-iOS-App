//
//  ViewModel.swift
//  DALL-E 2 Art Generator App
//
//  Created by Alex Ulanch on 8/22/23.
//

import SwiftUI

@MainActor
class ViewModel: ObservableObject {
    @Published var prompt = ""
    @Published var urls: [URL] = []
    @Published var dalleImages: [DalleImage] = []
    @Published var fetching = false
    @Published var selectedImage: UIImage?
    @Published var imageStyle = ImageStyle.none
    @Published var imageMedium = ImageMedium.none
    @Published var artist = Artist.none
    
    var desciption: String {
        let characteristics = imageStyle.description + imageMedium.description + artist.description
        return prompt + (!characteristics.isEmpty ? "\n- " + characteristics : "")
    }
    
    let apiService = APIService()
    
    func clearProperties() {
        urls = []
        dalleImages.removeAll()
        for _ in 1...Constants.n {
            dalleImages.append(DalleImage())
        }
        selectedImage = nil
    }
    
    func reset() {
        clearProperties()
        imageStyle = .none
        imageMedium = .none
        artist = .none
    }
    
    init() {
        clearProperties()
    }
    
    func fetchImages() {
        clearProperties()
        withAnimation {
            fetching.toggle()
        }
        let generationInput = GenerationInput(prompt: desciption)
        Task {
            if let data = generationInput.encodedData {
                do {
                    let response = try await apiService.fetchImages(with: data)
                    for data in response.data {
                        urls.append(data.url)
                    }
                    withAnimation {
                        fetching.toggle()
                    }
                    for (index, url) in urls.enumerated() {
                        dalleImages[index].uiImage = await apiService.loadImage(at: url)
                    }
                } catch {
                    print(error.localizedDescription)
                    fetching.toggle()
                }
            }
        }
    }
    
    func fetchVariations() {
        if let selectedImage {
            fetching.toggle()
            guard let imageData = selectedImage.pngData() else {
                return
            }
            clearProperties()
            Task {
                do {
                    let formDataFields: [String: Any] = ["n": Constants.n, "size" : Constants.imageSize]
                    let response = try await apiService.getVariations(formDataField: formDataFields, fieldName: "image", fileName: "myImage.png", fileData: imageData)
                    
                    for data in response.data {
                        urls.append(data.url)
                    }
                    withAnimation {
                        fetching.toggle()
                    }
                    for (index, url) in urls.enumerated() {
                        dalleImages[index].uiImage = await apiService.loadImage(at: url)
                    }
                } catch {
                    print(error.localizedDescription)
                    fetching.toggle()
                }
            }
        }
    }
}
