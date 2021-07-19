const yargsParser = require('yargs-parser');
const cliArgs = yargsParser(process.argv);

const mode = process.env.NODE_ENV || cliArgs.mode || 'development';

module.exports = {
  future: {
    removeDeprecatedGapUtilities: true,
    purgeLayersByDefault: true,
  },
  purge: {
    enabled: mode == 'production',
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
