@echo off
setlocal enabledelayedexpansion
title MindfulAI Backend
echo.
echo  ============================================
echo   MindfulAI - Mental Health Support Backend
echo  ============================================
echo.

:: Move to the folder containing this .bat file
cd /d "%~dp0"

:: Check Python is available
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python not found. Please install Python 3.10+ from https://python.org
    pause
    exit /b 1
)

:: Create virtual environment if it doesn't exist
if not exist "venv\" (
    echo [INFO] Creating virtual environment...
    python -m venv venv
    if errorlevel 1 (
        echo [ERROR] Failed to create virtual environment.
        pause
        exit /b 1
    )
    echo [OK] Virtual environment created.
)

:: Activate venv
echo [INFO] Activating virtual environment...
call venv\Scripts\activate.bat
if errorlevel 1 (
    echo [ERROR] Failed to activate virtual environment.
    pause
    exit /b 1
)

:: Install / upgrade dependencies
echo [INFO] Installing dependencies...
pip install -r requirements.txt --quiet
if errorlevel 1 (
    echo [ERROR] pip install failed.
    pause
    exit /b 1
)
echo [OK] Dependencies ready.

:: Create .env from example if missing
if not exist ".env" (
    copy ".env.example" ".env" >nul
    echo.
    echo  ============================================================
    echo   ACTION REQUIRED — Fill in your Azure OpenAI credentials:
    echo.
    echo   Open:  backend\.env
    echo.
    echo   Set:   AZURE_OPENAI_API_KEY=your_key_here
    echo          AZURE_OPENAI_ENDPOINT=https://YOUR-RESOURCE.openai.azure.com
    echo          AZURE_OPENAI_DEPLOYMENT=gpt-4o
    echo  ============================================================
    echo.
    pause
)

:: Start the server
echo.
echo [INFO] Starting FastAPI server on http://localhost:8000 ...
echo [INFO] API docs: http://localhost:8000/api/docs
echo [INFO] Press Ctrl+C to stop.
echo.
uvicorn app.main:app --reload --host 127.0.0.1 --port 8000

endlocal
pause
