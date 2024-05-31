import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    
    return  AlertDialog(
      key: key,
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.red
            ),
            child: Center(
              child: Icon(
                Icons.error_outlined,
                color: Colors.white,

                size: 180,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 12,),

                  SizedBox(height: 8.0,),
                  Text(
                    message!,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    height: 50,
                    width: 580,
                    margin: EdgeInsets.symmetric(horizontal: 50),

                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    child: Text(
                      "Okeyy",
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white
                    ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}