extend = (object, properties) ->
  for key, val of properties
    object[key] = val
  object

enumTypes=[]

#Java like enum
class Enumeration
  ###*
  * Static function that creates an enum object value. Uniqueness guarantied by object reference.
  * This objects's unique own field is the Enumeration name. It's read only.
  * @param {string or number} key the enum name, recommanded uppercase
  * @param {string or object} descriptor a string that identifies this value, or an object with fields that will be copied on the returned value. In this case
  * a field '_id' must be provided
  * @param {object} valueProto a prototype the returned object will inherit from
  * @param {string} enumType a string identifying the Enumeration instance this enum value is bound to
  ###
  @value:(enumName,descriptor,enumType,valueProto,ids)->
    identifier=descriptor._id or descriptor
    valueIsObject=descriptor._id?
    if identifier in ids then throw "Duplicate identifier : #{identifier}"
    else ids.push identifier
    methods=
      #Returns descriptor if not an object, descriptor._id otherwise
      id:    -> identifier
      key:   -> enumName
      type:  -> enumType
      describe: -> "#{enumName}:#{identifier}#{if valueIsObject then "  {#{enumName+":"+prop for enumName,prop of extend(descriptor,valueProto) when !(prop instanceof Function)}}" else ""}"
    testReserved=(object)-> throw "Reserved field #{field} cannot be passed as enum property" for field of object when field in Object.keys(methods)
    testReserved valueProto
    prototype=extend methods, valueProto
    properties={}
    defineReadOnlyProperty= (key0,value0)->
      properties[key0]=
        value:value0
        enumerable:true
    if descriptor instanceof Object
      testReserved descriptor
      if not descriptor._id? then throw "field '_id' must be defined when passing object as enum value"
      if descriptor._id instanceof Object then throw "_id descriptor field must be of type string or number"
      defineReadOnlyProperty key1,val1 for key1,val1 of descriptor when key1 isnt '_id'
    Object.create prototype, properties

  ###*
  * @param  {string}  enumType A string identifying the type of this Enumeration instance
  * @param  {object}  enumValues an object which keys are the enum names, and values are each enum descriptor.
  * A descriptor can be a single unique identifier (string or number),  or an object whose fields will be copied on the enum value instance. In this case
  * a field '_id' must be provided identifying this enum value.
  * @param  {object} proto [optional] a prototype each enum value will inherit from
  ###
  constructor:(enumType,enumValues,proto={}) ->
    #Guarantees identifiers uniqueness
    ids=[]
    #Ensure context to allow inheritance
    instance=@
    if enumType in enumTypes then throw "#{enumType} already exists!"
    else enumTypes.push enumType
    #Lambda to write enum values
    writeProperty = (descriptor,key) => @[key]=Enumeration.value(key,descriptor,enumType,proto,ids)
    writeProperty val,key for key,val of enumValues
    #Define non-enumerable method that returns a concise, pretty string representing the Enumeration
    Object.defineProperty @, 'pretty', value:-> "#{enumType}:#{"\n\t"+enume.describe() for key,enume of instance}"
    #Define non-enumerable method that returns the enum instance which matches identifier (descriptor if string, descriptor._id if object)
    Object.defineProperty @, 'from', value: (identifier) -> (instance[key] for key,enume of instance when enume.id() is identifier)[0] or throw "identifier #{identifier} does not match any"
    #Guaranties properties to be 'final', non writable
    Object.freeze(this)

#Export to npm
if module? then module.exports=Enumeration
