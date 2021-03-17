//
//  UIImage+Extension.swift
//  Hex
//
//  Created by Duong Pham on 3/17/21.
//

import SwiftUI

extension UIImage {
    convenience init?(fromDiskWithFileName fileName: String) {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory

        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            do {
                let data = try Data(contentsOf: imageUrl)
                self.init(data: data)
            } catch {
                print("-- Error: \(error)")
                return nil
            }
        } else {
            return nil
        }
    }
    
    func saveToDisk(fileName: String) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

            let fileName = fileName
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            guard let data = self.jpegData(compressionQuality: 1) else { return }

            //Checks if file exists, removes it if so.
            if FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    try FileManager.default.removeItem(atPath: fileURL.path)
                    print("Removed old image")
                } catch let removeError {
                    print("couldn't remove file at path", removeError)
                }

            }

            do {
                try data.write(to: fileURL)
            } catch let error {
                print("error saving file with error", error)
            }
    }
}
