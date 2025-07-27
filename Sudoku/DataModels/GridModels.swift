//
//  sudokuGrid.swift
//  Sudoku
//
//  Created by Tyler on 7/16/25.
//

import Foundation

struct SudokuGrid: Equatable {
    var rows: [SudokuRow]
    
    func getCell(at position: Position) -> SudokuCell {
        return rows[position.row].cells[position.column]
    }
    
    mutating func updateCell(at position: Position, with newCell: SudokuCell) {
        var newCellCopy = newCell
        rows[position.row].cells[position.column] = newCellCopy
        newCellCopy.valueIsIncorrect = self.checkForContradictions(position: position)
        rows[position.row].cells[position.column] = newCellCopy
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
    
    static func ==(lhs: SudokuGrid, rhs: SudokuGrid) -> Bool {
        for row in 0..<9 {
            for col in 0..<9 {
                if lhs.rows[row].cells[col].value != rhs.rows[row].cells[col].value {
                    return false
                }
            }
        }
        return true
    }

    func checkForContradictions(position: Position) -> Bool {
         checkRows(at: position) || checkColumns(at: position) || checkGrids(at: position)
    }
    
    private func checkRows(at position: Position) -> Bool {
        let selectedCell = self.getCell(at: position)
        guard selectedCell.value != 0 else { return false }
        
        var rowContradictions: Int {
            var count = 0
            let row = self.rows[position.row]
            
            for cell in row.cells {
                guard selectedCell.value != nil else { continue }
                count += cell.value == selectedCell.value ? 1 : 0
            }
            
            return count
        }
        
        return rowContradictions > 1
    }
    private func checkColumns(at position: Position) -> Bool {
        let selectedCell = self.getCell(at: position)
        guard selectedCell.value != 0 else { return false }
        
        var columnContradictions: Int {
            guard let selectedValue = selectedCell.value else { return 0 }

            var count = 0
            for rowIndex in 0..<9 {
                let cell = rows[rowIndex].cells[position.column]
                count += cell.value == selectedValue ? 1 : 0
            }

            return count
        }
        
        return columnContradictions > 1
    }
    private func checkGrids(at position: Position) -> Bool {
        let selectedCell = self.getCell(at: position)
        guard selectedCell.value != 0 else { return false }
        
        var gridContradictions: Int {
            var count = 0
            let selectedCellGrid = GridPosition.getGridPositionFrom(position: position)
            guard selectedCell.value != nil else { return 0}
            for rowIndex in 0..<9 {
                for columnIndex in 0..<9 {
                    let gridPosition = GridPosition.getGridPositionFrom(position: Position(row: rowIndex, column: columnIndex))
                    guard selectedCellGrid == gridPosition else { continue }
                    
                    let cell = rows[rowIndex].cells[columnIndex]
                    count += cell.value == selectedCell.value ? 1 : 0
                }
            }
            
            return count
        }
        return gridContradictions > 1
    }
}

struct SudokuRow {
    var cells: [SudokuCell]
}

struct SudokuCell {
    init(value: Int?, correctValueIfOpen: Int? = nil, isEditable: Bool) {
        self.value = value
        self.correctValueIfOpen = correctValueIfOpen
        self.pencilMarks = []
        self.isEditable = isEditable
        self.valueIsIncorrect = false
    }
    
    var value: Int?
    var correctValueIfOpen: Int?
    var pencilMarks: Set<Int> = []
    var isEditable: Bool
    var valueIsIncorrect: Bool
}

//MARK: Helper Types

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

enum GridPosition: CaseIterable {
    case upperLeft
    case upperMiddle
    case upperRight
    case middleLeft
    case middleMiddle
    case middleRight
    case lowerLeft
    case lowerRight
    case lowerMiddle
    
    var position: Position {
        switch self {
        case .upperLeft:
            return Position(row: 0, column: 0)
        case .upperMiddle:
            return Position(row: 0, column: 1)
        case .upperRight:
            return Position(row: 0, column: 2)
            
        case .middleLeft:
            return Position(row: 1, column: 0)
        case .middleMiddle:
            return Position(row: 1, column: 1)
        case .middleRight:
            return Position(row: 1, column: 2)
            
        case .lowerLeft:
            return Position(row: 2, column: 0)
        case .lowerMiddle:
            return Position(row: 2, column: 1)
        case .lowerRight:
            return Position(row: 2, column: 2)

        }
    }
    

    static func getGridPositionFrom(position: Position) -> GridPosition {
        let scaledDownPosition = Position(row: position.row / 3, column: position.column / 3)
        for possiblePosition in GridPosition.allCases {
            if possiblePosition.position == scaledDownPosition {
                return possiblePosition
            }
        }
        return .upperLeft
    }
}
