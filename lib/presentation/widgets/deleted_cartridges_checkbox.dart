import 'package:cartridge_keeper/presentation/cubits/cartridge_cubit/cartridge_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeletedCartridgesCheckbox extends StatelessWidget {
  const DeletedCartridgesCheckbox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartridgeCubit, CartridgeState>(
      builder: (context, state) {
        return Checkbox(
          splashRadius: 0,
          activeColor: const Color(0xFF4880FF),
          checkColor: Colors.white,
          value: state.viewIsDeleted,
          onChanged: (value) {
            context.read<CartridgeCubit>()
              ..changeDeletedCartridgesVisibility()
              ..loadAllCartridges(isDeleted: value!);
          },
        );
      },
    );
  }
}