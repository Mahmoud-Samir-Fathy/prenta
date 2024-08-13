import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printa/shared/styles/colors.dart';
import 'package:printa/view_model/change_mode/mode_cubit.dart';
import 'package:printa/view_model/prenta_layout/prenta_cubit.dart';
import 'package:printa/view_model/prenta_layout/prenta_states.dart';

class ActiveOrder extends StatelessWidget {
  const ActiveOrder({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<PrentaCubit, PrentaStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit=PrentaCubit.get(context);
        var onProcessingItems = cubit.onProcessingItems;

          return ConditionalBuilder(
            condition: onProcessingItems.isNotEmpty,
            builder: (context)=>ListView.separated(
              itemBuilder: (context, index) =>
                  buildActiveItem(onProcessingItems[index], context),
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: onProcessingItems.length,
            ),
            fallback: (context)=>const Center(child: Text('No items here')),
          );
      },
    );
  }

  Widget buildActiveItem(Map<String, dynamic> item, context) {
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
                        Row(
                          children: [
                            Text(item['title'] ?? 'Unknown Item'),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                PrentaCubit.get(context)
                                    .showCancelledOrderDialog(
                                    context, Colors.red,
                                    item['id'],item['title']); // Pass item['id'] as itemId
                              },
                              child: const Icon(
                                Icons.delete,
                                size: 25,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          item['description'] ?? 'No description',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Column(
                              children: [
                                Text('Qty(${item['quantity'] ?? 1})',
                                    style: const TextStyle(fontSize: 16)),
                                Text('${price * quantity + 50} L.E',
                                    style: const TextStyle(fontWeight: FontWeight.w700)),
                              ],
                            ),
                            const SizedBox(width: 30),
                            Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: ModeCubit.get(context).isDark?secondColor:firstColor,
                                  child: Text(item['size'] ?? 'N/A',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  radius: 16,
                                ),
                                Text(item['color'] ?? 'N/A')
                              ],
                            ),
                            const Spacer(),
                            Text('Processing',
                                style: TextStyle(
                                    color: ModeCubit.get(context).isDark?forthColor:Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
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