import 'package:flutter/material.dart';

class SchoolTextFormFieldEdit extends StatelessWidget {
  const SchoolTextFormFieldEdit(
      {super.key, this.initialValue, this.onSaved, required this.labelText});

  final String? initialValue;
  final Function(String?)? onSaved;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: labelText,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        initialValue: initialValue,
        onSaved: onSaved,
      ),
    );
  }
}
