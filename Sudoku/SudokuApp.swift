//
//  SudokuApp.swift
//  Sudoku
//
//  Created by Tyler on 7/16/25.
//

import SwiftUI

@main
struct SudokuApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView(vm: HomeView.ViewModel())
            //SudokuGridView(grid: SudokuGrid.emptyGrid())
        }
    }
}
