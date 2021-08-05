module.exports = {
  plugins: [
    require("postcss-import")({
      plugins: [require("stylelint")()],
    }),
    require("tailwindcss"),
    require("autoprefixer"),
    require("postcss-clean")(),
    require("postcss-color-function")(),
  ],
};
