import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_notes/db_handler.dart';
import 'package:simple_notes/home_page.dart';

import 'model.dart';

class AddUpdateNote extends StatefulWidget {
  AddUpdateNote(
      {super.key,
      this.noteId,
      this.noteTitle,
      this.noteDesc,
      this.noteDT,
      this.update});

  int? noteId;
  String? noteTitle;
  String? noteDesc;
  String? noteDT;
  bool? update;

  @override
  State<AddUpdateNote> createState() => _AddUpdateNoteState();
}

class _AddUpdateNoteState extends State<AddUpdateNote> {
  DBHelper? dbHelper;
  late Future<List<NoteModel>> dataList;

  final _fromKey = GlobalKey<FormState>();

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
    final titleController = TextEditingController(text: widget.noteTitle);
    final descController = TextEditingController(text: widget.noteDesc);
    String appTitle;
    if (widget.update == true) {
      appTitle = 'Update note';
    } else {
      appTitle = 'Add Note';
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            appTitle,
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
        body: Padding(
          padding: EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Form(
                  key: _fromKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          controller: titleController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Note title',
                              hintStyle: TextStyle(color: Colors.black54, fontSize: 15)),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter some text";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 14),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          minLines: 5,
                          controller: descController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Write notes here',
                              hintStyle: TextStyle(color: Colors.black54, fontSize: 15)),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter some text";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  )),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (_fromKey.currentState!.validate()) {
                          if (widget.update == true) {
                            await dbHelper!.update(
                              NoteModel(
                                  id: widget.noteId,
                                  title: titleController.text,
                                  dateandtime: widget.noteDT,
                                  desc: descController.text),
                            );
                          } else {
                            await dbHelper!.insert(NoteModel(
                                title: titleController.text,
                                desc: descController.text,
                                dateandtime: DateFormat('yMd')
                                    .add_jm()
                                    .format(DateTime.now())
                                    .toString()));
                          }

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(),
                              ));
                          titleController.clear();
                          descController.clear();
                        }
                      },
                      child: Text(widget.update == true ? ' Update' : 'Add Note'),
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)))),
                    ),
                    const SizedBox(width: 12),
                    Visibility(
                      visible: widget.update != true,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            titleController.clear();
                            descController.clear();
                          });
                        },
                        child: const Text('Clear'),
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)))),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
