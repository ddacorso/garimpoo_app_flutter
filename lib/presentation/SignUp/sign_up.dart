import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth_bloc.dart';
import '../../util/constants.dart';
import '../Dashboard/dashboard.dart';
import '../SignIn/sign_in.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  @override
  void dispose() {
     _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>( listener:  (context, state) {
      log((state is Registered).toString());
      if (state is Registered) {
        Navigator.of(context).pop();
      }
      if (state is AuthError) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(state.error)));
      }
    }, builder: (context, state) {
      if (state is AuthLoading ) {
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
      if (state is UnAuthenticated) {
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
      backgroundColor: Colors.transparent, body : Center(
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
                            controller: _usernameController,
                            style: TextStyle(color: Colors.white),
                            decoration:  InputDecoration(
                                hintText: txtUsername,
                                border: UnderlineInputBorder(),
                                hintStyle: TextStyle(color: Colors.white),
                                labelStyle: TextStyle(color: Colors.white, fontSize: 16),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.amberAccent.shade100),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.amberAccent.shade100),
                                )
                            ),
                            autovalidateMode:
                            AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              return value != null && value.isEmpty
                                  ? txtUsernameError
                                  : null;
                            },
                          ),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: _emailController,
                            style: TextStyle(color: Colors.white),
                            decoration:  InputDecoration(
                                hintText: txtEmail,
                                border: UnderlineInputBorder(),
                                hintStyle: TextStyle(color: Colors.white),
                                labelStyle: TextStyle(color: Colors.white, fontSize: 16),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.amberAccent.shade100),
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
                                  ? txtEmailError
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
                                border: UnderlineInputBorder(),
                                hintStyle: TextStyle(color: Colors.white),
                                labelStyle: TextStyle(color: Colors.white, fontSize: 16),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.amberAccent.shade100),
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

                                _createAccountWithEmailAndPassword(
                                    context);
                              },
                              child: Text(txtRegister,
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
                                Navigator.of(context).pushNamed("/signin");
                              },
                              child: Text(txtBack,
                                  style: TextStyle(
                                      color: Colors.amber.shade900,
                                      fontWeight: FontWeight.bold)),
                            ),
                          )
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

  void _createAccountWithEmailAndPassword(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        SignUpRequested(
          _usernameController.text,
          _emailController.text,
          _passwordController.text,
        ),
      );
    }
  }

}
