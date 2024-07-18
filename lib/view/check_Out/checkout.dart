import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ionicons/ionicons.dart';
import 'package:printa/shared/components/components.dart';
import 'package:printa/shared/styles/colors.dart';
import 'package:printa/view/homeScreen/homescreen.dart';
import 'package:printa/view/layout/prenta_layout.dart';
import 'package:printa/view_model/prenta_layout/prenta_cubit.dart';
import 'package:printa/view_model/prenta_layout/prenta_states.dart';

class CheckOut extends StatelessWidget {

  const CheckOut({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.microtask(() => BlocProvider.of<PrentaCubit>(context).loadCartItems());

    return BlocConsumer<PrentaCubit, PrentaStates>(
      listener: (context, state) {
        if (state is CartCheckedOutState) {
          // Navigate to a confirmation screen or show a success message
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Checkout successful!'))
          );

        } else if (state is CartCheckoutErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Checkout failed. Please try again.'))
          );
        }
      },
      builder: (context, state) {
        final cubit = PrentaCubit.get(context);
        final cartItems = cubit.cartItems;

        return Scaffold(
          backgroundColor: HexColor('FCFCFC'),
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(Ionicons.chevron_back_outline),
              onPressed: () {
                navigateTo(context, PrentaLayout());
              },
            ),
            title: Text(
              'Checkout',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: cartItems.isEmpty
              ? Center(child: Text('Your cart is empty.'))
              : Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: cartItems.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: HexColor('FFFFFF'),
                        child: ListTile(
                          leading: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(item['image']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(item['title']),
                              Spacer(),
                              Text(item['color']),
                              SizedBox(width: 15),
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: firstColor,
                                child: Text(
                                  '${item['size']}',
                                  style: TextStyle(fontSize: 15, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${item['price']} EG'),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      cubit.increaseQuantity(item['id']);
                                    },
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Icon(Icons.add, size: 20),
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  Text('${item['quantity']}'),
                                  SizedBox(width: 6),
                                  GestureDetector(
                                    onTap: () {
                                      cubit.decreaseQuantity(item['id']);
                                    },
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Icon(Icons.remove, size: 20),
                                    ),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      cubit.removeFromCart(item['id']);
                                      },
                                    child: Icon(
                                      Icons.delete,
                                      size: 25,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sub total',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${cubit.calculateSubtotal()} LE',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Shipping',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '50 LE', // Assuming fixed shipping cost
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${cubit.calculateTotalWithShipping()} LE', // Adding shipping cost to total
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: defaultMaterialButton(
                    text: 'Check out',
                    Function: () {
                      cubit.showCheckOutDialog(context, cubit.isDark ? Colors.white : firstColor);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}