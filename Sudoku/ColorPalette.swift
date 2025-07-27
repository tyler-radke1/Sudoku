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
    let valueIncorrect: Color
    let gridBorder: Color
    
    static let neutralSteel = ColorPalette(
        background: Color(red: 0.92, green: 0.93, blue: 0.95),         // soft off-white with blue hint
        givenText: Color(red: 0.15, green: 0.17, blue: 0.20),          // deep charcoal text
        userInputText: Color(red: 0.25, green: 0.40, blue: 0.65),      // muted steel blue
        pencilMarkText: Color(red: 0.40, green: 0.45, blue: 0.50),     // cool gray
        selectedCell: Color(red: 0.70, green: 0.80, blue: 0.90).opacity(0.5), // pale steel blue
        cellBorder: Color(red: 0.70, green: 0.70, blue: 0.75).opacity(0.6),   // neutral medium-light gray
        valueIncorrect: Color(red: 0.85, green: 0.25, blue: 0.25),     // softer alert red
        gridBorder: .black.opacity(0.5)    // bluish-gray border
    )
}
