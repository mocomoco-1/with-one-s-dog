// Import all the channels to be used by Action Cable
import "./consumer"
const channels = require.context('.', true, /_channel\.js$/)
channels.keys().forEach(channels)
