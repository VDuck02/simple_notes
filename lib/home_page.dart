import 'package:flutter/material.dart';
import 'package:simple_notes/add_update_screen.dart';
import 'package:simple_notes/db_handler.dart';
import 'package:simple_notes/model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DBHelper? dbHelper;
  late Future<List<NoteModel>> dataList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    dbHelper = DBHelper();
    loadData();
  }

  loadData() async {
    dataList = dbHelper!.getDataList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text(
          'My Note',
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              letterSpacing: 1 //Khoảng cách giữa các chữ
              ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.help_outline_rounded, size: 30),
          )
        ],
      ),
      body: Container(
        color: Colors.white38,
        child: Column(
          children: [
            Expanded(
                child: FutureBuilder(
              future: dataList,
              builder: (context, AsyncSnapshot<List<NoteModel>> snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.data!.length == 0) {
                  return Center(
                    child: Text(
                      "No tasks Found",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        int noteId = snapshot.data![index].id!.toInt();
                        String noteTitle = snapshot.data![index].title.toString();
                        String noteDesc = snapshot.data![index].desc.toString();
                        String noteDT =
                            snapshot.data![index].dateandtime.toString();

                        return Dismissible(
                            key: ValueKey<int>(noteId),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              setState(() {
                                dbHelper!.delete(noteId);
                                dataList = dbHelper!.getDataList();
                                snapshot.data!.remove(snapshot.data![index]);
                              });
                            },
                            background: Container(
                              color: Colors.redAccent,
                              child:
                                  Icon(Icons.delete_forever, color: Colors.white),
                            ),
                            child: Container(
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 4,
                                        spreadRadius: 1)
                                  ]),
                              child: Column(
                                children: [
                                  ListTile(
                                    contentPadding: EdgeInsets.only(left: 10, right: 10),
                                    title: Padding(
                                      padding: EdgeInsets.only(bottom: 5),
                                      child: Text(
                                        noteTitle,
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    subtitle: Text(
                                      noteDesc,
                                      style: TextStyle(fontSize: 14, fontStyle: FontStyle.normal, color: Colors.black45),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,

                                    ),
                                  ),
                                  Divider(
                                    color: Colors.black,
                                    thickness: 0.2,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          noteDT,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.italic),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddUpdateNote(
                                                    noteId: noteId,
                                                    noteTitle: noteTitle,
                                                    noteDesc: noteDesc,
                                                    noteDT: noteDT,
                                                    update: true,
                                                  ),
                                                ));
                                          },
                                          child: Icon(
                                            Icons.edit_note_rounded,
                                            size: 28,
                                            color: Colors.black,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ));
                      },
                    ),
                  );
                }
              },
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 7, //
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50))
        ),
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddUpdateNote(),
              ));
        },
      ),
    );
  }
}
