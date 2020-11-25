//
//  Slider.swift
//  Oliver Binns
//
//  Created by Oliver Binns on 12/10/2020.
//
import SwiftUI

struct Slider: View {
    let caption: String?
    @StateObject private var loader: ImageLoader
    @StateObject private var loader2: ImageLoader

    @State var crop: CGFloat = 0.50

    init(caption: String?, firstImage: URL, secondImage: URL) {
        self.caption = caption
        _loader = StateObject(wrappedValue: ImageLoader(url: firstImage, cache: Environment(\.imageCache).wrappedValue))
        _loader2 = StateObject(wrappedValue: ImageLoader(url: secondImage, cache: Environment(\.imageCache).wrappedValue))
    }

    var body: some View {
        VStack(alignment: .center) {
            ZStack {
                if loader.image != nil && loader2.image != nil {
                    Image(uiImage: loader2.image!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipped()
                        .overlay(
                            GeometryReader { geometry in
                                Image(uiImage: loader.image!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: geometry.size.width * crop,
                                           height: geometry.size.height,
                                           alignment: .leading)
                                    .scaledToFit()
                                    .clipped()
                            }
                        )
                        .overlay(
                            GeometryReader { geometry in
                                SliderPin()
                                    .offset(x: (geometry.size.width * crop) - 10, y: 0)
                                    .frame(width: 20, height: geometry.size.height)
                                    .gesture(
                                        DragGesture(minimumDistance: 10).onChanged { drag in
                                            crop = min(max(drag.location.x / geometry.size.width, 0), 1)
                                        }
                                    )
                            }
                        )
                }
            }
            if caption != nil {
                Text(caption!)
                    .foregroundColor(Color(UIColor.secondaryLabel))
                    .font(.caption)
            }
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            loader.load()
            loader2.load()
        }
    }
}

struct Slider_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
extension UIImage {
    var aspectRatio: CGFloat {
        size.height / size.width
    }
}
