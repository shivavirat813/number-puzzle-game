// lib/features/game/widgets/grid_cell.dart
import 'package:flutter/material.dart';
import 'package:number_puzzle_game/core/models/cell.dart';

class GridCell extends StatelessWidget {
  final Cell cell;
  final VoidCallback? onTap;

  const GridCell({
    Key? key,
    required this.cell,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: cell.isActive ? Colors.blueAccent : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '${cell.value}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}