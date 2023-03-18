//
//  Figure.swift
//  Oliver Binns
//
//  Created by Oliver Binns on 11/10/2020.
//
import SwiftUI

struct Figure: View {
    var caption: String?
    var url: URL?

    var body: some View {
        VStack {
            if let url = url {
                AsyncImage(url: url)
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
