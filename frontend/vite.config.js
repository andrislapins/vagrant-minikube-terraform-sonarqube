
import { defineConfig } from "vite";
import react from '@vitejs/plugin-react';
import { visualizer } from "rollup-plugin-visualizer";

export default defineConfig({
  headers: {
    "Content-Security-Policy": "frame-ancestors 'self' https://www.youtube.com;"
  },
  plugins: [
    react(),
    visualizer({ open: true })
  ],
  build: {
    rollupOptions: {
      output: {
        manualChunks: (id) => {
          if (id.includes('node_modules')) {
            return 'vendor';
          }
        },
      },
    },
  },
});