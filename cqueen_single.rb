#!/usr/bin/env ruby
@n = 5

#### Arguments ########################################
require "optparse"
OptionParser.new { |opts|
  # options
  opts.on("-h","--help","Show this message") {
    puts opts
    exit
  }
  opts.on("-n [int]"){ |f|
    @n = f.to_i
  }
  # parse
  opts.parse!(ARGV)
}

#### solve ########################################
def solve(n)
  ss = [ [Array.new(n){|i| i}] ]
  num = 0

  while (s = ss.pop) != nil
    num += 1
    return s if s.size == n && s[n-1].size == n
    get_children(s).each do |c|
      cs = get_child(s, c)
      ss.push(cs)
    end
  end
  p num
  return []
end

def get_children(s)
  mx = s[0].size
  my = s.size - 1

  cs = Array.new(mx){|i| i} # colors

  # get x & y
  x = s[my].size % mx
  y = my
  y = my + 1 if x == 0

  # draw y
  cs -= s[my] if x > 0

  # draw x
  for _y in 0..y-1
    cs -= [ s[_y][x] ]
  end

  # draw skew
  for i in 1..y
    cs -= [ s[y-i][x-i] ] if x-i >= 0
    cs -= [ s[y-i][x+i] ] if x+i < mx
  end

  cs
end

#### get a child of s by adding c ########################################
def get_child(s, c)
  # clone
  cld = []
  s.each do |line|
    cld.push(line.clone)
  end

  # mx & my
  mx = s[0].size
  my = s.size

  # add new line if needed
  cld.push([]) if cld[my-1].size == mx

  # add c to the tail
  my = cld.size
  cld[my-1].push(c)

  cld
end

#### show ########################################
def show(s)
  s.each do |line|
    p line
  end
end

#### main ########################################
show(solve(@n))
