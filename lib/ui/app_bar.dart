import 'package:flutter/material.dart';
import 'package:indriver_clone/ui/constants.dart';

class HomeAppBar extends StatelessWidget with PreferredSizeWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: Builder(builder: (context) {
        return CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(
              Icons.menu,
              color: primaryColor,
            ),
          ),
        );
      }),
      actions: [
        CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.share,
              color: primaryColor,
            ),
          ),
        )
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(100);
}

class NavAppbar extends StatelessWidget with PreferredSizeWidget {
  const NavAppbar({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    print(title);
    return AppBar(
      title: Text(title + 'hry'),
      backgroundColor: Colors.white,
      leading: Builder(builder: (context) {
        return IconButton(
          onPressed: () {
            try {
              Scaffold.of(context).openDrawer();
            } catch (e) {
              print(e);
            }
            print('pressed');
          },
          icon: const Icon(
            Icons.menu,
            color: primaryColor,
          ),
        );
      }),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(60);
}
