//
//  HTMLText.swift
//  Oliver Binns
//
//  Created by Oliver Binns on 12/09/2020.
//
import SwiftUI
import UIKit

struct AttributedText: View {
    @State var attributedText: NSAttributedString?
    @State private var desiredHeight: CGFloat = 0
    @State private var url: URL?

    var body: some View {
        HTMLText(attributedString: $attributedText,
                 desiredHeight: $desiredHeight,
                 linkPressed: {
            self.url = $0
        })
        .frame(height: desiredHeight)
        .sheet(isPresented: .init(get: { url != nil },
                                  set: { displayWebpage in
            if !displayWebpage { url = nil }
        })) {
            SafariView(url: url!)
        }
    }

}

fileprivate struct HTMLText: UIViewRepresentable {
    @Binding var attributedString: NSAttributedString?
    @Binding var desiredHeight: CGFloat
    var linkPressed: ((URL) -> Void)?

    func makeUIView(context: UIViewRepresentableContext<Self>) -> HTMLLabel {
        HTMLLabel()
    }

    func updateUIView(_ uiView: HTMLLabel, context: UIViewRepresentableContext<Self>) {
        guard let attributedString = attributedString else { return }
        uiView.linkPressed = linkPressed
        uiView.attributedText = NSMutableAttributedString(attributedString: attributedString)
            .setBaseFont(baseFont: .serifBody)
            .addingAttributes([.foregroundColor: UIColor.label])
            .untilPhrase("…")
            .trimTrailingWhiteSpace()
        uiView.tintColor = .accent
        uiView.isEditable = false

        DispatchQueue.main.async {
            let size = uiView.intrinsicContentSize
            guard size.height != self.desiredHeight else { return }
            self.desiredHeight = size.height
        }
    }
}
fileprivate final class HTMLLabel: UITextView {
    var linkPressed: ((URL) -> Void)?
    
    private var attributedTextCopy: NSAttributedString?

    convenience init() {
        self.init(frame: .zero)
        delegate = self
        textContainerInset = .zero
        textContainer.lineFragmentPadding = 0
        setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }

    override var intrinsicContentSize: CGSize {
        systemLayoutSizeFitting(.init(width: frame.width,
                                      height: UIView.layoutFittingCompressedSize.height),
                                withHorizontalFittingPriority: .required,
                                verticalFittingPriority: .fittingSizeLevel)
    }

    func characterTapped(at tapPoint: CGPoint) -> Int? {
        guard let attributedText = attributedText else { return nil }
        let layoutManager = NSLayoutManager()
        let textStorage = NSTextStorage(attributedString: attributedText)
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)

        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (bounds.size.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (bounds.size.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        let locationOfTouchInTextContainer = CGPoint(x: tapPoint.x - textContainerOffset.x,
                                                     y: tapPoint.y - textContainerOffset.y)
        return layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
    }
}
extension HTMLLabel: UITextViewDelegate {
    func textView(_ textView: UITextView,
                  shouldInteractWith URL: URL,
                  in characterRange: NSRange,
                  interaction: UITextItemInteraction) -> Bool {
        
        linkPressed?(URL)
        return false
    }
}
