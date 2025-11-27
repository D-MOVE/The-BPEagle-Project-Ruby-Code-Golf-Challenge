s=gets
puts (?A..?Z).filter_map{(k,),v=s.scan(/(?=(\w\w))/).tally.max_by{_2}
(s.gsub!k,it;it+?:+k)if v>1}*?,,s