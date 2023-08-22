//
//  ContentView.swift
//  DALL-E 2 Art Generator App
//
//  Created by Alex Ulanch on 8/21/23.
//

import SwiftUI

struct DALLEImagesView: View {
    @StateObject var vm =  ViewModel()
    var body: some View {
        NavigationStack {
            VStack {
                if !vm.urls.isEmpty {
                    HStack {
                        ForEach(vm.dalleImages) { dalleImage in
                            if let uiImage = dalleImage.uiImage {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                            } else {
                                ProgressView()
                                    .frame(width: 80, height: 80)
                            }
                        }
                    }
                }
                if !vm.fetching {
                    if vm.urls.isEmpty {
                        Text("Be as desciptive as you can with your prompt")
                        TextField("Image Description", text: $vm.prompt, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal)
                        Button("Fetch") {
                            vm.fetchImages()
                        }
                        .disabled(vm.prompt.isEmpty)
                        .buttonStyle(.borderedProminent)
                    } else {
                        Button("Try another") {
                            vm.clearProperties()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    ProgressView()
                }
                Spacer()
            }
            .navigationTitle("Art Generator")
        }
        .padding()
    }
}

#Preview {
    DALLEImagesView()
}
