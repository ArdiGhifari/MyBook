import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mybook/screens/google_maps.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatefulWidget {

  final String author;
  final String link;
  final String title;
  final double bookrating;
  final String description;
  final String id;
  final List<dynamic> bookmarks;
  final String price;
  final String pages;
  final Function(bool)? onBookmarkChanged;
  final double? latitude;
  final double? longitude;
  
     DetailScreen({
      required this.author,
      required this.title,
      required this.bookrating,
      required this.description,
      required this.link,
      required this.id,
      required this.bookmarks,
      required this.price,
      required this.pages,
      this.onBookmarkChanged,
      this.latitude,
      this.longitude,
    });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

bool? iconbtn1 = false;
User? user = FirebaseAuth.instance.currentUser;
final _firestore=FirebaseFirestore.instance;

void addorremovebookmark(bool isadding)
{
  String message=isadding?'Bookmark Added':'Bookmark Removed';
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

void Bookmarkadd(iconbtn)async
{
  try{
    if(iconbtn)
    {
      await _firestore.collection('books').doc(widget.id).update({'Bookmarks': FieldValue.arrayUnion([user!.email!])});
    }
    else{
      await _firestore.collection('books').doc(widget.id).update({'Bookmarks': FieldValue.arrayRemove([user!.email!])});
    }
  }
  catch(e){
    showDialog(
      context: context, 
      builder: (context){
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AlertDialog(
              title: Center(
                child: Text('Error', style: TextStyle(fontSize: 30),)),
              content: Column(
                children: [
                Icon(Icons.cancel, color: Colors.red, size: 130,),
                SizedBox(height: 12,),
                Center(child: Text('Try again',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),)),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  }, child: Text('Oke'))
              ],
            )
          ],
        );
      }
      );
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255,14, 135, 141),

      appBar: AppBar(
        backgroundColor: Color.fromARGB(200,8,51,161),
        centerTitle: true,
        automaticallyImplyLeading: false,
         title: Text('Detail Book',
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white
          ),
        ),
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
                Bookmarkadd(iconbtn1);
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
                      borderRadius: BorderRadius.circular(12),
                      color: Color.fromARGB(01,36,197,124),
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
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,

                      fontSize: 40,
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
                        fontSize: 20
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
                      onRatingUpdate: (bookrating){
                        print(bookrating);
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
                        ),      
                      ],
                    ),
                    SizedBox(height: 20,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                               "Rp.${widget.price}",
                              textAlign: TextAlign.left,
                              style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              color: Colors.black.withOpacity(1),
                              fontSize: 17
                            ),
                          ),
                        ),
                    SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            "${widget.pages} Halaman",
                            textAlign: TextAlign.left,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              color: Colors.black.withOpacity(1),
                              fontSize: 17
                            ),
                          ),
                        ),
                    SizedBox(height: 30,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(widget.description,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(1),
                        fontSize: 15,
                     ),
                    ),
                  ),
                  const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Row(
                children: [
                  Text(
                    'Lokasi Penjual:',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  widget.latitude != null && widget.longitude != null
                      ? SizedBox(
                          height: 200,
                          child: GoogleMapsScreen(
                            latitude: widget.latitude!,
                            longitude: widget.longitude!,
                          ),
                        )
                      : Container(
                          height: 200,
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(
                              Icons.location_off,
                              color: Colors.grey,
                              size: 50,
                            ),
                          ),
                        ),
            ),
                  SizedBox(height: 20,),
                        ElevatedButton(
                          onPressed:(){
                            final Uri whatsapp = Uri.parse('https://wa.me/${6289629018837}');
                            launchUrl(whatsapp);
                          },
                          child: Text('Chat Seller'),
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