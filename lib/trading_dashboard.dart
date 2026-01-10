import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'kite_charts_widget.dart';
import 'tradingview_widget.dart';

class TradingDashboard extends StatelessWidget {
  const TradingDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black.withOpacity(0.9),
          elevation: 0,
          title: const Text(
            'The Great Bulls — Pro Desk',
            style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: () => context.go('/'),
              icon: const Icon(Icons.home, color: Colors.amber),
              tooltip: 'Back to landing',
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.amber,
            labelColor: Colors.amber,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'US Charts (TradingView)'),
              Tab(text: 'Live Charts (Kite)'),
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Color(0xFF0a0a0a), Color(0xFF1a1a1a)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: _buildHeroHeader(),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _glassWrap(const TradingViewChartPage()),
                    _glassWrap(const KiteChartsPage()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _glassWrap(Widget child) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 24, offset: const Offset(0, 12)),
          ],
        ),
        child: child,
      ),
    );
  }

  Widget _buildHeroHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFFFC107), Color(0xFFFF9800)]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.amber.withOpacity(0.35), blurRadius: 24, offset: const Offset(0, 14)),
        ],
      ),
      child: Row(
        children: const [
          Icon(Icons.bolt, color: Colors.black, size: 28),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Elite Trading Desk',
                  style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'US-market TradingView charts + Zerodha live charts in one glassy cockpit.',
                  style: TextStyle(color: Colors.black87, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}