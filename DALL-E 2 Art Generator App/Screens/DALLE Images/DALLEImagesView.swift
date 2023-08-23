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
                                    .onTapGesture {
                                        vm.selectedImage = uiImage
                                    }
                            } else {
                                ProgressView()
                                    .frame(width: 80, height: 80)
                            }
                        }
                    }
                }
                if !vm.fetching {
                    if !vm.urls.isEmpty {
                        Text("Select an Image")
                    }
                    if let selectedImage = vm.selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 256, height: 256)
                    }
                    if vm.urls.isEmpty {
                        Text("Be as desciptive as you can with your prompt")
                        TextField("Image Description", text: $vm.prompt, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal)
                        Form {
                            Picker("Style", selection: $vm.imageStyle) {
                                ForEach(ImageStyle.allCases, id: \.self) { imageStyle in
                                    Text(imageStyle.rawValue)
                                    
                                }
                            }
                            Picker("Image Medium", selection: $vm.imageMedium) {
                                ForEach(ImageMedium.allCases, id: \.self) { imageMedium in
                                    Text(imageMedium.rawValue)
                                    
                                }
                            }
                            Picker("Artist", selection: $vm.artist) {
                                ForEach(Artist.allCases, id: \.self) { artist in
                                    Text(artist.rawValue)
                                    
                                }
                            }
                            HStack {
                                Spacer()
                                Button("Generate") {
                                    vm.fetchImages()
                                }
                                .disabled(vm.prompt.isEmpty)
                                .buttonStyle(.borderedProminent)
                            }
                            HStack {
                                Spacer()
                                if vm.urls.isEmpty || vm.selectedImage == nil {
                                    Image("Artist")
                                }
                                Spacer()
                            }
                            
                        }
                    } else {
                        Text(vm.desciption)
                            .padding()
                        Button("Try another") {
                            vm.reset()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    ProgressView()
                }
                if vm.selectedImage == nil && !vm.urls.isEmpty {
                    Image("Artist")
                }
                Spacer()
            }
            .navigationTitle("Art Generator")
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

#Preview {
    DALLEImagesView()
}
