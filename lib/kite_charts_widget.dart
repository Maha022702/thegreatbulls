import 'package:flutter/material.dart';
import 'live_market_data_with_history.dart';

class KiteChartsPage extends StatelessWidget {
  const KiteChartsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Use the enhanced Live Market Data widget with OpenSearch historical data integration
    return const LiveMarketDataWithHistory();
  }
}
