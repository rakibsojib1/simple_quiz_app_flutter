import 'package:flutter/material.dart';

class QuestionTile extends StatefulWidget {
  final String question;
  final List<dynamic> options;
  final int correctAnswerIndex;
  final Function(int) onOptionSelected;

  const QuestionTile({
    Key? key,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  _QuestionTileState createState() => _QuestionTileState();
}

class _QuestionTileState extends State<QuestionTile> {
  int selectedOptionIndex = -1;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(widget.question),
      children: [
        for (var i = 0; i < widget.options.length; i++)
          RadioListTile<int>(
            value: i,
            groupValue: selectedOptionIndex,
            onChanged: (value) {
              setState(() {
                selectedOptionIndex = value!;
                widget.onOptionSelected(value);
              });
            },
            title: Text(widget.options[i]),
          ),
      ],
    );
  }
}
