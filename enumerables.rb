# rubocop:disable Metrics/PerceivedComplexity,Metrics/CyclomaticComplexity,Metrics/ModuleLength
module Enumerable
  #---------- my_each method ---------------------------

  def my_each
    return to_enum(:my_each) unless block_given?

    n = Array(self).length
    i = 0
    # You can use the times method insted while
    while i < n
      yield(Array(self)[i])
      i += 1
    end
    self
  end

  #---------- my_each_with_index method ----------------

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    n = Array(self).length
    i = 0
    # You can use the times method insted while
    while i < n
      yield(Array(self)[i], i)
      i += 1
    end
    self
  end

  #---------- my_select method --------------------------

  def my_select
    return to_enum(:my_select) unless block_given?

    result = []
    Array(self).my_each do |i|
      next unless yield(i)

      result.push(i)
    end
    result
  end

  #---------- my_all method ------------------------------

  def my_all?(*args)
    if args.empty?
      if block_given?
        my_each { |i| return false unless yield(i) }
      else
        my_each { |i| return false unless i }
      end
    else
      raise ArgumentError, 'Too many arguments, Expected 1!' if args.length > 1

      puts 'Warning: given block not used' if block_given?

      if args[0].is_a?(Class)
        my_each { |i| return false unless i.is_a?(args[0]) }
      elsif args[0].is_a?(Regexp)
        my_each { |i| return false unless i.match(args[0]) }
      else
        my_each { |i| return false unless i == args[0] }
      end
    end
    true
  end

  #---------- my_any method ------------------------------

  def my_any?(*arg)
    if arg.empty?
      if block_given?
        my_each { |i| return true if yield(i) == true }
      else
        my_each { |i| return true if i == true }
      end
    else
      raise ArgumentError, 'Too many arguments, Expected 1!' if arg.length > 1

      puts 'Warning: given block not used' if block_given?

      if arg[0].is_a?(Class)
        my_each { |i| return true if i.is_a?(arg[0]) }
      elsif arg[0].is_a?(Regexp)
        my_each { |i| return true if i.match(arg[0]) }
      else
        my_each { |i| return true if i == arg[0] }
      end
    end
    false
  end

  #----------- my_none method --------------------------------

  def my_none?(*arg)
    if arg.empty?
      if block_given?
        my_each { |i| return false if yield(i) == true }
      else
        my_each { |i| return false if i == true }
      end
    else
      raise ArgumentError, 'Too many arguments, Expected 1!' if arg.length > 1

      puts 'Warning: given block not used' if block_given?

      if arg[0].is_a?(Class)
        my_each { |i| return false if i.is_a?(arg[0]) }
      elsif arg[0].is_a?(Regexp)
        my_each { |i| return false if i.match(arg[0]) }
      else
        my_each { |i| return false if i == arg[0] }
      end
    end
    true
  end

  #---------- my_count method ------------------------------

  def my_count(*args)
    count = 0
    if args.empty?
      if block_given?
        my_each { |i| count += 1 if yield(i) }
      else
        my_each { |_i| count += 1 }
      end
    else
      raise ArgumentError, 'Too many arguments, Expected 1!' if args.length > 1

      puts 'Warning: given block not used' if block_given?

      my_each { |i| count += 1 if i == args[0] }
    end
    count
  end

  #---------- my_map method ------------------------------

  def my_map(arg = nil)
    result = []
    if arg.is_a?(Proc)
      my_each do |i|
        result.push(arg.call(i))
      end
      return result
    end
    return to_enum(:my_map) unless block_given?

    my_each { |i| result.push(yield(i)) }
    result
  end

  #------------ my_inject -----------------------------

  def my_inject(*arg)
    raise LocalJumpError, 'NO BLOCK OR ARGUMENT GIVEN!' if !block_given? && arg.empty?

    validator = false
    counter = Array(self)[0]
    if (arg[0].class == Symbol) || arg[0].nil?
      validator = true
    elsif arg[0].is_a?(Numeric)
      counter = arg[0]
    end
    Array(self).my_each_with_index do |i, idx|
      next if validator && idx.zero?

      if block_given?
        counter = yield(counter, i)
      elsif arg[0].class == Symbol
        counter = counter.send(arg[0], i)
      elsif arg[0].is_a?(Numeric)
        counter = counter.send(arg[1], i)
      end
    end
    counter
  end
end
# rubocop:enable Metrics/PerceivedComplexity,Metrics/CyclomaticComplexity,Metrics/ModuleLength

def multiply_els(arr)
  arr.my_inject(:*)
end
