import 'package:flutter/material.dart';
import 'package:printa/shared/styles/colors.dart';
import 'package:printa/view/order_status/active_order/active_order.dart';
import 'package:printa/view/order_status/cancelled_order/cancelled_order.dart';
import 'package:printa/view/order_status/completed_order/comleted_order.dart';
import 'package:printa/view_model/change_mode/mode_cubit.dart';

class UserOrders extends StatelessWidget{
  const UserOrders({super.key});

  @override
  Widget build(BuildContext context) {
    var mCubit=ModeCubit.get(context);
   return DefaultTabController(
     length: 3,
     child: Container(
       child: Scaffold(
         appBar: AppBar(
           title: const Text('My Orders'),
           centerTitle: true,
           elevation: 0.0,
           surfaceTintColor: Colors.transparent,
         ),
         body:Column(
           children: [
             TabBar(

               indicator: UnderlineTabIndicator(
                 borderSide: BorderSide(
                     width: 4.0,
                     color:mCubit.isDark?thirdColor: firstColor
                 ),
               ),
                 dividerColor: Colors.transparent,
                 labelColor: mCubit.isDark?thirdColor: firstColor,
                 tabs: const [
                   Tab(text: 'Active'),
                   Tab(text: 'Completed',),
                   Tab(text: 'Cancelled',)
                 ]),

             const Expanded(
               child: TabBarView(
                 physics: NeverScrollableScrollPhysics(),
                   children: [
                 ActiveOrder(),
                 CompletedOrder(),
                 CancelledOrder(),
               ]),
             )
           ],
         ) ,
       ),
     ),
   );
  }
}