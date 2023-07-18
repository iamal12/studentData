import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'studentmodel.dart';
import 'package:provider/provider.dart';

class StudentProvider with ChangeNotifier {
  List<StudentModel> studentList = [];
  ValueNotifier<List<StudentModel>> studentListNotifier = ValueNotifier<
      List<StudentModel>>([]);

  StudentProvider() {
    getAllStudents();
  }

  Future<void> getAllStudents() async {
    final studentDB = await Hive.openBox<StudentModel>('student_db');
    studentList = studentDB.values.toList();
    studentListNotifier.value = studentList;
    studentListNotifier.notifyListeners();
  }

  Future<void> addStudent(StudentModel student) async {
    final box = await Hive.openBox<StudentModel>('student_db');
    final _id = await box.add(student);
    student.id = _id;
    studentList.add(student);
    studentListNotifier.value = studentList;
    studentListNotifier.notifyListeners();
  }

  void deleteStudent(int index) {
    if (index >= 0 && index < studentList.length) {
      final student = studentList[index];
      studentList.removeAt(index);
      final box = Hive.box<StudentModel>('student_db');
      box.delete(student.id);
      notifyListeners();
    }
  }


  void updateStudent(StudentModel updatedStudent, int index) async {
    studentList[index] = updatedStudent;
    final box = await Hive.openBox<StudentModel>('student_db');
    await box.put(updatedStudent.id, updatedStudent);
    studentListNotifier.value = studentList;
    studentListNotifier.notifyListeners();
  }
}
