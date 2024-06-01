import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mybook/dialog/error_dialog.dart';
import 'package:mybook/screens/register.dart';
import 'package:mybook/screens/post_book_screen.dart';
import 'package:mybook/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool checkSpinner = false;
  String? email;
  String? password;
  bool passwordvisible = false;
  final auth=FirebaseAuth.instance;

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
                        padding: const EdgeInsets.only(
                            left: 28, top: 30, right: 28, bottom: 30),
                        decoration: const BoxDecoration(
                            color: Color(0xFFffffff),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40))),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome Back",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 30,
                                  color: Color(0xFFffffff)),
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 14),
                                child: Text(
                                  "Login to your account",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Color(0xFFffffff)),
                                )),
                            Padding(
                              padding: EdgeInsets.only(top: 31),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "email".toUpperCase(),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.0),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25.0)),
                                      child: TextFormField(
                                        textAlign: TextAlign.start,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          hintText: "abc@gmail.com",
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.00),
                                              borderSide: BorderSide(
                                                  color: Color(0xFF6c8f92a1),
                                                  width: 1)),
                                          hintStyle: GoogleFonts.inter(
                                            color: Color(0xFF338f92a1),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            height: 1.21,
                                          ),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            email = value;
                                          });
                                        },
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(top: 31),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "password".toUpperCase(),
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 1.0),
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25.0)),
                                                child: TextFormField(
                                                  textAlign: TextAlign.start,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  obscureText: !passwordvisible,
                                                  decoration: InputDecoration(
                                                      hintText: "Password@123",
                                                      suffixIcon:
                                                          GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            passwordvisible =
                                                                !passwordvisible;
                                                          });
                                                        },
                                                        child: Icon(
                                                          passwordvisible
                                                              ? Icons.visibility
                                                              : Icons
                                                                  .visibility_off,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.00),
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xFF6c8f92a1),
                                                              width: 1)),
                                                      hintStyle:
                                                          GoogleFonts.inter(
                                                        color:
                                                            Color(0xFF338f92a1),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        height: 1.21,
                                                      )),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      password = value;
                                                    });
                                                  },
                                                ),
                                              )
                                            ])),
                                    SizedBox(
                                      height: 40,
                                    ),
                                    SizedBox(
                                      width: 280,
                                      height: 60,
                                      child: ElevatedButton(
                                          onPressed: () async{
                                            setState(() {
                                              checkSpinner=true;
                                            });
                                            try{
                                              if(email==null && password==null)
                                              {
                                                setState(() {
                                                  checkSpinner=false;
                                                });

                                                showDialog(
                                                  context: context, 
                                                  builder: (c){
                                                    return ErrorDialog(
                                                      message: "Tolong Masukkan Email dan password yang benar",
                                                    );
                                                  }
                                                  );
                                              }
                                              else
                                              {
                                                final userCredential= await auth.signInWithEmailAndPassword(
                                                  email: email!.trim(), password: password!.trim());
                                                final user=userCredential.user;
                                                if(user!=null)
                                                {

                                                  if(user.email=="admin@gmail.com")
                                                  {
                                                    Navigator.push(context, MaterialPageRoute(builder: (context) =>PostBookScreen()));
                                                  }
                                                  else{
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) =>HomeScreen()));
                                                  }
                                                }
                                                else
                                                {
                                                  showDialog(
                                                    context: context, builder: (c){
                                                      return ErrorDialog(
                                                        message: "Email Ini Tidak Terdaftar!",
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
                                                context: context, 
                                                builder: (c){
                                                  return ErrorDialog(
                                                    message: "Gagal Login",
                                                  );
                                                }
                                                );
                                                print(e);
                                            }
                                          },
                                          child: Text(
                                            'Login',
                                            style: GoogleFonts.inter(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w700,
                                                height: 1.21,
                                                color: Colors.white),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          39.00)),
                                              backgroundColor:
                                                  Color(0xFF666aec))),
                                    ),
                                    SizedBox(
                                      height: 42,
                                    ),
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Belum Punya Akun?',
                                            style: GoogleFonts.inter(
                                                color: Colors.grey.shade600,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(context,MaterialPageRoute(builder: (context) => RegisterScreen(),));
                                            },
                                            child: Text(
                                              'Sign Up',
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  decoration:
                                                      TextDecoration.underline),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ]),
                            ),
                          ],
                        )),
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
