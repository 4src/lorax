package.path = '../src/?.lua;' .. package.path

obj=require"obj" 

Cat,Dog = obj"Cat",obj"Dog"

function Cat:init(s)  self.name = s; self:weight(s) end
function Cat:weight() self.heaven = self.name:find"-$" and 0 or 1 end
function Cat:hello()  print(self.name, self._name, "meow",self.heaven) end

function Dog:init(s)  return {name=s} end
function Dog:hello()  print(self.name, self._name, "wowf") end
 
c=Cat("fluffy-")
d=Dog("spot")

c:hello()
d:hello()
