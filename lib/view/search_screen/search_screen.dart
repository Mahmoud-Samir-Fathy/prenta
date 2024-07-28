import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:printa/models/product_model/product%20model.dart';
import 'package:printa/view_model/prenta_layout/prenta_cubit.dart';
import 'package:printa/view_model/prenta_layout/prenta_states.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cubit = PrentaCubit.get(context);
    cubit.requestFocus(); // Request focus when the screen is built

    return BlocConsumer<PrentaCubit, PrentaStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 30,),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Ionicons.chevron_back_outline),
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
                        decoration: InputDecoration(
                          hintText: 'Search',
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        cubit.clearSearch();
                      },
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.separated(
                      itemBuilder: (context, index) =>
                          buildSearchItem(cubit.searchResults[index]),
                      separatorBuilder: (context, index) => SizedBox(height: 10),
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

Widget buildSearchItem(ProductModel model) => Padding(
  padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
  child: Card(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.network(model.image!, width: 100, height: 100),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(model.title!, style: TextStyle(fontSize: 22)),
              Text(
                '${model.description!}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Spacer(),
                  Text('Price: ${model.price.toString()}'),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  ),
);
