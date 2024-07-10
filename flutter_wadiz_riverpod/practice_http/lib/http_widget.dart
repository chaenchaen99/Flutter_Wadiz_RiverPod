import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:practice_http/main.dart';

class HttpWidget extends StatefulWidget {
  const HttpWidget({super.key});

  @override
  State<HttpWidget> createState() => _HttpWidgetState();
}

class _HttpWidgetState extends State<HttpWidget> {
  String responseText = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Center(
          child: Text("HTTP Practice"),
        ),
        TextButton(
          onPressed: () async {
            final response = await http.get(Uri.parse(api));
            if (response.statusCode == 200) {
              setState(() {
                responseText = response.body;
              });
            }
          },
          child: const Text("Http get"),
        ),
        TextButton(
          onPressed: () async {
            final response = await http.post(
              Uri.parse(api),
              headers: {
                'content-type': "application/json; charset=UTF-8",
              },
              body: jsonEncode(
                {
                  "title": "foo",
                  "body": 'bar',
                  "userId": 1,
                },
              ),
            );
            if (response.statusCode == 201) {
              setState(() {
                responseText = response.body;
              });
            }
          },
          child: const Text("Http post"),
        ),
        TextButton(
          onPressed: () async {
            await http
                .put(
              Uri.parse("$api/1"),
              headers: {
                'content-type': "application/json; charset=UTF-8",
              },
              body: jsonEncode(
                {
                  "title": "foo",
                  "body": 'bar',
                  "userId": 1,
                },
              ),
            )
                .then((value) {
              if (value.statusCode == 201) {
                setState(() {
                  responseText = value.body;
                });
              }
            });
          },
          child: const Text("Http put"),
        ),
        TextButton(
          onPressed: () {
            http.delete(Uri.parse("$api/1")).then(
              (response) {
                if (response.statusCode == 200) {
                  responseText = "삭제성공";
                }
              },
            );
          },
          child: const Text("Http delete"),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Text(responseText),
          ),
        ),
      ],
    );
  }
}