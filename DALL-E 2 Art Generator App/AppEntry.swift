//
//  DALL_E_2_Art_Generator_AppApp.swift
//  DALL-E 2 Art Generator App
//
//  Created by Alex Ulanch on 8/21/23.
//

import SwiftUI

@main
struct AppEntry: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear() {
                    Task {
                        let sample = GenerationInput(prompt: "Man in in a rowboat in a storm similar to work by van Gogh")
                        if let data = sample.encodedData {
                            try await APIService().fetchImages(with: data)
                        }
                    }
                }
        }
    }
}
