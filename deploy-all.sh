#!/bin/bash

# ResumeGenius Complete Deployment Script
echo "🚀 ResumeGenius Complete Deployment"
echo "==================================="

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    print_error "package.json not found. Please run this script from the project root."
    exit 1
fi

echo ""
print_info "This script will help you deploy both applications:"
echo "1. Builder Application → Netlify"
echo "2. Landing Page → GitHub Pages"
echo ""

read -p "Do you want to proceed? (y/n): " proceed

if [ "$proceed" != "y" ] && [ "$proceed" != "Y" ]; then
    print_status "Deployment cancelled"
    exit 0
fi

echo ""
print_info "Step 1: Deploying Builder Application to Netlify"
echo "====================================================="

# Build the main application
print_status "Building builder application..."
npm install
npm run build

if [ $? -eq 0 ]; then
    print_status "Builder application built successfully!"
    
    echo ""
    echo "Netlify Deployment Options:"
    echo "1) Deploy via Netlify CLI"
    echo "2) Deploy via Netlify Dashboard (drag & drop)"
    echo "3) Skip Netlify deployment"
    
    read -p "Choose option (1-3): " netlify_choice
    
    case $netlify_choice in
        1)
            print_status "Deploying to Netlify via CLI..."
            if command -v netlify &> /dev/null; then
                netlify deploy --prod --dir=dist
            else
                print_warning "Netlify CLI not found. Installing..."
                npm install -g netlify-cli
                netlify deploy --prod --dir=dist
            fi
            ;;
        2)
            print_info "Please manually deploy:"
            print_info "1. Go to https://netlify.com"
            print_info "2. Drag the 'dist' folder to the deploy area"
            print_info "3. Note your Netlify URL for the next step"
            ;;
        3)
            print_status "Skipping Netlify deployment"
            ;;
        *)
            print_error "Invalid choice"
            ;;
    esac
else
    print_error "Builder application build failed!"
    exit 1
fi

echo ""
print_info "Step 2: Deploying Landing Page to GitHub Pages"
echo "==================================================="

# Check if landing page exists
if [ ! -d "landing-page" ]; then
    print_error "Landing page directory not found!"
    exit 1
fi

cd landing-page

# Install dependencies
print_status "Installing landing page dependencies..."
npm install

# Build landing page
print_status "Building landing page..."
npm run build

if [ $? -eq 0 ]; then
    print_status "Landing page built successfully!"
    
    echo ""
    echo "GitHub Pages Deployment Options:"
    echo "1) Deploy via GitHub Actions (recommended)"
    echo "2) Deploy via gh-pages package"
    echo "3) Skip GitHub Pages deployment"
    
    read -p "Choose option (1-3): " github_choice
    
    case $github_choice in
        1)
            print_info "GitHub Actions Deployment:"
            print_info "1. Create a new GitHub repository"
            print_info "2. Push this landing-page directory to GitHub"
            print_info "3. The .github/workflows/deploy.yml will auto-deploy"
            print_info "4. Enable GitHub Pages in repository settings"
            print_info "5. Set VITE_BUILDER_URL secret with your Netlify URL"
            ;;
        2)
            print_status "Deploying via gh-pages..."
            npm run deploy
            ;;
        3)
            print_status "Skipping GitHub Pages deployment"
            ;;
        *)
            print_error "Invalid choice"
            ;;
    esac
else
    print_error "Landing page build failed!"
    exit 1
fi

cd ..

echo ""
print_info "Step 3: Connecting the Applications"
echo "========================================"

print_info "To connect your applications:"
echo ""
print_info "1. Get your Netlify URL (e.g., https://your-site.netlify.app)"
print_info "2. Get your GitHub Pages URL (e.g., https://username.github.io/repo-name)"
echo ""
print_info "3. Update environment variables:"
print_info "   - In Netlify: Add VITE_LANDING_URL with your GitHub Pages URL"
print_info "   - In GitHub: Add VITE_BUILDER_URL secret with your Netlify URL"
echo ""
print_info "4. Test the connection:"
print_info "   - Visit landing page → Click 'Get Started' → Should go to builder app"
print_info "   - Visit builder app → Click 'Home' → Should go to landing page"

echo ""
print_status "Deployment setup completed! 🎉"
print_info "Check DEPLOYMENT-GUIDE.md for detailed instructions." 