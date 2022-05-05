
import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth_bloc.dart';
import '../../util/constants.dart';
import '../Dashboard/dashboard.dart';
import '../SignUp/sign_up.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return BlocConsumer<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthLoading) {
        // Showing the loading indicator while the user is signing in
        return  Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(255, 200, 55, 1),
                      Color.fromRGBO(255, 128, 8, 1)
                    ])), child:const Center(
          child: CircularProgressIndicator(),
        ));
      }
      if (state is UnAuthenticated || state is Registered) {
        // Showing the sign in form if the user is not authenticated
        return Container(
            decoration: const BoxDecoration(
            gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
            Color.fromRGBO(255, 200, 55, 1),
      Color.fromRGBO(255, 128, 8, 1)
      ])), child: Scaffold(
      backgroundColor: Colors.transparent, body: Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  getAssetImage(),
                  Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: _emailController,
                            style: TextStyle(color: Colors.white),
                            decoration:  InputDecoration(
                                hintText: txtEmail,
                                border: OutlineInputBorder(),
                                hintStyle: TextStyle(color: Colors.white),
                                labelStyle: TextStyle(color: Colors.white, fontSize: 16),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.amberAccent.shade100),
                                )
                            ),
                            autovalidateMode:
                            AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              return value != null &&
                                  !EmailValidator.validate(value)
                                  ?  txtEmailError
                                  : null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: _passwordController,
                            obscureText: true,
                            style: TextStyle(color: Colors.white),
                            decoration:  InputDecoration(
                                hintText: txtPassword,
                                border: OutlineInputBorder(),
                                hintStyle: TextStyle(color: Colors.white),
                                labelStyle: TextStyle(color: Colors.white, fontSize: 16),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.amberAccent.shade100),
                                )
                            ),
                            autovalidateMode:
                            AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              return value != null && value.length < 6
                                  ? txtPasswordError
                                  : null;
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          SizedBox(
                            width:
                            MediaQuery.of(context).size.width * 0.9,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.white)),
                              onPressed: () {

                                _authenticateWithEmailAndPassword(
                                    context);
                              },
                              child: Text(txtEnterLogin,
                                  style: TextStyle(
                                      color: Colors.amber.shade900,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          SizedBox(
                            width:
                            MediaQuery.of(context).size.width * 0.9,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.white)),
                              onPressed: () {
                                Navigator.pushNamed(context, '/signup');
                              },
                              child: Text(txtRegister,
                                  style: TextStyle(
                                      color: Colors.amber.shade900,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),

                        ],
                      ),
                    ),

                  )
                ],
              ),
            ),
          ),
        )));
      }
      return Container();
    }, listener: (context, state) {
      if (state is Authenticated) {
        // Navigating to the dashboard screen if the user is authenticated
        Navigator.pushReplacementNamed(context, "/dashboard", arguments: {"hasAlerts": false});
      }
      if (state is AuthError) {
        // Showing the error message if the user has entered invalid credentials
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(state.error)));
      }
    });

  }

  static Widget getAssetImage() {
    AssetImage assetImage = const AssetImage('./images/logo.png');
    Image image = Image(
      image: assetImage,
      width: 125.0,
      height: 125.0,
    );
    return Container(
      padding: const EdgeInsets.only(top: padding_20, bottom: padding_20 * 2),
      child: image,
      alignment: Alignment.center,
    );
  }

  void _authenticateWithEmailAndPassword(context) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        SignInRequested(_emailController.text, _passwordController.text),
      );
    }
  }

}
