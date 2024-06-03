import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mybook/screens/detail_screen.dart';


final _firestore=FirebaseFirestore.instance;

class Newest extends StatefulWidget {
  const Newest({super.key});

  @override
  State<Newest> createState() => _NewestState();
}

class _NewestState extends State<Newest> {
  @override
  Widget build(BuildContext context) {
    return Container(

      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: StreamBuilder(
          stream: _firestore.collection('books').snapshots(),
          builder: (context,snapshot){
            if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blueAccent,
                ),
              );
            }
            else if(snapshot.hasError){
              return Text('Error ${snapshot.error}');
            }
            else{
              if(snapshot.data !=null)
              {
                final messages=snapshot.data?.docs.reversed;
                List<Widget> messagewidgets=[];

                for(var message in messages!){
                  final author = message.data()['author'];
                  final link = message.data()['image_url'];
                  final title = message.data()['title'];
                  final rating = message.data()['rating'];
                  final description = message.data()['description'];
                  final docid = message.id;
                  final bookmarks = message.data()['Bookmarks'];
                  final price = message.data()['price'];
                  final pages = message.data()['pages'];
                  final latitude = message.data()['latitude'];
                  final longitude = message.data()['longitude'];

                  final Widget messagewidget = NewestBooks(
                    author: author,
                    link: link,
                    title: title,
                    rating: rating,
                    description: description,
                    id: docid,
                    bookmarks: bookmarks,
                    price: price,
                    pages:pages,
                    latitude : latitude,
                    longitude : longitude,
                  );
                messagewidgets.add(messagewidget);
                }
                return ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  reverse: false,
                  padding: EdgeInsets.symmetric(vertical: 5.0,horizontal: 5.0),
                  children: messagewidgets,
                );
              }
              else
              {
                return Container();
              }
            }
          },
          ),
      ),
    );
  }
}

class NewestBooks extends StatefulWidget {

  final String author;
  final String link;
  final String title;
  final double rating;
  final String description;
  final String id;
  final List<dynamic> bookmarks;
  final Function(bool)? onBookmarkChanged;
  final String price;
  final String pages;
  final double? latitude;
  final double? longitude;


   const NewestBooks({
    required this.author,
    required this.link,
    required this.title,
    required this.rating,
    required this.description,
    required this.id,
    required this.bookmarks,
    this.onBookmarkChanged,
    required this.price,
    required this.pages,
    this.latitude,
    this.longitude,
    });

  

  @override
  State<NewestBooks> createState() => _NewestBooksState();
}

class _NewestBooksState extends State<NewestBooks> {
      bool? iconbtn;
      User? user = FirebaseAuth.instance.currentUser;

void addorremovebookmark(bool isadding)
{
  String message=isadding?'Bookmark added':'Bookmark removed';
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
          mainAxisAlignment: MainAxisAlignment.center,
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

  void initState(){
    if(widget.bookmarks!=null)
    {
      if(widget.bookmarks.contains(user!.email!)){

        setState(() {
          iconbtn = true;
        });
      }
      else{
        iconbtn=false;
      }
    }
    else{
      iconbtn=false;
    }
    super.initState();

    print(iconbtn);
  }
  
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2.0),
      child: Container(
        width: 390,
        height: 180,
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 1),
        decoration: BoxDecoration(
          color: Colors.indigo[50],
          borderRadius: BorderRadius.circular(7) 
        ),
        child: GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(
              author:widget.author,
              link:widget.link,
              title:widget.title,
              bookrating:widget.rating,
              description:widget.description,
              id:widget.id,
              bookmarks:widget.bookmarks,
              price: widget.price,
              pages: widget.pages,
              latitude: widget.latitude,
              longitude: widget.longitude,
            ),)
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.7),
                      spreadRadius: 0,
                      blurRadius: 3,
                      offset: Offset(3, 4),
                    ),
                  ],

                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    widget.link,
                    height: 150,
                    width: 100,
                    fit:BoxFit.cover,

                  )
                ),
              ),SizedBox(width: 20,),
              Container(
                width: 170,
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,

                  children: [
                    Text(
                      widget.title,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,

                        fontSize: 17
                      )
                    ),
                    SizedBox(height: 10,),
                    Text(
                      widget.author,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 17
                      ),
                    ),
                    SizedBox(height: 30,),
                    RatingBar.builder(
                      ignoreGestures: true,
                      initialRating:widget.rating,
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
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          iconbtn=!iconbtn!;
                          addorremovebookmark(iconbtn!);
                          Bookmarkadd(iconbtn!);
                        });
                      },
                      child: iconbtn!? Icon(
                        Icons.bookmark,
                        color: Colors.red,
                        size: 24,
                      ):Icon(
                        Icons.bookmark_border,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                )
            ],
          ),
        ),
      ),
    );
  }
} 