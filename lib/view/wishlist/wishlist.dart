import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:printa/view_model/prenta_layout/prenta_cubit.dart';
import 'package:printa/view_model/prenta_layout/prenta_states.dart';

class Wishlist extends StatelessWidget {
  const Wishlist({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PrentaCubit, PrentaStates>(
      listener: (context, state) {
        if (state is PrentaDeleteFavouriteItemSuccessState) {
          // Optionally show a success message or refresh the list
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Item removed from wishlist')),
          );
        } else if (state is PrentaDeleteFavouriteItemErrorState) {
          // Optionally show an error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to remove item from wishlist')),
          );
        }
      },
      builder: (context, state) {
        var cubit = PrentaCubit.get(context);
        final wishlistItems = cubit.getFavourite;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text('Wishlist'),
            centerTitle: true,
            elevation: 0.0,
            actions: [
              IconButton(
                icon: Icon(Ionicons.search),
                onPressed: () {},
              ),
            ],
          ),
          body: wishlistItems.isEmpty
              ? Center(child: Text('No items in wishlist'))
              : ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 25),
            itemCount: wishlistItems.length,
            itemBuilder: (context, index) {
              final item = wishlistItems[index];
              return Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.network(item!.productImage!, width: 100, height: 100),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.productTittle!, style: TextStyle(fontSize: 22)),
                                Text('${item.productDescription!}', maxLines: 2, overflow: TextOverflow.ellipsis),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Spacer(),
                                    Text('Price: ${item.productPrice.toString()}'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Call the delete function with the correct product
                      cubit.deleteFavouriteItem(model: item);
                    },
                    icon: Icon(Icons.cancel),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
