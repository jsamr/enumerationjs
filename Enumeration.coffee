class Enumeration
  #Registered enums
  @types:[]
  #Static function that creates an enum object value. Uniqueness guarantied by object reference.
  #This objects's unique own field is the Enumeration name. It's read only.
  #string value shall be uppercase
  @value:(value,enumName="Enumeration")->
    prototype= id: -> @[enumName]
    properties={}
    properties[enumName]=
      value:value
      enumerable:true
    Object.create prototype, properties

  constructor:(enumName,enumValues) ->
    #Check for uniqueness
    if enumName in Enumeration.types then throw "#{enumName} already exists!"
    else Enumeration.types.push enumName
    #Lambda to write enum values
    writeProperty = (property,key) => @[key or property]=Enumeration.value(property,enumName)
    if enumValues instanceof Array then writeProperty val for val in enumValues
    else writeProperty val,key for key,val of enumValues
    #Define non-enumerable property
    Object.defineProperty @, 'concise', {
      #Returns a concise string representing the enumeration
      value:-> "#{enumName}:[#{" "+val+" " for val in enumValues}]"
    }
    Object.defineProperty @, 'from', {
      #Returns the enum instance that matches value
      value: (lookupVal) -> (@[key] for key,val of enumValues when val is lookupVal)[0]
    }
    #Guaranties properties to be 'final', non writable
    Object.freeze(this)
