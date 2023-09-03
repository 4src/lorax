package.path = '../src/?.lua;' .. package.path

kl=require"klass"
obj,names =kl.obj,kl.names

Cat,Dog = obj"Cat",obj"Dog"

function Cat:init(s)  self.name = s; self:weight(s) end
function Cat:weight() self.heaven = self.name:find"-$" and 0 or 1 end
function Cat:hello()  print(self.name, names[Cat], "meow",self.heaven) end

function Dog:init(s)  return {name=s} end
function Dog:hello()  print(self.name, names[Dog], "wowf") end
 
c=Cat("fluffy-")
d=Dog("spot")

c:hello()
d:hello()
