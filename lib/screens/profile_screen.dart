import 'package:flutter/material.dart';
import 'package:mybook/constant.dart';
import 'package:mybook/screens/favorite_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
   final user=FirebaseAuth.instance.currentUser;
  String? username;
  String? userinitial;
  
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async{

        print('Hello');
        widget.callback!();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          elevation: 0.0,
          backgroundColor: Colors.indigo,
        ),
        backgroundColor: Colors.yellow,
        body: SingleChildScrollView(
          child: Column(

            children: [
              Container(
                height: 300,
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                color: Colors.indigo,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(7.0),
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2.0
                        )
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Center(
                          child: Text(
                            userinitial!,
                            style: TextStyle(color: Colors.black,fontSize: 98, fontWeight: FontWeight.w600),
                          ),
                        ),

                      ),
                    ),
                    SizedBox(height: 40,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        username!,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      ),
                      )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Text(
                    'Your Books',
                    style: HeadingTextstyle.copyWith(fontSize: 23),
                  ),
                ),
              ),
               FavoriteScreen()
            ],
          ),
        ),
      ),
    );
  }
}