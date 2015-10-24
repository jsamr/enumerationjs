isUnderscoreDefined= (root) ->
  isFunction= (obj) -> typeof obj is 'function'
  isFunction(us=root?._) and isFunction(us.isObject) and isFunction(us.isFunction) and isFunction(us.keys) and isFunction(us.map) and isFunction(us.clone) and isFunction(us.extend)

# Universal module definition
((root, factory) ->
  if typeof define == 'function' and define.amd
    deps=[]
    #Allows compatibility with any underscore version
    #and lodash
    if(not isUnderscoreDefined root) then deps.push "underscore"
    # AMD. Register enumeration.js module
    define "enumeration.js", deps, factory
  else if typeof module == 'object' and module.exports
    # Node. Does not work with strict CommonJS, but
    # only CommonJS-like environments that support module.exports,
    # like Node.
    module.exports = factory(require('underscore'))
  else
    # Browser globals (root is window)
    if not root._?
      throw new ReferenceError "underscore global object '_' must be defined.
        Get the bundled version of enumeration.js here : https://github.com/sveinburne/enumeration.js/#bundled
        or install underscore : http://underscorejs.org/ "
    #Export to global window
    root.Enumeration = factory(root._)

) this, (_) ->
  enumTypes=[]
  #Java like enum
  class Enumeration
    ###*
    * @return {array} an array containing all the registered enumTypes
    ###
    @list:-> _.clone(enumTypes)
    ###*
    * Static function that creates an enum object value. Uniqueness guarantied by object reference.
    * This objects's unique own field is the Enumeration name. It's read only.
    * @param {string or number} key the enum name, recommanded uppercase
    * @param {string or object} descriptor a string that identifies this value, or an object with fields that will be copied on the returned value. In this case
    * a field '_id' must be provided
    * @param {object} valueProto a prototype the returned object will inherit from
    * @param {string} enumType a string identifying the Enumeration instance this enum value is bound to
    * @param {object} enumerationProto : the prototype shared with Enumeration instance.prototype
    ###
    @constant:(enumName,descriptor,valueProto,ids,enumerationProto)->
      identifier=descriptor._id or descriptor
      valueIsObject=descriptor._id?
      if identifier in ids then throw "Duplicate identifier : #{identifier}"
      else ids.push identifier
      methods=
        #Returns descriptor if not an object, descriptor._id otherwise
        id:    -> identifier
        key:   -> enumName
        describe: -> "#{enumName}:#{identifier}#{if valueIsObject then "  {#{enumName+":"+prop for enumName,prop of extend(descriptor,valueProto) when !(_.isFunction(prop))}}" else ""}"
      testReserved=(object)-> throw "Reserved field #{field} cannot be passed as enum property" for field of object when field in _.keys(_.extend({},methods,enumerationProto))
      testReserved valueProto
      prototype=_.extend methods, valueProto
      properties={}
      prototype.__proto__=enumerationProto
      defineReadOnlyProperty= (key0,value0)->
        properties[key0]=
          value:value0
          enumerable:true
      if _.isObject(descriptor)
        testReserved descriptor
        if not descriptor._id? then throw "field '_id' must be defined when passing object as enum constant"
        if _.isObject(descriptor._id) then throw "_id descriptor field must be of type string or number"
        defineReadOnlyProperty key1,val1 for key1,val1 of descriptor when key1 isnt '_id'
      Object.freeze(Object.create prototype, properties)

    ###*
    * @param  {string}  enumType A string identifying the type of this Enumeration instance
    * @param  {object}  enumValues an object which keys are the enum names, and values are each enum descriptor.
    * A descriptor can be a single unique identifier (string or number),  or an object whose fields will be copied on the enum value instance. In this case
    * a field '_id' must be provided identifying this enum value.
    * @param  {object} proto [optional] a prototype each enum value will inherit from
    ###
    constructor:(enumType,enumValues,proto={}) ->
      idToKeyMap=_.object(_.map(enumValues,(key,value) -> [key._id or key,value]))
      self= -> self.pretty()
      #Guarantees identifiers uniqueness
      ids=[]
      if not _.isString(enumType) then throw "missing or bad enumType value : must be a string"
      if not _.isObject(enumValues) or _.isArray(enumValues) then throw "missing or bad enumValues : must be an object"
      if enumType in enumTypes then throw "#{enumType} already exists!"
      else
        if (key for key in _.keys(enumValues) when key in ["pretty","from","value"]).length>0
          throw "Cannot have enum constant as one amongst reserved enumeration property [pretty,from]"
      #Non enumerable prototype property
      Object.defineProperty(self,"prototype", value:{type:->enumType})
      #Lambda to write enum values
      writeProperty = (descriptor,key) => self[key]=Enumeration.constant(key,descriptor,proto,ids,self.prototype)
      writeProperty val,key for key,val of enumValues
      #Define non-enumerable method that returns a concise, pretty string representing the Enumeration
      Object.defineProperty self, 'pretty', value:-> "#{enumType}:#{"\n\t"+enumVal.describe() for key,enumVal of self}"
      #Define non-enumerable method that returns the enum instance which matches identifier (descriptor if string, descriptor._id if object)
      Object.defineProperty self, 'from', value:
        (identifier,throwOnFailure=false) -> self[idToKeyMap[identifier]] or (throw "identifier #{identifier} does not match any" if throwOnFailure )
      #Guaranties properties to be 'final', non writable
      Object.freeze(self)
      #Push the enum type upon success
      enumTypes.push enumType
      return self

  return Enumeration