import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'kite_config.dart';

/// Enhanced Live Market Data Widget with OpenSearch Historical Data Integration
class LiveMarketDataWithHistory extends StatefulWidget {
  const LiveMarketDataWithHistory({Key? key}) : super(key: key);

  @override
  State<LiveMarketDataWithHistory> createState() => _LiveMarketDataWithHistoryState();
}

class _LiveMarketDataWithHistoryState extends State<LiveMarketDataWithHistory> {
  late String _viewType;

  @override
  void initState() {
    super.initState();
    _viewType = 'live-market-data-with-history-${DateTime.now().millisecondsSinceEpoch}';
    _registerViewFactory();
  }

  void _registerViewFactory() {
    ui_web.platformViewRegistry.registerViewFactory(
      _viewType,
      (int viewId) {
        final iframe = html.IFrameElement()
          ..id = 'live-data-history-iframe-$viewId'
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.border = 'none'
          ..srcdoc = _buildLiveDataHTML();

        return iframe;
      },
    );
  }

  String _buildLiveDataHTML() {
    // OpenSearch API endpoint from AWS Lambda deployment
    const openSearchApiUrl = 'https://erkg1luks7.execute-api.us-east-1.amazonaws.com/prod/data';
    
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <script src="https://unpkg.com/lightweight-charts@4/dist/lightweight-charts.standalone.production.js"></script>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    
    body {
      background: #0a0a0a;
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Inter', sans-serif;
      color: #ffffff;
      height: 100vh;
      overflow: hidden;
    }
    
    .container { display: flex; height: 100vh; }
    
    .stock-list {
      width: 280px;
      background: #0f0f0f;
      border-right: 1px solid #27272a;
      overflow-y: auto;
      flex-shrink: 0;
    }
    
    .list-header {
      padding: 14px 16px;
      background: #1a1a1a;
      border-bottom: 1px solid #27272a;
      position: sticky;
      top: 0;
      z-index: 10;
    }
    
    .list-header h2 { font-size: 14px; color: #fbbf24; margin-bottom: 6px; }
    
    .connection-badge {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      padding: 4px 10px;
      background: #27272a;
      border-radius: 12px;
      font-size: 10px;
      margin-right: 8px;
    }
    
    .connection-badge.connected {
      background: #22c55e15;
      border: 1px solid #22c55e40;
      color: #22c55e;
    }
    
    .connection-dot {
      width: 6px;
      height: 6px;
      border-radius: 50%;
      background: #6b7280;
    }
    
    .connection-badge.connected .connection-dot {
      background: #22c55e;
      animation: pulse 1s infinite;
    }
    
    /* New: History Data Badge */
    .history-badge {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      padding: 4px 10px;
      background: #3b82f615;
      border: 1px solid #3b82f640;
      border-radius: 12px;
      font-size: 10px;
      color: #3b82f6;
    }
    
    .history-dot {
      width: 6px;
      height: 6px;
      border-radius: 50%;
      background: #3b82f6;
    }
    
    @keyframes pulse {
      0%, 100% { opacity: 1; }
      50% { opacity: 0.5; }
    }
    
    .stock-item {
      padding: 12px 16px;
      cursor: pointer;
      border-bottom: 1px solid #1f1f23;
      transition: all 0.2s;
    }
    
    .stock-item:hover {
      background: #1a1a1a;
    }
    
    .stock-item.selected {
      background: #1a1a1a;
      border-left: 3px solid #fbbf24;
      padding-left: 13px;
    }
    
    .stock-item.updating {
      animation: itemFlash 0.3s;
    }
    
    @keyframes itemFlash {
      0%, 100% { background: #1a1a1a; }
      50% { background: #27272a; }
    }
    
    .stock-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    
    .stock-name {
      font-size: 13px;
      font-weight: 600;
      color: #e5e7eb;
    }
    
    .stock-token-id {
      font-size: 10px;
      color: #6b7280;
      margin-top: 2px;
    }
    
    .stock-price {
      text-align: right;
    }
    
    .ltp {
      font-size: 13px;
      font-weight: 700;
    }
    
    .ltp.up { color: #22c55e; }
    .ltp.down { color: #ef4444; }
    .ltp.neutral { color: #9ca3af; }
    
    .change {
      font-size: 10px;
      font-weight: 600;
      margin-top: 2px;
    }
    
    .change.up { color: #22c55e; }
    .change.down { color: #ef4444; }
    
    .main-content {
      flex: 1;
      display: flex;
      flex-direction: column;
    }
    
    .chart-header {
      padding: 14px 20px;
      background: #1a1a1a;
      border-bottom: 1px solid #27272a;
      display: flex;
      justify-content: space-between;
      align-items: center;
      gap: 20px;
    }
    
    .selected-info {
      display: flex;
      align-items: center;
      gap: 12px;
    }
    
    .selected-name {
      font-size: 16px;
      font-weight: 700;
      color: #fbbf24;
    }
    
    .selected-price {
      font-size: 18px;
      font-weight: 700;
    }
    
    .selected-price.up { color: #22c55e; }
    .selected-price.down { color: #ef4444; }
    
    .selected-change {
      font-size: 13px;
      font-weight: 600;
    }
    
    .selected-change.up { color: #22c55e; }
    .selected-change.down { color: #ef4444; }
    
    .header-controls {
      display: flex;
      align-items: center;
      gap: 15px;
    }
    
    .interval-selector {
      display: flex;
      gap: 4px;
      background: #1a1a1a;
      padding: 3px;
      border-radius: 6px;
    }
    .interval-btn {
      padding: 4px 10px;
      border: none;
      background: transparent;
      color: #9ca3af;
      font-size: 11px;
      font-weight: 600;
      cursor: pointer;
      border-radius: 4px;
      transition: all 0.15s;
    }
    .interval-btn:hover { background: #27272a; color: #fff; }
    .interval-btn.active { background: #fbbf24; color: #000; }
    
    /* New: History Load Button */
    .history-btn {
      padding: 6px 14px;
      border: 1px solid #3b82f6;
      background: #3b82f615;
      color: #3b82f6;
      font-size: 11px;
      font-weight: 600;
      cursor: pointer;
      border-radius: 6px;
      transition: all 0.15s;
      display: flex;
      align-items: center;
      gap: 6px;
    }
    .history-btn:hover {
      background: #3b82f625;
      border-color: #60a5fa;
    }
    .history-btn:disabled {
      opacity: 0.5;
      cursor: not-allowed;
    }
    .history-btn.loading {
      animation: pulseButton 1s infinite;
    }
    
    @keyframes pulseButton {
      0%, 100% { opacity: 1; }
      50% { opacity: 0.6; }
    }
    
    .live-indicator {
      display: flex;
      align-items: center;
      gap: 6px;
      padding: 4px 10px;
      background: #22c55e15;
      border: 1px solid #22c55e40;
      border-radius: 14px;
      color: #22c55e;
      font-size: 10px;
      font-weight: 600;
    }
    .live-dot { width: 6px; height: 6px; background: #22c55e; border-radius: 50%; animation: pulse 1s infinite; }
    
    .stock-stats {
      display: flex;
      gap: 20px;
      padding: 10px 20px;
      background: #0f0f0f;
      border-bottom: 1px solid #27272a;
      flex-wrap: wrap;
    }
    .stat-item { display: flex; flex-direction: column; gap: 1px; }
    .stat-label { font-size: 9px; color: #6b7280; text-transform: uppercase; }
    .stat-value { font-size: 12px; font-weight: 600; color: #e5e7eb; }
    .stat-value.high { color: #22c55e; }
    .stat-value.low { color: #ef4444; }
    .stat-value.volume { color: #60a5fa; }
    
    .candle-count {
      font-size: 10px;
      color: #6b7280;
      padding: 4px 10px;
      background: #1a1a1a;
      border-radius: 10px;
    }
    
    .realtime-clock {
      font-size: 11px;
      font-weight: 600;
      color: #fbbf24;
      font-family: monospace;
    }
    
    .last-tick {
      font-size: 10px;
      color: #6b7280;
      padding: 4px 10px;
      background: #1a1a1a;
      border-radius: 10px;
    }
    .last-tick.fresh { color: #22c55e; }
    .last-tick.stale { color: #ef4444; }
    
    /* New: History Status */
    .history-status {
      font-size: 10px;
      color: #3b82f6;
      padding: 4px 10px;
      background: #1a1a1a;
      border-radius: 10px;
    }
    
    #chartContainer { flex: 1; position: relative; }
    
    .no-selection {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      height: 100%;
      color: #6b7280;
      gap: 10px;
    }
    .no-selection-icon { font-size: 40px; }
    
    .loading-overlay {
      position: absolute;
      top: 0; left: 0; right: 0; bottom: 0;
      background: rgba(10,10,10,0.85);
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      color: #fbbf24;
      font-size: 14px;
      z-index: 100;
      gap: 10px;
    }
    
    .loading-spinner {
      border: 3px solid #27272a;
      border-top: 3px solid #fbbf24;
      border-radius: 50%;
      width: 40px;
      height: 40px;
      animation: spin 1s linear infinite;
    }
    
    @keyframes spin {
      0% { transform: rotate(0deg); }
      100% { transform: rotate(360deg); }
    }
  </style>
</head>
<body>
  <div class="container">
    <!-- Stock List Sidebar -->
    <div class="stock-list">
      <div class="list-header">
        <h2>Live Market Data</h2>
        <div>
          <div class="connection-badge" id="connectionBadge">
            <div class="connection-dot"></div>
            <span id="connectionStatus">Disconnected</span>
          </div>
          <div class="history-badge" id="historyBadge" style="display: none;">
            <div class="history-dot"></div>
            <span>Historical Data</span>
          </div>
        </div>
      </div>
      <div id="stockList"></div>
    </div>
    
    <!-- Main Chart Area -->
    <div class="main-content">
      <div class="chart-header">
        <div class="selected-info">
          <span class="selected-name" id="selectedName">Select a stock</span>
          <span class="selected-price" id="selectedPrice">—</span>
          <span class="selected-change" id="selectedChange">—</span>
        </div>
        <div class="header-controls">
          <button class="history-btn" id="loadHistoryBtn" onclick="loadHistoricalData()" disabled>
            <span>📊</span>
            <span id="historyBtnText">Load Historical Data</span>
          </button>
          <div class="interval-selector">
            <button class="interval-btn active" data-interval="1m" onclick="setInterval('1m')">1m</button>
            <button class="interval-btn" data-interval="5m" onclick="setInterval('5m')">5m</button>
            <button class="interval-btn" data-interval="15m" onclick="setInterval('15m')">15m</button>
          </div>
          <div class="live-indicator">
            <div class="live-dot"></div>
            <span>LIVE</span>
          </div>
        </div>
      </div>
      
      <div class="stock-stats">
        <div class="stat-item">
          <span class="stat-label">Open</span>
          <span class="stat-value" id="statOpen">—</span>
        </div>
        <div class="stat-item">
          <span class="stat-label">High</span>
          <span class="stat-value high" id="statHigh">—</span>
        </div>
        <div class="stat-item">
          <span class="stat-label">Low</span>
          <span class="stat-value low" id="statLow">—</span>
        </div>
        <div class="stat-item">
          <span class="stat-label">Close</span>
          <span class="stat-value" id="statClose">—</span>
        </div>
        <div class="stat-item">
          <span class="stat-label">Volume</span>
          <span class="stat-value volume" id="statVolume">—</span>
        </div>
        <div class="stat-item">
          <span class="stat-label">Buy Qty</span>
          <span class="stat-value" id="statBuyQty">—</span>
        </div>
        <div class="stat-item">
          <span class="stat-label">Sell Qty</span>
          <span class="stat-value" id="statSellQty">—</span>
        </div>
        <div class="candle-count" id="candleCount">0 candles</div>
        <div class="realtime-clock" id="realtimeClock">—</div>
        <div class="last-tick" id="lastTick">Waiting for data...</div>
        <div class="history-status" id="historyStatus" style="display: none;">Historical: —</div>
      </div>
      
      <div id="chartContainer">
        <div class="no-selection">
          <div class="no-selection-icon">📈</div>
          <div>Select a stock to view live chart</div>
        </div>
      </div>
    </div>
  </div>

  <script>
    const OPENSEARCH_API = '$openSearchApiUrl';
    const IST_OFFSET = 19800; // 5.5 hours in seconds
    
    let chart = null;
    let candleSeries = null;
    let volumeSeries = null;
    let selectedToken = null;
    let currentInterval = '1m';
    let ws = null;
    let db = null;
    let tickCount = 0;
    
    // State tracking
    let hasHistoricalData = false;
    let loadingHistory = false;
    
    const stocks = [
      { token: 256265, symbol: 'NIFTY50', name: 'NIFTY 50' },
      { token: 260105, symbol: 'BANKNIFTY', name: 'NIFTY BANK' },
      { token: 261641, symbol: 'FINNIFTY', name: 'NIFTY FIN SERVICE' },
      { token: 264969, symbol: 'MIDCPNIFTY', name: 'NIFTY MIDCAP SELECT' }
    ];
    
    const stockData = {};
    const candleData = {};
    const currentCandle = {};
    const lastTickTime = {};
    
    stocks.forEach(stock => {
      stockData[stock.token] = {
        symbol: stock.symbol,
        ltp: 0,
        change: 0,
        changePercent: 0,
        ohlc: {},
        volume: 0,
        buyQty: 0,
        sellQty: 0
      };
      candleData[stock.token] = { '1m': [], '5m': [], '15m': [] };
    });
    
    // ========== OpenSearch Integration ==========
    async function loadHistoricalData() {
      if (!selectedToken || loadingHistory) return;
      
      loadingHistory = true;
      hasHistoricalData = false;
      updateHistoryButton();
      
      const stock = stocks.find(s => s.token === selectedToken);
      if (!stock) return;
      
      try {
        showLoadingOverlay('Loading historical data from OpenSearch...');
        
        // Fetch historical data from OpenSearch API
        const limit = 500;
        const url = \`\${OPENSEARCH_API}?action=historical&instrument=\${selectedToken}&limit=\${limit}\`;
        
        const response = await fetch(url);
        if (!response.ok) throw new Error('Failed to fetch historical data');
        
        const data = await response.json();
        
        if (data.status === 'success' && data.data && data.data.length > 0) {
          // Process and merge historical data
          processHistoricalData(data.data);
          hasHistoricalData = true;
          document.getElementById('historyBadge').style.display = 'inline-flex';
          document.getElementById('historyStatus').style.display = 'block';
          document.getElementById('historyStatus').textContent = \`Historical: \${data.data.length} records loaded\`;
          updateChart();
        } else {
          console.log('No historical data available');
          document.getElementById('historyStatus').textContent = 'Historical: No data available';
        }
        
      } catch (error) {
        console.error('Error loading historical data:', error);
        alert('Failed to load historical data: ' + error.message);
      } finally {
        hideLoadingOverlay();
        loadingHistory = false;
        updateHistoryButton();
      }
    }
    
    function processHistoricalData(records) {
      if (!records || records.length === 0) return;
      
      const intervals = ['1m', '5m', '15m'];
      
      // Group records by interval
      const grouped = {};
      intervals.forEach(interval => grouped[interval] = []);
      
      records.forEach(record => {
        if (record.interval && grouped[record.interval]) {
          // Convert timestamp to seconds if needed
          let time = record.timestamp;
          if (time > 9999999999) time = Math.floor(time / 1000);
          
          const candle = {
            time: time,
            open: record.open,
            high: record.high,
            low: record.low,
            close: record.close,
            volume: record.volume || 0
          };
          
          grouped[record.interval].push(candle);
        }
      });
      
      // Merge with existing candle data (historical comes first, then live)
      intervals.forEach(interval => {
        if (grouped[interval].length > 0) {
          const historical = grouped[interval].sort((a, b) => a.time - b.time);
          const existing = candleData[selectedToken][interval] || [];
          
          // Merge without duplicates
          const merged = [...historical];
          existing.forEach(candle => {
            if (!merged.find(c => c.time === candle.time)) {
              merged.push(candle);
            }
          });
          
          candleData[selectedToken][interval] = merged.sort((a, b) => a.time - b.time);
        }
      });
    }
    
    function updateHistoryButton() {
      const btn = document.getElementById('loadHistoryBtn');
      const text = document.getElementById('historyBtnText');
      
      if (loadingHistory) {
        btn.disabled = true;
        btn.classList.add('loading');
        text.textContent = 'Loading...';
      } else if (hasHistoricalData) {
        btn.disabled = false;
        btn.classList.remove('loading');
        text.textContent = 'Reload Historical';
      } else {
        btn.disabled = !selectedToken;
        btn.classList.remove('loading');
        text.textContent = 'Load Historical Data';
      }
    }
    
    function showLoadingOverlay(message) {
      const overlay = document.createElement('div');
      overlay.className = 'loading-overlay';
      overlay.id = 'loadingOverlay';
      overlay.innerHTML = \`
        <div class="loading-spinner"></div>
        <div>\${message}</div>
      \`;
      document.getElementById('chartContainer').appendChild(overlay);
    }
    
    function hideLoadingOverlay() {
      const overlay = document.getElementById('loadingOverlay');
      if (overlay) overlay.remove();
    }
    
    // ========== IndexedDB Functions ==========
    const DB_NAME = 'KiteChartDB';
    const DB_VERSION = 1;
    const CANDLES_STORE = 'candles';
    
    function initDB() {
      return new Promise((resolve) => {
        const req = indexedDB.open(DB_NAME, DB_VERSION);
        req.onerror = () => resolve();
        req.onsuccess = (e) => { db = e.target.result; resolve(); };
        req.onupgradeneeded = (e) => {
          const database = e.target.result;
          if (!database.objectStoreNames.contains(CANDLES_STORE)) {
            const store = database.createObjectStore(CANDLES_STORE, { keyPath: 'id' });
            store.createIndex('token_interval_time', ['token', 'interval', 'time'], { unique: false });
          }
        };
      });
    }
    
    async function loadCandlesFromDB(token, interval) {
      if (!db) return [];
      return new Promise((resolve) => {
        try {
          const tx = db.transaction(CANDLES_STORE, 'readonly');
          const store = tx.objectStore(CANDLES_STORE);
          const index = store.index('token_interval_time');
          const range = IDBKeyRange.bound([token, interval, 0], [token, interval, Infinity]);
          
          const candles = [];
          index.openCursor(range).onsuccess = (e) => {
            const cursor = e.target.result;
            if (cursor) {
              candles.push({ time: cursor.value.time, open: cursor.value.open, high: cursor.value.high, low: cursor.value.low, close: cursor.value.close });
              cursor.continue();
            } else {
              resolve(candles);
            }
          };
        } catch (e) { resolve([]); }
      });
    }
    
    function saveCandle(candle) {
      if (!db) return;
      try {
        const tx = db.transaction(CANDLES_STORE, 'readwrite');
        const store = tx.objectStore(CANDLES_STORE);
        const id = \`\${candle.token}_\${candle.interval}_\${candle.time}\`;
        store.put({ ...candle, id });
      } catch (e) {}
    }
    
    async function cleanOldCandles() {
      if (!db) return;
      const tx = db.transaction(CANDLES_STORE, 'readwrite');
      const store = tx.objectStore(CANDLES_STORE);
      const cutoff = Math.floor(Date.now() / 1000) - (7 * 24 * 60 * 60);
      
      store.openCursor().onsuccess = (event) => {
        const cursor = event.target.result;
        if (cursor) {
          if (cursor.value.time < cutoff) cursor.delete();
          cursor.continue();
        }
      };
    }
    
    // ========== Stock Selection ==========
    function selectStock(token) {
      selectedToken = token;
      hasHistoricalData = false;
      document.getElementById('historyBadge').style.display = 'none';
      document.getElementById('historyStatus').style.display = 'none';
      updateHistoryButton();
      renderStockList();
      updateChartHeader();
      
      const noSelection = document.querySelector('.no-selection');
      if (noSelection) noSelection.remove();
      
      initChart();
      updateChart();
    }
    
    function setInterval(interval) {
      currentInterval = interval;
      document.querySelectorAll('.interval-btn').forEach(btn => btn.classList.remove('active'));
      document.querySelector(\`[data-interval="\${interval}"]\`).classList.add('active');
      updateChart();
    }
    
    function formatNum(n) { return n >= 1e7 ? (n/1e7).toFixed(2) + ' Cr' : n >= 1e5 ? (n/1e5).toFixed(2) + ' L' : n >= 1e3 ? (n/1e3).toFixed(2) + ' K' : String(n || 0); }
    function updateStatus(text, cls) { document.getElementById('connectionStatus').textContent = text; document.getElementById('connectionBadge').className = 'connection-badge ' + cls; }
    
    // ========== Chart Functions ==========
    function initChart() {
      const container = document.getElementById('chartContainer');
      if (chart) chart.remove();
      
      chart = LightweightCharts.createChart(container, {
        layout: { background: { color: '#0a0a0a' }, textColor: '#9ca3af' },
        width: container.offsetWidth,
        height: container.offsetHeight,
        grid: { vertLines: { color: '#1f1f23' }, horzLines: { color: '#1f1f23' } },
        crosshair: { mode: 0, vertLine: { color: '#fbbf24', width: 1, style: 3 }, horzLine: { color: '#fbbf24', width: 1, style: 3 } },
        rightPriceScale: { borderColor: '#27272a', scaleMargins: { top: 0.1, bottom: 0.2 } },
        timeScale: { borderColor: '#27272a', timeVisible: true, secondsVisible: false },
      });
      
      candleSeries = chart.addCandlestickSeries({
        upColor: '#22c55e',
        downColor: '#ef4444',
        borderUpColor: '#22c55e',
        borderDownColor: '#ef4444',
        wickUpColor: '#22c55e',
        wickDownColor: '#ef4444',
      });
      
      volumeSeries = chart.addHistogramSeries({
        color: '#60a5fa',
        priceFormat: { type: 'volume' },
        priceScaleId: '',
        scaleMargins: { top: 0.8, bottom: 0 },
      });
      
      window.addEventListener('resize', () => chart.resize(container.offsetWidth, container.offsetHeight));
    }
    
    function updateChart() {
      if (!chart || !selectedToken) return;
      const data = candleData[selectedToken][currentInterval] || [];
      if (data.length === 0) return;
      
      candleSeries.setData(data);
      const volumeData = data.map(d => ({ time: d.time, value: d.volume || 0, color: d.close >= d.open ? '#22c55e80' : '#ef444480' }));
      volumeSeries.setData(volumeData);
      
      document.getElementById('candleCount').textContent = data.length + ' candles';
      chart.timeScale().fitContent();
    }
    
    // ========== Candle Aggregation ==========
    function getIntervalMs(interval) {
      switch(interval) {
        case '1m': return 60 * 1000;
        case '5m': return 5 * 60 * 1000;
        case '15m': return 15 * 60 * 1000;
        default: return 60 * 1000;
      }
    }
    
    function getCandleTime(timestamp, interval) {
      const ms = getIntervalMs(interval);
      const utcSeconds = Math.floor(timestamp / 1000);
      const istSeconds = utcSeconds + IST_OFFSET;
      const intervalSeconds = ms / 1000;
      const candleIstSeconds = Math.floor(istSeconds / intervalSeconds) * intervalSeconds;
      return candleIstSeconds - IST_OFFSET;
    }
    
    function processTick(tick) {
      const token = tick.instrument_token;
      const price = tick.last_price;
      const volume = tick.volume || 0;
      const now = Date.now();
      
      ['1m', '5m', '15m'].forEach(interval => {
        const candleTime = getCandleTime(now, interval);
        let candle = currentCandle[token + '_' + interval];
        
        if (!candle || candle.time !== candleTime) {
          if (candle) {
            candleData[token][interval].push(candle);
            if (candleData[token][interval].length > 500) {
              candleData[token][interval] = candleData[token][interval].slice(-500);
            }
            saveCandle(candle);
          }
          
          candle = {
            token: token,
            interval: interval,
            time: candleTime,
            open: price,
            high: price,
            low: price,
            close: price,
            volume: volume
          };
          currentCandle[token + '_' + interval] = candle;
        } else {
          candle.high = Math.max(candle.high, price);
          candle.low = Math.min(candle.low, price);
          candle.close = price;
          candle.volume = volume;
        }
      });
      
      if (token === selectedToken) updateChart();
    }
    
    // ========== Stock List & Display ==========
    function renderStockList() {
      const list = document.getElementById('stockList');
      list.innerHTML = '';
      
      stocks.forEach(stock => {
        const d = stockData[stock.token];
        const cls = d.change > 0 ? 'up' : d.change < 0 ? 'down' : 'neutral';
        const arr = d.change > 0 ? '▲' : d.change < 0 ? '▼' : '';
        
        const item = document.createElement('div');
        item.className = 'stock-item' + (selectedToken === stock.token ? ' selected' : '');
        item.id = 'item-' + stock.token;
        item.onclick = () => selectStock(stock.token);
        
        item.innerHTML = '<div class="stock-row"><div><div class="stock-name">' + stock.symbol + '</div><div class="stock-token-id">' + stock.name + '</div></div><div class="stock-price"><div class="ltp ' + cls + '">₹' + (d.ltp ? d.ltp.toFixed(2) : '—') + '</div><div class="change ' + cls + '">' + arr + ' ' + d.changePercent.toFixed(2) + '%</div></div></div>';
        
        list.appendChild(item);
      });
    }
    
    function updateChartHeader() {
      if (!selectedToken) return;
      const d = stockData[selectedToken];
      const cls = d.change > 0 ? 'up' : d.change < 0 ? 'down' : '';
      const arr = d.change > 0 ? '▲' : d.change < 0 ? '▼' : '';
      
      document.getElementById('selectedName').textContent = d.symbol;
      document.getElementById('selectedPrice').textContent = '₹' + (d.ltp?.toFixed(2) || '—');
      document.getElementById('selectedPrice').className = 'selected-price ' + cls;
      document.getElementById('selectedChange').innerHTML = arr + ' ₹' + Math.abs(d.change).toFixed(2) + ' (' + (d.change >= 0 ? '+' : '') + d.changePercent.toFixed(2) + '%)';
      document.getElementById('selectedChange').className = 'selected-change ' + cls;
      
      document.getElementById('statOpen').textContent = '₹' + (d.ohlc.open?.toFixed(2) || '—');
      document.getElementById('statHigh').textContent = '₹' + (d.ohlc.high?.toFixed(2) || '—');
      document.getElementById('statLow').textContent = '₹' + (d.ohlc.low?.toFixed(2) || '—');
      document.getElementById('statClose').textContent = '₹' + (d.ohlc.close?.toFixed(2) || '—');
      document.getElementById('statVolume').textContent = formatNum(d.volume);
      document.getElementById('statBuyQty').textContent = formatNum(d.buyQty);
      document.getElementById('statSellQty').textContent = formatNum(d.sellQty);
    }
    
    function updateStock(tick) {
      const d = stockData[tick.instrument_token];
      if (!d) return;
      
      d.ltp = tick.last_price;
      d.ohlc = tick.ohlc || d.ohlc;
      d.volume = tick.volume || d.volume;
      d.buyQty = tick.buy_quantity || d.buyQty;
      d.sellQty = tick.sell_quantity || d.sellQty;
      
      if (d.ohlc.close) {
        d.change = d.ltp - d.ohlc.close;
        d.changePercent = (d.change / d.ohlc.close) * 100;
      }
      
      processTick(tick);
      lastTickTime[tick.instrument_token] = Date.now();
      tickCount++;
      updateLastTickDisplay();
      
      const item = document.getElementById('item-' + tick.instrument_token);
      if (item) {
        item.classList.add('updating');
        setTimeout(() => item.classList.remove('updating'), 300);
      }
      
      renderStockList();
    }
    
    // ========== WebSocket Functions ==========
    function connectWebSocket() {
      const accessToken = localStorage.getItem('access_token');
      if (!accessToken) {
        updateStatus('Not logged in', 'disconnected');
        return;
      }
      
      updateStatus('Connecting...', 'connecting');
      const apiKey = '${KiteConfig.apiKey}';
      ws = new WebSocket('wss://ws.kite.trade?api_key=' + apiKey + '&access_token=' + accessToken);
      ws.binaryType = 'arraybuffer';
      
      ws.onopen = () => {
        updateStatus('Live', 'connected');
        const tokens = stocks.map(s => s.token);
        ws.send(JSON.stringify({ a: 'subscribe', v: tokens }));
        setTimeout(() => ws.send(JSON.stringify({ a: 'mode', v: ['full', tokens] })), 500);
      };
      
      ws.onmessage = (event) => {
        if (event.data instanceof ArrayBuffer) {
          const buffer = event.data;
          if (buffer.byteLength < 2) return;
          
          const dv = new DataView(buffer);
          const n = dv.getInt16(0);
          let off = 2;
          
          for (let i = 0; i < n; i++) {
            if (off + 2 > buffer.byteLength) break;
            const len = dv.getInt16(off);
            off += 2;
            if (off + len > buffer.byteLength) break;
            
            const tick = parseTick(dv, off, len);
            if (tick) updateStock(tick);
            off += len;
          }
        }
      };
      
      ws.onerror = () => updateStatus('Error', 'disconnected');
      ws.onclose = (e) => {
        updateStatus('Disconnected', 'disconnected');
        if (e.code !== 1000) setTimeout(connectWebSocket, 5000);
      };
    }
    
    function parseTick(dv, off, len) {
      try {
        const token = dv.getInt32(off);
        if (len === 8) return { instrument_token: token, last_price: dv.getInt32(off + 4) / 100 };
        
        return {
          instrument_token: token,
          last_price: dv.getInt32(off + 4) / 100,
          volume: dv.getInt32(off + 16),
          buy_quantity: dv.getInt32(off + 20),
          sell_quantity: dv.getInt32(off + 24),
          ohlc: {
            open: dv.getInt32(off + 28) / 100,
            high: dv.getInt32(off + 32) / 100,
            low: dv.getInt32(off + 36) / 100,
            close: dv.getInt32(off + 40) / 100
          }
        };
      } catch (e) { return null; }
    }
    
    // ========== Real-time Clock ==========
    function updateClock() {
      const now = new Date();
      const ist = new Date(now.getTime() + (IST_OFFSET * 1000) - (now.getTimezoneOffset() * 60 * 1000));
      const time = ist.toTimeString().split(' ')[0];
      document.getElementById('realtimeClock').textContent = time + ' IST';
    }
    setInterval(updateClock, 1000);
    updateClock();
    
    // ========== Last Tick Display ==========
    function updateLastTickDisplay() {
      if (!selectedToken) return;
      const lastTime = lastTickTime[selectedToken];
      const el = document.getElementById('lastTick');
      if (!el) return;
      
      if (lastTime) {
        const ago = Math.floor((Date.now() - lastTime) / 1000);
        el.textContent = 'Last tick: ' + ago + 's ago (#' + tickCount + ')';
        el.className = 'last-tick ' + (ago < 5 ? 'fresh' : 'stale');
      } else {
        el.textContent = 'Waiting for tick...';
        el.className = 'last-tick';
      }
    }
    setInterval(updateLastTickDisplay, 1000);
    
    // ========== Initialize ==========
    async function init() {
      await initDB();
      await cleanOldCandles();
      renderStockList();
      connectWebSocket();
    }
    
    init();
  </script>
</body>
</html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: _viewType);
  }
}
