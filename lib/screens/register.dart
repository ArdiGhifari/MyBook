import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mybook/screens/home_screen.dart';
import 'package:mybook/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mybook/dialog/error_dialog.dart';
import 'package:mybook/screens/mybook.dart';
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final _auth=FirebaseAuth.instance;
  bool checkSpinner = false;
  String? email;
  String? password;
  bool passwordvisible = false;

  reset(){
    setState(() {
      email=null;
      password=null;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFffffff),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: ModalProgressHUD(
          inAsyncCall: checkSpinner,
          child: Center(
            child: SizedBox(

              height: MediaQuery.of(context).size.height,
              width: double.maxFinite,
              child: Stack(

                children: [
                  Image.asset(
                    'images/banner-jurusan.jpg',
                    fit: BoxFit.cover,
                    height: 287,
                    width: double.infinity,
                    alignment: Alignment.topCenter,
                  ),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.only(
                        left: 28, top: 30, right: 28, bottom: 30
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFffffff),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(48),
                          topRight: Radius.circular(40)
                        )
                      ),

                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Create Account",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 38,
                            color: Color.fromARGB(255, 100, 47, 47)
                          ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(top: 31),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("email".toLowerCase(),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.0
                                ),
                                ),
                                SizedBox(height: 12,),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25.0)
                                  ),
                                  child: TextFormField(

                                    textAlign: TextAlign.start,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      hintText: "abc@gmail.com",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8.00),
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(95, 130, 105, 197),
                                          width: 1
                                        )
                                      ),
                                      hintStyle: GoogleFonts.inter(
                                        color: Color.fromARGB(255, 151, 55, 55),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        height: 1.21,

                                      )
                                    ),
                                    onChanged: (value){
                                      setState(() {
                                        email=value;
                                      });
                                    },
                                  ),
                                )
                              ]
                            )
                            ),

                            Padding(
                              padding: EdgeInsets.only(top: 31),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Password".toUpperCase(),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.0
                                  ),
                                  ),
                                  SizedBox(height: 12,),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25.0)
                                    ),
                                    child: TextFormField(

                                      textAlign: TextAlign.start,
                                      keyboardType: TextInputType.emailAddress,

                                      decoration: InputDecoration(
                                        hintText: "Password@123",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.08),
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(255, 241, 239, 239),
                                            width: 1
                                          )
                                        ),
                                        hintStyle: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          height: 1.21,
                                        )
                                      ),
                                      onChanged: (value){
                                        setState(() {
                                          password=value;
                                        });
                                      },
                                    ),
                                  )

                                ]
                              )
                            ),
                            SizedBox(
                              height: 40,

                            ),
                            SizedBox(
                              width: 280,
                              height: 68,
                              child: ElevatedButton(
                                onPressed: ()async{
                                  setState(() {
                                    checkSpinner=true;
                                  });
                                  try{
                                    if(email==null && password==null)
                                  {
                                    setState((){
                                      checkSpinner=false;
                                    });
                                    showDialog(
                                     context: context,
                                     builder: (c){
                                      return ErrorDialog(
                                        message: "Tolong Masukkan email dan password",
                                      );
                                      
                                     }
                                     );
                                  }
                                else{
                                  final newUser= await _auth.createUserWithEmailAndPassword(
                                    email: email!.trim(), password: password!.trim());

                                  if(newUser!=null)
                                  {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                                    reset();
                                  }
                                  else
                                  {
                                    showDialog(
                                      context: context, 
                                      builder: (c){
                                        return ErrorDialog(
                                          message: "Siap Regist",
                                        );
                                      }
                                      );
                                  }

                                  setState(() {
                                    checkSpinner=false;
                                  });
                                }
                                }
                                catch(e){
                                  setState(() {
                                    checkSpinner=false;
                                  });

                                  showDialog(
                                    context: context, builder: (e){
                                      return ErrorDialog(
                                        message:e.toString().split("]")[1].trim(),
                                      );
                                    }
                                    );
                                    print(e);
                                }  
                                },
                                 child: Text(
                                  'Create Account',
                                  style: GoogleFonts.inter(
                                    fontSize: 17,
                                    fontWeight: FontWeight.normal,
                                    height: 1.21,
                                    color: Colors.blue,
                                  ),
                                 ),
                                 style: ElevatedButton.styleFrom(

                                 ),
                                ),
                            ),
                            SizedBox(height: 42,),

                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Sudah Punya Akun?',
                                  style:GoogleFonts.inter(
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14
                                  ),),
                                  SizedBox(width: 5,),
                                  InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
                                    },
                                    child: Text(
                                      'Log in',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline
                                      ),
                                    ),
                                  )
                                ],
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
        ),
      ),
    );
  }
}