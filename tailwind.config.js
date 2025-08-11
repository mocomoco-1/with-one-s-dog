/** @type {import("tailwindcss").Config} */
module.exports = {
  content: [
    "./app/views/**/*.html.erb",
    "./app/helpers/**/*.rb", 
    "./app/assets/stylesheets/**/*.css",
    "./app/javascript/**/*.js"
  ],
  theme: {
    extend: {},
  },
  plugins: [
    require("daisyui")
  ],
  daisyui: {
    themes: [
      {
        cupcake: {
          "primary": "#F6F8F7",
          "primary-content": "oklch(74% 0.16 232.661)",
          "secondary": "#8CC9E2",
          "secondary-content": "oklch(98% 0.003 247.858)",
          "accent": "#F7F6E4",
          "accent-content": "#6E5448",
          "neutral": "oklch(90% 0.058 230.902)",
          "neutral-content": "#6E5448",
          "base-100": "oklch(98% 0 0)",
          "base-200": "oklch(96% 0.001 286.375)",
          "base-300": "oklch(92% 0.004 286.32)",
          "base-content": "#6E5448",
          "info": "oklch(82% 0.119 306.383)",
          "info-content": "#6E5448",
          "success": "oklch(95% 0.052 163.051)",
          "success-content": "oklch(38% 0.063 188.416)",
          "warning": "oklch(94% 0.129 101.54)",
          "warning-content": "oklch(28% 0.066 53.813)",
          "error": "oklch(89% 0.058 10.001)",
          "error-content": "#B74242",
          "--radius-selector": "1rem",
          "--radius-field": "0.5rem",
          "--radius-box": "1rem",
          "--size-selector": "0.25rem",
          "--size-field": "0.25rem",
          "--border": "1px",
          "--depth": "0",
          "--noise": "1",
        }
      }
    ]
  }
}
