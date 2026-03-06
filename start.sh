#!/bin/bash
# Start MindfulAI backend
echo "Starting MindfulAI backend..."
cd "$(dirname "$0")"

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
  echo "Creating virtual environment..."
  python -m venv venv
fi

# Activate and install dependencies
source venv/Scripts/activate 2>/dev/null || source venv/bin/activate

pip install -r requirements.txt -q

# Copy .env if it doesn't exist
if [ ! -f ".env" ]; then
  cp .env.example .env
  echo ""
  echo "ACTION REQUIRED: Add your OpenAI API key to backend/.env"
  echo "  OPENAI_API_KEY=your_key_here"
  echo ""
fi

# Start server
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
