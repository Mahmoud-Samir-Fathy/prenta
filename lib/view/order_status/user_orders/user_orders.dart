import 'package:flutter/material.dart';
import 'package:printa/shared/styles/colors.dart';
import 'package:printa/view/order_status/active_order/active_order.dart';
import 'package:printa/view/order_status/cancelled_order/cancelled_order.dart';
import 'package:printa/view/order_status/completed_order/comleted_order.dart';

class user_orders extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
   return DefaultTabController(
     length: 3,
     child: Container(
       child: Scaffold(
         appBar: AppBar(
           leading: IconButton( onPressed: () {  }, icon: Icon(Icons.arrow_back_ios_outlined,)),
           title: Text('My Orders'),
           centerTitle: true,
           elevation: 0.0,
         ),
         body:Column(
           children: [
             TabBar(
               indicator: UnderlineTabIndicator(
                 borderSide: BorderSide(
                     width: 4.0,
                     color: firstColor
                 ),
               ),
                 dividerColor: Colors.transparent,
                 labelColor: firstColor,
                 tabs: [
                   Tab(text: 'Active'),
                   Tab(text: 'Completed',),
                   Tab(text: 'Cancelled',)
                 ]),

             Expanded(
               child: TabBarView(children: [
                 active_order(),
                 completed_order(),
                 cancelled_order(),
               ]),
             )
           ],
         ) ,
       ),
     ),
   );
  }
}