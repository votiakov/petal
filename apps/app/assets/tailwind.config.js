module.exports = {
  future: {
    removeDeprecatedGapUtilities: true,
    purgeLayersByDefault: true,
  },
  purge: {
    enabled: true,
    layers: ['base', 'components', 'utilities'],
    content: [
      '../../../**/views/*.ex',
      '../../../**/*.html.eex',
      '../../../**/*.html.leex',
      '../../../**/*.html.heex',
      './js/**/*.js'
    ]
  },
  theme: {
    extend: {},
  },
  variants: {
    backgroundColor: ['responsive', 'hover', 'focus', 'checked'],
  },
  plugins: [],
}
