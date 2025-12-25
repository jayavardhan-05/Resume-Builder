# ✨ ResumeGenius - Professional Resume Builder

Create and download beautiful, ATS-friendly resumes in minutes. ResumeGenius is a powerful and intuitive web application that is completely free to use.

---

### 🚀 **Live Demos**

*   **Landing Page:** [**https://jayavardhan-05.github.io/RESUME-BUILDER/**](https://arifmohammad30.github.io/RESUME-BUILDER/)
*   **Builder Application:** [**https://resumegenious.netlify.app/**](https://resumegenious.netlify.app/)

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Key Features](#-key-features)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Deployment Architecture](#-deployment-architecture)
- [Getting Started](#-getting-started)
- [Available Scripts](#-available-scripts)
- [License](#-license)

## 📖 Overview

ResumeGenius is designed to simplify the resume creation process. It features a decoupled architecture with three main components:

1.  **A Static Landing Page:** A visually appealing, fast-loading page built to showcase the features of the resume builder.
2.  **A Dynamic Builder Application:** A feature-rich Single-Page Application (SPA) where users can input their personal and professional details, select from a variety of templates, and see a live preview.
3.  **A Node.js PDF Generation Service:** A backend server responsible for converting the resume's HTML into a downloadable, high-quality PDF.

This decoupled approach allows each part of the application to be developed and deployed independently.

## 🌟 Key Features

*   **Intuitive Multi-Step Form:** Guides the user through sections for personal info, experience, education, skills, projects, and certifications.
*   **Multiple Professional Templates:** Choose from a selection of 15+ ATS-friendly resume templates.
*   **Live Preview:** See your resume update in real-time as you type.
*   **High-Quality PDF Downloads:** Generates pixel-perfect PDFs using a server-side headless browser, ensuring the downloaded file matches the preview exactly.
*   **Auto-Save Functionality:** Your progress is automatically saved to your browser's `localStorage`, so you can pick up where you left off.
*   **Fully Responsive:** Works seamlessly on both desktop and mobile devices.
*   **No Sign-Up Required:** Completely free to use with no registration needed.

## 🛠️ Tech Stack

The project utilizes a modern and robust stack for a high-quality user experience:

| Category           | Technology                                                                                                                                                                                                                                                                                                                                                     |
| ------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Frontend**       | ![React](https://img.shields.io/badge/react-%2320232a.svg?style=for-the-badge&logo=react&logoColor=%2361DAFB) ![TypeScript](https://img.shields.io/badge/typescript-%23007ACC.svg?style=for-the-badge&logo=typescript&logoColor=white) ![Vite](https://img.shields.io/badge/vite-%23646CFF.svg?style=for-the-badge&logo=vite&logoColor=white)                             |
| **Backend**        | ![NodeJS](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white) ![Express.js](https://img.shields.io/badge/express.js-%23404d59.svg?style=for-the-badge&logo=express&logoColor=%2361DAFB)                                                                                                                                |
| **Styling**        | ![TailwindCSS](https://img.shields.io/badge/tailwindcss-%2338B2AC.svg?style=for-the-badge&logo=tailwind-css&logoColor=white)                                                                                                                                                                                                                                     |
| **UI Components**  | **Shadcn/ui**, **Lucide React** (Icons)                                                                                                                                                                                                                                                                                                                        |
| **Forms**          | ![React Hook Form](https://img.shields.io/badge/React%20Hook%20Form-%23EC5990.svg?style=for-the-badge&logo=reacthookform&logoColor=white) **Zod** (Validation)                                                                                                                                                                                                     |
| **PDF Generation** | **Puppeteer**, **@sparticuz/chromium** (for serverless), **@react-pdf/renderer**                                                                                                                                                                                                                                                                                 |
| **Deployment**     | ![Netlify](https://img.shields.io/badge/netlify-%23000000.svg?style=for-the-badge&logo=netlify&logoColor=#00C7B7) ![Render](https://img.shields.io/badge/Render-%46E3B7.svg?style=for-the-badge&logo=render&logoColor=white) ![GitHub Pages](https://img.shields.io/badge/github%20pages-%23121013.svg?style=for-the-badge&logo=github&logoColor=white) |

## 🏗️ Project Structure

The project uses a monorepo-style structure within a single repository.

```
ResumeGenius/
├── client/                 # Source code for the Builder Application (SPA)
│   ├── src/
│   └── ...
├── landing-page/           # Self-contained project for the Landing Page
│   ├── src/
│   └── ...
├── server.js               # Node.js backend for PDF generation
├── netlify.toml            # Deployment configuration for Netlify
└── package.json            # Root dependencies for the Builder & Server
```

## ☁️ Deployment Architecture

The three applications are deployed independently to leverage the strengths of different hosting platforms.

*   **Landing Page (Static Site)**
    *   **Platform:** **GitHub Pages**
    *   **Workflow:** The `gh-pages` package is used to build the static files and push them to the `gh-pages` branch.
*   **Builder Application (SPA Frontend)**
    *   **Platform:** **Netlify**
    *   **Workflow:** Connected to the `main` branch. Pushing a commit automatically triggers a build on Netlify and deploys the output from the `dist/` directory.
*   **PDF Server (Node.js Backend)**
    *   **Platform:** **Render**
    *   **Workflow:** Connected to the `main` branch. Pushing a commit triggers a new deployment on Render. It installs dependencies from the root `package.json` and runs `server.js`.
    *   **Note:** The server is on a free tier and may "spin down" after inactivity, causing a delay on the first PDF generation request.

The applications are connected via hard-coded URLs and a Netlify environment variable (`VITE_LANDING_URL`).

## 🚀 Getting Started

To run this project locally, you need to run the frontend and backend applications in separate terminals.

### 1. Clone the Repository

```bash
git clone https://github.com/arifmohammad30/RESUME-BUILDER.git
cd RESUME-BUILDER
```

### 2. Install Dependencies

Install dependencies for both the builder app and the server from the root directory.

```bash
npm install
```

### 3. Run the Applications

*   **Terminal 1: Run the Builder Application (Frontend)**

    ```bash
    # Run the Vite development server
    npm run dev
    ```

    The frontend will be available at `http://localhost:5173`.

*   **Terminal 2: Run the PDF Server (Backend)**

    ```bash
    # Run the Node.js server
    npm run server
    ```

    The server will be running on `http://localhost:3001`. The frontend is configured to send requests to this address in development.

### 4. Run the Landing Page (Optional)

The landing page is a separate project in its own directory.

```bash
# Navigate to the landing-page directory
cd landing-page

# Install its dependencies
npm install

# Run the development server
npm run dev
```

The landing page will be available at a different port (e.g., `http://localhost:3000`).

## 📜 Available Scripts

### Root (Builder App & Server)

*   `npm run dev`: Starts the frontend development server.
*   `npm run server`: Starts the backend PDF generation server.
*   `npm run build`: Builds the frontend application for production.
*   `npm run type-check`: Runs the TypeScript compiler to check for errors.

### Landing Page

*   `npm run dev`: Starts the landing page development server.
*   `npm run build`: Builds the landing page for production.
*   `npm run deploy`: Deploys the landing page to GitHub Pages.

## 📄 License

This project is licensed under the MIT License. See the `LICENSE` file for more details.

---


