import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key, this.todo});
  final Map? todo;

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  final titleController = TextEditingController();

  final descriptionController = TextEditingController();
  bool isEditPage = false;

  @override
  void initState() {
    if (widget.todo != null) {
      isEditPage = true;
       titleController.text = widget.todo!['title'];
    descriptionController.text = widget.todo!['description'];
      
    }
   

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child:
                isEditPage ? const Text('Edit Page') : const Text('Add Page')),
      ),
      body: ListView(padding: const EdgeInsets.all(10), children: [
        TextField(
          controller: titleController,
          decoration: const InputDecoration(
            hintText: 'Title',
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          controller: descriptionController,
          decoration: const InputDecoration(hintText: 'Description'),
          keyboardType: TextInputType.multiline,
          // keyboardAppearance: ,
          minLines: 2,
          maxLines: 8,
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
          onPressed:isEditPage?updateData: submitData,
          child: isEditPage ? const Text('Update') : const Text('Submit'),
        ),
      ]),
    );
  }

  Future<void> updateData() async {
    final title = titleController.text;
    final description = descriptionController.text;
    final id = widget.todo!['_id'];

    final body = {
      'title': title,
      'description': description,
      'is_completed': false
    };
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      showSuccessMessage('Message Updated');
    } else {
      print(response.statusCode);
      showErrorMessage('Error occured');
    }
  }

  Future<void> submitData() async {
    FocusManager.instance.primaryFocus!.unfocus(); // hide the keyboard
    final title = titleController.text;
    final description = descriptionController.text;
    // final id=widget.todo!['_id'];
    final body = {
      'title': title,
      'description': description,
      'is_completed': false
    };
    const url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    try {
      final response = await http.post(
        uri,
        body: json.encode(body),
        headers: {'Content-Type': 'application/json'},
      );
      print('${response.body},${response.statusCode}');
      if (response.statusCode == 201) {
        showSuccessMessage('Message Saved');
      } else {
        showErrorMessage('Error occured');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void showSuccessMessage(String message) {
    clearForm();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
    Navigator.pop(context);
  }

  void showErrorMessage(String message) {
    clearForm();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(message),
      ),
    );
  }

  void clearForm() {
    titleController.clear();
    descriptionController.clear();
  }
}
