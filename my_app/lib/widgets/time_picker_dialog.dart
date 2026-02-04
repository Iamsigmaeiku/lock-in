import 'package:flutter/material.dart';

class TimePickerDialog extends StatefulWidget {
  final String title;
  final int initialValue;
  final int min;
  final int max;

  const TimePickerDialog({
    super.key,
    required this.title,
    required this.initialValue,
    this.min = 1,
    this.max = 60,
  });

  @override
  State<TimePickerDialog> createState() => _TimePickerDialogState();
}

class _TimePickerDialogState extends State<TimePickerDialog> {
  late int _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$_currentValue 分鐘',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          Slider(
            value: _currentValue.toDouble(),
            min: widget.min.toDouble(),
            max: widget.max.toDouble(),
            divisions: widget.max - widget.min,
            label: '$_currentValue',
            onChanged: (value) {
              setState(() {
                _currentValue = value.toInt();
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${widget.min}'),
              Text('${widget.max}'),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _currentValue),
          child: const Text('確定'),
        ),
      ],
    );
  }
}
