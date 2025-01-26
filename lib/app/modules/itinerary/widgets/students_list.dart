import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/itinerary.dart';
import '../../../models/student.dart';
import '../../../providers/student_provider.dart';
import '../../student/widgets/student_card.dart';

class StudentsList extends StatelessWidget {
  final Itinerary itinerary;

  const StudentsList({super.key, required this.itinerary});

  @override
  Widget build(BuildContext context) {
    final studentProvider = context.read<StudentProvider>();

    return FutureBuilder<List<Student>>(
      future: studentProvider.getStudentsByItinerary(itinerary.id!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhum estudante cadastrado.'));
        }

        final students = snapshot.data!;
        students.sort((a, b) => a.name.compareTo(b.name));

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: students.length,
          itemBuilder: (context, index) {
            final student = students[index];
            return StudentCard(student: student);
          },
        );
      },
    );
  }
}
