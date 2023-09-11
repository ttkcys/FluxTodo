import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewData extends StatefulWidget {
  const ViewData({super.key, required this.document,required this.id});

  final Map<String, dynamic> document;
  final String id;

  @override
  State<ViewData> createState() => _ViewDataState();
}

class _ViewDataState extends State<ViewData> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String type;
  late String category;
  bool edit = false;

  @override
  void initState() {
    super.initState();
    String title = widget.document['title'] ?? 'Hey There';
    _titleController = TextEditingController(text: title);
    _descriptionController =
        TextEditingController(text: widget.document['description']);
    type = widget.document['task'];
    category = widget.document['category'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1D1E26),
              Color(0xFF252041),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      CupertinoIcons.arrow_left,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          FirebaseFirestore.instance.collection('Todo').doc(widget.id).delete().then((value) {
                            Navigator.pop(context);
                          });
                        },
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 26,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            edit = !edit;
                          });
                        },
                        icon: Icon(
                          Icons.edit_outlined,
                          color: edit ? Colors.grey : Colors.green,
                          size: 26,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      edit ? 'Editing Your Todo' : 'View Your Todo',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.0,
                      ),
                    ),
                    SizedBox(
                      height: 28,
                    ),
                    label('Task Title'),
                    SizedBox(
                      height: 12,
                    ),
                    title(),
                    SizedBox(
                      height: 28,
                    ),
                    label('Task Type'),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        taskSelect('Important', 0xFFB22222),
                        SizedBox(
                          width: 16,
                        ),
                        taskSelect('Planned', 0xFF00FF00),
                      ],
                    ),
                    SizedBox(
                      height: 28,
                    ),
                    label('Task Description'),
                    SizedBox(
                      height: 12,
                    ),
                    description(),
                    SizedBox(
                      height: 28,
                    ),
                    label('Task Category'),
                    SizedBox(
                      height: 12,
                    ),
                    Wrap(
                      runSpacing: 8,
                      children: [
                        categorySelect('Work', 0xFF000000),
                        SizedBox(
                          width: 16,
                        ),
                        categorySelect('Technology', 0xFFC0C0C0),
                        SizedBox(
                          width: 16,
                        ),
                        categorySelect('Food', 0xFF4876FF),
                        categorySelect('Design', 0xFFFFFF00),
                        SizedBox(
                          width: 16,
                        ),
                        categorySelect('Sport', 0xFFFF7F50),
                        SizedBox(
                          width: 16,
                        ),
                        categorySelect('Science', 0xFF6A5ACD),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    edit ? button() : Container(),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget button() {
    return InkWell(
      onTap: () {
        FirebaseFirestore.instance.collection('Todo').doc(widget.id).update({
          'title': _titleController.text,
          'task': type,
          'description': _descriptionController.text,
          'category': category
        });
        Navigator.pop(context);
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            colors: [
              Color(0xFF78469b),
              Color(0xFF3684c4),
            ],
          ),
        ),
        child: Center(
          child: Text(
            'Update Todo',
            style: TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget description() {
    return Container(
      height: 120,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xFF2A2E3D),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextFormField(
        controller: _descriptionController,
        enabled: edit,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
        maxLines: null,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Task Description',
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
          contentPadding: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
          ),
        ),
      ),
    );
  }

  Widget taskSelect(String label, int color) {
    return InkWell(
      onTap: edit
          ? () {
              setState(() {
                type = label;
              });
            }
          : null,
      child: Chip(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        backgroundColor: type == label ? Colors.orange : Color(color),
        label: Text(label),
        labelStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
        labelPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
      ),
    );
  }

  Widget categorySelect(String label, int color) {
    return InkWell(
      onTap: edit
          ? () {
              setState(() {
                category = label;
              });
            }
          : null,
      child: Chip(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        backgroundColor: category == label ? Colors.orange : Color(color),
        label: Text(label),
        labelStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
        labelPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
      ),
    );
  }

  Widget title() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xFF2A2E3D),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextFormField(
        controller: _titleController,
        enabled: edit,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Task Title',
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
          contentPadding: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
          ),
        ),
      ),
    );
  }

  Widget label(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
