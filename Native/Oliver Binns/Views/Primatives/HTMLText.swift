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
        uiView.setLinkColor(.accent)

        DispatchQueue.main.async {
            let size = uiView.intrinsicContentSize
            guard size.height != self.desiredHeight else { return }
            self.desiredHeight = size.height
        }
    }
}
fileprivate final class HTMLLabel: UILabel {
    var linkPressed: ((URL) -> Void)?
    
    private var attributedTextCopy: NSAttributedString?

    lazy var textContainer: NSTextContainer = {
        let textContainer = NSTextContainer(size: .zero)
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = lineBreakMode
        textContainer.maximumNumberOfLines = numberOfLines
        textContainer.size = bounds.size
        return textContainer
    }()

    convenience init() {
        self.init(frame: .zero)
        numberOfLines = 0
        setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        isUserInteractionEnabled = true

        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleGesture(gesture:)))
        gesture.cancelsTouchesInView = false
        gesture.delegate = self
        gesture.allowableMovement = 0.5
        gesture.minimumPressDuration = 0
        self.addGestureRecognizer(gesture)
    }

    @objc private func handleGesture(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            onTouchDown(tapGesture: gesture)
        case .ended:
            onTouchUp(tapGesture: gesture)
        default:
            setLinkColor(.accent)
        }
    }

    private func onTouchDown(tapGesture: UIGestureRecognizer) {
        let tapPoint = tapGesture.location(in: self)
        guard let characterIndex = characterTapped(at: tapPoint) else {
            return
        }
        setLinkColor(.gray, at: characterIndex)
    }

    private func onTouchUp(tapGesture: UIGestureRecognizer) {
        let tapPoint = tapGesture.location(in: self)
        guard let characterIndex = characterTapped(at: tapPoint),
              let linkValue = attributedText?.attribute(.link, at: characterIndex, effectiveRange: nil) as? URL else {
            return
        }
        linkPressed?(linkValue)
        setLinkColor(.accent)
    }

    public func setLinkColor(_ color: UIColor, at characterIndex: Int? = nil) {
        guard let attributedText = attributedText else { return }
        attributedText.enumerateAttribute(.link,
                                          in: NSRange(location: 0, length: attributedText.length)) { (value, range, _) in
            guard value != nil else { return }
            if let characterIndex = characterIndex,
               !range.contains(characterIndex) {
                return
            }
            let string = NSMutableAttributedString(attributedString: attributedText)
            string.removeAttribute(.foregroundColor, range: range)
            string.addAttribute(.foregroundColor, value: color.cgColor, range: range)
            self.attributedText = string
         }
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
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (bounds.size.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (bounds.size.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        let locationOfTouchInTextContainer = CGPoint(x: tapPoint.x - textContainerOffset.x,
                                                     y: tapPoint.y - textContainerOffset.y)
        return layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
    }
}
extension HTMLLabel: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        false
    }
}
