import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_pra/add_book_page.dart';
import 'package:firebase_pra/login_page.dart';
import 'package:flutter/material.dart';

class BookListPage extends StatelessWidget {
  BookListPage(this.user);
  final User user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('本一覧'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              await Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) {
                  return LoginPage();
                }),
              );
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('books')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          if (snapshot.connectionState == ConnectionState.waiting)
            return Text('loading...');
          return ListView(
              children: snapshot.data.docs.map((doc) {
            return Dismissible(
              key: Key(doc.data()['title']),
              onDismissed: (direction) {
                // Remove the item from the data source.
                doc.reference.delete();
                // Then show a snackbar.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("delete")),
                );
              },
              background: Container(color: Colors.red),
              child: ListTile(
                title: Text(doc.data()['title']),
                subtitle: Text(doc.data()['createdAt'].toDate().toString()),
              ),
            );
          }).toList());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddBookPage(user.uid)),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
