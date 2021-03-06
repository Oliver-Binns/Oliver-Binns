//
//  LinkView.swift
//  Oliver Binns
//
//  Created by Oliver Binns on 10/10/2020.
//
import Foundation
import SwiftUI

struct LinkView: View {
    var imageURL: URL?
    var title: String
    var bodyText: String
    var url: URL

    var body: some View {
        SafariButton(url: url) {
            HStack(alignment: .top, spacing: 16) {
                if imageURL != nil {
                    AsyncImage(
                        url: imageURL!,
                        placeholder: { Image(systemName: "doc").resizable() },
                        image: { Image(uiImage: $0).resizable() }
                    )
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.headline)
                    Text(bodyText)
                        .font(.caption)
                }
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .border(Color.primary)
        }
    }
}

struct LinkView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
