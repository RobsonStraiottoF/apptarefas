import 'package:http/http.dart' as http;
import 'dart:convert';

class DatabaseHelper {
  static const String baseUrl = "http://10.56.46.56/tarefas/public/api";

  

  //Create
  static Future<void> adicionarTarefa(String tarefa) async {
    
  }

  //Read
  static Future<List<Map<String, dynamic>>> getTarefas() async {
    
  }

  //Update
  static Future<void> editarTarefa(int id, String tarefa, int status) async {
   
  }

  //Delete
  static Future<void> deletarTarefa(int id) async {
  
  }
}
