
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mybook/dialog/loading_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mybook/dialog/error_dialog.dart';
import 'package:mybook/dialog/success_dialog.dart';
import 'package:mybook/services/location_service.dart';

class PostBookScreen extends StatefulWidget {
  const PostBookScreen({super.key});

  @override
  State<PostBookScreen> createState() => _PostBookScreenState();
}

class _PostBookScreenState extends State<PostBookScreen> {
  XFile? image;
  bool? textscanning;
  String textscanner="No image to show";
  TextEditingController title=TextEditingController();
  TextEditingController Description=TextEditingController();
  TextEditingController Price=TextEditingController();
  TextEditingController Pages=TextEditingController();
  TextEditingController Author=TextEditingController();
  double latitude = 0.0;
  double longitude = 0.0;
  double initialRating=0.0;
  bool? light1=false;
  final ImagePicker _imagePicker = ImagePicker();
  String selectedCategory = 'Select Category';
  final _firestore=FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  LatLng? selectedLocation;

  List<String> categories= ['Select Category','Comedy','Lifestyle','Sport','Thriller','Mystery'];

  Future<void> checkData()async{

    CollectionReference users=_firestore.collection('books');
    if(image==null || title.text.isEmpty || Description.text.isEmpty || Price.text.isEmpty || Author.text.isEmpty || selectedCategory=='Select Category' || initialRating==0.0)
    {
      showDialog(
        context: context, 
        builder: (c){
          return ErrorDialog(
            message: "Please fill the information properly",
          );
        }
      );
    }
    else{
      showDialog(
        context: context, 
        builder: (c){
          return LoadingDialog(
            message:"Saving Data"
          );
        }
      );
        String imageUrl = await uploadImageToFirebaseStorage();
        try{
          users.add(
            {
              'title': title.text,
              'description':Description.text,
              'price': Price.text,
              'pages': Pages.text,
              'author': Author.text,
              'image_url': imageUrl,
              'isPopular': light1,
              'categories':selectedCategory,
              'rating':initialRating,
              'Bookmarks':[],
              'latitude':selectedLocation?.latitude,
              'longitude':selectedLocation?.longitude,
            }
          ).whenComplete((){
            setState(() {
              image = null;
              textscanning = null;
              textscanner = "No image to show";
              title.text = "";
              Description.text ="";
              Price.text="";
              Pages.text="";
              light1 = false;
              Author.text = "";
              selectedCategory = "Select Category";
              initialRating = 0.0;
            });
            Navigator.pop(context);
            showDialog(
              context: context, 
              builder: (c){
                return const SuccesDialog(
                  message: "Data Update Succesfully",
                );
              }
            );
          });
        }
        catch(e){
          Navigator.pop(context);
          print(e);
        }
    }

  }
  void galleryImage()async{
    try{
      XFile? imagetemp = await _imagePicker.pickImage(source: ImageSource.gallery);

      if(imagetemp != null){
        setState(() {
          textscanning=true;
          image=imagetemp;
        });
      }
    }

    catch(e){
      textscanning=false;
      image=null;
      textscanner="Error Occured, Please try again";
    }
  }

  Future<String> uploadImageToFirebaseStorage()async{
    try{
      File imageFile = File(image!.path);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
      Reference storageReferance = FirebaseStorage.instance.ref().child('image/$fileName');

      final metadata = SettableMetadata(contentType: 'image/jpeg');
      await storageReferance.putFile(imageFile, metadata);

      String imageUrl = await storageReferance.getDownloadURL();
      return imageUrl; 
    }catch(e){
      print('Error uploading image: $e');
      return '';
    }
  }

  Future<void> _pickLocation() async {
    try {
      final currentPosition = await LocationService.getCurrentPosition();
      if (currentPosition != null) {
        setState(() {
          selectedLocation =
              LatLng(currentPosition.latitude, currentPosition.longitude);
        });
      } else {
        // Handle the case when currentPosition is null
        // For example, show an error message to the user
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to get current location.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Handle the error, for example, show an error message to the user
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('An error occurred while getting the location: $e'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Books',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.indigo,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: ()async{
              try{
                await _auth.signOut();
                Navigator.pop(context);
                print("User signed out");
              }
              catch(e){
                print("Error signing out $e");
              }
            },
             icon: Icon(
              Icons.logout,
              size: 30,
              color: Colors.white,
              )),

        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.indigo[50],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextFormField(
                  controller: title,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Book Title',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 18,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                    prefixIcon: Icon(Icons.book_outlined,size: 24,color: Colors.indigo),

                  ),
                ),
              ),
              SizedBox(height: 20,),
              Container(

                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.indigo[50],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextFormField(
                controller: Description,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                
                textInputAction: TextInputAction.newline,

                decoration: InputDecoration(
                  hintText: "Book Description",
                  contentPadding: EdgeInsets.all(10),
                  hintStyle: GoogleFonts.inter(
                    fontSize: 18,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,

                  ),
                  border: InputBorder.none
                ),
              ),
            ),
              SizedBox(height: 30,),
              Container(
                width: double.infinity,

                decoration: BoxDecoration(
                  color: Colors.indigo[50],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextFormField(
                  controller: Author,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Author Name',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 18,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                    prefixIcon: Icon(Icons.person,size: 24,color: Colors.indigo,),

                  ),
                ),
              ),
              SizedBox(height: 30,),
              Container(
                width: double.infinity,

                decoration: BoxDecoration(
                  color: Colors.indigo[50],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextFormField(
                  controller: Price,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Harga',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 18,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                    prefixIcon: Icon(Icons.money,size: 24,color: Colors.indigo,),

                  ),
                ),
              ),
              SizedBox(height: 30,),
              Container(
                width: double.infinity,

                decoration: BoxDecoration(
                  color: Colors.indigo[50],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextFormField(
                  controller: Pages,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Halaman Buku',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 18,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                    prefixIcon: Icon(Icons.book,size: 24,color: Colors.indigo,),

                  ),
                ),
              ),
              
