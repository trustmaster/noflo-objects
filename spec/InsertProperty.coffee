noflo = require 'noflo'

unless noflo.isBrowser()
  chai = require 'chai'
  path = require 'path'
  baseDir = path.resolve __dirname, '../'
else
  baseDir = 'noflo-objects'

expect = chai.expect unless expect

describe 'InsertProperty', ->
  c = null
  loader = null

  before (done) ->
    loader = new noflo.ComponentLoader baseDir
    loader.load 'objects/InsertProperty', (err, instance) ->
      return done err if err
      c = instance
      done()

  describe 'inPorts', ->
    it 'should include "in"', (done) ->
      expect(c.inPorts.in).to.be.an 'object'
      done()
    it 'should include "property"', (done) ->
      expect(c.inPorts.property).to.be.an 'object'
      done()

  describe 'outPorts', ->
    it 'should include "out"', (done) ->
      expect(c.outPorts.out).to.be.an 'object'
      done()

  describe 'data flow', ->
    inIn = null
    propertyIn = null
    outOut = null

    beforeEach (done) ->
      inIn = noflo.internalSocket.createSocket()
      propertyIn = noflo.internalSocket.createSocket()
      outOut = noflo.internalSocket.createSocket()

      c.inPorts.in.attach inIn
      c.inPorts.property.attach propertyIn
      c.outPorts.out.attach outOut
      done()

    describe 'with input on all ports', ->
      it 'should insert the property', (done) ->
        outOut.on 'data', (data) ->
          expect(data).to.deep.equal
            test: true
            key: 'value'
          done()

        inIn.post new noflo.IP 'data', {test: true}

        propertyIn.post new noflo.IP 'openBracket', 'key'
        propertyIn.post new noflo.IP 'data', 'value'
        propertyIn.post new noflo.IP 'closeBracket', 'key'
