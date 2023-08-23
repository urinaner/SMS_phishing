import 'package:flutter/material.dart';
import 'package:sms_receiver_channel/platform_channel.dart';
import 'dart:convert' as convert;
import 'dart:convert';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String sms = 'No SMS';
  String status = '';
  String url = '';
  @override
  void initState() {
    super.initState();
    PlatformChannel().receiveSms().then((value) async {
      sms = value;
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      var url = Uri.http('10.0.2.2:8000', '/check-sms/');
      var response = await http.post(
        url,
        headers: headers,
        body: json.encode({
          "sms_text": sms,
        }),
      );

      if (response.statusCode == 200) {
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        //메세지 오면 위에 주소로 요청해서 정보값 받아오기
        print(jsonResponse['results'][0]['status']);
        status = jsonResponse['results'][0]['status'];
        // url = jsonResponse['results'][0]['url'];
        print('Number of books about http: $sms.');
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Incoming message :',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent),
            ),
            const SizedBox(height: 10),
            Text(
              sms,
              style: const TextStyle(fontSize: 18, color: Colors.black54),
            ),
            Text(
              url,
              style: const TextStyle(fontSize: 40, color: Colors.blue),
            ),
            Text(
              status,
              style: const TextStyle(fontSize: 40, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
