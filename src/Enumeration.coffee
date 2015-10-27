isUnderscoreDefined= (root) ->
  isFunction= (obj) -> typeof obj is 'function'
  isFunction(us=root?._) and isFunction(us.isObject) and isFunction(us.isFunction) and isFunction(us.keys) and isFunction(us.map) and isFunction(us.clone) and isFunction(us.extend)

# Universal module definition
((root, factory) ->
#AMD Style
  if typeof define == 'function' and define.amd
    deps=[]
    #Allows compatibility with any underscore version
    #and lodash
    if(not isUnderscoreDefined root) then deps.push "underscore"
    # AMD. Register enumerationjs module
    define "enumerationjs", deps, factory
#CommonJS style
  else if typeof module == 'object' and module.exports
# Node. Does not work with strict CommonJS, but
# only CommonJS-like environments that support module.exports,
# like Node.
    module.exports = factory(require('underscore'))
#Meteor style
  else if root.Package?.underscore?._? then root.Enumeration = factory(root.Package.underscore._)
#Globals
  else if root._ then  root.Enumeration = factory(root._)
  else throw new ReferenceError "underscore global object '_' must be defined.
        Get the bundled version of enumerationjs here : https://github.com/sveinburne/enumerationjs/#bundled
        or install underscore : http://underscorejs.org/ "
) this, (_) ->
  mapObject=(object,transform,ignorePredicate)->
    unfiltered=_.object(_.map(object,((value,key)-> [key,transform(value,key)])))
    if not ignorePredicate then unfiltered
    else _.omit(unfiltered,ignorePredicate)

  enumTypes=[]
  defineNonEnumerableProperty=do ->
    #check for IE <= V8 first, then check defineProperty
    if ((window?.attachEvent && !window?.addEventListener) or not Object.defineProperty?) then (obj,name,prop)->obj[name]=prop
    else (obj,name,prop)->Object.defineProperty(obj,name,{value:prop,configurable:false})
  freezeObject= Object.freeze or _.identity
  baseCreate = do ->
    create=Object.create or (prototype)->
      ctor= ->
      ctor.prototype=prototype
      new ctor()
    (prototype) ->
      if !_.isObject(prototype)
        return {}
      create(prototype)

  createObject= (prototype, props) ->
    result = baseCreate(prototype)
    if props then  _.extend result, props
    result

  ###*
  * Static function that creates an enum object value. Uniqueness guarantied by object reference.
  * This objects's unique own field is the Enumeration name. It's read only.
  * @param {string or number} key the enum name, recommanded uppercase
  * @param {string or object} descriptor a string that identifies this value, or an object with fields that will be copied on the returned value. In this case
  * a field '_id' must be provided
  * @param {object} valueProto a prototype the returned object will inherit from
  * @param {string} enumType a string identifying the Enumeration instance this enum constant is bound to
  * @param {object} enumerationProto : the prototype shared with Enumeration instance.prototype
  ###
  constant=(enumName,descriptor,valueProto,ids,enumerationProto)->
    thatConstant=null
    identifier=descriptor._id or descriptor
    valueIsObject=descriptor._id?
    if identifier in ids then throw "Duplicate identifier : #{identifier}"
    else ids.push identifier
    getId=-> identifier
    getKey=-> enumName
    evaluateSchema=(schema,includePrototype,evaluateMethods)->
      recursiveEval=(obj)->
        if _.isFunction(obj) then recursiveEval(obj.call(thatConstant))
        else if not _.isObject(obj) or obj is null then obj
        else mapObject(obj,recursiveEval, (val)-> val is undefined or _.isFunction(val))
      objectToIterateOn=if not includePrototype then schema else _.extend(schema,valueProto)
      if evaluateMethods then recursiveEval(objectToIterateOn)
      else JSON.parse(JSON.stringify(objectToIterateOn))

    methods=
      #Returns descriptor if not an object, descriptor._id otherwise
      id:getId
      toJSON:getId
      schema:(includePrototype=true,evaluateMethods=true)->
        base=if valueIsObject then descriptor else {_id:identifier}
        evaluateSchema(base,includePrototype,evaluateMethods)
      toString:getKey
      key:     getKey
      describe: -> "#{enumName}:#{identifier}#{if valueIsObject then "  {#{enumName+":"+prop for enumName,prop of _.extend({},descriptor,valueProto) when !(_.isFunction(prop))}}" else ""}"
    testReserved=(object)-> throw "Reserved field #{field} cannot be passed as enum property" for field of object when field in _.keys(_.extend({},methods,enumerationProto))
    testReserved valueProto
    prototype=baseCreate(enumerationProto)
    _.extend prototype, methods, valueProto
    properties={}
    defineReadOnlyProperty= (key0,value0)->
      properties[key0]=
        value:value0
        enumerable:true
    if _.isObject(descriptor)
      testReserved descriptor
      if not descriptor._id? then throw "field '_id' must be defined when passing object as enum constant"
      if _.isObject(descriptor._id) then throw "_id descriptor field must be of type string or number"
      defineReadOnlyProperty key1,val1 for key1,val1 of descriptor when key1 isnt '_id'
    thatConstant=freezeObject(Object.create prototype, properties)
    thatConstant

  #Java like enum
  class Enumeration
    ###*
    * @return {array} an array containing all the registered enumTypes
    ###
    @list:-> _.clone(enumTypes)
    ###
    * alias to Enumeration.list
    ###
    @types:@list

    ###*
    * @param  {string}  enumType A string identifying the type of this Enumeration instance
    * @param  {object}  enumValues an object which keys are the enum names, and values are each enum descriptor.
    * A descriptor can be a single unique identifier (string or number),  or an object whose fields will be copied on the enum constant instance. In this case
    * a field '_id' must be provided identifying this enum constant.
    * @param  {object} proto [optional] a prototype each enum constant will inherit from
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
        if (key for key in _.keys(enumValues) when key in ["pretty","from","toJSON","assertScheme","type"]).length>0
          throw "Cannot have enum constant as one amongst reserved enumeration property [pretty,from]"
      self.prototype={type:->enumType}
      #Define non-enumerable method that returns a concise, pretty string representing the Enumeration
      Object.defineProperty self, 'pretty', value:(evalConstantsMethods=false)-> JSON.stringify(self.toJSON(true,evalConstantsMethods),null,2)
      #Define non-enumerable method that returns a concise, pretty string representing the Enumeration
      Object.defineProperty self, 'prettyPrint', value:(evalConstantsMethods=false)-> console.log(self.toJSON(true,evalConstantsMethods))
      writeConstant = (descriptor,key) => self[key]=constant(key,descriptor,proto,ids,self.prototype)
      writeConstant val,key for key,val of enumValues
      #Define non-enumerable method that returns a concise, pretty string representing the Enumeration

      #Define non-enumerable method that returns the enum instance which matches identifier (descriptor if string, descriptor._id if object)
      defineNonEnumerableProperty self, 'from',
        (identifier,throwOnFailure=false) -> self[idToKeyMap[identifier]] or (throw "identifier #{identifier} does not match any" if throwOnFailure )
      defineNonEnumerableProperty self, 'toJSON', (includeConstantsPrototype=false,evalConstantsMethods=false) ->
        _.extend({type:enumType},mapObject(_.pick(self,_.keys(enumValues)), (val)-> val.schema(includeConstantsPrototype,evalConstantsMethods)))
      defineNonEnumerableProperty self, 'type', enumType
      defineNonEnumerableProperty self, 'assertSchema',(schemaString,strict=true,providedType=null)->
        'use strict'
        if not _.isString(schemaString) then throw new TypeError("first argument must be a string")
        remoteShema=JSON.parse(schemaString)
        localSchema=self.toJSON()
        if providedType? then remoteShema.type=providedType
        if remoteShema.type isnt localSchema.type then throw new Error("Assertion failed. Local schema type differs from remote schema type.")
        if strict
          if not _.isEqual(localSchema,remoteShema) then throw new Error("Assertion failed. Local schema differs from remote schema.")
        else
          id=(val)->val._id
          if not (_.isEqual(mapObject(remoteShema,id),mapObject(self.toJSON(),id)))
            throw new Error("Assertion failed. Local schema differs from remote schema.")
        true

      #Push the enum type upon success
      enumTypes.push enumType
      return self

  return Enumeration