import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomePage extends StatelessWidget {
    const HomePage({super.key});

    @override
    Widget build(BuildContext context) {
        return Scaffold (
            appBar: AppBar(
                title: Text(
                    'Sikap',
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    ),
                ),
                backgroundColor: Colors.white,
                centerTitle: true,
                leading: Container (
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                    ),
                    child: SvgPicture.asset('assets/icons/your_icon_name.svg'),
                ),
            ),
        );
    }
}