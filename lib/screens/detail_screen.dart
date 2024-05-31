import 'dart:ui';

import 'package:mybook/screens/favorite_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DetailScreen extends StatefulWidget {

  final String author;
  final String link;
  final String booktitle;
  final double bookrating;
  final String rating;
  final String description;
  final String id;
  final List<dynamic> bookmarks;
  
     DetailScreen({
      required this.author,
      required this.bookrating,
      required this.link,
      required this.booktitle,
      required this.rating,
      required this.description,
      required this.id,
      required this.bookmarks
    });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

bool? iconbtn1;
User? user = FirebaseAuth.instance.currentUser;
final _firestore=FirebaseFirestore.instance;

void addorremovebookmark(bool isadding)
{
  String message=isadding?'Bookmark Added':'Bookmark Remove';
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.grey,
    textColor: Colors.white,
    fontSize: 16.0
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,

      appBar: AppBar(
        backgroundColor: Colors.indigo.shade700,

        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: (){
            Navigator.pop(context);
          },

        ),
        actions: [
          InkWell(

            onTap: (){

              setState(() {
                iconbtn1=!iconbtn1!;
                addorremovebookmark(iconbtn1!);
                Bookmarked(iconbtn1);
              });
            },
            child: Container(
              padding: EdgeInsets.all(7),

              margin: EdgeInsets.symmetric(horizontal: 9.0,vertical: 9.0),

              child: iconbtn1!? Icon(
                Icons.bookmark,
                color: Colors.white,
                size: 26,
              ):Icon(
                Icons.bookmark_border,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(

            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.indigo[50],
                     
                    ),
                    width: double.infinity,
                    child:ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                       child:Image.network(
                        widget.link,
                        height: 360,
                        width: 100,
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                      )
                    ),
                    
                  ),
                ),
                SizedBox(height: 28,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    widget.booktitle,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,

                      fontSize: 30,
                    ),
                  ),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      widget.author,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 17
                      ),
                    ),
                    ),
                    SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        RatingBar.builder(
                           initialRating:widget.bookrating,
                      minRating: 1,
                      itemSize: 23,
                      direction : Axis.horizontal,
                      allowHalfRating: true,
                      itemCount:5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      onRatingUpdate: (rating){
                        print(rating);
                      }
                        ),
                        SizedBox(width: 10,),
                        Row(
                          children: [
                            Text(
                              widget.bookrating.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 23,
                              )
                            ),
                            Text(
                              '/5.0',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 14
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 30,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(widget.description,
                      textAlign: TextAlign.left,
                      
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 15,
                      ),
                      ),
                      ),

                      SizedBox(height: 15,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}