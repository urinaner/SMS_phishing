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
  String sms = '문자가 없어요';
  String status = '';
  String url = '';
  String delete = '';
  String message = '';

  @override
  void initState() {
    super.initState();
    PlatformChannel().receiveSms().then((value) async {
      sms = value;
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      var url = Uri.https('db91-203-232-224-243.ngrok-free.app', '/check-sms/');
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
        // delete = '삭제하시겠습니까?';
        print(jsonResponse['result']);
        status = jsonResponse['result'];
        // url = jsonResponse['results'][0]['url'];
        if (status == 'malicious') {
          delete = '들어가면 ㅈ됨';
          message = '삭제하시겠습니까?';
        } else if (status == 'caution') {
          delete = '들어가면 주읫됨';
          message = '삭제하시겠습니까?';
        } else if (status == 'attention') {
          delete = 'ㄱㅊ음';
        } else if (status == 'safe') {
          delete = '야미';
        } else {
          delete = '알수없음';
        }

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
              '수신메세지 :',
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
            const SizedBox(
              height: 30,
            ),
            Text(
              delete,
              style: const TextStyle(fontSize: 50, color: Colors.red),
            ),
            Text(
              message,
              style: const TextStyle(fontSize: 50, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
