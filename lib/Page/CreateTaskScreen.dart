import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:business_tasks_app/utils/constants.dart';

import 'HomeScreen.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {

  TextEditingController taskNameController = TextEditingController();
  TextEditingController workerNameController = TextEditingController();

  TextEditingController workerContactController = TextEditingController();
  TextEditingController taskDescriptionController = TextEditingController();
  TextEditingController taskDeadlineController = TextEditingController();


  User? user =  FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.appName),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [

              const SizedBox(height: 20,),

              FadeInLeft(
                duration: const Duration(milliseconds: 1000),
                child: TextFormField(
                  controller: taskNameController,
                  decoration: InputDecoration(
                      hintText: "Наименование задания",
                      labelText: "Наименование задания",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                  ),
                ),
              ),
              const SizedBox(height: 20,),

              FadeInLeft(
                duration: const Duration(milliseconds: 1000),
                child: TextFormField(
                  controller:  workerNameController,
                  decoration: InputDecoration(
                      hintText: "ФИО работника",
                      labelText: "ФИО работника",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                  ),
                ),
              ),
              const SizedBox(height: 20,),


              FadeInLeft(
                duration: const Duration(milliseconds: 1000),
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: workerContactController,
                  decoration: InputDecoration(
                      hintText: "Телефон работника",
                      labelText: "Телефон работника",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                  ),
                ),
              ),
              const SizedBox(height: 20,),

              FadeInLeft(
                duration: const Duration(milliseconds: 1000),
                child: TextFormField(
                  controller: taskDescriptionController,
                  decoration: InputDecoration(
                      hintText: "Описание задачи",
                      labelText: "Описание задачи",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                  ),
                ),
              ),
              const SizedBox(height: 20,),

              FadeInLeft(
                duration: const Duration(milliseconds: 1000),
                child: TextFormField(
                  controller: taskDeadlineController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: "Дедлайн",
                      labelText: "Дедлайн",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                  ),
                ),
              ),
              const SizedBox(height: 20,),


              ElevatedButton(onPressed: () async {

                EasyLoading.show();

                Map<String,dynamic> userOrderMap = {
                  'userId': user?.uid,
                  'taskName':  taskNameController.text.trim(),
                  'workerName': workerNameController.text.trim(),
                  'workerContact': workerContactController.text.trim(),
                  'taskDescription': taskDescriptionController.text.trim(),
                  'taskDeadline': taskDeadlineController.text.trim(),
                  'date': DateTime.now(),
                  'status': "Ожидание"
              };
                await FirebaseFirestore.instance.collection('Задачи').doc().set(userOrderMap);

                Fluttertoast.showToast(msg: "Задача успешно создана");
                Get.to(const HomeScreen());
                EasyLoading.dismiss();

              }, child: const Text("Создать задачу работнику")),

            ],
          ),
        ),
      ),
    );
  }
}
