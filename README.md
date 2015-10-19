Answer to [this SO question](http://stackoverflow.com/questions/9369780/coffeescript-and-enum-values)

#KVEnumeration.coffee : Key/Value style enum
## Basic usage

        CloseEventCodes = new KVEnumeration("CloseEventCodes", {
            CLOSE_NORMAL:1000
            CLOSE_GOING_AWAY:1001
            CLOSE_PROTOCOL_ERROR:1002
            CLOSE_UNSUPPORTED:1003
            CLOSE_NO_STATUS:1005
            CLOSE_ABNORMAL:1006
            CLOSE_TOO_LARGE:1009
          }
        )

> `CloseEventCodes.CLOSE_PROTOCOL_ERROR._key()` returns *CLOSE_PROTOCOL_ERROR*
> `CloseEventCodes.CLOSE_PROTOCOL_ERROR._value()` returns *1002*
> `CloseEventCodes.CLOSE_PROTOCOL_ERROR._type()` returns *CloseEventCodes*

## Use of prototypes

        CloseEventCodes = new KVEnumeration("CloseEventCodes", {
            CLOSE_NORMAL:1000
            CLOSE_GOING_AWAY:1001
            CLOSE_PROTOCOL_ERROR:1002
            CLOSE_UNSUPPORTED:1003
            CLOSE_NO_STATUS:1005
            CLOSE_ABNORMAL:1006
            CLOSE_TOO_LARGE:1009
          }, printsKeyValueType:->console.log "enum value with key #{@_key()} and value #{@_value()} belonging to instance #{@_type()} of Class KVEnumeration"
        )

> `CloseEventCodes.CLOSE_PROTOCOL_ERROR.printsKeyValueType()` prints *enum value with key CLOSE_PROTOCOL_ERROR and value 1002 belonging to instance CloseEventCodes of Class KVEnumeration*

## extend to a Class private static fields
Yeah, that's the funny thing with prototype inheritance : your coffeescript class can inherit this enumeration 

        MyClass
          @__proto__:new KVEnumeration 'MyClass', {PRIVATE_STATIC_ENUM1:"VAL1",PRIVATE_STATIC_ENUM2:"VAL2"}
          
Now `MyClass.PRIVATE_STATIC_ENUM1` and `MyClass.PRIVATE_STATIC_ENUM2` are defined.
