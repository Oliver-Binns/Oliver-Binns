//
//  Figure.swift
//  Oliver Binns
//
//  Created by Oliver Binns on 11/10/2020.
//
import SwiftUI

struct Figure: View {
    let caption: AttributedString?
    let altText: String
    let url: URL

    var body: some View {
        VStack {
            AsyncImage(url: url,
                       content: { $0.resizable() },
                       placeholder: { Color.accentColor })
                .accessibilityLabel(altText)
                .aspectRatio(contentMode: .fit)
            if let caption {
                Text(caption)
                    .multilineTextAlignment(.center)
                    .font(.caption)
                    .foregroundColor(Color(UIColor.secondaryLabel))
            }
        }.frame(maxWidth: .infinity)
    }
}

struct Figure_Previews: PreviewProvider {
    static var previews: some View {
        Figure(caption: "",
               altText: "Testing 123",
               url: URL(string: "https://www.google.com")!)
    }
}
