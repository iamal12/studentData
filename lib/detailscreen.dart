import 'dart:convert';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:addstudentdata/student_provider.dart';
import 'package:addstudentdata/dbfunctions.dart';
import 'package:addstudentdata/studentmodel.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';


class DetailedScreen extends StatelessWidget {
  final int index;

  DetailedScreen(this.index);

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentProvider>(
      builder: (context, studentProvider, _) {
        final studentList = studentProvider.studentList;
        final studentModel = studentList[index];
        final base64Image = studentModel.profilePhoto;
        final imageBytes = base64.decode(base64Image!);
        final _nameController = TextEditingController(text: studentModel.name);
        final _ageController = TextEditingController(text: studentModel.age);
        final _departmentController = TextEditingController(text: studentModel.department);

        void _updateStudent() {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Edit Student Info"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      child: Image(image: MemoryImage(imageBytes)),
                      onTap: () async {
                        final picker = ImagePicker();
                        final pickedFile = await picker.pickImage(source: ImageSource.gallery);

                        if (pickedFile != null) {
                          final imageFile = File(pickedFile.path);

                        }
                      },
                    ),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: "Name",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter a name";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _ageController,
                      decoration: InputDecoration(
                        labelText: "Age",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter a valid age";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _departmentController,
                      decoration: InputDecoration(
                        labelText: "Department",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter a department";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.isNotEmpty &&
                        _ageController.text.isNotEmpty &&
                        _departmentController.text.isNotEmpty) {
                      final updatedStudent = StudentModel(
                        id: studentModel.id,
                        name: _nameController.text,
                        age: _ageController.text,
                        department: _departmentController.text,
                        profilePhoto: base64Image,
                        location: studentModel.location,
                      );
                      studentProvider.updateStudent(updatedStudent, studentModel.id!);
                      Navigator.pop(context);
                      studentProvider.notifyListeners();
                    }
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text("Detailed Student Info"),
            actions: [
              IconButton(
                onPressed: _updateStudent,
                icon: Icon(Icons.edit),
              ),
            ],
          ),
          body: Center(
            child: Container(
              height: 500,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 90,
                    backgroundImage: MemoryImage(imageBytes),
                  ),
                  SizedBox(height: 10),
                  Text(
                    studentModel.name,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Age: ${studentModel.age}',
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                  SizedBox(height: 9),
                  Text(
                    studentModel.department,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

