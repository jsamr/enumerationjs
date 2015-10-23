<a name="top"></a>
# enumeration : Java-like enum for javascript/coffeescript  

![Travis build](https://travis-ci.org/sveinburne/enumeration.svg?branch=master)![dependencies](https://david-dm.org/sveinburne/enumeration.js.svg)
**43 specs, 0 failures**

*Since java 5, you can define enum static fields and enum value fields and methods. 
How about doing the same in javascript/coffeescript with even more flexibility?*  

**Pros**
- ✓ Straightforward though very flexible solution addressing the missing `enum` keyword.  
- ✓ Enum values are guarantied **unique** and **read only**, can **inherit properties from a shared prototype** and have **their own specific properties**.  
- ✓ You can move a lot of the logic to those instances and refactor, avoiding the `if else` mess  ([JS](JS.GUIDE.MD#refactoring) | [COFFEE](COFFEE.GUIDE.MD#refactoring)) 
- ✓ The enumerations are guarantied unique and frozen : you cannot instantiate two enumerations with a same name    
- ✓ Lightweight deserialization with `enumInstance.from(identifier)` and serialization with `enumInstance.ENUM_VALUE.id()`  
- ✓ Rock solid jasmine specified tests. 
- ✓ Enum values are typed : `enumInstance.ENUM_VALUE instanceof enumInstance` evaluates to `true` 

**Disclaimers**
- ⚠ you **must** guaranty the javascript engine is [ECMA-262 5th edition](https://people.mozilla.org/~jorendorff/es5.html) compatible, **or at least** provide the es5-shim package, see [this section](#ecmascript)
- ⚠ adds a dependency to **lodash**  
- ⚠ the key/identifier of an enum value does not appear explicitly inside the object instance. See the [enum values API](#enumeration.valueinstances) for more info.
 
Critics and suggestions are welcome

<a name="toc"></a>
**TABLE OF CONTENTS**  
1\.  [Quick api overview](#quickapioverview)  
1.1\.  [Enumeration.constructor](#enumeration.constructor)  
1.2\.  [Enumeration.value instances](#enumeration.valueinstances)  
1.3\.  [Enumeration instance](#enumerationinstance)  
1.4\.  [Enumeration object](#enumerationobject)  
2\.  [Guides](#guides)  
2.1\.  [For Coffeescript users](#forcoffeescriptusers)  
2.2\.  [For Javascript users](#forjavascriptusers)  
3\.  [Ecmascript compatibility](#ecmascriptcompatibility)  
4\.  [Dependencies](#dependencies)  

<a name="quickapioverview"></a>

### 1\. Quick api overview

<a name="enumeration.constructor"></a>

#### 1.1\. Enumeration.constructor
You can instantiate an enumeration with the provided `Enumeration` constructor. It will take three arguments :
- `enumType` : the name of this enumeration, must be unique amongst other Enumeration instances.
- `enumValues` : an object containing the set of enum values. Keys are enum value names and values, aka descriptors can either be ...
    * a **raw descriptor** i.e. a unique identifier of type string or number  ([JS](JS.GUIDE.MD#basicusagewithrawdescriptors) | [COFFEE](COFFEE.GUIDE.MD#basicusagewithrawdescriptors))      
    * a **structured descriptor** i.e. a plain object ([JS](JS.GUIDE.MD#useofstructureddescriptors) | [COFFEE](COFFEE.GUIDE.MD#useofstructureddescriptors))   
- `prototype` : [optional] a prototype all the enum values will inherit ([JS](JS.GUIDE.MD#aprototypeforenumvalues) | [COFFEE](COFFEE.GUIDE.MD#aprototypeforenumvalues))

<a name="enumeration.valueinstances"></a>

#### 1.2\. Enumeration.value instances
Each **enum value** will have the following methods :
- `key()`      : retrieve the key (`SOME_ENUM_VALUE` for example)
- `id()`       : retrieve the identifier (`1000` for example)
- `type()`     : retrieve the Enumeration instance type,`enumType` Enumeration constructor's argument
- `describe()` : return a string of the form 'key:id', useful for logging/debugging  

 ...plus the properties provided at instantiation time (inherited from `prototype` and provided by descriptors)

<a name="enumerationinstance"></a>

#### 1.3\. Enumeration instance
- `from(id,throwOnFailure=false)`  : retrieve the enum value instance that matches given `id`. [optional] throwOnFailure, default to false, throws an error when no id match.  
- `pretty()`                       : give a pretty description of this Enumeration instance and all its enum values, useful for logging/debugging  
- `()`                             : shortcut for pretty()
 
<a name="enumerationobject"></a>

#### 1.4\. Enumeration object
- `Enumeration.list()` : returns an array containing the `enumType` for each Enumeration instance. 

<a name="guides"></a>

### 2\. Guides
<a name="forcoffeescriptusers"></a>

#### 2.1\. For Coffeescript users
> → [COFFEE.GUIDE.MD](COFFEE.GUIDE.MD#top)  
<a name="forjavascriptusers"></a>

#### 2.2\. For Javascript users
> → [JS.GUIDE.MD](JS.GUIDE.MD#top)  

<a name="ecmascript"></a>
<a name="ecmascriptcompatibility"></a>

### 3\. Ecmascript compatibility

> ECMA-262 5th edition was published on December 3, 2009 

Among those specifications, the following methods must be available:
```javascript
Object.defineProperty(object,property,propertyDescriptor)
Object.freeze(object)
Object.create(prototype,propertiesDescriptors)
```
These methods prevent user from mistakenly modify any property from the Enumeration instance and its bound enum values :  
**any attempt to write a read-only property [in 'strict mode' will throw an error](http://www.w3schools.com/js/js_strict.asp)**, ignored otherwise.  
**any attempt to reconfigure a non-configurable property [in 'strict mode' will throw an error](http://www.w3schools.com/js/js_strict.asp)**, ignored otherwise.     
For older browser, those methods can be polyfilled with [es5-shim](https://github.com/es-shims/es5-shim), however the write permissions will be ignored.   

<a name="dependencies"></a>

### 4\. Dependencies
Relies on lodash >=3.0. 
Therefore, runs one node >=0.10

**↑ Back to [TABLE OF CONTENTS](#toc)**  
