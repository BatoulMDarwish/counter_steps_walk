import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../storage_service.dart';
import '../home_provider.dart';

class ScoresPage extends StatefulWidget {
  const ScoresPage({Key? key}) : super(key: key);

  @override
  ScoresPageState createState() => ScoresPageState();
}

class ScoresPageState extends State<ScoresPage> {
  @override
  Widget build(BuildContext context) {
    HomeProvider provider = Provider.of(context, listen: false);

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: provider.usersStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        if (snapshot.connectionState == ConnectionState.active) {
          List<QueryDocumentSnapshot<Map<String, dynamic>>>? list =
              snapshot.data?.docs;

          return ListView.builder(
            itemCount: list?.length ?? 0,
            itemBuilder: (context, index) {
              User data = User.fromJson(
                  snapshot.data?.docs[index].data() as Map<String, dynamic>);

              print(data);
              return Card(
                child: ListTile(
                  leading: SizedBox(
                    height: 50,
                    width: 50,
                    child: FutureBuilder<String>(
                      future: provider.getImage(snapshot.data?.docs[index].id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return const SizedBox();
                        }
                        if (snapshot.data != null) {
                          return ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50)),
                            child: Image.network(
                              snapshot.data!,
                              fit: BoxFit.cover,
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  title: Text((data).name),
                  subtitle: Text((data).email),
                  trailing: Text(data.score.toString(),
                      style: Theme.of(context).textTheme.caption),
                ),
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
