
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {

  static const id = "DetailScreen";

  final Map<String, dynamic> payload;

  const DetailScreen({
    Key? key,
    required this.payload
  }) : super(key: key);

  @override
  State<DetailScreen> createState() {
    return _DetailScreen();
  }

}

class _DetailScreen extends State<DetailScreen> {
  late Map<String, dynamic> _payload;

  @override
  void initState() {
    super.initState();
    _payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Screen"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("${_payload["title"]}"),
            Text("${_payload["body"]}")
          ],
        ),
      ),
    );
  }


}
