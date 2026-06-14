//
//  LocalSkinService.swift
//  BeautyAI
//
//  Created by Fang Fang on 6/11/26.
//
import Foundation
import UIKit

struct SkinAnalysisResult: Codable {
    
    let gender: String
    let skinScore: Double
    let aiSkinAge: Int
    
    let brightnessScore: Double
    let rednessScore: Double
    let textureScore: Double
    let pigmentationScore: Double
    
    let mainConcern: String
    
    enum CodingKeys: String, CodingKey {
        case gender
        
        case skinScore = "skin_score"
        case aiSkinAge = "ai_skin_age"
        
        case brightnessScore = "brightness_score"
        case rednessScore = "redness_score"
        case textureScore = "texture_score"
        case pigmentationScore = "pigmentation_score"
        
        case mainConcern = "main_concern"
    }
}

class LocalSkinService {
    
    func analyze(image: UIImage?) async -> String {
        
        guard let image = image,
              let imageData = image.jpegData(compressionQuality: 0.8) else {
            return "Please select a photo first."
        }
        
        guard let url = URL(string: "http://127.0.0.1:8000/analyze") else {
            return "Invalid URL"
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        
        request.setValue(
            "multipart/form-data; boundary=\(boundary)",
            forHTTPHeaderField: "Content-Type"
        )
        
        var body = Data()
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"photo.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        do {
            
            let (data, _) =
            try await URLSession.shared.data(for: request)
            
            let decoded =
            try JSONDecoder().decode(
                SkinAnalysisResult.self,
                from: data
            )
            
            let brightnessText =
            decoded.brightnessScore > 80 ? "Excellent" :
            decoded.brightnessScore > 70 ? "Good" :
            "Needs Improvement"
            
            let textureText =
            decoded.textureScore > 80 ? "Good" :
            "Needs Improvement"
            
            let rednessText =
            decoded.rednessScore > 80 ? "Excellent" :
            decoded.rednessScore > 70 ? "Good" :
            "Needs Improvement"
            
            let pigmentationText =
            decoded.pigmentationScore > 75 ? "Good" :
            "Needs Improvement"
            
            return """
            
            BeautyAI Skin Report
            
            Gender: \(decoded.gender)
            
            Skin Score: \(decoded.skinScore)/100
            AI Skin Age: \(decoded.aiSkinAge)
            
            Overall Assessment
            
            Your skin condition is above average.
            The primary concern is pigmentation and uneven skin tone.
            
            Main Concern
            
            \(decoded.mainConcern)
            
            Skin Details
            
            Brightness: \(brightnessText)
            Texture: \(textureText)
            Redness: \(rednessText)
            Pigmentation: \(pigmentationText)
            
            Recommended Routine
            
            Morning
            • Vitamin C Serum
            • SPF50 Sunscreen
            
            Night
            • Retinol
            • Moisturizer
            
            """
            
        } catch {
            
            return "Error: \(error.localizedDescription)"
        }
    }
}
