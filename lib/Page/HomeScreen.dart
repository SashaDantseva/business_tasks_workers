import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:business_tasks_app/utils/constants.dart';
import 'package:business_tasks_app/page/CreateTaskScreen.dart';

import 'LoginScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  User? user= FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppConstants.appName),
        actions: [
          GestureDetector(
              onTap: (){
                Get.to(const CreateTaskScreen());
              },
              child: Container(
                margin: const EdgeInsets.only(right: 15),
                child: const CircleAvatar(
                    child: Icon(Icons.shopping_cart)),
              ))
        ],
      ),

      drawer: Drawer(
        child: ListView(
          children:  [
             const UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(child: Text("44"),),
                accountName: Text('Данцева Александра'),
                accountEmail: Text("sashadantseva@nyasha.ru")),

            const ListTile(
                title: Text("Начальная страница"),
                leading: Icon(Icons.home_outlined),
                trailing: Icon(Icons.arrow_circle_right_outlined),
              ),

            GestureDetector(
              onTap: (){
                Get.to(const CreateTaskScreen());
              },
              child: const ListTile(
                title: Text("Создать новую задачу"),
                leading: Icon(Icons.add_business_outlined),
                trailing: Icon(Icons.arrow_circle_right_outlined),
              ),
            ),

            const ListTile(
              title: Text("Информация"),
              leading: Icon(Icons.info_outline),
              trailing: Icon(Icons.arrow_circle_right_outlined),
            ),

            const Divider(height: 3,color: Colors.grey,),

            const  ListTile(
              title: Text("Помощь"),
              leading: Icon(Icons.help_center_outlined),
              trailing: Icon(Icons.arrow_circle_right_outlined),
            ),

           const Divider(height: 5,color: Colors.grey,),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(onPressed: (){
                Get.defaultDialog(
                  title: "Выход",
                  titlePadding: const EdgeInsets.only(top: 20),
                  contentPadding: const EdgeInsets.all(10),
                  middleText: "Ошибка выхода",
                  confirm: TextButton(onPressed: () async{
                    await FirebaseAuth.instance.signOut();
                    Get.offAll(const LoginScreen());
                    Fluttertoast.showToast(msg: "Успешно");
                  }, child: const Text("ДА")),
                  cancel: TextButton(onPressed: (){
                    Get.back();
                  }, child: const Text("Нет")),
                );
              }, child: const Text("Выход")),
            ),
          ],
        ),
      ),

      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Задачи').where('userId', isEqualTo: user!.uid).snapshots(),
          builder: (BuildContext context, snapshot){

            if(snapshot.hasError) {
              return const Center(
                child: Text("Ошибка"),);
            }
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                child: CupertinoActivityIndicator());
            }
            if(snapshot.data !=null){
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index){
                    String status = snapshot.data!.docs[index]['status'];
                    var docId = snapshot.data!.docs[index].id;
                    return Card(
                      child: FadeInLeftBig(
                        child: ListTile(
                          title: Text(snapshot.data!.docs[index]['taskName']),
                          subtitle: status == 'Ожидание' ? Text(snapshot.data!.docs[index]['status'],style: const TextStyle(color: Colors.blueAccent),)
                              : Text(snapshot.data!.docs[index]['status'],style: const TextStyle(color: Colors.orangeAccent),),
                          leading: CircleAvatar(
                            child: Text(index.toString()),
                          ),
                          trailing: CircleAvatar(child: InkWell(
                              onTap: (){
                                Get.defaultDialog(
                                  titlePadding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                                  title: "Изменить статус задачи?", content: const Text(""),
                                  onCancel: (){},
                                  onConfirm: () async {
                                    EasyLoading.show();
                                    await FirebaseFirestore.instance.collection('Задачи').doc(docId).update({'status': 'Исполнено'},);
                                    Get.back();
                                    EasyLoading.dismiss();
                                  },
                                );
                              },
                              child: const Icon(Icons.mode_edit_outline))),
                        ),
                      ),
                    );
                  }
              );
            }
              return Container();
          },
        ),



      ),
    );
  }
}