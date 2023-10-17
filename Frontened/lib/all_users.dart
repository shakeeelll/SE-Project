import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DataDisplayScreen extends StatefulWidget {
  @override
  _DataDisplayScreenState createState() => _DataDisplayScreenState();
}

class _DataDisplayScreenState extends State<DataDisplayScreen> {
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final url = Uri.parse('http://localhost:3022/api/signup');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          data = jsonResponse.cast<Map<String, dynamic>>();
        });
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  Future<void> deleteUserData(int index) async {
    try {
      final userId = data[index]['_id']; // Assuming '_id' is the user ID field
      final url = Uri.parse('http://localhost:3022/api/signup/$userId');
      final response = await http.delete(url);

      if (response.statusCode == 204) {
        // User deleted successfully, update the UI
        setState(() {
          data.removeAt(index);
        });
      } else {
        throw Exception('Failed to delete user: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting user: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _buildUserCard(index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/signup');
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildUserCard(int index) {
    return Card(
      elevation: 4.0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfo('Name: ${data[index]['f_name']}'),
            _buildUserInfo('Email: ${data[index]['email']}'),
            _buildUserInfo('Password: ${data[index]['password']}'),
            _buildUserInfo('Role: ${data[index]['Role']}'),
            ElevatedButton.icon(
              onPressed: () => deleteUserData(index),
              icon: Icon(Icons.delete),
              label: Text('Delete'),
              style: ElevatedButton.styleFrom(
                primary: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 16),
    );
  }
}
