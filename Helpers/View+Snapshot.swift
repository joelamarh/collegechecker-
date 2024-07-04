//
//  View+Snapshot.swift
//  DNALogo
//
//  Created by Erwin Zwart on 21/10/2022.
//

import SwiftUI

extension View {
    #if os(macOS)
    public func snapshot(targetSize: CGSize) -> ImageType? {
        let controller = NSHostingController(rootView: self)
        let contentRect = NSRect(origin: .zero, size: targetSize)

        let window = NSWindow(contentRect: contentRect,
                              styleMask: [.borderless],
                              backing: .buffered,
                              defer: false)
        window.contentView = controller.view

        guard
            let bitmapRep = controller.view.bitmapImageRepForCachingDisplay(in: contentRect)
        else { return nil }

        controller.view.cacheDisplay(in: contentRect, to: bitmapRep)
        let image = NSImage(size: bitmapRep.size)
        image.addRepresentation(bitmapRep)

        return image
    }
    #else
    public func snapshot(targetSize: CGSize) -> ImageType? {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        let result = renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
        return result
    }
    #endif
}

#if os(macOS)
extension NSImage {
    var pngData: Data? {
        guard let tiffRepresentation = tiffRepresentation,
              let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else { return nil }
        return bitmapImage.representation(using: .png, properties: [:])
    }

    func pngWrite(to url: URL, options: Data.WritingOptions = .atomic) -> Bool {
        do {
            try pngData?.write(to: url, options: options)
            return true
        } catch {
            print(error)
            return false
        }
    }
}
#endif
