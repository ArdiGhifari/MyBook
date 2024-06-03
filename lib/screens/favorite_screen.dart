import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mybook/screens/detail_screen.dart';


class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final _firestore=FirebaseFirestore.instance;
  final user=FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: StreamBuilder<QuerySnapshot<Object?>>(
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
              return Text('Error: ${snapshot.error}');
            }
            else{
              if(snapshot.data !=null){
                final message=snapshot.data?.docs.reversed;
                List<QueryDocumentSnapshot<Object?>> messageList = message!.toList();
              
                List<Widget> messagewidgets=[];
                List<bool> checkbookmark=List.filled(messageList.length, true);

                for(int i = 0; i < messageList!.length; i++){
                  var message = messageList[i];
                  final Map<String, dynamic>? data=message.data() as Map<String , dynamic>;

                    final author=data!['author'];
                    final link=data!['image_url'];
                    final title=data!['title'];
                    final description= data! ['description'];
                    final rating= data!['rating'];
                    final docid=message.id;
                    final bookmarks= data!['Bookmarks'];
                    final price = data!['price'];
                    final pages = data!['pages'];
                    final latitude = data!['latitude'];
                    final longitude = data!['longitude'];

                    if (bookmarks.contains(user!.email!))
                    {
                      final Widget messagewidget = Newest(
                        author: author, 
                        link: link, 
                        title: title, 
                        rating: rating, 
                        description: description, 
                        id: docid, 
                        bookmarks: bookmarks,
                        checkbookmarks: checkbookmark,
                        index:i,
                        price: price,
                        pages: pages,
                        latitude:latitude,
                        longitude:longitude
                    );

                        messagewidgets.add(messagewidget);
                    }
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
                return Container(
                  child: Center(
                    child: Text("No Book to display"),
                  ),
                );
              }
            }
          },
        ),),
    );
  }
}

class Newest extends StatefulWidget {
  final String author;
  final String link;
  final String title;
  final double rating;
  final String description;
  final String id;
  final List<dynamic> bookmarks;
  final List<bool> checkbookmarks;
  final int index;
  final String price;
  final String pages;
  final double? latitude;
  final double? longitude;

  const Newest({
    required this.author,
    required this.link,
    required this.title,
    required this.rating,
    required this.description,
    required this.id,
    required this.bookmarks, 
    required this.checkbookmarks, 
    required this.index,
    required this.price,
    required this.pages,
    this.latitude,
    this.longitude,
  });
  
  
  @override
  State<Newest> createState() => _NewestState();
}

class _NewestState extends State<Newest> {

  final _firestore=FirebaseFirestore.instance;
  final user=FirebaseAuth.instance.currentUser;

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

  void Bookmarkadd() async
  {
    try{
      await _firestore.collection('books').doc(widget.id).update({'Bookmarks': FieldValue.arrayRemove([user!.email!])});
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
                      Center(child: Text('Try Again',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),)),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: (){
                        Navigator.pop(context);
                      } ,
                       child: Text('Ok'))
                  ],
              ),
            ],
          );
        }
        );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 390,
      height: 240,
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(
            author: widget.author, 
            link: widget.link, 
            title: widget.title, 
            bookrating: widget.rating, 
            description: widget.description, 
            id: widget.id, 
            bookmarks: widget.bookmarks,
            price: widget.price,
            pages: widget.pages,
            latitude: widget.latitude,
            longitude: widget.longitude
            )),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),

                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.9),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(3, 7),
                  ),
                ] ,
              ),
              child:  ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  widget.link,
                  height: 190,
                  width: 120,
                ),
              ),

              
            ),
            Container(
            width: 170,
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,

                    fontSize: 26
                  ),
                ),
                SizedBox(height: 18,),
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
              padding: EdgeInsets.symmetric(vertical: 18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        widget.checkbookmarks[widget.index]=!widget.checkbookmarks[widget.index];
                        addorremovebookmark(widget.checkbookmarks[widget.index]);
                        Bookmarkadd();
                      });
                    },
                    child: widget.checkbookmarks[widget.index]? Icon(
                      Icons.bookmark,
                      color: Colors.red,
                      size: 26,
              
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
    );
  }
}