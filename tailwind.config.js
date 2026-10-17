/** @type {import('tailwindcss').Config} */
// Berries palette: cream page, deep-brown ink, caramel accent. Token names are kept so every screen restyles together.
export default {
  content: ['./index.html', './src/**/*.{js,jsx}'],
  theme: {
    extend: {
      colors: {
        steel: { DEFAULT: '#F6EFE2', 100: '#FBF7F0', 200: '#EADFCB', 300: '#DCCBB0', 500: '#8E7A63' },
        ink: { DEFAULT: '#4F2F1E', soft: '#77634E', 900: '#24160E', 800: '#33211A', 700: '#4A3326' },
        cardamom: { DEFAULT: '#AA5F29', dark: '#8C4C1F', light: '#F3E3D3' },
        veg: '#2F7D32',
        espresso: { DEFAULT: '#1E1B18', soft: '#3A332D' },
        haldi: { DEFAULT: '#F2B705', light: '#FDF3CF', dark: '#8A6A00' },
        chilli: { DEFAULT: '#C2412D', light: '#F8E3DF' },
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
        serif: ['Fraunces', 'Georgia', 'serif'],
        script: ['"Great Vibes"', 'cursive'],
      },
    },
  },
  plugins: [],
};
