<a name="top"></a>
#enumeration : Java-like enum for javascript/coffeescript  

> ✓ Last Jasmine test run was the 10/21/15 at 20:11 UTC  with 
**41 specs, 0 failures**

**Since java 5, you can define enum static fields and enum value fields and methods. 
How about doing the same in javascript/coffeescript?**  

####Pros & Cons

- ✓ flexible solution to the missing `enum` keyword implementation  
- ✓ enum values are unique  
- ✓ enum values are read only  
- ✓ enum values can inherit properties from a prototype given at Enumeration instanciation time.  
- ✓ you can define as many properties as you wish for each instantiated value (such as 'message', 'info' ...)  
- ✓ The enumerations are guarantied uniques : you cannot instanciate two enumerations with a same name    
- ✓ The enumerations are frozen (read-only)  
- ✓ Each enum value has a unique identifier that you provide at instanciation time, recovorable with `id()` method. You can easely match the instance associated to an identifier with `enumInstance.from(identifier)` which allows easy lightweight serialization.  
- ✓ You can hack a class ([JS](JS.GUIDE.MD#hackdaclassincorporateaspublicclassfields) | [COFFEE](COFFEE.GUIDE.MD#hackdaclassincorporateaspublicclassfields)) to have all the defined values of your Enumeration instance as static fields of this `class`.  
- ✓ You can move all the logic inside those enum values ([JS](JS.GUIDE.MD##refactoring) | [COFFEE](COFFEE.GUIDE.MD##refactoring)) and refactor, avoiding the `if else` mess.  
- ✗ relies on **ECMAScript 5**  
- ✗ adds a dependency to **underscore.js**  
- ✗ the key/identifier of an enum value does not appear explicitly inside the object instance. Those are recoverable via `key()` and `id()` methods. However the `describe()` method returns a string with all those informations. And the `enumInstance.pretty()` returns a string with all the enum values and their associated descriptions.  
 
Critics and suggestions are welcome

#### Guides

- → Here is the [coffeescript-users guide](COFFEE.GUIDE.MD#top)  
- → Here is the [javascript-users guide](JS.GUIDE.MD#top)  
