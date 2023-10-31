import 'package:flutter/material.dart';
import 'package:todo/screens/to_do_page.dart';
import 'package:todo/services/to_do_services.dart';
import 'package:todo/utils/snackbar_helper.dart';


// -------------------------API IS 'https://api.nstack.in/' ---------------------------------------


class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  bool isLoading = true;

  var list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('To-do-List')),
      ),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: fetchData,
          child: list.isEmpty
              ? const Center(
                  child: Text(
                  'No to-dos created',
                  style: TextStyle(fontSize: 20),
                ))
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final item = list[index] as Map;
                    final itemId = item['_id'] as String;
                    print(itemId);
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 18),
                      child: ListTile(
                        leading:
                            CircleAvatar(child: Text((index + 1).toString())),
                        title: Text('${item['title']}'),
                        subtitle: Text('${item['description']}'),
                        trailing: PopupMenuButton(
                            onSelected: (value) {
                              if (value == 'Edit') {
                                navigateToEditPage(item);
                              } else if (value == 'Remove') {
                                deleteData(itemId);
                              }
                            },
                            itemBuilder: (context) => const [
                                  PopupMenuItem(
                                    value: 'Edit',
                                    child: Text('Edit'),
                                  ),
                                  PopupMenuItem(
                                    value: 'Remove',
                                    child: Text('Remove'),
                                  )
                                ]),
                      ),
                    );
                  }),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          navigateToAddPage();
        },
        label: const Text('Add todo'),
      ),
    );
  }
// --------------------------------------delete data--------------------------------

  Future<void> deleteData(String id) async {
    final response = await ToDoService.deleteById(id);
    if (response) {
      final deletedItems =
          list.where((element) => element['_id'] != id).toList();
      setState(() {
        list = deletedItems;
      });
    } else {
      print('Error occured..........................');
    }
  }

// --------------------------------------get data--------------------------------
  Future<void> fetchData() async {
    final result = await ToDoService.fetchData();
    if (result != null) {
      setState(() {
        list = result;
        isLoading = false;
      });
    } else {
      showErrorMessage(context, message: 'Message not sent');
    }
  }

  Future<void> navigateToEditPage(Map todo) async {
    final route = MaterialPageRoute(
        builder: (context) => ToDoPage(
              todo: todo,
            ));
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchData();
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(builder: (context) => const ToDoPage());
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchData();
  }
}
