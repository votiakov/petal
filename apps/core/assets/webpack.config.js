const path = require('path');
const glob = require('glob');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const TerserPlugin = require('terser-webpack-plugin');
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');

const nodeModulesPath = path.resolve(__dirname, 'node_modules')

module.exports = (env, options) => {
  const devMode = options.mode !== 'production';

  return {
    optimization: {
      minimizer: [
        new TerserPlugin({ cache: true, parallel: true, sourceMap: devMode }),
        new OptimizeCSSAssetsPlugin({})
      ]
    },
    mode: options.mode,
    devtool: devMode ? 'source-map' : undefined,
    entry: {
      'app': glob.sync('./vendor/**/*.js').concat(['./js/app.js']),
      'content-editor': ['./js/content-editor.js'],
    },
    output: {
      filename: 'js/[name].js',
      path: path.resolve(__dirname, '../priv/static/')
    },
    module: {
      rules: [
        // For images and fonts found in our scss files
        {
          test: /\.(jpg|jpeg|gif|png)$/,
          use: [
            'file-loader',
            {
              loader: 'image-webpack-loader',
              options: {
                disable: devMode,
              },
            },
          ],
        },
        {
          test: /\.(woff2?|ttf|eot|svg)(\?[a-z0-9\=\.]+)?$/,
          exclude: [nodeModulesPath],
          loader: 'file-loader',
        },
        {
          test: /\.js$/,
          exclude: /node_modules/,
          use: {
            loader: 'babel-loader'
          }
        },
        {
          test: /\.css$/,
          use: [
            {loader: MiniCssExtractPlugin.loader, options: {sourceMap: true}},
            {loader: 'css-loader', options: {sourceMap: true}},
            {loader: 'postcss-loader', options: {sourceMap: true}},
          ],
        },
      ]
    },
    plugins: [
      new MiniCssExtractPlugin({
        filename: 'css/[name].css',
        chunkFilename: '[id].css',
      }),
      new CopyWebpackPlugin([
        {
          from: path.resolve(__dirname, 'static'),
          to: path.resolve(__dirname, '../priv/static'),
        },
      ]),
    ],
  }
};
