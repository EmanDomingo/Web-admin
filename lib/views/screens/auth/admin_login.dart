
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rental_app_web_admin/views/screens/auth/admin_register.dart';
import 'package:rental_app_web_admin/views/screens/controllers/admin_auth_controller.dart';
import 'package:rental_app_web_admin/views/screens/main_screen.dart';
import 'package:rental_app_web_admin/views/screens/utils/show_snackBar.dart';

class AdminLogin extends StatefulWidget {
  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AdminAuthController _adminauthController = AdminAuthController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String Email;

  late String Password;

  bool _isLoading = false;

  _adminloginUsers () async {
    
    if (_formKey.currentState!.validate()) {
      String res = await _adminauthController.adminLoginUsers(Email, Password);

      if (res == 'success') {
      return Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return MainScreen();
      }));

      } else {
        return showSnack(context, res);
      }
    }
  }

  //   } else {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     return showSnack(context, 'Please fields most not be emty');
  //   }
  // }


  // _loginUsers () async {
  //   setState(() {
  //     _isLoading = true;
  //   });
    
  //   if (_formKey.currentState!.validate()) {
  //     await _authController
  //     .LoginUsers(email, password);
  //     return Navigator.pushReplacement(context,
  //         MaterialPageRoute(builder: (BuildContext context) {
  //       return MainScreen();
  //     }));

  //     // } else {

  //     //   return showSnack(context, res);
  //     // }
  //     //return showSnack(context, 'You Are Now Logged In');
  //   } else {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     return showSnack(context, 'Please fields most not be emty');
  //   }
  // }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color.fromARGB(255, 107, 174, 230),Color.fromARGB(255, 255, 255, 255),Color.fromARGB(255, 107, 174, 230),], // Add your gradient colors here
          ),
        ),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                        'assets/image/rentop0.png', // Replace with your image path
                        height: 150, // Adjust the height as needed
                        width: 150, // Adjust the width as needed
                      ),
                      Text(
                      'Login Account',
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email address';
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          Email = value;
                        },
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: TextFormField(
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your password';
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          Password = value;
                        },
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _adminloginUsers,
                      child: _isLoading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              'Login',
                              style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                            ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        )),
                      ),
                    ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return AdminRegister();
                          }));
                        },
                        child: Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
                        ),
            ),
            ),
        ),
      );
  }
}
