//
//  TestData.swift
//  Sudoku
//
//  Created by Tyler on 7/18/25.
//

import Foundation

class TestData {
    static var testGrid = SudokuGrid(rows: [
    testRow,
    testRow,
    testRow,
    testRow,
    testRow,
    testRow,
    testRow,
    testRow,
    testRow
])
    
    static var testRow: SudokuRow {
        var cells: [SudokuCell] = []
        for _ in 1...9 {
            cells.append(SudokuCell(value: nil, isEditable: true))
        }
        return SudokuRow(cells: cells)
    }

}
