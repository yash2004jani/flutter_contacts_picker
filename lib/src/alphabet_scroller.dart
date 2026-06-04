import 'package:flutter/material.dart';

class AlphabetScroller extends StatelessWidget {
  final List<String> alphabets;
  final Function(String) onLetterSelect;
  final String selectedLetter;

  const AlphabetScroller({
    super.key,
    required this.alphabets,
    required this.onLetterSelect,
    required this.selectedLetter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      alignment: Alignment.center,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: alphabets.length,
        itemBuilder: (context, index) {
          final letter = alphabets[index];
          final isSelected = letter == selectedLetter;
          return GestureDetector(
            onTap: () => onLetterSelect(letter),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                letter,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Theme.of(context).primaryColor : Colors.black54,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
