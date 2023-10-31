import 'package:http/http.dart' as http;
import 'dart:convert';
class ToDoService {


  // ---------------------------- DELETE API --------------------------

  
  static Future<bool> deleteById(String id)async{

       final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
     return response.statusCode==200; 
  }


  // --------------------------- GET API -------------------------------


  static Future<List?> fetchData()async{
 const url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final json = jsonDecode(response.body) as Map;
  
    // print(items);
    if (response.statusCode == 200) {
      final result = json['items'] as List;
      return result;
    }
    else{
      return null;
    }

  }
}