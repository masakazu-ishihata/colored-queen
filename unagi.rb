#!/usr/bin/env ruby
#### board ########################################
@@wd = [["l", "h", "i", "k", "o", "a", "v"],
        ["r", "q", "s", "c", "z", "l", "p"],
        ["u", "w", "a", "l", "n", "f", "o"],
        ["t", "y", "k", "a", "j", "e", "h"],
        ["a", "h", "i", "t", "s", "y", "d"],
        ["e", "f", "o", "p", "t", "x", "n"],
        ["r", "u", "z", "w", "y", "v", "e"]]

#### p --> k & w ####
def k(p)  (p[0]+1)*(p[1]+1)  end
def w(p)  @@wd[p[1]][p[0]]   end

#### show ####
def show_pieces(piece)
  str = piece.sort{|a, b| k(a) <=> k(b)}.map{|p| w(p)}.join("")
  sum = eval(piece.map{|p| k(p)}.join("+"))
  puts "Do you want to eat eel for free?\nMail to #{str}-#{sum}@plusr.co.jp!"
end

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

#### solver ########################################
def solve(q)
  cs = [ q ]
  while (c = cs.pop) != nil          # choose a candidate c
    break if (y = c.next) == c.size  # end if c is a solution
    for x in 0..c.size-1
      cs.push(q) if (q = c.clone.put([[x, y]])).valid?  # add all valid children of c
    end
  end
  c.piece
end

#### main ########################################
show_pieces(solve( MyNqueen.new(7).put([[2, 2], [3, 4]]) ))
