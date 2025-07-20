//
//  ColorPalette.swift
//  Sudoku
//
//  Created by Tyler on 7/20/25.
//

import Foundation
import SwiftUI

struct ColorPalette {
    // Background behind the puzzle grid
    let background: Color

    // Text colors
    let givenText: Color
    let userInputText: Color
    let pencilMarkText: Color

    // Cell highlight
    let selectedCell: Color

    // Optional: border color, cell background, etc.
    let cellBorder: Color
    let gridBorder: Color

    // Example static theme using system colors
    static let `default` = ColorPalette(
        background: .white,
        givenText: .primary,
        userInputText: .purple,
        pencilMarkText: .mint,
        selectedCell: .pink.opacity(0.2),
        cellBorder: .gray.opacity(0.7),
        gridBorder: .pink.opacity(0.5)
    )
}
