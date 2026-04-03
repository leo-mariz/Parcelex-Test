import 'package:flutter/material.dart';

/// Chave global para [SnackBar] após `pop` (contexto da rota anterior ainda não montado).
final GlobalKey<ScaffoldMessengerState> appScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
