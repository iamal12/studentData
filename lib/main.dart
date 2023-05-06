import 'package:addstudentdata/screen_home.dart';
import 'package:addstudentdata/studentmodel.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if(!Hive.isAdapterRegistered(StudentModelAdapter().typeId)){
    Hive.registerAdapter(StudentModelAdapter());
  };
  runApp(MaterialApp(
    home: ScreenHome(),
  ));
}



