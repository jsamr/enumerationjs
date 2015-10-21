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
    expect(id).toBe(closeEventCodes[key].id()) for key,id of descriptors
  it 'should have their descriptor\'s key matching the result of key() ', ->
    expect(key).toBe(closeEventCodes[key].key()) for key of descriptors
  it 'should have the result of type() matching the type given at instanciation time', ->
    expect(enumType).toBe(closeEventCodes[key].type()) for key of descriptors
  it 'should share prototype\'s properties', ->
    expect(prototype.someStupidFun).toBe(closeEventCodes[key].someStupidFun) for key of descriptors

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
    expect(descr._id).toBe(closeEventCodes[key].id()) for key,descr of descriptors
  it 'should have their descriptor\'s key matching the result of key() ', ->
    expect(key).toBe(closeEventCodes[key].key()) for key of descriptors
  it 'should have an info field matching descriptor\'s info field ', ->
    expect(descr.info).toBe(closeEventCodes[key].info) for key,descr of descriptors
  it 'should have the result of type() matching the type given at instanciation time', ->
    expect(enumType).toBe(closeEventCodes[key].type()) for key of descriptors
  it 'should share prototype\'s properties', ->
    expect(prototype.someStupidFun).toBe(closeEventCodes[key].someStupidFun) for key of descriptors
  it 'should not have an _id property', ->
    expect(closeEventCodes[key]._id).not.toBeDefined() for key of descriptors

describe 'Enumeration instantiation with raw descriptor', () ->
  it 'should throw an error when reserved property "id" is a prototype property', ->
    expect(-> new Enumeration("SomeRawDescribedEnumeration1",{FIELD_ONE:1,FIELD_TWO:2},{id:->"Hi!"})).toThrow()
  it 'should throw an error when reserved property "key" is a prototype property', ->
    expect(-> new Enumeration("SomeRawDescribedEnumeration2",{FIELD_ONE:1,FIELD_TWO:2},{key:->"Hi!"})).toThrow()
  it 'should throw an error when reserved property "describe" is a prototype property', ->
    expect(-> new Enumeration("SomeRawDescribedEnumeration3",{FIELD_ONE:1,FIELD_TWO:2},{describe:->"Hi!"})).toThrow()
  it 'should throw an error when reserved property "type" is a prototype property', ->
    expect(-> new Enumeration("SomeRawDescribedEnumeration4",{FIELD_ONE:1,FIELD_TWO:2},{type:->"Hi!"})).toThrow()
  it 'should throw an error when two descriptors are equal (duplicate id)', ->
    expect(-> new Enumeration("SomeRawDescribedEnumeration5",{FIELD_ONE:1,FIELD_TWO:1})).toThrow()

