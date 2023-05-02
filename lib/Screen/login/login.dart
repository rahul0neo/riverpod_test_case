import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_test_case/Screen/home_screen/home_screen.dart';
import 'package:riverpod_test_case/config/rest_url.dart';
import 'package:riverpod_test_case/utils/theme/app_colors.dart';
import 'package:riverpod_test_case/utils/theme/test_styles.dart';

final _hiveBox = Hive.box('testBox');

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
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.red),
              child: Text(AppLocalizations.of(context)!.logo,
                  style: AppTextStyles.logo),
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
                      child: Text("Sign Up", style: AppTextStyles.h1),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
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

        SmartDialog.showLoading(
            backDismiss: false, clickMaskDismiss: false, msg: "Please wait...");
        Response response = await Dio().post(RestUrl.loginUrl,
            data: {"username": "kminchelle", "password": "0lelplR"});
        debugPrint(
            "---------------------------------------------------------------------------");
        debugPrint("${response.data}");
        debugPrint(
            "---------------------------------------------------------------------------");
        if (response.statusCode == 200) {
          Map<String, dynamic> data = {
            "firstname": _firstname.text.trim(),
            "lastname": _lastname.text.trim(),
            "email": _email.text.trim(),
            "mobilenumber": _mobileno.text.trim(),
            "country": _country.text.trim(),
          };

          await _hiveBox.add(data);
          debugPrint('Try Again Later${_hiveBox.length}');
          SmartDialog.dismiss();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));

          _firstname.clear();
          _lastname.clear();
          _email.clear();
          _mobileno.clear();
          _country.clear();
        }

        else{
          SmartDialog.dismiss();
          debugPrint('Try Again Later');
          click = true;
        }
      }
    }
  }

  Widget ColumnView(String name,TextEditingController controller,TextInputType typeK){
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5, right: 20),
          margin: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: controller,

                keyboardType: typeK,
                textInputAction: TextInputAction.next,
                // inputFormatters: <TextInputFormatter>[
                //   FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                // ], //
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please Enter Valid $name";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                  hintText: name,
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.email_outlined),
                  prefixIconColor: AppColors.black,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 1,
                      )),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // TextFormField(
              //   validator: (value) {
              //     if (value!.isEmpty) {
              //       return 'Please enter the $name';
              //     }
              //     return null;
              //   },
              //   keyboardType: typeK,
              //   controller: controller,
              //   cursorColor: AppColors.black,
              //   style: AppTextStyles.bodyLg,
              //   decoration: InputDecoration(
              //       prefixIcon: Icon(Icons.email_outlined),
              //       prefixIconColor: AppColors.black,
              //       hintText: name,
              //       border: InputBorder.none),
              // ),
            ],
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}