import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:test_token/UI/log_in.dart';
import 'package:test_token/bloc/request/request_bloc.dart';
import 'package:test_token/bloc/request/request_event.dart';
import 'package:test_token/bloc/request/request_state.dart';
import 'package:test_token/constants/all_global_constants.dart';
import 'package:test_token/constants/constant_class.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _reEnterPasswordController = TextEditingController();
  bool seePassword = false;
  bool seeRepeatPassword = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return  BlocProvider(
  create: (context) => RequestBloc()..add(AlreadySignedUpEvent()),
  child: Scaffold(
      body: BlocConsumer<RequestBloc, RequestState>(
  listener: (context, state) {
    if (state is SignUpError){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          content: Text((state).errorMessage,style: buttonTextStyle,)
      ),
      );
    }
    if (state is SignedUpState){
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context)=> const LogIn()),
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
                      if(val!.length < 3){
                        return ConstantClass.userNameLengthError;
                      }
                      else{
                        return null;
                      }

                    },
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: ConstantClass.userNameHeader,
                      prefixIcon: const Icon(Icons.person),
                      border: textFieldDecoration.copyWith(
                        borderRadius: BorderRadius.circular(width*0.075)
                      ),
                      enabledBorder: textFieldDecoration.copyWith(
                          borderRadius: BorderRadius.circular(width*0.075)
                      )

                    ),
                  )
              ),
              SizedBox(
                height: height*0.0125,
              ),

              SizedBox(
                width: width*0.9,
                  child: TextFormField(
                    validator: (val){
                      if(val!.length < 5){
                        return ConstantClass.emailLengthError;
                      }
                      else if (!(val.contains('@') || !val.contains('.'))){
                        return ConstantClass.invalidEmailError;
                      }
                      else{
                        return null;
                      }

                    },
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: ConstantClass.emailHeader,
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
                      return ConstantClass.passwordLengthError;
                    }
                    else {
                      return null;
                    }
                  },
                  obscureText: !seePassword,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: ConstantClass.passwordHeader,
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
                height: height*0.0125,
              ),
              SizedBox(
                  width: width*0.9,
                  child: TextFormField(
                    obscureText: !seeRepeatPassword,
                    validator: (val){
                      if (val! != _passwordController.text){
                        return ConstantClass.passwordUnmatchedError;
                      }
                      else {
                        return null;
                      }
                    },
                    controller: _reEnterPasswordController,
                    decoration: InputDecoration(
                      hintText: ConstantClass.repeatPasswordHead,
                        prefixIcon: const Icon(Icons.password),
                        suffixIcon:  IconButton(
                          icon: seeRepeatPassword ? const Icon(Icons.remove_red_eye): const Icon(FontAwesomeIcons.eyeSlash),
                          onPressed: (){
                            setState(() {
                              seeRepeatPassword=!seeRepeatPassword;
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
                    context.read<RequestBloc>().add(SignUpEvent(
                        userName: _usernameController.text,
                        email: _emailController.text,
                        password: _passwordController.text,
                        newPassword: _reEnterPasswordController.text
                    ),
                    );
                    
      
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
                    child: Text(ConstantClass.signUpButton, style: buttonTextStyle,),
                  ),
                ),
              ),
              SizedBox(
                height: height*0.025,
              ),
              TextButton(onPressed: (){
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context)=> const LogIn()),
                    (route)=> false);
              }, child: Text(ConstantClass.login, style: buttonTextStyle.copyWith(
                fontSize: 18
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
