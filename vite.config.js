import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react-swc'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  server: {
    host: true, // This allows Vite to listen on all network interfaces
    hmr: {
      protocol: 'ws',
      host: 'localhost',
    },
  },
})
