
#Enumeration.coffee : Java-like enum
Answer to [this SO question](http://stackoverflow.com/questions/9369780/coffeescript-and-enum-values)
Pros : 
* enum values are unique
* enum values are read only
* enum values can inherit properties from a prototype given at Enumeration instanciation time. 
* The enumerations are guarantied uniques : you cannot instanciate two enumerations with a same name
* the enumerations are frozen (read-only)

Cons :
* relies on ECMAScript 5 

## Basic usage

```coffeescript
CloseEventCodes = new Enumeration("CloseEventCodes", {
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
> `CloseEventCodes.CLOSE_PROTOCOL_ERROR._key()` evaluates *CLOSE_PROTOCOL_ERROR* 
> `CloseEventCodes.CLOSE_PROTOCOL_ERROR._value()` evaluates *1002*  
> `CloseEventCodes.CLOSE_PROTOCOL_ERROR._type()` evaluates *CloseEventCodes*  
> `CloseEventCodes.from(1006) is CloseEventCodes.CLOSE_ABNORMAL` evaluates `true`  
> `1006 is CloseEventCodes.CLOSE_ABNORMAL` evaluates `false`  

## Use of prototypes

```coffeescript
CloseEventCodes = new Enumeration("CloseEventCodes", {
      CLOSE_NORMAL:1000
      CLOSE_GOING_AWAY:1001
      CLOSE_PROTOCOL_ERROR:1002
      CLOSE_UNSUPPORTED:1003
      CLOSE_NO_STATUS:1005
      CLOSE_ABNORMAL:1006
      CLOSE_TOO_LARGE:1009
    }, printsKeyValueType:->console.log "enum value with key #{@_key()} and value #{@_value()} belonging to instance #{@_type()} of Class Enumeration"
)
```

> `CloseEventCodes.CLOSE_PROTOCOL_ERROR.printsKeyValueType()` prints *enum value with key CLOSE_PROTOCOL_ERROR and value 1002 belonging to instance CloseEventCodes of Class Enumeration*

## incorporates in a Class private static fields
Yeah, that's the funny thing with prototype inheritance : your coffeescript class can inherit this enumeration 

```coffeescript
class MyClass
  @__proto__:new Enumeration('MyClass', {PRIVATE_STATIC_ENUM1:"VAL1",PRIVATE_STATIC_ENUM2:"VAL2"})
```
Now `MyClass.PRIVATE_STATIC_ENUM1` and `MyClass.PRIVATE_STATIC_ENUM2` are defined.
