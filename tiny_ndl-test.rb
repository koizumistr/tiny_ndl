require 'io/console'

require './tiny_ndl'

# c = TinyNdl.new(some-proxy-address, proxy-port)
c = TinyNdl.new
f = IO.console

print 'ISBN: '
until f.eof
  isbn = f.readline.chomp
  isbn.strip!
  num = c.search(isbn)
  puts num
  if num.negative?
    puts 'something wrong'
    next
  elsif num.zero?
    puts 'not found'
    next
  elsif num == 1
    c.select(1)
  else # > 1
    (0..(num - 1)).each do |i|
      print "[#{i + 1}]-------------\n"
      puts c.summary_array[i]
    end
    selnum = 0
    f = IO.console
    loop do
      print 'which?: '
      selnum = f.readline.chomp.to_i
      # p selnum, num
      break if selnum.positive? && (selnum <= num)
    end
    c.select(selnum)
  end

  puts c.title
  puts c.title_yomi
  puts c.vol
  puts c.creator
  puts c.publisher
  puts c.price
  puts c.ext

  print 'ISBN: '
end
