##### → Back to [README.MD](README.MD)  

> This is the **coffeescript-users** guide file.  
> **If you want to read the javascript-users guide** then go here : [JS.GUIDE.MD](JS.GUIDE.MD)  


**Summary**
>
[1. Basic usage](#basic-usage)  
[2. A prototype for enum values](#a-prototype-for-enum-values)  
[3. Use more complex enum descriptors](#use-more-complex-enum-descriptors)  
[4. Extend your Enumeration with prototype inheritance](#extend-your-enumeration-with-prototype-inheritance)  
[5. Hack da class : incorporate as public class fields](#hack-da-class--incorporate-as-public-class-fields)  
[6. The constructor signature](#the-constructor-signature)  
[7. Refactoring](#refactoring)  



## Basic usage
> ✓ If an enumeration called 'closeEventCodes' already exists, an error will show up  
> ✓ If a duplicate id (value associated to key) is given, an error will show up  




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
closeEventCodes.CLOSE_PROTOCOL_ERROR.describe()              # evaluates to 'CLOSE_PROTOCOL_ERROR:1002'
closeEventCodes.from(1006) is closeEventCodes.CLOSE_ABNORMAL # evaluates to true
1006 is closeEventCodes.CLOSE_ABNORMAL                       # evaluates to false
```
## A prototype for enum values
> ✓ If you mistakenly use a reserved property in the given prototype (id,key,describe or type), an error will show up  
<br/>


```coffeescript
closeEventCodes = new Enumeration("closeEventCodes", {
      CLOSE_NORMAL:1000
      CLOSE_GOING_AWAY:1001
      CLOSE_PROTOCOL_ERROR:1002
      CLOSE_UNSUPPORTED:1003
      CLOSE_NO_STATUS:1005
      CLOSE_ABNORMAL:1006
      CLOSE_TOO_LARGE:1009
    }, print: -> console.log @describe()
)
```
```coffeescript
closeEventCodes.CLOSE_NO_STATUS.print() # prints 'CLOSE_NO_STATUS:1005'
```
## Use more complex enum descriptors

> ⚠ Each descriptor **must** contain an `_id` field of type `string` or `number`, an exception will be thrown otherwise.  
> ✓ If an enumeration called 'closeEventCodes' already exists, an error will show up  
> ✓ If a duplicate _id is given, an error will show up   
> ✓ If you mistakenly use a reserved property in the given descriptor (id,key,describe or type), an error will show up  


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
closeEventCodes.CLOSE_PROTOCOL_ERROR._id                     # evaluates to undefined 
closeEventCodes.CLOSE_PROTOCOL_ERROR.type()                  # evaluates to 'closeEventCodes'  
closeEventCodes.CLOSE_PROTOCOL_ERROR.describe()              # evaluates to 'CLOSE_PROTOCOL_ERROR:1002 {info:Connection closed due to protocol error}' 
closeEventCodes.from(1006) is closeEventCodes.CLOSE_ABNORMAL # evaluates to true
```
## Extend your Enumeration with prototype inheritance

> ⚠ The Enumeration instance is **frozen**, so you cannot add fields directly to the instance, you *must* inherit through the prototype chain or [hack da class](#hack-da-class--incorporates-as-public-class-fields).  


```coffeescript
#Inherit all Enumeration instance fields by moving it to myEnum prototype
#The prototype will still be frozen, but myEnum instance won't.
myEnum=Object.create new Enumeration('myEnum',{STATE1:1,STATE2:2,STATE3:3})
myEnum.newFunction = -> @STATE1.describe()
```

## Hack da class : incorporate as public class fields
Yeah, that's the funny thing with prototype inheritance : your coffeescript class can inherit this Enumeration instance.

> ⚠ Be carefull, `@__proto__` can be overriden if and only if it is the last class statement. Otherwise you will override the forthcoming statements

```coffeescript
class MyClass
  constructor : -> @someProperty="someValue"
  someFunction: -> 'doing stuff'

  @__proto__:new Enumeration('MyClass',
    PUBLIC_STATIC_ENUM1:"VAL1"
    PUBLIC_STATIC_ENUM2:"VAL2"
  )
```
Now `MyClass.PUBLIC_STATIC_ENUM1` and `MyClass.PUBLIC_STATIC_ENUM2` are defined.

> ✓ If you don't like this hack, you can either define a class' static field holding the enum by replacing `@__proto__` with `@colors` or `@states` ... or use [prototype inheritance instead](#extend-your-enumeration-with-prototype-inheritance).

## The constructor signature


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

