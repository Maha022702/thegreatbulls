export default async function handler(req, res) {
  // CORS preflight support
  if (req.method === 'OPTIONS') {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET,OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', 'Authorization, Content-Type');
    return res.status(200).end();
  }

  const { token, interval } = req.query;
  const { from, to } = req.query;

  if (!token || !interval || !from || !to) {
    return res.status(400).json({ error: 'Missing token/interval/from/to' });
  }

  const authHeader = req.headers['authorization'] || '';
  const accessToken = authHeader.replace('token', '').trim();
  const apiKey = process.env.KITE_API_KEY;

  if (!apiKey) {
    return res.status(500).json({ error: 'KITE_API_KEY not configured on server' });
  }
  if (!accessToken) {
    return res.status(401).json({ error: 'Missing access token' });
  }

  const url = `https://api.kite.trade/instruments/historical/${token}/${interval}?from=${from}&to=${to}`;

  try {
    const kiteResp = await fetch(url, {
      headers: {
        Authorization: `token ${apiKey}:${accessToken}`,
        'X-Kite-Version': '3',
      },
    });

    const text = await kiteResp.text();
    res.setHeader('Access-Control-Allow-Origin', '*');

    if (!kiteResp.ok) {
      return res.status(kiteResp.status).send(text);
    }

    // Pass through JSON
    res.setHeader('Content-Type', 'application/json');
    return res.status(200).send(text);
  } catch (err) {
    console.error('Proxy error', err);
    res.setHeader('Access-Control-Allow-Origin', '*');
    return res.status(502).json({ error: 'Upstream fetch failed', detail: err.message });
  }
}
