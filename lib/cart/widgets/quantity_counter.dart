import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class QuantityCounter extends StatefulWidget {
  final int initialValue;

  final Function(int) onChanged;

  final int minValue;

  const QuantityCounter({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.minValue = 0,
  });

  @override
  State<QuantityCounter> createState() => _QuantityCounterState();
}

class _QuantityCounterState extends State<QuantityCounter> {
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialValue;
  }

  @override
  void didUpdateWidget(QuantityCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != _quantity) {
      setState(() {
        _quantity = widget.initialValue;
      });
    }
  }

  void _increment() {
    setState(() {
      _quantity++;
      widget.onChanged(_quantity);
    });
  }

  void _decrement() {
    if (_quantity > widget.minValue) {
      setState(() {
        _quantity--;
        widget.onChanged(_quantity);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Iconsax.minus_copy),
          onPressed: _decrement,
          color: _quantity > widget.minValue ? Colors.red : Colors.grey,
        ),

        SizedBox(
          width: 30,
          child: Text(
            '$_quantity',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),

        IconButton(
          icon: const Icon(Iconsax.add_copy),
          onPressed: _increment,
          color: Colors.green,
        ),
      ],
    );
  }
}
