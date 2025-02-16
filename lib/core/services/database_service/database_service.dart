import '../../models/faculty.dart';
import '../../models/student.dart';

abstract class DatabaseService {
  Future<void> insertStudent(Student student);
  Future<void> insertFaculty(Faculty faculty);
  Future<List<Student>> getStudents();
  Future<List<Faculty>> getFaculties();
}