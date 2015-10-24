<a name="top">
**← Back to [README.MD](README.MD#top)**  
<br/>
> This is the **coffeescript-users** guide for the **enumeration** package.   
> **If you want to read the javascript-users guide** then go here : [JS.GUIDE.MD](JS.GUIDE.MD#top)  

<a name="toc"></a>
**TABLE OF CONTENTS**
<br/>
1\.  [Basic usage with raw descriptors](#basicusagewithrawdescriptors)  
2\.  [A prototype for enum values](#aprototypeforenumvalues)  
3\.  [Use of structured descriptors](#useofstructureddescriptors)  
4\.  [Extend your Enumeration with prototype inheritance](#extendyourenumerationwithprototypeinheritance)  
5\.  [Hack da class, incorporate as public class fields](#hackdaclassincorporateaspublicclassfields)  
6\.  [Refactoring](#refactoring)  
6.1\.  [get rid of a if / else or switch mess](#getridofaif/elseorswitchmess)  
6.2\.  [What about the visitor pattern?](#whataboutthevisitorpattern?)  

<a name="basicusagewithrawdescriptors"></a>

## 1\. Basic usage with raw descriptors
> ✓ If an enumeration called 'closeEventCodes' already exists, an error will show up  
> ✓ If a duplicate id (value associated to key) is given, an error will show up  
> ✓ If a key conflicts with one amongst Enumeration instance reserved methods, an error will show up : you should always use uppercase strings as keys to avoid any conflict - plus it's a standard for enums.  




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
closeEventCodes.CLOSE_ABNORMAL instanceof closeEventCodes    # evaluates to true
```
<a name="aprototypeforenumvalues"></a>

## 2\. A prototype for enum values
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
<a name="useofstructureddescriptors"></a>

## 3\. Use of structured descriptors

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
<a name="extendyourenumerationwithprototypeinheritance"></a>

## 4\. Extend your Enumeration with prototype inheritance

> ⚠ The Enumeration instance is **frozen**, so you cannot add fields directly to the instance, 
you *must* inherit through the prototype chain or [hack da class](#hackdaclassincorporateaspublicclassfields).  

```coffeescript
#Inherit all Enumeration instance fields by moving it to myEnum prototype
#The prototype will still be frozen, but myEnum instance will not.
myEnum=Object.create new Enumeration('myEnum',{STATE1:1,STATE2:2,STATE3:3})
myEnum.newFunction = -> @STATE1.describe()
```

<a name="hackdaclassincorporateaspublicclassfields"></a>

## 5\. Hack da class, incorporate as public class fields
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

> ✓ If you don't like this hack, you can either define a class' static field holding the enum by
replacing `@__proto__` with `@colors` or `@states` ... or use [prototype inheritance instead](#extendyourenumerationwithprototypeinheritance).

<a name="refactoring"></a>

## 6\. Refactoring

<a name="getridofaif/elseorswitchmess"></a>

### 6.1\. get rid of a if / else or switch mess

```coffeescript
#Old school enum
States=Object.freeze
    OK:0
    ERROR_1:1
    ERROR_2:2
    ERROR_3:3

#somewhere later
if state is States.OK then console.log "Message transmitted"
else if state is States.ERROR_1 then console.log "An error of type 1 occurred"
else if state is States.ERROR_2 then console.log "An error of type 2 occurred"
else if state is States.ERROR_3 then console.log "An error of type 3 occurred"
```
Move the logic inside the Enumeration instance...
```coffeescript
#New school enum
States=new Enumeration('States',
    OK:      _id:0, msg:"Message transmitted"
    ERROR_1: _id:1, msg:"An error of type 1 occurred"
    ERROR_2: _id:2, msg:"An error of type 2 occurred"
    ERROR_3: _id:3, msg:"An error of type 3 occurred"
  , report:-> console.log @msg
)

#somewhere later
state.report()
```

<a name="whataboutthevisitorpattern?"></a>

### 6.2\. What about the visitor pattern? 
```coffeescript
#Old school enum
States=Object.freeze
    OK:0
    ERROR_1:1
    ERROR_2:2
    ERROR_3:3

stateHandler={
  someFun1:-> 
    #do some stuff relative to this instance ...
    console.log "Error 1"
  someFun2:->
    #do some stuff relative to this instance ...
    console.log "Error 2"
  someFun3:-> 
    #do some stuff relative to this instance ...
    console.log "Error 3"
  onError:  (state) ->
    if state is States.ERROR_1 then this.someFun1()
    else if state is States.ERROR_2 then this.someFun2()
    else if state is States.ERROR_3 then this.someFun3()
  onSuccess: -> 
    #do some stuff relative to this instance ...    
    console.log "Success!"
  handle: (state) ->
    if state is States.OK then this.onSuccess()
    else this.onError(state)
}
```
Move the logic, and pass the stateHandler instance to the enum value handle function!
```coffeescript
#New school enum
States=new Enumeration('States',
        OK:      _id:0, fun:'onSuccess'
        ERROR_1: _id:1, fun:'someFun1'
        ERROR_2: _id:2, fun:'someFun2'
        ERROR_3: _id:3, fun:'someFun3'
, handle:(handler)-> handler[@fun]()
)

stateHandler=
  someFun1:-> 
    #do some stuff relative to this instance ...
    console.log "Error 1"
  someFun2:->
    #do some stuff relative to this instance ...
    console.log "Error 2"
  someFun3:-> 
    #do some stuff relative to this instance ...
    console.log "Error 3"
  onSuccess: -> 
    #do some stuff relative to this instance ...    
    console.log "Success!"
  handle: (state) -> state.handle @
  
```

Cleaner, isn't it?
<br/><br>
**↑ Back to [TABLE OF CONTENTS](#toc)**  
**← Back to [README.MD](README.MD#top)**  



