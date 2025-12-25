import express from 'express';
import puppeteer from 'puppeteer-core';
import chromium from '@sparticuz/chromium';
import cors from 'cors';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const PORT = 3001;

app.use(cors());
app.use(express.json({ limit: '50mb' }));

// PDF generation endpoint
app.post('/api/generate-pdf', async (req, res) => {
  console.log('Received PDF generation request');
  console.log('Request body keys:', Object.keys(req.body));
  console.log('HTML length:', req.body.html ? req.body.html.length : 'No HTML');
  
  let browser = null;
  
  try {
    const { html, filename = 'resume.pdf' } = req.body;
    
    if (!html) {
      console.log('No HTML provided');
      return res.status(400).json({ error: 'HTML content is required' });
    }

    console.log('Launching browser...');

    // Launch browser with serverless-optimized settings
    browser = await puppeteer.launch({
      args: chromium.args,
      defaultViewport: chromium.defaultViewport,
      executablePath: await chromium.executablePath(),
      headless: chromium.headless,
      ignoreHTTPSErrors: true,
    });

    console.log('Creating new page...');
    const page = await browser.newPage();
    
    // Set viewport for consistent rendering
    await page.setViewport({ width: 1200, height: 1600 });
    
    console.log('Setting HTML content...');
    // Set content and wait for fonts to load
    await page.setContent(html, { 
      waitUntil: ['networkidle0', 'domcontentloaded'],
      timeout: 30000
    });
    
    // Wait for fonts and any dynamic content
    console.log('Waiting for content to load...');
    await new Promise(res => setTimeout(res, 2000));

    // Check if content loaded properly
    const contentCheck = await page.evaluate(() => {
      const preview = document.querySelector('[data-resume-preview]');
      return {
        hasPreview: !!preview,
        previewText: preview ? preview.textContent.substring(0, 100) : 'No preview found'
      };
    });
    
    console.log('Content check:', contentCheck);

    console.log('Generating PDF...');
    // Generate PDF with proper settings
    const pdfBuffer = await page.pdf({
      format: 'A4',
      printBackground: true,
      preferCSSPageSize: true,
      displayHeaderFooter: false
    });

    console.log('PDF generated successfully, size:', pdfBuffer.length, 'bytes');

    // Set headers for PDF download
    res.setHeader('Content-Type', 'application/pdf');
    res.setHeader('Content-Disposition', `attachment; filename="${filename}"`);
    res.setHeader('Content-Length', pdfBuffer.length);
    
    res.send(pdfBuffer);

  } catch (error) {
    console.error('PDF generation error:', error);
    console.error('Error stack:', error.stack);
    
    // Send detailed error response
    res.status(500).json({ 
      error: 'Failed to generate PDF', 
      details: error.message,
      stack: process.env.NODE_ENV === 'development' ? error.stack : undefined
    });
  } finally {
    // Always close browser
    if (browser) {
      try {
        await browser.close();
        console.log('Browser closed successfully');
      } catch (closeError) {
        console.error('Error closing browser:', closeError);
      }
    }
  }
});

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.json({ status: 'OK', message: 'PDF server is running' });
});

app.listen(PORT, () => {
  console.log(`PDF server running on port ${PORT}`);
  console.log(`Health check: http://localhost:${PORT}/api/health`);
}); 