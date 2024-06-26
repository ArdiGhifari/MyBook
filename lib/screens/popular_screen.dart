import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mybook/screens/detail_screen.dart';

class PopularBooks extends StatefulWidget {
  const PopularBooks({super.key});

  @override
  State<PopularBooks> createState() => _PopularBooksState();
}

class _PopularBooksState extends State<PopularBooks> {
  final _firestore=FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _firestore.collection('books').snapshots(),
          builder: (context, snapshot) {
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
                  final bool popular=message.data()['isPopular'];

                  if(popular)
                  {
                    final author=message.data()['author'];
                    final link=message.data()['image_url'];
                    final title=message.data()['title'];
                    final description=message.data()['description'];
                    final rating=message.data()['rating'];
                    final docid=message.id;
                    final bookmarks=message.data()['Bookmarks'];
                    final price=message.data()['price'];
                    final pages=message.data()['pages'];
                    final latitude=message.data()['latitude'];
                    final longitude=message.data()['longitude'];

                    final messagewidget=PopularBook(
                      author:author,
                      link:link,
                      title:title,
                      rating:rating,
                      description:description,
                      id: docid,
                      bookmarks : bookmarks,
                      price: price,
                      pages: pages,
                      latitude:latitude,
                      longitude:longitude,
                    );
                    messagewidgets.add(messagewidget);
                  }
                }
                print(messagewidgets);
                return ListView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  reverse: false,
                  padding: EdgeInsets.symmetric(vertical: 3.0,horizontal: 5.0),
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

class PopularBook extends StatelessWidget{
  final String author;
  final String link;
  final String title;
  final double rating;
  final String description;
  final String id;
  final List<dynamic> bookmarks;
  final String price;
  final String pages;
  final double? latitude;
  final double? longitude;
  
  PopularBook({
    required this.author,
    required this.link,
    required this.title,
    required this.rating,
    required this.description,
    required this.id,
    required this.bookmarks,
    required this.price,
    required this.pages,
    this.latitude,
    this.longitude,
  });


@override
Widget build(BuildContext context){
  return Container(
    width: 170,
    height: 300,
    padding: EdgeInsets.all(8),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(
            author:author,
            link:link,
            title:title,
            bookrating:rating,
            description:description,
            id:id,
            bookmarks:bookmarks,
            price:price,
            pages:pages,
            latitude: latitude,
            longitude: longitude,
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
                border: Border.all(
                  color: Colors.black,
                  width: 1.2
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.7),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(3, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),

                child: Image.network(link,
                height: 200,

                width: 150,
                fit: BoxFit.cover,
                )
              ),
            ),
            SizedBox(height: 12,),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,

                fontSize: 17
              ),
            ),
             SizedBox(height: 12,),
            Text(
              author,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.black.withOpacity(0.5),
                fontSize: 15
              ),
            ),
          ]
        ),
      )
    )
  );
}

}