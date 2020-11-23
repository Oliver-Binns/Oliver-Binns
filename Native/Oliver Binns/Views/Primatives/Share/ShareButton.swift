//
//  ShareButton.swift
//  Oliver Binns
//
//  Created by Laptop 3 on 28/10/2020.
//
import SwiftUI

struct ShareButton<Label: View>: View {
    let activityItems: [Any]
    let label: Label
    @State private var shouldDisplayLink: Bool = false

    init(activityItems: [Any], @ViewBuilder label: () -> Label) {
        self.activityItems = activityItems
        self.label = label()
    }

    var body: some View {
        Button {
            shouldDisplayLink = true
        } label: {
            label
        }
        .sheet(isPresented: $shouldDisplayLink) {
            ShareView(activityItems: activityItems)
        }
    }
}
