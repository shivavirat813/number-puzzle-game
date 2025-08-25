// lib/features/game/widgets/grid_board.dart
import 'package:flutter/material.dart';
import 'package:number_puzzle_game/core/models/cell.dart';

import 'gride_cell.dart';


class GridBoard extends StatelessWidget {
  final List<Cell> cells;
  final void Function(int) onCellTap;

  const GridBoard({
    Key? key,
    required this.cells,
    required this.onCellTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cells.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,        // change to 4 or 3 if you want fewer columns
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        return GridCell(
          cell: cells[index],
          onTap: () => onCellTap(index),
        );
      },
    );
  }
}