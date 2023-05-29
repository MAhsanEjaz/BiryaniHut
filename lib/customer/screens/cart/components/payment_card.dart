import 'package:flutter/material.dart';

class PaymentCard extends StatefulWidget {
  String? image;
  bool color;
  double? boxHeight;
  double? boxWidth;
  Function()? onTap;
  final String paymentName;

  PaymentCard(
      {this.image,
      required this.color,
      this.onTap,
      required this.paymentName,
      this.boxHeight,
      this.boxWidth});

  @override
  State<PaymentCard> createState() => _PaymentCardState();
}

class _PaymentCardState extends State<PaymentCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("${widget.paymentName}"),
        Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide(
                  color: widget.color ? Colors.red : Colors.black12,
                  width: 1.8)),
          elevation: widget.color ? 15.0 : 0,
          child: InkWell(
            onTap: (widget.onTap),
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Container(
                  height: widget.boxHeight ?? 65,
                  width: widget.boxWidth ?? 65,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(widget.image!),
                          fit: BoxFit.cover)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
