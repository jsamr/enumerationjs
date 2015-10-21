console.log "loading spec"

Enumeration=require('../src/Enumeration.coffee')
describe 'Enumeration values when descriptors are raw types :',  ->
  closeEventCodes=null
  descriptors=null
  enumType=null
  prototype=null
  counter=0
  beforeEach ->
    counter++
    enumType="closeEventCodesRaw#{counter}"
    prototype=someStupidFun:-> "Hi I'm dumb!"
    descriptors=
      CLOSE_NORMAL:1000
      CLOSE_GOING_AWAY:1001
      CLOSE_PROTOCOL_ERROR:1002
      CLOSE_UNSUPPORTED:1003
      CLOSE_NO_STATUS:1005
      CLOSE_ABNORMAL:1006
      CLOSE_TOO_LARGE:1009
    closeEventCodes=new Enumeration(enumType, descriptors, prototype)

  it 'should have their descriptor\'s id matching the result of id() ', ->
    expect(id).toEqual(closeEventCodes[key].id()) for key,id of descriptors
  it 'should have their descriptor\'s key matching the result of key() ', ->
    expect(key).toEqual(closeEventCodes[key].key()) for key of descriptors
  it 'should have the result of type() matching the type given at instanciation time', ->
    expect(enumType).toEqual(closeEventCodes[key].type()) for key of descriptors
  it 'should share prototype\'s properties', ->
    expect(prototype.someStupidFun).toEqual(closeEventCodes[key].someStupidFun) for key of descriptors

describe 'Enumeration values when descriptors are structured objects :',  ->
  closeEventCodes=null
  descriptors=null
  enumType=null
  prototype=null
  counter=0
  beforeEach ->
    counter++
    enumType="closeEventCodesStructured#{counter}"
    prototype=someStupidFun:-> "Hi I'm dumb!"
    descriptors=
      CLOSE_NORMAL:        {_id:1000,info:"Connection closed normally"}
      CLOSE_GOING_AWAY:    {_id:1001,info:"Connection closed going away"}
      CLOSE_PROTOCOL_ERROR:{_id:1002,info:"Connection closed due to protocol error"}
      CLOSE_UNSUPPORTED:   {_id:1003,info:"Connection closed due to unsupported operation"}
      CLOSE_NO_STATUS:     {_id:1005,info:"Connection closed with no status"}
      CLOSE_ABNORMAL:      {_id:1006,info:"Connection closed abnormally"}
      CLOSE_TOO_LARGE:     {_id:1009,info:"Connection closed due to too large packet"}
    closeEventCodes=new Enumeration(enumType, descriptors, prototype)

  it 'should have their descriptor\'s id matching the result of id() ', ->
    expect(descr._id).toEqual(closeEventCodes[key].id()) for key,descr of descriptors
  it 'should have their descriptor\'s key matching the result of key() ', ->
    expect(key).toEqual(closeEventCodes[key].key()) for key of descriptors
  it 'should have an info field matching descriptor\'s info field ', ->
    expect(descr.info).toEqual(closeEventCodes[key].info) for key,descr of descriptors
  it 'should have the result of type() matching the type given at instanciation time', ->
    expect(enumType).toEqual(closeEventCodes[key].type()) for key of descriptors
  it 'should share prototype\'s properties', ->
    expect(prototype.someStupidFun).toEqual(closeEventCodes[key].someStupidFun) for key of descriptors

describe 'Enumeration instanciation with raw descriptor', () ->
  
  it 'should throw an error when id method is used as prototype\'s field', ->
    expect(new Enumeration("SomeRawDescribedEnumeration",{FIELD_ONE:1,FIELD_TWO:2},{id:->"Hi!"})).toThrow()
  
describe 'Enumeration instanciation with structured descriptor', () ->

  it 'should throw an error when reserved method are used as prototype\'s field'
