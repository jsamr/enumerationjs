extend = (object, properties) ->
  for key, val of properties
    object[key] = val
  object

enumNames=[]

#C like enum
class KVEnumeration
  #Registered enums
  #Static function that creates an enum object value. Uniqueness guarantied by object reference.
  #This objects's unique own field is the KVEnumeration name. It's read only.
  #string value shall be uppercase
  @value:(key,value,enumName="KVEnumeration",valueProto)->
    prototype=extend
      _value:-> @[key]
      _key:->key
      _type:->enumName
    , valueProto
    properties={}
    properties[key]=
      value:value
      enumerable:true
    Object.create prototype, properties

  constructor:(enumName,enumValues,valueProto={}) ->
    #Check for uniqueness
    if enumName in enumNames then throw "#{enumName} already exists!"
    else enumNames.push enumName
    #Lambda to write enum values
    writeProperty = (property,key) => @[key]=KVEnumeration.value(key,property,enumName,valueProto)
    writeProperty val,key for key,val of enumValues
    #Define non-enumerable property
    Object.defineProperty @, 'concise', {
      #Returns a concise string representing the KVEnumeration
      value:-> "#{enumName}:[#{" "+val+" " for val in enumValues}]"
    }
    Object.defineProperty @, 'from', {
      #Returns the enum instance that matches value
      value: (lookupVal) -> (@[key] for key,val of enumValues when val is lookupVal)[0]
    }
    #Guaranties properties to be 'final', non writable
    Object.freeze(this)


