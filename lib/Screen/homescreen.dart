import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test_case/commons/databasehelper.dart';
import 'package:riverpod_test_case/models/userModel.dart';


final userDataProvider = FutureProvider<List<UserModel>>((ref) {
  return DatabaseHelper().getMicroData();
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('text'),
      ),
      body: userData.when(
          data: (data) {
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: ((context, index) {
                return ListTile(title: Text('${data[index].firstname} ${data[index].lastname}'));
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
