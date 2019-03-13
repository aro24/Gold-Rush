# require_relative [class name]
require 'minitest/autorun'
require_relative 'game.rb'
require_relative 'checker.rb'
require_relative 'prospector.rb'
require_relative 'node.rb'

# Scoopity woop
class GoldRushTest < Minitest::Test
  # CHECKER TESTS

  # UNIT TESTS FOR METHOD: check_args(args)
  # Equivalence classes:
  # args.count !=2 -> test_invalid_num_args
  # args.count ==2 && all args are ints -> test_valid_num_args
  # args.count ==2 && args contains non-int -> test_invalid_arg_type

  # If the args array count is not 2, return false
  # EDGE CASE
  def test_invalid_num_args
    argue = [1, 2, 3]
    check = Checker.new
    assert_equal check.check_args(argue), false
  end

  # if the args array is 2, return true
  def test_valid_num_args
    argue = [1, 2]
    check = Checker.new
    assert_equal check.check_args(argue), true
  end

  # if the args array contains a non int, return false
  # EDGE CASE
  def test_invalid_arg_type
    argue = %w[hello world]
    check = Checker.new
    assert_equal check.check_args(argue), false
  end

  # PROSPECTOR TESTS

  # tests that gold is added
  def test_add_gold
    testboy = Prospector.new
    assert_equal testboy.add_gold(1), 1
  end

  # tests that silver is added
  def test_add_silver
    testboy = Prospector.new
    assert_equal testboy.add_silver(1), 1
  end

  # tests that correct gold value is returned
  def test_gold
    testboy = Prospector.new
    testboy.add_gold(1)
    assert_equal testboy.gold, 1
  end

  # tests that correct silver value is returned
  def test_silver
    testboy = Prospector.new
    testboy.add_silver(1)
    assert_equal testboy.silver, 1
  end

  # tests that the right haul value is calculated
  def test_get_haul
    testboy = Prospector.new
    testboy.add_silver(3)
    testboy.add_gold(1)
    assert_equal testboy.haul, (20.67 + 1.31 * 3)
  end

  # NODE TESTS

  # tests correct node id is returned
  def test_id
    testnode = Node.new(1, 5, 5)
    assert_equal testnode.id, 1
  end

  # tests maximum gold is correct
  def test_max_gold
    testnode = Node.new(1, 5, 5)
    assert_equal testnode.max_silver, 5
  end

  # tests that maximum silver is correct
  def test_max_silver
    testnode = Node.new(1, 5, 5)
    assert_equal testnode.max_gold, 5
  end

  # tests that the number of neighbors is correct
  def test_num_neighbors
    testnode = Node.new(1, 5, 5)
    assert_equal testnode.num_neighbors, 0
  end

  # tests that node is alone
  def test_alone
    testnode = Node.new(1, 5, 5)
    assert testnode.alone?
  end

  # tests that node is connected
  def test_connected
    testnode = Node.new(1, 5, 5)
    testnode2 = %w[test]
    testnode.add_neighbors testnode2
    assert testnode.connected?
  end

  # tests that neighbor returns the correct neighbor
  def test_neighbor
    testnode = Node.new(1, 5, 5)
    testnodearr = %w[test test2]
    testnode.add_neighbors testnodearr
    assert_equal testnode.neighbor(0), testnodearr[0]
  end

  # Tests that the next_location function is consistent with a seed
  def test_next_location
    testnode = Node.new(1, 5, 5)
    testnodearr = %w[test test2]
    testnode.add_neighbors testnodearr
    testrand = Random.new(1)
    assert_equal testnode.next_location(testrand), testnodearr[1]
  end

  # GAME TESTS

  # tests that a number is returned from random
  def test_rand
    testarr = [1, 2]
    testgame = Game.new(testarr)
    testrando = Random.new(1)
    assert_equal testgame.rand(testrando, 10), 5
  end

  # tests that addmetals adds correct values
  def test_add_metals
    testarr = [1, 2]
    testgame = Game.new(testarr)
    testgame.stub(:initmap, 'Testy time') do
      testboy = Prospector.new
      testgame.addmetals(testboy, 1, 3)
      assert_equal testboy.gold, 1
      assert_equal testboy.silver, 3
    end
  end

  # tests that sutter creek in location hash match up
  def test_initmap
    testarr = [1, 2]
    testgame = Game.new(testarr)
    hash = testgame.initmap
    assert_equal hash['Sutter Creek'].id, 'Sutter Creek'
  end

  # tests that the starting print statment is correct
  def test_print_start
    testarr = [1, 2]
    testgame = Game.new(testarr)
    testgame.stub(:initmap, 'Testy time') do
      assert_output(/\nProspector 1 starting in Sutter Creek./) { testgame.print_start(0) }
    end
  end

  # UNIT TESTS FOR METHOD: print_round
  # Equivalence classes:
  # gold=1 && silver =1 -> test_print_round_singulars
  # gold=1 && silver >1 -> test_print_round_sing_plur
  # gold>1 && silver =1 -> test_print_round_plur_sing
  # gold>1 && silver >1 -> test_print_round_plurals
  # gold<1 && silver =1 -> test_print_round_missing_gold_sing
  # gold=1 && silver <1 -> test_print_round_missing_silver_sing
  # gold<1 && silver >1 -> test_print_round_missing_gold_plur
  # gold>1 && silver <1 -> test_print_round_missing_silver_plur
  # gold<1 && silver <1 -> test_print_round_none

  # if gold && silver == 1, print ounce
  def test_print_round_singluars
    testarr = [1, 2]
    testgame = Game.new(testarr)

    testloc = 'Sutter Creek'
    str = testgame.print_round(1, 1, testloc)
    assert_equal "\tFound 1 ounce of gold and 1 ounce of silver in Sutter Creek.", str
  end

  # if gold ==1 && silver > 1, print ounce, then ounces
  def test_print_round_sing_plur
    testarr = [1, 2]
    testgame = Game.new(testarr)
    testloc = 'Sutter Creek'
    str = testgame.print_round(1, 2, testloc)
    assert_equal "\tFound 1 ounce of gold and 2 ounces of silver in Sutter Creek.", str
  end

  # if gold >1 && silver == 1, print ounces, then ounce
  def test_print_round_plur_sing
    testarr = [1, 2]
    testgame = Game.new(testarr)
    testloc = 'Sutter Creek'
    str = testgame.print_round(2, 1, testloc)
    assert_equal "\tFound 2 ounces of gold and 1 ounce of silver in Sutter Creek.", str
  end

  # if gold && silver >1, print ounces
  def test_print_round_plurals
    testarr = [1, 2]
    testgame = Game.new(testarr)

    testloc = 'Sutter Creek'
    str = testgame.print_round(2, 2, testloc)
    assert_equal "\tFound 2 ounces of gold and 2 ounces of silver in Sutter Creek.", str
  end

  # if gold == 0 && silver ==1, print only silver with ounce
  def test_print_round_missing_gold_sing
    testarr = [1, 2]
    testgame = Game.new(testarr)

    testloc = 'Sutter Creek'
    str = testgame.print_round(0, 1, testloc)
    assert_equal "\tFound 1 ounce of silver in Sutter Creek.", str
  end

  # if gold == 1 && silver ==0, print only gold with ounce
  def test_print_round_missing_silver_sing
    testarr = [1, 2]
    testgame = Game.new(testarr)

    testloc = 'Sutter Creek'
    str = testgame.print_round(1, 0, testloc)
    assert_equal "\tFound 1 ounce of gold in Sutter Creek.", str
  end

  # if gold == 0 && silver >1, print only silver with ounces
  def test_print_round_missing_gold_plur
    testarr = [1, 2]
    testgame = Game.new(testarr)

    testloc = 'Sutter Creek'
    str = testgame.print_round(0, 2, testloc)
    assert_equal "\tFound 2 ounces of silver in Sutter Creek.", str
  end

  # if gold > 1 && silver ==0, print only gold with ounces
  def test_print_round_missing_silver_plur
    testarr = [1, 2]
    testgame = Game.new(testarr)

    testloc = 'Sutter Creek'
    str = testgame.print_round(2, 0, testloc)
    assert_equal "\tFound 2 ounces of gold in Sutter Creek.", str
  end

  # if gold && silver ==0, print that no precious metals were found
  def test_print_round_none
    testarr = [1, 2]
    testgame = Game.new(testarr)

    testloc = 'Sutter Creek'
    str = testgame.print_round(0, 0, testloc)
    assert_equal "\tNo precious metals found in Sutter Creek.", str
  end

  # UNIT TESTS FOR METHOD: print_move
  # Equivalence classes:
  # gold=1 && silver =1 -> test_print_move_singulars
  # gold=1 && silver >1 -> test_print_move_sing_plur
  # gold>1 && silver =1 -> test_print_move_plur_sing
  # gold>1 && silver >1 -> test_print_move_plurals

  # if gold && silver ==1, print ounce twice
  # EDGE CASE
  def test_print_move_singulars
    testarr = [1, 2]
    testgame = Game.new(testarr)
    testgame.stub(:initmap, 'Testy time') do
      testloc = 'Sutter Creek'
      testloc2 = 'Coloma'
      str = testgame.print_move(1, 1, testloc, testloc2)
      assert_equal 'Heading from Sutter Creek to Coloma, holding 1 ounce of gold and 1 ounce of silver.', str
    end
  end

  # if gold==1 && silver!=1, print ounce, then ounces
  def test_print_move_sing_plur
    testarr = [1, 2]
    testgame = Game.new(testarr)
    testgame.stub(:initmap, 'Testy time') do
      testloc = 'Sutter Creek'
      testloc2 = 'Coloma'
      str = testgame.print_move(1, 2, testloc, testloc2)
      assert_equal 'Heading from Sutter Creek to Coloma, holding 1 ounce of gold and 2 ounces of silver.', str
    end
  end

  # if gold!=1 && silver ==1, print ounces, then ounce
  def test_print_move_plur_sing
    testarr = [1, 2]
    testgame = Game.new(testarr)
    testgame.stub(:initmap, 'Testy time') do
      testloc = 'Sutter Creek'
      testloc2 = 'Coloma'
      str = testgame.print_move(2, 1, testloc, testloc2)
      assert_equal 'Heading from Sutter Creek to Coloma, holding 2 ounces of gold and 1 ounce of silver.', str
    end
  end

  # if gold && silver !=0, print ounces
  def test_print_move_plurals
    testarr = [1, 2]
    testgame = Game.new(testarr)
    testgame.stub(:initmap, 'Testy time') do
      testloc = 'Sutter Creek'
      testloc2 = 'Coloma'
      str = testgame.print_move(2, 2, testloc, testloc2)
      assert_equal 'Heading from Sutter Creek to Coloma, holding 2 ounces of gold and 2 ounces of silver.', str
    end
  end

  # UNIT TESTS FOR METHOD: print_move
  # Equivalence classes:
  # gold=1 && silver =1 -> test_print_final_singulars
  # gold=1 && silver >1 -> test_print_final_sing_plur
  # gold>1 && silver =1 -> test_print_final_plur_sing
  # gold>1 && silver >1 -> test_print_final_plurals

  # if gold && silver !=1, print ounces
  def test_print_final_plurals
    testarr = [1, 2]
    testgame = Game.new(testarr)
    mockboy = Minitest::Mock.new('Mock Prospector')
    def mockboy.haul
      0
    end
    teststr = "After 5 days, Prospector #1 returned to San Francisco with:\n"
    teststr += "\t0 ounces of gold.\n\t0 ounces of silver.\n\tHeading home with $0"
    str = testgame.print_final(5, 1, mockboy, 0, 0)
    assert_equal str, teststr
  end

  # if gold ==1 && silver !=1, print ounce, then ounces
  def test_print_final_sing_plur
    testarr = [1, 2]
    testgame = Game.new(testarr)
    mockboy = Minitest::Mock.new('Mock Prospector')
    def mockboy.haul
      0
    end
    teststr = "After 5 days, Prospector #1 returned to San Francisco with:\n"
    teststr += "\t1 ounce of gold.\n\t0 ounces of silver.\n\tHeading home with $0"
    str = testgame.print_final(5, 1, mockboy, 1, 0)
    assert_equal str, teststr
  end

  # if gold !=1 && silver ==1, print ounces, then ounce
  def test_print_final_plur_sing
    testarr = [1, 2]
    testgame = Game.new(testarr)
    mockboy = Minitest::Mock.new('Mock Prospector')
    def mockboy.haul
      0
    end
    teststr = "After 5 days, Prospector #1 returned to San Francisco with:\n"
    teststr += "\t0 ounces of gold.\n\t1 ounce of silver.\n\tHeading home with $0"
    str = testgame.print_final(5, 1, mockboy, 0, 1)
    assert_equal str, teststr
  end

  # if gold && silver ==1, print ounce
  # EDGE CASE
  def test_print_final_singulars
    testarr = [1, 2]
    testgame = Game.new(testarr)
    mockboy = Minitest::Mock.new('Mock Prospector')
    def mockboy.haul
      0
    end
    teststr = "After 5 days, Prospector #1 returned to San Francisco with:\n"
    teststr += "\t1 ounce of gold.\n\t1 ounce of silver.\n\tHeading home with $0"
    str = testgame.print_final(5, 1, mockboy, 1, 1)
    assert_equal str, teststr
  end
end
