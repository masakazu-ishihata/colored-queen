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

#### N-queen ########################################
class MyNqueen
  #### new ####
  def initialize(size)
    @size  = size
    @piece = Array.new
  end

  #### accessors %%%%
  attr_reader :size, :piece

  #### put pieces (not a piece) ####
  def put(ps)
    @piece += ps
    self
  end

  #### clone ####
  def clone
    MyNqueen.new(@size).put(@piece)
  end

  #### next ####
  def next
    ary = Array.new(@size){|i| 0}
    @piece.each{|p| ary[p[1]] = 1}
    for y in 0..@size-1
      return y if ary[y] == 0
    end
    return @size
  end

  #### valid? ####
  def valid?
    n = Array.new(2){|i| Array.new(@size){|j| 0}     } # x, y
    m = Array.new(2){|i| Array.new(2*@size-1){|j| 0} } # right & left skew
    @piece.each do |x, y|
      return false if (n[0][x] += 1) > 1
      return false if (n[1][y] += 1) > 1
      return false if (m[0][x + y] += 1) > 1
      return false if (m[1][x - y + @size - 1] += 1) > 1
    end
    return true
  end
end

#### N queen solver ########################################
def solve_nqueen(n)
  cs = [ MyNqueen.new(n) ]     # candidates of solutions for n-queen
  ss = []                      # solutions for n-queen
  while (c = cs.pop) != nil
    if (y = c.next) == c.size  # end if c is a solution
      ss.push(c.piece.sort)
    else
      for x in 0..c.size-1
        q = c.clone.put([[x, y]])
        cs.push(q) if q.valid?  # add all valid children of c
      end
    end
  end
  ss
end

#### N colored queen solver ########################################
def solve_ncqueen(n)
  ss = solve_nqueen(n)         # solutions of n-queen
  ssi = Array.new(n){|i| [] }  # solutions which includes [0, i]
  ns = ss.size                 # # solutions
  cs = Array.new               # candidates of solutions for n-colored-queen

  # initialize ssi
  ss.each do |s|
    ssi[s[0][1]].push(s)
  end

  prd = 1
  for i in 0..n-1
    prd *= ssi[i].size
  end
  puts "# #{n}-queen  solutions  = #{ns}"
  puts "# #{n}-cqueen candidates = #{prd}"

  # initialize cs
  for i in 0..ssi[0].size-1
    cs.push([ [i], ssi[0][i] ])
  end

  # depth first search
  while (c = cs.pop) != nil
    sol = c[0]   # solution
    pie = c[1]   # pieces
    i = sol.size # next index

    break if i == n # c is a solution

    # add c's valid children to cs
    for j in 0..ssi[i].size-1
      nsol = sol + [j]                # next solution
      npie = (pie + ssi[i][j]).uniq   # next pieces
      cs.push([nsol, npie]) if npie.size == n*(i+1)
    end
  end

  # solution
  s = []
  if c != nil
    for i in 0..n-1
      s.push(ssi[i][ c[0][i] ])
    end
  end
  s
end

#### main ########################################
puts "Solve #{@n}-colored-queen problem"
solve_ncqueen(@n).each do |s|
  p s
end
