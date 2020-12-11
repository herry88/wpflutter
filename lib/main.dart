import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(new MaterialApp(
    home: MyApp(),
    title: "BelajarFlutter",
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //BaseURL
  final String apiUrl = "https://belajarflutter.com/wp-json/wp/v2/";
  List posts;

  //function to fetch list
  Future<String> getPosts() async {
    var res = await http.get(Uri.encodeFull(apiUrl + "posts?_embed"),
        headers: {"Accept": "application/json"});

    //fill our post
    setState(() {
      var resBody = json.decode(res.body);
      posts = resBody;
    });

    return "Success!";
  }

  void initState() {
    super.initState();
    this.getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Test Api"),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: posts == null ? 0 : posts.length,
        itemBuilder: (BuildContext context, int index) {
          return new Column(
            children: [
              new Card(
                child: Column(
                  children: [
                    new Image.network(posts[index]["_embedded"]
                        ["wp:featuredmedia"][0]["source_url"]),
                    new Padding(

                      padding: EdgeInsets.all(10.0),
                      child: new ListTile(
                        title: new Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: new Text(
                            posts[index]["title"]["rendered"],
                          ),
                        ),
                        subtitle: new Text(
                          posts[index]["excerpt"]["rendered"]
                              .replaceAll(new RegExp(r'<[^>]*>'), ''),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
