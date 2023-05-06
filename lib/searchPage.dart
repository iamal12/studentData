
import 'package:addstudentdata/dbfunctions.dart';
import 'package:addstudentdata/detailscreen.dart';
import 'package:addstudentdata/studentmodel.dart';
import 'package:flutter/material.dart';

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
    filteredList = studentListNotifier.value;
  }

  void _updateFilteredList() {
    setState(() {
      filteredList = studentListNotifier.value.where((student) =>
      student.name.toLowerCase().contains(searchController.text.toLowerCase())
          || student.age.toLowerCase().contains(searchController.text.toLowerCase())
          || student.department.toLowerCase().contains(searchController.text.toLowerCase())
      ).toList();
    });
  }

  @override
  Widget build(BuildContext context){
    final studentList = studentListNotifier.value;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Search Students Here"),),
        body: ValueListenableBuilder<List<StudentModel>>(
          valueListenable: studentListNotifier,
          builder: (BuildContext context, List<StudentModel> studentList, Widget? child) {
          //notifyListeners();
            return Column(
              children: [
                TextField(
                  controller: searchController,
                  onChanged: (_) => _updateFilteredList(),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (ctx, index) {
                      final data = filteredList[index];
                      notifyListeners();

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
                            if (data.id != null) {
                              deleteStudent(data.id!);
                            } else {
                              print('Student id is null, Unable to delete');
                            }
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
            );
          },
        ),
      ),
    );
  }
}