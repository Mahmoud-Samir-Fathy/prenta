import 'package:cloud_firestore/cloud_firestore.dart';
import 'product model.dart';

class ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Product>> fetchProducts() async {
    QuerySnapshot snapshot = await _firestore.collection('products').get();
    return snapshot.docs.map((doc) {
      return Product.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }
}
