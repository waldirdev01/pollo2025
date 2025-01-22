import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pollo2025/app/core/ui/ap_ui_config.dart';
import 'package:pollo2025/app/core/widgets/custom_app_bar.dart';
import 'package:pollo2025/app/models/student.dart';
import 'package:pollo2025/app/providers/app_auth_provider.dart';

import '../../models/incident.dart';
import '../../providers/student_provider.dart';

class IncidentCreateForm extends StatefulWidget {
  final Student student;

  const IncidentCreateForm({super.key, required this.student});

  @override
  State<IncidentCreateForm> createState() => _IncidentCreateFormState();
}

class _IncidentCreateFormState extends State<IncidentCreateForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _confirm = false;
  final TextEditingController _description = TextEditingController();
  late Incident incident;
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2028),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppAuthProvider>(context).appUser;
    return Scaffold(
        appBar: CustomAppBar(
          title: 'Registro de incidente',
          actions: [
            TextButton.icon(
              onPressed: () => _selectDate(context),
              icon: const Icon(
                Icons.calendar_today,
                color: Colors.white,
              ),
              label: Text(DateFormat('dd/MM/yyyy').format(_selectedDate),
                  style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                children: [
                  Text(widget.student.name,
                      style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 12),
                  !_confirm
                      ? const SizedBox()
                      : TextFormField(
                          maxLines: null,
                          controller: _description,
                          decoration: InputDecoration(
                              labelText: 'Descrição',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12))),
                        ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: AppUiConfig.elevatedButtonThemeCustom,
                    onPressed: !_confirm
                        ? () {
                            setState(() {
                              incident = Incident(
                                  studentId: widget.student.id!,
                                  dateCreate: DateTime.now(),
                                  description: _description.text,
                                  appUserName: appUser!.name,
                                  dateCient: DateTime.now());
                              context
                                  .read<StudentProvider>()
                                  .createIncident(incident: incident);
                              _confirm = true;
                            });
                          }
                        : () {
                            if (_formKey.currentState!.validate()) {
                              incident.description = _description.text;

                              context
                                  .read<StudentProvider>()
                                  .updateStudentIncident(
                                      widget.student.id!, incident);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }
                          },
                    child: !_confirm
                        ? const Text(
                            'Registrar incidente',
                            style: TextStyle(color: Colors.white),
                          )
                        : const Text(
                            'Salvar',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
