import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

import 'chatRoomsScreen.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  TextEditingController userNameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  signMeUp() {
    final form = _formKey.currentState!;
    if(form.validate()){

      Map<String, Object> userInfoMap = {
        'name' : userNameTextEditingController.text,
        'email' : emailTextEditingController.text
      };

      setState(() {
        isLoading = true;
      });

      authMethods.signUpwithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text).then((val) {
        //print("${val.uid}");

        databaseMethods.uploadUserInfo(userInfoMap);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatRoom()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading ? Container(
        child: Center(child: CircularProgressIndicator()),
      ) : SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      /// Username
                      TextFormField(
                        validator: (val){
                          if(val == null || val.isEmpty || val.length < 2) {
                            return 'Please Provide Username';
                          }
                          return null;
                        },
                          controller: userNameTextEditingController,
                          style: simpleTextStyle(),
                          decoration: textFieldInputDecoration("username")
                      ),
                      /// Email
                      TextFormField(
                          validator: (val){
                            return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val!) ?
                            null : "Enter correct email";
                          },
                          controller: emailTextEditingController,
                          style: simpleTextStyle(),
                          decoration: textFieldInputDecoration("email")
                      ),
                      /// Password
                      TextFormField(
                        obscureText: true,
                          validator: (val){
                            if(val == null || val.isEmpty || val.length < 8) {
                              return 'Please Provide password with 8+ characters';
                            }
                            return null;
                          },
                          controller: passwordTextEditingController,
                          style: simpleTextStyle(),
                          decoration: textFieldInputDecoration("password")
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8,),
                /// Forgot Password Container
                Container(
                  alignment: Alignment.centerRight,
                  child: Container (
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text("Forgot Password?", style: simpleTextStyle(),),
                  ),
                ),
                SizedBox(height: 8,),
                /// Sign Up Button
                GestureDetector(
                  onTap: (){
                    signMeUp();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              const Color(0xff007EF4),
                              const Color(0xff2A75BC)
                            ]
                        ),
                        borderRadius: BorderRadius.circular(30)
                    ),
                    child: Text("Sign Up", style: mediumTextStyle()),
                  ),
                ),
                SizedBox(height: 16,),
                /// Sign Up with Google Button
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: Text("Sign Up with Google", style: TextStyle(
                      color: Colors.black87,
                      fontSize: 17
                  ),),
                ),
                SizedBox(height: 16,),
                /// Already have an account container/row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? ", style: mediumTextStyle(),),
                    GestureDetector(
                      onTap: (){
                        widget.toggle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text("SignIn now", style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          decoration: TextDecoration.underline,
                        ),),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 50,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
