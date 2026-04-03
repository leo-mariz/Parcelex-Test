import 'ds_padding.dart';
import 'ds_size.dart';

/// Espaçamentos do app a partir de valores base no Figma (375×812).
/// Use [DSPadding] / [DSSize] diretamente para novos casos.
abstract final class AppSpacing {
  static double get pageHorizontal => DSPadding.horizontal(16);

  static double get cardTopPadding => DSPadding.vertical(36);

  static double get sectionGap => DSPadding.vertical(24);

  static double get md => DSSize.width(16);

  /// Espaço vertical curto (ex.: label → campo).
  static double get gapXs => DSPadding.vertical(4);

  /// Espaço vertical / horizontal pequeno (ex.: entre linhas em tile).
  static double get gapSm => DSPadding.vertical(8);

  /// Rodapé abaixo de [AppPageScaffold.stickyFooter] (valor base Figma).
  static double get stickyFooterBottom => DSPadding.vertical(20);

  /// Largura máxima do conteúdo em telas largas; `null` = largura total.
  static double? get contentMaxWidth {
    if (DSSize.logicalWidth < 600) return null;
    return DSSize.width(520).clamp(420.0, 600.0);
  }

  static double get loginHeroHeight => DSSize.logicalHeight * 0.62;

  /// Início do card branco. Um pouco acima da proporção “pura” evita overflow
  /// do formulário em telas com pouca altura útil (~8–12 px).
  static double get loginCardTop =>
      DSSize.logicalHeight * 0.58 - DSSize.height(26);
}
