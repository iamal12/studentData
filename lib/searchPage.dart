
import 'package:addstudentdata/dbfunctions.dart';
import 'package:addstudentdata/detailscreen.dart';
import 'package:addstudentdata/student_provider.dart';
import 'package:addstudentdata/studentmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final searchController = TextEditingController();

  List<StudentModel> filteredList = [];

  @override
  void initState() {
    super.initState();
    filteredList = Provider.of<StudentProvider>(context, listen: false).studentList;
  }

  void _updateFilteredList(List<StudentModel> studentList) {
    setState(() {
      filteredList = studentList.where((student) =>
      student.name.toLowerCase().contains(searchController.text.toLowerCase()) ||
          student.age.toLowerCase().contains(searchController.text.toLowerCase()) ||
          student.department.toLowerCase().contains(searchController.text.toLowerCase()),
      ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context);
    final studentList = studentProvider.studentList;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Search Students Here"),
        ),
        body: Column(
          children: [
            TextField(
              controller: searchController,
              onChanged: (_) => _updateFilteredList(studentList),
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemBuilder: (ctx, index) {
                  final data = filteredList[index];

                  return ListTile(
                    title: Text(data.name),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DetailedScreen(index)),
                      );
                    },
                    subtitle: Text('${data.age} ${data.department}'),
                    trailing: IconButton(
                      onPressed: () {
                        studentProvider.deleteStudent(index);
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),
                  );
                },
                separatorBuilder: (ctx, index) => const Divider(),
                itemCount: filteredList.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
