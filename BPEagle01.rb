s,c,a=gets,?@,[]
[s.gsub!(K,c.next!),a<<c+?:+K]while((K,),v=s.scan(/(?=(\w\w))/).tally.max_by{_2})&&v>1
puts a*?,,s