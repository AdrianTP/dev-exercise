### Array extension

# Please write a module that gives `where` behavior to an array of hashes. (See
# `test.rb` and make it pass, or feel free to convert the tests to your favorite
# test framework.)

require 'minitest/autorun'

module ArrayWhere
  def where(criteria)
    self.select do |h|
      match = true

      criteria.each do |k, v|
        case k
        when :name, :rank
          match = match && h[k] == v
        when :title, :quote
          match = match && (h[k] =~ v) != nil
        else
          match = false
        end
      end

      match
    end
  end

  # alternate solution
  # def where(criteria)
  #   collection = self
  #   criteria.each do |k, v|
  #     collection = collection.select do |h|
  #       case k
  #       when :name, :rank
  #         h[k] == v
  #       when :title, :quote
  #         (h[k] =~ v) != nil
  #       end
  #     end
  #   end
  #   collection
  # end
end

class Array
  include ArrayWhere
end

class WhereTest < Minitest::Test
  def setup
    @boris   = {:name => 'Boris The Blade', :quote => "Heavy is good. Heavy is reliable. If it doesn't work you can always hit them.", :title => 'Snatch', :rank => 4}
    @charles = {:name => 'Charles De Mar', :quote => 'Go that way, really fast. If something gets in your way, turn.', :title => 'Better Off Dead', :rank => 3}
    @wolf    = {:name => 'The Wolf', :quote => 'I think fast, I talk fast and I need you guys to act fast if you wanna get out of this', :title => 'Pulp Fiction', :rank => 4}
    @glen    = {:name => 'Glengarry Glen Ross', :quote => "Put. That coffee. Down. Coffee is for closers only.",  :title => "Blake", :rank => 5}

    @fixtures = [@boris, @charles, @wolf, @glen]
  end

  def test_where_with_exact_match
    assert_equal [@wolf], @fixtures.where(:name => 'The Wolf')
  end

  def test_where_with_partial_match
    assert_equal [@charles, @glen], @fixtures.where(:title => /^B.*/)
  end

  def test_where_with_mutliple_exact_results
    assert_equal [@boris, @wolf], @fixtures.where(:rank => 4)
  end

  def test_with_with_multiple_criteria
    assert_equal [@wolf], @fixtures.where(:rank => 4, :quote => /get/)
  end

  def test_with_chain_calls
    assert_equal [@charles], @fixtures.where(:quote => /if/i).where(:rank => 3)
  end
end

