const { webpackConfig, merge } = require('shakapacker')
const { VueLoaderPlugin } = require('vue-loader')

const configs = merge({
  resolve: {
    extensions: ['.vue', '.css', '.scss']
  },
  module: {
    rules: [
      {
        test: /\.vue$/,
        use: [
          {
            loader: 'vue-loader'
          }
        ]
      },
      {
        test: /\.css$/,
        use: [
          'css-loader',
          'postcss-loader',
          'sass-loader'
        ]
      },
      {
        test: /\.scss$/,
        use: [
          'postcss-loader',
          'sass-loader'
        ]
      }
    ]
  },
  plugins: [
    new VueLoaderPlugin()
  ]
}, webpackConfig)

configs.optimization.runtimeChunk = false
configs.optimization.splitChunks = false

module.exports = configs
