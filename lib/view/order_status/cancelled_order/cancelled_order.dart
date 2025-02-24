import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printa/shared/styles/colors.dart';
import 'package:printa/view_model/change_mode/mode_cubit.dart';
import 'package:printa/view_model/prenta_layout/prenta_cubit.dart';
import 'package:printa/view_model/prenta_layout/prenta_states.dart';

class CancelledOrder extends StatelessWidget{
  const CancelledOrder({super.key});

  @override
  Widget build(BuildContext context) {
    PrentaCubit.get(context).getFavouriteItems();

    return BlocConsumer<PrentaCubit, PrentaStates>(
      listener: (context,state){},
      builder: (context, state) {
        var cubit=PrentaCubit.get(context);
        var cancelledItems=cubit.cancelledItems;

          return ConditionalBuilder(
            condition: cancelledItems.isNotEmpty,
            builder: (context)=>ListView.separated(
              itemBuilder: (context, index) => buildActiveItem(cancelledItems[index],context),
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: cancelledItems.length,
            ),
            fallback: (context)=>const Center(child: Text('No items here')),
          );
        }
    );
  }

  Widget buildActiveItem(Map<String, dynamic> item,context) {

    final int quantity = item['quantity'] ?? 1;
    final double price = double.tryParse(item['price'].toString()) ?? 0.0;

    return Container(
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 100,
                child: Image(
                  image: NetworkImage(item['image']),
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(item['title'] ?? 'Unknown Item'),
                      Text(item['description'] ?? 'No description',maxLines: 1,overflow: TextOverflow.ellipsis,),
                      const Spacer(),
                      Row(
                        children: [
                          Column(
                            children: [
                              Text('Qty(${item['quantity'] ?? 1})', style: const TextStyle(fontSize: 16)),
                              Text('${price * quantity + 50} L.E',
                                  style: const TextStyle(fontWeight: FontWeight.w700)),],
                          ),
                          const SizedBox(width: 30),
                          Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: ModeCubit.get(context).isDark?secondColor:firstColor,
                                radius: 16,
                                child: Text(item['size'] ?? 'N/A', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                              ),
                              Text(item['color'] )
                            ],
                          ),
                          const Spacer(),
                          if (item['description'] != null)
                            TextButton(child:Text('Re-order', style: TextStyle(color: ModeCubit.get(context).isDark?forthColor:Colors.black,fontWeight: FontWeight.bold, fontSize: 18)),onPressed: (){
                              PrentaCubit.get(context).showReorderOrderDialog(context,Colors.blueAccent,item['id'],item['title']);

                          },),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
}
