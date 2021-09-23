import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController = new TextEditingController();

  late QuerySnapshot searchSnapshot;

  initiateSearch(){
    databaseMethods
        .getUserByUsername(searchTextEditingController.text)
        .then((val) {
      setState(() { searchSnapshot = val; });
    });
  }

  Widget searchList() {
    return searchSnapshot!= null ? ListView.builder(
        itemCount: searchSnapshot.docs.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final _searchSnapshot = searchSnapshot.docs[index].data() as Map<String, dynamic>;
          return SearchTile(
            //TODO: controlla che funzioni
              userName:  _searchSnapshot['name'],
              userEmail: _searchSnapshot['email']
          );
        }) : Container();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Color(0x54000000),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                        controller: searchTextEditingController,
                        style: TextStyle(
                          color: Colors.white
                        ),
                        decoration: InputDecoration(
                          hintText: "search username...",
                          hintStyle: TextStyle(
                            color:Colors.white54
                          ),
                          border: InputBorder.none
                        ),
                      )
                  ),
                  GestureDetector(
                    onTap: () async {
                      await initiateSearch();
                    },
                    child: Container(
                      height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0x36FFFFFF),
                              const Color(0x0FFFFFFF)
                            ]
                          ),
                          borderRadius: BorderRadius.circular(40)
                        ),
                        padding: EdgeInsets.all(8),
                        child: Image.asset("assets/images/search_white.png")
                    ),
                  )
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}

class SearchTile extends StatelessWidget {

  final String userName;
  final String userEmail;
  SearchTile({required this.userName, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Column(
            children: [
              Text(userName, style: simpleTextStyle(),),
              Text(userEmail, style: simpleTextStyle(),)
            ],
          ),
          Spacer(),
          Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(30)
            ),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Text("Message"),
          )
        ],
      ),
    );
  }
}

