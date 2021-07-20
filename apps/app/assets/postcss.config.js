module.exports = {
  plugins: [
    require("postcss-import")({
      plugins: [require("stylelint")()],
    }),
    require("tailwindcss"),
    require("autoprefixer"),
    require("csswring")(),
    require("postcss-color-function")(),
  ],
};
