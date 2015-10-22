<a name="top"></a>
enumeration : Java-like enum for javascript/coffeescript  
=========================================================
 ![Travis build](https://travis-ci.org/sveinburne/enumeration.svg?branch=master)  *last Jasmine test run was the 10/22/15 at 00:30 UTC  with*
**41 specs, 0 failures**

**Since java 5, you can define enum static fields and enum value fields and methods. 
How about doing the same in javascript/coffeescript?**  

1\.  [Pros & Cons](#pros&cons)  
2\.  [Basic api overview](#basicapioverview)  
2.1\.  [Enumeration constructor](#enumerationconstructor)  
2.2\.  [Enumeration.value instances](#enumeration.valueinstances)  
2.3\.  [Enumeration instance](#enumerationinstance)  
3\.  [Guides](#guides)  
3.1\.  [For Coffeescript users](#forcoffeescriptusers)  
3.2\.  [For Javascript users](#forjavascriptusers)  
4\.  [Ecmascript compatibility](#ecmascriptcompatibility)  

<a name="pros&cons"></a>

###1\. Pros & Cons

- ✓ Straightforward-to-use though very flexible solution addressing the missing `enum` keyword  
- ✓ Enum values are guarantied **unique** and **read only**, can **inherit properties from a shared prototype** and have **their own specific properties**.  
- ✓ You can move a lot of the logic to those instances (example in [JS](JS.GUIDE.MD##refactoring) | [COFFEE](COFFEE.GUIDE.MD##refactoring)) and refactor, avoiding the `if else` mess. 
- ✓ The enumerations are guarantied unique and frozen (read-only) : you cannot instantiate two enumerations with a same name    
- ✓ Each enum value has a unique identifier that you provide at instantiation time, recoverable with `id()` method. You can easely match the instance associated to an identifier with `enumInstance.from(identifier)` which allows easy lightweight serialization.  
- ✓ You can hack a class ([JS](JS.GUIDE.MD#hackdaclassincorporateaspublicclassfields) | [COFFEE](COFFEE.GUIDE.MD#hackdaclassincorporateaspublicclassfields)) to inherit the Enumeration instance enum values and methods.  
- ✓ Rock solid jasmine specification tests. 
- ✗ you **must** guaranty the javascript engine is [ECMA-262 5th edition]() compatible, or at least provide the appropriate workaround, see [this section](#ecmascript)
- ✗ adds a dependency to **underscore.js**  
- ✗ the key/identifier of an enum value does not appear explicitly inside the object instance. Those are recoverable via `key()` and `id()` methods. However the `describe()` method returns a string with all those informations. And the `enumInstance.pretty()` returns a string with all the enum values and their associated descriptions.  
 
Critics and suggestions are welcome

<a name="basicapioverview"></a>

### 2\. Basic api overview
<a name="enumerationconstructor"></a>

#### 2.1\. Enumeration constructor
You can instantiate an enumeration with the provided `Enumeration` constructor. It will take three arguments :
- `enumType` : the name of this enumeration, must be unique amongst other Enumeration instances.
- `enumValues` : an object containing the set of enum values. Keys are enum value names and values are either a unique identifier 
,string or number, or a structured descriptor (example in [JS](JS.GUIDE.MD#usemorecomplexenumdescriptors) | [COFFEE](COFFEE.GUIDE.MD#usemorecomplexenumdescriptors)) 
- `prototype` : [optional] a prototype all the enum values will inherit (example in [JS](JS.GUIDE.MD#aprototypeforenumvalues) | [COFFEE](COFFEE.GUIDE.MD#aprototypeforenumvalues))

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
- `from(id)`  : retrieve the enum value instance that matches given `id`  
- `pretty()`  : give a pretty description of this Enumeration instance and all its enum values, useful for logging/debugging  
 
<a name="guides"></a>

### 3\. Guides
<a name="forcoffeescriptusers"></a>

#### 3.1\. For Coffeescript users
→ [coffeescript-users guide](COFFEE.GUIDE.MD#top)  
<a name="forjavascriptusers"></a>

#### 3.2\. For Javascript users
→ [javascript-users guide](JS.GUIDE.MD#top)  

<a name="ecmascript"></a>
<a name="ecmascriptcompatibility"></a>

### 4\. Ecmascript compatibility

> ECMA-262 5th edition was published on December 3, 2009 

Among those specifications, the following methods must be available:
```javascript
Object.defineProperty(object,property,propertyDescriptor)
Object.freeze(object)
Object.create(prototype,propertiesDescriptors)
```
These methods prevent user from mistakenly modify any property from the Enumeration instance and its bound enum values.   
Those can all be polyfilled with [es5-shim](https://github.com/es-shims/es5-shim).  
**Any attempt to write a read-only property [in 'strict mode' will throw an error](http://www.w3schools.com/js/js_strict.asp)**  
The only issue might be with `Object.defineProperty`[on IE8](https://github.com/es-shims/es5-shim/issues/5) with a es5-shim < v2.0.10  

Node version 0.5.1 and upper, published on July 14,  2011 support ECMAScript 5th edition.  
