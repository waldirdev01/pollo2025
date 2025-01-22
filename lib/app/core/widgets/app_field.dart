// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:pollo2025/app/core/ui/ap_ui_config.dart';

class AppField extends StatelessWidget {
  final TextInputAction? textInputAction;
  final String label;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final IconButton? suffixIcon;
  final bool? obscureText;
  final ValueNotifier<bool> obscureTextVN;
  final FocusNode? focusNode;
  final TextInputType? keyBoadType;
  final String? initialValue;
  final Function(String?)? onSaved;
  AppField(
      {super.key,
      required this.label,
      this.controller,
      this.validator,
      this.suffixIcon,
      this.obscureText = false,
      this.focusNode,
      this.textInputAction,
      this.keyBoadType,
      this.initialValue,
      this.onSaved})
      : assert(obscureText == true ? suffixIcon == null : true,
            'obscureText não pode ser passado em conjunto com suffixIcon'),
        obscureTextVN = ValueNotifier(obscureText!);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: obscureTextVN,
        builder: (_, obscureTextValue, child) {
          return TextFormField(
            initialValue: initialValue,
            keyboardType: keyBoadType,
            textInputAction: textInputAction,
            focusNode: focusNode,
            controller: controller,
            validator: validator,
            obscureText: obscureTextValue,
            decoration: InputDecoration(
              isDense: true,
              labelText: label,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.red)),
              suffixIcon: suffixIcon ??
                  (obscureText == true
                      ? IconButton(
                          onPressed: () {
                            obscureTextVN.value = !obscureTextVN.value;
                          },
                          icon: Icon(
                            obscureTextValue
                                ? Icons.visibility
                                : Icons.visibility_off,
                            size: 24,
                            color: AppUiConfig.themeCustom.primaryColor,
                          ),
                        )
                      : null),
            ),
            onSaved: onSaved,
          );
        });
  }
}
