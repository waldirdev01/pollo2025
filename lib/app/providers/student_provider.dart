import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/attendance.dart';
import '../models/incident.dart';
import '../models/student.dart';

class StudentProvider extends ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore;
  StudentProvider({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;
  Student? _student;
  Student? get student => _student;
  set student(Student? value) {
    _student = value;
    notifyListeners();
  }

  List<Student> _students = [];
  List<Student> get students => _students;
  set students(List<Student> value) {
    _students = value;
    notifyListeners();
  }

  Incident? _incident;
  Incident? get incident => _incident;
  set incident(Incident? value) {
    _incident = value;
    notifyListeners();
  }

  List<Incident> _incidents = [];
  List<Incident> get incidents => _incidents;
  set incidents(List<Incident> value) {
    _incidents = value;
    notifyListeners();
  }

  Future<void> createStudent({required Student student}) async {
    try {
      final doc =
          await _firebaseFirestore.collection('students').add(student.toJson());
      student.id = doc.id;
      await _firebaseFirestore
          .collection('students')
          .doc(doc.id)
          .set(student.toJson());
      await _firebaseFirestore
          .collection('schools')
          .doc(student.schoolId)
          .update({
        'studentsId': FieldValue.arrayUnion([student.id])
      });
      notifyListeners();
    } on FirebaseException catch (e) {
      throw e.message!;
    }
  }

  Future<List<Student>> getStudentByName(String name) async {
    final snappshot = await _firebaseFirestore
        .collection('students')
        .orderBy('name')
        .startAt([name]).endAt(['$name\uf8ff']).get();

    List<Student> students = snappshot.docs
        .map((doc) => Student.fromJson(doc.data())..id = doc.id)
        .toList();

    return students;
  }

  Future<void> addCPF() async {
    final snappshot = await _firebaseFirestore
        .collection('students')
        .where('cpf', isEqualTo: '')
        .get();
    // ignore: avoid_function_literals_in_foreach_calls
    snappshot.docs.forEach((doc) async {
      await _firebaseFirestore
          .collection('students')
          .doc(doc.id)
          .update({'cpf': '00000000000'});
    });
  }

  Future<void> createIncident({required Incident incident}) async {
    try {
      final doc = await _firebaseFirestore
          .collection('incidents')
          .add(incident.toJson());
      incident.id = doc.id;
      await _firebaseFirestore
          .collection('incidents')
          .doc(doc.id)
          .set(incident.toJson());
      await _firebaseFirestore
          .collection('students')
          .doc(incident.studentId)
          .update({
        'studentsId': FieldValue.arrayUnion([student?.id])
      });
      notifyListeners();
    } on FirebaseException catch (e) {
      throw e.message!;
    }
  }

  Future<Student> getStudent(String id) async {
    try {
      final snapshot =
          await _firebaseFirestore.collection('students').doc(id).get();
      _student = Student.fromJson(snapshot.data()!);
      notifyListeners();
      return _student!;
    } on FirebaseException catch (e) {
      throw e.message!;
    }
  }

  Future<int> getNumberTotalStudents() async {
    try {
      final snapshot = await _firebaseFirestore.collection('students').get();
      final numberofStudents = snapshot.docs.length;
      notifyListeners();
      return numberofStudents;
    } on FirebaseException catch (e) {
      throw e.message ?? 'Ocorreu um erro desconhecido';
    }
  }

  Future<int> getNumberStudentPNE() async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('students')
          .where('pne.type', isNotEqualTo: 'none')
          .get();
      final numberofStudents = snapshot.docs.length;
      notifyListeners();
      return numberofStudents;
    } on FirebaseException catch (e) {
      throw e.message ?? 'Ocorreu um erro desconhecido';
    }
  }

  Future<int> getNumberStudentPNEBySchool(String schoolId) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('students')
          .where('schoolId', isEqualTo: schoolId)
          .where('pne.type', isNotEqualTo: 'none')
          .get();
      final numberofStudents = snapshot.docs.length;
      notifyListeners();
      return numberofStudents;
    } on FirebaseException catch (e) {
      throw e.message ?? 'Ocorreu um erro desconhecido';
    }
  }

  Future<int> getNumberStudentPNEvisualImpairment() async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('students')
          .where('pne.type', isEqualTo: 'visualImpairment')
          .get();
      final numberofStudents = snapshot.docs.length;
      notifyListeners();
      return numberofStudents;
    } on FirebaseException catch (e) {
      throw e.message ?? 'Ocorreu um erro desconhecido';
    }
  }

  Future<int> getNumberTotalStudentBySchool(String schoolId) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('students')
          .where('schoolId', isEqualTo: schoolId)
          .get();
      final numberofStudents = snapshot.docs.length;
      notifyListeners();
      return numberofStudents;
    } on FirebaseException catch (e) {
      throw e.message ?? 'Ocorreu um erro desconhecido';
    }
  }

  Future<int> getNumberStudentPNEvisualImpairmentBySchool(
      String schoolId) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('students')
          .where('schoolId', isEqualTo: schoolId)
          .where('pne.type', isEqualTo: 'visualImpairment')
          .get();
      final numberofStudents = snapshot.docs.length;
      notifyListeners();
      return numberofStudents;
    } on FirebaseException catch (e) {
      throw e.message ?? 'Ocorreu um erro desconhecido';
    }
  }

  Future<int> getwheelchairUser() async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('students')
          .where('pne.type', isEqualTo: 'wheelchairUser')
          .get();
      final numberofStudents = snapshot.docs.length;
      notifyListeners();
      return numberofStudents;
    } on FirebaseException catch (e) {
      throw e.message ?? 'Ocorreu um erro desconhecido';
    }
  }

  Future<int> getwheelchairUserBySchool(String schoolId) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('students')
          .where('schoolId', isEqualTo: schoolId)
          .where('pne.type', isEqualTo: 'wheelchairUser')
          .get();
      final numberofStudents = snapshot.docs.length;
      notifyListeners();
      return numberofStudents;
    } on FirebaseException catch (e) {
      throw e.message ?? 'Ocorreu um erro desconhecido';
    }
  }

  Future<int> getStudentsRequeriesGuardian() async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('students')
          .where('requiresGuardian', isEqualTo: true)
          .get();
      final numberofStudents = snapshot.docs.length;
      notifyListeners();
      return numberofStudents;
    } on FirebaseException catch (e) {
      throw e.message ?? 'Ocorreu um erro desconhecido';
    }
  }

  Future<int> getStudentsRequeriesGuardianBySchool(String schoolId) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('students')
          .where('schoolId', isEqualTo: schoolId)
          .where('requiresGuardian', isEqualTo: true)
          .get();
      final numberofStudents = snapshot.docs.length;
      notifyListeners();
      return numberofStudents;
    } on FirebaseException catch (e) {
      throw e.message ?? 'Ocorreu um erro desconhecido';
    }
  }

  Future<int> getAutistic() async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('students')
          .where('pne.type', isEqualTo: 'autistic')
          .get();
      final numberofStudents = snapshot.docs.length;
      notifyListeners();
      return numberofStudents;
    } on FirebaseException catch (e) {
      throw e.message ?? 'Ocorreu um erro desconhecido';
    }
  }

  Future<int> getAutisticBySchool(String schoolId) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('students')
          .where('schoolId', isEqualTo: schoolId)
          .where('pne.type', isEqualTo: 'autistic')
          .get();
      final numberofStudents = snapshot.docs.length;
      notifyListeners();
      return numberofStudents;
    } on FirebaseException catch (e) {
      throw e.message ?? 'Ocorreu um erro desconhecido';
    }
  }

  Future<int> getNumberStudentRuralResidence() async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('students')
          .where('residenceType', isEqualTo: 'RURAL')
          .get();
      final numberofStudents = snapshot.docs.length;
      notifyListeners();
      return numberofStudents;
    } on FirebaseException catch (e) {
      throw e.message ?? 'Ocorreu um erro desconhecido';
    }
  }

  Future<int> getNumberStudentRuralResidenceBySchool(String schoolId) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('students')
          .where('schoolId', isEqualTo: schoolId)
          .where('residenceType', isEqualTo: 'RURAL')
          .get();
      final numberofStudents = snapshot.docs.length;
      notifyListeners();
      return numberofStudents;
    } on FirebaseException catch (e) {
      throw e.message ?? 'Ocorreu um erro desconhecido';
    }
  }

  Future<int> getNumberStudentUrbanResidence() async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('students')
          .where('residenceType', isEqualTo: 'URBANA')
          .get();
      final numberofStudents = snapshot.docs.length;
      notifyListeners();
      return numberofStudents;
    } on FirebaseException catch (e) {
      throw e.message ?? 'Ocorreu um erro desconhecido';
    }
  }

  Future<int> getNumberStudentUrbanResidenceBySchool(String schoolId) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('students')
          .where('schoolId', isEqualTo: schoolId)
          .where('residenceType', isEqualTo: 'URBANA')
          .get();
      final numberofStudents = snapshot.docs.length;
      notifyListeners();

      return numberofStudents;
    } on FirebaseException catch (e) {
      throw e.message ?? 'Ocorreu um erro desconhecido';
    }
  }

  Future<List<Student>> getStudentsBySchoolIsNotAuthorized(
      String schoolId) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('students')
          .where('schoolId', isEqualTo: schoolId)
          .where('authorized', isEqualTo: false)
          .orderBy('createdAt')
          .get();
      _students = snapshot.docs.map((e) => Student.fromJson(e.data())).toList();

      return _students;
    } on FirebaseException catch (e) {
      throw e.message!;
    }
  }

  Future<List<Student>> getStudentsNotAuthorized() async {
    List<Student> studants = [];
    try {
      final snapshot = await _firebaseFirestore
          .collection('students')
          .where('authorized', isEqualTo: false)
          .get();
      _students = snapshot.docs.map((e) => Student.fromJson(e.data())).toList();

      _students.map((student) {
        if (student.itineraryId != '') {
          studants.add(student);
        }
      }).toList();
      _students.sort((a, b) => a.name.compareTo(b.name));
      notifyListeners();

      return studants;
    } on FirebaseException catch (e) {
      throw e.message!;
    }
  }

  Future<List<Student>> getStudentsBySchoolHaveIncident(String schoolId) async {
    try {
      // Passo 1: Obtenha todos os incidentes marcados como cient == false.
      var incidentsSnapshot = await _firebaseFirestore
          .collection('incidents')
          .where('cient', isEqualTo: false)
          .get();

      // Passo 2: Filtre os IDs dos alunos desses incidentes.
      Set<String> studentIdsWithIncidents = incidentsSnapshot.docs
          .map((doc) => doc['studentId'] as String)
          .toSet();

      // Passo 3: Obtenha os alunos que correspondem aos IDs coletados e pertencem à escola específica.
      List<Student> studentsWithUnacknowledgedIncidents = [];
      for (String studentId in studentIdsWithIncidents) {
        var studentSnapshot = await _firebaseFirestore
            .collection('students')
            .doc(studentId)
            .get();

        var studentData = studentSnapshot.data();
        if (studentData != null && studentData['schoolId'] == schoolId) {
          // Aqui, criamos uma instância de Student a partir dos dados
          // Nota: Você precisará ajustar isso para corresponder à estrutura da sua classe Student
          Student student = Student.fromJson(studentData);
          studentsWithUnacknowledgedIncidents.add(student);
        }
      }

      return studentsWithUnacknowledgedIncidents;
    } on FirebaseException catch (e) {
      throw e.message!;
    }
  }

  Future<List<Student>> getStudentsBySchoolIsWithoutInitinerary(
      String schoolId) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('students')
          .where('schoolId', isEqualTo: schoolId)
          .where('itineraryId', isEqualTo: '')
          .get();
      _students = snapshot.docs.map((e) => Student.fromJson(e.data())).toList();
      _students.sort((a, b) => a.name.compareTo(b.name));
      return _students;
    } on FirebaseException catch (e) {
      throw e.message!;
    }
  }

  Future<List<Student>> getStudentsBySchool(String schoolId) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('students')
          .where('schoolId', isEqualTo: schoolId)
          .get();
      _students = snapshot.docs.map((e) => Student.fromJson(e.data())).toList();
      _students.sort((a, b) => a.name.compareTo(b.name));
      for (var std in _students) {
        print('${std.name.toUpperCase()}, ${std.ieducar}, ${std.cpf}');
      }
      print('TOTAL DE ESTUDANTES: ${_students.length}');
      return _students;
    } on FirebaseException catch (e) {
      throw e.message!;
    }
  }

  Future<List<Student>> getStudentsForAuthorize() async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('students')
          .where('authorized', isEqualTo: false)
          .get();
      _students.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      _students = snapshot.docs.map((e) => Student.fromJson(e.data())).toList();

      return _students;
    } on FirebaseException catch (e) {
      throw e.message!;
    }
  }

  Future<List<Student>> getStudentsByItinerary(String itineraryId) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('students')
          .where('itineraryId', isEqualTo: itineraryId)
          .get();
      _students = snapshot.docs.map((e) => Student.fromJson(e.data())).toList();
      _students.sort((a, b) => a.name.compareTo(b.name));
      notifyListeners();
      return _students;
    } on FirebaseException catch (e) {
      throw e.message!;
    }
  }

  String cleanCpf(String cpf) {
    // Remover pontos, traços e espaços em branco
    return cpf.replaceAll(RegExp(r'[.\-\s]'), '');
  }

  Future<List<Student>> getStudentsWithCpfNot11Characters() async {
    try {
      // Carregar todos os estudantes (ou adicionar mais filtros na consulta, se necessário)
      final snapshot = await _firebaseFirestore.collection('students').get();

      // Filtrar os estudantes localmente onde o campo 'cpf' tenha um número de caracteres diferente de 11
      List<Student> filteredStudents = snapshot.docs
          .map((e) => Student.fromJson(e.data()))
          .where((student) => cleanCpf(student.cpf).length != 11)
          .toList();

      for (var student in filteredStudents) {
        // Limpar o CPF antes de imprimir
        // String cleanedCpf = cleanCpf(student.cpf);
        print(student.cpf);

        // Atualizar o CPF limpo no Firestore
        // student.cpf = '000000000${cleanedCpf}';
        //await updateStudent(student); // Atualizar no Firestore
      }

      return filteredStudents;
    } on FirebaseException catch (e) {
      throw e.message!;
    }
  }

  Future<void> deleteStudent(
      String studentId, String schoolId, String itineraryId) async {
    try {
      await _firebaseFirestore.collection('students').doc(studentId).delete();
      await _firebaseFirestore.collection('schools').doc(schoolId).update({
        'studentsId': FieldValue.arrayRemove([studentId])
      });
      await _firebaseFirestore
          .collection('itineraries')
          .doc(itineraryId)
          .update({
        'studentIds': FieldValue.arrayRemove([studentId])
      });
      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> updateStudent(Student student) async {
    try {
      await _firebaseFirestore
          .collection('students')
          .doc(student.id)
          .update(student.toJson());
      notifyListeners();
    } on FirebaseException catch (e) {
      throw e.message!;
    }
  }

  Future<List<Incident>> getIncidentsByStudent(String studentId) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('incidents')
          .where('studentId', isEqualTo: studentId)
          .get();
      incidents =
          snapshot.docs.map((e) => Incident.fromJson(e.data())).toList();
      notifyListeners();
      return incidents;
    } on FirebaseException catch (e) {
      throw e.message!;
    }
  }

  Future<void> updateStudentIncident(
      String studentId, Incident incident) async {
    try {
      await _firebaseFirestore
          .collection('incidents')
          .doc(incident.id)
          .update(incident.toJson());
      await _firebaseFirestore.collection('students').doc(studentId).update({
        'incidentsId': FieldValue.arrayUnion([incident.id])
      });

      notifyListeners();
    } on FirebaseException catch (e) {
      throw e.message!;
    }
  }

  Future<void> updateAttendance(
      String studentId, List<Attendance> attendance) async {
    final doc = _firebaseFirestore.collection('students').doc(studentId);
    final attendanceJson = attendance.map((a) => a.toJson()).toList();

    try {
      await doc.update({'attendance': attendanceJson});
    } catch (e) {
      debugPrint('Detalhes do erro original: $e');
      throw Exception("Falha ao atualizar a frequência do estudante.");
    }
  }

  Future<void> deleteAttendance(String studentId, DateTime dateToDelete) async {
    final studentDoc =
        await _firebaseFirestore.collection('students').doc(studentId).get();
    final studentData = studentDoc.data() as Map<String, dynamic>;

    if (studentData.containsKey('attendance')) {
      final List<dynamic> attendanceJson = studentData['attendance'];
      final List<Attendance> attendance =
          attendanceJson.map((json) => Attendance.fromJson(json)).toList();

      attendance
          .removeWhere((attendance) => attendance.isSameDay(dateToDelete));

      await _firebaseFirestore
          .collection('students')
          .doc(studentId)
          .update({'attendance': attendance.map((a) => a.toJson()).toList()});
    }

    notifyListeners();
  }

  Future<void> subtractOneAbsence(String studentId) async {
    final doc = _firebaseFirestore.collection('students').doc(studentId);
    final studentDoc = await doc.get();
    final studentData = studentDoc.data() as Map<String, dynamic>;

    if (studentData.containsKey('attendance')) {
      final List<dynamic> attendanceJson = studentData['attendance'];
      final List<Attendance> attendance =
          attendanceJson.map((json) => Attendance.fromJson(json)).toList();

      bool hasSubtracted = false;

      for (var att in attendance) {
        if (!att.going) {
          att.going = true;
          hasSubtracted = true;
          break;
        }
        if (!att.returning) {
          att.returning = true;
          hasSubtracted = true;
          break;
        }
      }

      if (hasSubtracted) {
        await doc
            .update({'attendance': attendance.map((a) => a.toJson()).toList()});
        notifyListeners();
      }
    }
  }

  Future<void> resetAbsences(String studentId) async {
    final doc = _firebaseFirestore.collection('students').doc(studentId);
    final studentDoc = await doc.get();
    final studentData = studentDoc.data() as Map<String, dynamic>;

    if (studentData.containsKey('attendance')) {
      final List<dynamic> attendanceJson = studentData['attendance'];
      final List<Attendance> attendance =
          attendanceJson.map((json) => Attendance.fromJson(json)).toList();

      for (var att in attendance) {
        att.going = true;
        att.returning = true;
      }

      await doc
          .update({'attendance': attendance.map((a) => a.toJson()).toList()});
      notifyListeners();
    }
  }
}
