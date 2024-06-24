import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:test_token/UI/log_in.dart';
import 'package:test_token/bloc/request/request_bloc.dart';
import 'package:test_token/bloc/request/request_event.dart';
import 'package:test_token/bloc/request/request_state.dart';
import 'package:test_token/database/shared_preference.dart';

import '../constants/all_global_constants.dart';
import '../constants/constant_class.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => RequestBloc(),
      child: Scaffold(
        body: BlocConsumer<RequestBloc, RequestState>(
          listener: (context, state) {
            // when already signed up, navigate to login page
            if(state is SignUpState){
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context)=> const LogIn()), (route)=> false);
            }
            // view snack bar to show if it has valid token
            if (state is TokenValidState){
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    backgroundColor: Colors.white,
                    content: Text(ConstantClass.validToken,style: buttonTextStyle,)
                ),
              );
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,

              children: [
                Padding(padding:EdgeInsets.fromLTRB(0, height*0.05, width*0.025, 0),
                  child: IconButton(
                    onPressed: (){
                      SharedPreferenceHelper().removeToken();
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context)=> const LogIn()),
                          (route)=>false
                      );
                    },
                    icon: const Icon(FontAwesomeIcons.arrowRightFromBracket, color: Colors.black, size: 30,),
                  ),

                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      width*0.2,
                      height*0.3,
                      width*0.2,
                      0
                  ),
                  child: Center(
                    child: InkWell(
                      onTap: (){
                        context.read<RequestBloc>().add(CheckTokenRequestEvent());
                      },
                      child: Container(
                        width: width*0.6,
                        height: height*0.085,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(width*0.075),
                            color: Colors.amber
                        ),
                        child: const Center(
                          child: Text(ConstantClass.checkTokenButton, style: buttonTextStyle),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
