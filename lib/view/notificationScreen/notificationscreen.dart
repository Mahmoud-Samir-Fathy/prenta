import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printa/models/notification_model/notification_model.dart';
import 'package:printa/view_model/prenta_layout/prenta_cubit.dart';
import 'package:printa/view_model/prenta_layout/prenta_states.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PrentaCubit()..getNotificationList(),
      child: BlocConsumer<PrentaCubit,PrentaStates>(
        listener: (context, state) {

        },
        builder: (context, state) {
          var cubit=PrentaCubit.get(context);
          return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 25),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                title: const Text('Notification'),
                centerTitle: true,
              ),
              body:SingleChildScrollView(
                child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context,index)=>buildNotification(cubit.notificationList[index]),
                    separatorBuilder: (context,index)=> Divider(color: Colors.grey.shade300, thickness: 1),
                    itemCount: cubit.notificationList.length),
              )
          );
        },
      ),
    );
  }
}
Widget buildNotification(NotificationModel model)=>Padding(
  padding: const EdgeInsets.all(16.0),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CircleAvatar(
        radius: 25,
        backgroundColor: Colors.grey.shade200,
        child: Icon(getIconForNotification(model.image.toString()),
            color: Colors.blue,),
      ),
      const SizedBox(width: 15),
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${model.title}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${model.body}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${model.date}',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    ],
  ),
);

IconData getIconForNotification(String imageType) {
  switch (imageType) {
    case 'email':
      return Icons.email;
    case 'password':
      return Icons.lock;
    case 'person':
      return Icons.person;
    case 'address':
      return Icons.home;
  // Add more cases as needed
    default:
      return Icons.notifications;
  }
}