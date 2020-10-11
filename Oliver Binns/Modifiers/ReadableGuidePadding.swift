//
//  ReadableGuidePadding.swift
//  Oliver Binns
//
//  Created by Laptop 3 on 11/10/2020.
import SwiftUI

private struct ReadableGuidePadding: ViewModifier {
    @Environment(\.horizontalSizeClass) var horizontal

    func body(content: Content) -> some View {
        HStack {
            Spacer()
            content
                .frame(maxWidth: 672)
                .padding()
            Spacer()
        }
    }
}

extension View {
    func readableGuidePadding() -> some View {
        modifier(ReadableGuidePadding())
    }
}
