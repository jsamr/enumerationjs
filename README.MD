<a name="top"></a>
# enumeration : Java-like enum for javascript/coffeescript  

![Travis build](https://travis-ci.org/sveinburne/enumeration.js.svg?branch=master) ![dependencies](https://david-dm.org/sveinburne/enumeration.js.svg)
**44 specs, 0 failures**

*Since java 5, you can define enum static fields and enum value fields and methods. 
How about doing the same in javascript/coffeescript with even more flexibility?*  

**PROS**
- ✓ Straightforward though very flexible solution addressing the missing `enum` keyword.  
- ✓ Enum values are guarantied **unique** and **read only**, can **inherit properties from a shared prototype** and have **their own specific properties**.  
- ✓ You can move a lot of the logic to those instances and refactor, avoiding the `if else` mess  ([JS](JS.GUIDE.MD#refactoring) | [COFFEE](COFFEE.GUIDE.MD#refactoring)) 
- ✓ The enumerations are guarantied unique and immutable : you cannot instantiate two enumerations with a same name    
- ✓ Lightweight **deserialization** with `enumInstance.from(identifier)` and **serialization** with `enumInstance.ENUM_VALUE.id()`  
- ✓ **Rock solid** jasmine specified tests. 
- ✓ Enum values are **typed** : `enumInstance.ENUM_VALUE instanceof enumInstance` evaluates to `true` | since v1.1 

**WARNS**
- ⚠ you **shall** guaranty the javascript engine is [ECMA-262 5th edition](https://people.mozilla.org/~jorendorff/es5.html) compatible, **or at least** provide the es5-shim package, see [this section](#ecmascript)
- ⚠ Requires **lodash** or **underscore**, see [this section](#dependencies)  
 
<a name="toc"></a>
**EXAMPLES**

> [→ COFFEE.GUIDE.MD](COFFEE.GUIDE.MD#top) for coffescript devs   
> [→ JS.GUIDE.MD](JS.GUIDE.MD#top)         for js devs         


**TABLE OF CONTENTS**  
1\.  [Install](#install)  
1.1\.  [Bundled version ~ AMD Compatible](#bundledversion~amdcompatible)  
1.2\.  [Lightweight version ~ AMD Compatible](#lightweightversion~amdcompatible)  
1.3\.  [Node](#node)  
1.4\.  [Meteor](#meteor)  
2\.  [Quick api overview](#quickapioverview)  
2.1\.  [Enumeration.constructor](#enumeration.constructor)  
2.2\.  [Enumeration.value instances](#enumeration.valueinstances)  
2.3\.  [Enumeration instance](#enumerationinstance)  
2.4\.  [Enumeration object](#enumerationobject)  
3\.  [Ecmascript compatibility](#ecmascriptcompatibility)  
4\.  [Dependencies](#dependencies)  

<a name="install"></a>

### 1\. Install

<a name="bundledversion~amdcompatible"></a>

#### 1.1\. Bundled version ~ AMD Compatible
You want to use the source from scratch? 

> [SOURCE ~ 59K](publish/Enumeration.bd.js) | [MINIFIED ~ 30K](publish/Enumeration.bd.min.js)

<a name="lightweightversion~amdcompatible"></a>

#### 1.2\. Lightweight version ~ AMD Compatible
Don't want to waste space? 

**Works for AMD module users (Requirejs...)**  
⚠ Assuming you can provide **underscore** dependency, see [this section](#dependencies)   
**For other users**  
⚠ Assuming the global variable `_` is defined, wether it's from **lodash** or **underscore** is not relevant.  

> [SOURCE ~ 6.4K](publish/Enumeration.js) | [MINIFIED ~ 3.5K](publish/Enumeration.min.js)

<a name="node"></a>

#### 1.3\. Node
> `npm install enumeration.js`    
> `var Enumeration = require("enumeration.js")`   

Runs one node >=0.10  

<a name="meteor"></a>

#### 1.4\. Meteor
> Meteor `meteor add sveinburne:enumeration.js`

Global constructor `Enumeration` will be available



<a name="quickapioverview"></a>

### 2\. Quick api overview

<a name="enumeration.constructor"></a>

#### 2.1\. Enumeration.constructor
You can instantiate an enumeration with the provided `Enumeration` constructor. It will take three arguments :
- `enumType` : the name of this enumeration, must be unique amongst other Enumeration instances.
- `enumValues` : an object containing the set of enum values. Keys are enum value names and values, aka descriptors can either be ...
    * a **raw descriptor** i.e. a unique identifier of type string or number  ([JS](JS.GUIDE.MD#basicusagewithrawdescriptors) | [COFFEE](COFFEE.GUIDE.MD#basicusagewithrawdescriptors))      
    * a **structured descriptor** i.e. a plain object ([JS](JS.GUIDE.MD#useofstructureddescriptors) | [COFFEE](COFFEE.GUIDE.MD#useofstructureddescriptors))   
- `prototype` : [optional] a prototype all the enum values will inherit ([JS](JS.GUIDE.MD#aprototypeforenumvalues) | [COFFEE](COFFEE.GUIDE.MD#aprototypeforenumvalues))

<a name="enumeration.valueinstances"></a>

#### 2.2\. Enumeration.value instances
Each **enum value** will have the following methods :
- `key()`      : retrieve the key (`SOME_ENUM_VALUE` for example)
- `id()`       : retrieve the identifier (`1000` for example)
- `type()`     : retrieve the Enumeration instance type,`enumType` Enumeration constructor's argument
- `describe()` : return a string of the form 'key:id', useful for logging/debugging  

 ...plus the properties provided at instantiation time (inherited from `prototype` and provided by descriptors)

<a name="enumerationinstance"></a>

#### 2.3\. Enumeration instance
- `from(id,throwOnFailure=false)`  : retrieve the enum value instance that matches given `id`. [optional] throwOnFailure, default to false, throws an error when no id match.  
- `pretty()`                       : give a pretty description of this Enumeration instance and all its enum values, useful for logging/debugging  
- `()`                             : shortcut for pretty()
 
<a name="enumerationobject"></a>

#### 2.4\. Enumeration object
- `Enumeration.list()` : returns an array containing the `enumType` for each Enumeration instance. 


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
Relies on underscore >=1.1. 
**NB** : On version 1.2 I switched to **lodash** for its optimizations and improvements, but on the other hand **underscore** appeared lighter for the bundled version, 
plus it's heavily used my meteor.


**↑ Back to [TABLE OF CONTENTS](#toc)**  
