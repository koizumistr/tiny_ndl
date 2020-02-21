require 'io/console'

require './tiny_ndl'

#c = TinyNdl.new(some-proxy-address, proxy-port)
c = TinyNdl.new()
f = IO::console

print "ISBN: "
until f.eof
  isbn = f.readline.chomp
  num = c.search(isbn)
  puts num
  if num < 0 then
    puts "something wrong"
    next
  elsif num == 0
    puts "not found"
    next
  elsif num == 1
    # nop
  else # > 1
    for i in 0..(num - 1) do
      print '[' + (i + 1).to_s + "]-------------\n"
      puts c.summary_array[i]
      puts c.id_array[i]
    end
    f = IO::console
    begin
      print "which?: "
      selnum = f.readline.chomp.to_i
#      p selnum, num
    end until selnum > 0 and selnum <= num
    c.select(selnum)
  end
  puts c.title
  puts c.title_yomi
  puts c.creator
  puts c.publisher
#  print c.title + "," + c.title_yomi + "," + c.publisher  + "\n"

  print "ISBN: "
end
