//
//  sudokuGrid.swift
//  Sudoku
//
//  Created by Tyler on 7/16/25.
//

import Foundation

struct SudokuGrid {
    var rows: [SudokuRow]
    
    //var columns: will come later, as is not need for UI
    //var boxes: will come later
    func getCellColumn() {
        
    }
    static var testGrid = SudokuGrid(rows: [
        SudokuRow.testRow,
        SudokuRow.testRow,
        SudokuRow.testRow,
        SudokuRow.testRow,
        SudokuRow.testRow,
        SudokuRow.testRow,
        SudokuRow.testRow,
        SudokuRow.testRow,
        SudokuRow.testRow
    ])
}

struct SudokuRow {
    var cells: [SudokuCell]
    
    static var testRow: SudokuRow {
        var cells: [SudokuCell] = []
        for i in 1...9 {
            cells.append(SudokuCell(cellType: .open, value: i))
        }
        return SudokuRow(cells: cells)
    }
}

enum CellType {
    case prefilled
    case open
}

struct SudokuCell {
    let cellType: CellType
    var value: Int
    var correctValueIfOpen: Int?
    var pencilMarks: Set<Int> = []
    var isSelected: Bool = false
}

