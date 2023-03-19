//
//  SliderPin.swift
//  Oliver Binns
//
//  Created by Oliver Binns on 14/10/2020.
//

import SwiftUI

struct SliderPin: View {
    private let symbolName = "arrowtriangle.left.fill.and.line.vertical.and.arrowtriangle.right.fill"

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                PinShape(lineWidth: geometry.size.width / 3,
                         circleDiameter: geometry.size.width)
                    .fill(Color.black)
                PinShape(lineWidth: geometry.size.width / 3,
                         circleDiameter: geometry.size.width)
                    .inset(by: 2)
                    .fill(Color.white)
                    .overlay(Image(systemName: symbolName)
                                .font(.system(size: geometry.size.width / 2,
                                              weight: .medium, design: .default))
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.black))
            }
        }
    }
}

struct SliderPin_Previews: PreviewProvider {
    static var previews: some View {
        SliderPin()
    }
}

struct PinShape: InsettableShape {
    let lineWidth: CGFloat
    let circleDiameter: CGFloat
    var insetAmount: CGFloat = 0

    func path(in rect: CGRect) -> Path {
        let rectX = (rect.width - lineWidth) / 2
        var customShape = Path(roundedRect: CGRect(x: rectX + insetAmount / 2,
                                                   y: insetAmount / 2,
                                                   width: lineWidth - insetAmount,
                                                   height: rect.height - insetAmount),
                               cornerRadius: lineWidth / 2, style: .continuous)

        let circleX = (rect.width - circleDiameter) / 2
        let circleY = (rect.height - circleDiameter) / 2
        customShape.addEllipse(in: CGRect(x: circleX + insetAmount / 2,
                                          y: circleY + insetAmount / 2,
                                          width: circleDiameter - insetAmount,
                                          height: circleDiameter - insetAmount))
        return customShape
    }

    func inset(by amount: CGFloat) -> some InsettableShape {
        PinShape(lineWidth: lineWidth,
                 circleDiameter: circleDiameter,
                 insetAmount: insetAmount + amount)
    }
}
