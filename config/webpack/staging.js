process.env.NODE_ENV = process.env.NODE_ENV || 'staging'

const environment = require('./environment')

module.exports = environment.toWebpackConfig()