              SizedBox(height: 30,),
              DottedBorder(

                borderType: BorderType.RRect,
                radius: Radius.circular(20),
                padding: EdgeInsets.all(6),
                child: GestureDetector(
                  onTap: (){
                    galleryImage();
                  },
                  child: Container(
                    width: 250,
                    height: 450,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.indigo[50],
                    ),

                    child:(textscanning==null) ?Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.upload_file,
                            size: 80,
                            color: Colors.black.withOpacity(0.6),
                          ),
                          SizedBox(height: 25,),
                          Text(
                            'Tap to Upload Image',
                            style: GoogleFonts.inter(
                              fontSize: 19,
                              fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      ),
                    ):(textscanning==false)? Center(child:Text(textscanner,style: TextStyle(color: Colors.black87),),):Image.file(File(image!.path)),
                  ),
                ),
              ),
              SizedBox(height: 20,),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Popular',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                    ),

                  ),
                  SizedBox(width: 20,),
                  Transform.scale(
                    scale: 1.5,
                    child: Switch(

                      // ignore: deprecated_member_use
                      thumbIcon: (light1==true)?MaterialStateProperty.resolveWith((states) => Icon(Icons.check,color: Colors.black,)):MaterialStateProperty.resolveWith((states) => Icon(Icons.close,color: Colors.white)),
                      value: light1!,
                      activeTrackColor: Colors.green,
                      inactiveThumbColor: Colors.indigo,
                      onChanged: (bool value){
                        setState(() {
                          light1=value;
                        });
                      },
                    ),
                    )
                ],
              ),
              SizedBox(height: 30,),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(

                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Text(
                      'Category',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 21,
                      ),
                    ),
                    SizedBox(width: 10,),
                    Container(
                      padding: EdgeInsets.all(4),

                      decoration: BoxDecoration(
                        color: Colors.indigo[50],
                        borderRadius: BorderRadius.circular(12)
                      ),
                      child: DropdownButton<String>(
                        value: selectedCategory,

                        items: categories.map((String category){
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                            );
                        }).toList(),
                        onChanged: (newvalue){
                          setState(() {
                            selectedCategory = newvalue!;
                           }
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(

                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Text(
                      'Rating',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 21,
                      ),
                    ),
                    SizedBox(width: 10),
                    RatingBar.builder(
                      initialRating: initialRating,
                      minRating: 1,
                      maxRating: 5,
                      itemSize: 40.0,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate:(rating){
                        setState(() {
                          initialRating = rating;
                        });
                      }
                    )
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(0),
                  child: ButtonBar(
                    alignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: _pickLocation,
                        style: ElevatedButton.styleFrom(
                            minimumSize:
                                const Size(400, 50), // Ukuran minimum tombol
                            backgroundColor: Colors.blue),
                        child: const Text('Ambil Lokasi Saya'),
                      ),
                    ],
                  ),
                ),
                const Text('Lokasi'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 200, // Sesuaikan tinggi sesuai kebutuhan
                    child: selectedLocation != null
                        ? GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(selectedLocation!.latitude,
                                  selectedLocation!.longitude),
                              zoom: 15,
                            ),
                            markers: {
                              Marker(
                                markerId: const MarkerId('selectedLocation'),
                                position: LatLng(selectedLocation!.latitude,
                                    selectedLocation!.longitude),
                              ),
                            },
                          )
                        : Container(
                            alignment: Alignment.center,
                          ),
                  ),
                ),
              SizedBox(height: 30,),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: (){
                    checkData();
                  },
                  child: Text(
                    'Upload Book',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w700
                    ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                ),
              ),
            ],
          ),

        ),
      ),
    );
  }
}