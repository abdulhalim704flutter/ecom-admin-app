import 'package:ecom_admin/auth/auth_service.dart';
import 'package:ecom_admin/pages/dashboard_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isObscureText = true;
  String errorMsg = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 4.0),
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: 'Email address',
                      prefixIcon: const Icon(Icons.email)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'this feild must not be empty!';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 4.0),
                child: TextFormField(
                  obscureText: isObscureText,
                  controller: _passController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isObscureText = !isObscureText;
                          });
                        },
                        icon: Icon(isObscureText
                            ? Icons.visibility_off
                            : Icons.visibility),
                      )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'this feild must not be empty!';
                    }
                    return null;
                  },
                ),
              ),
              ElevatedButton(onPressed: _loginAdmin, child: Text('Save')),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(errorMsg,style: const TextStyle(fontSize: 16,color: Colors.red),),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loginAdmin() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passController.text;
      EasyLoading.show(status: 'Plase wait');
      try {
        final status = await AuthService.loginAdmin(email, password);
        EasyLoading.dismiss();
        if(status){
          Navigator.pushReplacementNamed(context, DashboardScrren.routeName);
        }else{
          await AuthService.logout();
          setState(() {
            errorMsg = 'You are not an Admin!';
          });
        }
      } on FirebaseAuthException catch (error) {
        EasyLoading.dismiss();
        errorMsg = error.message!;
      }
    }
  }
}
