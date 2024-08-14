import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:printa/models/favourite_model/favourite_model.dart';
import 'package:printa/models/product_model/product%20model.dart';
import 'package:printa/shared/components/components.dart';
import 'package:printa/view/product_details/product_details.dart';
import 'package:printa/view_model/change_mode/mode_cubit.dart';
import 'package:printa/view_model/prenta_layout/prenta_cubit.dart';
import 'package:printa/view_model/prenta_layout/prenta_states.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    PrentaCubit.get(context).getProductData();

    var cubit = PrentaCubit.get(context);
    cubit.requestFocus(); // Request focus when the screen is built

    return BlocConsumer<PrentaCubit, PrentaStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 30,),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Ionicons.chevron_back_outline),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: cubit.searchController,
                        focusNode: cubit.searchFocusNode,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Search query must not be empty';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          cubit.searchProduct(value);
                        },
                        decoration: const InputDecoration(
                          hintText: 'Search',
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        cubit.clearSearch();
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.separated(
                      itemBuilder: (context, index) =>
                          buildSearchItem(cubit.searchResults[index],context,FavouriteModel()),
                      separatorBuilder: (context, index) => const SizedBox(height: 1),
                      itemCount: cubit.searchResults.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget buildSearchItem(ProductModel product, context,FavouriteModel model) => GestureDetector(
  onTap: () {
    navigateTo(context, ProductDetails(product: product,model:model ,));
  },
  child: Padding(
    padding: const EdgeInsetsDirectional.symmetric(horizontal: 5),
    child: Card(
      color: ModeCubit.get(context).isDark ? Colors.grey[700] : Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0), // Adjust the radius as needed
            clipBehavior: Clip.antiAlias, // Smooth clipping
            child: Image.network(
              product.image!,
              width: 100,
              height: 100,
              fit: BoxFit.cover, // Ensures the image fits well within the container
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title!,
                    style: const TextStyle(fontSize: 22),
                  ),
                  Text(
                    product.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Spacer(),
                      Text('Price: ${product.price.toString()}'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  ),
);
