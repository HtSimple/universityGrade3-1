<template>
  <div class="page-wrapper">
    <!-- 顶部标题栏 -->
    <header class="page-header">
      <h1>🎬 微短剧翻译与海报生成工具</h1>
    </header>

    <!-- 主体内容 -->
    <main class="app-container">
      <!-- 左1：上传 + 翻译 -->
      <div class="panel upload-translate">
        <section class="upload-section">
          <h2>1️⃣ 上传剧本</h2>
          <input type="file" accept=".fountain,.txt" @change="handleFileUpload" />
          <p v-if="scriptContent" class="filename">已上传文件：{{ fileName }}</p>
        </section>

        <section class="translation-section">
          <h2>2️⃣ 翻译剧本</h2>
          <div class="lang-select">
            <label>目标语言：</label>
            <select v-model="targetLang">
              <option value="en">英语</option>
              <option value="zh">中文</option>
            </select>
            <button @click="translateScript" :disabled="!scriptContent">开始翻译</button>
          </div>
          <textarea
            v-model="translatedScript"
            placeholder="翻译后的剧本内容..."
          ></textarea>
        </section>
      </div>

      <!-- 左2：关键词与剧情梗概 -->
      <div class="panel">
        <h2>3️⃣ 关键词与剧情梗概</h2>
        <button @click="generateKeywordsAndSummary" :disabled="!translatedScript">生成关键词与梗概</button>
        <div class="keyword-cloud">
          <span v-for="kw in keywords" :key="kw" class="keyword">{{ kw }}</span>
        </div>
        <textarea v-model="summary" placeholder="剧情梗概..."></textarea>
      </div>

      <!-- 左3：提示词 -->
      <div class="panel">
        <h2>4️⃣ 提示词生成</h2>

        <button class="prompt-btn" @click="optimizePrompt" :disabled="!translatedScript">
          生成提示词
        </button>

        <textarea v-model="prompt" placeholder="提示词内容..."></textarea>
      </div>

      <!-- 左4：海报 -->
      <div class="panel">
        <h2>5️⃣ 海报生成</h2>
        <button @click="generatePoster" :disabled="!prompt">生成海报</button>
        <div v-if="posterUrl" class="poster-preview">
          <img :src="posterUrl" alt="海报预览" />
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref } from 'vue';

const fileName = ref('');
const scriptContent = ref('');
const translatedScript = ref('');
const targetLang = ref('en');
const keywords = ref([]);
const summary = ref('');
const prompt = ref('');
const posterUrl = ref('');

// 上传文件
function handleFileUpload(event) {
  const file = event.target.files[0];
  if (!file) return;
  fileName.value = file.name;
  const reader = new FileReader();
  reader.onload = (e) => {
    scriptContent.value = e.target.result;
  };
  reader.readAsText(file);
}

// 翻译
async function translateScript() {
  const res = await fetch('/api/translate', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      text: scriptContent.value,
      targetLang: targetLang.value
    })
  });
  const data = await res.json();
  translatedScript.value = data.translatedText;
}

// 关键词与梗概
async function generateKeywordsAndSummary() {
  const res = await fetch('/api/keywords_summary', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ text: translatedScript.value })
  });
  const data = await res.json();
  keywords.value = data.keywords;
  summary.value = data.summary;
  prompt.value = `题材: ${keywords.value.join(', ')}; 剧情: ${summary.value}`;
}

// 优化提示词
function optimizePrompt() {
  prompt.value += '，高清风格，微短剧风格';
}

// 生成海报
async function generatePoster() {
  const res = await fetch('/api/generate_poster', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ prompt: prompt.value })
  });
  const data = await res.json();
  posterUrl.value = data.url;
}
</script>

<style scoped>
html, body, #app {
  height: 100%;
  margin: 0;
  background: linear-gradient(to bottom right, #e8f4ff, #d7ecff);
  font-family: 'Segoe UI', Roboto, sans-serif;
}

/* 顶部标题栏 */
.page-header {
  text-align: center;
  padding: 5px 0;
  color: #003366;
  background: rgba(255, 255, 255, 0.7);
  backdrop-filter: blur(6px);
  border-bottom: 2px solid #cce0ff;
}
.page-header h1 {
  font-size: 28px;
  margin-bottom: 4px;
}
.page-header p {
  color: #336699;
  font-size: 16px;
}

/* 主体布局 */
.app-container {
  display: flex;
  height: calc(100vh - 100px);
  width: 100%;
  gap: 12px;
  padding: 12px;
  box-sizing: border-box;
}

/* 每个面板 */
.panel {
  flex: 1;
  background: #ffffff;
  border-radius: 10px;
  padding: 12px;
  box-shadow: 0 4px 12px rgba(0, 100, 200, 0.1);
  display: flex;
  flex-direction: column;
  transition: transform 0.2s, box-shadow 0.2s;
}
.panel:hover {
  transform: translateY(-4px);
  box-shadow: 0 6px 16px rgba(0, 100, 200, 0.2);
}

/* 上传+翻译区双层 */
.upload-translate {
  display: flex;
  flex-direction: column;
  gap: 10px;
}
.upload-section {
  flex: 0.15; 
}
.translation-section {
  flex: 0.85;
}

.lang-select {
  display: flex;
  align-items: center;
  gap: 10px;
}

.lang-select button {
  margin-left: 40px;
}

section {
  flex: 1;
  background: #f9fbff;
  border-radius: 8px;
  padding: 10px;
  display: flex;
  flex-direction: column;
  box-shadow: inset 0 0 3px rgba(0,0,0,0.05);
}

/* 通用元素样式 */
textarea {
  flex: 1;
  resize: none;
  margin-top: 8px;
  padding: 10px;
  border: 1px solid #aacfff;
  border-radius: 6px;
  box-sizing: border-box;
  font-size: 14px;
  background-color: #fdfefe;
}

.keyword-cloud {
  display: flex;
  flex-wrap: wrap;
  margin-top: 8px;
}
.keyword {
  background-color: #cce7ff;
  color: #003366;
  margin: 4px;
  padding: 5px 10px;
  border-radius: 6px;
  font-weight: bold;
  transition: background 0.2s;
}
.keyword:hover {
  background-color: #99d0ff;
}

.poster-preview {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
}
.poster-preview img {
  max-width: 100%;
  max-height: 100%;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.15);
}

/* 按钮美化 */
button {
  margin-top: 10px;
  padding: 8px 14px;
  background-color: #0078ff;
  color: white;
  border: none;
  border-radius: 6px;
  font-size: 14px;
  cursor: pointer;
  transition: background 0.2s, transform 0.1s;
}
button:hover:not(:disabled) {
  background-color: #005fcc;
  transform: translateY(-2px);
}
button:disabled {
  background-color: #b0c8e8;
  cursor: not-allowed;
}



.filename {
  color: #0066aa;
  font-size: 13px;
  margin-top: 4px;
}
</style>
