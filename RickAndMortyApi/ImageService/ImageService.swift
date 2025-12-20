//
//  ImageService.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 29/08/2025.
//

import UIKit

class ImageService {
    static let shared = ImageService()
    private let fileManager = FileManager.default
    private let nsCache = NSCache<NSString, UIImage>()
    
    // Directory where the system can clear files if disk space is low
    private var cacheDirectory: URL {
        let paths = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        let folderURL = paths[0].appending(path: "ImageCache", directoryHint: .isDirectory)
        return folderURL
    }
    
    // The system never deletes files from here automatically.
    // Files are removed only when the user removes them from Favorites.
    private var permanentDirectory: URL {
        let paths = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        let folderURL = paths[0].appending(path: "FavoriteImages", directoryHint: .isDirectory)
        return folderURL
    }
    
    // MARK: - init
    private init() {
        nsCache.countLimit = 150
        print("Cache Directory Path: \(cacheDirectory.path())")
        print("Favorites Directory Path: \(permanentDirectory.path())")
        
        do {
            if !fileManager.fileExists(atPath: cacheDirectory.path()) {
                try fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
                print("✅ ImageCache folder created")
            }
            if !fileManager.fileExists(atPath: permanentDirectory.path()) {
                try fileManager.createDirectory(at: permanentDirectory, withIntermediateDirectories: true)
                print("✅ FavoriteImages folder created")
            }
        } catch {
            print("❌ Error creating folders: \(error.localizedDescription)")
        }
    }
    
    // MARK: - fetch
    func fetch(_ urlString: String) async -> UIImage? {
        let filename = getFileName(for: urlString)
        let key = filename as NSString
        // 1. check NSCache
        if let memoryImage = nsCache.object(forKey: key) {
            print("taken from NSCache")
            return memoryImage
        }
        // 2. check permanent directory (Favorites)
        let permanentFileURL = permanentDirectory.appending(path: filename, directoryHint: .notDirectory)
        if let image = loadFromDisk(at: permanentFileURL) {
            print("taken from permanentDirectory")
            nsCache.setObject(image, forKey: key)
            return image
        }
        // 3. check temporary cache directory
        let cacheFileURL = cacheDirectory.appending(path: filename, directoryHint: .notDirectory)
        if let image = loadFromDisk(at: cacheFileURL) {
            // check if the file older than 30 days
            if isExpired(fileURL: cacheFileURL) {
                print("File is expired, removing from disk")
                do {
                    try fileManager.removeItem(at: cacheFileURL)
                    print("✅ old file deleted")
                } catch {
                    print("❌ failed to delete old file: \(error.localizedDescription)")
                }
            } else {
                print("taken from cacheDirectory")
                nsCache.setObject(image, forKey: key)
                return image
            }
        }
        
        // 4. downloading from internet
        print("downloading from internet")
        guard let url = URL(string: urlString) else {
            print("❌ invalid URL")
            return nil
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else {
                print("❌ failed to create image from data")
                return nil
            }
            print("✅ downloaded successfully")
            // Сохраняем в NSCache
            nsCache.setObject(image, forKey: key)
            // Сохраняем на диск в кэш
            do {
                try data.write(to: cacheFileURL)
                print("✅  saved to cacheDirectory")
            } catch {
                print("❌ failed to save to cacheDirectory: \(error.localizedDescription)")
            }
            return image
        } catch {
            print("❌ error during downloading: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: - toggleFavorite
    @discardableResult
    func toggleFavorite(url: String) -> Bool {
        let filename = getFileName(for: url)
        let cacheFileURL = cacheDirectory.appending(path: filename, directoryHint: .notDirectory)
        let permanentFileURL = permanentDirectory.appending(path: filename, directoryHint: .notDirectory)
        
        do {
            // 1. check if file exists in permanentDirectory
            if fileManager.fileExists(atPath: permanentFileURL.path) {
                // if yes, then delete it
                try fileManager.removeItem(at: permanentFileURL)
                print("✅ Deleted from permanentDirectory: \(filename)")
                return false
            }
            // 2.  If not, check if it exists in cacheDirectory and copy it to permanentFileURL
            if fileManager.fileExists(atPath: cacheFileURL.path) {
                try fileManager.copyItem(at: cacheFileURL, to: permanentFileURL)
                print("✅ added to permanentFileURL: \(filename)")
                return true
            }
        } catch {
            print("❌ error: \(error.localizedDescription)")
            return false
        }
        return false
    }
    
    
    
    // MARK: - helpers
    func getFileName(for url: String) -> String {
        guard let data = url.data(using: .utf8) else { return "temp" }
        return data.base64EncodedString().replacingOccurrences(of: "/", with: "_")
    }
    
    private func loadFromDisk(at url: URL) -> UIImage? {
        // If this returns nil, the logic will proceed to download from the internet
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }
    
    private func isExpired(fileURL: URL) -> Bool {
        print("checking if file is old")
        do {
            let attributes = try fileManager.attributesOfItem(atPath: fileURL.path())
            if let creationDate = attributes[.creationDate] as? Date {
                // check if more than 30 days
                let isOld = Date().timeIntervalSince(creationDate) > (30 * 24 * 60 * 60)
                if isOld {
                    print("file creation date is old: \(creationDate)")
                }
                return isOld
            }
        } catch {
            print("❌ coudn't read file creation date, considering it as new")
            return false
        }
        return true
    }
    
    // MARK: - Favorite tab
    func getSavedFiles() -> [URL] {
        do {
            return try fileManager.contentsOfDirectory(at: permanentDirectory, includingPropertiesForKeys: nil)
        } catch {
            print("❌ error fetching files from permanentDirectory: \(error)")
            return []
        }
    }
    
    func isSaved(url: String) -> Bool {
        let filename = getFileName(for: url)
        let fileURL = permanentDirectory.appending(path: filename, directoryHint: .notDirectory)
        return fileManager.fileExists(atPath: fileURL.path)
    }
    
}

