const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const axios = require('axios');

const app = express();
app.use(cors());
app.use(bodyParser.json());

const API_BASE_URL = 'https://api.example.com';
const API_KEY = '你的APIKEY';

async function callAPI(endpoint, data) {
  const res = await axios.post(`${API_BASE_URL}/${endpoint}`, data, {
    headers: { 'Authorization': `Bearer ${API_KEY}` }
  });
  return res.data;
}

// 翻译接口
app.post('/api/translate', async (req, res) => {
  const { text, targetLang } = req.body;
  try {
    const data = await callAPI('translate', { text, targetLang });
    res.json({ translatedText: data.translatedText });
  } catch {
    res.status(500).json({ error: '翻译失败' });
  }
});

// 关键词梗概接口
app.post('/api/keywords_summary', async (req, res) => {
  const { text } = req.body;
  try {
    const data = await callAPI('keywords_summary', { text });
    res.json({ keywords: data.keywords, summary: data.summary });
  } catch {
    res.status(500).json({ error: '生成关键词与梗概失败' });
  }
});

// 海报接口
app.post('/api/generate_poster', async (req, res) => {
  const { prompt } = req.body;
  try {
    const data = await callAPI('generate_poster', { prompt });
    res.json({ url: data.url });
  } catch {
    res.status(500).json({ error: '生成海报失败' });
  }
});

app.listen(3000, () => console.log('Server running on http://localhost:3000'));
