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
    func getCell(at position: Position) -> SudokuCell {
        return rows[position.row].cells[position.column]
    }
    
    mutating func updateValue(at position: Position, with value: Int) {
        rows[position.row].cells[position.column].value = value
    }
}

struct SudokuRow {
    var cells: [SudokuCell]
}

struct SudokuCell {
    var value: Int
    var correctValueIfOpen: Int?
    var pencilMarks: Set<Int> = []
    var isEditable: Bool
}

struct Position: Equatable {
    let row: Int
    let column: Int
}

