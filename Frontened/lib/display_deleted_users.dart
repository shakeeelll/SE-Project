import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:se_project/models/deletedUser.dart';

class DeletedUsersScreen extends StatefulWidget {
  const DeletedUsersScreen({Key? key}) : super(key: key);

  @override
  _DeletedUsersScreenState createState() => _DeletedUsersScreenState();
}

class _DeletedUsersScreenState extends State<DeletedUsersScreen> {
  List<DeletedUser> deletedUsers = [];

  @override
  void initState() {
    super.initState();
    fetchDeletedUsers();
  }

  Future<void> fetchDeletedUsers() async {
    try {
      final url = Uri.parse('http://localhost:3022/api/deletedUsers');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body.toString());
        setState(() {
          jsonResponse.forEach((element) {
            deletedUsers.add(DeletedUser.fromJson(element));
          });
        });
      } else {
        throw Exception('Failed to load deleted users: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching deleted users: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deleted Users'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: deletedUsers.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: ${deletedUsers[index].fName}',
                    ),
                    Text('Last Name: ${deletedUsers[index].lName}'),
                    Text('Email: ${deletedUsers[index].email}'),
                    Text('Deleted At: ${deletedUsers[index].deletedAt}'),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
