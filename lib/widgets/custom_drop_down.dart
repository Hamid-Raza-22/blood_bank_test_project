// 📌 new
import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final int value;
  final ValueChanged<int?> onChanged;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: value,
      items: List.generate(10, (index) {
        int number = index + 1;
        return DropdownMenuItem(

          value: number,
          child: Text(number.toString()),
        );
      }),
      onChanged: onChanged,

    );
  }
}
