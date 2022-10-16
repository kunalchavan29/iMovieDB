//
//  ImageLoader.swift
//  iMovieTest
//
//  Created by A118830248 on 15/10/22.
//
//

import SwiftUI
import UIKit

class ImageLoader: ObservableObject {
    
    @Published var image: UIImage?
    @Published var isLoading = false
    
    var imageCache = NSCache<AnyObject, AnyObject>()

    func loadImage(with url: URL) {
        let urlString = url.absoluteString
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            do {
                if Reachability.isConnectedToNetwork() {
                    let data = try Data(contentsOf: url)
                    guard let image = UIImage(data: data) else {
                        return
                    }
                    self.imageCache.setObject(image, forKey: urlString as AnyObject)
                    _ = self.saveToDirectory(data: data, name: url.lastPathComponent)
                    DispatchQueue.main.async { [weak self] in
                        self?.image = image
                    }
                } else {
                    let image = self.loadFromDirectory(imageName: url.lastPathComponent)
                    DispatchQueue.main.async { [weak self] in
                        self?.image = image
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
        
}

extension ImageLoader {
    func saveToDirectory(data: Data, name: String) -> Bool {
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent(name)!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func loadFromDirectory(imageName: String) -> UIImage? {
        do {
            let dir = try FileManager.default.url(for: .documentDirectory,
                                                        in: .userDomainMask,
                                                        appropriateFor: nil,
                                                        create: false)
            let image = UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(imageName).path)
            return image
        } catch {
            print(error)
         return nil
        }
    }
}
