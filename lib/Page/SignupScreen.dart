import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:business_tasks_app/Services/SignupServices.dart';
import 'package:business_tasks_app/utils/constants.dart';
import 'LoginScreen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  TextEditingController userNameController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppConstants.appName,),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: 250,
                width: 250,
                child: Lottie.asset('assets/Welcome.json',
                  fit: BoxFit.cover,
                ),
              ),

              FadeInLeft(
                duration: const Duration(milliseconds: 1000),
                child: TextFormField(
                  controller: userNameController,
                  decoration: InputDecoration(
                      hintText: "Имя пользователя",
                      labelText: "Имя пользователя",
                      prefixIcon: const Icon(Icons.person_2_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )

                  ),
                ),
              ),

              const SizedBox(height: 10,),

              FadeInLeft(
                duration: const Duration(milliseconds: 1000),
                child: TextFormField(
                  controller: userEmailController,
                  decoration: InputDecoration(
                      hintText: "e-mail",
                      labelText: "e-mail",
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )

                  ),
                ),
              ),

              const SizedBox(height: 10,),

              FadeInLeft(
                duration: const Duration(milliseconds: 1000),
                child: TextFormField(
                  controller: userPasswordController,
                  obscureText: obscureText,
                  decoration: InputDecoration(
                      hintText: "Пароль",
                      labelText: "Пароль",
                      prefixIcon: const Icon(Icons.password_outlined),
                      suffixIcon: GestureDetector(
                          onTap: (){
                            setState(() {
                              obscureText = ! obscureText;
                            });
                          },
                          child: obscureText? const Icon(Icons.visibility_outlined) : const Icon(Icons.visibility_off_outlined)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )

                  ),
                ),
              ),

              const SizedBox(height: 10,),

              FadeInUp(
                  duration: const Duration(milliseconds: 1000),
                  child: ElevatedButton(onPressed: () async {
                    var userName = userNameController.text.trim();
                    var userEmail = userEmailController.text.trim();
                    var userPassword  = userPasswordController.text.trim();
                    EasyLoading.show();

                    if(userName.isEmpty || userEmail.isEmpty || userPassword.isEmpty)
                    {
                      Fluttertoast.showToast(msg: 'Не заполнены все обязательные поля');
                      EasyLoading.dismiss();
                    }
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: userEmail, password: userPassword).then((value) =>  {
                      signUpUser(userName, userEmail, userPassword),
                    });
                    Get.offAll(const LoginScreen());
                    EasyLoading.dismiss();
                    Fluttertoast.showToast(msg: "Регистрация завершена!");
                  }, child: const Text(' Зарегистрироваться '))),

              const SizedBox(height: 30,),

              GestureDetector(
                onTap: (){
                  Get.to(const LoginScreen());
                },
                child: FadeInUp(
                    duration: const Duration(milliseconds: 1000),
                    child: const Card(child: Text('Данный логин уже занят', style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),))),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