describe 'Enumeration instantiation with structured descriptor', () ->
  it 'should throw an error when reserved property "id" is a prototype property', ->
    expect(-> new Enumeration("SomeStructuredDescribedEnumeration1",{FIELD_ONE:{_id:1},FIELD_TWO:{_id:2}},{id:->"Hi!"})).toThrow()
  it 'should throw an error when reserved property "key" is a prototype property', ->
    expect(-> new Enumeration("SomeStructuredDescribedEnumeration2",{FIELD_ONE:{_id:1},FIELD_TWO:{_id:2}},{key:->"Hi!"})).toThrow()
  it 'should throw an error when reserved property "describe" is a prototype property', ->
    expect(-> new Enumeration("SomeStructuredDescribedEnumeration3",{FIELD_ONE:{_id:1},FIELD_TWO:{_id:2}},{describe:->"Hi!"})).toThrow()
  it 'should throw an error when reserved property "type" is a prototype property', ->
    expect(-> new Enumeration("SomeStructuredDescribedEnumeration4",{FIELD_ONE:{_id:1},FIELD_TWO:{_id:2}},{type:->"Hi!"})).toThrow()

  it 'should throw an error when reserved property "id" is a descriptor property', ->
    expect(-> new Enumeration("SomeStructuredDescribedEnumeration5",{FIELD_ONE:{_id:1,id:1},FIELD_TWO:{_id:2,id:2}})).toThrow()
  it 'should throw an error when reserved property "key" is a descriptor property', ->
    expect(-> new Enumeration("SomeStructuredDescribedEnumeration6",{FIELD_ONE:{_id:1,key:""},FIELD_TWO:{_id:2,key:""}})).toThrow()
  it 'should throw an error when reserved property "describe" is a descriptor property', ->
    expect(-> new Enumeration("SomeStructuredDescribedEnumeration7",{FIELD_ONE:{_id:1,describe:->},FIELD_TWO:{_id:2,describe:->}})).toThrow()
  it 'should throw an error when reserved property "type" is a descriptor property', ->
    expect(-> new Enumeration("SomeStructuredDescribedEnumeration8",{FIELD_ONE:{_id:1,type:""},FIELD_TWO:{_id:2,type:""}})).toThrow()

  it 'should throw an error when descriptor is missing "_id" property', ->
    expect(-> new Enumeration("SomeStructuredDescribedEnumeration9",{FIELD_ONE:{},FIELD_TWO:{}})).toThrow()
  it 'should throw an error when two descriptor share the same "_id" property', ->
    expect(-> new Enumeration("SomeStructuredDescribedEnumeration10",{FIELD_ONE:{_id:1},FIELD_TWO:{_id:1}})).toThrow()
  it 'should throw an error when a descriptor "_id" property is a plain old js object', ->
    expect(-> new Enumeration("SomeStructuredDescribedEnumeration11",{FIELD_ONE:{_id:{}}})).toThrow()
  it 'should throw an error when a descriptor "_id" property is an array', ->
    expect(-> new Enumeration("SomeStructuredDescribedEnumeration12",{FIELD_ONE:{_id:[]}})).toThrow()
  it 'should throw an error when a descriptor "_id" property is a function', ->
    expect(-> new Enumeration("SomeStructuredDescribedEnumeration13",{FIELD_ONE:{_id:->}})).toThrow()

  it 'shall throw an error when a reserved property conflicts with an enum value key', ->
    expect(-> new Enumeration("SomeStructuredDescribedEnumeration14",{from:1})).toThrow()
    expect(-> new Enumeration("SomeStructuredDescribedEnumeration14",{pretty:1})).toThrow()


describe 'Enumeration instanciation', ->
  it 'shall throw an error if no enumValues are provided', ->
  expect(-> new Enumeration("EnumerationInstantiation1")).toThrow()
  it 'shall throw an error if no arguments are provided', ->
    expect(-> new Enumeration()).toThrow()
  it 'shall throw an error if first argument is not a string', ->
    expect(-> new Enumeration({})).toThrow()
  it 'shall throw an error if first argument is not a string', ->
    expect(-> new Enumeration({})).toThrow()
  it 'shall throw an error if enumValues is not an object', ->
    expect(-> new Enumeration("EnumerationInstantiation1","")).toThrow()
    expect(-> new Enumeration("EnumerationInstantiation1",1)).toThrow()
    expect(-> new Enumeration("EnumerationInstantiation1",[])).toThrow()


describe 'Enumeration instance', ->
  enumeration2=new Enumeration("EnumerationInstance2",{KEY1:1,KEY2:2})
  it 'shall throw an error when an other Enumeration instance exists with a given name', ->
    expect(-> new Enumeration("EnumerationInstance1",{})).not.toThrow()
    expect(-> new Enumeration("EnumerationInstance1",{})).toThrow()
  it 'from(id) method shall return the matching enum value instance which id is equal ', ->
    expect(enumeration2.from(2)).toBe(enumeration2.KEY2)
    expect(enumeration2.from(1)).toBe(enumeration2.KEY1)
  it 'from(id,throwOnFailure=true) shall throw an error when no matching id are found', ->
    expect(-> new Enumeration("EnumerationInstance3",{KEY1:1,KEY2:2}).from(3,throwOnFailure=true)).toThrow()
  it 'from(id,throwOnFailure=true) shall not throw an error when a matching id is found', ->
    expect(-> new Enumeration("EnumerationInstance3_1",{KEY1:1,KEY2:2}).from(2,throwOnFailure=true)).not.toThrow()
  it 'from(id,throwOnFailure=false) shall not throw an error when no matching id are found', ->
    expect(-> new Enumeration("EnumerationInstance4",{KEY1:1,KEY2:2}).from(3,throwOnFailure=false)).not.toThrow()
  it 'from(id) shall not throw an error when no matching id are found', ->
    expect(-> new Enumeration("EnumerationInstance5",{KEY1:1,KEY2:2}).from(3)).not.toThrow()
  it '\'s prototype should be Function.prototype ', ->
    expect(new Enumeration("EnumerationInstance6",{}).__proto__).toBe(Function.prototype)
