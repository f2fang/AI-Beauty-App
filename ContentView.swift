//
//  ContentView.swift
//  BeautyAI
//
//  Created by Fang Fang on 6/11/26.
//
import SwiftUI
import PhotosUI

struct ContentView: View {
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    @State private var selectedUIImage: UIImage?
    @State private var result = ""
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                Text("Beauty AI")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                if let selectedImage {
                    selectedImage
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .cornerRadius(16)
                } else {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 300)
                        .overlay(
                            Text("Upload Photo")
                                .foregroundColor(.gray)
                        )
                }
                
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images
                ) {
                    Text("Select Photo")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                
                Button {
                    Task {
                        isLoading = true
                        result = "Analyzing..."
                        
                        let skinService = LocalSkinService()
                        result = await skinService.analyze(image: selectedUIImage)
                        
                        isLoading = false
                    }
                } label: {
                    if isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Analyze Skin")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.pink)
                .foregroundColor(.white)
                .cornerRadius(12)
                
                ScrollView {
                    Text(result)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.pink.opacity(0.08))
                        .cornerRadius(12)
                }
                .frame(height: 220)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Beauty AI")
        }
        .onChange(of: selectedItem) { oldValue, newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    selectedUIImage = uiImage
                    selectedImage = Image(uiImage: uiImage)
                    result = ""
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
