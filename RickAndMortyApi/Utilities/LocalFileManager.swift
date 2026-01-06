//
//  LocalFileManager.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 24/12/2025.
//

import SwiftUI

class LocalFileManager {
    static let shared = LocalFileManager()
    private init() { }
    
    //choose where to save (Caches is temporary, Documents is permanent)
    enum SearchPathDirectory {
        case caches
        case documents
    }
    
    func save(data: Data, filename: String, folderName: String, directory: SearchPathDirectory = .caches) throws {
        let folderURL = try createFolderIfNeeded(folderName: folderName, directory: directory)
        let fileURL = folderURL.appendingPathComponent(filename)
        try data.write(to: fileURL)
    }
    
    func getData(filename: String, folderName: String, directory: SearchPathDirectory = .caches) -> Data? {
        guard let url = getURLForFile(filename: filename, folderName: folderName, directory: directory),
              FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        return try? Data(contentsOf: url)
    }
  
    func getURLForFile(filename: String, folderName: String, directory: SearchPathDirectory = .caches) -> URL? {
        guard let folderURL = getURLForFolder(folderName: folderName, directory: directory) else {
            return nil
        }
        return folderURL.appendingPathComponent(filename)
    }
   
    func delete(filename: String, folderName: String, directory: SearchPathDirectory = .caches) {
        guard let url = getURLForFile(filename: filename, folderName: folderName, directory: directory),
              FileManager.default.fileExists(atPath: url.path) else { return }
        
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Error deleting file: \(filename). \(error)")
        }
    }
  
    private func createFolderIfNeeded(folderName: String, directory: SearchPathDirectory) throws -> URL {
        guard let folderURL = getURLForFolder(folderName: folderName, directory: directory) else {
            throw NSError(domain: "FileManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid Path"])
        }
        
        if !FileManager.default.fileExists(atPath: folderURL.path) {
            try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
        }
        return folderURL
    }
    
    private func getURLForFolder(folderName: String, directory: SearchPathDirectory) -> URL? {
        let path: FileManager.SearchPathDirectory = (directory == .caches) ? .cachesDirectory : .documentDirectory
        
        guard let url = FileManager.default.urls(for: path, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(folderName)
    }
}



extension LocalFileManager {
    func saveImage(image: UIImage, imageName: String, folderName: String) {
        guard let data = image.jpegData(compressionQuality: 1.0) else { return }
        do {
            try save(data: data, filename: imageName, folderName: folderName)
            
            let size = ByteCountFormatter.string(fromByteCount: Int64(data.count), countStyle: .file)
                       print("✅ saving image: \(imageName) | Size: \(size)")
            if let path = getURLForFile(filename: imageName, folderName: folderName, directory: .documents)?.path {
                 print("✅ saving image data to location: \(path)")
             }
        } catch {
            print("Error saving image: \(error)")
        }
    }
    
    func getImage(imageName: String, folderName: String, directory: SearchPathDirectory = .caches) -> UIImage? {
        guard let data = getData(filename: imageName, folderName: folderName , directory: directory) else { return nil }
        let size = ByteCountFormatter.string(fromByteCount: Int64(data.count), countStyle: .file)
        print("✅ LOADED: \(imageName) | Size: \(size)")
        return UIImage(data: data)
    }
    
    
     //Copy file from Caches  to Documents
     func moveFileToDocuments(filename: String, folderName: String) {
         guard let cacheURL = getURLForFile(filename: filename, folderName: folderName, directory: .caches),
               let docURL = getURLForFile(filename: filename, folderName: folderName, directory: .documents) else { return }
         
         //Check if source exists in Cache
         guard FileManager.default.fileExists(atPath: cacheURL.path) else { return }
         
         //Create the destination folder in Documents if needed
         // (We reuse the logic you already have, or simpler: just ensure directory exists)
         try? createFolderIfNeeded(folderName: folderName, directory: .documents)
         
         //Copy (or overwrite if exists)
         do {
             if FileManager.default.fileExists(atPath: docURL.path) {
                 try FileManager.default.removeItem(at: docURL)
             }
             try FileManager.default.copyItem(at: cacheURL, to: docURL)
             print("✅ Promoted \(filename) to Documents")
         } catch {
             print("❌ Error moving file to documents: \(error)")
         }
     }
}
