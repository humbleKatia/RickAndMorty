//
//  ImageService.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 29/08/2025.
//

import SwiftUI

class ImageService {
    static let shared = ImageService()
    private let fileManager = ImageFileManager.shared
    private let folderName = "character_images"
    
    private init() { }
  
    func fetch(_ urlString: String) async -> UIImage? {
        // 1 Generate a unique key for the image based on the URL
        guard let imageName = getImageName(from: urlString) else {
            return nil
        }
        // 2 Check the File Manager (Cache) first
        if let cachedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
             print("Fetched from Cache: \(imageName)")
            return cachedImage
        }
        // 3 If not in cache, download from network
        return await downloadImage(urlString: urlString, imageName: imageName)
    }
    
    private func downloadImage(urlString: String, imageName: String) async -> UIImage? {
        guard let url = URL(string: urlString) else { return nil }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                return nil
            }
            guard let image = UIImage(data: data) else { return nil }
            fileManager.saveImage(image: image, imageName: imageName, folderName: folderName)
            return image
        } catch {
            print("Error downloading image: \(error)")
            return nil
        }
    }
    
    /// Helper to extract a filename from the URL (e.g., "https://.../avatar/1.jpeg" -> "1.jpeg")
    private func getImageName(from urlString: String) -> String? {
        guard let url = URL(string: urlString) else { return nil }
        return url.lastPathComponent
    }
}




