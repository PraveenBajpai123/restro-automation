/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,jsx}'],
  theme: {
    extend: {
      colors: {
        steel: { DEFAULT: '#EEF1F2', 100: '#F6F8F8', 200: '#E2E7E9', 300: '#CBD3D6', 500: '#7D8B91' },
        ink: { DEFAULT: '#1F2A30', soft: '#46555C', 900: '#162026', 800: '#25333A', 700: '#31424A' },
        cardamom: { DEFAULT: '#2F6B4F', dark: '#24553F', light: '#E3EEE8' },
        haldi: { DEFAULT: '#F2B705', light: '#FDF3CF', dark: '#8A6A00' },
        chilli: { DEFAULT: '#C2412D', light: '#F8E3DF' },
      },
      fontFamily: {
        sans: ['"Bricolage Grotesque"', 'system-ui', 'sans-serif'],
      },
    },
  },
  plugins: [],
};
