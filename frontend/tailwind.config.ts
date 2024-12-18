import type { Config } from "tailwindcss";

export default {
  content: [
    "./pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        background: "var(--background)",
        foreground: "var(--foreground)",
        brand: "#175cd3",
        titles: "#d5d7da",
        subtitles: "#181d27",
        secondaryButton: "#e6f2ff",
        primaryButton: "##000000",
      },
    },
  },
  plugins: [],
} satisfies Config;
