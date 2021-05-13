import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddBookPage extends StatefulWidget {
  AddBookPage(this.uid);
  final String uid;
  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _titleTextController = TextEditingController();
  bool _isComposing = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('追加'),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'タイトル',
                border: InputBorder.none,
                hintText: 'Flutter 入門',
              ),
              controller: _titleTextController,
              onChanged: (String text) {
                setState(() {
                  _isComposing = text.isNotEmpty;
                });
              },
            ),
            ElevatedButton(
              onPressed: _isComposing
                  ? () async {
                      CollectionReference books = FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.uid)
                          .collection('books');
                      DocumentReference value = await books.add({
                        'title': _titleTextController.text,
                        'createdAt': DateTime.now()
                      });
                      print(value);
                      Navigator.pop(context);
                    }
                  : null,
              child: Text('追加'),
            )
          ],
        ),
      ),
    );
  }
}
