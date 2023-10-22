import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class SalesReportPage extends StatefulWidget {
  @override
  _SalesReportPageState createState() => _SalesReportPageState();
}

class _SalesReportPageState extends State<SalesReportPage> {
  List<Map<String, dynamic>> salesData = [];

  @override
  void initState() {
    super.initState();
    _fetchSalesData();
  }

  Future<void> _fetchSalesData() async {
    try {
      final url = Uri.parse(
          'http://localhost:3022/api/sales-report?date=${DateFormat('yyyy-MM-dd').format(DateTime.now())}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<Map<String, dynamic>> dailySales =
            List<Map<String, dynamic>>.from(data['dailySales']);

        setState(() {
          salesData = dailySales;
        });
      } else {
        print('Failed to load sales report: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to load sales report: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report'),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Sales Report',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: salesData.length,
                itemBuilder: (context, index) {
                  return _buildSalesCard(index);
                },
              ),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 8.0, // Increased elevation for a 3D effect
              margin: EdgeInsets.symmetric(vertical: 8.0),
              color: Colors.grey[200], // Lighter color for the card
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Total Sales: ${calculateTotalSales()}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesCard(int index) {
    return Card(
      elevation: 8.0, // Increased elevation for a 3D effect
      margin: EdgeInsets.symmetric(vertical: 8.0),
      color: Colors.grey[200], // Lighter color for the card
      child: ListTile(
        title: Text(
          'Product: ${salesData[index]['productName'] ?? 'N/A'}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quantity: ${salesData[index]['quantity']}'),
            Text('Price per Unit: ${salesData[index]['pricePerUnit']}'),
            Text('Total Price: ${salesData[index]['totalPrice']}'),
            Text(
              'Sale Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(salesData[index]['saleDate']))}',
            ),
          ],
        ),
      ),
    );
  }

  double calculateTotalSales() {
    double totalSales = 0;
    for (var sale in salesData) {
      totalSales += sale['totalPrice'] ?? 0;
    }
    return totalSales;
  }
}
