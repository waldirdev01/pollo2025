import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pollo2025/app/models/school.dart';
import 'package:pollo2025/app/providers/school_provider.dart';

import '../../../core/ui/ap_ui_config.dart';
import '../../../models/student.dart';

class StudentCard extends StatefulWidget {
  const StudentCard({super.key, required this.student});
  final Student student;

  @override
  State<StudentCard> createState() => _StudentCardState();
}

class _StudentCardState extends State<StudentCard> {
  Future<String> getSchoolName(String schooId, BuildContext context) async {
    School? school;
    await context.read<SchoolProvider>().getSchool(schooId);
    if (mounted) {
      // ignore: use_build_context_synchronously
      school = context.read<SchoolProvider>().school;
    }
    if (school != null) {
      return school.name;
    } else {
      return 'Escola não encontrada';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: getColorByAbsences(widget.student.countAbsences()),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.student.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    FutureBuilder<String>(
                      future: getSchoolName(widget.student.schoolId, context),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else {
                          if (snapshot.hasError) {
                            return const Text('Erro ao carregar escola');
                          } else {
                            return Text(
                              snapshot.data!,
                              style: const TextStyle(fontSize: 18),
                            );
                          }
                        }
                      },
                    ),
                    Text('I-EDUCAR: ${widget.student.ieducar}',
                        style: const TextStyle(fontSize: 18)),
                    Text('Faltas: ${widget.student.countAbsences()}',
                        style: const TextStyle(fontSize: 18)),
                  ]),
            ),
            const SizedBox(
              width: double.minPositive,
            ),
            widget.student.incidentsId.isNotEmpty
                ? Icon(
                    Icons.report_problem,
                    color: AppUiConfig.themeCustom.primaryColor,
                  )
                : const SizedBox.shrink(),
            widget.student.differentiated != ''
                ? Icon(
                    Icons.admin_panel_settings,
                    color: AppUiConfig.themeCustom.primaryColor,
                  )
                : const SizedBox.shrink(),
            widget.student.requiresGuardian
                ? Icon(
                    Icons.group,
                    color: AppUiConfig.themeCustom.primaryColor,
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
