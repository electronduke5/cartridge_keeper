import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/compatibility_cartridges_provider.dart';


class CartridgeCompatibilitySelectableWidget extends ConsumerStatefulWidget {
  const CartridgeCompatibilitySelectableWidget({
        super.key,
        required this.cartridgeName,
      });

  final String cartridgeName;


  @override
  ConsumerState<CartridgeCompatibilitySelectableWidget> createState() =>
      _CartridgeCompatibilitySelectableWidgetState();
}

class
_CartridgeCompatibilitySelectableWidgetState
    extends ConsumerState<CartridgeCompatibilitySelectableWidget> {
  @override
  Widget build(BuildContext context) {
    final listCartridges = ref.watch(compatibilityCartridgesProvider);
    bool isSelected = false;
    setState(() {
      isSelected = listCartridges
          .map((e) => e)
          .toList()
          .contains(widget.cartridgeName);
    });

    return GestureDetector(
      onTap: () {
        setState(() {
          ref
              .read(compatibilityCartridgesProvider.notifier)
              .toggleItem(widget.cartridgeName);

          isSelected = listCartridges
              .map((e) => e)
              .toList()
              .contains(widget.cartridgeName);
        });
      },
      child: Card(
        color: isSelected ? const Color(0xFF4880FF) : const Color(0xFF273142),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(
            color: Colors.white,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            children: [
              Icon(
                isSelected ? Icons.check : Icons.add,
                size: 20,
              ),
              const SizedBox(width: 5),
              Text(
                widget.cartridgeName,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
