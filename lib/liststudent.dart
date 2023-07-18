import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'studentmodel.dart';
import 'student_provider.dart';
import 'detailscreen.dart';

class ListStudentWidget extends StatelessWidget {
  const ListStudentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context);

    return ValueListenableBuilder<List<StudentModel>>(
      valueListenable: studentProvider.studentListNotifier,
      builder: (BuildContext context, List<StudentModel> studentList, Widget? child) {
        return ListView.separated(
          itemBuilder: (ctx, index) {
            final data = studentList[index];
            return ListTile(
              title: Text(data.name),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DetailedScreen(index)),
                );
              },
              subtitle: Text(data.age + data.department + data.location),
              trailing: IconButton(
                onPressed: () {
                  studentProvider.deleteStudent(index);
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            );
          },
          separatorBuilder: (ctx, index) {
            return const Divider();
          },
          itemCount: studentList.length,
        );
      },
    );
  }
}
