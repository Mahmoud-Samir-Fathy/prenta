import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:printa/shared/components/components.dart';

class successful_change extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Image(image: AssetImage('images/success.png'))),
          SizedBox(height: 30,),
          Text('Congratulation',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
          Text('Successful change',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold)),
          Spacer(),
          defaultMaterialButton(text: 'Continue', Function: (){}),
          SizedBox(height: 30,),
        ],
      ),
    );
  }


}