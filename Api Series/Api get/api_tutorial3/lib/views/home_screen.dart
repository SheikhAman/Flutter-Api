import 'dart:convert';

import 'package:api_tutorial3/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<UserModel> userList = [];
  Future<List<UserModel>> getUsersApi() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
    var data = jsonDecode(response.body);
    print(data);
    userList.clear();
    if (response.statusCode == 200) {
      for (Map<String, dynamic> i in data) {
        userList.add(UserModel.fromJson(i));
      }
      return userList;
    } else {
      return userList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Api tutorial 3'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getUsersApi(),
              builder: (context, AsyncSnapshot<List<UserModel>> snapshot) {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      print(' fdfdfdf ${snapshot.data!.length}');
                      if (!snapshot.hasData) {
                        return const Text('Loading....');
                      } else {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                ReuseableRow(
                                  title: 'Name',
                                  value: snapshot.data![index].name.toString(),
                                ),
                                ReuseableRow(
                                  title: 'Username',
                                  value:
                                      snapshot.data![index].username.toString(),
                                ),
                                ReuseableRow(
                                  title: 'Email',
                                  value: snapshot.data![index].email.toString(),
                                ),
                                ReuseableRow(
                                  title: 'Address',
                                  value:
                                      snapshot.data![index].address!.city.toString(),
                                )
                              ],
                            ),
                          ),
                        );
                      }
                    });
              },
            ),
          )
        ],
      ),
    );
  }
}

class ReuseableRow extends StatelessWidget {
  String title;
  String value;
  ReuseableRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(value),
        ],
      ),
    );
  }
}
