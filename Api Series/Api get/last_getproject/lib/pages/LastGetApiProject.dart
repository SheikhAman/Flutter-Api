import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:last_getproject/models/products_model.dart';
import 'package:flutter/src/widgets/image.dart' as img;

class LastGetApiProject extends StatefulWidget {
  const LastGetApiProject({super.key});

  @override
  State<LastGetApiProject> createState() => _LastGetApiProjectState();
}

class _LastGetApiProjectState extends State<LastGetApiProject> {
  Future<ProductsModel> getProductsApi() async {
    final response = await http.get(
        Uri.parse('https://webhook.site/277716a7-7d97-4dfa-96b8-b00c7dc897f8'));
    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      print(data);
      return ProductsModel.fromJson(data);
    } else {
      return ProductsModel.fromJson(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('LastGEtApiProject'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<ProductsModel>(
              future: getProductsApi(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.data!.length,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(snapshot.data!.data![index].shopaddress
                                .toString()),
                            subtitle: Text(snapshot.data!.data![index].shopemail
                                .toString()),
                            leading: CircleAvatar(
                                backgroundImage: NetworkImage(snapshot
                                    .data!.data![index].image
                                    .toString())),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: MediaQuery.of(context).size.width * 1,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.data![index]
                                  .products![index].images!.length,
                              itemBuilder: (context, position) {
                                return Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        snapshot
                                            .data!
                                            .data![index]
                                            .products![index]
                                            .images![position]
                                            .url
                                            .toString(),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'FileName $position: ' +
                                        snapshot
                                            .data!
                                            .data![index]
                                            .products![index]
                                            .images![position]
                                            .filename
                                            .toString(),
                                  ),
                                );
                              },
                            ),
                          ),
                          Icon(snapshot.data!.data![index].products![index]
                                      .inWishlist ==
                                  true
                              ? Icons.favorite
                              : Icons.favorite_outline),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
