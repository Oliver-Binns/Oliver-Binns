//
//  Figure.swift
//  Oliver Binns
//
//  Created by Laptop 3 on 11/10/2020.
//
import SwiftUI

struct Figure: View {
    var caption: String?
    var url: URL?

    var body: some View {
        VStack {
            if url != nil {
                AsyncImage(
                    url: url!,
                    placeholder: {
                        VStack {
                            ActivityIndicator(isAnimating: .constant(true),
                                              style: .large)
                        }
                    },
                    image: { Image(uiImage: $0).resizable() }
                )
                .aspectRatio(contentMode: .fit)
            }
            if caption != nil {
                Text(caption!)
                    .multilineTextAlignment(.center)
                    .font(.caption)
                    .foregroundColor(Color(UIColor.secondaryLabel))
            }
        }.frame(maxWidth: .infinity)
    }
}

struct Figure_Previews: PreviewProvider {
    static var previews: some View {
        Figure(caption: "", url: URL(string: "https://www.google.com"))
    }
}
