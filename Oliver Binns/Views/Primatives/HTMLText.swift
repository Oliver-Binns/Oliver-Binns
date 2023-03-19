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
    @State var font: UIFont = .serifBody
    @State var textColor: UIColor = .label

    @State private var desiredHeight: CGFloat = 0
    @State private var url: URL?
    var body: some View {
        HTMLText(attributedString: $attributedText,
                 desiredHeight: $desiredHeight,
                 font: $font, textColor: $textColor,
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
    @Binding var font: UIFont
    @Binding var textColor: UIColor
    var linkPressed: ((URL) -> Void)?

    func makeUIView(context: UIViewRepresentableContext<Self>) -> HTMLLabel {
        HTMLLabel()
    }

    func updateUIView(_ uiView: HTMLLabel, context: UIViewRepresentableContext<Self>) {
        guard let attributedString = attributedString else { return }
        uiView.linkPressed = linkPressed
        uiView.attributedText = NSMutableAttributedString(attributedString: attributedString)
            .setBaseFont(baseFont: font)
            .addingAttributes([.foregroundColor: textColor])
            .untilPhrase("…")
            .trimTrailingWhiteSpace()
        uiView.tintColor = .accent
        uiView.isEditable = false

        DispatchQueue.main.async {
            self.desiredHeight = uiView.contentSize.height
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
        setContentCompressionResistancePriority(.required, for: .vertical)
    }

    override var intrinsicContentSize: CGSize {
        contentSize
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
