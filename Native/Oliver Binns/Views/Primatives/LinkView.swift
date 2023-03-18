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
                if let imageURL {
                    AsyncImage(url: imageURL,
                               content: { $0.resizable() },
                               placeholder: { Color.accentColor })
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100)
                        .cornerRadius(7)
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
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(12)
        }.buttonStyle(.plain)
    }
}

struct LinkView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
