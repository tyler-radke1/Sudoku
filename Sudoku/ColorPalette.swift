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

    // Example static theme using system colors
    static let `default` = ColorPalette(
        background: .white,
        givenText: .primary,
        userInputText: .purple,
        pencilMarkText: .mint,
        selectedCell: .pink.opacity(0.2),
        cellBorder: .gray.opacity(0.7),
        valueIncorrect: .red,
        gridBorder: .pink.opacity(0.5)
    )
    
    static let relaxedNight = ColorPalette(
        background: Color(red: 0.10, green: 0.12, blue: 0.14),         // deep charcoal
        givenText: Color(red: 0.85, green: 0.85, blue: 0.90),          // soft light gray-blue
        userInputText: Color(red: 0.58, green: 0.75, blue: 0.98),      // soft sky blue
        pencilMarkText: Color(red: 0.60, green: 0.65, blue: 0.75),     // cool slate gray
        selectedCell: Color(red: 0.25, green: 0.35, blue: 0.45).opacity(0.6), // muted steel blue
        cellBorder: Color(red: 0.40, green: 0.45, blue: 0.50).opacity(0.7),   // neutral medium gray
        valueIncorrect: Color(red: 1.0, green: 0.35, blue: 0.35),      // alert red
        gridBorder: Color(red: 0.60, green: 0.70, blue: 0.80).opacity(0.5)    // soft bluish-gray
    )
    
    static let pinkTheme = ColorPalette(
        background: Color(red: 1.0, green: 0.94, blue: 0.96),         // soft blush background
        givenText: .pink,                                              // soft clue color
        userInputText: Color(red: 0.5, green: 0.0, blue: 0.5),
        pencilMarkText: Color(red: 0.9, green: 0.5, blue: 0.7),       // muted rose for notes
        selectedCell: Color.pink.opacity(0.3),                        // subtle highlight
        cellBorder: Color(red: 0.9, green: 0.7, blue: 0.8),           // light mauve border
        valueIncorrect: .red,                                        // classic error red
        gridBorder: .pink.opacity(0.5)                               // semi-transparent pink grid
    )

}
