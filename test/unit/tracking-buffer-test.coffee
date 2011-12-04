require('buffertools')
TrackingBuffer = require('../../lib/tracking-buffer')

exports.create = (test) ->
  buffer = new TrackingBuffer()
  
  test.ok(buffer)
  test.strictEqual(0, buffer.data.length)

  test.done()

exports.writeUnsignedInt = (test) ->
  buffer = new TrackingBuffer(2)

  buffer.writeUInt8(1)
  buffer.writeUInt16LE(2)
  buffer.writeUInt16BE(3)
  buffer.writeUInt32LE(4)
  buffer.writeUInt32BE(5)

  assertBuffer(test, buffer, [
    0x01
    0x02, 0x00
    0x00, 0x03
    0x04, 0x00, 0x00, 0x00
    0x00, 0x00, 0x00, 0x05
  ])

  test.done()

exports.writeSignedInt = (test) ->
  buffer = new TrackingBuffer(2)

  buffer.writeInt8(-1)
  buffer.writeInt16LE(-2)
  buffer.writeInt16BE(-3)
  buffer.writeInt32LE(-4)
  buffer.writeInt32BE(-5)

  assertBuffer(test, buffer, [
    0xFF
    0xFE, 0xFF
    0xFF, 0xFD
    0xFC, 0xFF, 0xFF, 0xFF
    0xFF, 0xFF, 0xFF, 0xFB
  ])

  test.done()


exports.writeString = (test) ->
  buffer = new TrackingBuffer(2)

  buffer.writeString('abc')

  assertBuffer(test, buffer, [0x61, 0x00, 0x62, 0x00, 0x63, 0x00])

  test.done()

assertBuffer = (test, actual, expected) ->
  actual = actual.data
  expected = new Buffer(expected)

  comparisonResult = actual.compare(expected)
  if (comparisonResult != 0)
    console.log('actual  ', actual)
    console.log('expected', expected)
  
  test.strictEqual(comparisonResult, 0)