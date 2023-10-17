import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ViewAllProduct extends StatefulWidget {
  const ViewAllProduct({Key? key}) : super(key: key);

  @override
  _ViewAllProductState createState() => _ViewAllProductState();
}

class _ViewAllProductState extends State<ViewAllProduct> {
  List<Map<String, dynamic>> data = [];
  List<bool> isEditing = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final url = Uri.parse('http://localhost:3022/api/products');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          data = jsonResponse.cast<Map<String, dynamic>>();
          isEditing = List<bool>.filled(data.length, false);
        });
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  Future<void> deleteProduct(int index) async {
    try {
      final productId = data[index]['_id'];
      final url = Uri.parse('http://localhost:3022/api/products/$productId');
      final response = await http.delete(url);

      if (response.statusCode == 204) {
        setState(() {
          data.removeAt(index);
          isEditing.removeAt(index);
        });
      } else {
        throw Exception('Failed to delete product: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting product: $error');
    }
  }

  Future<void> updateProduct(int index) async {
    try {
      final productData = data[index];
      final url = Uri.parse('http://localhost:3022/api/products/${productData['_id']}');
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'price': productData['price'],
          'discount': productData['discount'],
          'quantity': productData['quantity'],
          'description': productData['description'],
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          isEditing[index] = false;
        });
      } else {
        throw Exception('Failed to edit product: ${response.statusCode}');
      }
    } catch (error) {
      print('Error editing product: $error');
    }
  }

  void toggleEditing(int index) {
    setState(() {
      isEditing[index] = !isEditing[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _buildProductCard(index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-product');
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildProductCard(int index) {
    return Card(
      elevation: 4.0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildField('Price', 'price', index),
            _buildField('Max Discount', 'discount', index),
            _buildField('Stock', 'quantity', index),
            _buildField('Description', 'description', index),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => deleteProduct(index),
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 240, 110, 110),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (isEditing[index]) {
                      updateProduct(index);
                    }
                    toggleEditing(index);
                  },
                  icon: Icon(isEditing[index] ? Icons.save : Icons.edit),
                  label: Text(isEditing[index] ? 'Save' : 'Edit'),
                  style: ElevatedButton.styleFrom(
                    primary: isEditing[index] ? Colors.greenAccent : Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, String field, int index) {
    return isEditing[index]
        ? TextFormField(
            initialValue: data[index][field].toString(),
            onChanged: (value) {
              data[index][field] = value;
            },
            decoration: InputDecoration(
              labelText: label,
            ),
          )
        : Text(
            '$label: ${data[index][field]}',
            style: const TextStyle(fontSize: 16),
          );
  }
}
