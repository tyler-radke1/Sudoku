//
//  GridBorderOverlay.swift
//  Sudoku
//
//  Created by Tyler on 7/20/25.
//

import Foundation
import SwiftUI

struct GridBorderOverlay: ViewModifier {
    let sides: Set<BorderSide>
    let color: Color
    let width: CGFloat = 4

    func body(content: Content) -> some View {
        content
            .overlay(
                sides.contains(.top)
                    ? Rectangle()
                        .frame(height: width)
                        .foregroundColor(color)
                        .frame(maxHeight: .infinity, alignment: .top)
                    : nil
            )
            .overlay(
                sides.contains(.bottom)
                    ? Rectangle()
                        .frame(height: width)
                        .foregroundColor(color)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                    : nil
            )
            .overlay(
                sides.contains(.left)
                    ? Rectangle()
                        .frame(width: width)
                        .foregroundColor(color)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    : nil
            )
            .overlay(
                sides.contains(.right)
                    ? Rectangle()
                        .frame(width: width)
                        .foregroundColor(color)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    : nil
            )
    }
}

extension View {
    func gridBorderOverlay(for position: Position, color: Color = .black) -> some View {
        let sides = BorderSide.getBorderSides(for: position)
        return self.modifier(GridBorderOverlay(sides: sides, color: color))
    }
}
