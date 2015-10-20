console.log "loading spec"

Enumeration=require('../src/Enumeration.coffee')
describe 'Enumeration', () ->
  calc = {}
  beforeEach ->
    calc = new Enumeration()

  it 'should be able to add two numbers', () ->
    expect(calc.add 3,4 ).toBe 7


