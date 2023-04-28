import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_test_case/commons/databasehelper.dart';
import 'package:riverpod_test_case/Screen/homescreen.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  bool click = true;

  final loginFormKey = GlobalKey<FormState>();
  TextEditingController _firstname = TextEditingController();
  TextEditingController _lastname = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _mobileno = TextEditingController();
  TextEditingController _country = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Container(
              alignment: Alignment.center,
              width: 120,
              height: 120,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
              child: TextView("Neo", 24.0, FontWeight.w800, Colors.white),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.09),
            Form(
              key: loginFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   ColumnView('First Name',_firstname,TextInputType.text),
                   ColumnView('Last Name ',_lastname,TextInputType.text),
                   ColumnView('Email',_email,TextInputType.text),
                   ColumnView('Phone Number',_mobileno,TextInputType.number),
                   ColumnView('Country',_country,TextInputType.text),
                  InkWell(
                    onTap: () => onClick(context),
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.symmetric(horizontal: 25),
                      decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(25)),
                      child: TextView("Sign Up", 16.0, FontWeight.w600, Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  onClick(BuildContext context) async {

    if (!loginFormKey.currentState!.validate()){
      return;
    }else{
      if(click){
        click = false;
        Response response = await Dio().get("https://jsonplaceholder.typicode.com/posts");
        if(response.statusCode==200){
          Map<String, dynamic> data = {
            "firstname": _firstname.text.trim(),
            "lastname": _lastname.text.trim(),
            "email": _email.text.trim(),
            "mobilenumber": _mobileno.text.trim(),
            "country": _country.text.trim(),
          };

          int check=await DatabaseHelper().saveReg(data);
          if(check==-1||check==0){
            debugPrint('Try Again Later');
            click=true;
          }else{
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );

            _firstname.clear();
            _lastname.clear();
            _email.clear();
            _mobileno.clear();
            _country.clear();
          }

        }

        else{
          debugPrint('Try Again Later');
          click=true;
        }
      }


    }
  }

  Widget TextView(String txt, var size, var font,var color_type) {
    return Text(
      txt,
      textAlign: TextAlign.center,
      style: TextStyle(color: color_type, fontSize: size, fontWeight: font),
    );
  }

  Widget ColumnView(String name,TextEditingController controller,TextInputType typeK){
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5, right: 20),
          margin: EdgeInsets.symmetric(horizontal: 25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.03),
                spreadRadius: 10,
                blurRadius: 3,
                // changes position of shadow
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the $name';
                  }
                  return null;
                },
                keyboardType: typeK,
                controller: controller,
                cursorColor: Color(0xFF000000),
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF000000)),
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined),
                    prefixIconColor: Color(0xFF000000),
                    hintText: name,
                    border: InputBorder.none),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}


