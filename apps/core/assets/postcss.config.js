module.exports = {
  plugins: [
    require('postcss-import')(),
    require('stylelint')(),
    require('tailwindcss'),
    require('autoprefixer'),
    require('csswring')(),
    require('postcss-color-function')()
  ],
}
