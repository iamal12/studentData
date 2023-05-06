
import 'package:addstudentdata/dbfunctions.dart';
import 'package:addstudentdata/searchPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'addstudentwidget.dart';
import 'liststudent.dart';

class ScreenHome extends StatelessWidget{
  const ScreenHome({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context){
    getAllStudents();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: Text("Add Student App"), actions: [
          IconButton(onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchPage()),
            );
          }, icon: Icon(Icons.search)),


        ],),
      body: SafeArea(

        child: Column(
          children: [
            AddStudentWidget(),
            const Expanded(child: ListStudentWidget()),
          ],
        ),
      ),
    );
  }
}