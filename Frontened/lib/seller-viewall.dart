import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const _primaryColor = Color.fromARGB(255, 55, 48, 90);
const _accentColor = Color(0xFFF44336);
const _textColor = Color.fromARGB(255, 0, 0, 0);



class ResponsiveProductTable extends StatefulWidget {
  @override
  _ResponsiveProductTableState createState() => _ResponsiveProductTableState();
}

class _ResponsiveProductTableState extends State<ResponsiveProductTable> {
  List<dynamic> products = [];
  String searchTerm = '';
  bool isFilteredByPrice = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final url = Uri.parse('http://localhost:3022/api/products');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        setState(() {
          products = jsonResponse;
        });
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching products: $error');
    }
  }

  void _onSearchTextChanged(String text) {
    setState(() {
      searchTerm = text;
    });
  }

  void _onFilterByPriceChanged(bool value) {
    setState(() {
      isFilteredByPrice = value;
    });
  }

  List<dynamic> _filterProducts() {
    if (isFilteredByPrice) {
      return products.where((product) => product['price'] >= 1).toList();
    } else {
      return products;
    }
  }

  List<dynamic> _searchProducts(String searchTerm) {
    return _filterProducts().where((product) {
      return product['name'].toLowerCase().contains(searchTerm.toLowerCase()) ||
          product['description']
              .toLowerCase()
              .contains(searchTerm.toLowerCase());
    }).toList();
  }

  TextEditingController _feedbackController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Products'),
        backgroundColor: _primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductSearchDelegate(
                  products: _searchProducts(searchTerm),
                  onSearchTextChanged: _onSearchTextChanged,
                ),
              );
            },
          ),
          Switch(
            value: isFilteredByPrice,
            activeColor: _accentColor,
            onChanged: _onFilterByPriceChanged,
          )
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 600) {
            return _buildDesktopTable(context);
          } else {
            return _buildMobileTable(context);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFeedbackDialog();
        },
        tooltip: 'Leave Feedback',
        child: Icon(Icons.feedback),
      ),
    );
  }

  void _showFeedbackDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Leave Feedback'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
              Container(
                height:
                    30, // Adjust the height based on your spacing preference
              ),
              TextField(
                controller: _feedbackController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Feedback',
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Send the feedback to the backend
                _sendFeedbackToAdmin(
                    _feedbackController.text, _nameController.text);
                Navigator.of(context).pop();
              },
              child: Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _sendFeedbackToAdmin(String feedback, String name) async {
    // Call your backend API to store the feedback in the database
    try {
      final url = Uri.parse('http://localhost:3022/api/feedback');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'feedback': feedback, 'name': name}),
      );

      if (response.statusCode == 200) {
        print('Feedback submitted successfully!');
        // You can add further logic based on the response
      } else {
        print('Failed to submit feedback: ${response.statusCode}');
      }
    } catch (error) {
      print('Error submitting feedback: $error');
    }
  }

  Widget _buildDesktopTable(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('Name', style: TextStyle(color: _textColor)),
              tooltip: 'The product name',
            ),
            DataColumn(
              label: Text('Price', style: TextStyle(color: _textColor)),
              numeric: true,
            ),
            DataColumn(
              label: Text('Discount', style: TextStyle(color: _textColor)),
              numeric: true,
            ),
            DataColumn(
              label: Text('stock', style: TextStyle(color: _textColor)),
              numeric: true,
            ),
            DataColumn(
              label: Text('Description', style: TextStyle(color: _textColor)),
              tooltip: 'The product description',
            ),
            DataColumn(
              label: Text('Action', style: TextStyle(color: _textColor)),
            ),
          ],
          rows: _buildDesktopTableRows(),
        ),
      ),
    );
  }

  List<DataRow> _buildDesktopTableRows() {
    final filteredProducts = _searchProducts(searchTerm);

    return filteredProducts.map((product) {
      return DataRow(
        cells: [
          DataCell(Text(product['name'])),
          DataCell(Text('${product['price'].toStringAsFixed(2)}')),
          DataCell(Text('${product['discount']}')),
          DataCell(Text('${product['quantity']}')),
          DataCell(Text(product['description'])),
          DataCell(
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    _sellProduct(product);
                  },
                ),
                // Add more icons/buttons as needed
              ],
            ),
          ),
        ],
      );
    }).toList();
  }

  Widget _buildMobileTable(BuildContext context) {
    final filteredProducts = _searchProducts(searchTerm);

    return ListView.builder(
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];

        return Card(
          elevation: 4.0,
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'],
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Text('Price: ${product['price'].toStringAsFixed(2)}'),
                Text('Discount: ${product['discount']}'),
                Text('Stock: ${product['quantity']}'),
                Text('Description: ${product['description']}'),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.shopping_cart),
                      onPressed: () {
                        _sellProduct(product);
                      },
                    ),
                    // Add more icons/buttons as needed
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _sellProduct(dynamic product) {
    showDialog(
      context: context,
      builder: (context) {
        int quantity = 1;
        double price = product['price'];

        return AlertDialog(
          title: Text('${product['name']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Available Quantity: ${product['quantity']}'),
              SizedBox(height: 16.0),
              Text('Enter Quantity to Sell:'),
              SizedBox(height: 8.0),
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  quantity = int.parse(value);
                },
              ),
              SizedBox(height: 16.0),
              Text('Enter Price:'),
              SizedBox(height: 8.0),
              TextFormField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  price = double.parse(value);
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (product != null && quantity <= (product['quantity'])) {
                  // Call API to update stock and generate invoice
                  _updateStockAndGenerateInvoice(product, quantity, price);
                  Navigator.of(context).pop();
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Text('Sell'),
            ),
          ],
        );
      },
    );
  }

  void _updateStockAndGenerateInvoice(
      dynamic product, int quantity, double price) async {
    try {
      final url = Uri.parse('http://localhost:3022/api/sale/${product['_id']}');
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'quantity': quantity,
        }),
      );


      if (response.statusCode == 200) {
        print('totalPrice: ${quantity * price}');
      } else {
        print('Failed to sell product: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other errors
      print('Error selling product: $error');
    }
  }
}

class ProductSearchDelegate extends SearchDelegate<List<dynamic>> {
  final List<dynamic> products;
  final Function(String) onSearchTextChanged;

  ProductSearchDelegate(
      {required this.products, required this.onSearchTextChanged});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          onSearchTextChanged('');
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onSearchTextChanged(query);
    return Container(); // Results are shown in the main widget
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ListTile(
          title: Text(product['name']),
          onTap: () {
            query = product['name'];
            onSearchTextChanged(query);
            close(context,
                products); // Pass the updated list back to the main widget
          },
        );
      },
    );
  }
}
