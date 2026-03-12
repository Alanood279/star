<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BuildFlow AI - منصة الذكاء الاصطناعي لبناء المواقع</title>
    
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Tajawal:wght@300;400;500;700;800;900&display=swap" rel="stylesheet">
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --primary: #8b5cf6;
            --primary-dark: #7c3aed;
            --primary-light: #a78bfa;
            --secondary: #ec4899;
            --success: #10b981;
            --warning: #f59e0b;
            --error: #ef4444;
            --dark: #0f172a;
            --light: #f8fafc;
            --gray: #64748b;
        }

        body {
            font-family: 'Tajawal', sans-serif;
            background: var(--light);
            color: var(--dark);
            transition: all 0.3s;
        }

        body.dark {
            background: var(--dark);
            color: var(--light);
        }

        /* AI Chat Styles */
        .ai-chat-container {
            position: fixed;
            bottom: 20px;
            right: 20px;
            z-index: 1000;
        }

        .ai-chat-button {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: 0 10px 25px rgba(139, 92, 246, 0.4);
            transition: all 0.3s;
            position: relative;
            overflow: hidden;
        }

        .ai-chat-button::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, transparent, rgba(255,255,255,0.3), transparent);
            transform: rotate(45deg);
            animation: shimmer 3s infinite;
        }

        @keyframes shimmer {
            0% { transform: translateX(-100%) rotate(45deg); }
            100% { transform: translateX(100%) rotate(45deg); }
        }

        .ai-chat-button:hover {
            transform: scale(1.1) rotate(5deg);
        }

        .ai-chat-button svg {
            width: 30px;
            height: 30px;
            fill: white;
        }

        .ai-chat-window {
            position: absolute;
            bottom: 80px;
            right: 0;
            width: 350px;
            height: 500px;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.2);
            display: none;
            flex-direction: column;
            overflow: hidden;
        }

        .dark .ai-chat-window {
            background: #1e293b;
        }

        .ai-chat-window.show {
            display: flex;
            animation: slideIn 0.3s;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .ai-chat-header {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            padding: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .ai-status {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .ai-dot {
            width: 8px;
            height: 8px;
            background: var(--success);
            border-radius: 50%;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { box-shadow: 0 0 0 0 rgba(16, 185, 129, 0.7); }
            70% { box-shadow: 0 0 0 10px rgba(16, 185, 129, 0); }
            100% { box-shadow: 0 0 0 0 rgba(16, 185, 129, 0); }
        }

        .ai-chat-messages {
            flex: 1;
            padding: 15px;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .message {
            display: flex;
            gap: 10px;
            max-width: 80%;
        }

        .message.user {
            align-self: flex-end;
            flex-direction: row-reverse;
        }

        .message-avatar {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 12px;
        }

        .message-content {
            padding: 10px 15px;
            border-radius: 15px;
            background: #f1f5f9;
            font-size: 14px;
        }

        .dark .message-content {
            background: #334155;
            color: white;
        }

        .message.user .message-content {
            background: var(--primary);
            color: white;
        }

        .message.ai .message-content {
            background: linear-gradient(135deg, #f1f5f9, #e2e8f0);
        }

        .dark .message.ai .message-content {
            background: linear-gradient(135deg, #334155, #1e293b);
        }

        .typing-indicator {
            display: flex;
            gap: 5px;
            padding: 10px 15px;
            background: #f1f5f9;
            border-radius: 15px;
            width: fit-content;
        }

        .dark .typing-indicator {
            background: #334155;
        }

        .typing-dot {
            width: 8px;
            height: 8px;
            background: var(--gray);
            border-radius: 50%;
            animation: typing 1.4s infinite;
        }

        .typing-dot:nth-child(2) { animation-delay: 0.2s; }
        .typing-dot:nth-child(3) { animation-delay: 0.4s; }

        @keyframes typing {
            0%, 60%, 100% { transform: translateY(0); }
            30% { transform: translateY(-10px); background: var(--primary); }
        }

        .ai-chat-input {
            padding: 15px;
            border-top: 1px solid rgba(0,0,0,0.1);
            display: flex;
            gap: 10px;
        }

        .dark .ai-chat-input {
            border-top-color: rgba(255,255,255,0.1);
        }

        .ai-chat-input input {
            flex: 1;
            padding: 10px 15px;
            border: 1px solid rgba(0,0,0,0.1);
            border-radius: 25px;
            outline: none;
            font-family: inherit;
        }

        .dark .ai-chat-input input {
            background: #334155;
            border-color: rgba(255,255,255,0.1);
            color: white;
        }

        .ai-chat-input button {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: var(--primary);
            border: none;
            color: white;
            cursor: pointer;
            transition: all 0.3s;
        }

        .ai-chat-input button:hover {
            background: var(--primary-dark);
            transform: scale(1.1);
        }

        /* AI Generator Styles */
        .ai-generator-section {
            padding: 80px 0;
            background: linear-gradient(135deg, rgba(139, 92, 246, 0.1), rgba(236, 72, 153, 0.1));
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        .ai-generator-header {
            text-align: center;
            margin-bottom: 50px;
        }

        .ai-generator-header h2 {
            font-size: 40px;
            font-weight: 800;
            margin-bottom: 15px;
        }

        .gradient-text {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .ai-generator-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-top: 30px;
        }

        .ai-input-card {
            background: white;
            padding: 30px;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
        }

        .dark .ai-input-card {
            background: #1e293b;
        }

        .ai-input-card h3 {
            margin-bottom: 20px;
            font-size: 24px;
        }

        .ai-prompt-input {
            width: 100%;
            padding: 15px;
            border: 2px solid rgba(0,0,0,0.1);
            border-radius: 15px;
            font-size: 16px;
            font-family: inherit;
            resize: none;
            margin-bottom: 20px;
            transition: all 0.3s;
        }

        .ai-prompt-input:focus {
            border-color: var(--primary);
            outline: none;
            box-shadow: 0 0 0 3px rgba(139, 92, 246, 0.2);
        }

        .dark .ai-prompt-input {
            background: #334155;
            border-color: rgba(255,255,255,0.1);
            color: white;
        }

        .ai-options {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 10px;
            margin-bottom: 20px;
        }

        .ai-option {
            text-align: center;
            padding: 10px;
            border: 2px solid rgba(0,0,0,0.1);
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.3s;
        }

        .ai-option:hover {
            border-color: var(--primary);
            background: rgba(139, 92, 246, 0.1);
        }

        .ai-option.selected {
            border-color: var(--primary);
            background: var(--primary);
            color: white;
        }

        .ai-option svg {
            width: 30px;
            height: 30px;
            margin-bottom: 5px;
            fill: currentColor;
        }

        .ai-generate-btn {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            border: none;
            border-radius: 15px;
            font-size: 18px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            position: relative;
            overflow: hidden;
        }

        .ai-generate-btn::after {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, transparent, rgba(255,255,255,0.3), transparent);
            transform: rotate(45deg);
            animation: shimmer 3s infinite;
        }

        .ai-generate-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(139, 92, 246, 0.4);
        }

        .ai-output-card {
            background: white;
            padding: 30px;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            min-height: 400px;
        }

        .dark .ai-output-card {
            background: #1e293b;
        }

        .ai-output-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .ai-output-title {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .ai-badge {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
        }

        .ai-output-content {
            min-height: 300px;
            position: relative;
        }

        .ai-loading {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            text-align: center;
        }

        .ai-spinner {
            width: 50px;
            height: 50px;
            border: 4px solid rgba(139, 92, 246, 0.3);
            border-top-color: var(--primary);
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin: 0 auto 20px;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        .generated-element {
            background: linear-gradient(135deg, #f1f5f9, #e2e8f0);
            padding: 20px;
            border-radius: 15px;
            margin-bottom: 15px;
            animation: fadeIn 0.5s;
        }

        .dark .generated-element {
            background: linear-gradient(135deg, #334155, #1e293b);
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* AI Suggestions */
        .ai-suggestions {
            margin-top: 20px;
        }

        .suggestion-chip {
            display: inline-block;
            padding: 8px 15px;
            background: rgba(139, 92, 246, 0.1);
            border: 1px solid var(--primary);
            border-radius: 25px;
            margin: 0 5px 10px 0;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.3s;
        }

        .suggestion-chip:hover {
            background: var(--primary);
            color: white;
        }

        /* AI Insights */
        .ai-insights {
            margin-top: 30px;
            padding: 20px;
            background: linear-gradient(135deg, rgba(16, 185, 129, 0.1), rgba(139, 92, 246, 0.1));
            border-radius: 15px;
            border-right: 4px solid var(--primary);
        }

        .insight-title {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 10px;
            font-weight: 600;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .ai-generator-grid {
                grid-template-columns: 1fr;
            }
            
            .ai-chat-window {
                width: 300px;
            }
        }
    </style>
</head>
<body>
    <!-- AI Chat Widget -->
    <div class="ai-chat-container">
        <div class="ai-chat-button" onclick="toggleAIChat()">
            <svg viewBox="0 0 24 24">
                <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8zm0-14c-3.31 0-6 2.69-6 6s2.69 6 6 6 6-2.69 6-6-2.69-6-6-6z"/>
                <circle cx="12" cy="12" r="4"/>
            </svg>
        </div>
        
        <div class="ai-chat-window" id="aiChatWindow">
            <div class="ai-chat-header">
                <div class="ai-status">
                    <span class="ai-dot"></span>
                    <span>مساعد AI ذكي</span>
                </div>
                <button onclick="toggleAIChat()" style="background: none; border: none; color: white; cursor: pointer;">✕</button>
            </div>
            
            <div class="ai-chat-messages" id="aiChatMessages">
                <div class="message ai">
                    <div class="message-avatar">AI</div>
                    <div class="message-content">
                        مرحباً! أنا مساعدك الذكي. كيف يمكنني مساعدتك في بناء موقعك اليوم؟
                    </div>
                </div>
            </div>
            
            <div class="ai-chat-input">
                <input type="text" placeholder="اسألني عن أي شيء..." id="aiChatInput">
                <button onclick="sendAIMessage()">➤</button>
            </div>
        </div>
    </div>

    <!-- AI Generator Section -->
    <section class="ai-generator-section">
        <div class="container">
            <div class="ai-generator-header">
                <h2>مولد <span class="gradient-text">الذكاء الاصطناعي</span></h2>
                <p>صف ما تريد بناءه وسيقوم الذكاء الاصطناعي بإنشائه لك</p>
            </div>
            
            <div class="ai-generator-grid">
                <!-- Input Side -->
                <div class="ai-input-card">
                    <h3>📝 صف فكرتك</h3>
                    
                    <textarea class="ai-prompt-input" id="aiPrompt" rows="5" 
                        placeholder="مثال: أريد صفحة هبوط لمتجر عطور فاخرة، مع قسم رئيسي، صور منتجات، وأزرار تسوق..."></textarea>
                    
                    <div class="ai-options">
                        <div class="ai-option selected" onclick="selectAIOption(this, 'website')" data-type="website">
                            <svg viewBox="0 0 24 24">
                                <path d="M20 4H4a2 2 0 00-2 2v12a2 2 0 002 2h16a2 2 0 002-2V6a2 2 0 00-2-2zm-8 2h6v2h-6V6zm0 4h6v2h-6v-2zm-6 0h4v2H6v-2zm10 4h-4v-2h4v2zm-10 0h4v2H6v-2z"/>
                            </svg>
                            <span>موقع كامل</span>
                        </div>
                        <div class="ai-option" onclick="selectAIOption(this, 'section')" data-type="section">
                            <svg viewBox="0 0 24 24">
                                <path d="M3 3h18v18H3V3zm2 2v14h14V5H5zm2 2h10v2H7V7zm0 4h10v2H7v-2zm0 4h6v2H7v-2z"/>
                            </svg>
                            <span>قسم</span>
                        </div>
                        <div class="ai-option" onclick="selectAIOption(this, 'component')" data-type="component">
                            <svg viewBox="0 0 24 24">
                                <path d="M12 2L2 7l10 5 10-5-10-5zm0 7L4.06 7 12 3.06 19.94 7 12 9zM2 17l10 5 10-5M2 12l10 5 10-5"/>
                            </svg>
                            <span>عنصر</span>
                        </div>
                    </div>
                    
                    <button class="ai-generate-btn" onclick="generateWithAI()">
                        <span>🤖 توليد بالذكاء الاصطناعي</span>
                    </button>
                    
                    <!-- AI Suggestions -->
                    <div class="ai-suggestions">
                        <p style="color: var(--gray); margin-bottom: 10px;">اقتراحات سريعة:</p>
                        <span class="suggestion-chip" onclick="useSuggestion('صفحة هبوط لمتجر ملابس')">متجر ملابس</span>
                        <span class="suggestion-chip" onclick="useSuggestion('موقع مطعم مع قائمة طعام')">مطعم</span>
                        <span class="suggestion-chip" onclick="useSuggestion('صفحة شخصية لكاتب')">صفحة شخصية</span>
                        <span class="suggestion-chip" onclick="useSuggestion('مدونة تقنية')">مدونة</span>
                    </div>
                </div>
                
                <!-- Output Side -->
                <div class="ai-output-card">
                    <div class="ai-output-header">
                        <div class="ai-output-title">
                            <span class="ai-badge">AI GENERATED</span>
                            <span id="generatedType">موقع كامل</span>
                        </div>
                        <div>
                            <button class="suggestion-chip" onclick="copyGenerated()">📋 نسخ</button>
                            <button class="suggestion-chip" onclick="useGenerated()">✨ استخدام</button>
                        </div>
                    </div>
                    
                    <div class="ai-output-content" id="aiOutput">
                        <!-- سيتم عرض النتيجة هنا -->
                        <div class="ai-loading" id="aiLoading" style="display: none;">
                            <div class="ai-spinner"></div>
                            <p>AI يقوم بالتحليل والإنشاء...</p>
                        </div>
                        
                        <div id="generatedResult">
                            <!-- النتيجة الافتراضية -->
                            <div class="generated-element">
                                <h3 style="color: var(--primary); margin-bottom: 10px;">✨ مرحباً بك في مولد الذكاء الاصطناعي</h3>
                                <p>اكتب وصفاً لما تريد وسيقوم AI بإنشائه لك تلقائياً</p>
                                <div style="background: rgba(139, 92, 246, 0.1); padding: 15px; border-radius: 10px; margin-top: 15px;">
                                    <strong>مثال:</strong> "أريد صفحة هبوط لمتجر عطور مع قسم رئيسي وصور منتجات"
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- AI Insights -->
                    <div class="ai-insights" id="aiInsights" style="display: none;">
                        <div class="insight-title">
                            <span>💡</span>
                            <span>تحليلات وتوصيات AI</span>
                        </div>
                        <p id="insightText"></p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <script>
        // ==================== AI Configuration ====================
        const AI_CONFIG = {
            model: 'gpt-4', // يمكن تغييره حسب API المستخدم
            temperature: 0.7,
            maxTokens: 500,
            apiKey: 'YOUR_API_KEY', // ضع مفتاح API هنا
            apiEndpoint: 'https://api.openai.com/v1/chat/completions' // مثال OpenAI
        };

        // ==================== AI Chat System ====================
        let aiChatOpen = false;
        let chatHistory = [];

        function toggleAIChat() {
            aiChatOpen = !aiChatOpen;
            document.getElementById('aiChatWindow').classList.toggle('show');
        }

        async function sendAIMessage() {
            const input = document.getElementById('aiChatInput');
            const message = input.value.trim();
            
            if (!message) return;
            
            // Add user message
            addChatMessage(message, 'user');
            input.value = '';
            
            // Show typing indicator
            showTypingIndicator();
            
            try {
                // Get AI response
                const response = await getAIResponse(message, chatHistory);
                
                // Remove typing indicator
                removeTypingIndicator();
                
                // Add AI response
                addChatMessage(response, 'ai');
                
            } catch (error) {
                console.error('AI Error:', error);
                removeTypingIndicator();
                addChatMessage('عذراً، حدث خطأ. يرجى المحاولة مرة أخرى.', 'ai');
            }
        }

        function addChatMessage(text, sender) {
            const messages = document.getElementById('aiChatMessages');
            const messageDiv = document.createElement('div');
            messageDiv.className = `message ${sender}`;
            
            const avatar = sender === 'ai' ? 'AI' : 'أنت';
            
            messageDiv.innerHTML = `
                <div class="message-avatar">${avatar}</div>
                <div class="message-content">${text}</div>
            `;
            
            messages.appendChild(messageDiv);
            messages.scrollTop = messages.scrollHeight;
            
            // Save to history
            chatHistory.push({ role: sender, content: text });
        }

        function showTypingIndicator() {
            const messages = document.getElementById('aiChatMessages');
            const indicator = document.createElement('div');
            indicator.className = 'message ai';
            indicator.id = 'typingIndicator';
            indicator.innerHTML = `
                <div class="message-avatar">AI</div>
                <div class="typing-indicator">
                    <div class="typing-dot"></div>
                    <div class="typing-dot"></div>
                    <div class="typing-dot"></div>
                </div>
            `;
            messages.appendChild(indicator);
            messages.scrollTop = messages.scrollHeight;
        }

        function removeTypingIndicator() {
            const indicator = document.getElementById('typingIndicator');
            if (indicator) indicator.remove();
        }

        // ==================== AI Generator ====================
        let selectedAIType = 'website';

        function selectAIOption(element, type) {
            // Remove selected class from all
            document.querySelectorAll('.ai-option').forEach(opt => {
                opt.classList.remove('selected');
            });
            
            // Add selected class to clicked
            element.classList.add('selected');
            selectedAIType = type;
            
            // Update label
            const typeNames = {
                'website': 'موقع كامل',
                'section': 'قسم',
                'component': 'عنصر'
            };
            document.getElementById('generatedType').textContent = typeNames[type];
        }

        function useSuggestion(text) {
            document.getElementById('aiPrompt').value = text;
        }

        async function generateWithAI() {
            const prompt = document.getElementById('aiPrompt').value;
            
            if (!prompt.trim()) {
                alert('الرجاء كتابة وصف لما تريد إنشاؤه');
                return;
            }
            
            // Show loading
            document.getElementById('aiLoading').style.display = 'block';
            document.getElementById('generatedResult').style.opacity = '0.3';
            
            try {
                // Get AI generation
                const result = await generateAIContent(prompt, selectedAIType);
                
                // Hide loading
                document.getElementById('aiLoading').style.display = 'none';
                document.getElementById('generatedResult').style.opacity = '1';
                
                // Display result
                displayGeneratedResult(result);
                
                // Get AI insights
                await generateAIInsights(prompt, result);
                
            } catch (error) {
                console.error('Generation Error:', error);
                document.getElementById('aiLoading').style.display = 'none';
                document.getElementById('generatedResult').style.opacity = '1';
                alert('حدث خطأ في التوليد. يرجى المحاولة مرة أخرى.');
            }
        }

        // ==================== AI API Integration ====================
        
        // دالة الحصول على رد من الذكاء الاصطناعي
        async function getAIResponse(message, history) {
            // محاكاة رد AI (للتجربة)
            await new Promise(resolve => setTimeout(resolve, 1500));
            
            const responses = {
                'مرحبا': 'أهلاً بك! كيف يمكنني مساعدتك؟',
                'تصميم': 'يمكنني مساعدتك في تصميم موقعك. ماذا تريد بالضبط؟',
                'متجر': 'لإنشاء متجر إلكتروني، أحتاج لمعرفة نوع المنتجات التي تبيعها',
                'سعر': 'الأسعار تبدأ من $19 شهرياً للخطة الاحترافية',
                'مساعدة': 'بالطبع! ماذا تريد أن تعرف؟'
            };
            
            // البحث عن كلمة مفتاحية في الرسالة
            for (let [key, response] of Object.entries(responses)) {
                if (message.includes(key)) {
                    return response;
                }
            }
            
            return 'شكراً لتواصلك. سأقوم بتحليل طلبك ومساعدتك في أقرب وقت.';
            
            /* للتكامل الفعلي مع OpenAI:
            const response = await fetch(AI_CONFIG.apiEndpoint, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${AI_CONFIG.apiKey}`
                },
                body: JSON.stringify({
                    model: AI_CONFIG.model,
                    messages: [
                        { role: 'system', content: 'أنت مساعد ذكي متخصص في بناء المواقع.' },
                        ...history.map(msg => ({
                            role: msg.role === 'ai' ? 'assistant' : 'user',
                            content: msg.content
                        })),
                        { role: 'user', content: message }
                    ],
                    temperature: AI_CONFIG.temperature,
                    max_tokens: AI_CONFIG.maxTokens
                })
            });
            
            const data = await response.json();
            return data.choices[0].message.content;
            */
        }

        // دالة توليد المحتوى
        async function generateAIContent(prompt, type) {
            // محاكاة توليد AI
            await new Promise(resolve => setTimeout(resolve, 2000));
            
            const templates = {
                website: `
                    <div class="generated-element">
                        <header style="background: linear-gradient(135deg, #8b5cf6, #ec4899); color: white; padding: 60px 20px; text-align: center; border-radius: 15px;">
                            <h1 style="font-size: 36px; margin-bottom: 20px;">${prompt.split(' ').slice(0, 3).join(' ')}</h1>
                            <p style="font-size: 18px; opacity: 0.9; max-width: 600px; margin: 0 auto;">تم إنشاؤه بواسطة الذكاء الاصطناعي خصيصاً لك</p>
                            <button style="background: white; color: #8b5cf6; border: none; padding: 12px 30px; border-radius: 25px; margin-top: 30px; font-weight: bold;">ابدأ الآن</button>
                        </header>
                        
                        <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-top: 30px;">
                            <div style="background: #f1f5f9; padding: 20px; border-radius: 10px;">
                                <h3>ميزة 1</h3>
                                <p style="color: #64748b;">وصف الميزة الأولى هنا</p>
                            </div>
                            <div style="background: #f1f5f9; padding: 20px; border-radius: 10px;">
                                <h3>ميزة 2</h3>
                                <p style="color: #64748b;">وصف الميزة الثانية هنا</p>
                            </div>
                            <div style="background: #f1f5f9; padding: 20px; border-radius: 10px;">
                                <h3>ميزة 3</h3>
                                <p style="color: #64748b;">وصف الميزة الثالثة هنا</p>
                            </div>
                        </div>
                    </div>
                `,
                
                section: `
                    <div class="generated-element">
                        <section style="padding: 40px; background: white; border-radius: 15px;">
                            <h2 style="color: #8b5cf6; margin-bottom: 20px;">${prompt}</h2>
                            <p style="color: #64748b; line-height: 1.8;">هذا القسم تم إنشاؤه بواسطة الذكاء الاصطناعي لتلبية احتياجاتك. يمكنك تعديل المحتوى حسب رغبتك.</p>
                            <div style="display: flex; gap: 15px; margin-top: 20px;">
                                <span style="background: #f1f5f9; padding: 5px 15px; border-radius: 20px;">#تصميم</span>
                                <span style="background: #f1f5f9; padding: 5px 15px; border-radius: 20px;">#ابتكار</span>
                                <span style="background: #f1f5f9; padding: 5px 15px; border-radius: 20px;">#احترافية</span>
                            </div>
                        </section>
                    </div>
                `,
                
                component: `
                    <div class="generated-element">
                        <div style="background: linear-gradient(135deg, #f1f5f9, #e2e8f0); padding: 30px; border-radius: 15px;">
                            <h3 style="color: #8b5cf6; margin-bottom: 15px;">عنصر تفاعلي</h3>
                            <div style="display: flex; gap: 10px;">
                                <input type="text" placeholder="أدخل نصاً" style="flex: 1; padding: 10px; border: 1px solid #ddd; border-radius: 8px;">
                                <button style="background: #8b5cf6; color: white; border: none; padding: 10px 20px; border-radius: 8px; cursor: pointer;">إرسال</button>
                            </div>
                            <p style="color: #64748b; margin-top: 15px;">${prompt}</p>
                        </div>
                    </div>
                `
            };
            
            return templates[type] || templates.website;
        }

        // دالة توليد التحليلات
        async function generateAIInsights(prompt, result) {
            await new Promise(resolve => setTimeout(resolve, 1000));
            
            const insights = [
                '✅ هذا التصميم مناسب تماماً للهواتف المحمولة',
                '🎨 الألوان المستخدمة تزيد من نسبة التحويل بنسبة 30%',
                '📱 يمكن تحسين سرعة التحميل بتحسين الصور',
                '🔍 SEO: الكلمات المفتاحية قوية جداً',
                '⚡ الأداء متوقع أن يكون ممتازاً'
            ];
            
            const insightText = insights[Math.floor(Math.random() * insights.length)];
            
            document.getElementById('aiInsights').style.display = 'block';
            document.getElementById('insightText').textContent = insightText;
        }

        function displayGeneratedResult(html) {
            document.getElementById('generatedResult').innerHTML = html;
        }

        function copyGenerated() {
            const result = document.getElementById('generatedResult').innerHTML;
            navigator.clipboard.writeText(result).then(() => {
                alert('تم نسخ الكود!');
            });
        }

        function useGenerated() {
            alert('تم تطبيق التصميم على المحرر');
            // هنا يمكن إضافة المنطق لتطبيق التصميم على المحرر
        }

        // ==================== AI Image Analysis (اختياري) ====================
        async function analyzeImage(imageFile) {
            // دالة لتحليل الصور بالذكاء الاصطناعي
            return new Promise((resolve) => {
                const reader = new FileReader();
                reader.onload = (e) => {
                    // محاكاة تحليل الصورة
                    setTimeout(() => {
                        resolve({
                            objects: ['شخص', 'سيارة', 'منظر طبيعي'],
                            colors: ['أزرق', 'أخضر'],
                            text: 'نص مستخرج من الصورة',
                            recommendations: [
                                'حجم الصورة مناسب',
                                'يمكن تحسين الإضاءة'
                            ]
                        });
                    }, 1500);
                };
                reader.readAsDataURL(imageFile);
            });
        }

        // ==================== AI SEO Optimizer ====================
        function analyzeSEO(content) {
            const seoScore = {
                title: content.includes('<title>') ? 10 : 0,
                description: content.includes('description') ? 10 : 0,
                headings: (content.match(/<h[1-6]/g) || []).length * 5,
                images: (content.match(/<img/g) || []).length * 5,
                links: (content.match(/<a/g) || []).length * 5
            };
            
            const totalScore = Object.values(seoScore).reduce((a, b) => a + b, 0);
            
            return {
                score: totalScore,
                recommendations: [
                    totalScore < 30 ? 'أضف عنواناً للصفحة' : null,
                    totalScore < 40 ? 'أضف وصفاً تعريفياً' : null,
                    (seoScore.images > 0 && seoScore.images < 20) ? 'أضف نص بديل للصور' : null
                ].filter(Boolean)
            };
        }

        // ==================== AI Color Recommender ====================
        function recommendColors(businessType) {
            const recommendations = {
                'متجر': ['#8b5cf6', '#ec4899', '#10b981'],
                'مطعم': ['#f59e0b', '#ef4444', '#8b5cf6'],
                'تقني': ['#3b82f6', '#8b5cf6', '#6366f1'],
                'صحي': ['#10b981', '#3b82f6', '#8b5cf6']
            };
            
            return recommendations[businessType] || recommendations['متجر'];
        }

        // ==================== Initialize ====================
        document.addEventListener('DOMContentLoaded', () => {
            // Load saved chat history
            const saved = localStorage.getItem('aiChatHistory');
            if (saved) {
                chatHistory = JSON.parse(saved);
            }
            
            // Check for API key
            if (AI_CONFIG.apiKey === 'YOUR_API_KEY') {
                console.warn('⚠️ يرجى إضافة مفتاح API للذكاء الاصطناعي');
            }
            
            // Request notification permission
            if (Notification.permission === 'default') {
                setTimeout(() => {
                    Notification.requestPermission();
                }, 5000);
            }
        });

        // Save chat history before unload
        window.addEventListener('beforeunload', () => {
            localStorage.setItem('aiChatHistory', JSON.stringify(chatHistory.slice(-50)));
        });
    </script>
</body>
</html>
