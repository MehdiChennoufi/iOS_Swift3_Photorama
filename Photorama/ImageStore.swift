//
//  ImageStore.swift
//  Photorama
//
//  Created by Mehdi Chennoufi on 10/02/2017.
//  Copyright © 2017 Mehdi Chennoufi. All rights reserved.
//

import UIKit

class ImageStore {

    // Utilisation du cache sous forme de tableau associatif
    let cache = NSCache<NSString,UIImage>()
    
    // ------------------
    
    // Insertion d'une image dans le tableau
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
        
        // Création de l'URL de l'image
        let url = imageURL(forKey: key)
        
        // Transformation de l'image en data JPEG
        if let data = UIImageJPEGRepresentation(image, 0.5) {
            // Si succès je l'affecte à URL
            let _ = try? data.write(to: url, options: [.atomic])
        }
    }
    
    // ------------------
    
    // Affichage/Selection d'une image dans le tableau
    func image(forKey key: String) -> UIImage? {
        if let existingImage = cache.object(forKey: key as NSString) {
            return existingImage
    }
        
    let url = imageURL(forKey: key)
        guard let imageFromDisk = UIImage(contentsOfFile: url.path) else {
            return nil
        }
        
        cache.setObject(imageFromDisk, forKey: key as NSString)
        return imageFromDisk
    }
    
    // ------------------
    
    // Suppression d'une image du tableau
    func deleteImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
        
        let url = imageURL(forKey: key)
        do {
            try FileManager.default.removeItem(at: url)
        } catch let deleteError {
            print("Error removing the image from disk: \(deleteError)")
        }
    }
    
    // ------------------
    
    func imageURL(forKey key: String) -> URL {
        
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        
        return documentDirectory.appendingPathComponent(key)
    }
}
