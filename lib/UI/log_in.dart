import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:test_token/UI/home_page.dart';
import 'package:test_token/UI/sign_up.dart';
import 'package:test_token/bloc/request/request_bloc.dart';
import 'package:test_token/bloc/request/request_event.dart';
import 'package:test_token/bloc/request/request_state.dart';
import 'package:test_token/database/shared_preference.dart';

import '../constants/all_global_constants.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _formKey = GlobalKey<FormState>();
  bool seePassword= false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) =>
      RequestBloc()
        ..add(LogInInitialEvent()),
      child: Scaffold(
        body: BlocConsumer<RequestBloc, RequestState>(
  listener: (context, state) {
    if (state is LogInError){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.white,
            content: Text((state).errorMessage,style: buttonTextStyle,)
        ),
      );
    }
    if (state is LoggedInState){
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context)=> const HomePage()),
              (route)=>false
      );
    }


    // TODO: implement listener
  },
  builder: (context, state) {
    return SizedBox(
          width: width,
          height: height,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: width*0.9,
                  child: TextFormField(
                    validator: (val){
                      if(val!.length < 5){
                        return "invalid email length";
                      }
                      else if (!(val.contains('@') || !val.contains('.'))){
                        return "invalid email";
                      }
                      else{
                        return null;
                      }
        
                    },
                    controller: _emailController,
                    decoration: InputDecoration(
                        hintText: "email",
                        prefixIcon: const Icon(Icons.email),
                        border: textFieldDecoration.copyWith(
                            borderRadius: BorderRadius.circular(width*0.075)
                        ),
                        enabledBorder: textFieldDecoration.copyWith(
                            borderRadius: BorderRadius.circular(width*0.075)
                        )
        
                    ),
                  ),),
                SizedBox(
                  height: height*0.0125,
                ),
                SizedBox(
                  width: width*0.9,
                  child: TextFormField(
                    validator: (val){
                      if (val!.length < 5){
                        return "password must be at least 5 characters long";
                      }
                      else {
                        return null;
                      }
                    },
                    obscureText: !seePassword,
                    controller: _passwordController,
                    decoration: InputDecoration(
                        hintText: "password",
                        prefixIcon: const Icon(Icons.password),
                        suffixIcon:  IconButton(
                          icon: seePassword ? const Icon(Icons.remove_red_eye): const Icon(FontAwesomeIcons.eyeSlash),
                          onPressed: (){
                            setState(() {
                              seePassword=!seePassword;
                            });
                          },
                        ),
                        border: textFieldDecoration.copyWith(
                            borderRadius: BorderRadius.circular(width*0.075)
                        ),
                        enabledBorder: textFieldDecoration.copyWith(
                            borderRadius: BorderRadius.circular(width*0.075)
                        )
                    ),
        
                  ),
                ),
                SizedBox(
                  height: height*0.025,
                ),
                InkWell(
                  onTap: (){
                    if (_formKey.currentState!.validate()) {
                      context.read<RequestBloc>().add(LogInEvent(email: _emailController.text,
                          password: _passwordController.text
                      ));
        
        
        
                    }
        
                  },
                  child: Container(
                    width: width*0.4,
                    height: height*0.05,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(width*0.075),
                        color: Colors.amber
                    ),
                    child: const Center(
                      child: Text("Login", style: buttonTextStyle,),
                    ),
                  ),
                ),
                SizedBox(
                  height: height*0.025,
                ),
                TextButton(onPressed: (){
                  SharedPreferenceHelper().removeEmail();
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context)=> const SignUpPage()),
                          (route)=> false);
                }, child: Text("Do not have a account, Sign up ?", style: buttonTextStyle.copyWith(
                  decoration: TextDecoration.underline,
                    fontSize: 18,
                  fontWeight: FontWeight.w500
                ),))
              ],
            ),
          ),
        );
  },
),
      ),
    );
  }
}
