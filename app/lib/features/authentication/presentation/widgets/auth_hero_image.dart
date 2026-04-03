import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';

/// Área do hero no topo do login; substitua [AppAssets.authHero] pela sua imagem.
class AuthHeroImage extends StatelessWidget {
  const AuthHeroImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.authHero,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
      errorBuilder: (context, error, stackTrace) => ColoredBox(
        color: Colors.blueGrey.shade100,
        child: Center(
          child: Icon(
            Icons.photo_outlined,
            size: 56,
            color: Colors.blueGrey.shade400,
          ),
        ),
      ),
    );
  }
}
