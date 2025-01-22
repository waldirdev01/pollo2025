import 'package:flutter/material.dart';
import 'package:pollo2025/app/core/ui/ap_ui_config.dart';
import 'package:pollo2025/app/models/e_c_student.dart';

class ECStudentCard extends StatelessWidget {
  const ECStudentCard(
      {super.key,
      required this.student,
      required this.checkBox,
      required this.value,
      this.deleteFunction});
  final ECStudent student;
  final Widget checkBox;
  final bool value;

  final void Function()? deleteFunction;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: value ? AppUiConfig.themeCustom.primaryColor : Colors.white,
        child: ListTile(
          title: Text(
            student.name,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: value
                    ? Colors.white
                    : AppUiConfig.themeCustom.primaryColor),
          ),
          subtitle: Text(
            student.ieducarCode.toString(),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: value
                    ? Colors.white
                    : AppUiConfig.themeCustom.primaryColor),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              checkBox,
              IconButton(
                  onPressed: deleteFunction,
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ))
            ],
          ),
        ));
  }
}
