//
//  HTMLText.swift
//  Oliver Binns
//
//  Created by Laptop 3 on 12/09/2020.
//
import SwiftUI
import UIKit

struct AttributedText: View {
    @State var attributedText: NSAttributedString?
    @State private var desiredHeight: CGFloat = 0

    var body: some View {
        HTMLText(attributedString: $attributedText, desiredHeight: $desiredHeight)
            .frame(height: desiredHeight)
    }

}

struct HTMLText: UIViewRepresentable {
    @Binding var attributedString: NSAttributedString?
    @Binding var desiredHeight: CGFloat

    func makeUIView(context: UIViewRepresentableContext<Self>) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }

    func updateUIView(_ uiView: UILabel, context: UIViewRepresentableContext<Self>) {
        guard let attributedString = attributedString else { return }
        uiView.attributedText = NSMutableAttributedString(attributedString: attributedString)
            .setBaseFont(baseFont: .serifBody)
            .addingAttributes([.foregroundColor: UIColor.label])
            .untilPhrase("…")
            .trimTrailingWhiteSpace()

        DispatchQueue.main.async {
            let size = uiView.systemLayoutSizeFitting(.init(width: uiView.frame.width,
                                                    height: UIView.layoutFittingCompressedSize.height),
                                           withHorizontalFittingPriority: .required,
                                           verticalFittingPriority: .fittingSizeLevel)
            guard size.height != self.desiredHeight else { return }
            self.desiredHeight = size.height
        }
    }
}
