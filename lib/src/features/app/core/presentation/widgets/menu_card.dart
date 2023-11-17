import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';
import 'package:travel_ease_app/src/features/app/core/presentation/bloc/set_page_cubit.dart';

class MenuCard extends StatefulWidget {
  final int index;
  final String title;
  final IconData icon;

  const MenuCard({
    super.key,
    required this.index,
    required this.title,
    required this.icon,
  });

  @override
  State<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<SetPageCubit>().setPage(widget.index);
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: PrimaryColor.navyBlack,
          border: Border.all(
            color: PrimaryColor.pureGrey,
            width: 8,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              color: PrimaryColor.pureWhite,
            ),
            const SizedBox(height: 20),
            Text(
              widget.title,
              style: TextStyle(
                color: PrimaryColor.pureWhite,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
