import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../home_provider.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({Key? key}) : super(key: key);

  @override
  CounterPageState createState() => CounterPageState();
}

class CounterPageState extends State<CounterPage> {
  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Consumer<HomeProvider>(
            builder: (context, value, child) => Text(
                value.user?.name ?? "",
                style: Theme.of(context).textTheme.titleLarge),
          ),
          Builder(builder: (context) {
            final walking = context
                .select<HomeProvider, bool>((value) => value.walking);
            return SizedBox(
              height: MediaQuery.of(context).size.height * 1 / 2,
              child: Lottie.asset("assets/man-walking.json",
                  repeat: walking),
            );
          }),
          Text("Your steps",
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(color: Theme.of(context).primaryColor)),
          Builder(builder: (context) {
            final count = context
                .select<HomeProvider, int>((value) => value.count);
            return Text(count.toString(),
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    ?.copyWith(fontSize: 70));
          }),
          // FutureBuilder<QuerySnapshot>(
          //   future:
          //       FirebaseFirestore.instance.collection("users").get(),
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return const Center(
          //         child: CircularProgressIndicator(),
          //       );
          //     }
          //     if (snapshot.hasError) {
          //       return Text(snapshot.error.toString());
          //     }
          //     print(snapshot.data?.docs.toList());
          //     return Expanded(
          //         child: ListView.builder(
          //       itemCount: snapshot.data?.docs.length,
          //       itemBuilder: (context, index) {
          //         Map data = snapshot.data?.docs[index].data() as Map;
          //         print(data);
          //         return ListTile(
          //           title: Text((data)["name"]),
          //           subtitle: Text((data)["email"] ?? "ss"),
          //         );
          //       },
          //     ));
          //   },
          // ),
        ],
      ),
    );
  }
}
