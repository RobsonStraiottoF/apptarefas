import 'package:apptarefas/database_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _tarefas = [];
  final TextEditingController _txtTarefaController = TextEditingController();
  final TextEditingController _txtEditarTarefaController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    carregarTarefas();
  }

  Future<void> carregarTarefas() async {
    final tarefas = await DatabaseHelper.getTarefas();

    setState(() {
      _tarefas = tarefas;
    });
  }

  Future<void> adicionarTarefa() async {
    if (_txtTarefaController.text.isNotEmpty) {
      await DatabaseHelper.adicionarTarefa(_txtTarefaController.text);
      _txtTarefaController.clear();
      carregarTarefas();
    }
  }

  void confirmarDelete(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Excluir tarefa"),
          content: const Text("Você tem certeza que deseja excluir?"),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Excluir"),
              onPressed: () {
                deletarTarefa(id);
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  Future<void> deletarTarefa(int id) async {
    await DatabaseHelper.deletarTarefa(id);
    carregarTarefas();
  }

  void editarTarefa(int index) {
    final dadosTarefa = _tarefas[index];

    _txtEditarTarefaController.text = dadosTarefa["tarefa"];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Editar Tarefa"),
          content: TextField(
            controller: _txtEditarTarefaController,
            decoration: const InputDecoration(labelText: "Tarefa"),
          ),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Salvar"),
              onPressed: () async {
                if (_txtEditarTarefaController.text.isNotEmpty) {
                  await DatabaseHelper.editarTarefa(
                    dadosTarefa["id"],
                    _txtEditarTarefaController.text,
                    dadosTarefa["status"],
                  );
                  carregarTarefas();
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                }
              },
            )
          ],
        );
      },
    );
  }

  Future<void> marcarTarefa(int index) async {
    final dadosTarefa = _tarefas[index];
    final status = dadosTarefa["status"] == 0 ? 1 : 0;
    await DatabaseHelper.editarTarefa(
      dadosTarefa["id"],
      dadosTarefa["tarefa"],
      status,
    );
    carregarTarefas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Tarefas"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _txtTarefaController,
                    decoration: const InputDecoration(labelText: "Nova Tarefa"),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: adicionarTarefa,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tarefas.length,
              itemBuilder: (context, index) {
                final tarefa = _tarefas[index];

                return ListTile(
                  leading: Checkbox(
                    value: tarefa['status'] == 1,
                    onChanged: (value) => marcarTarefa(index),
                  ),
                  title: Text(
                    tarefa["tarefa"],
                    style: TextStyle(
                      decoration: tarefa['status'] == 1
                          ? TextDecoration.lineThrough
                          : null,
                      color: tarefa['status'] == 1 ? Colors.grey : null,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                        ),
                        onPressed: () {
                          editarTarefa(index);
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                        ),
                        onPressed: () => confirmarDelete(tarefa['id']),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
