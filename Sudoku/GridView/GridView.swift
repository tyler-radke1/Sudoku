//
//  ContentView.swift
//  Sudoku
//
//  Created by Tyler on 7/16/25.
//

import SwiftUI

struct SudokuGridView: View {
    @StateObject var vm: ViewModel
    init(grid: SudokuGrid) {
        _vm = StateObject(wrappedValue: ViewModel(grid: grid))
    }
    
    var body: some View {
        VStack(spacing: 2) {
            makeSettingsToolbar()
            
            ForEach(0..<9, id: \.self) { rowIndex in
                HStack(spacing: 2) {
                    ForEach(0..<9, id: \.self) { cellIndex in
                        reactiveCellView(in: $vm.currentPuzzle, at: Position(row: rowIndex, column: cellIndex))
                        
                    }
                }
            }
            
            makeInputButtons()
                .padding(.top, 20)
        }
        .alert("You Won!", isPresented: $vm.isShowingWinPopup) {
            Button("Start Over") {
                vm.fetchGrid(of: vm.selectedDifficulty)
            }
            Button("Dismiss", role: .cancel) { }
        } message: {
            Text("Congratulations! You've completed the puzzle.")
        }

        .task {
            vm.fetchGrid(of: vm.selectedDifficulty)
        }
        .padding()
        .background(vm.colorPalette.background)
    }
    @ViewBuilder
    func reactiveCellView(in puzzle: Binding<SudokuGrid?>, at position: Position) -> some View {
        if let cell = puzzle.wrappedValue?.getCell(at: position) {
            ZStack {
                Rectangle()
                    .fill(vm.getCellColor(position: position))
                    .frame(width: 40, height: 40)
                   // .border(cell.valueIsIncorrect ? vm.colorPalette.valueIncorrect: Color.black , width: 1)
                    .gridBorderOverlay(for: position, color: vm.colorPalette.gridBorder)
                    
                // Incorrect value border and shadow overlay
                 RoundedRectangle(cornerRadius: 4)
                     .stroke(cell.valueIsIncorrect ? vm.colorPalette.valueIncorrect : Color.black, lineWidth: cell.valueIsIncorrect ? 3 : 1)
                     .shadow(color: cell.valueIsIncorrect ? vm.colorPalette.valueIncorrect.opacity(0.6) : .clear, radius: 4)

                    
                // Pencil marks grid (only if no value and has notes)
                if cell.value == 0 && !cell.pencilMarks.isEmpty {
                    VStack(spacing: 0) {
                        ForEach(0..<3, id: \.self) { row in
                            HStack(spacing: 0) {
                                ForEach(0..<3, id: \.self) { col in
                                    let number = row * 3 + col + 1
                                    Text(cell.pencilMarks.contains(number) ? "\(number)" : "")
                                        .font(.caption2)
                                        .foregroundColor(vm.colorPalette.pencilMarkText)
                                        .frame(width: 13, height: 13, alignment: .center)
                                }
                            }
                        }
                    }
                }

                // Main number (centered)
                if let cellValue = cell.value {
                    Text("\(cellValue)")
                        .font(.headline)
                        .foregroundColor(cell.isEditable ? vm.colorPalette.userInputText : vm.colorPalette.givenText)
                        .frame(width: 40, height: 40, alignment: .center)
                }
                
            }
            .frame(width: 40, height: 40)
            .onTapGesture {
                vm.cellTapped(position: position)
            }
        }
    }
    
    @ViewBuilder
    func makeInputButtons() -> some View {
        HStack(spacing: 4) {
            ForEach(0...9, id: \.self) { number in
                Button(action: {
                    vm.inputTapped(input: number)
                }) {
                    ZStack {
                        if number > 0 {
                            Text("\(number)")
                                .font(.headline)
                                .foregroundColor(.primary)
                        } else {
                            Image(systemName: "delete.backward")
                                .font(.headline)
                                .foregroundColor(.red)
                        }
                    }
                    .frame(width: 35, height: 35)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(5)
                }
            }
        }
    }

    @ViewBuilder
    func makeSettingsToolbar() -> some View {
        // Toolbar at the top
        VStack {
            HStack(spacing: 6) {

               // New Puzzle Button
                Button("New Puzzle") {
                    vm.showingNewPuzzleDialogue = true
                }
                
                // Pencil Button
                Button(action: {
                    vm.isTakingNotes.toggle()
                }) {
                    Label(vm.isTakingNotes ? "Disable Notes" : "Enable Notes", systemImage: vm.isTakingNotes ? "pencil.circle.fill" : "pencil.circle" )
                        .foregroundStyle(vm.isTakingNotes ? .blue : .gray)
                }
                
                Button(action: {
                    vm.solveButtonTapped()
                }) {
                    Label("Solve", systemImage: "checkmark.circle")
                }
                
            }
            
            .confirmationDialog("Select Difficulty", isPresented: $vm.showingNewPuzzleDialogue, titleVisibility: .visible) {
                ForEach(GridDifficulty.allCases, id: \.self) { difficulty in
                    Button(difficulty.rawValue.capitalized) {
                        vm.selectedDifficulty = difficulty
                        vm.fetchGrid(of: difficulty)
                    }
                }
                Button("Cancel", role: .cancel) { }
            }
            
            Text("Time: \(vm.formattedTime)")
            .padding()
        }
        
    }
}

#Preview {
    SudokuGridView(grid: TestData.testGrid)
}
