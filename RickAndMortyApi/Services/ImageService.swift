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
        guard let imageName = getImageName(from: urlString) else {
            return nil
        }
        if let cachedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            return cachedImage
        }
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
    
    private func getImageName(from urlString: String) -> String? {
        guard let url = URL(string: urlString) else { return nil }
        return url.lastPathComponent
    }
}




