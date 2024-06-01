import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mybook/screens/detail_screen.dart';

class Categories extends StatefulWidget {
  Categories({required this.category});

  String category;
  
  @override
  State<Categories> createState() => _CategoriesState();
}


class _CategoriesState extends State<Categories> {
  final _firestore=FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade700,
        title: Text(widget.category,
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white
        ),
        ),
        centerTitle: true,
        elevation: 0.0,

        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('books').snapshots(),
          builder: (context,snapshot){
            if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blueAccent,
                ),
              );
            }
            else if (snapshot.hasError){
              return Text('Error ${snapshot.error}');
            }
            else{
              if(snapshot.data!=null)
              {
                final messages=snapshot.data?.docs.reversed;
                List<Widget>messagewidgets=[];

                for(var message in messages!){
                  final Map<String,dynamic>? data=message.data() as Map<String, dynamic>;

                  if(data!['categories']==widget.category)
                  {
                    final author=data!['author'];
                    final link=data!['image_url'];
                    final booktitle=data!['title'];
                    final description= data! ['description'];
                    final rating= data!['rating'];
                    final docid=message.id;
                    final bookmarks= data!['Bookmarks'];

                    final messagewidget= CategoryBooks(
                      author:author,
                      link:link,
                      booktitle:booktitle,
                      rating : rating,
                      description : description,
                      id: docid,
                      bookmarks: bookmarks,
                    );

                    messagewidgets.add(messagewidget);
                  }
                }
                return GridView.builder(
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: false,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6
                  ),
                  itemCount: messagewidgets.length,
                  itemBuilder: (BuildContext context,int index){
                    return Padding(
                      padding: EdgeInsets.all(3.0),
                      child: messagewidgets[index],
                      );
                  },
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

class CategoryBooks extends StatelessWidget{

   CategoryBooks({required this.author,required this.link,required this.booktitle,required this.rating,required this.description,required this.id,required this.bookmarks});


  final String author;
  final String link;
  final String booktitle;
  final double rating;
  final String description;
  final String id;
  final List<dynamic> bookmarks;


  @override

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        width: 170,
        height: 270,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.indigo[50],
          borderRadius: BorderRadius.circular(5)
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(
                author: author, 
                link: link, 
                booktitle: booktitle,
                bookrating: rating, 
                description: description, 
                id: id, 
                bookmarks: bookmarks,
                ),)
                );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.7),
                        spreadRadius: 0,
                        blurRadius: 3,
                        offset: Offset(3,4),
                      ) ,
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(link,
                    height: 160,
                    width: 110,
                    fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 12,),
                Text(
                  booktitle,

                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,

                    fontSize: 17
                  ),
                ),
                SizedBox(height: 2,),
                Text(
                  author,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Colors.black.withOpacity(0.5),
                    fontWeight: FontWeight.w500,

                    fontSize: 15
                  ),
                ),

              ]
            ),
          ),
          ),
      ),
      );
  }
        
}