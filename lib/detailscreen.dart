import 'dart:convert';

import 'package:addstudentdata/dbfunctions.dart';
import 'package:addstudentdata/studentmodel.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DetailedScreen extends StatefulWidget {
  final int index;
  DetailedScreen(this.index);

  @override
  State<DetailedScreen> createState() => _DetailedScreenState();
}

class _DetailedScreenState extends State<DetailedScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _departmentController;
  late StudentModel _studentModel;

  @override
  void initState(){
    super.initState();
    _nameController = TextEditingController();
    _ageController = TextEditingController();
    _departmentController = TextEditingController();
    final studentList = studentListNotifier.value;
    _studentModel = studentList[widget.index];
    _nameController.text = _studentModel.name;
    _ageController.text = _studentModel.age.toString();
    _departmentController.text = _studentModel.department;
  }

  @override
  void dispose(){
    _nameController.dispose();
    _ageController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  Future<void> _updateStudent(StudentModel studentModel) async {
    if (_formKey.currentState!.validate()) {
      final studentList = studentListNotifier.value;
      final updatedStudent = StudentModel(
        id: _studentModel.id,
        name: _nameController.text,
        age: (_ageController.text),
        department: _departmentController.text,
        profilePhoto: _studentModel.profilePhoto,
        location: _studentModel.location
      );
      studentList[widget.index] = updatedStudent;
      final box = await Hive.openBox<StudentModel>('student_db');
      await box.put(_studentModel.id, _studentModel);
      studentListNotifier.value = studentList;
      notifyListeners();

    }
  }


  @override
  Widget build(BuildContext context) {
    final base64Image = _studentModel.profilePhoto;
    final imageBytes = base64.decode(base64Image!);

    return ValueListenableBuilder<List<StudentModel>>(
      valueListenable: studentListNotifier,
      builder: (BuildContext context, List<StudentModel> studentList, Widget? child) {
        final data = studentList[widget.index];
        final base64Image = data.profilePhoto;
        final imageBytes = base64.decode(base64Image!);
        return Scaffold(

          resizeToAvoidBottomInset: false,
          appBar: AppBar(title: Text("Detailed Student Info"),
          actions: [
            IconButton(onPressed: (){
              showDialog(context: context, builder: (context) => AlertDialog(
                title: Text("Edit Student Info"),
                content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: "Name",
                        ),
                        validator: (value){
                          if(value ==null || value.isEmpty){
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
                        validator: (value){
                          if(value ==null || value.isEmpty){
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
                        validator: (value){
                          if(value ==null || value.isEmpty){
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
                      if (_formKey.currentState!.validate()) {
                        final updatedStudent = StudentModel(
                          name:_nameController.text,
                          age: (_ageController.text),
                          department:_departmentController.text,
                          profilePhoto: _studentModel.profilePhoto,
                          location: _studentModel.location
                        );
                        studentListNotifier.value[widget.index] = updatedStudent;
                        _updateStudent(updatedStudent);
                        setState(() {});
                        notifyListeners();
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Save'),
                  ),
                ],

              ));
            }, icon: Icon(Icons.edit))
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
                    backgroundImage: MemoryImage(imageBytes), // Use the photoUrl from the student data
                  ),
                  SizedBox(height: 10),
                  Text(
                    data.name,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold,color: Colors.blue),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Age: ${data.age}', // Use string interpolation to display age
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                  SizedBox(height: 9),
                  Text(
                    data.department,
                    style: TextStyle(fontSize: 16,color: Colors.black),
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
