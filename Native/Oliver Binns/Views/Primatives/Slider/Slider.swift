//
//  Slider.swift
//  Oliver Binns
//
//  Created by Oliver Binns on 12/10/2020.
//
import SwiftUI

struct Slider: View {
    let caption: String?
    let firstImage: URL
    let secondImage: URL

    @State var crop: CGFloat = 0.50

    var body: some View {
        VStack(alignment: .center) {
            ZStack {
                if let firstImage,
                    let secondImage {
                    AsyncImage(url: firstImage)
                        .aspectRatio(contentMode: .fit)
                        .clipped()
                        .overlay(
                            GeometryReader { geometry in
                                AsyncImage(url: secondImage)
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
