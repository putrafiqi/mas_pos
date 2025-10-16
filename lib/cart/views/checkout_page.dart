import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:mas_pos/cart/cart.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({
    super.key,
    required this.totalPrice,
    required this.paymentMethod,
  });
  final double totalPrice;
  final PaymentMethod paymentMethod;

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return Scaffold(
      backgroundColor: Colors.blue.shade800,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        forceMaterialTransparency: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.share))],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            Column(
              children: [
                Text(
                  'Pembayaran Berhasil',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Yuk! Mulai Siapkan Pesanan',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            Image.asset('assets/images/checkout.png'),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(DateFormat('yMMMMd').format(DateTime.now())),
                      Text('213123123*******'),
                    ],
                  ),
                  Divider(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Total Bayar'),
                      Text(
                        'Rp. ${totalPrice.toInt()}',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Gap(24),
                  Row(
                    spacing: 16,
                    children: [
                      Text('Metode Pembayaran'),
                      paymentMethod == PaymentMethod.qris
                          ? Image.asset('assets/images/qris_logo.png')
                          : Image.asset('assets/images/tunai_logo.png'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
