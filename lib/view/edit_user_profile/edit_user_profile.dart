import 'package:flutter/material.dart';
import 'package:printa/shared/components/components.dart';

class edit_profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var firstNameController = TextEditingController();
    var lastNameController = TextEditingController();
    var emailNameController = TextEditingController();
    var phoneNameController = TextEditingController();


    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
          },
        ),
        title: Text('Edit Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage('images/google.png'),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 20,
                    child: Icon(Icons.camera_alt_outlined, color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('First Name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        SizedBox(height: 8),
                        defaultTextFormField(
                          controller: firstNameController,
                          KeyboardType: TextInputType.text,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your first name';
                            } else {
                              return null;
                            }
                          },
                          lable: 'First Name',
                          prefix: Icons.person,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Last Name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        SizedBox(height: 8),
                        defaultTextFormField(
                          controller: lastNameController,
                          KeyboardType: TextInputType.text,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your Last name';
                            } else {
                              return null;
                            }
                          },
                          lable: 'Last Name',
                          prefix: Icons.person,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Your Email', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  SizedBox(height: 8),
                  defaultTextFormField(
                    controller: emailNameController,
                    KeyboardType: TextInputType.emailAddress,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email address';
                      } else {
                        return null;
                      }
                    },
                    lable: 'xxx@gmail.com',
                    prefix: Icons.email_outlined,
                  ),
                ],
              ),
              SizedBox(height: 15,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Phone Number', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  SizedBox(height: 8),
                  defaultTextFormField(
                    controller: phoneNameController,
                    KeyboardType: TextInputType.phone,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your phone number';
                      } else {
                        return null;
                      }
                    },
                    lable: '+02*******',
                    prefix: Icons.phone,
                  ),
                ],
              ),
              SizedBox(height: 15,),
        
              Row(
                children: [
                  Icon(Icons.password),
                  SizedBox(width: 15,),
                  Text('Change Password'),
                  Spacer(),
                  IconButton(onPressed: (){}, icon:Icon( Icons.arrow_forward_ios_sharp))
                ],
              ),
              SizedBox(height: 15,),
        
              Row(
                children: [
                  Icon(Icons.home),
                  SizedBox(width: 15,),
                  Text('Change Address'),
                  Spacer(),
                  IconButton(onPressed: (){}, icon:Icon( Icons.arrow_forward_ios_sharp))
                ],
              ),
              SizedBox(height: 30),
              defaultMaterialButton(text: 'Submit', Function: (){})
            ],
          ),
        ),
      ),
    );
  }
}
