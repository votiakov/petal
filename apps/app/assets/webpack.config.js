const path = require("path");
const glob = require("glob");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const TerserPlugin = require("terser-webpack-plugin");
const CssMinimizerPlugin = require("css-minimizer-webpack-plugin");
const CopyWebpackPlugin = require("copy-webpack-plugin");

const nodeModulesPath = path.resolve(__dirname, "node_modules");

module.exports = (env, options) => {
  const devMode = options.mode !== "production";

  return {
    optimization: {
      minimizer: [
        new TerserPlugin({ parallel: true }),
        new CssMinimizerPlugin(),
      ],
    },
    mode: options.mode,
    devtool: devMode ? "source-map" : undefined,
    entry: {
      app: glob.sync("./vendor/**/*.js").concat(["./js/app.js"]),
      "content-editor": ["./js/content-editor.js"],
    },
    output: {
      filename: "js/[name].js",
      path: path.resolve(__dirname, "../priv/static/"),
    },
    module: {
      rules: [
        // For images and fonts found in our scss files
        {
          test: /\.(jpg|jpeg|gif|png)$/,
          use: [
            "file-loader",
            {
              loader: "image-webpack-loader",
              options: {
                disable: devMode,
              },
            },
          ],
        },
        {
          test: /\.(woff2?|ttf|eot|svg)(\?[a-z0-9\=\.]+)?$/,
          loader: "file-loader",
          options: {
            publicPath: "/fonts",
            outputPath: (url, resourcePath, context) => {
              return `/fonts/${url}`;
            },
          },
        },
        {
          test: /\.js$/,
          exclude: /node_modules/,
          use: {
            loader: "babel-loader",
          },
        },
        {
          test: /\.css$/,
          use: [
            { loader: MiniCssExtractPlugin.loader },
            { loader: "css-loader", options: { sourceMap: true } },
            { loader: "postcss-loader", options: { sourceMap: true } },
          ],
        },
      ],
    },
    plugins: [
      new MiniCssExtractPlugin({
        filename: "css/[name].css",
        chunkFilename: "[id].css",
      }),
      new CopyWebpackPlugin({
        patterns: [
          {
            from: path.resolve(__dirname, "static"),
            to: path.resolve(__dirname, "../priv/static"),
          },
        ],
      }),
    ],
    resolve: {
      alias: {
        "../webfonts/fa-brands-400.eot": path.resolve(
          __dirname,
          "node_modules/@fortawesome/fontawesome-free/webfonts/fa-brands-400.eot"
        ),
        "../webfonts/fa-brands-400.woff2": path.resolve(
          __dirname,
          "node_modules/@fortawesome/fontawesome-free/webfonts/fa-brands-400.woff2"
        ),
        "../webfonts/fa-brands-400.woff": path.resolve(
          __dirname,
          "node_modules/@fortawesome/fontawesome-free/webfonts/fa-brands-400.woff"
        ),
        "../webfonts/fa-brands-400.ttf": path.resolve(
          __dirname,
          "node_modules/@fortawesome/fontawesome-free/webfonts/fa-brands-400.ttf"
        ),
        "../webfonts/fa-brands-400.svg": path.resolve(
          __dirname,
          "node_modules/@fortawesome/fontawesome-free/webfonts/fa-brands-400.svg"
        ),
        "../webfonts/fa-regular-400.eot": path.resolve(
          __dirname,
          "node_modules/@fortawesome/fontawesome-free/webfonts/fa-regular-400.eot"
        ),
        "../webfonts/fa-regular-400.woff2": path.resolve(
          __dirname,
          "node_modules/@fortawesome/fontawesome-free/webfonts/fa-regular-400.woff2"
        ),
        "../webfonts/fa-regular-400.woff": path.resolve(
          __dirname,
          "node_modules/@fortawesome/fontawesome-free/webfonts/fa-regular-400.woff"
        ),
        "../webfonts/fa-regular-400.ttf": path.resolve(
          __dirname,
          "node_modules/@fortawesome/fontawesome-free/webfonts/fa-regular-400.ttf"
        ),
        "../webfonts/fa-regular-400.svg": path.resolve(
          __dirname,
          "node_modules/@fortawesome/fontawesome-free/webfonts/fa-regular-400.svg"
        ),
        "../webfonts/fa-solid-900.eot": path.resolve(
          __dirname,
          "node_modules/@fortawesome/fontawesome-free/webfonts/fa-solid-900.eot"
        ),
        "../webfonts/fa-solid-900.woff2": path.resolve(
          __dirname,
          "node_modules/@fortawesome/fontawesome-free/webfonts/fa-solid-900.woff2"
        ),
        "../webfonts/fa-solid-900.woff": path.resolve(
          __dirname,
          "node_modules/@fortawesome/fontawesome-free/webfonts/fa-solid-900.woff"
        ),
        "../webfonts/fa-solid-900.ttf": path.resolve(
          __dirname,
          "node_modules/@fortawesome/fontawesome-free/webfonts/fa-solid-900.ttf"
        ),
        "../webfonts/fa-solid-900.svg": path.resolve(
          __dirname,
          "node_modules/@fortawesome/fontawesome-free/webfonts/fa-solid-900.svg"
        ),
      },
    },
  };
};
