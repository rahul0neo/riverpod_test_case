import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final _hiveBox = Hive.box('testBox');
final userDataProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return await getData();
});

Future<List<Map<String, dynamic>>> getData() async {


  final data =_hiveBox.keys.map((key){

    final item = _hiveBox.get(key);
    return {'key':key,"firstname": item["firstname"],
    "lastname": item["lastname"],
    "email": item["email"],
    "mobilenumber": item["mobilenumber"],
    "country": item["country"]};
  }).toList();


  return data.toList();
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Data'),
      ),
      body: userData.when(
          data: (data) {
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: ((context, index) {
                return ListTile(title: Text('${data[index]['firstname']} ${data[index]['mobilenumber']}'));
              }),
            );
          },
          error: ((error, stackTrace) => Text(error.toString())),
          loading: () {
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
