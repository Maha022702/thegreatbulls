import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'kite_service.dart';

class TradingDashboard extends StatefulWidget {
  const TradingDashboard({super.key});

  @override
  State<TradingDashboard> createState() => _TradingDashboardState();
}

class _TradingDashboardState extends State<TradingDashboard> {
  bool _isLoading = true;
  Map<String, dynamic>? _userProfile;
  Map<String, dynamic>? _orders;
  Map<String, dynamic>? _positions;
  Map<String, dynamic>? _holdings;
  Map<String, dynamic>? _margins;
  Map<String, dynamic>? _instruments;
  Map<String, dynamic>? _quote;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load all data in parallel
      final results = await Future.wait([
        KiteService.getUserProfile(),
        KiteService.getOrders(),
        KiteService.getPositions(),
        KiteService.getHoldings(),
        KiteService.getMargins(),
        KiteService.getInstruments('NSE'),
        KiteService.getQuote('NSE:RELIANCE'),
      ]);

      setState(() {
        _userProfile = results[0] as Map<String, dynamic>?;
        _orders = results[1] as Map<String, dynamic>?;
        _positions = results[2] as Map<String, dynamic>?;
        _holdings = results[3] as Map<String, dynamic>?;
        _margins = results[4] as Map<String, dynamic>?;
        _instruments = results[5] as Map<String, dynamic>?;
        _quote = results[6] as Map<String, dynamic>?;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    await KiteService.logout();
    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.amber),
              SizedBox(height: 16),
              Text(
                'Loading your trading data...',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1a1a1a),
        title: const Text(
          'The Great Bulls - Trading Dashboard',
          style: TextStyle(color: Colors.amber),
        ),
        actions: [
          IconButton(
            onPressed: _loadAllData,
            icon: const Icon(Icons.refresh, color: Colors.amber),
            tooltip: 'Refresh Data',
          ),
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout, color: Colors.red),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Section
            if (_userProfile != null) _buildUserProfileSection(),

            const SizedBox(height: 24),

            // Market Data Section
            if (_quote != null) _buildMarketDataSection(),

            const SizedBox(height: 24),

            // Portfolio Overview
            Row(
              children: [
                if (_margins != null) Expanded(child: _buildMarginsCard()),
                const SizedBox(width: 16),
                if (_holdings != null) Expanded(child: _buildHoldingsSummaryCard()),
              ],
            ),

            const SizedBox(height: 24),

            // Orders and Positions
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_orders != null) Expanded(child: _buildOrdersCard()),
                const SizedBox(width: 16),
                if (_positions != null) Expanded(child: _buildPositionsCard()),
              ],
            ),

            const SizedBox(height: 24),

            // Instruments (sample)
            if (_instruments != null) _buildInstrumentsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfileSection() {
    final user = _userProfile?['data'];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a1a),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.person, color: Colors.amber, size: 28),
              const SizedBox(width: 12),
              const Text(
                'User Profile',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildProfileRow('Name', user?['user_name'] ?? 'N/A'),
          _buildProfileRow('Email', user?['email'] ?? 'N/A'),
          _buildProfileRow('User ID', user?['user_id'] ?? 'N/A'),
          _buildProfileRow('Broker', user?['broker'] ?? 'N/A'),
          _buildProfileRow('User Type', user?['user_type'] ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildMarketDataSection() {
    final quote = _quote?['data']?['NSE:RELIANCE'];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a1a),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.show_chart, color: Colors.amber, size: 28),
              const SizedBox(width: 12),
              const Text(
                'Market Data (RELIANCE)',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildMarketDataItem('Last Price', '₹${quote?['last_price'] ?? 'N/A'}')),
              Expanded(child: _buildMarketDataItem('Change', '${quote?['net_change'] ?? 'N/A'}')),
              Expanded(child: _buildMarketDataItem('Volume', quote?['volume']?.toString() ?? 'N/A')),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildMarketDataItem('Open', '₹${quote?['ohlc']?['open'] ?? 'N/A'}')),
              Expanded(child: _buildMarketDataItem('High', '₹${quote?['ohlc']?['high'] ?? 'N/A'}')),
              Expanded(child: _buildMarketDataItem('Low', '₹${quote?['ohlc']?['low'] ?? 'N/A'}')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMarginsCard() {
    final margins = _margins?['data'];
    final equity = margins?['equity'];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a1a),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.account_balance_wallet, color: Colors.green, size: 24),
              const SizedBox(width: 8),
              const Text(
                'Margins',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildMarginItem('Available', '₹${equity?['available']?['cash'] ?? 'N/A'}'),
          _buildMarginItem('Used', '₹${equity?['used']?['cash'] ?? 'N/A'}'),
          _buildMarginItem('Total', '₹${equity?['total']?['cash'] ?? 'N/A'}'),
        ],
      ),
    );
  }

  Widget _buildHoldingsSummaryCard() {
    final holdings = _holdings?['data'] as List<dynamic>? ?? [];
    final totalValue = holdings.fold<double>(0, (sum, holding) => sum + (holding['total'] ?? 0));
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a1a),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.account_balance, color: Colors.blue, size: 24),
              const SizedBox(width: 8),
              const Text(
                'Holdings',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildHoldingItem('Total Stocks', holdings.length.toString()),
          _buildHoldingItem('Total Value', '₹${totalValue.toStringAsFixed(2)}'),
          _buildHoldingItem('PNL', holdings.isNotEmpty ? '₹${holdings.first['pnl'] ?? 0}' : 'N/A'),
        ],
      ),
    );
  }

  Widget _buildOrdersCard() {
    final orders = _orders?['data'] as List<dynamic>? ?? [];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a1a),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long, color: Colors.orange, size: 24),
              const SizedBox(width: 8),
              Text(
                'Orders (${orders.length})',
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (orders.isEmpty)
            const Text('No orders found', style: TextStyle(color: Colors.white70))
          else
            ...orders.take(3).map((order) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                '${order['tradingsymbol']} - ${order['transaction_type']} ${order['quantity']} @ ₹${order['average_price']}',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            )),
        ],
      ),
    );
  }

  Widget _buildPositionsCard() {
    final positions = _positions?['data']?['net'] as List<dynamic>? ?? [];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a1a),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.purple, size: 24),
              const SizedBox(width: 8),
              Text(
                'Positions (${positions.length})',
                style: const TextStyle(
                  color: Colors.purple,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (positions.isEmpty)
            const Text('No positions found', style: TextStyle(color: Colors.white70))
          else
            ...positions.take(3).map((position) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                '${position['tradingsymbol']} - ${position['quantity']} @ ₹${position['average_price']}',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            )),
        ],
      ),
    );
  }

  Widget _buildInstrumentsSection() {
    final instrumentsData = _instruments?['data'] as String?;
    final lines = instrumentsData?.split('\n').take(6) ?? [];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a1a),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.teal.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.table_chart, color: Colors.teal, size: 24),
              const SizedBox(width: 8),
              const Text(
                'Instruments (NSE Sample)',
                style: TextStyle(
                  color: Colors.teal,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              lines.join('\n'),
              style: const TextStyle(color: Colors.white, fontSize: 10, fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketDataItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildMarginItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildHoldingItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}