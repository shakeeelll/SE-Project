// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateProduct extends StatefulWidget {
  const CreateProduct({super.key});

  @override
  _CreateProductState createState() => _CreateProductState();
}

class _CreateProductState extends State<CreateProduct> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _discountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                  validator: (name) {
                    if (name == null || name.isEmpty) {
                      return 'Please enter product name.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'Price per unit',
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        double.parse(value) <= 0) {
                      return 'Price can\'t be negative';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  controller: _quantityController,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        double.parse(value) < 0) {
                      return 'Quantity can not be negative';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Describe your product.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  controller: _discountController,
                  decoration: InputDecoration(
                    labelText: 'Maximum discount',
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        double.parse(value) < 0 ||
                        double.parse(value) >
                            double.parse(_priceController.text)) {
                         return 'Discount can not be negative or greater than price';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _onPress();
                    }
                  },
                  child: Text('Save product'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onPress() async {
    try {
      final String name = _nameController.text;
      final String quantity = _quantityController.text;
      final String price = _priceController.text;
      final String description = _descriptionController.text;
      final String discount = _discountController.text;
      Map<String, String> data = {
        'name': name,
        'price': price,
        'quantity': quantity,
        'description': description,
        'discount': discount,
      };

      final url = Uri.parse('http://localhost:3022/api/add-product');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product added!'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add.'),
          ),
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
