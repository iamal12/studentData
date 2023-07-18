import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'student_provider.dart';
import 'searchPage.dart';
import 'addstudentwidget.dart';
import 'liststudent.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context);

    // Call getAllStudents method from the provider
    studentProvider.getAllStudents();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Add Student App"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Consumer<StudentProvider>(
              builder: (BuildContext context, StudentProvider studentProvider, Widget? child) {
                return AddStudentWidget();
              },
            ),
            Expanded(
              child: ListStudentWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
