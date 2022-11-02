import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/photo_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Photos> photoList = [];

  Future<List<Photos>> getApi() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));
    var data = jsonDecode(response.body);
    photoList.clear();
    if (response.statusCode == 200) {
      for (Map i in data) {
        // object er parameter e map er value rakhlam
        Photos photos = Photos(
          title: i['title'],
          url: i['url'],
          thumbnailUrl: i['thumbnailUrl'],
          id: i['id'],
        );
        photoList.add(photos);
      }
      return photoList;
    } else {
      return photoList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Api tutorial 2'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getApi(),
              builder: (context, AsyncSnapshot<List<Photos>> snapshot) {
                if (!snapshot.hasData) {
                  return Text('Loading....');
                } else {
                  return ListView.builder(
                      itemCount: photoList.length,
                      itemBuilder: (context, index) {
                        print(photoList[index].url);
                        return ListTile(
                          title: Text('Notes id:' +
                              snapshot.data![index].id.toString()),
                          leading: CircleAvatar(
                            child: Image.network(
                              snapshot.data![index].url.toString(),
                              fit: BoxFit.cover,
                              height: 15,
                              width: 15,
                            ),
                          ),

                          subtitle:
                              Text(snapshot.data![index].title.toString()),
                          // trailing: Image.network(snapshot.data![index].url),
                        );
                      });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
