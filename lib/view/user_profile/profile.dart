import 'package:flutter/material.dart';
import 'package:printa/shared/styles/colors.dart';

class profile_screen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title:Text('Profile Settings',style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 70,
                  child: Image(image: AssetImage('images/google.png'),fit: BoxFit.fill,),
                ),
                SizedBox(height: 10,),
                Text('Mahmoud Samir'),
                SizedBox(height: 5,),
                Text('MahmoudSamir1999@hotmail.com'),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.grey.withOpacity(0.3),
                  ),
                ),
                SizedBox(height: 30,),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Profile',style: TextStyle(fontWeight: FontWeight.w400),),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 15,),
                      Text('Edit Profile'),
                      Spacer(),
                      IconButton(onPressed: (){}, icon:Icon( Icons.arrow_forward_ios_sharp))
                    ],
                  ),
                  SizedBox(height: 15,),
                  Row(
                    children: [
                      Icon(Icons.settings),
                      SizedBox(width: 15,),
                      Text('Dark Mode'),
                      Spacer(),
                      IconButton(onPressed: (){}, icon:Icon( Icons.arrow_forward_ios_sharp))
                    ],
                  ),
                  SizedBox(height: 15,),
                  Row(
                    children: [
                      Icon(Icons.wallet),
                      SizedBox(width: 15,),
                      Text('Orders'),
                      Spacer(),
                      IconButton(onPressed: (){}, icon:Icon( Icons.arrow_forward_ios_sharp))
                    ],
                  ),
                  SizedBox(height: 20,),
                  Text('Support',style: TextStyle(fontWeight: FontWeight.w400),),
                  SizedBox(height: 15,),
                  Row(
                    children: [
                      Icon(Icons.warning),
                      SizedBox(width: 15,),
                      Text('Help Center'),
                      Spacer(),
                      IconButton(onPressed: (){}, icon:Icon( Icons.arrow_forward_ios_sharp))
                    ],
                  ),
                  SizedBox(height: 15,),
                  Row(
                    children: [
                      Icon(Icons.warning),
                      SizedBox(width: 15,),
                      Text('Terms of Service'),
                      Spacer(),
                      IconButton(onPressed: (){}, icon:Icon( Icons.arrow_forward_ios_sharp))
                    ],
                  ),
                  SizedBox(height: 30,),
                  Center(
                      child:
                      Container(
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color:firstColor
                          )
                        ),
                        child: MaterialButton(
                          height: 60,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all( Radius.circular(30),),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.output_outlined),
                              SizedBox(width: 15,),
                              Text('Sign out'),
                            ],
                          ),
                          onPressed: (){
                            _showSignOutDialog(context);

                          },
                        ),
                      )
                  ),
                  SizedBox(height: 20,)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
void _showSignOutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(

        title: Align(alignment:AlignmentDirectional.center,child: Text('Sign Out'),),
        content: Container(height:100,child: Center(child: Text('Do you want to sign out?',style: TextStyle(fontWeight: FontWeight.w300),))),
        actions: [
          Container(
            height: 50,
            width: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                    color:firstColor
                )
            ),
            child: MaterialButton(
            height:50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all( Radius.circular(30),),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ),
          Container(
            height: 50,
            width: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                    color:firstColor
                )
            ),
            child: MaterialButton(

              color: firstColor,
            height:50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all( Radius.circular(30),),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Sign Out',style: TextStyle(color: Colors.white),),
            ),
          ),
        ],
      );
    },
  );
}
