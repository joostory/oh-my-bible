
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator()
      )
    );
  }
}


class MessageLoading extends StatelessWidget {
  final String message;

  const MessageLoading({this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(message)
      )
    );
  }
}
