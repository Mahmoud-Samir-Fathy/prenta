import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ionicons/ionicons.dart';
import 'package:printa/shared/components/components.dart';
import 'package:printa/shared/styles/colors.dart';
import 'package:printa/view_model/prenta_layout/prenta_cubit.dart';
import 'package:printa/view_model/prenta_layout/prenta_states.dart';

class CheckOut extends StatefulWidget {
  const CheckOut({Key? key}) : super(key: key);

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  @override
  void initState() {
    super.initState();
    // Load cart items from the cubit
    BlocProvider.of<PrentaCubit>(context).loadCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PrentaCubit, PrentaStates>(
      listener: (context, state) {
        // Optional: Handle any state changes
      },
      builder: (context, state) {
        final cartItems = BlocProvider.of<PrentaCubit>(context).cartItems;

        return Scaffold(
          backgroundColor: HexColor('FCFCFC'),
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(Ionicons.chevron_back_outline),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              'Checkout',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: Column(
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
                                      BlocProvider.of<PrentaCubit>(context).increaseQuantity(item['title']);
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
                                      BlocProvider.of<PrentaCubit>(context).decreaseQuantity(item['title']);
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
                                      BlocProvider.of<PrentaCubit>(context).removeFromCart(item['title']);
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
              // ... Remaining layout for totals and checkout button
            ],
          ),
        );
      },
    );
  }
}
