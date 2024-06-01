import 'package:flutter/material.dart';

class SuccesDialog extends StatelessWidget {
  const SuccesDialog({this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
              color: Colors.green
            ),
            child: Center(
              child: Icon(
                Icons.check_circle,
                color: Colors.white,

                size: 180,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 12,),
                  Text(
                    'Success',
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0,),
                  Text(
                    message!,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    height: 50,
                    width: 500,
                    margin: EdgeInsets.symmetric(horizontal: 50),

                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Oke"
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36)),
                        backgroundColor: Colors.green,
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