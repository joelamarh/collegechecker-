//
//  LogoGeneratorView.swift
//  DNADashboard
//
//  Created by Erwin Zwart on 30/03/2023.
//

import AVKit
import PhotosUI
import SwiftUI

#if os(macOS)
public typealias ImageType = NSImage
#else
public typealias ImageType = UIImage
#endif

struct LogoGeneratorView: View {

    /// Collection of configurable values for the project
    enum Config {
        /// The asset names of the available logo's to pick from
        static let logoNames = ["DNA_Logo_Black", "DNA_Logo_Full_Inc_Black", "DNA_Logo_Outlined_Black"]
        /// The size of the exported logo
        static let exportSize = CGSize(width: 3000, height: 1500)

        #if os(macOS)
        static let toolbarPlacement: ToolbarItemPlacement = .automatic
        #else
        static let toolbarPlacement: ToolbarItemPlacement = .bottomBar
        #endif
    }

    @State var maskContent: Image?
    @State var blur: CGFloat = 0.0

    @State private var selectedLogo: String?
    @State private var blurPopoverVisible: Bool = false
    @State private var logoPopoverVisible: Bool = false
    @State private var sharePopoverVisible: Bool = false

    #if !os(macOS)
    @State private var selectedPhoto: PhotosPickerItem?
    #endif

    private var maskContainer: some View {
        ZStack {
            if let maskContent = maskContent {
                GeometryReader { geometry in
                    maskContent
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .blur(radius: blur)
                        .mask {
                            Image(selectedLogo ?? "")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                }
            }
            else {
                emptyMaskView
            }
        }
        #if os(macOS)
        .padding(100)
        #else
        .onChange(of: selectedPhoto) { newValue in
            Task {
                if let imageData = try? await newValue?.loadTransferable(type: Data.self),
                   let image = UIImage(data: imageData) {
                    #if os(macOS)
                    let result = Image(nsImage: image)
                    #else
                    let result = Image(uiImage: image)
                    #endif
                    maskContent = result
                }
            }
        }
        .padding(25)
        #endif
    }

    private var emptyMaskView: some View {
        #if os(macOS)
        ZStack {
            Image(selectedLogo ?? "")
                .resizable()
                .renderingMode(.template)
                .colorMultiply(Color("LogoSelectorTint"))
                .aspectRatio(contentMode: .fit)
                .opacity(0.01)
            Text("Drop an image here")
        }
        #else
        PhotosPicker(selection: $selectedPhoto) {
            Label("Select a photo", systemImage: "photo.artframe")
        }
        #endif
    }

    private var logoPanel: some View {
        List(Config.logoNames, id: \.self, selection: $selectedLogo) { logoName in
            Image(logoName)
                .resizable()
                .renderingMode(.template)
                .colorMultiply(Color("LogoSelectorTint"))
                .aspectRatio(contentMode: .fit)
                .opacity(0.5)
                .padding(50)
        }
        .onChange(of: selectedLogo, perform: { _ in
            logoPopoverVisible = false
        })
        .frame(width: 300, alignment: .leading)
        .listStyle(.sidebar)
    }

    var body: some View {
        maskContainer
            .toolbar {
                ToolbarItemGroup(placement: Config.toolbarPlacement) {
                    #if !os(macOS)
                    PhotosPicker(selection: $selectedPhoto) {
                        Image(systemName: "photo.on.rectangle.angled")
                    }
                    #endif
                    Spacer()
                    Button(action: {
                        logoPopoverVisible.toggle()
                    }, label: {
                        Image(systemName: "square.grid.2x2")
                    })
                    .popover(isPresented: $logoPopoverVisible, arrowEdge: .bottom) {
                        logoPanel
                    }
                    Button(action: {
                        blurPopoverVisible.toggle()
                    }, label: {
                        Image(systemName: "circle.dashed.inset.fill")
                    })
                    .popover(isPresented: $blurPopoverVisible, arrowEdge: .bottom) {
                        VStack {
                            Text("Blur")
                                .font(.headline)
                                .padding(.bottom)
                            Slider(value: $blur, in: 0...60)
                                .frame(width: 150, alignment: .leading)
                        }
                        .padding(10)
                    }
                    Spacer()
                    Button(action: {
                        #if os(macOS)
                        export()
                        #else
                        sharePopoverVisible.toggle()
                        #endif
                    }, label: {
                        Image(systemName: "square.and.arrow.up")
                    })
                    #if !os(macOS)
                    .sheet(isPresented: $sharePopoverVisible) {
                        ShareSheet(activityItems: [maskContainer.snapshot(targetSize: Config.exportSize) ?? UIImage()])
                    }
                    #endif
                }
            }
            .onAppear {
                selectedLogo = Config.logoNames.first
            }
        #if os(macOS)
            .onDrop(of: ["public.url", "public.file-url"], isTargeted: nil, perform: { items in
                guard let item = items.first else { return false }
                item.getImage { image in
                    if let image = image {
                        maskContent = Image(nsImage: image)
                    }
                    else {
                        maskContent = nil
                    }
                }
                return true
            })
        #endif
    }

    #if os(macOS)
    private func export() {
        let image = maskContainer.snapshot(targetSize: Config.exportSize)
        let savePanel = NSSavePanel()
        savePanel.nameFieldStringValue = "DNA-logo.png"
        let response = savePanel.runModal()
        guard let url = savePanel.url else { return }
        switch response {
        case .OK:
            _ = image?.pngWrite(to: url)
        default:
            return
        }
    }
    #else
    private func export() {}
    #endif
}

struct LogoGeneratorView_Previews: PreviewProvider {
    static var previews: some View {
        LogoGeneratorView()
    }
}
