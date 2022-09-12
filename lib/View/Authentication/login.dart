import 'package:express_attendance/My%20widgets/MyCupertinoButton.dart';
import 'package:express_attendance/My%20widgets/MyTextField.dart';
import 'package:express_attendance/Provider/UserCredentialsProvider/user_credentials.dart';
import 'package:express_attendance/Services/ApiServices/StorageServices/get_storage.dart';
import 'package:express_attendance/View/Employee%20Attendance/employee_attendance_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late UserCredentialsProvider userProv;

  bool showVisibilty = true;
  bool rememberMe = false;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    userProv = Provider.of<UserCredentialsProvider>(context, listen: false);
    super.initState();
  }

  Widget build(BuildContext context) {
    final s = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                ),
                Center(
                    child: Text(
                  "Attendance App Login",
                  style: TextStyle(
                      fontSize: 31, color: HexColor("#2196F3"), fontWeight: FontWeight.bold),
                )),
                SizedBox(
                  height: 40,
                ),
                MyTextField(
                    hintTxt: "Enter your Email",
                    textEditingController: userProv.emailController,
                    mxLine: 1,
                    heigtContainer: 50,
                    IconRight: Icon(Icons.email_outlined),
                    onValidate: (v) {
                      if (v!.isEmpty)
                        return "Required";
                      else if (!v.isEmail) return "Please Enter Valid Email";

                      return null;
                    }),
                SizedBox(
                  height: 30,
                ),
                MyTextField(
                    hintTxt: "Enter your Password",
                    textEditingController: userProv.passwordController,
                    mxLine: 1,
                    heigtContainer: 50,
                    IconRight: IconButton(
                      onPressed: () {
                        setState(() {
                          showVisibilty = !showVisibilty;
                        });
                      },
                      icon: Icon(
                        showVisibilty ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                    obscuretxt: showVisibilty,
                    onValidate: (v) {
                      if (v!.isEmpty) return "Required";

                      return null;
                    }),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Checkbox(
                      value: rememberMe,
                      onChanged: (bool? value) {
                        setState(() {
                          rememberMe = !rememberMe;
                        });
                      },
                    ),
                    SizedBox(width: 10),
                    Text("Remember me",
                        style: TextStyle(color: HexColor("#2196F3"), fontWeight: FontWeight.bold))
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                MyCupertinoButton(
                    text: "Login",
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        bool result = await userProv.verifiedUser();
                        await StorageCRUD.box.write(StorageKeys.remember, rememberMe);
                        if (!result) return;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EmployeeMainScreen(),
                          ),
                        );
                      }
                    },
                    width: s.width * 0.8,
                    textSize: 25,
                    padding: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
