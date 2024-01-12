bool checkWinner(List<String> board) {
  final List<List<int>> winningConditions = [
    [0, 1, 2], // row 1
    [3, 4, 5], // row 2
    [6, 7, 8], // row 3
    [0, 3, 6], // column 1
    [1, 4, 7], // column 2
    [2, 5, 8], // column 3
    [0, 4, 8], // diagonal 1
    [2, 4, 6], // diagonal 2
  ];

  for (final condition in winningConditions) {
    if (board[condition[0]] != '' &&
        board[condition[0]] == board[condition[1]] &&
        board[condition[1]] == board[condition[2]]) {
      return true;
    }
  }

  return false;
}
