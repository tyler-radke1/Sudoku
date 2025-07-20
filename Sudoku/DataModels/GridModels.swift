//
//  sudokuGrid.swift
//  Sudoku
//
//  Created by Tyler on 7/16/25.
//

import Foundation

struct SudokuGrid {
    var rows: [SudokuRow]
    
    func getCell(at position: Position) -> SudokuCell {
        return rows[position.row].cells[position.column]
    }
    
    mutating func updateValue(at position: Position, with value: Int) {
        rows[position.row].cells[position.column].value = value
    }
    
    mutating func receivedPencilMark(_ mark: Int, for cellPosition: Position) {
        var cell = getCell(at: cellPosition)
        
        if cell.pencilMarks.contains(mark) {
            cell.pencilMarks.remove(mark)
        } else {
            cell.pencilMarks.insert(mark)
        }
        
        rows[cellPosition.row].cells[cellPosition.column] = cell
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

enum BorderSide {
    case top, right, bottom, left
    
    static func getBorderSides(for position: Position) -> Set<BorderSide> {
        var sides = Set<BorderSide>()
        
        // Outer edges (thicker)
        if [0,3,6].contains(position.row) {
            sides.insert(.top)
        }
        if position.row == 8 {
            sides.insert(.bottom)
        }
        if [0,3,6].contains(position.column) {
            sides.insert(.left)
        }
        if position.column == 8 {
            sides.insert(.right)
        }
        
        return sides
    }
}

