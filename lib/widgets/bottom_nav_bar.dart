import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFFF5F0E8),
      selectedItemColor: const Color(0xFF0A3D1F),
      unselectedItemColor: const Color(0xFF8D5524),
      selectedLabelStyle: GoogleFonts.openSans(fontWeight: FontWeight.w600),
      unselectedLabelStyle: GoogleFonts.openSans(),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.spa),
          label: 'Sussurro',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.nights_stay),
          label: 'Lua',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.park),
          label: 'Árvore',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
      onTap: (index) {
        if (index == currentIndex) return;

        if (index == 0) {
          Navigator.pushReplacementNamed(context, '/home');
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LuaRituaisScreen()),
          );
        } else if (index == 2) {
          Navigator.pushReplacementNamed(context, '/arvore');
        } else if (index == 3) {
          Navigator.pushReplacementNamed(context, '/perfil');
        }
      },
    );
  }
}