# OpenWebUI - Local AI Chat

**URL:** http://localhost:3000  
**Tailscale:** http://TAILSCALE_IP:3000  
**Time:** 20 minutes

## What is OpenWebUI?

ChatGPT-style interface running completely on your M4 Mac. No subscriptions, no data sent to external servers.

## Prerequisites

- [ ] Ollama is running (check in Portainer)

## Configuration Steps

### Step 1: Create Account
- [ ] Open http://localhost:3000
- [ ] Click "Sign Up"
- [ ] Enter email (can be fake - it's local only)
- [ ] Set username
- [ ] Set password (save to 1Password)
- [ ] Click "Create Account"

### Step 2: Download Your First Model

Models are like different AI personalities. Start with these:

**Llama 3.2 (Fast, good for chat):**
- [ ] Click settings (gear icon)
- [ ] Go to "Models"
- [ ] In "Pull a model from Ollama.com", type: `llama3.2`
- [ ] Click download icon
- [ ] Wait 2-5 minutes (1.3GB download)

**Mistral (Smarter, better for complex tasks):**
- [ ] Pull model: `mistral`
- [ ] Wait 5-10 minutes (4.1GB download)

**CodeLlama (Best for programming):**
- [ ] Pull model: `codellama`
- [ ] Wait 5-10 minutes (3.8GB)

**DeepSeek Coder (Alternative for coding):**
- [ ] Pull model: `deepseek-coder`
- [ ] Great for programming questions

### Step 3: Test Your First Chat
- [ ] Click "New Chat"
- [ ] Select model (llama3.2 for speed)
- [ ] Type: "Tell me a joke about homelabs"
- [ ] Watch response stream in real-time
- [ ] Response should be coherent and relevant

### Step 4: Try Different Models
- [ ] Start new chat
- [ ] Switch to Mistral
- [ ] Ask same question
- [ ] Compare responses
- [ ] Notice Mistral is smarter but slower

### Step 5: Test Code Generation
- [ ] Start new chat
- [ ] Select CodeLlama
- [ ] Ask: "Write a Python script to organize files by extension"
- [ ] Model should provide working code with explanations

### Step 6: Upload Documents (RAG)

OpenWebUI can read documents and answer questions about them!

- [ ] Click paperclip icon in chat
- [ ] Upload a PDF or text file
- [ ] Ask: "Summarize this document"
- [ ] Ask: "What are the key points?"
- [ ] Model uses document content to answer

### Step 7: Customize Settings

**Model Settings:**
- [ ] Click settings → Models
- [ ] Adjust temperature (0.7 = balanced, 0.3 = focused, 0.9 = creative)
- [ ] Adjust max tokens (response length)

**Interface Settings:**
- [ ] Settings → Interface
- [ ] Choose dark/light theme
- [ ] Adjust font size
- [ ] Enable/disable features

**System Prompts:**
- [ ] Settings → Prompts
- [ ] Create custom system prompts
- [ ] Example: "You are a helpful homelab assistant who knows Docker"
- [ ] Use per chat or globally

### Step 8: Create Custom Prompts

**Example: Homelab Helper**
- [ ] Settings → Prompts
- [ ] Create new prompt
- [ ] Name: "HomeLab Assistant"
- [ ] Content:
```
You are an expert in homelabs, Docker, Linux, and home automation.
You help configure services, troubleshoot issues, and suggest improvements.
Always provide practical, tested solutions.
```
- [ ] Save
- [ ] Use in new chats by selecting it

**Example: Code Reviewer**
```
You are a senior software engineer doing code review.
Identify bugs, suggest improvements, and explain best practices.
Be constructive and educational.
```

### Step 9: Organize Chats

**Folders:**
- [ ] Right-click on chat
- [ ] "Move to folder"
- [ ] Create folders: Code, HomeLab, Writing, etc.
- [ ] Organize chats by topic

**Tags:**
- [ ] Tag chats for easy searching
- [ ] #docker, #python, #homelab, etc.

**Archive Old Chats:**
- [ ] Right-click → Archive
- [ ] Keeps chat history clean

## Recommended Models by Use Case

**General Chat & Questions:**
- `llama3.2` (fast)
- `mistral` (smarter)

**Programming & Code:**
- `codellama`
- `deepseek-coder`
- `phind-codellama`

**Creative Writing:**
- `mistral`
- `llama3.2`

**Technical Documentation:**
- `deepseek-coder`
- `codellama`

**Small & Fast (for testing):**
- `tinyllama` (650MB)

**Vision (Image Understanding):**
- `llava` (can describe images)

## Example Prompts to Try

**HomeLab:**
- "How do I configure Plex to transcode 4K to 1080p?"
- "Write a Docker compose file for a new service"
- "Explain how Prometheus scraping works"

**Coding:**
- "Review this Python code: [paste code]"
- "Convert this bash script to Python"
- "Explain this error: [paste error]"

**Writing:**
- "Write a professional email requesting time off"
- "Summarize this article in 3 bullet points"
- "Rewrite this paragraph to be more concise"

**Learning:**
- "Explain Docker networking like I'm 5"
- "What's the difference between MQTT and HTTP?"
- "Teach me Python decorators with examples"

## Advanced Features

**Chat Import/Export:**
- Export chats as JSON
- Share conversations
- Backup important chats

**API Access:**
- OpenWebUI has an API
- Integrate with other apps
- Automate conversations

**Multi-User:**
- Create accounts for family
- Each user gets their own chat history
- Admin controls in settings

**Model Management:**
- Delete unused models to free space
- Each model is several GB
- Keep 3-4 models you actually use

## Performance Tips

**M4 Mac Optimization:**
- Models run on CPU (no GPU needed)
- M4 handles 7B-13B models well
- Larger models (70B+) will be slow

**Speed vs Quality:**
- llama3.2: Fastest, good enough
- mistral: Slower, smarter
- Pick based on task importance

**Memory Usage:**
- Models use RAM when loaded
- Unload unused models
- Check RAM in Portainer

## Privacy & Security

**Completely Private:**
- No data sent to external servers
- No internet required (after model download)
- Chat history stored locally

**Safe for Sensitive Data:**
- Can paste confidential code
- Can discuss private matters
- Perfect for work-related questions

## Troubleshooting

**Model won't download:**
- Check internet connection
- Check disk space (models are large)
- Try `docker logs ollama` in Portainer

**Slow responses:**
- M4 Mac should be fast
- Check CPU usage in Portainer
- Try smaller model (llama3.2 vs mistral)

**Model gives nonsense:**
- Lower temperature
- Try different model
- Rephrase question more specifically

**Can't access OpenWebUI:**
- Check if running in Portainer
- Try `docker restart openwebui`
- Check logs: `docker logs openwebui`

## ✅ Verification

- [ ] Can log in to OpenWebUI
- [ ] Downloaded at least 2 models
- [ ] Had successful conversation
- [ ] Tested code generation
- [ ] Uploaded and queried a document
- [ ] Created custom prompt
- [ ] Organized chats into folders

## Next Steps

→ Download more models as needed  
→ Create custom prompts for your workflow  
→ Integrate into your daily work

**This replaces ChatGPT subscriptions - use it daily!**

