
#Enumeration.coffee : Java-like enum

Answer to [this SO question](http://stackoverflow.com/questions/9369780/coffeescript-and-enum-values)  

Pros : 
* flexible solution to the missing `enum` keyword implementation
* enum values are unique
* enum values are read only
* enum values can inherit properties from a prototype given at Enumeration instanciation time. 
* you can define as many properties as you wish for each instantiated value (such as 'message', 'info' ...)
* The enumerations are guarantied uniques : you cannot instanciate two enumerations with a same name
* The enumerations are frozen (read-only)
* Each enum value has a unique identifier that you provide at instanciation time, recovorable with `id()` method. You can easely match the instance associated to an identifier with `enumInstance.from(identifier)` which allows easy lightweight serialization.
* You can hack a coffeescript `class` to have all the defined values of your Enumeration as static fields of this `class`, see at the bottom of this page

Cons :
* relies on ECMAScript 5 
* the key/identifier of an enum value does not appear explicitly inside the object instance. Those are recoverable via `key()` and `id()` methods. However the `describe()` method returns a string with all those informations. And the `enumInstance.pretty()` returns a string with all the enum values and their associated descriptions.

Critics and suggestions are welcome

## Basic usage

```coffeescript
closeEventCodes = new Enumeration("closeEventCodes", {
    CLOSE_NORMAL:1000
    CLOSE_GOING_AWAY:1001
    CLOSE_PROTOCOL_ERROR:1002
    CLOSE_UNSUPPORTED:1003
    CLOSE_NO_STATUS:1005
    CLOSE_ABNORMAL:1006
    CLOSE_TOO_LARGE:1009
  }
)
```
```coffeescript
closeEventCodes.CLOSE_PROTOCOL_ERROR.key()                   # evaluates to 'CLOSE_PROTOCOL_ERROR'  
closeEventCodes.CLOSE_PROTOCOL_ERROR.id()                    # evaluates to 1002  
closeEventCodes.CLOSE_PROTOCOL_ERROR.type()                  # evaluates to 'closeEventCodes'  
closeEventCodes.from(1006) is closeEventCodes.CLOSE_ABNORMAL # evaluates to true
1006 is closeEventCodes.CLOSE_ABNORMAL                       # evaluates to false
```

## Use of a prototype

```coffeescript
closeEventCodes = new Enumeration("closeEventCodes", {
      CLOSE_NORMAL:1000
      CLOSE_GOING_AWAY:1001
      CLOSE_PROTOCOL_ERROR:1002
      CLOSE_UNSUPPORTED:1003
      CLOSE_NO_STATUS:1005
      CLOSE_ABNORMAL:1006
      CLOSE_TOO_LARGE:1009
    }, printsKeyValueType:->console.log "enum value with key #{@key()} and value #{@id()} belonging to instance #{@type()} of Class Enumeration"
)
```
```coffeescript
closeEventCodes.CLOSE_PROTOCOL_ERROR.printsKeyValueType() 
# prints 'enum value with key CLOSE_PROTOCOL_ERROR and value 1002 belonging to instance closeEventCodes of Class Enumeration'
```
## Use more complex enum descriptors
```coffeescript
#the descriptor MUST contain an _id field as it is an object
closeEventCodes = new Enumeration("closeEventCodes", {
    CLOSE_NORMAL:        {_id:1000,info:"Connection closed normally"}
    CLOSE_GOING_AWAY:    {_id:1001,info:"Connection closed going away"}
    CLOSE_PROTOCOL_ERROR:{_id:1002,info:"Connection closed due to protocol error"}
    CLOSE_UNSUPPORTED:   {_id:1003,info:"Connection closed due to unsupported operation"}
    CLOSE_NO_STATUS:     {_id:1005,info:"Connection closed with no status"}
    CLOSE_ABNORMAL:      {_id:1006,info:"Connection closed abnormally"}
    CLOSE_TOO_LARGE:     {_id:1009,info:"Connection closed due to too large packet"}
  }
)
```
```coffeescript
closeEventCodes.CLOSE_PROTOCOL_ERROR.info #evaluates to 'Connection closed due to protocol error'
closeEventCodes.CLOSE_PROTOCOL_ERROR.key()                   # evaluates to 'CLOSE_PROTOCOL_ERROR'  
closeEventCodes.CLOSE_PROTOCOL_ERROR.id()                    # evaluates to 1002  
closeEventCodes.CLOSE_PROTOCOL_ERROR.type()                  # evaluates to 'closeEventCodes'  
closeEventCodes.from(1006) is closeEventCodes.CLOSE_ABNORMAL # evaluates to true
```
## #CoffeeHack : incorporates as private static fields
Yeah, that's the funny thing with prototype inheritance : your coffeescript class can inherit this Enumeration instance!

```coffeescript
class MyClass
  @__proto__:new Enumeration('MyClass', {PRIVATE_STATIC_ENUM1:"VAL1",PRIVATE_STATIC_ENUM2:"VAL2"})
```
Now `MyClass.PRIVATE_STATIC_ENUM1` and `MyClass.PRIVATE_STATIC_ENUM2` are defined.
If you don't like this hack, you can always define a class' static field holding the enum by replacing `@__proto__` with `@colors` for example. 

## Have a look to the constructor signature
```coffeescript
  ###*
  * @param  {string}  enumType A string identifying the type of this Enumeration instance
  * @param  {object}  enumValues an object which keys are the enum names, and values are 
  * enum descriptor.
  * A descriptor can be a single unique identifier (string or number),  or an object whose 
  * fields will be copied on the enum value instance. In this case
  * a field '_id' must be provided identifying this enum value.
  * @param  {object} proto [optional] a prototype each enum value will inherit from
  ###
  constructor:(enumType,enumValues,proto={}) -> ...
```
