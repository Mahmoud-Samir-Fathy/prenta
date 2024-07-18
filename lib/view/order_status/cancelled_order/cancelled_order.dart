import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printa/shared/styles/colors.dart';
import 'package:printa/view_model/prenta_layout/prenta_cubit.dart';
import 'package:printa/view_model/prenta_layout/prenta_states.dart';

class CancelledOrder extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    context.read<PrentaCubit>().getCancelledItems();

    return BlocConsumer<PrentaCubit, PrentaStates>(
      listener: (context,state){},
      builder: (context, state) {
        if (state is PrentaGetCancelledItemsLoadingState) {
          return Center(child: CircularProgressIndicator());
        }
        else if (state is PrentaGetCancelledItemsSuccessState) {
          final cancelledItems = state.items;
          if (cancelledItems.isEmpty) {
            return Center(child: Text('No processing items found.'));
          }
          return ListView.separated(
            itemBuilder: (context, index) => buildActiveItem(cancelledItems[index]),
            separatorBuilder: (context, index) => SizedBox(height: 10),
            itemCount: cancelledItems.length,
          );
        }
        else if (state is PrentaGetCancelledItemsErrorState) {
          return Center(child: Text('Error: ${state.error}'));
        } else {
          return Center(child: Text('Unexpected state'));
        }
      },
    );
  }

  Widget buildActiveItem(Map<String, dynamic> item) => Container(
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
              SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(item['title'] ?? 'Unknown Item'),
                      Text(item['description'] ?? 'No description',maxLines: 1,overflow: TextOverflow.ellipsis,),
                      Spacer(),
                      Row(
                        children: [
                          Column(
                            children: [
                              Text('Qty(${item['quantity'] ?? 1})', style: TextStyle(fontSize: 16)),
                              Text('${item['price'] ?? 0} L.E', style: TextStyle(fontWeight: FontWeight.w700)),
                            ],
                          ),
                          SizedBox(width: 30),
                          Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: firstColor,
                                child: Text(item['size'] ?? 'N/A', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                radius: 16,
                              ),
                              Text(item['color'] )
                            ],
                          ),
                          Spacer(),
                          TextButton(child:Text('Re-order', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),onPressed: (){},),
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