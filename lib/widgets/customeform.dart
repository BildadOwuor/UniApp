// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:uniapp/Providers/authservice.dart';

class CustomForm extends StatefulWidget {
  CustomForm({super.key});
  late bool isLoading = false;

  @override
  CustomFormState createState() {
    return CustomFormState();
  }
}

class CustomFormState extends State<CustomForm> {
  // ignore: unused_field
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailcontroler = TextEditingController();
  final TextEditingController passwordcontroler = TextEditingController();

  late bool isLoading = false;

  String? get _errorText {
    final mailtext = emailcontroler.text;
    final passtext = passwordcontroler.text;
    if (passtext == '' || mailtext == '') {
      return 'can\'t be empty';
    } else if (passtext.length < 6) {
      return 'Password is too short';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Card(
            color: Colors.white10,
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            elevation: 0,
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Neumorphic(
                    child: TextFormField(
                      validator: (value) => _errorText,
                      controller: emailcontroler,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        labelText: "Email",
                        icon: Icon(Icons.email_sharp),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Neumorphic(
                    child: TextFormField(
                      obscureText: true,
                      validator: (value) => _errorText,
                      controller: passwordcontroler,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        labelText: "Password",
                        icon: Icon(Icons.key_sharp),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          NeumorphicButton(
            style: NeumorphicStyle(
              color: Colors.green,
              shape: NeumorphicShape.concave,
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
            ),
            onPressed: () async {
              setState(() {
                isLoading = true;
              });

              await Future.delayed(const Duration(seconds: 6), () {
                setState(() {
                  isLoading = !isLoading;
                });
                context.read<AuthenticationService>().signIn(
                      email: emailcontroler.text.trim(),
                      password: passwordcontroler.text.trim(),
                    );
              });
            },
            child: isLoading
                ? SizedBox(
                    width: 30,
                    height: 50,
                    child: JumpingDotsProgressIndicator(
                      fontSize: 20.0,
                      numberOfDots: 4,
                      dotSpacing: 2,
                      milliseconds: 3000,
                      color: Colors.white,
                    ),
                  )
                : Text('LogIn'.toUpperCase()),
          )
        ],
      ),
    );
  }
}
