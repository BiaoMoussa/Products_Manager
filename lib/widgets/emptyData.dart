
import 'package:flutter/material.dart';

class EmptyData extends StatelessWidget {
  const EmptyData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center( child: Text("NO DATA!",style: TextStyle(color: Colors.red),),

    );
  }
}
