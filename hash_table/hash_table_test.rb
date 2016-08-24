require 'minitest/autorun'
require_relative 'hash_table'

class HashTableTest < MiniTest::Test 
	def setup
		@hash = HashTable.new
		@hash.insert('test', 'value')
	end

	def test_insert_should_insert_new_item
		index = @hash.index_from('test')

		assert_equal [['test', 'value']], @hash.buckets[index]
	end

	def test_should_add_duplicate_to_bucket
		@hash.insert('test', 'different')
		index = @hash.index_from('test')

		assert_equal [['test', 'value'], ['test', 'different']], @hash.buckets[index]
	end

	def test_find
		assert_equal 'value', @hash.find('test')
	end

	def test_find_non_existant
		assert_equal nil, @hash.find('non_existant')
	end

	def test_find_when_multiple_in_bucket
		@hash.stub(:index_from, @hash.index_from('test')) do
			@hash.insert('new_key', 'new_val')

			assert_equal 'new_val', @hash.find('new_key')
		end
	end
end