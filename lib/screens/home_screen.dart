import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mybook/screens/login.dart';
import 'package:mybook/screens/profile_screen.dart';
import 'package:mybook/constant.dart';
import 'package:mybook/screens/popular_screen.dart';
import 'package:mybook/screens/newest_screen.dart';
import 'package:mybook/screens/category_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user=FirebaseAuth.instance.currentUser;
String? username;
String? userinitial;

  final GlobalKey<ScaffoldState> _scaffoldkey=GlobalKey<ScaffoldState>();

  void openDrawer(){
    _scaffoldkey.currentState?.openDrawer();
  }

  void refreshstream(){
    Navigator.pop(context);
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context)=> HomeScreen()),
    );
  }

  @override
  void initState(){
    username=user!.email;
    userinitial=username!.isNotEmpty?username![0].toUpperCase():"Un";
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: Color(0xFFF5F5F3),
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade700,
        title: Text('My Book',
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white
        ),
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: openDrawer,
          child: Container(
            margin: EdgeInsets.all(9.0),

            child: Icon(Icons.menu,color: Colors.white,size: 28,),
          ),
        ),
        actions: [

          SizedBox(width: 12,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(callback:refreshstream),));
              },
              child: Container(
                padding: EdgeInsets.all(1.0),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2.0
                  )
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.indigo,
                  child: Center(
                    child: Text(
                      userinitial!,

                      style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold  ),
                    ),
                  ),
                ),
              ),
            ),
            )
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 28,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
              child: Text(
                'Popular Books',
                style: HeadingTextstyle.copyWith(
                   decoration: TextDecoration.underline
              ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(7.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.indigo[50],
                  borderRadius: BorderRadius.circular(12.0)
                ),
                child: PopularBooks()
              ),
            ),
            SizedBox(height: 13,),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text("Newest",
                style: HeadingTextstyle.copyWith(
                  decoration: TextDecoration.underline
                ),
              ),
            ),
              SizedBox(height: 5,),
               Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Container(
                    decoration: BoxDecoration(

                      borderRadius: BorderRadius.circular(12.0)
                    ),
                    child: Container(
                    child: Newest()),
                ),
              )  
          ],
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.indigo[50],
      child: ListView(
        padding: EdgeInsets.zero,

        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.indigo.shade700
            ),
            child: Icon(
              Icons.person,
              size: 50,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 50,),
          ListTile(
            leading: Icon(
              Icons.theater_comedy,
            ),
            title: Text('Comedy',style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
              fontSize: 16
            ),),
            onTap: (){
              Navigator.push(context,MaterialPageRoute(builder: (context) => Categories(category: 'Comedy'),));
            },
          ),
          Divider(height: 3.0,color: Colors.black,),
          ListTile(
            leading: Icon(
              Icons.card_giftcard,
            ),
            title: Text('Lifestyle',style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
              fontSize: 16
            ),),
            onTap: (){
              Navigator.push(context,MaterialPageRoute(builder: (context) => Categories(category: 'Lifestyle'),));
            },
          ),
           Divider(height: 3.0,color: Colors.black,),
            ListTile(
            leading: Icon(
              Icons.sports,
            ),
            title: Text('Sport',style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
              fontSize: 16
            ),),
            onTap: (){
              Navigator.push(context,MaterialPageRoute(builder: (context) => Categories(category: 'Sport'),));
            },
          ),
           Divider(height: 3.0,color: Colors.black,),
            ListTile(
            leading: Icon(
              Icons.movie,
            ),
            title: Text('Thriller',style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
              fontSize: 16
            ),),
            onTap: (){
              Navigator.push(context,MaterialPageRoute(builder: (context) => Categories(category: 'Thriller'),));
            },
          ),
           Divider(height: 3.0,color: Colors.black,),
            ListTile(
            leading: Icon(
              Icons.local_movies_rounded,
            ),
            title: Text('Mystery',style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
              fontSize: 16
            ),),
            onTap: (){
              Navigator.push(context,MaterialPageRoute(builder: (context) => Categories(category: 'Mystery'),));
            },
          ),
          Divider(height: 3.0,color: Colors.black,),
            ListTile(
            leading: Icon(
              Icons.logout,
            ),
            title: Text('Logout',style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
              fontSize: 16
            ),),
            onTap: ()async{
              try{
                await FirebaseAuth.instance.signOut();
                Navigator.push(context,MaterialPageRoute(builder: (context)=>LoginScreen()));
                 print("User Sign out");
              }
              catch(e){
                print("Error Sign out");
              }
            },
          ),
          Divider(height: 3.0,color: Colors.black,),
        ],
      ),
    );
  }
}