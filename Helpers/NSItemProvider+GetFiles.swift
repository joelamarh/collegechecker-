//
//  NSItemProvider+GetFiles.swift
//  DNALogoCreator
//
//  Created by Erwin Zwart on 25/10/2022.
//

#if os(macOS)
import Foundation

extension NSItemProvider {
    public func getImage(completion: @escaping (ImageType?) -> Void) {
        guard let identifier = registeredTypeIdentifiers.first,
              identifier == "public.url" || identifier == "public.file-url" else {
            completion(nil)
            return
        }
        loadItem(forTypeIdentifier: identifier, options: nil) { urlData, _ in
            guard let urlData = urlData as? Data else { return }
            let url = NSURL(absoluteURLWithDataRepresentation: urlData, relativeTo: nil) as URL

            guard let image = ImageType(contentsOf: url) else {
                completion(nil)
                return
            }
            completion(image)
        }
    }
}
#endif
